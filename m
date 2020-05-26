Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEC01E2E1A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389938AbgEZTFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391453AbgEZTFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F352820776;
        Tue, 26 May 2020 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519903;
        bh=R1Gt4SG3jPJ4a59LjXWWW9Stoq8z0WJPtFjuu69IuNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7jS+s+ZbEfgr2w12NTPTrG/DbcnY6UQXgkdvW8VKKkGr0M2aoZEzN6COUXCwyuaf
         TCCaWB0WjjMPXWeQ0JgyF4gYOfVXKXWcn/QIEX7VkmG4ZKC6ZlhPWZwRx4PxmBqkqF
         zFBxT9pmwEbadqYD7ahLg2dAbpTWvP/sE5EUTdHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>, franky.lin@broadcom.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 63/81] brcmfmac: abort and release host after error
Date:   Tue, 26 May 2020 20:53:38 +0200
Message-Id: <20200526183934.053640655@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 863844ee3bd38219c88e82966d1df36a77716f3e ]

With commit 216b44000ada ("brcmfmac: Fix use after free in
brcmf_sdio_readframes()") applied, we see locking timeouts in
brcmf_sdio_watchdog_thread().

brcmfmac: brcmf_escan_timeout: timer expired
INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
Not tainted 4.19.94-07984-g24ff99a0f713 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
[<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
[<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
[<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
[<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)

In addition to restarting or exiting the loop, it is also necessary to
abort the command and to release the host.

Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: franky.lin@broadcom.com
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e0211321fe9e..96870d1b3b73 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1933,6 +1933,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
+				brcmf_sdio_rxfail(bus, true, true);
+				sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
-- 
2.25.1



