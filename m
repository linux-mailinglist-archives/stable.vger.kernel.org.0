Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA8527941
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiEOSrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiEOSrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E182E031;
        Sun, 15 May 2022 11:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F84B80E07;
        Sun, 15 May 2022 18:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8EDC385B8;
        Sun, 15 May 2022 18:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640436;
        bh=tgWxhcx8CrfP/cirT05J3G8iFvZV+2akjTVp4M2dFHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHVKbNSVP/+5lo2djR42tRsNCuddycXko4BYai5qrak17tfrAarELXl/JMQTO1vBW
         H/hE/tWuJyhUrCOLNTxVD++/BWvuKPX7hRoD3zoKBPehNfCtWC2xxHaUNEZStdOHAT
         V7UkWAKCfucPAR66B6WCzhrqJGODuTtF0Z+MqNPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.279
Date:   Sun, 15 May 2022 20:47:04 +0200
Message-Id: <165264042472114@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165264042429201@kroah.com>
References: <165264042429201@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9e6373f02d6c..efe93f82073a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 278
+SUBLEVEL = 279
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 3b6f687f177c..32f8c501f6cb 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -174,7 +174,7 @@ void __init plat_mem_setup(void)
 		dtb = phys_to_virt(fw_arg2);
 	else if (fw_passed_dtb) /* UHI interface */
 		dtb = (void *)fw_passed_dtb;
-	else if (__dtb_start != __dtb_end)
+	else if (&__dtb_start != &__dtb_end)
 		dtb = (void *)__dtb_start;
 	else
 		panic("no dtb found");
diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index 9ff7ccde9de0..a26322ff57e0 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -82,7 +82,7 @@ void __init plat_mem_setup(void)
 
 	if (fw_passed_dtb) /* UHI interface */
 		dtb = (void *)fw_passed_dtb;
-	else if (__dtb_start != __dtb_end)
+	else if (&__dtb_start != &__dtb_end)
 		dtb = (void *)__dtb_start;
 	else
 		panic("no dtb found");
diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index 51599710472b..406c6c5cec29 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -36,7 +36,7 @@ static ulong get_fdtaddr(void)
 	if (fw_passed_dtb && !fw_arg2 && !fw_arg3)
 		return (ulong)fw_passed_dtb;
 
-	if (__dtb_start < __dtb_end)
+	if (&__dtb_start < &__dtb_end)
 		ftaddr = (ulong)__dtb_start;
 
 	return ftaddr;
diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 92b3d4849996..1f7c686f7218 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -79,7 +79,7 @@ void __init plat_mem_setup(void)
 	 */
 	if (fw_passed_dtb)
 		dtb = (void *)fw_passed_dtb;
-	else if (__dtb_start != __dtb_end)
+	else if (&__dtb_start != &__dtb_end)
 		dtb = (void *)__dtb_start;
 
 	__dt_setup_arch(dtb);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 5543876ec0e2..bfefa8c4fa16 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -774,9 +774,11 @@ int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info)
 	mutex_lock(&adm_ctx.resource->adm_mutex);
 
 	if (info->genlhdr->cmd == DRBD_ADM_PRIMARY)
-		retcode = drbd_set_role(adm_ctx.device, R_PRIMARY, parms.assume_uptodate);
+		retcode = (enum drbd_ret_code)drbd_set_role(adm_ctx.device,
+						R_PRIMARY, parms.assume_uptodate);
 	else
-		retcode = drbd_set_role(adm_ctx.device, R_SECONDARY, 0);
+		retcode = (enum drbd_ret_code)drbd_set_role(adm_ctx.device,
+						R_SECONDARY, 0);
 
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
 	genl_lock();
@@ -1941,7 +1943,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	drbd_flush_workqueue(&connection->sender_work);
 
 	rv = _drbd_request_state(device, NS(disk, D_ATTACHING), CS_VERBOSE);
-	retcode = rv;  /* FIXME: Type mismatch. */
+	retcode = (enum drbd_ret_code)rv;
 	drbd_resume_io(device);
 	if (rv < SS_SUCCESS)
 		goto fail;
