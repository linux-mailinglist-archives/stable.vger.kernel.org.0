Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030C860FDB6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiJ0Q6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbiJ0Q6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB913B87A2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1442B826F9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068A4C433B5;
        Thu, 27 Oct 2022 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889891;
        bh=7ZN4BYVLANYc4gosrRkji40C8G4JL6ej9L3YFGk2wak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3LidTIpBvxsdyKG6Hwlgnu4//p1z4EJZWKbRwlYo7uIOSBz2sVCHP7xuBVgKGw03
         QbwXn/vjC0YsYwYANU/eZH7UVRjU2wt9YBr7NmPFbNlPq9Jaibos2Kclwm14iZRRIT
         1r+VPGBA/nIcT2eXP+QttojbiRvdHa5ZjzX6nCPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 38/94] net: dsa: qca8k: fix ethtool autocast mib for big-endian systems
Date:   Thu, 27 Oct 2022 18:54:40 +0200
Message-Id: <20221027165058.651273563@linuxfoundation.org>
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

[ Upstream commit 0d4636f7d72df3179b20a2d32b647881917a5e2a ]

The switch sends autocast mib in little-endian. This is problematic for
big-endian system as the values needs to be converted.

Fix this by converting each mib value to cpu byte order.

Fixes: 5c957c7ca78c ("net: dsa: qca8k: add support for mib autocast in Ethernet packet")
Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
Tested-by: Lech Perczak <lech.perczak@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 20 ++++++++------------
 include/linux/dsa/tag_qca.h      |  2 +-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index c11d68185e7d..300c9345ee2b 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1518,9 +1518,9 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	struct qca8k_priv *priv = ds->priv;
 	const struct qca8k_mib_desc *mib;
 	struct mib_ethhdr *mib_ethhdr;
-	int i, mib_len, offset = 0;
-	u64 *data;
+	__le32 *data2;
 	u8 port;
+	int i;
 
 	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
 	mib_eth_data = &priv->mib_eth_data;
@@ -1532,28 +1532,24 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	if (port != mib_eth_data->req_port)
 		goto exit;
 
-	data = mib_eth_data->data;
+	data2 = (__le32 *)skb->data;
 
 	for (i = 0; i < priv->info->mib_count; i++) {
 		mib = &ar8327_mib[i];
 
 		/* First 3 mib are present in the skb head */
 		if (i < 3) {
-			data[i] = mib_ethhdr->data[i];
+			mib_eth_data->data[i] = get_unaligned_le32(mib_ethhdr->data + i);
 			continue;
 		}
 
-		mib_len = sizeof(uint32_t);
-
 		/* Some mib are 64 bit wide */
 		if (mib->size == 2)
-			mib_len = sizeof(uint64_t);
-
-		/* Copy the mib value from packet to the */
-		memcpy(data + i, skb->data + offset, mib_len);
+			mib_eth_data->data[i] = get_unaligned_le64((__le64 *)data2);
+		else
+			mib_eth_data->data[i] = get_unaligned_le32(data2);
 
-		/* Set the offset for the next mib */
-		offset += mib_len;
+		data2 += mib->size;
 	}
 
 exit:
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 0e176da1e43f..b1b5720d89a5 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -73,7 +73,7 @@ enum mdio_cmd {
 };
 
 struct mib_ethhdr {
-	u32 data[3];		/* first 3 mib counter */
+	__le32 data[3];		/* first 3 mib counter */
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
-- 
2.35.1



