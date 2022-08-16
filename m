Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9729D59516B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiHPE5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiHPE4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE9BB6BB;
        Mon, 15 Aug 2022 13:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FCECB811A6;
        Mon, 15 Aug 2022 20:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A61C433D6;
        Mon, 15 Aug 2022 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596644;
        bh=ojXpPZh/ik84UpWua9/tZpxCm24Ecm+E56/QMq1bOJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJamnue2bnKwUYWPaxevfoklPkTfk3Vz3EDLzPlRBAaAT/ytSby/IRN/+/ooyv0ep
         AaujdUdAgWiJZGZRdr2I7QOGb4G+quoWZVqW+nv63sFLC7vXLWtptefo6sVKWcJqvw
         FHpnR4WCffPI9YzGbAHz1ZteLZeyrxtivpW9wp4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 5.19 1145/1157] Revert "devcoredump: remove the useless gfp_t parameter in dev_coredumpv and dev_coredumpm"
Date:   Mon, 15 Aug 2022 20:08:21 +0200
Message-Id: <20220815180526.304886042@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 38a523a2946d3a0961d141d477a1ee2b1f3bdbb1 upstream.

This reverts commit 77515ebaf01920e2db49e04672ef669a7c2907f2 as it
causes build problems in linux-next.  It needs to be reintroduced in a
way that can allow the api to evolve and not require a "flag day" to
catch all users.

Link: https://lore.kernel.org/r/20220623160723.7a44b573@canb.auug.org.au
Cc: Duoming Zhou <duoming@zju.edu.cn>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devcoredump.c                               |   16 +++++++++------
 drivers/bluetooth/btmrvl_sdio.c                          |    2 -
 drivers/bluetooth/hci_qca.c                              |    2 -
 drivers/gpu/drm/etnaviv/etnaviv_dump.c                   |    2 -
 drivers/gpu/drm/msm/disp/msm_disp_snapshot.c             |    4 +--
 drivers/gpu/drm/msm/msm_gpu.c                            |    4 +--
 drivers/media/platform/qcom/venus/core.c                 |    2 -
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c           |    2 -
 drivers/net/wireless/ath/ath10k/coredump.c               |    2 -
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c        |    2 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c |    2 -
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c              |    6 +++--
 drivers/net/wireless/marvell/mwifiex/main.c              |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c          |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c          |    3 +-
 drivers/net/wireless/realtek/rtw88/main.c                |    2 -
 drivers/net/wireless/realtek/rtw89/ser.c                 |    2 -
 drivers/remoteproc/qcom_q6v5_mss.c                       |    2 -
 drivers/remoteproc/remoteproc_coredump.c                 |    8 +++----
 include/drm/drm_print.h                                  |    2 -
 include/linux/devcoredump.h                              |   13 ++++++------
 sound/soc/intel/avs/apl.c                                |    2 -
 sound/soc/intel/avs/skl.c                                |    2 -
 sound/soc/intel/catpt/dsp.c                              |    2 -
 24 files changed, 50 insertions(+), 40 deletions(-)

--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -173,13 +173,15 @@ static void devcd_freev(void *data)
  * @dev: the struct device for the crashed device
  * @data: vmalloc data containing the device coredump
  * @datalen: length of the data
+ * @gfp: allocation flags
  *
  * This function takes ownership of the vmalloc'ed data and will free
  * it when it is no longer used. See dev_coredumpm() for more information.
  */
-void dev_coredumpv(struct device *dev, void *data, size_t datalen)
+void dev_coredumpv(struct device *dev, void *data, size_t datalen,
+		   gfp_t gfp)
 {
-	dev_coredumpm(dev, NULL, data, datalen, devcd_readv, devcd_freev);
+	dev_coredumpm(dev, NULL, data, datalen, gfp, devcd_readv, devcd_freev);
 }
 EXPORT_SYMBOL_GPL(dev_coredumpv);
 
