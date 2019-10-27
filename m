Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66CBE63B4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfJ0PXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 11:23:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42272 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0PX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 11:23:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so7274644wrs.9;
        Sun, 27 Oct 2019 08:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6igW15FTNZ7FtCx0WIgyCMA7DFyAcrqLMXtjwXRNmLA=;
        b=IpzaTN653x/VMl1PRi17h+qZEKf0SkYms86/7yjWeyCLKorH0aA4rIJZCOEtoKR7hs
         zXrChV5UqjC6nwsIt8LeW3HgC7I/FAAQwcftiLpA88QJp7Dt/j/0XSsWXC6/kffekQ33
         b4bHt4zO7n/L0w6m7irP8CA50P0yGXoyQTigACshScNaWvf65llgJp1MYokVU1l5wKzQ
         td4WcUNEzvSZyU9tgSrCNxod3e6IJg45eGAt9p5cJtn/KaRUyr5/IKeMxs2gKQHjoyfC
         tE/WhkzB9IFfyFXbE+k0F3GHieLdiFZSKc/eu639a1+DK/RhB3AJMyZFcpykePl+CuFz
         A5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=6igW15FTNZ7FtCx0WIgyCMA7DFyAcrqLMXtjwXRNmLA=;
        b=a7I6mdG2Ii8T6JZwmVObw1kt8jpLpX+AmEVyfNmbxwPkTPuDHanA6GriDwvt9s6A2e
         DoJrRKubbGprhe7Wcita7Dc18RVoH8E0y2Wx7KPK4ZHYv1efbIh34nWOpwPBBs/dVbfc
         ao/T8xGLQdxXgbWyCsIoUW/XEE+MkC8uYhIJngvU4g1HuG4ch9+lx8w0Mg1EPHOWfoTt
         AWaJmOuNjPXhmpway7XEYLaUK1AF/lVvmJc8AlWu341x7FuF+MJibEHUBcYHArnSor74
         QvPqJlPJ3mvxd0YGtL3uLX2Vcf0gfJEW/oYjrTqSm/SxUIgMEkt8VRDXiKsmWIbW1WMT
         pXNQ==
X-Gm-Message-State: APjAAAU/oWc0kr74xNqEAkyJXGgjQ/2JPp3+tO21+5rnEyvfeH31E52B
        6qVCYummTVXdEyeoOQvsZDL8frQt
X-Google-Smtp-Source: APXvYqyUIc8eYKFqH39Ikktps0DnWgYsp2ek8Y5cJ/Z2DcRo5ITOuExB++Squxhm8XxeSkzWItMuWw==
X-Received: by 2002:adf:f4cb:: with SMTP id h11mr12546506wrp.260.1572189806902;
        Sun, 27 Oct 2019 08:23:26 -0700 (PDT)
Received: from localhost.localdomain (mob-2-43-145-251.net.vodafone.it. [2.43.145.251])
        by smtp.gmail.com with ESMTPSA id z15sm8490315wrr.19.2019.10.27.08.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 08:23:26 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active
Date:   Sun, 27 Oct 2019 16:23:23 +0100
Message-Id: <20191027152323.24326-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VMX already does so if the host has SMEP, in order to support the combination of
CR0.WP=1 and CR4.SMEP=1.  However, it is perfectly safe to always do so, and in
fact VMX already ends up running with EFER.NXE=1 on old processors that lack the
"load EFER" controls, because it may help avoiding a slow MSR write.  Removing
all the conditionals simplifies the code.

SVM does not have similar code, but it should since recent AMD processors do
support SMEP.  So this patch also makes the code for the two vendors more similar
while fixing NPT=0, CR0.WP=1 and CR4.SMEP=1 on AMD processors.

Cc: stable@vger.kernel.org
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c     | 10 ++++++++--
 arch/x86/kvm/vmx/vmx.c | 14 +++-----------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b6feb6a11a8d..2c452293c7cc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -732,8 +732,14 @@ static int get_npt_level(struct kvm_vcpu *vcpu)
 static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	vcpu->arch.efer = efer;
-	if (!npt_enabled && !(efer & EFER_LMA))
-		efer &= ~EFER_LME;
+
+	if (!npt_enabled) {
+		/* Shadow paging assumes NX to be available.  */
+		efer |= EFER_NX;
+
+		if (!(efer & EFER_LMA))
+			efer &= ~EFER_LME;
+	}
 
 	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
 	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2a2ba277c676..e191d41afb34 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -896,17 +896,9 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 	u64 guest_efer = vmx->vcpu.arch.efer;
 	u64 ignore_bits = 0;
 
-	if (!enable_ept) {
-		/*
-		 * NX is needed to handle CR0.WP=1, CR4.SMEP=1.  Testing
-		 * host CPUID is more efficient than testing guest CPUID
-		 * or CR4.  Host SMEP is anyway a requirement for guest SMEP.
-		 */
-		if (boot_cpu_has(X86_FEATURE_SMEP))
-			guest_efer |= EFER_NX;
-		else if (!(guest_efer & EFER_NX))
-			ignore_bits |= EFER_NX;
-	}
+	/* Shadow paging assumes NX to be available.  */
+	if (!enable_ept)
+		guest_efer |= EFER_NX;
 
 	/*
 	 * LMA and LME handled by hardware; SCE meaningless outside long mode.
-- 
2.21.0

