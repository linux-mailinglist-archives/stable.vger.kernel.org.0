Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4EE60F599
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiJ0Kom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbiJ0Kom (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:44:42 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC4217889
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666867481; x=1698403481;
  h=from:to:cc:subject:date:message-id;
  bh=FkmfML8jbwWv3zwseungaAawgXZhGUJV4KVbQwdDk7M=;
  b=nQK+t8c8yq9PioEPRtcxhRi2MYxlA7KhryQvMOAoJ8Qa/QJkDOMbXvZZ
   uy2ABJSiLR0dJ5ZPtb3qY5eo28E4PbTuaxU6GY1F2sLo8beiMhRv4UM9Y
   gTfixDobwrzFY4z7WBJyTB177VjinqZ5A4m/hh/F/zvR2pL2k/dFN0e7+
   u6/NmSmPSKUoA5bfQF/fF5kun4dhIvIyAMNuUjbkrW1TIOEk5IN3ahxOM
   5hk8dgCn2z2cx2EwN5kfd9XMRibTOx+oqfWieAbo4meneGB9p+KQhmnsB
   MZ6f7GwyBZSvZ/+X+2SZvIiIfI3oxGRIsYjW6VosN6BbjJDVe0EbtIaGR
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,217,1661788800"; 
   d="scan'208";a="215225727"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 18:44:38 +0800
IronPort-SDR: mThhllw9tJ63YYa/x19yJawdyNkdbR3J0uxfWB1ypWgStOPVAXOjCWkBA9uI8xVHQrlvKOe3Yl
 QnMGly9kLQae3/u/TgGOIAqeTOcJukf970XTPePFSiacfLNY3NuToOT1yQKqZ84zSIQsqNXj3Q
 fg3Ak7BWUPB/63JVTHTYEyHdFClDnsVQ2fWQUR1WfvxQdsMVg1Nqo+TKy6iBoXk1DbZLFV1/d8
 8CJa/PlT/2zE8Y/V+k50kBgAemjXrwrPZ5UWqJAWhT1N+IS3iajaPmceNbwL0ruG16RGNhTVVO
 y7rrAX1njCgRVx3RBRhgotBV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2022 02:58:17 -0700
IronPort-SDR: XdJAbXKoElacGOhlroFLCKhBUayVyYOVzqfz+onyYU9+PIqgYnt0GwvbsAcX7W1T3B1K3ZFsdy
 OMCegI7imBHcjWIMoLrTO5Cwmer639g/a0x1jO/MkGOyNflOD104i8jC9R9A4NtlHcGgpdz0dx
 yXB5BUhXJNMPcmEVGcDfviaODTykAjL/gbVYPptzWExT5gpXsQ+/HvytHPO5CaRVjGuhzPXmps
 PnOeV1BLqOnfcYfjhBnJSpxdp4XEKVUAgq7Rj8TTzrd4jYzl5fsvnSfvKBsTE1PBPzdLxW0m2p
 jyU=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.30.255])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Oct 2022 03:44:37 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH Backport 5.10-stable] mmc: core: Add SD card quirk for broken discard
Date:   Thu, 27 Oct 2022 13:44:23 +0300
Message-Id: <20221027104423.517-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 07d2872bf4c8 ]

Some SD-cards from Sandisk that are SDA-6.0 compliant reports they supports
discard, while they actually don't. This might cause mk2fs to fail while
trying to format the card and revert it to a read-only mode.

To fix this problem, let's add a card quirk (MMC_QUIRK_BROKEN_SD_DISCARD)
to indicate that we shall fall-back to use the legacy erase command
instead.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220928095744.16455-1-avri.altman@wdc.com
[Ulf: Updated the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/block.c  | 7 ++++++-
 drivers/mmc/core/card.h   | 6 ++++++
 drivers/mmc/core/quirks.h | 6 ++++++
 include/linux/mmc/card.h  | 1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 8d3df0be0355..9163b7a26e56 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1050,6 +1050,11 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	nr = blk_rq_sectors(req);
 
 	do {
+		unsigned int erase_arg = card->erase_arg;
+
+		if (mmc_card_broken_sd_discard(card))
+			erase_arg = SD_ERASE_ARG;
+
 		err = 0;
 		if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -1060,7 +1065,7 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
-			err = mmc_erase(card, from, nr, card->erase_arg);
+			err = mmc_erase(card, from, nr, erase_arg);
 	} while (err == -EIO && !mmc_blk_reset(md, card->host, type));
 	if (err)
 		status = BLK_STS_IOERR;
diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 7bd392d55cfa..5c6986131faf 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -70,6 +70,7 @@ struct mmc_fixup {
 #define EXT_CSD_REV_ANY (-1u)
 
 #define CID_MANFID_SANDISK      0x2
+#define CID_MANFID_SANDISK_SD   0x3
 #define CID_MANFID_ATP          0x9
 #define CID_MANFID_TOSHIBA      0x11
 #define CID_MANFID_MICRON       0x13
@@ -222,4 +223,9 @@ static inline int mmc_card_broken_hpi(const struct mmc_card *c)
 	return c->quirks & MMC_QUIRK_BROKEN_HPI;
 }
 
+static inline int mmc_card_broken_sd_discard(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BROKEN_SD_DISCARD;
+}
+
 #endif
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index d68e6e513a4f..c8c0f50a2076 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -99,6 +99,12 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 	MMC_FIXUP("V10016", CID_MANFID_KINGSTON, CID_OEMID_ANY, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
 
+	/*
+	 * Some SD cards reports discard support while they don't
+	 */
+	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
+		  MMC_QUIRK_BROKEN_SD_DISCARD),
+
 	END_FIXUP
 };
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 42df06c6b19c..ef870d1f4f5f 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -270,6 +270,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_IRQ_POLLING	(1<<11)	/* Polling SDIO_CCCR_INTx could create a fake interrupt */
 #define MMC_QUIRK_TRIM_BROKEN	(1<<12)		/* Skip trim */
 #define MMC_QUIRK_BROKEN_HPI	(1<<13)		/* Disable broken HPI support */
+#define MMC_QUIRK_BROKEN_SD_DISCARD	(1<<14)	/* Disable broken SD discard support */
 
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
 
-- 
2.17.1