@@ -234,6 +236,7 @@ static ssize_t devcd_read_from_sgtable(c
  * @owner: the module that contains the read/free functions, use %THIS_MODULE
  * @data: data cookie for the @read/@free functions
  * @datalen: length of the data
+ * @gfp: allocation flags
  * @read: function to read from the given buffer
  * @free: function to free the given buffer
  *
@@ -243,7 +246,7 @@ static ssize_t devcd_read_from_sgtable(c
  * function will be called to free the data.
  */
 void dev_coredumpm(struct device *dev, struct module *owner,
-		   void *data, size_t datalen,
+		   void *data, size_t datalen, gfp_t gfp,
 		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 				   void *data, size_t datalen),
 		   void (*free)(void *data))
@@ -265,7 +268,7 @@ void dev_coredumpm(struct device *dev, s
 	if (!try_module_get(owner))
 		goto free;
 
-	devcd = kzalloc(sizeof(*devcd), GFP_KERNEL);
+	devcd = kzalloc(sizeof(*devcd), gfp);
 	if (!devcd)
 		goto put_module;
 
@@ -315,6 +318,7 @@ EXPORT_SYMBOL_GPL(dev_coredumpm);
  * @dev: the struct device for the crashed device
  * @table: the dump data
  * @datalen: length of the data
+ * @gfp: allocation flags
  *
  * Creates a new device coredump for the given device. If a previous one hasn't
  * been read yet, the new coredump is discarded. The data lifetime is determined
@@ -322,9 +326,9 @@ EXPORT_SYMBOL_GPL(dev_coredumpm);
  * it will free the data.
  */
 void dev_coredumpsg(struct device *dev, struct scatterlist *table,
-		    size_t datalen)
+		    size_t datalen, gfp_t gfp)
 {
-	dev_coredumpm(dev, NULL, table, datalen, devcd_read_from_sgtable,
+	dev_coredumpm(dev, NULL, table, datalen, gfp, devcd_read_from_sgtable,
 		      devcd_free_sgtable);
 }
 EXPORT_SYMBOL_GPL(dev_coredumpsg);
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1515,7 +1515,7 @@ done:
 	/* fw_dump_data will be free in device coredump release function
 	 * after 5 min
 	 */
-	dev_coredumpv(&card->func->dev, fw_dump_data, fw_dump_len);
+	dev_coredumpv(&card->func->dev, fw_dump_data, fw_dump_len, GFP_KERNEL);
 	BT_INFO("== btmrvl firmware dump to /sys/class/devcoredump end");
 }
 
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1120,7 +1120,7 @@ static void qca_controller_memdump(struc
 				    qca_memdump->ram_dump_size);
 			memdump_buf = qca_memdump->memdump_buf_head;
 			dev_coredumpv(&hu->serdev->dev, memdump_buf,
-				      qca_memdump->received_dump);
+				      qca_memdump->received_dump, GFP_KERNEL);
 			cancel_delayed_work(&qca->ctrl_memdump_timeout);
 			kfree(qca->qca_memdump);
 			qca->qca_memdump = NULL;
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -225,5 +225,5 @@ void etnaviv_core_dump(struct etnaviv_ge
 
 	etnaviv_core_dump_header(&iter, ETDUMP_BUF_END, iter.data);
 
-	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start);
+	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start, GFP_KERNEL);
 }
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot.c
@@ -74,8 +74,8 @@ static void _msm_disp_snapshot_work(stru
 	 * If there is a codedump pending for the device, the dev_coredumpm()
 	 * will also free new coredump state.
 	 */
-	dev_coredumpm(disp_state->dev, THIS_MODULE, disp_state, 0,
-		      disp_devcoredump_read, msm_disp_state_free);
+	dev_coredumpm(disp_state->dev, THIS_MODULE, disp_state, 0, GFP_KERNEL,
+			disp_devcoredump_read, msm_disp_state_free);
 }
 
 void msm_disp_snapshot_state(struct drm_device *drm_dev)
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -299,8 +299,8 @@ static void msm_gpu_crashstate_capture(s
 	gpu->crashstate = state;
 
 	/* FIXME: Release the crashstate if this errors out? */
-	dev_coredumpm(gpu->dev->dev, THIS_MODULE, gpu, 0,
-		      msm_gpu_devcoredump_read, msm_gpu_devcoredump_free);
+	dev_coredumpm(gpu->dev->dev, THIS_MODULE, gpu, 0, GFP_KERNEL,
+		msm_gpu_devcoredump_read, msm_gpu_devcoredump_free);
 }
 #else
 static void msm_gpu_crashstate_capture(struct msm_gpu *gpu,
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -49,7 +49,7 @@ static void venus_coredump(struct venus_
 
 	memcpy(data, mem_va, mem_size);
 	memunmap(mem_va);
-	dev_coredumpv(dev, data, mem_size);
+	dev_coredumpv(dev, data, mem_size, GFP_KERNEL);
 }
 
 static void venus_event_notify(struct venus_core *core, u32 event)
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
@@ -281,5 +281,5 @@ void mcp251xfd_dump(const struct mcp251x
 	mcp251xfd_dump_end(priv, &iter);
 
 	dev_coredumpv(&priv->spi->dev, iter.start,
-		      iter.data - iter.start);
+		      iter.data - iter.start, GFP_KERNEL);
 }
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1607,7 +1607,7 @@ int ath10k_coredump_submit(struct ath10k
 		return -ENODATA;
 	}
 
