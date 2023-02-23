Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7DE6A09B2
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjBWNJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbjBWNJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907983A80
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34607B81A1F
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F96C433D2;
        Thu, 23 Feb 2023 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157750;
        bh=wfyFCpqiKvgyqUXkHezD0XTK9T5ZtswDbi1NAjImbeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zO1k2V3njZqfpt9zXXNK9+emiu5cVsTb30DtgoSsy3yRfnB47lteIe4a7Fvoqjf+r
         PcSkzeKLtFIvaJ3RG+TD/C94smK7eQ68Gs/SrYDi3M9z9c93IzjU7G435QYNgkNhjN
         MPiSw0AEsmyxXvN6uGXSjenMFGbjaYwYp+2qtbWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/46] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
Date:   Thu, 23 Feb 2023 14:06:31 +0100
Message-Id: <20230223130432.693114154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit a79b53aaaab53de017517bf9579b6106397a523c ]

While KVM_XEN_EVTCHN_RESET is usually called with no vCPUs running,
if that happened it could cause a deadlock.  This is due to
kvm_xen_eventfd_reset() doing a synchronize_srcu() inside
a kvm->lock critical section.

To avoid this, first collect all the evtchnfd objects in an
array and free all of them once the kvm->lock critical section
is over and th SRCU grace period has expired.

Reported-by: Michal Luczaj <mhal@rbox.co>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/xen.c                            | 30 +++++++++++++++++--
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  6 ++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f3098c0e386a8..a58a426e6b1c0 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1757,18 +1757,42 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
 
 static int kvm_xen_eventfd_reset(struct kvm *kvm)
 {
-	struct evtchnfd *evtchnfd;
+	struct evtchnfd *evtchnfd, **all_evtchnfds;
 	int i;
+	int n = 0;
 
 	mutex_lock(&kvm->lock);
+
+	/*
+	 * Because synchronize_srcu() cannot be called inside the
+	 * critical section, first collect all the evtchnfd objects
+	 * in an array as they are removed from evtchn_ports.
+	 */
+	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i)
+		n++;
+
+	all_evtchnfds = kmalloc_array(n, sizeof(struct evtchnfd *), GFP_KERNEL);
+	if (!all_evtchnfds) {
+		mutex_unlock(&kvm->lock);
+		return -ENOMEM;
+	}
+
+	n = 0;
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
+		all_evtchnfds[n++] = evtchnfd;
 		idr_remove(&kvm->arch.xen.evtchn_ports, evtchnfd->send_port);
-		synchronize_srcu(&kvm->srcu);
+	}
+	mutex_unlock(&kvm->lock);
+
+	synchronize_srcu(&kvm->srcu);
+
+	while (n--) {
+		evtchnfd = all_evtchnfds[n];
 		if (!evtchnfd->deliver.port.port)
 			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 		kfree(evtchnfd);
 	}
-	mutex_unlock(&kvm->lock);
+	kfree(all_evtchnfds);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 2a5727188c8d3..8383457e66990 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -942,6 +942,12 @@ int main(int argc, char *argv[])
 	}
 
  done:
+	struct kvm_xen_hvm_attr evt_reset = {
+		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
+		.u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
+
 	alarm(0);
 	clock_gettime(CLOCK_REALTIME, &max_ts);
 
-- 
2.39.0



