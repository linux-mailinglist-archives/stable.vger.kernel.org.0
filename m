Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119BD3B3907
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFXWFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhFXWFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:05:04 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C21C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:02:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 17-20020a630b110000b029022064e7cdcfso4690958pgl.10
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6Y4QVLIGrD4J13kvncLBGMd58mxa6TfuWSqUzcypgf4=;
        b=UfAb8Y+cPX2V91sN86eqEk291YN9Wxlxl9zpcqw7wKNjgH3NpBz5W0iIfbFttHYbMp
         F8ZZSACdA8y/HGINEgR1nlRUfAS4nIOcJbAuwjZ1E2ef+j4eEP0C/+tvtXXoeATTLoVb
         X4LOLnFCu4R12E3PTPXkK9Iw7Q2dwJoTqF0oWl9uVJvb5CGp8bL0u1OEKObD5S+/EYww
         4HJVkwtyY1ExqHZ6a4oM66G5o4O7j/Ja0dgQLIiHKwHZQhAG7DfvKw0wkHjYPhfJJjvT
         hNxCzohqdW15ZMJMjsqGg/Lge2lvsYNa/Cg9wS81SxFLXdiS2y0qULdJpUjqv4fLlDgJ
         x70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6Y4QVLIGrD4J13kvncLBGMd58mxa6TfuWSqUzcypgf4=;
        b=uU6efx+jphI6VHmQRgQHRKpslDqm20HzbFrU++1meEHlMG+shDO0BBhvdEwULYpx7c
         z0fxjxvhUBPP7SZx+yxyv4j2uwQdu9CsEd6VSh+9edRfpmJ97Ao/83o60RpDVJFq3bg3
         RkHMhXzL6puYk9ljwxJxyLDOHrNXHydYW4l8BEu80fwSOd6FeTS0EyvA7dvumQyUhqsn
         u8unnMrIkxOAcavpvP7inohVUwFJsHHT0CeLD+Fp5rFWbzfahBN41Fb9ar0WFfgm5rxI
         g4SAR34AHccrVVdlC1f8OB+fHhHoINod4w8KLkCj6BsQ1zCb4lNBO3p8UZMSDsvz0g5U
         6e6g==
X-Gm-Message-State: AOAM530wj0K0/nRTGWPS2Kf0S49Oj3/V4vYluIpJ3dEI7cIrmo+3mqYl
        tLEPoR0+4wVWybeGXz3Y1QlvR6X0adSorTwpLO2+yD6CXPlXB31IINLhywAfw7wwIIRH5F2c5zd
        B4uSMvzYuAvxl49Bn0qgOqrCEqmDde7MgxrWO2sjlua3zMJSYPEbvXLVnTUAgrdBE96I=
X-Google-Smtp-Source: ABdhPJzbcW+goocYkKXW8Kzyn7TEH0os2UTTfawc2/iOReazr8V2vmD9y6+HjiCHUqH80YrtdimxUhCLCtp4Sg==
X-Received: from alperct.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:466b])
 (user=alpergun job=sendgmr) by 2002:a62:3543:0:b029:301:aaae:8785 with SMTP
 id c64-20020a6235430000b0290301aaae8785mr7369990pfa.20.1624572163254; Thu, 24
 Jun 2021 15:02:43 -0700 (PDT)
Date:   Thu, 24 Jun 2021 22:02:11 +0000
Message-Id: <20210624220211.1973589-1-alpergun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 5.12] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
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
index dbc6214d69de..96a61fab9c58 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -143,9 +143,19 @@ static void sev_asid_free(int asid)
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
@@ -165,15 +175,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
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
@@ -303,8 +305,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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

