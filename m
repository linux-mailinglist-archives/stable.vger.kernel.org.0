Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6F13B39DC
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 01:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhFXXvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 19:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhFXXvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 19:51:35 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60907C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 16:49:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s5-20020a17090a7645b029016f7e331ca4so6909285pjl.6
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 16:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Vt2aSebjq1sGUnOvdsn722BRfFx66IlNGLb8mfRKA0A=;
        b=pN7fAN+7Z1qUVjNo9ogsSR63nmQhjeUUVHVMVwxEc8CV9GCoUqfRJihawqxrMLK0pB
         GcFkQDe0S+yQzrChTKoSVT6r4cH9d9zo9Ri4VdbREORGsnwk92HIzWWIhMpMvjWZ29Z4
         +lANJMfNvT4G9usjz328y8MLVBSX2b96r1bsyNOVD2VEXIAwuj6BM9jAruEfhxpeb1lF
         JuF8s8FRBbO+ZlWknKJOhuI77Aki5K84D8pBZY7RWeb4iclIr7fKTIJxl72wLQxdricq
         /Xa8pgx2EllO1aXKXba4b2r8bcwsYAquI3VULDT7wJY0I7CKjvMVceED4XSObUD6dEsz
         ZaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Vt2aSebjq1sGUnOvdsn722BRfFx66IlNGLb8mfRKA0A=;
        b=J6O3JN+Mu10tjGBQeky/COeZyiKXHMcPpllzNu+yoLl93yT1zddU09wK0gXv5UGUFJ
         gin/VD124fSdB9bk/LY/2RiKRpvVAjFxO8Dmk5fjgc8J5efZdMvXizfZ3diqdRoo00qp
         gxcNU9w5nE0yx8oqJyqWOK9U49iTsrwWO74s72URE5bZqKx4hAXcQUYgslBgqk+G3bBG
         cMN7whqNXRuY7Jtw9yq0QNRdQjEuip3au1QD8fFKWdQiB9AmWUBwsWAGZi0q75Ri/Lnk
         2+u5hTTPPZxfsK49Z/2tCgBZyLvZiTojpFNNGn0i4euGi7eusRfS33M0rx163iDn7Un0
         0Nnw==
X-Gm-Message-State: AOAM531Yas8Wq/+2/Xhpb5EfJVBQwzC5fOhP9IcnL647soOgCoCk6M7N
        BQ3cwVJ09+4b8F09yWqjur/aWtYp9rCUVfmc1Eq7x7jOGL4RtgDRFnrYI2lf63QTof1JgqBkxNL
        Lmt5OG7toA0Xw17KdNf4HPwT53axY+mVwbS4Aj5B4ssD5Scp15dnamJP7zfb8K3GL3wQ=
X-Google-Smtp-Source: ABdhPJxAw7xTENF3xgFJFxoaaL9AQ2SxoHOX24wXyhaXjTkY+P0MUsfuEKb3SK0vuwnPlgOFOAb0nz5MzYYX2g==
X-Received: from alperct.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:466b])
 (user=alpergun job=sendgmr) by 2002:aa7:9729:0:b029:2ff:1e52:e284 with SMTP
 id k9-20020aa797290000b02902ff1e52e284mr7426497pfg.71.1624578554596; Thu, 24
 Jun 2021 16:49:14 -0700 (PDT)
Date:   Thu, 24 Jun 2021 23:48:55 +0000
Message-Id: <20210624234855.2428305-1-alpergun@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 5.10 v2] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
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
index 16b10b9436dc..01547bdbfb06 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -130,9 +130,25 @@ static void sev_asid_free(int asid)
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
@@ -152,15 +168,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
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
@@ -288,8 +296,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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

