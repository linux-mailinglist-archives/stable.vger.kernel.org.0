Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF37D3C53AD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348409AbhGLHzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350619AbhGLHvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5569461C30;
        Mon, 12 Jul 2021 07:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076022;
        bh=qC8BuRcM73CXyeA4KBinzP5v6wjTB3NpWGuOzKomHek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/N3Ppz4uprMzh8HUleGuiCtq3D4qqj34HWLAjeKiUnmuAJ7pbI42co1IUkRoZEGa
         2p2Ducqb1GsOccXqsRWWKwO5NW98JAbAPhuTJiFCVsmvHjy3HxM76f4Gt459EZEbHJ
         1DkL4SkI8F49za3f2dMKuullw1NCq0wPUQ77OOmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 464/800] brcmfmac: Fix a double-free in brcmf_sdio_bus_reset
Date:   Mon, 12 Jul 2021 08:08:07 +0200
Message-Id: <20210712061016.491016964@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit 7ea7a1e05c7ff5ffc9f9ec1f0849f6ceb7fcd57c ]

brcmf_sdiod_remove has been called inside brcmf_sdiod_probe when fails,
so there's no need to call another one. Otherwise, sdiodev->freezer
would be double freed.

Fixes: 7836102a750a ("brcmfmac: reset SDIO bus on a firmware crash")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210601100128.69561-1-tongtiangen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 16ed325795a8..3a1c98a046f0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4162,7 +4162,6 @@ static int brcmf_sdio_bus_reset(struct device *dev)
 	if (ret) {
 		brcmf_err("Failed to probe after sdio device reset: ret %d\n",
 			  ret);
-		brcmf_sdiod_remove(sdiodev);
 	}
 
 	return ret;
-- 
2.30.2



