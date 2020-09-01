Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB725945F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgIAPi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728241AbgIAPiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FB0C20866;
        Tue,  1 Sep 2020 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974734;
        bh=AOQDhAs5sbYZs2BMhmI2uixw2SfSCbf3ZGUMKVmE1Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHz31zlvnTqu6NxItKMPxgIA6I5yvuGNLjvbLF6/edWkX65I5vF6Me3Eo+sUFghLE
         Uv42XAQxX4db1VjGYz6Zs48ksEW70EU46gg4vvzyA0Je15WrzAF3weBdQgmdrI7uMA
         NnX/0Q/E6vhr6zUK0cCCnuYpg6qCHZYNlM7y0AS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 073/255] brcmfmac: Set timeout value when configuring power save
Date:   Tue,  1 Sep 2020 17:08:49 +0200
Message-Id: <20200901151004.230421914@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 3dc05ffb04436020f63138186dbc4f37bd938552 ]

Set the timeout value as per cfg80211's set_power_mgmt() request. If the
requested value value is left undefined we set it to 2 seconds, the
maximum supported value.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200721112302.22718-1-nsaenzjulienne@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a757abd7a5999..f4db818cccae7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -84,6 +84,8 @@
 
 #define BRCMF_ND_INFO_TIMEOUT		msecs_to_jiffies(2000)
 
+#define BRCMF_PS_MAX_TIMEOUT_MS		2000
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -2941,6 +2943,12 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 		else
 			bphy_err(drvr, "error (%d)\n", err);
 	}
+
+	err = brcmf_fil_iovar_int_set(ifp, "pm2_sleep_ret",
+				min_t(u32, timeout, BRCMF_PS_MAX_TIMEOUT_MS));
+	if (err)
+		bphy_err(drvr, "Unable to set pm timeout, (%d)\n", err);
+
 done:
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
-- 
2.25.1



