Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195CB40B765
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhINTCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhINTCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:02:47 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEDEC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:01:29 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id l22-20020a05622a175600b0029d63a970f6so61448823qtk.23
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qXeN+0YjwEWrVRbmWh3uR8N524Lyfl40pJMmG7kpDMQ=;
        b=l3NOXhYLSb4uR4qCfXv+kIDu6RaW+mh86Oqac9N3/0W8oiw7weakxDFnEWjIaXQdvN
         IIOJGPaH4B859pASij8XptcTpT2pjissVlrsQ5wpefqrc1w+0gD3VAgCMHH8r7TauYQj
         ySxAkItpKb5QI+a1Zp0uKUxfWB7zVMERif/fL67YtvPv05x+mH6K8xncGxzeVj58aOxZ
         hzjo+FvWaHCuMlnNlIDbQ7H1WV6M/jU36au9d9ur7PKj44jQgyb7Qy+0fyc7qTAmAdB/
         lD2RgigqVWFSJYOYiQYcUhzRvg6dUonCuhA2JrzCESG7+jezCoEDY2U8BE7w9WdT/DYh
         NFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qXeN+0YjwEWrVRbmWh3uR8N524Lyfl40pJMmG7kpDMQ=;
        b=KG9o9k4/uQMtIeTDSdsFb3F7qGVA/ybeoVRtLUVkZ4s42CN231xfhM/zOrQHW8sZ85
         OyyxGMUwmX9Le6u8lQd4QdGRDFWZeC+X4LgHk42THODfRmduB+NHNxr8Wtt8WmJH0MmG
         wDHv8c+eKaLlguoKe+ePMHTQ8R9+NuECQPbv13aQhZZSvM8wjoPUlqEeomh/i/vV6oAK
         S/GXYwca0axCGZC7MK2UgqGH2EGbKHrfwAt/2NH0sh/vk0jqjD593bPgbbdiDW8woFej
         X4794ptj03FVFKSls5F/SJ+HyzS5UF+5dMeYguxVc0+dKok4nrw9l8DKC9naFgHWzNS8
         wIfA==
X-Gm-Message-State: AOAM530Bly+ZtJPp2+cdmS+BDhbZVoPoefAtp+Rg0Sti/qSSJOvIwuy4
        Hrzd/jJybX7ymI9UwCxbDgn3PpQEG1I=
X-Google-Smtp-Source: ABdhPJyKSDtjXlMeEQPNa3EfLfWLutRYhMOrRnGvZvDGH5j1BrBsdMydQKn0s3IIS0BQz+zLsPI4bROmm5A=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a0c:cb10:: with SMTP id o16mr7026938qvk.57.1631646088587;
 Tue, 14 Sep 2021 12:01:28 -0700 (PDT)
Date:   Tue, 14 Sep 2021 12:01:25 -0700
Message-Id: <20210914190125.3289256-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH V2] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
SEV-ES guest. The destination VM is already checked for SEV and SEV-ES
with sev_guest(), so this ioctl already fails if the destination is SEV
enabled.

Enabling mirroring a VM or copying its encryption context with an SEV-ES
VM is more involved and should happen in its own feature patch if that's
needed. This is because the vCPUs of SEV-ES VMs need to be updated with
LAUNCH_UPDATE_VMSA before LAUNCH_FINISH. This needs KVM changes because
the mirror VM has all its SEV ioctls blocked and the original VM doesn't
know about the mirrors vCPUs.

Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")

V2:
 * Updated changelog with more information and added stable CC.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Nathan Tempelman <natet@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..8a279027425f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1728,7 +1728,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	source_kvm = source_kvm_file->private_data;
 	mutex_lock(&source_kvm->lock);
 
-	if (!sev_guest(source_kvm)) {
+	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto e_source_unlock;
 	}
-- 
2.33.0.309.g3052b89438-goog

