Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91F75A4952
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiH2LXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiH2LWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:22:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E34175FD1;
        Mon, 29 Aug 2022 04:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBA69B80F93;
        Mon, 29 Aug 2022 11:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DB7C433D7;
        Mon, 29 Aug 2022 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771516;
        bh=d3JNQipKIVdMRMQCi6Ms0j33x+78SPG5tZ2w5RRVZ9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkv2o+zVfDa0InnPmXaGAOFZ7HDe3UZsDW399I4TE4jkKj1UuBLqxFOy9zYSiP6gU
         fQ9JobOUf2La4sptybEA53/AftrHRjyls4DcNbhzApMbbe6A3fep/wU5UPQmQ56Jnm
         B4mBGGviXP6nWRGPaiYZfrax0jzUVTg9v193RtSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 039/158] net: dsa: microchip: move tag_protocol to ksz_common
Date:   Mon, 29 Aug 2022 12:58:09 +0200
Message-Id: <20220829105810.422227660@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Arun Ramadoss <arun.ramadoss@microchip.com>

[ Upstream commit 534a0431e9e68959e2c0d71c141d5b911d66ad7c ]

This patch move the dsa hook get_tag_protocol to ksz_common file. And
the tag_protocol is returned based on the dev->chip_id.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c    | 13 +------------
 drivers/net/dsa/microchip/ksz9477.c    | 14 +-------------
 drivers/net/dsa/microchip/ksz_common.c | 24 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 4 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3cc51ee5fb6cc..041956e3c7b1a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -898,17 +898,6 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	}
 }
 
-static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
-						   int port,
-						   enum dsa_tag_protocol mp)
-{
-	struct ksz_device *dev = ds->priv;
-
-	/* ksz88x3 uses the same tag schema as KSZ9893 */
-	return ksz_is_ksz88x3(dev) ?
-		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
-}
-
 static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	/* Silicon Errata Sheet (DS80000830A):
@@ -1394,7 +1383,7 @@ static void ksz8_get_caps(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
-	.get_tag_protocol	= ksz8_get_tag_protocol,
+	.get_tag_protocol	= ksz_get_tag_protocol,
 	.get_phy_flags		= ksz8_sw_get_phy_flags,
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bcfdd505ca79a..31be767027feb 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -276,18 +276,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
-						      int port,
-						      enum dsa_tag_protocol mp)
-{
-	enum dsa_tag_protocol proto = DSA_TAG_PROTO_KSZ9477;
-	struct ksz_device *dev = ds->priv;
-
-	if (dev->features & IS_9893)
-		proto = DSA_TAG_PROTO_KSZ9893;
-	return proto;
-}
-
 static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
 {
 	struct ksz_device *dev = ds->priv;
@@ -1329,7 +1317,7 @@ static int ksz9477_setup(struct dsa_switch *ds)
 }
 
 static const struct dsa_switch_ops ksz9477_switch_ops = {
-	.get_tag_protocol	= ksz9477_get_tag_protocol,
+	.get_tag_protocol	= ksz_get_tag_protocol,
 	.setup			= ksz9477_setup,
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 4511e99823f57..0713a40685fa9 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -930,6 +930,30 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
+enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+					   int port, enum dsa_tag_protocol mp)
+{
+	struct ksz_device *dev = ds->priv;
+	enum dsa_tag_protocol proto = DSA_TAG_PROTO_NONE;
+
+	if (dev->chip_id == KSZ8795_CHIP_ID ||
+	    dev->chip_id == KSZ8794_CHIP_ID ||
+	    dev->chip_id == KSZ8765_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ8795;
+
+	if (dev->chip_id == KSZ8830_CHIP_ID ||
+	    dev->chip_id == KSZ9893_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ9893;
+
+	if (dev->chip_id == KSZ9477_CHIP_ID ||
+	    dev->chip_id == KSZ9897_CHIP_ID ||
+	    dev->chip_id == KSZ9567_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ9477;
+
+	return proto;
+}
+EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index e6bc5fb2b1303..21db6f79035fa 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -231,6 +231,8 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
 void ksz_get_strings(struct dsa_switch *ds, int port,
 		     u32 stringset, uint8_t *buf);
+enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+					   int port, enum dsa_tag_protocol mp);
 
 /* Common register access functions */
 
-- 
2.35.1



