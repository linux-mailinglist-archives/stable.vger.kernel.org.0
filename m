Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD57763EF17
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiLALPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 06:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiLALOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 06:14:39 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9785EA6CF0
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 03:08:49 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b2so3334175eja.7
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 03:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nkd0qjvVaAiiEvmHWMbDGHcYV2hQv0G5FFDx/lAEuwk=;
        b=aEqdasMvzqt4cGfl45hppFfevyDtbdbXO3ajVl/j31uklO7/Acttz+JxUMY4/Pd13r
         qA9jpZl+Rnhhik8PLiWzpnbpHs4CiEsN9ONSDoAsKhineOBAg0pLPqrw5R9mTY36uBT9
         DqRNCsQ1YVYeROKDbES+8UklF3NSMzWu//+j4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nkd0qjvVaAiiEvmHWMbDGHcYV2hQv0G5FFDx/lAEuwk=;
        b=wEPLfumHGLhiSLqxNEzITgokC6Lxrfb6GFun/jE/6VQwQVQR0czjuvecvIstnsEqDZ
         5Ei2cpCe4UmHQO3NAtpcGPmTDAt7LNVR5CZNyG+DnCc7KorRiCbktOsmyA2EvTUNUaSY
         GkuFuj/OZKiq2bW+KXDTigdhqM5A4HCkg98Ostjmjvgu8TwU6etSrLnfBjyGsNqp6Mtc
         Zn6pIq4AfHAcH4Zoc0atIVxnb8RXQg50VX8S+7KKh8XJY6SxtWgUAtZOcn1GdgWlXGw2
         zatzln3TEnDCgBHemqDsgzC0r5FFgkBsTcTeRrba36FPWxncA72N64VW8e1/8xfrzLBT
         10yg==
X-Gm-Message-State: ANoB5pnSezUDWXeQsN0lu7y7LSmtAur//huYfK8Mw+MeYT85rYkTF7I9
        WnkucrxvCgDH4nOwLaHvCCTi9g==
X-Google-Smtp-Source: AA0mqf7plaI93uNo8E+lVQtK6J3MolwWpNt7yp2inKCHh9SE/C4zxiykYQTaWDwrBxRvAvs+Ixd68w==
X-Received: by 2002:a17:907:3fa9:b0:7bf:5446:389d with SMTP id hr41-20020a1709073fa900b007bf5446389dmr17697065ejc.449.1669892927999;
        Thu, 01 Dec 2022 03:08:47 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:f554:724a:f89a:73db])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906293100b0078e0973d1f5sm1663824ejd.0.2022.12.01.03.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:08:47 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 01 Dec 2022 12:08:21 +0100
Subject: [PATCH v8 1/3] kexec: Refactor kexec_in_progress into a function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221127-snd-freeze-v8-1-3bc02d09f2ce@chromium.org>
References: <20221127-snd-freeze-v8-0-3bc02d09f2ce@chromium.org>
In-Reply-To: <20221127-snd-freeze-v8-0-3bc02d09f2ce@chromium.org>
To:     Juergen Gross <jgross@suse.com>, Mark Brown <broonie@kernel.org>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Len Brown <len.brown@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biederman <ebiederm@xmission.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Joel Fernandes <joel@joelfernandes.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Takashi Iwai <tiwai@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc:     kexec@lists.infradead.org, alsa-devel@alsa-project.org,
        Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        xen-devel@lists.xenproject.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=5606; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=rOwSP5vskEUbZoU8S9iGZ6yjsxnhI5XXCgf6CDbEiKk=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjiIs3ixiN1I8p0kAS9AN3OftX9qa+MJe/lyiFxhnr
 3KQHBPGJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4iLNwAKCRDRN9E+zzrEiAgBD/
 wMD0lpvGLSjykTW74XwGtwIS0vCS7kYGnMNXMZAS/+qAy1e9lAb+uWUmzMdmZCun7EdSzbcELHOnWF
 lmHJHTn37w6DN+LbjryPPWJ5HMyXKgLVRWnoxBNooMFbtfY0oCJ0XkmHwzHTtAnRmNumEv1/5BtFuc
 tCndENqSLCxLn1Q0WCvVnbEIKgUm1WrdGfPxSVaPWM7o9olbv6KLz/O4a5QRpsf83kNY0GGNQqnJ6T
 3K4jfeuO3u0HjrrHSAOxBpiQ7YzCqDPYmgXvzxsPOilkxnkhdUXm4zrz5l8uRRm5IPH+D+a2tJ2xSf
 V3id9yxm9UsfilPgFJFoM8+MwGPpIHhEt8kbCvIbq9R5JISg6YLh2i3jlX4iZc/bD3B34x25tq04tr
 NizRIER+5veXenpuoUm99sahcxk2+/HszRhEch2IEM4L4lUNjitjkfWZTJsR6NO1kGHnMQRA1Lv9JL
 WaoL/u/viwVrDq2nrVdpvFEoZQfyX3lh2X2XRYGk0SmUUBvipE9HAuETMI3Qyf/wErQ2zHHA5cQJ4m
 kT1GIXFzV1IFdk4jOpJTgbWlzWHqLegh4mYK50pubtKtmM57lytPw7JO8Un5mdcuGIsap10P8uxXLy
 JQmi7sc86pt58fddHNIdBd5kFCFomxDX91gu/JSYVpE3HMcvzl5av3SEmC+Q==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers running .shutdown() might want to behave differently during
