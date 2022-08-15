Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6065594309
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348297AbiHOV46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348137AbiHOVyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:54:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA9A108F9C;
        Mon, 15 Aug 2022 12:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDA26113B;
        Mon, 15 Aug 2022 19:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B52FC433D7;
        Mon, 15 Aug 2022 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592011;
        bh=VaPQ+O2Fw42bwODM7MNZEwPN+DIlDmoE8rDjqD4UN/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWdQZJR87KSZfmBn8VQ8a10XyQOE/+wzxPU8A2XeXTFvkqG2LQUTMEyhd5+v956HK
         xmir1SIxVzTCvNVPn5iRNLLvBWvjLIlwAO3EqaHrLfwro78qZfSabnq/DaLpjHpuam
         spsWwDkl6lDP3CbQ9W6c0wEhw56uHgDtoIzwvnDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com,
        Coleman Dietsch <dietschc@csp.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0044/1157] KVM: x86/xen: Initialize Xen timer only once
Date:   Mon, 15 Aug 2022 19:50:00 +0200
Message-Id: <20220815180441.206951782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Coleman Dietsch <dietschc@csp.edu>

commit af735db31285fa699384c649be72a9f32ecbb665 upstream.

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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220808190607.323899-2-dietschc@csp.edu>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -713,7 +713,9 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 			vcpu->arch.xen.timer_virq = data->u.timer.port;
-			kvm_xen_init_timer(vcpu);
+
+			if (!vcpu->arch.xen.timer.function)
+				kvm_xen_init_timer(vcpu);
 
 			/* Restart the timer if it's set */
 			if (data->u.timer.expires_ns)


