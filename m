Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12823C4E16
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbhGLHQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243451AbhGLHPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B8D661153;
        Mon, 12 Jul 2021 07:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073935;
        bh=qC8BuRcM73CXyeA4KBinzP5v6wjTB3NpWGuOzKomHek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faNiOeglE1+/pYpVvl1jSkzEEyQDdpVpEOivDA+dG2ENgyIQ+vtiPLc3+JtndVMpv
         AoexQVuCkL9jQ1ZvXyhy6jeiIrOQW/sPMi4x73v38dXt/VMvSHHD+qfZjY5Y/MY3H5
         GkDB5DCw+LPDtRddnH7LiXblIPd33sZUUfaTyT6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 410/700] brcmfmac: Fix a double-free in brcmf_sdio_bus_reset
Date:   Mon, 12 Jul 2021 08:08:13 +0200
Message-Id: <20210712061020.016120572@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