kexec.

Convert kexec_in_progress into a function and export it, so it can be
used by drivers that are either built-in or modules.

Cc: stable@vger.kernel.org
Fixes: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 arch/powerpc/platforms/pseries/vio.c |  2 +-
 arch/x86/kernel/cpu/mshyperv.c       |  6 +++---
 arch/x86/xen/enlighten_hvm.c         |  2 +-
 drivers/firmware/efi/efi.c           |  2 +-
 drivers/pci/pci-driver.c             |  2 +-
 include/linux/kexec.h                |  5 ++---
 kernel/kexec_core.c                  | 12 ++++++++++--
 7 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/vio.c b/arch/powerpc/platforms/pseries/vio.c
index 00ecac2c205b..923f9a36b992 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -1289,7 +1289,7 @@ static void vio_bus_shutdown(struct device *dev)
 		viodrv = to_vio_driver(dev->driver);
 		if (viodrv->shutdown)
 			viodrv->shutdown(viodev);
-		else if (kexec_in_progress)
+		else if (kexec_in_progress())
 			vio_bus_remove(dev);
 	}
 }
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 831613959a92..f91f35206489 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -122,21 +122,21 @@ void hv_remove_crash_handler(void)
 #ifdef CONFIG_KEXEC_CORE
 static void hv_machine_shutdown(void)
 {
-	if (kexec_in_progress && hv_kexec_handler)
+	if (kexec_in_progress() && hv_kexec_handler)
 		hv_kexec_handler();
 
 	/*
 	 * Call hv_cpu_die() on all the CPUs, otherwise later the hypervisor
 	 * corrupts the old VP Assist Pages and can crash the kexec kernel.
 	 */
-	if (kexec_in_progress && hyperv_init_cpuhp > 0)
+	if (kexec_in_progress() && hyperv_init_cpuhp > 0)
 		cpuhp_remove_state(hyperv_init_cpuhp);
 
 	/* The function calls stop_other_cpus(). */
 	native_machine_shutdown();
 
 	/* Disable the hypercall page when there is only 1 active CPU. */
-	if (kexec_in_progress)
+	if (kexec_in_progress())
 		hyperv_cleanup();
 }
 
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index c1cd28e915a3..769163833ffc 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -145,7 +145,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_xen_hvm_callback)
 static void xen_hvm_shutdown(void)
 {
 	native_machine_shutdown();
-	if (kexec_in_progress)
+	if (kexec_in_progress())
 		xen_reboot(SHUTDOWN_soft_reset);
 }
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a46df5d1d094..608bc2146802 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -1040,7 +1040,7 @@ static int update_efi_random_seed(struct notifier_block *nb,
 	struct linux_efi_random_seed *seed;
 	u32 size = 0;
 
-	if (!kexec_in_progress)
+	if (!kexec_in_progress())
 		return NOTIFY_DONE;
 
 	seed = memremap(efi_rng_seed, sizeof(*seed), MEMREMAP_WB);
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 107d77f3c846..23eeb7538b03 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -519,7 +519,7 @@ static void pci_device_shutdown(struct device *dev)
 	 * If it is not a kexec reboot, firmware will hit the PCI
 	 * devices with big hammer and stop their DMA any way.
 	 */
-	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
+	if (kexec_in_progress() && pci_dev->current_state <= PCI_D3hot)
 		pci_clear_master(pci_dev);
 }
 
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 41a686996aaa..2ec0aec1a0de 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -423,8 +423,7 @@ extern int kexec_load_disabled;
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
 				 KEXEC_FILE_NO_INITRAMFS)
 
-/* flag to track if kexec reboot is in progress */
-extern bool kexec_in_progress;
+bool kexec_in_progress(void);
 
 int crash_shrink_memory(unsigned long new_size);
 ssize_t crash_get_memory_size(void);
@@ -507,7 +506,7 @@ static inline void __crash_kexec(struct pt_regs *regs) { }
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 static inline int kexec_crash_loaded(void) { return 0; }
-#define kexec_in_progress false
+static inline bool kexec_in_progress(void) { return false; }
 #endif /* CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_KEXEC_SIG
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index ca2743f9c634..4495d0fc28ae 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -52,8 +52,16 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 note_buf_t __percpu *crash_notes;
 
 /* Flag to indicate we are going to kexec a new kernel */
-bool kexec_in_progress = false;
+static bool kexec_in_progress_internal;
 
+/**
+ * kexec_in_progress - Check if the system is going to kexec
+ */
+bool kexec_in_progress(void)
+{
+	return kexec_in_progress_internal;
+}
+EXPORT_SYMBOL(kexec_in_progress);
 
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
@@ -1175,7 +1183,7 @@ int kernel_kexec(void)
 	} else
 #endif
 	{
-		kexec_in_progress = true;
+		kexec_in_progress_internal = true;
 		kernel_restart_prepare("kexec reboot");
 		migrate_to_reboot_cpu();
 

-- 
2.39.0.rc0.267.gcb52ba06e7-goog-b4-0.11.0-dev-696ae