-	dev_coredumpv(ar->dev, dump, le32_to_cpu(dump->len));
+	dev_coredumpv(ar->dev, dump, le32_to_cpu(dump->len), GFP_KERNEL);
 
 	return 0;
 }
--- a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
+++ b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
@@ -117,6 +117,6 @@ void wil_fw_core_dump(struct wil6210_pri
 	/* fw_dump_data will be free in device coredump release function
 	 * after 5 min
 	 */
-	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size);
+	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size, GFP_KERNEL);
 	wil_info(wil, "fw core dumped, size %d bytes\n", fw_dump_size);
 }
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -37,7 +37,7 @@ int brcmf_debug_create_memdump(struct br
 		return err;
 	}
 
-	dev_coredumpv(bus->dev, dump, len + ramsize);
+	dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
 
 	return 0;
 }
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2601,7 +2601,8 @@ static void iwl_fw_error_dump(struct iwl
 					     fw_error_dump.trans_ptr->data,
 					     fw_error_dump.trans_ptr->len,
 					     fw_error_dump.fwrt_len);
-		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len);
+		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
+			       GFP_KERNEL);
 	}
 	vfree(fw_error_dump.fwrt_ptr);
 	vfree(fw_error_dump.trans_ptr);
@@ -2646,7 +2647,8 @@ static void iwl_fw_error_ini_dump(struct
 					     entry->data, entry->size, offs);
 			offs += entry->size;
 		}
-		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len);
+		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
+			       GFP_KERNEL);
 	}
 	iwl_dump_ini_list_free(&dump_list);
 }
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1115,7 +1115,8 @@ void mwifiex_upload_device_dump(struct m
 	 */
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump start\n");
-	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len);
+	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len,
+		      GFP_KERNEL);
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump end\n");
 
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2422,5 +2422,6 @@ void mt7615_coredump_work(struct work_st
 
 		dev_kfree_skb(skb);
 	}
-	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ);
+	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
+		      GFP_KERNEL);
 }
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1419,7 +1419,8 @@ void mt7921_coredump_work(struct work_st
 	}
 
 	if (dump)
-		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ);
+		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
+			      GFP_KERNEL);
 
 	mt7921_reset(&dev->mt76);
 }
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -414,7 +414,7 @@ static void rtw_fwcd_dump(struct rtw_dev
 	 * framework. Note that a new dump will be discarded if a previous one
 	 * hasn't been released yet.
 	 */
-	dev_coredumpv(rtwdev->dev, desc->data, desc->size);
+	dev_coredumpv(rtwdev->dev, desc->data, desc->size, GFP_KERNEL);
 }
 
 static void rtw_fwcd_free(struct rtw_dev *rtwdev, bool free_self)
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -127,7 +127,7 @@ static void rtw89_ser_cd_send(struct rtw
 	 * will be discarded if a previous one hasn't been released by
 	 * framework yet.
 	 */
-	dev_coredumpv(rtwdev->dev, buf, sizeof(*buf));
+	dev_coredumpv(rtwdev->dev, buf, sizeof(*buf), GFP_KERNEL);
 }
 
 static void rtw89_ser_cd_free(struct rtw89_dev *rtwdev,
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -597,7 +597,7 @@ static void q6v5_dump_mba_logs(struct q6
 	data = vmalloc(MBA_LOG_SIZE);
 	if (data) {
 		memcpy(data, mba_region, MBA_LOG_SIZE);
-		dev_coredumpv(&rproc->dev, data, MBA_LOG_SIZE);
+		dev_coredumpv(&rproc->dev, data, MBA_LOG_SIZE, GFP_KERNEL);
 	}
 	memunmap(mba_region);
 }
--- a/drivers/remoteproc/remoteproc_coredump.c
+++ b/drivers/remoteproc/remoteproc_coredump.c
@@ -309,7 +309,7 @@ void rproc_coredump(struct rproc *rproc)
 		phdr += elf_size_of_phdr(class);
 	}
 	if (dump_conf == RPROC_COREDUMP_ENABLED) {
-		dev_coredumpv(&rproc->dev, data, data_size);
+		dev_coredumpv(&rproc->dev, data, data_size, GFP_KERNEL);
 		return;
 	}
 
