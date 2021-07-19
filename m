Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5FF3CDDF2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344138AbhGSPBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344318AbhGSO7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C932960FE7;
        Mon, 19 Jul 2021 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709179;
        bh=JoFwLlLuF5fE6++aDnNO33GC9Te0mD7UoPSEptbOJN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsfGn4CcBgCKXkaQD6kDrbAH5MRNLk528Y5yRvxqtA51ct8vNusfMt9G7R4+M1oiN
         Y7g+weDlyfN9jCAJPhHHVbWelmU5YLvdP3f2b5TgPStRLoEmDWuJpwxPK5KO7agBcH
         P/nYVa28ks9hm0tMLhquYwAPZs9E6E8O6teP+FpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/421] wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP
Date:   Mon, 19 Jul 2021 16:51:06 +0200
Message-Id: <20210719144955.237821751@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 11ef6bc846dcdce838f0b00c5f6a562c57e5d43b ]

At least on wl12xx, reading the MAC after boot can fail with a warning
at drivers/net/wireless/ti/wlcore/sdio.c:78 wl12xx_sdio_raw_read.
The failed call comes from wl12xx_get_mac() that wlcore_nvs_cb() calls
after request_firmware_work_func().

After the error, no wireless interface is created. Reloading the wl12xx
module makes the interface work.

Turns out the wlan controller can be in a low-power ELP state after the
boot from the bootloader or kexec, and needs to be woken up first.

Let's wake the hardware and add a sleep after that similar to
wl12xx_pre_boot() is already doing.

Note that a similar issue could exist for wl18xx, but I have not seen it
so far. And a search for wl18xx_get_mac and wl12xx_sdio_raw_read did not
produce similar errors.

Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210603062814.19464-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl12xx/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index e10fff42751e..b88c413f96ac 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1517,6 +1517,13 @@ static int wl12xx_get_fuse_mac(struct wl1271 *wl)
 	u32 mac1, mac2;
 	int ret;
 
+	/* Device may be in ELP from the bootloader or kexec */
+	ret = wlcore_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	if (ret < 0)
+		goto out;
+
+	usleep_range(500000, 700000);
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
 	if (ret < 0)
 		goto out;
-- 
2.30.2



