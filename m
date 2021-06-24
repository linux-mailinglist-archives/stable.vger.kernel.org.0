Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36C03B39DD
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 01:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhFXXw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 19:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXXw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 19:52:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C63CC061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 16:50:09 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t28-20020a63461c0000b0290221e90ef795so4837546pga.6
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 16:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M1VNVuQMjdWO8UyTMgNh8Y5zDVGwOKIQwOB57tUW73Q=;
        b=YFkfMXxc4cirqn6Yh/z82dmxpKvryoVZYqHs4JtotD9tz0RsFPJfwnCAU+PW9dnRfT
         CuW4BRC+hJ44eG1HE+4FvHguRXC/xy2vXpYtHV+FIDT1C6zb4bMsgVV+7T3PE3iWAIpe
         IOxega4U9r6rBDxqSviu4kPOKn+yBGHM2FTuaN1kwxV9lUAHlgwWGhhtn1IQ6Aa5S4pi
         LBHMjSu5pULZko/T5ScNqeKJh+b2HKK2qSNH37CpesyALm51Yth450GVDjPJ+EmLU6xD
         SA1r+yuGxNkbA8+pYK+30swYAVFw4OuhUdGf7U2yxxOWByinSJjfQ9yDVq9QimAfk+kF
         IADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M1VNVuQMjdWO8UyTMgNh8Y5zDVGwOKIQwOB57tUW73Q=;
        b=T65pq2iLqZLOjr2kqKqfLY3V2owpzWSJXxavVoW8xIY6XFWws5f3X4i9Q2/O6MagK1
         4Kvnv/MBE5tZ4JxxU/U3oCja5RxrgG5ZeldIilcP5y1oVtyyz04TC8C+zP888r3QvG8E
         glU71V0nkenb89l9VIKbGWO595mbOIxNgndkLeGeA/6uzUPTZzutcFDpXbigfCBOdBc8
         GmppWF3TywOJhFM/jj/TZStTkyssVHeJuYoU15XYkadM3q+AkCvBgleEOsekHI5+fiAz
         wXU+JMDbGTefngZFtwr3hW1CXGj7uhRxQWykYgO3DLMls9J+SRPmDe17Bjupn10zupqv
         3P/A==
X-Gm-Message-State: AOAM5300MDos33z206mA8OVijkiaNfWbaljn6j8i+joFNukRWn7Xw19k
        rF8SErFyrvmxWdrUJZer8qCeyLHm0sNuElMumyjHOVIi7nhwAz+hS2CgNFxTb259FWtepwjIC5g
        dT+e7Br4m2iBuGj860t/H6bCUlA3odG/hbXM0Vv6bheC2xHMX4K5FZtjmuDDFj0vIoUA=
X-Google-Smtp-Source: ABdhPJzcD9byXoqjTbSZgD4jiCls13+S3+cKu5Q6nMTWmzZl/mjCEBF7gMVhmV0GP8cweTcT6KEdWdqr5icwEQ==
X-Received: from alperct.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:466b])
 (user=alpergun job=sendgmr) by 2002:a63:e114:: with SMTP id
 z20mr6803373pgh.207.1624578608552; Thu, 24 Jun 2021 16:50:08 -0700 (PDT)
Date:   Thu, 24 Jun 2021 23:50:02 +0000
Message-Id: <20210624235002.2429467-1-alpergun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 5.12 v2] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
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
 arch/x86/kvm/svm/sev.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dbc6214d69de..8f3b438f6fd3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -143,9 +143,25 @@ static void sev_asid_free(int asid)
 	mutex_unlock(&sev_bitmap_lock);
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
@@ -165,15 +181,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
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
@@ -303,8 +311,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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

