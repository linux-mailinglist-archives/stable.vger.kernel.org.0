Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C3857DEB0
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbiGVJ3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbiGVJ32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FACCFE60;
        Fri, 22 Jul 2022 02:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C8061FFE;
        Fri, 22 Jul 2022 09:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56944C341C6;
        Fri, 22 Jul 2022 09:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481514;
        bh=ogXzme9Nd+4tRHQ/niqYL5axx8kpl4DBKD2E0Na7Ndo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBwlBR95nRPTckAgYHfbRLIme5JRKIRue1VWL+Uym3Ie6kkQEA1kv6g/SrJUqVyPV
         O3HeF+l4Up7jSX64pyuWVxKmRUYCj0MDW2cR37g3YNhJFTxtl2qpMAzYzvpU9qcV4C
         WeGyedTRTiGgCuOnT/t6is25OmMM1S+qp+Qn3G3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.15 79/89] x86/xen: Fix initialisation in hypercall_page after rethunk
Date:   Fri, 22 Jul 2022 11:11:53 +0200
Message-Id: <20220722091137.764504078@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

The hypercall_page is special and the RETs there should not be changed
into rethunk calls (but can have SLS mitigation).  Change the initial
instructions to ret + int3 padding, as was done in upstream commit
5b2fc51576ef "x86/ibt,xen: Sprinkle the ENDBR".

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/xen-head.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -69,9 +69,9 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
 SYM_CODE_START(hypercall_page)
 	.rept (PAGE_SIZE / 32)
 		UNWIND_HINT_FUNC
-		.skip 31, 0x90
 		ANNOTATE_UNRET_SAFE
-		RET
+		ret
+		.skip 31, 0xcc
 	.endr
 
 #define HYPERCALL(n) \


