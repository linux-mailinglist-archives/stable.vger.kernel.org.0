Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9B60FDB5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiJ0Q6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbiJ0Q6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB87F158D67
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EB1623F1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E99DC433D6;
        Thu, 27 Oct 2022 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889888;
        bh=Hu0Oi0y0GkM2j6CQGY4IuV17nKXhXprBWVNqOsK/s4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rENICUMqx4s9PtLjRc2CLSIf/wjFbhUTtHwf+0KSruFcay9rUOv4jlKLkrcgIMFt+
         ZRS6YsBzfjoWHr274RkA8jcBkTMmOsQFoRemhbpvq6V7yXfOz6BEdO1TowPKOD/qPO
         li+fLw6PnAUPAdg9PEMu5RE2FFyfpJjVgEScgpkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 37/94] net: dsa: qca8k: fix inband mgmt for big-endian systems
Date:   Thu, 27 Oct 2022 18:54:39 +0200
Message-Id: <20221027165058.602853581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit a2550d3ce53c68f54042bc5e468c4d07491ffe0e ]

The header and the data of the skb for the inband mgmt requires
to be in little-endian. This is problematic for big-endian system
as the mgmt header is written in the cpu byte order.

Fix this by converting each value for the mgmt header and data to
little-endian, and convert to cpu byte order the mgmt header and
data sent by the switch.

Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
Tested-by: Lech Perczak <lech.perczak@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Lech Perczak <lech.perczak@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 63 ++++++++++++++++++++++++--------
 include/linux/dsa/tag_qca.h      |  6 +--
 2 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index c181346388a4..c11d68185e7d 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -137,27 +137,42 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	struct qca8k_priv *priv = ds->priv;
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u32 command;
 	u8 len, cmd;
+	int i;
 
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
 	mgmt_eth_data = &priv->mgmt_eth_data;
 
-	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
-	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
+	command = get_unaligned_le32(&mgmt_ethhdr->command);
+	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
+	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
 
 	/* Make sure the seq match the requested packet */
-	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
+	if (get_unaligned_le32(&mgmt_ethhdr->seq) == mgmt_eth_data->seq)
 		mgmt_eth_data->ack = true;
 
 	if (cmd == MDIO_READ) {
-		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
+		u32 *val = mgmt_eth_data->data;
+
+		*val = get_unaligned_le32(&mgmt_ethhdr->mdio_data);
 
 		/* Get the rest of the 12 byte of data.
 		 * The read/write function will extract the requested data.
 		 */
-		if (len > QCA_HDR_MGMT_DATA1_LEN)
-			memcpy(mgmt_eth_data->data + 1, skb->data,
-			       QCA_HDR_MGMT_DATA2_LEN);
+		if (len > QCA_HDR_MGMT_DATA1_LEN) {
+			__le32 *data2 = (__le32 *)skb->data;
+			int data_len = min_t(int, QCA_HDR_MGMT_DATA2_LEN,
+					     len - QCA_HDR_MGMT_DATA1_LEN);
+
+			val++;
+
+			for (i = sizeof(u32); i <= data_len; i += sizeof(u32)) {
+				*val = get_unaligned_le32(data2);
+				val++;
+				data2++;
+			}
+		}
 	}
 
 	complete(&mgmt_eth_data->rw_done);
@@ -169,8 +184,10 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
 	unsigned int real_len;
 	struct sk_buff *skb;
-	u32 *data2;
+	__le32 *data2;
+	u32 command;
 	u16 hdr;
+	int i;
 
 	skb = dev_alloc_skb(QCA_HDR_MGMT_PKT_LEN);
 	if (!skb)
@@ -199,20 +216,32 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
 
-	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
+	command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
+	command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
+	command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
+	command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
 					   QCA_HDR_MGMT_CHECK_CODE_VAL);
 
+	put_unaligned_le32(command, &mgmt_ethhdr->command);
+
 	if (cmd == MDIO_WRITE)
-		mgmt_ethhdr->mdio_data = *val;
+		put_unaligned_le32(*val, &mgmt_ethhdr->mdio_data);
 
 	mgmt_ethhdr->hdr = htons(hdr);
 
 	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
-	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
-		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN) {
+		int data_len = min_t(int, QCA_HDR_MGMT_DATA2_LEN,
+				     len - QCA_HDR_MGMT_DATA1_LEN);
+
+		val++;
+
+		for (i = sizeof(u32); i <= data_len; i += sizeof(u32)) {
+			put_unaligned_le32(*val, data2);
+			data2++;
+			val++;
+		}
+	}
 
 	return skb;
 }
@@ -220,9 +249,11 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
 {
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u32 seq;
 
+	seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb->data;
-	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
+	put_unaligned_le32(seq, &mgmt_ethhdr->seq);
 }
 
 static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 50be7cbd93a5..0e176da1e43f 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -61,9 +61,9 @@ struct sk_buff;
 
 /* Special struct emulating a Ethernet header */
 struct qca_mgmt_ethhdr {
-	u32 command;		/* command bit 31:0 */
-	u32 seq;		/* seq 63:32 */
-	u32 mdio_data;		/* first 4byte mdio */
+	__le32 command;		/* command bit 31:0 */
+	__le32 seq;		/* seq 63:32 */
+	__le32 mdio_data;		/* first 4byte mdio */
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
-- 
2.35.1



