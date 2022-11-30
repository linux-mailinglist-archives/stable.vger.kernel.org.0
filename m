Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC763E010
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiK3SxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiK3SxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E03275DE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C721B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC80C433C1;
        Wed, 30 Nov 2022 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834380;
        bh=/7nNmNLkVrG6cnl4XZM4dyEmfIA/rHGBXc7NZRApXoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwIm0LY+LrgX5CHkqhjNrQHHPSIpVjaVOIZMfAr6MTfII1qIuST7ljX98OCLOxr9u
         1KyOlY7dMUxgCEj7KPaS6JRhWuwRDzOPLjk+9NCId+x2O+4rqI2wgLAUFypmnW+aYX
         yKAz5KMVRDS1yPqf0IvAMlMZKSVfJyiRrt5gCXWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>, stable@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 205/289] KVM: x86/xen: Validate port number in SCHEDOP_poll
Date:   Wed, 30 Nov 2022 19:23:10 +0100
Message-Id: <20221130180548.767960200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit 4ea9439fd537313f3381f0af4ebbf05e3f51a58c upstream.

We shouldn't allow guests to poll on arbitrary port numbers off the end
of the event channel table.

Fixes: 1a65105a5aba ("KVM: x86/xen: handle PV spinlocks slowpath")
[dwmw2: my bug though; the original version did check the validity as a
 side-effect of an idr_find() which I ripped out in refactoring.]
Reported-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: stable@kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -954,6 +954,14 @@ static int kvm_xen_hypercall_complete_us
 	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
 }
 
+static inline int max_evtchn_port(struct kvm *kvm)
+{
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+		return EVTCHN_2L_NR_CHANNELS;
+	else
+		return COMPAT_EVTCHN_2L_NR_CHANNELS;
+}
+
 static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 			       evtchn_port_t *ports)
 {
@@ -1042,6 +1050,10 @@ static bool kvm_xen_schedop_poll(struct
 			*r = -EFAULT;
 			goto out;
 		}
+		if (ports[i] >= max_evtchn_port(vcpu->kvm)) {
+			*r = -EINVAL;
+			goto out;
+		}
 	}
 
 	if (sched_poll.nr_ports == 1)
@@ -1308,14 +1320,6 @@ handle_in_userspace:
 	return 0;
 }
 
-static inline int max_evtchn_port(struct kvm *kvm)
-{
-	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
-		return EVTCHN_2L_NR_CHANNELS;
-	else
-		return COMPAT_EVTCHN_2L_NR_CHANNELS;
-}
-
 static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
 {
 	int poll_evtchn = vcpu->arch.xen.poll_evtchn;


