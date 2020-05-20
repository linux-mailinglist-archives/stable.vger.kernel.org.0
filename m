Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BD11DB6AA
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgETO0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:26:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33070 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727037AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035i-JS; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DPq-KT; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "Brian Norris" <briannorris@chromium.org>,
        "Douglas Anderson" <dianders@chromium.org>,
        "Kalle Valo" <kvalo@codeaurora.org>, franky.lin@broadcom.com,
        "Matthias Kaehlcke" <mka@chromium.org>
Date:   Wed, 20 May 2020 15:13:53 +0100
Message-ID: <lsq.1589984008.528149311@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 25/99] brcmfmac: abort and release host after error
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 863844ee3bd38219c88e82966d1df36a77716f3e upstream.

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
[bwh: Backported to 3.16:
 - Use bus->sdiodev->func[1] instead of ->func1
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1971,6 +1971,8 @@ static uint brcmf_sdio_readframes(struct
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
+				brcmf_sdio_rxfail(bus, true, true);
+				sdio_release_host(bus->sdiodev->func[1]);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}

