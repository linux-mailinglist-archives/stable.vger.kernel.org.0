Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8463582E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbiKWJwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbiKWJvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1893E1BEF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AEC2B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A5C433C1;
        Wed, 23 Nov 2022 09:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196898;
        bh=Mj0Dibo5NJ9JLM9UW1yITq7awWO2TLW20TY3ZnCDkMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiAABb7U1hoYolSnoQ4EYfUi52OS34vLELQtNrDmnDrS4b71rHKy9C0ZI2G6bMBDn
         43SgAEvE2YaIhJl4NExprWrqwXlhgHgtOH9XRaGb60tvEyvYNfFqKriYcLEp+W1XN+
         cOiepNM0Vz1j93ZEIchMabBHvJLTFjk/xuiSQeGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jian Zhang <zhangjian.3032@bytedance.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 153/314] mctp i2c: dont count unused / invalid keys for flow release
Date:   Wed, 23 Nov 2022 09:49:58 +0100
Message-Id: <20221123084632.499341272@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 9cbd48d5fa14e4c65f8580de16686077f7cea02b ]

We're currently hitting the WARN_ON in mctp_i2c_flow_release:

    if (midev->release_count > midev->i2c_lock_count) {
        WARN_ONCE(1, "release count overflow");

This may be hit if we expire a flow before sending the first packet it
contains - as we will not be pairing the increment of release_count
(performed on flow release) with the i2c lock operation (only
performed on actual TX).

To fix this, only release a flow if we've encountered it previously (ie,
dev_flow_state does not indicate NEW), as we will mark the flow as
ACTIVE at the same time as accounting for the i2c lock operation. We
also need to add an INVALID flow state, to indicate when we've done the
release.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Reported-by: Jian Zhang <zhangjian.3032@bytedance.com>
Tested-by: Jian Zhang <zhangjian.3032@bytedance.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20221110053135.329071-1-jk@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 47 +++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 53846c6b56ca..aca3697b0962 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -43,6 +43,7 @@
 enum {
 	MCTP_I2C_FLOW_STATE_NEW = 0,
 	MCTP_I2C_FLOW_STATE_ACTIVE,
+	MCTP_I2C_FLOW_STATE_INVALID,
 };
 
 /* List of all struct mctp_i2c_client
@@ -374,12 +375,18 @@ mctp_i2c_get_tx_flow_state(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 	 */
 	if (!key->valid) {
 		state = MCTP_I2C_TX_FLOW_INVALID;
-
-	} else if (key->dev_flow_state == MCTP_I2C_FLOW_STATE_NEW) {
-		key->dev_flow_state = MCTP_I2C_FLOW_STATE_ACTIVE;
-		state = MCTP_I2C_TX_FLOW_NEW;
 	} else {
-		state = MCTP_I2C_TX_FLOW_EXISTING;
+		switch (key->dev_flow_state) {
+		case MCTP_I2C_FLOW_STATE_NEW:
+			key->dev_flow_state = MCTP_I2C_FLOW_STATE_ACTIVE;
+			state = MCTP_I2C_TX_FLOW_NEW;
+			break;
+		case MCTP_I2C_FLOW_STATE_ACTIVE:
+			state = MCTP_I2C_TX_FLOW_EXISTING;
+			break;
+		default:
+			state = MCTP_I2C_TX_FLOW_INVALID;
+		}
 	}
 
 	spin_unlock_irqrestore(&key->lock, flags);
@@ -617,21 +624,31 @@ static void mctp_i2c_release_flow(struct mctp_dev *mdev,
 
 {
 	struct mctp_i2c_dev *midev = netdev_priv(mdev->dev);
+	bool queue_release = false;
 	unsigned long flags;
 
 	spin_lock_irqsave(&midev->lock, flags);
-	midev->release_count++;
-	spin_unlock_irqrestore(&midev->lock, flags);
-
-	/* Ensure we have a release operation queued, through the fake
-	 * marker skb
+	/* if we have seen the flow/key previously, we need to pair the
+	 * original lock with a release
 	 */
-	spin_lock(&midev->tx_queue.lock);
-	if (!midev->unlock_marker.next)
-		__skb_queue_tail(&midev->tx_queue, &midev->unlock_marker);
-	spin_unlock(&midev->tx_queue.lock);
+	if (key->dev_flow_state == MCTP_I2C_FLOW_STATE_ACTIVE) {
+		midev->release_count++;
+		queue_release = true;
+	}
+	key->dev_flow_state = MCTP_I2C_FLOW_STATE_INVALID;
+	spin_unlock_irqrestore(&midev->lock, flags);
 
-	wake_up(&midev->tx_wq);
+	if (queue_release) {
+		/* Ensure we have a release operation queued, through the fake
+		 * marker skb
+		 */
+		spin_lock(&midev->tx_queue.lock);
+		if (!midev->unlock_marker.next)
+			__skb_queue_tail(&midev->tx_queue,
+					 &midev->unlock_marker);
+		spin_unlock(&midev->tx_queue.lock);
+		wake_up(&midev->tx_wq);
+	}
 }
 
 static const struct net_device_ops mctp_i2c_ops = {
-- 
2.35.1



