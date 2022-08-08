Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238B858CE3F
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244183AbiHHTDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 15:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244180AbiHHTDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 15:03:54 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EF81902D
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 12:03:52 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l9so5373934ilq.1
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DfkYWLinzITcd/FJI51hf3bH49wjjl87W/fTyl+XXYA=;
        b=G6S5GsbMlO7CxtxLLHVMTvL+xcHqdBOWo6ahIsrJb7qp/OIm8X+nywOXbxQXbdqGAO
         zv1j2qowAFGNSTP3/yPEcaHh9IVsfC8bm5ZO5rnQwP3xWVmjgHDrm7KuMLohyFhH+roM
         mLmP48oyaiXIBsXar236LXTyS2XwzJxvUVfMzpktq6QKPBNWJe6ncWWWBNaEJR/uw25+
         zspy0I6ZVefcEHO4jc2LLbFqtaSBrHzkhW5PZinEA+/GTysWg6VnkJDw6BPm87yvJ2LP
         7CTUtXXBsBRuvQEd/p9aY1CYJUT1kzzMjFS8LuXBu7LZ6trO1a3iqzuRVgR5AQq8iTdd
         FWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DfkYWLinzITcd/FJI51hf3bH49wjjl87W/fTyl+XXYA=;
        b=Oj+gxmBvWWW/3z4sP1WO6YxhU4B6glFLhK/w62SaETqw6EewF5hz5sC8MAaCQVzD8n
         A5Hk1NbRBiwVFmJgD+wEY4FKBBvMHQ08dADXNzT0gn8QFOsh6maN4RyjbKTNohFULSQD
         TiDTU/WW0RiRAlT4/wpfle/wlmL4xyFkqDLX6cZgkHla28oR9iBj0dM0PIwlnWBqDzgH
         0dNgJIoxwFLKX/FYaw+lzVhcdh6m/5FS4Hn2/q9pawLtRhOcwsfsVAToumke5yaSUiuI
         47JZ1ycVxRK6wJuxkHAzqiuET6jq3AaZdi6zxT5Wmkk6aNVT5r7gXcsVYXDQe6GoBE9c
         RxGw==
X-Gm-Message-State: ACgBeo3rZ7wQRjApyC66W+URTfhU8d9gh1iAGdp8nXNRzhhL0DtgxTJ8
        ONRuiV8ZGV72qLNYcUaNIDZtgw==
X-Google-Smtp-Source: AA6agR5RXKeN6Pr+tax9ZL1jAO/mRGtORZEn6sbDJeBHTyBlqpMEZATCOqAGHkk3ePrCB4CEk6kSDQ==
X-Received: by 2002:a05:6e02:15c4:b0:2d7:aa1e:5b55 with SMTP id q4-20020a056e0215c400b002d7aa1e5b55mr8904925ilu.120.1659985432381;
        Mon, 08 Aug 2022 12:03:52 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id e17-20020a921e11000000b002dd0becf37fsm183086ile.53.2022.08.08.12.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 12:03:52 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     dietschc@csp.edu
Cc:     stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: [PATCH v3 1/2] KVM: x86/xen: Initialize Xen timer only once
Date:   Mon,  8 Aug 2022 14:02:11 -0500
Message-Id: <20220808190211.323827-2-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808190211.323827-1-dietschc@csp.edu>
References: <20220808190211.323827-1-dietschc@csp.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a check for existing xen timers before initializing a new one.

Currently kvm_xen_init_timer() is called on every
KVM_XEN_VCPU_ATTR_TYPE_TIMER, which is causing the following ODEBUG
crash when vcpu->arch.xen.timer is already set.

ODEBUG: init active (active state 0)
object type: hrtimer hint: xen_timer_callbac0
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Call Trace:
__debug_object_init
debug_hrtimer_init
debug_init
hrtimer_init
kvm_xen_init_timer
kvm_xen_vcpu_set_attr
kvm_arch_vcpu_ioctl
kvm_vcpu_ioctl
vfs_ioctl

Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
Cc: stable@vger.kernel.org
Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
---
 arch/x86/kvm/xen.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a0c05ccbf4b1..6e554041e862 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -713,7 +713,9 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 				break;
 			}
 			vcpu->arch.xen.timer_virq = data->u.timer.port;
-			kvm_xen_init_timer(vcpu);
+
+			if (!vcpu->arch.xen.timer.function)
+				kvm_xen_init_timer(vcpu);
 
 			/* Restart the timer if it's set */
 			if (data->u.timer.expires_ns)
-- 
2.34.1

