Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04242593C0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgIAPac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgIAPa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3152D205F4;
        Tue,  1 Sep 2020 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974227;
        bh=ljQvRiNJ+zD+RqKxPXtXqrXymWeeZshRIjfMSdfN9Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8DyjFnjaBoRm4SjPQ7riQ4CDyamvLCpg/iSVK/gJtvmen+N64/FsKyiJqhbvnsQH
         ZEmieEDQSHNrs5mkmVJ9Ngj1m0tHbxZBlUA4kemk2hDOfnRTTluPfRaz5cytoPDqw+
         orKeMXekB1G/9+rEyi2Onvl4s8Tuglgtzkjr0vvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/214] brcmfmac: Set timeout value when configuring power save
Date:   Tue,  1 Sep 2020 17:09:04 +0200
Message-Id: <20200901150956.046718353@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
index e3ebb7abbdaed..4ca50353538ef 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -82,6 +82,8 @@
 
 #define BRCMF_ND_INFO_TIMEOUT		msecs_to_jiffies(2000)
 
+#define BRCMF_PS_MAX_TIMEOUT_MS		2000
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -2789,6 +2791,12 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
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



