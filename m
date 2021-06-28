Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C63B6A04
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhF1VN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbhF1VN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 17:13:26 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3B8C061574
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:11:00 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t18-20020a056a001392b02903039eb2e663so10014108pfg.5
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=N63TEkOqeIEMukdKDiwxRq7WFmub09k3C+gQgcyO9cM=;
        b=D8+T8hwRR4f7wbVou+Urpyus04h9rv5qpPmyKJ/rpqDkDxmx0WCvh1Tu2/yIKqRdvm
         1TfptyruLWPyITxcZ4AVZDpKIuDZQrJE52e7cuyAtUzwDWk1itWohXaLytCeWGHOqA4C
         DsrIZ5AYKxO2c0DSe5YuSv2Pmm59DszCa6Qj+4GIxZ1H2p/rOcpKc0+qXpsyVw0Usm8h
         z80wTSvsHrPWJwVDprURdT96H0KQAT8JTz397kDe/jy6ulXvs/9QatSimSC1cT22MM6f
         miInXmI2FAqVXQm7M80agPGrTkp659mthQ9j0Kk1B+xcw0Zh3T01CLWT27b9+cFnIBis
         r+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=N63TEkOqeIEMukdKDiwxRq7WFmub09k3C+gQgcyO9cM=;
        b=Go8LpETGAiKEjh2RBA296zurElLb/wHem/zbGKChtoGtUiIVx5l3OA/m7UAIgiZayM
         q+eOQCjHpE8Vxp6+1/xoKGv3qBw/6NEA//uVeWMHhy2kqHCQ9nlWKGIrC6eLZ6EG9Z0n
         WZKS/dPoENqYntaBpS4yT27XPEJR2ZKO3cmarw7Mc47j1sfvLsGasDq2ZR9g6vlmqlrA
         dkaSE2Xper3mwawNewKmlodpnO8KEKEdrMDuY0ljz9nu40kVLj2TxFSeDJLcXWK6zFL+
         pBKn3SYU4xcwSEwd2Nv5Ov8bNMbXxxrC2Gcgd5zB0fbVbsoqex4aZM+s0o8Ldgvrv/Yy
         3OWA==
X-Gm-Message-State: AOAM531TbvDJR86/hVsGADZo91iqUCkVZv//u7y1s2KqJ3KrE+yuNrrX
        IUd5fY2pZqs2HwPaBhljXvYWRXqkeCluhxovoq5T1oRsaJuKB4/cLuV7FuACjuVYzL9+wAtkLN7
        iy/Nq07NfOrM7eTioWFxol+clYDlbtrLkJRfkpm6zDhFCIRGf1I1LO1MmdQ/qsR+nl38=
X-Google-Smtp-Source: ABdhPJx8yT1GcROPbRIOoKylSNTDstl8G46OsQT/0U4cjLxswpYI1SDagqF1DLVOUYhlZB4ZoWvQlbMQlVpIbw==
X-Received: from alperct.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:466b])
 (user=alpergun job=sendgmr) by 2002:aa7:8b56:0:b029:2b9:77be:d305 with SMTP
 id i22-20020aa78b560000b02902b977bed305mr26617172pfd.61.1624914659407; Mon,
 28 Jun 2021 14:10:59 -0700 (PDT)
Date:   Mon, 28 Jun 2021 21:10:54 +0000
Message-Id: <20210628211054.61528-1-alpergun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 5.4] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
From:   Alper Gun <alpergun@google.com>
To:     stable@vger.kernel.org
Cc:     Alper Gun <alpergun@google.com>, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 934002cd660b035b926438244b4294e647507e13 upstream.

Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
fails. If a failure happens after  a successful LAUNCH_START command,
a decommission command should be executed. Otherwise, guest context
will be unfreed inside the AMD SP. After the firmware will not have
memory to allocate more SEV guest context, LAUNCH_START command will
begin to fail with SEV_RET_RESOURCE_LIMIT error.

The existing code calls decommission inside sev_unbind_asid, but it is
not called if a failure happens before guest activation succeeds. If
sev_bind_asid fails, decommission is never called. PSP firmware has a
limit for the number of guests. If sev_asid_binding fails many times,
PSP firmware will not have resources to create another guest context.

Cc: stable@vger.kernel.org
Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
Reported-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Alper Gun <alpergun@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210610174604.2554090-1-alpergun@google.com>
---
 arch/x86/kvm/svm.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 074cd170912a..aa2da922ca99 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1794,9 +1794,25 @@ static void sev_asid_free(struct kvm *kvm)
 	__sev_asid_free(sev->asid);
 }
 
-static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission *decommission;
+
+	if (!handle)
+		return;
+
+	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
+	if (!decommission)
+		return;
+
+	decommission->handle = handle;
+	sev_guest_decommission(decommission, NULL);
+
+	kfree(decommission);
+}
+
+static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+{
 	struct sev_data_deactivate *data;
 
 	if (!handle)
@@ -1814,15 +1830,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_guest_df_flush(NULL);
 	kfree(data);
 
-	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
-	if (!decommission)
-		return;
-
-	/* decommission handle */
-	decommission->handle = handle;
-	sev_guest_decommission(decommission, NULL);
-
-	kfree(decommission);
+	sev_decommission(handle);
 }
 
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
@@ -6475,8 +6483,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start->handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start->handle);
 		goto e_free_session;
+	}
 
 	/* return handle to userspace */
 	params.handle = start->handle;
-- 
2.32.0.93.g670b81a890-goog

