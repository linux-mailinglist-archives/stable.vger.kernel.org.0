Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1B957EE5D
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbiGWKJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbiGWKJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6BCB744;
        Sat, 23 Jul 2022 03:02:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A69476125F;
        Sat, 23 Jul 2022 10:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4257C341C7;
        Sat, 23 Jul 2022 10:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570542;
        bh=ogXzme9Nd+4tRHQ/niqYL5axx8kpl4DBKD2E0Na7Ndo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKRghvFw8iBx8dE2MMGfD5wlnyqcJ+UnhBKQX3i0NTDuxBVqYFGdBIXPYaq7YZqdN
         28RPNcLJiG0uCYGUtPCdtE/M8UoESaFCBF0DEpjMuziEaJ37nUOZWAFFw4GzMM6LVl
         vJx7ZrYw4qlE+E5Oou8ijY48T3rtGZ4Ilfhh7Ye0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 133/148] x86/xen: Fix initialisation in hypercall_page after rethunk
Date:   Sat, 23 Jul 2022 11:55:45 +0200
Message-Id: <20220723095301.607582870@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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


