Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF85F3B6A03
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhF1VNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbhF1VM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 17:12:59 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4C7C061574
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:10:32 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 124-20020a6217820000b02902feebfd791eso10002437pfx.19
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xUtrUtp2XoD9dfURf+TvxTLDKhhVTmYdNDcKFDdxUl0=;
        b=gPo9ak02pjgpprwMhXE0kkAGKECyIHJ/RlZd5pU+lCTgnxE+OvxxujffKad45R3Ziw
         y2bY+HaffEKJvXecE1AMVf8VaL2lGXlZ6Zj3GY6eU5XdeXICqGBeKDb3VuEPX8tpj5+C
         FUUR85r4sMKqRhLubA63D/72N6DZpiXAnQx29Uf6twYuA/64xOc7iVayEE5e5i+StQ2W
         0E4lj3cTVlpkp/hWG19ipMQGqU/AHHgB5kIlKoHpc08G1h1sDUoBasIevsbzKXa8571V
         YGc3RYOWBI5g7S3WiEYGs2zMG1RJ+AMwfxeICGJ9ITKt+f+U+KfZFJnvh/lcYspYMntD
         4RQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xUtrUtp2XoD9dfURf+TvxTLDKhhVTmYdNDcKFDdxUl0=;
        b=EFijHE0KIsvmTWT38mH5+Fl9qXPH/t4TKcQ0nCEOWHNY582IzhGHiJL685f9UmS1ET
         aG2nl4/eCbzu2lFH9KTPCWOg5tkojpboUWMBt1YyuPHoaUShBsa2nU4wNTfZySwO6yig
         7tJqLDkp6syidZQuCHP7HzDxzaqnuCYwTSI1HUyAXtYS+BFwM2zsbFhw5pUq+9qyQZGC
         UxoGxcf16L+b4ZFRTjZPyMUXT4YTX8XJst8GHg6Z2OP3p/y5E/cZhNAZpANDFfnPaFa0
         SR9r8tRGTRQ54wxyavqYmtBjhjC7z7ZJP5YmdU06QD417BJIBXJOCA2yKF/OamWDEx8i
         7pGQ==
X-Gm-Message-State: AOAM5301fSQHl44N0a7zgpnO78c+7NL5t/RA8SU9wkxMWILxhgliQd42
        UZkc4oB8mvXT+uj5vqn+LATaDQWR+SiT9whHdhg2JhynGIGV5041zSUdsCM3AVirKkscGrJTP3c
        E9FgiBAI9dUEkNuB5SQNVxBTmalIGGHyXWHp5gQL4ovwQqXfCjLlQW1QpuHE4SCWBhTA=
X-Google-Smtp-Source: ABdhPJwG1XSdXsknAgRDLMqrCcGOtWFoVGJ5kdJZQR5xYciM9KFrgC8mfcyzIN7jQkH6iKO+2yvLVmphR1JcSg==
X-Received: from alperct.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:466b])
 (user=alpergun job=sendgmr) by 2002:a17:90a:a05:: with SMTP id
 o5mr8107057pjo.107.1624914631508; Mon, 28 Jun 2021 14:10:31 -0700 (PDT)
Date:   Mon, 28 Jun 2021 21:10:12 +0000
Message-Id: <20210628211012.60827-1-alpergun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 4.19] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
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
index ad24e6777277..ae94ec036137 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1791,9 +1791,25 @@ static void sev_asid_free(struct kvm *kvm)
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
@@ -1811,15 +1827,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
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
@@ -6468,8 +6476,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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

