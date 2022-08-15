Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4133D593B08
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbiHOUJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345858AbiHOUJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486AC48CB3;
        Mon, 15 Aug 2022 11:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F9BC6123D;
        Mon, 15 Aug 2022 18:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BDBC433D6;
        Mon, 15 Aug 2022 18:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589750;
        bh=97zjYBB23BfRBu0CCZkuOZde815VbzM7pC1v+wXwUcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lt+a6b3Z+vwqaw3z2UduD6NZH4NcIrmEACAy8uUvzckYcuuuVo+6g3CY9j/e36I5T
         aTVEksEdlGiss1xJyg8GUOd333XjET/zSnB19Y7Oj//9SLyE8hirZ1y9yFKKA43r59
         uKqlSOS1y5N6NX53Z8q2SrU9YvBbJqgCytbO9/0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5.18 0037/1095] KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
Date:   Mon, 15 Aug 2022 19:50:36 +0200
Message-Id: <20220815180430.925274525@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2626206963ace9e8bf92b6eea5ff78dd674c555c upstream.

When injecting a #GP on LLDT/LTR due to a non-canonical LDT/TSS base, set
the error code to the selector.  Intel SDM's says nothing about the #GP,
but AMD's APM explicitly states that both LLDT and LTR set the error code
to the selector, not zero.

Note, a non-canonical memory operand on LLDT/LTR does generate a #GP(0),
but the KVM code in question is specific to the base from the descriptor.

Fixes: e37a75a13cda ("KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220711232750.1092012-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1724,8 +1724,8 @@ static int __load_segment_descriptor(str
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
-				((u64)base3 << 32), ctxt))
-			return emulate_gp(ctxt, 0);
+						 ((u64)base3 << 32), ctxt))
+			return emulate_gp(ctxt, err_code);
 	}
 
 	if (seg == VCPU_SREG_TR) {


