Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812F23CD7D6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbhGSOTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242118AbhGSOR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:17:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 543096113C;
        Mon, 19 Jul 2021 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706716;
        bh=+fXf6jpUUuCXSmPqqyjFrZnbQRz/VIXuiackegUhJHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJGGWHnidNipW8bRpURSAmAb9rQfrQ1aLRTqUOPCmxJrfKUvyrSnXHrz3xb2GvWPM
         6Xwqq3BKDK7NZnTqooQZJrIRy0a4oTXn6xmTUCZ1gONHl00dM+SO+8JKUU6IWiCUbQ
         QelpwZrZhpdEADQ2ybJQKT1MdgN3OPgO/ta0oW+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 066/188] brcmsmac: mac80211_if: Fix a resource leak in an error handling path
Date:   Mon, 19 Jul 2021 16:50:50 +0200
Message-Id: <20210719144928.326185498@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9a25344d5177c2b9285532236dc3d10a091f39a8 ]

If 'brcms_attach()' fails, we must undo the previous 'ieee80211_alloc_hw()'
as already done in the remove function.

Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/8fbc171a1a493b38db5a6f0873c6021fca026a6c.1620852921.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index a4e1eec96c60..e3a500fb4e3c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1221,6 +1221,7 @@ static int brcms_bcma_probe(struct bcma_device *pdev)
 {
 	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
+	int ret;
 
 	dev_info(&pdev->dev, "mfg %x core %x rev %d class %d irq %d\n",
 		 pdev->id.manuf, pdev->id.id, pdev->id.rev, pdev->id.class,
@@ -1245,11 +1246,16 @@ static int brcms_bcma_probe(struct bcma_device *pdev)
 	wl = brcms_attach(pdev);
 	if (!wl) {
 		pr_err("%s: brcms_attach failed!\n", __func__);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_free_ieee80211;
 	}
 	brcms_led_register(wl);
 
 	return 0;
+
+err_free_ieee80211:
+	ieee80211_free_hw(hw);
+	return ret;
 }
 
 static int brcms_suspend(struct bcma_device *pdev)
-- 
2.30.2