@@ -318,7 +318,7 @@ void rproc_coredump(struct rproc *rproc)
 	dump_state.header = data;
 	init_completion(&dump_state.dump_done);
 
-	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size,
+	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size, GFP_KERNEL,
 		      rproc_coredump_read, rproc_coredump_free);
 
 	/*
@@ -449,7 +449,7 @@ void rproc_coredump_using_sections(struc
 	}
 
 	if (dump_conf == RPROC_COREDUMP_ENABLED) {
-		dev_coredumpv(&rproc->dev, data, data_size);
+		dev_coredumpv(&rproc->dev, data, data_size, GFP_KERNEL);
 		return;
 	}
 
@@ -458,7 +458,7 @@ void rproc_coredump_using_sections(struc
 	dump_state.header = data;
 	init_completion(&dump_state.dump_done);
 
-	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size,
+	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size, GFP_KERNEL,
 		      rproc_coredump_read, rproc_coredump_free);
 
 	/* Wait until the dump is read and free is called. Data is freed
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -162,7 +162,7 @@ struct drm_print_iterator {
  *	void makecoredump(...)
  *	{
  *		...
- *		dev_coredumpm(dev, THIS_MODULE, data, 0,
+ *		dev_coredumpm(dev, THIS_MODULE, data, 0, GFP_KERNEL,
  *			coredump_read, ...)
  *	}
  *
--- a/include/linux/devcoredump.h
+++ b/include/linux/devcoredump.h
@@ -52,26 +52,27 @@ static inline void _devcd_free_sgtable(s
 
 
 #ifdef CONFIG_DEV_COREDUMP
-void dev_coredumpv(struct device *dev, void *data, size_t datalen);
+void dev_coredumpv(struct device *dev, void *data, size_t datalen,
+		   gfp_t gfp);
 
 void dev_coredumpm(struct device *dev, struct module *owner,
-		   void *data, size_t datalen,
+		   void *data, size_t datalen, gfp_t gfp,
 		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 				   void *data, size_t datalen),
 		   void (*free)(void *data));
 
 void dev_coredumpsg(struct device *dev, struct scatterlist *table,
-		    size_t datalen);
+		    size_t datalen, gfp_t gfp);
 #else
 static inline void dev_coredumpv(struct device *dev, void *data,
-				 size_t datalen)
+				 size_t datalen, gfp_t gfp)
 {
 	vfree(data);
 }
 
 static inline void
 dev_coredumpm(struct device *dev, struct module *owner,
-	      void *data, size_t datalen,
+	      void *data, size_t datalen, gfp_t gfp,
 	      ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 			      void *data, size_t datalen),
 	      void (*free)(void *data))
@@ -80,7 +81,7 @@ dev_coredumpm(struct device *dev, struct
 }
 
 static inline void dev_coredumpsg(struct device *dev, struct scatterlist *table,
-				  size_t datalen)
+				  size_t datalen, gfp_t gfp)
 {
 	_devcd_free_sgtable(table);
 }
--- a/sound/soc/intel/avs/apl.c
+++ b/sound/soc/intel/avs/apl.c
@@ -164,7 +164,7 @@ static int apl_coredump(struct avs_dev *
 	} while (offset < msg->ext.coredump.stack_dump_size);
 
 exit:
-	dev_coredumpv(adev->dev, dump, dump_size);
+	dev_coredumpv(adev->dev, dump, dump_size, GFP_KERNEL);
 
 	return 0;
 }
--- a/sound/soc/intel/avs/skl.c
+++ b/sound/soc/intel/avs/skl.c
@@ -88,7 +88,7 @@ static int skl_coredump(struct avs_dev *
 		return -ENOMEM;
 
 	memcpy_fromio(dump, avs_sram_addr(adev, AVS_FW_REGS_WINDOW), AVS_FW_REGS_SIZE);
-	dev_coredumpv(adev->dev, dump, AVS_FW_REGS_SIZE);
+	dev_coredumpv(adev->dev, dump, AVS_FW_REGS_SIZE, GFP_KERNEL);
 
 	return 0;
 }
--- a/sound/soc/intel/catpt/dsp.c
+++ b/sound/soc/intel/catpt/dsp.c
@@ -539,7 +539,7 @@ int catpt_coredump(struct catpt_dev *cde
 		pos += CATPT_DMA_REGS_SIZE;
 	}
 
-	dev_coredumpv(cdev->dev, dump, dump_size);
+	dev_coredumpv(cdev->dev, dump, dump_size, GFP_KERNEL);
 
 	return 0;
 }


