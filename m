Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E31F2947
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387858AbgFHX6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbgFHXXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011672086A;
        Mon,  8 Jun 2020 23:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658592;
        bh=jYmhetrVkNgZTNo37SbeiWGjdac6A+k42aQczdxV2LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uVi0YoBaICQEV3bJq6ljwtnIoJJJBQNH9ElzS7exHaM+6izANrsQQdPZuAYcavKW
         ceF48tZnlvA7G14p2td8m7+zoMNnXTnijBlOmcuYY2d/Sjg30fF/tEVkCXsmwAnQqQ
         QHQFKYw6Sae7BEkSXgqyH0mmNZ7uvQ1VHnMgUA7c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Tobias Baumann <017623705678@o2online.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 026/106] mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error
Date:   Mon,  8 Jun 2020 19:21:18 -0400
Message-Id: <20200608232238.3368589-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 91995b904ec2e44b5c159ac6a5d3f154345a4de7 ]

The vendor driver (from the 3.10 kernel) triggers a soft reset every
time before starting a new command. While this fixes a problem where
SDIO cards are not detected at all (because all commands simply
timed out) this hurts SD card read performance a bit (in my tests
between 10% to 20%).

Trigger a soft reset after we got a CRC error or if the previous command
timed out (just like the vendor driver from the same 3.10 kernel for the
newer SDHC controller IP does). This fixes detection of SDIO cards and
doesn't hurt SD card read performance at the same time.

With this patch the initialization of an RTL8723BS SDIO card looks like
this:
  req done (CMD52): -110: 00000000 00000000 00000000 00000000
  clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 21 width 1 timing 0
  starting CMD0 arg 00000000 flags 000000c0
  req done (CMD0): 0: 00000000 00000000 00000000 00000000
  clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 1 timing 0
  starting CMD8 arg 000001aa flags 000002f5
  req done (CMD8): -110: 00000000 00000000 00000000 00000000
  starting CMD5 arg 00000000 flags 000002e1
  req done (CMD5): 0: 90ff0000 00000000 00000000 00000000
  starting CMD5 arg 00200000 flags 000002e1
  req done (CMD5): 0: 90ff0000 00000000 00000000 00000000
  starting CMD3 arg 00000000 flags 00000075
  req done (CMD3): 0: 00010000 00000000 00000000 00000000
  starting CMD7 arg 00010000 flags 00000015
  req done (CMD7): 0: 00001e00 00000000 00000000 00000000
  starting CMD52 arg 00000000 flags 00000195
  req done (CMD52): 0: 00001032 00000000 00000000 00000000
  [... more CMD52 omitted ...]
  clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 1 timing 2
  clock 50000000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 1 timing 2
  starting CMD52 arg 00000e00 flags 00000195
  req done (CMD52): 0: 00001000 00000000 00000000 00000000
  starting CMD52 arg 80000e02 flags 00000195
  req done (CMD52): 0: 00001002 00000000 00000000 00000000
  clock 50000000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 4 timing 2
  starting CMD52 arg 00020000 flags 00000195
  req done (CMD52): 0: 00001007 00000000 00000000 00000000
  [... more CMD52 omitted ...]
  new high speed SDIO card at address 0001

Fixes: ed80a13bb4c4c9 ("mmc: meson-mx-sdio: Add a driver for the Amlogic Meson8 and Meson8b SoCs")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20200503222805.2668941-1-martin.blumenstingl@googlemail.com
Tested-by: Tobias Baumann <017623705678@o2online.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-mx-sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/meson-mx-sdio.c b/drivers/mmc/host/meson-mx-sdio.c
index 1c062473b1c2..27837a794e7b 100644
--- a/drivers/mmc/host/meson-mx-sdio.c
+++ b/drivers/mmc/host/meson-mx-sdio.c
@@ -249,6 +249,9 @@ static void meson_mx_mmc_request_done(struct meson_mx_mmc_host *host)
 
 	mrq = host->mrq;
 
+	if (host->cmd->error)
+		meson_mx_mmc_soft_reset(host);
+
 	host->mrq = NULL;
 	host->cmd = NULL;
 
-- 
2.25.1

