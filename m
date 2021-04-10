Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1067535ACFB
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhDJLg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhDJLg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65E37610F7;
        Sat, 10 Apr 2021 11:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618054575;
        bh=N4Jx8KsAbZcP8HP/QqGsIoEd/sLPk/dbFnmJNTF7SYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfX69K4NYfQQPBhLV4IlIHemdNgV9qEPhLno0CwrexVvIpYNVM2DpzjBCbihbEUm8
         UeAZLkJADVfSVGQKsvZfr2IRYHsOkvFCy6nv6Q2BPhAkoYMbFdGaT0ly6S7xA83UGA
         G1e+vC7Q3vaLE+yqco4dWAgEyUrm0oniK1Qxb2b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.230
Date:   Sat, 10 Apr 2021 13:36:06 +0200
Message-Id: <1618054566475@kroah.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <16180545661866@kroah.com>
References: <16180545661866@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index f45576aeda9d..09989cdd5cab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 229
+SUBLEVEL = 230
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index e58fab8aec5d..8923273a2f73 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -38,6 +38,9 @@
 		ethernet1 = &cpsw_emac1;
 		spi0 = &spi0;
 		spi1 = &spi1;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
 	};
 
 	cpus {
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 555b11180156..16a7dae5f770 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1860,7 +1860,7 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = (void *)__get_free_pages(GFP_KERNEL,
+			data = (void *)__get_free_pages(GFP_ATOMIC,
 							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9f33a69b5605..146aadeb7c8e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -35,7 +35,7 @@ REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse
+		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
 
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 0415c0cd4a19..a114c319cac2 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1107,7 +1107,16 @@ xadd:			if (is_imm8(insn->off))
 		}
 
 		if (image) {
-			if (unlikely(proglen + ilen > oldproglen)) {
+			/*
+			 * When populating the image, assert that:
+			 *
+			 *  i) We do not write beyond the allocated space, and
+			 * ii) addrs[i] did not change from the prior run, in order
+			 *     to validate assumptions made for computing branch
+			 *     displacements.
+			 */
+			if (unlikely(proglen + ilen > oldproglen ||
+				     proglen + ilen != addrs[i])) {
 				pr_err("bpf_jit: fatal error\n");
 				return -EFAULT;
 			}
diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index a2f89bac9c16..4c0ac0360b93 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -56,7 +56,7 @@ int msm_wait_fence(struct msm_fence_context *fctx, uint32_t fence,
 	int ret;
 
 	if (fence > fctx->last_fence) {
-		DRM_ERROR("%s: waiting on invalid fence: %u (of %u)\n",
+		DRM_ERROR_RATELIMITED("%s: waiting on invalid fence: %u (of %u)\n",
 				fctx->name, fence, fctx->last_fence);
 		return -EINVAL;
 	}
diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
index e240010b93fa..c87cb193830c 100644
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -711,7 +711,7 @@ isac_release(struct isac_hw *isac)
 {
 	if (isac->type & IPAC_TYPE_ISACX)
 		WriteISAC(isac, ISACX_MASK, 0xff);
-	else
+	else if (isac->type != 0)
 		WriteISAC(isac, ISAC_MASK, 0xff);
 	if (isac->dch.timer.function != NULL) {
 		del_timer(&isac->dch.timer);
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index a94a946996a9..c300011ddbab 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -413,9 +413,15 @@ static int flexcan_chip_disable(struct flexcan_priv *priv)
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = 1000 * 1000 * 10 / priv->can.bittiming.bitrate;
+	unsigned int timeout;
+	u32 bitrate = priv->can.bittiming.bitrate;
 	u32 reg;
 
+	if (bitrate)
+		timeout = 1000 * 1000 * 10 / bitrate;
+	else
+		timeout = FLEXCAN_TIMEOUT_US / 10;
+
 	reg = flexcan_read(&regs->mcr);
 	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
 	flexcan_write(reg, &regs->mcr);
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 993724959a7c..1883f0d076e3 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1553,8 +1553,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
-	unregister_netdev(dev);
 	cancel_work_sync(&pep->tx_timeout_task);
+	unregister_netdev(dev);
 	free_netdev(dev);
 	return 0;
 }
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index ffaaccded34e..30bfd51c0e58 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3964,13 +3964,19 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 
 	case TP_HKEY_EV_KEY_NUMLOCK:
 	case TP_HKEY_EV_KEY_FN:
-	case TP_HKEY_EV_KEY_FN_ESC:
 		/* key press events, we just ignore them as long as the EC
 		 * is still reporting them in the normal keyboard stream */
 		*send_acpi_ev = false;
 		*ignore_acpi_ev = true;
 		return true;
 
+	case TP_HKEY_EV_KEY_FN_ESC:
+		/* Get the media key status to foce the status LED to update */
+		acpi_evalf(hkey_handle, NULL, "GMKS", "v");
+		*send_acpi_ev = false;
+		*ignore_acpi_ev = true;
+		return true;
+
 	case TP_HKEY_EV_TABLET_CHANGED:
 		tpacpi_input_send_tabletsw();
 		hotkey_tablet_mode_notify_change();
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6cb933ecc084..f80b31b35a0d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -949,6 +949,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	return 0;
 fail:
+	if (bio)
+		bio_put(bio);
+	while (req->bio) {
+		bio = req->bio;
+		req->bio = bio->bi_next;
+		bio_put(bio);
+	}
+	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6c77a96437e6..46e8e9324b58 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -163,6 +163,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 			goto posix_open_ret;
 		}
 	} else {
+		cifs_revalidate_mapping(*pinode);
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0c6e5450ff76..80339e318294 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -656,8 +656,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
-	return false;
+	cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
+	return true;
 }
 
 void
diff --git a/init/Kconfig b/init/Kconfig
index 20f709ea1eb3..be58f0449c68 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -65,8 +65,7 @@ config CROSS_COMPILE
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
-	depends on !UML
-	default n
+	depends on HAS_IOMEM
 	help
 	  Some drivers can be compiled on a different platform than they are
 	  intended to be run on. Despite they cannot be loaded there (or even
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8a51f94ec1ce..2136ce3b4489 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -913,8 +913,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			continue;
 
 		if (!dflt_chandef.chan) {
+			/*
+			 * Assign the first enabled channel to dflt_chandef
+			 * from the list of channels
+			 */
+			for (i = 0; i < sband->n_channels; i++)
+				if (!(sband->channels[i].flags &
+						IEEE80211_CHAN_DISABLED))
+					break;
+			/* if none found then use the first anyway */
+			if (i == sband->n_channels)
+				i = 0;
 			cfg80211_chandef_create(&dflt_chandef,
-						&sband->channels[0],
+						&sband->channels[i],
 						NL80211_CHAN_NO_HT);
 			/* init channel we're on */
 			if (!local->use_chanctx && !local->_oper_chandef.chan) {
