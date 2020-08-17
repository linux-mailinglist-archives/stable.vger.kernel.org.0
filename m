Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDA5246BF5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388385AbgHQQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388361AbgHQQF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82BB920888;
        Mon, 17 Aug 2020 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680317;
        bh=oH8mZYM95hLP+WKKBBElhiRUYsGIIf0PWYjvZJhekzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3gRTs4BUoxBNDNgs7cPaa132zvCl1+uhC0c0EQrjEl/h4St7ko5/EOgd1H3rJJQy
         FuLQYXtDaGHdh0vThNUoLH+1ABqxoVJqY6+sbHrieAX9X8sczoCi78I/7e7NdjqU1K
         HeLofdQHHQhCPGEeZA+y5R6IVjmQ4cv5GEaTSduA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/270] mwifiex: Prevent memory corruption handling keys
Date:   Mon, 17 Aug 2020 17:15:40 +0200
Message-Id: <20200817143802.736860430@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e18696786548244914f36ec3c46ac99c53df99c3 ]

The length of the key comes from the network and it's a 16 bit number.  It
needs to be capped to prevent a buffer overflow.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200708115857.GA13729@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/marvell/mwifiex/sta_cmdresp.c    | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 20c206da06315..7ae2c34f65db2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -580,6 +580,11 @@ static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_key_material *key =
 						&resp->params.key_material;
+	int len;
+
+	len = le16_to_cpu(key->key_param_set.key_len);
+	if (len > sizeof(key->key_param_set.key))
+		return -EINVAL;
 
 	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key->key_param_set.key_info) & KEY_MCAST)) {
@@ -593,9 +598,8 @@ static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
 
 	memset(priv->aes_key.key_param_set.key, 0,
 	       sizeof(key->key_param_set.key));
-	priv->aes_key.key_param_set.key_len = key->key_param_set.key_len;
-	memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key,
-	       le16_to_cpu(priv->aes_key.key_param_set.key_len));
+	priv->aes_key.key_param_set.key_len = cpu_to_le16(len);
+	memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key, len);
 
 	return 0;
 }
@@ -610,9 +614,14 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 					      struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_key_material_v2 *key_v2;
-	__le16 len;
+	int len;
 
 	key_v2 = &resp->params.key_material_v2;
+
+	len = le16_to_cpu(key_v2->key_param_set.key_params.aes.key_len);
+	if (len > WLAN_KEY_LEN_CCMP)
+		return -EINVAL;
+
 	if (le16_to_cpu(key_v2->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key_v2->key_param_set.key_info) & KEY_MCAST)) {
 			mwifiex_dbg(priv->adapter, INFO, "info: key: GTK is set\n");
@@ -628,10 +637,9 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 	memset(priv->aes_key_v2.key_param_set.key_params.aes.key, 0,
 	       WLAN_KEY_LEN_CCMP);
 	priv->aes_key_v2.key_param_set.key_params.aes.key_len =
-				key_v2->key_param_set.key_params.aes.key_len;
-	len = priv->aes_key_v2.key_param_set.key_params.aes.key_len;
+				cpu_to_le16(len);
 	memcpy(priv->aes_key_v2.key_param_set.key_params.aes.key,
-	       key_v2->key_param_set.key_params.aes.key, le16_to_cpu(len));
+	       key_v2->key_param_set.key_params.aes.key, len);
 
 	return 0;
 }
-- 
2.25.1



