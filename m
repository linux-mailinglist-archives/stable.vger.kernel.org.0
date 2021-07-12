Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC5D3C49C0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbhGLGqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236777AbhGLGpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E635610CD;
        Mon, 12 Jul 2021 06:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072085;
        bh=3Ame5mAbHVT7+zjKqVsURnRRLE/UlmfH3QxEbGObC9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jT0duqcOQKhpKLaH08Lt1E2z1ozDJ00dCarVORsVncNHd9P7I97h/k8EQc9ipBE9u
         WTlf3p5AdijFyfP199CRKUx9OqLfwf87/KmaKYZwrKHmdp+m+01OX22j3k6VQHj35E
         RO6ffSo3Af5gw+WJqnIyfvEh5A6WOe7Nxm4XC0lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/593] brcmfmac: Fix a double-free in brcmf_sdio_bus_reset
Date:   Mon, 12 Jul 2021 08:08:29 +0200
Message-Id: <20210712060924.584376808@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 59c2b2b6027d..6d5d5c39c635 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4157,7 +4157,6 @@ static int brcmf_sdio_bus_reset(struct device *dev)
 	if (ret) {
 		brcmf_err("Failed to probe after sdio device reset: ret %d\n",
 			  ret);
-		brcmf_sdiod_remove(sdiodev);
 	}
 
 	return ret;
-- 
2.30.2



