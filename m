Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188E959D859
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349551AbiHWJ1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350215AbiHWJZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69D6760F9;
        Tue, 23 Aug 2022 01:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A191361475;
        Tue, 23 Aug 2022 08:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8502C433D6;
        Tue, 23 Aug 2022 08:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243779;
        bh=eicEbu+IdcK/sMPONUo+LG9V3CoqePHys2TFpekNiR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAmHfIKlN+hmLTA7s2waLF0raWlOmmrKaNDbMnNaKal7012WQQ1WlbNBQb2Hnmwai
         5+QIW960TPTXAQzLDCOTusxaClVua7OXVel+Mz7243j+vzCuPQ4s7z89wWmzklPtX3
         z/cWl3loHutGy4Ej1ArmHhyw3EEx41vQh0YrqXpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4.14 019/229] KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
Date:   Tue, 23 Aug 2022 10:23:00 +0200
Message-Id: <20220823080054.129802752@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

commit ec6e4d863258d4bfb36d48d5e3ef68140234d688 upstream.

Wait to mark the TSS as busy during LTR emulation until after all fault
checks for the LTR have passed.  Specifically, don't mark the TSS busy if
the new TSS base is non-canonical.

Opportunistically drop the one-off !seg_desc.PRESENT check for TR as the
only reason for the early check was to avoid marking a !PRESENT TSS as
busy, i.e. the common !PRESENT is now done before setting the busy bit.

Fixes: e37a75a13cda ("KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR")
Reported-by: syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220711232750.1092012-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1721,16 +1721,6 @@ static int __load_segment_descriptor(str
 	case VCPU_SREG_TR:
 		if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
 			goto exception;
-		if (!seg_desc.p) {
-			err_vec = NP_VECTOR;
-			goto exception;
-		}
-		old_desc = seg_desc;
-		seg_desc.type |= 2; /* busy */
-		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
-						  sizeof(seg_desc), &ctxt->exception);
-		if (ret != X86EMUL_CONTINUE)
-			return ret;
 		break;
 	case VCPU_SREG_LDTR:
 		if (seg_desc.s || seg_desc.type != 2)
@@ -1771,6 +1761,15 @@ static int __load_segment_descriptor(str
 				((u64)base3 << 32), ctxt))
 			return emulate_gp(ctxt, 0);
 	}
+
+	if (seg == VCPU_SREG_TR) {
+		old_desc = seg_desc;
+		seg_desc.type |= 2; /* busy */
+		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
+						  sizeof(seg_desc), &ctxt->exception);
+		if (ret != X86EMUL_CONTINUE)
+			return ret;
+	}
 load:
 	ctxt->ops->set_segment(ctxt, selector, &seg_desc, base3, seg);
 	if (desc)