@@ -2671,7 +2673,8 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 	rcu_read_unlock();
 
-	retcode = conn_request_state(connection, NS(conn, C_UNCONNECTED), CS_VERBOSE);
+	retcode = (enum drbd_ret_code)conn_request_state(connection,
+					NS(conn, C_UNCONNECTED), CS_VERBOSE);
 
 	conn_reconfig_done(connection);
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
@@ -2777,7 +2780,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	mutex_lock(&adm_ctx.resource->adm_mutex);
 	rv = conn_try_disconnect(connection, parms.force_disconnect);
 	if (rv < SS_SUCCESS)
-		retcode = rv;  /* FIXME: Type mismatch. */
+		retcode = (enum drbd_ret_code)rv;
 	else
 		retcode = NO_ERROR;
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 9de6a32f0c9f..0b1d4f2b5862 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -49,10 +49,7 @@ struct realtek_pci_sdmmc {
 	bool			double_clk;
 	bool			eject;
 	bool			initial_mode;
-	int			power_state;
-#define SDMMC_POWER_ON		1
-#define SDMMC_POWER_OFF		0
-
+	int			prev_power_state;
 	int			sg_count;
 	s32			cookie;
 	int			cookie_sg_count;
@@ -913,14 +910,21 @@ static int sd_set_bus_width(struct realtek_pci_sdmmc *host,
 	return err;
 }
 
-static int sd_power_on(struct realtek_pci_sdmmc *host)
+static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	if (host->power_state == SDMMC_POWER_ON)
+	if (host->prev_power_state == MMC_POWER_ON)
 		return 0;
 
+	if (host->prev_power_state == MMC_POWER_UP) {
+		rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, 0);
+		goto finish;
+	}
+
+	msleep(100);
+
 	rtsx_pci_init_cmd(pcr);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_SELECT, 0x07, SD_MOD_SEL);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_SHARE_MODE,
@@ -939,11 +943,17 @@ static int sd_power_on(struct realtek_pci_sdmmc *host)
 	if (err < 0)
 		return err;
 
+	mdelay(1);
+
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
 		return err;
 
-	host->power_state = SDMMC_POWER_ON;
+	/* send at least 74 clocks */
+	rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, SD_CLK_TOGGLE_EN);
+
+finish:
+	host->prev_power_state = power_mode;
 	return 0;
 }
 
@@ -952,7 +962,7 @@ static int sd_power_off(struct realtek_pci_sdmmc *host)
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 
 	rtsx_pci_init_cmd(pcr);
 
@@ -978,7 +988,7 @@ static int sd_set_power_mode(struct realtek_pci_sdmmc *host,
 	if (power_mode == MMC_POWER_OFF)
 		err = sd_power_off(host);
 	else
-		err = sd_power_on(host);
+		err = sd_power_on(host, power_mode);
 
 	return err;
 }
@@ -1416,7 +1426,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 	host->pdev = pdev;
 	host->cookie = -1;
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 05a59b9946cb..4eb196d7f4a6 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -245,7 +245,7 @@ struct grcan_device_config {
 		.rxsize		= GRCAN_DEFAULT_BUFFER_SIZE,	\
 		}
 
-#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	0x4100
+#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	4100
 #define GRLIB_VERSION_MASK		0xffff
 
 /* GRCAN private data structure */
@@ -1141,7 +1141,7 @@ static int grcan_close(struct net_device *dev)
 	return 0;
 }
 
