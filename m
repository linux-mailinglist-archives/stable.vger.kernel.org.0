Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F8727C7B8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgI2LoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbgI2LoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D9602074A;
        Tue, 29 Sep 2020 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379840;
        bh=XdRDOgvHDsFvBn0rGa9k5vnw2/tgAY54y+zRY39tkGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JROvNKrOBje0HiZqFfs3slbCSO5A/QmfvkWPjZ75V0TEdutVGh6EKiU8uanoz2IGD
         /hCA3I6TEEETXBzVTQRnEVZWwZ9monAZvKR6NkFsUclNwrY56Bh/y5tcuMrGDHRl7g
         lQVJ6v1tGYnbOMorzb8kqMZAP9eGuaeeP1t5lSOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Kaloyan Nikolov <konik98@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 340/388] mwifiex: Increase AES key storage size to 256 bits
Date:   Tue, 29 Sep 2020 13:01:11 +0200
Message-Id: <20200929110026.920969800@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 4afc850e2e9e781976fb2c7852ce7bac374af938 ]

Following commit e18696786548 ("mwifiex: Prevent memory corruption
handling keys") the mwifiex driver fails to authenticate with certain
networks, specifically networks with 256 bit keys, and repeatedly asks
for the password. The kernel log repeats the following lines (id and
bssid redacted):

    mwifiex_pcie 0000:01:00.0: info: trying to associate to '<id>' bssid <bssid>
    mwifiex_pcie 0000:01:00.0: info: associated to bssid <bssid> successfully
    mwifiex_pcie 0000:01:00.0: crypto keys added
    mwifiex_pcie 0000:01:00.0: info: successfully disconnected from <bssid>: reason code 3

Tracking down this problem lead to the overflow check introduced by the
aforementioned commit into mwifiex_ret_802_11_key_material_v2(). This
check fails on networks with 256 bit keys due to the current storage
size for AES keys in struct mwifiex_aes_param being only 128 bit.

To fix this issue, increase the storage size for AES keys to 256 bit.

Fixes: e18696786548 ("mwifiex: Prevent memory corruption handling keys")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Reported-by: Kaloyan Nikolov <konik98@gmail.com>
Tested-by: Kaloyan Nikolov <konik98@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200825153829.38043-1-luzmaximilian@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h          | 2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 1fb76d2f5d3fd..8b9d0809daf62 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -953,7 +953,7 @@ struct mwifiex_tkip_param {
 struct mwifiex_aes_param {
 	u8 pn[WPA_PN_SIZE];
 	__le16 key_len;
-	u8 key[WLAN_KEY_LEN_CCMP];
+	u8 key[WLAN_KEY_LEN_CCMP_256];
 } __packed;
 
 struct mwifiex_wapi_param {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 7ae2c34f65db2..4eaa493e33253 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -619,7 +619,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 	key_v2 = &resp->params.key_material_v2;
 
 	len = le16_to_cpu(key_v2->key_param_set.key_params.aes.key_len);
-	if (len > WLAN_KEY_LEN_CCMP)
+	if (len > sizeof(key_v2->key_param_set.key_params.aes.key))
 		return -EINVAL;
 
 	if (le16_to_cpu(key_v2->action) == HostCmd_ACT_GEN_SET) {
@@ -635,7 +635,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 		return 0;
 
 	memset(priv->aes_key_v2.key_param_set.key_params.aes.key, 0,
-	       WLAN_KEY_LEN_CCMP);
+	       sizeof(key_v2->key_param_set.key_params.aes.key));
 	priv->aes_key_v2.key_param_set.key_params.aes.key_len =
 				cpu_to_le16(len);
 	memcpy(priv->aes_key_v2.key_param_set.key_params.aes.key,
-- 
2.25.1



