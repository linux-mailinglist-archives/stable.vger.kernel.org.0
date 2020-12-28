Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A02E3AEC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404455AbgL1NnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404444AbgL1NnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8EA208B3;
        Mon, 28 Dec 2020 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162957;
        bh=lV2GbKqBOhyT8kvP2rouqp6IKJybO9jCwjG1f6ejt4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+58ANDtelGtcco1n/1cZbYtxHa/r25H/CjOU5SLp0I0KMHvorgtDvzmrU+cNfpVl
         e0dFkUi3Ay3zTZPOZ/zyddac8VzQ7TACy//dG0PIomBxMFuWczVrKo3HjPytQIjf06
         k2dSP7jY1196/vZFNdRG7gdIddySeWS++ods1hZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/453] mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
Date:   Mon, 28 Dec 2020 13:45:56 +0100
Message-Id: <20201228124942.989189991@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit fa74cb1dc0f4da46c441b735ca865ac52de42c0e ]

When a PCIe function level reset (FLR) is performed but without fw reset for
some reasons (e.g., on Microsoft Surface devices, fw reset requires other
quirks), it fails to reset wifi properly. You can trigger the issue on such
devices via debugfs entry for reset:

    $ echo 1 | sudo tee /sys/kernel/debug/mwifiex/mlan0/reset

and the resulting dmesg log:

    [   45.740508] mwifiex_pcie 0000:03:00.0: Resetting per request
    [   45.742937] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 3
    [   45.744666] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
    [   45.751530] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.751539] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771691] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771695] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771697] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771698] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771699] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771701] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771702] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771703] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771704] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771705] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771707] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771708] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   53.099343] mwifiex_pcie 0000:03:00.0: info: trying to associate to '[SSID]' bssid [BSSID]
    [   53.241870] mwifiex_pcie 0000:03:00.0: info: associated to bssid [BSSID] successfully
    [   75.377942] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [   85.385491] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 15
    [   87.539408] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [   87.539412] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   99.699917] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [   99.699925] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [  111.859802] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [  111.859808] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [...]

When comparing mwifiex_shutdown_sw() with mwifiex_pcie_remove(), it
lacks mwifiex_init_shutdown_fw().

This commit fixes mwifiex_shutdown_sw() by adding the missing
mwifiex_init_shutdown_fw().

Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201028142110.18144-2-kitakar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index d14e55e3c9dad..5894566ec4805 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1469,6 +1469,8 @@ int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	mwifiex_deauthenticate(priv, NULL);
 
+	mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
+
 	mwifiex_uninit_sw(adapter);
 	adapter->is_up = false;
 
-- 
2.27.0



