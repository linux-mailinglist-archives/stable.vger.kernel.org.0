Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919513B390D
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhFXWGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbhFXWGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:06:37 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C1C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:04:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j24-20020a62b6180000b0290303645fae06so4807534pff.22
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xWh5oaKygJ0fMbRbwbzDfiZGkhc65kiiu1VD8WaYs3M=;
        b=HWKo3ds2hLB6a0cd4EtuunJPGu2bD9N4nmhnK4XjUrNmXeVgLIhoPh4AvzDiwtNTz1
         FO5NFZqqSPc3OpsZwzXY9Pn710hK0nQyJnctbIjju6LxRZIdp2KWJBzPGK4Ax2Z2CYA8
         gOYwm0hz29I1d1AFVQp1Gzi3AxksPPQnlb+gp1BVIzEvuKCBR61mr/M6Rnm5LvYrgzKB
         8YhI1QcU8/gfv/d2WOs/ytxdx0Mxvqk7ciweYzRWve/coj4QYNTGzscvjawZIAHkcjyS
         F9TbrkD4P4h21LDiVudE6OAEwoeTqeOO9819nLHXENsKT9U7+lXTQNJhGfqWw60P6ALB
         /HIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xWh5oaKygJ0fMbRbwbzDfiZGkhc65kiiu1VD8WaYs3M=;
        b=K//F1iMcFU4kFx5YcfRw8nRtGO9MCdGAVoHR6vxZ2NG7yvatlpJvs+Z6Et+4/bfsvC
         FRDzhOXdyFG8Zh3CUTPm82IrlfUPx4KTjGFZTpILlY22EfE1Quw5MIi07QLzg7lUwr4+
         ApalbYP8lUE9+1Phm122pmg3Ce9Q1WmD2I95Hf1u+US41WffE4/YzkLLG+2ozzEOu8ta
         SE4kPHqSPMq0WVeDPbfsf5RR8tQKt7wVtHAX7mP1rWNK7aLvg6IrOqx9YB7J3xQEyOad
         UzumI3YkJAc85UdPt4JWJTwg+m7YSSOuxWVF01rVoRQ5EgJUbxc/CD8rOIydUk6Edwy2
         WKBg==
X-Gm-Message-State: AOAM530w1p9FlYtRXJk04MtKEGdrYV2CuKn1FKSeW2exzLmvH2+KR4SY
        zB7EmGs06u7x1ugTuA6I9xQRfzdHW+ue/MgryRTfsUy/4lQAD/3DAP4Xz5roEaq/Tt2OXw5DPbb
        ip0+Q7PcHonAQvLCwArzrhTqNhvoDD+cRNgcJiEYD23npaQLaleNeEqrGeUnC5JJJjWQ=
X-Google-Smtp-Source: ABdhPJxg4WxXze8qm+G1iQCyIVsg04ivGuFvERXTcapJ1sPIESceX6TZJpuhj+kOHA4SJEw8sE3jr5c0OKNEVA==
X-Received: from alperct.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:466b])
 (user=alpergun job=sendgmr) by 2002:a17:902:8305:b029:120:1d69:6bd8 with SMTP
 id bd5-20020a1709028305b02901201d696bd8mr6418513plb.2.1624572256911; Thu, 24
 Jun 2021 15:04:16 -0700 (PDT)
Date:   Thu, 24 Jun 2021 22:03:42 +0000
Message-Id: <20210624220342.1974675-1-alpergun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 5.10] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
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
---
 arch/x86/kvm/svm/sev.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 16b10b9436dc..8112eafd45bc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -130,9 +130,19 @@ static void sev_asid_free(int asid)
 	mutex_unlock(&sev_bitmap_lock);
 }
 
+static void sev_decommission(unsigned int handle)
+{
+	struct sev_data_decommission decommission;
+
+	if (!handle)
+		return;
+
+	decommission.handle = handle;
+	sev_guest_decommission(&decommission, NULL);
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
-	struct sev_data_decommission *decommission;
 	struct sev_data_deactivate *data;
 
 	if (!handle)
@@ -152,15 +162,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
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
 
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -288,8 +290,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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

