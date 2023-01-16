Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E94866C920
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbjAPQqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbjAPQpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB59E1A943
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 677C66104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757A2C433F1;
        Mon, 16 Jan 2023 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886822;
        bh=cX34OYYI8zhcVtfNcqMZjcKBsFtWFO5hCYW5EYiikQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYT2akIkCGFYKZoPKMG3m4bLRgqUXAGVlPnhyJdjtfEnERurE1ucA59tBw97wilyw
         +oMCwH8hs3ca16ghdWMEMK1hsynczUijRIgEwL1OLMU5sIoYYt1s39LxpxwYp4gYpU
         X4tOlhI+XqWjBpnfBGmLq/yZZ4udZu6JmVud3Gd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 574/658] nfc: Fix potential resource leaks
Date:   Mon, 16 Jan 2023 16:51:02 +0100
Message-Id: <20230116154935.769386673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit df49908f3c52d211aea5e2a14a93bbe67a2cb3af ]

nfc_get_device() take reference for the device, add missing
nfc_put_device() to release it when not need anymore.
Also fix the style warnning by use error EOPNOTSUPP instead of
ENOTSUPP.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Fixes: 29e76924cf08 ("nfc: netlink: Add capability to reply to vendor_cmd with data")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/netlink.c | 52 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 9e94f732e717..b53d5eb86864 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1505,6 +1505,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	u32 dev_idx, se_idx;
 	u8 *apdu;
 	size_t apdu_len;
+	int rc;
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 	    !info->attrs[NFC_ATTR_SE_INDEX] ||
@@ -1518,25 +1519,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	if (!dev->ops || !dev->ops->se_io)
-		return -ENOTSUPP;
+	if (!dev->ops || !dev->ops->se_io) {
+		rc = -EOPNOTSUPP;
+		goto put_dev;
+	}
 
 	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
-	if (apdu_len == 0)
-		return -EINVAL;
+	if (apdu_len == 0) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
-	if (!apdu)
-		return -EINVAL;
+	if (!apdu) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto put_dev;
+	}
 
 	ctx->dev_idx = dev_idx;
 	ctx->se_idx = se_idx;
 
-	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+	rc = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+
+put_dev:
+	nfc_put_device(dev);
+	return rc;
 }
 
 static int nfc_genl_vendor_cmd(struct sk_buff *skb,
@@ -1559,14 +1572,21 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 	subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
 
 	dev = nfc_get_device(dev_idx);
-	if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
+	if (!dev)
 		return -ENODEV;
 
+	if (!dev->vendor_cmds || !dev->n_vendor_cmds) {
+		err = -ENODEV;
+		goto put_dev;
+	}
+
 	if (info->attrs[NFC_ATTR_VENDOR_DATA]) {
 		data = nla_data(info->attrs[NFC_ATTR_VENDOR_DATA]);
 		data_len = nla_len(info->attrs[NFC_ATTR_VENDOR_DATA]);
-		if (data_len == 0)
-			return -EINVAL;
+		if (data_len == 0) {
+			err = -EINVAL;
+			goto put_dev;
+		}
 	} else {
 		data = NULL;
 		data_len = 0;
@@ -1581,10 +1601,14 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 		dev->cur_cmd_info = info;
 		err = cmd->doit(dev, data, data_len);
 		dev->cur_cmd_info = NULL;
-		return err;
+		goto put_dev;
 	}
 
-	return -EOPNOTSUPP;
+	err = -EOPNOTSUPP;
+
+put_dev:
+	nfc_put_device(dev);
+	return err;
 }
 
 /* message building helper */
-- 
2.35.1