-static int grcan_transmit_catch_up(struct net_device *dev, int budget)
+static void grcan_transmit_catch_up(struct net_device *dev)
 {
 	struct grcan_priv *priv = netdev_priv(dev);
 	unsigned long flags;
@@ -1149,7 +1149,7 @@ static int grcan_transmit_catch_up(struct net_device *dev, int budget)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	work_done = catch_up_echo_skb(dev, budget, true);
+	work_done = catch_up_echo_skb(dev, -1, true);
 	if (work_done) {
 		if (!priv->resetting && !priv->closing &&
 		    !(priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
@@ -1163,8 +1163,6 @@ static int grcan_transmit_catch_up(struct net_device *dev, int budget)
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return work_done;
 }
 
 static int grcan_receive(struct net_device *dev, int budget)
@@ -1246,19 +1244,13 @@ static int grcan_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = priv->dev;
 	struct grcan_registers __iomem *regs = priv->regs;
 	unsigned long flags;
-	int tx_work_done, rx_work_done;
-	int rx_budget = budget / 2;
-	int tx_budget = budget - rx_budget;
+	int work_done;
 
-	/* Half of the budget for receiveing messages */
-	rx_work_done = grcan_receive(dev, rx_budget);
+	work_done = grcan_receive(dev, budget);
 
-	/* Half of the budget for transmitting messages as that can trigger echo
-	 * frames being received
-	 */
-	tx_work_done = grcan_transmit_catch_up(dev, tx_budget);
+	grcan_transmit_catch_up(dev);
 
-	if (rx_work_done < rx_budget && tx_work_done < tx_budget) {
+	if (work_done < budget) {
 		napi_complete(napi);
 
 		/* Guarantee no interference with a running reset that otherwise
@@ -1275,7 +1267,7 @@ static int grcan_poll(struct napi_struct *napi, int budget)
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	return rx_work_done + tx_work_done;
+	return work_done;
 }
 
 /* Work tx bug by waiting while for the risky situation to clear. If that fails,
@@ -1665,6 +1657,7 @@ static int grcan_setup_netdev(struct platform_device *ofdev,
 static int grcan_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
+	struct device_node *sysid_parent;
 	struct resource *res;
 	u32 sysid, ambafreq;
 	int irq, err;
@@ -1674,10 +1667,15 @@ static int grcan_probe(struct platform_device *ofdev)
 	/* Compare GRLIB version number with the first that does not
 	 * have the tx bug (see start_xmit)
 	 */
-	err = of_property_read_u32(np, "systemid", &sysid);
-	if (!err && ((sysid & GRLIB_VERSION_MASK)
-		     >= GRCAN_TXBUG_SAFE_GRLIB_VERSION))
-		txbug = false;
+	sysid_parent = of_find_node_by_path("/ambapp0");
+	if (sysid_parent) {
+		of_node_get(sysid_parent);
+		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
+		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
+			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
+			txbug = false;
+		of_node_put(sysid_parent);
+	}
 
 	err = of_property_read_u32(np, "freq", &ambafreq);
 	if (err) {
diff --git a/fs/namespace.c b/fs/namespace.c
index 683668a20bed..a0c549f2721c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2570,9 +2570,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
 		return -ENODEV;
 
 	mnt = vfs_kern_mount(type, sb_flags, name, data);
-	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
-	    !mnt->mnt_sb->s_subtype)
-		mnt = fs_set_subtype(mnt, fstype);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE)) {
+		down_write(&mnt->mnt_sb->s_umount);
+		if (!mnt->mnt_sb->s_subtype)
+			mnt = fs_set_subtype(mnt, fstype);
+		up_write(&mnt->mnt_sb->s_umount);
+	}
 
 	put_filesystem(type);
 	if (IS_ERR(mnt))
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 51afaaa68408..d42288a06af6 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -34,6 +34,9 @@
 /* HCI priority */
 #define HCI_PRIO_MAX	7
 
+/* HCI maximum id value */
+#define HCI_MAX_ID 10000
+
 /* HCI Core structures */
 struct inquiry_data {
 	bdaddr_t	bdaddr;
diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 24febf9e177c..0a4770cc3691 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -396,6 +396,8 @@ struct snd_pcm_runtime {
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
+	struct mutex buffer_mutex;	/* protect for buffer changes */
+	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/mm/memory.c b/mm/memory.c
index cec495ecffae..4154fb45ac0f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4836,6 +4836,8 @@ long copy_huge_page_from_user(struct page *dst_page,
 		if (rc)
 			break;
 
+		flush_dcache_page(subpage);
+
 		cond_resched();
 	}
 	return ret_val;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index ee8a68863089..3f08453e703d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -56,6 +56,8 @@ static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -565,6 +567,7 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 687b4d0e4c67..a6f186a04fe7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3100,10 +3100,10 @@ int hci_register_dev(struct hci_dev *hdev)
 	 */
 	switch (hdev->dev_type) {
 	case HCI_PRIMARY:
-		id = ida_simple_get(&hci_index_ida, 0, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 0, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	case HCI_AMP:
-		id = ida_simple_get(&hci_index_ida, 1, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 1, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	default:
 		return -EINVAL;
@@ -3112,7 +3112,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (id < 0)
 		return id;
 
-	sprintf(hdev->name, "hci%d", id);
+	snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
 	hdev->id = id;
 
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index a228bf933110..de48803f2be2 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1032,6 +1032,8 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 	init_waitqueue_head(&runtime->tsleep);
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	mutex_init(&runtime->buffer_mutex);
+	atomic_set(&runtime->buffer_accessing, 0);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
@@ -1063,6 +1065,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 	substream->runtime = NULL;
 	if (substream->timer)
 		spin_unlock_irq(&substream->timer->lock);
+	mutex_destroy(&runtime->buffer_mutex);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 82a7387ba9d2..82d4b72dcb64 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2226,10 +2226,15 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 			snd_pcm_stream_unlock_irq(substream);
 			return -EINVAL;
 		}
+		if (!atomic_inc_unless_negative(&runtime->buffer_accessing)) {
+			err = -EBUSY;
+			goto _end_unlock;
+		}
 		snd_pcm_stream_unlock_irq(substream);
 		err = writer(substream, appl_ofs, data, offset, frames,
 			     transfer);
 		snd_pcm_stream_lock_irq(substream);
+		atomic_dec(&runtime->buffer_accessing);
 		if (err < 0)
 			goto _end_unlock;
 		err = pcm_accessible_state(runtime);
diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index ae33e456708c..adc5f3c2379b 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -160,19 +160,20 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	size_t size;
 	struct snd_dma_buffer new_dmab;
 
+	mutex_lock(&substream->pcm->open_mutex);
 	if (substream->runtime) {
 		buffer->error = -EBUSY;
-		return;
+		goto unlock;
 	}
 	if (!snd_info_get_line(buffer, line, sizeof(line))) {
 		snd_info_get_str(str, line, sizeof(str));
 		size = simple_strtoul(str, NULL, 10) * 1024;
 		if ((size != 0 && size < 8192) || size > substream->dma_max) {
 			buffer->error = -EINVAL;
-			return;
+			goto unlock;
 		}
 		if (substream->dma_buffer.bytes == size)
-			return;
+			goto unlock;
 		memset(&new_dmab, 0, sizeof(new_dmab));
 		new_dmab.dev = substream->dma_buffer.dev;
 		if (size > 0) {
@@ -180,7 +181,7 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 						substream->dma_buffer.dev.dev,
 						size, &new_dmab) < 0) {
 				buffer->error = -ENOMEM;
-				return;
+				goto unlock;
 			}
 			substream->buffer_bytes_max = size;
 		} else {
@@ -192,6 +193,8 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	} else {
 		buffer->error = -EINVAL;
 	}
+ unlock:
+	mutex_unlock(&substream->pcm->open_mutex);
 }
 
 static inline void preallocate_info_init(struct snd_pcm_substream *substream)
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c530d008fe01..c57d82402220 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -634,6 +634,30 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+/* acquire buffer_mutex; if it's in r/w operation, return -EBUSY, otherwise
+ * block the further r/w operations
+ */
+static int snd_pcm_buffer_access_lock(struct snd_pcm_runtime *runtime)
+{
+	if (!atomic_dec_unless_positive(&runtime->buffer_accessing))
+		return -EBUSY;
+	mutex_lock(&runtime->buffer_mutex);
+	return 0; /* keep buffer_mutex, unlocked by below */
+}
+
+/* release buffer_mutex and clear r/w access flag */
+static void snd_pcm_buffer_access_unlock(struct snd_pcm_runtime *runtime)
+{
+	mutex_unlock(&runtime->buffer_mutex);
+	atomic_inc(&runtime->buffer_accessing);
+}
+
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
@@ -645,22 +669,25 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	err = snd_pcm_buffer_access_lock(runtime);
+	if (err < 0)
+		return err;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (!is_oss_stream(substream) &&
+		    atomic_read(&substream->mmap_count))
+			err = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		err = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-	if (!substream->oss.oss)
-#endif
-		if (atomic_read(&substream->mmap_count))
-			return -EBADFD;
+	if (err)
+		goto unlock;
 
 	params->rmask = ~0U;
 	err = snd_pcm_hw_refine(substream, params);
@@ -737,14 +764,19 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	if ((usecs = period_to_usecs(runtime)) >= 0)
 		pm_qos_add_request(&substream->latency_pm_qos_req,
 				   PM_QOS_CPU_DMA_LATENCY, usecs);
-	return 0;
+	err = 0;
  _error:
-	/* hardware might be unusable from this time,
-	   so we force application to retry to set
-	   the correct hardware parameter settings */
-	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	if (substream->ops->hw_free != NULL)
-		substream->ops->hw_free(substream);
+	if (err) {
+		/* hardware might be unusable from this time,
+		 * so we force application to retry to set
+		 * the correct hardware parameter settings
+		 */
+		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
+		if (substream->ops->hw_free != NULL)
+			substream->ops->hw_free(substream);
+	}
+ unlock:
+	snd_pcm_buffer_access_unlock(runtime);
 	return err;
 }
 
@@ -777,22 +809,29 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	result = snd_pcm_buffer_access_lock(runtime);
+	if (result < 0)
+		return result;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (atomic_read(&substream->mmap_count))
+			result = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		result = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-	if (atomic_read(&substream->mmap_count))
-		return -EBADFD;
+	if (result)
+		goto unlock;
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
+ unlock:
+	snd_pcm_buffer_access_unlock(runtime);
 	return result;
 }
 
@@ -1029,15 +1068,17 @@ struct action_ops {
  */
 static int snd_pcm_action_group(const struct action_ops *ops,
 				struct snd_pcm_substream *substream,
-				int state, int do_lock)
+				int state, int stream_lock)
 {
 	struct snd_pcm_substream *s = NULL;
 	struct snd_pcm_substream *s1;
 	int res = 0, depth = 1;
 
 	snd_pcm_group_for_each_entry(s, substream) {
-		if (do_lock && s != substream) {
-			if (s->pcm->nonatomic)
+		if (s != substream) {
+			if (!stream_lock)
+				mutex_lock_nested(&s->runtime->buffer_mutex, depth);
+			else if (s->pcm->nonatomic)
 				mutex_lock_nested(&s->self_group.mutex, depth);
 			else
 				spin_lock_nested(&s->self_group.lock, depth);
@@ -1065,18 +1106,18 @@ static int snd_pcm_action_group(const struct action_ops *ops,
 		ops->post_action(s, state);
 	}
  _unlock:
-	if (do_lock) {
-		/* unlock streams */
-		snd_pcm_group_for_each_entry(s1, substream) {
-			if (s1 != substream) {
-				if (s1->pcm->nonatomic)
-					mutex_unlock(&s1->self_group.mutex);
-				else
-					spin_unlock(&s1->self_group.lock);
-			}
-			if (s1 == s)	/* end */
-				break;
+	/* unlock streams */
+	snd_pcm_group_for_each_entry(s1, substream) {
+		if (s1 != substream) {
+			if (!stream_lock)
+				mutex_unlock(&s1->runtime->buffer_mutex);
+			else if (s1->pcm->nonatomic)
+				mutex_unlock(&s1->self_group.mutex);
+			else
+				spin_unlock(&s1->self_group.lock);
 		}
+		if (s1 == s)	/* end */
+			break;
 	}
 	return res;
 }
@@ -1157,10 +1198,15 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 	int res;
 
 	down_read(&snd_pcm_link_rwsem);
+	res = snd_pcm_buffer_access_lock(substream->runtime);
+	if (res < 0)
+		goto unlock;
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, 0);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
+	snd_pcm_buffer_access_unlock(substream->runtime);
+ unlock:
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }
