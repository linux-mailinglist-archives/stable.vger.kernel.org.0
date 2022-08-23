Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D663B59E079
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354235AbiHWKZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353094AbiHWKTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:19:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7EC81681;
        Tue, 23 Aug 2022 02:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9732961530;
        Tue, 23 Aug 2022 09:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83142C433C1;
        Tue, 23 Aug 2022 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245320;
        bh=1vOJ0DEcTcdeZLSQo67LaoUD2bS9OW4W8on2CZ1dDuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pD0tv3tlrNDlhv3SlJ79wpmsTiNJVd3A0UtamWQDX0lV9N1Xkiv/HI/jIoq2GsEKB
         V8lgo3qEcpa06vXwznbrXlvdbKkqB3szEjahOX0akTO4a2u+BFQr351YXkoSw4rUpa
         LPirj9CKLsrAJX3cAtJ6Ym5K2uMFk5WAGHchkrFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4.19 011/287] KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
Date:   Tue, 23 Aug 2022 10:23:00 +0200
Message-Id: <20220823080100.654882034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -1745,8 +1745,8 @@ static int __load_segment_descriptor(str
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
-				((u64)base3 << 32), ctxt))
-			return emulate_gp(ctxt, 0);
+						 ((u64)base3 << 32), ctxt))
+			return emulate_gp(ctxt, err_code);
 	}
 
 	if (seg == VCPU_SREG_TR) {


