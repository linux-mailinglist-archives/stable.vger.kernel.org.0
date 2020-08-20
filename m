Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6124B53B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgHTKU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbgHTKU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:20:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5482078B;
        Thu, 20 Aug 2020 10:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918857;
        bh=G28ve71zjd6PmMq9nLFalJ5EoHPctVPUwTcnmlLeZg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJunXsP4/4LEFERTPAGrwuNRH1u8Nqb03VCzK91hbjN75u3OGYdUqoL0Wa5KalHZx
         y1yksBjOH03FgC4lkg1i1rw48dHZldLl0zfcHlzCL2Rs70qGxcMCCg3M0dJ1gHQoq7
         l5FAVJ5j+jf6PofOqmQzvGwot+j1awvzMErhUL/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 091/149] mwifiex: Prevent memory corruption handling keys
Date:   Thu, 20 Aug 2020 11:22:48 +0200
Message-Id: <20200820092130.135063750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
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
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 9ac7aa2431b41..9e3853c8a22da 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -592,6 +592,11 @@ static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
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
@@ -605,9 +610,8 @@ static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
 
 	memset(priv->aes_key.key_param_set.key, 0,
 	       sizeof(key->key_param_set.key));
-	priv->aes_key.key_param_set.key_len = key->key_param_set.key_len;
-	memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key,
-	       le16_to_cpu(priv->aes_key.key_param_set.key_len));
+	priv->aes_key.key_param_set.key_len = cpu_to_le16(len);
+	memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key, len);
 
 	return 0;
 }
@@ -622,9 +626,14 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
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
@@ -640,10 +649,9 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
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



