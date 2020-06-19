Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA0A201330
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404209AbgFSP63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390488AbgFSPTa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 479CD2184D;
        Fri, 19 Jun 2020 15:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579968;
        bh=gaxOcen6Q9dN8HfcwwrP4yk5frKodCMa00mJuEccJdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akCErn432cBghn8ieEtmWS8wal+1phcMjROpcM4XKXL6sn7K6+lykud8B/6MUNwzX
         D7Cq9/L5prRwmYr5R4KZEjrgKB2oXkx6Eesj8dQE9wO4dTpsUBPR2NpyUasm4mRNuy
         3bJswm3YbjqYyoCLFJsMcdehA+TjUuMOIsI4dC4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Tobias Baumann <017623705678@o2online.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 072/376] mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error
Date:   Fri, 19 Jun 2020 16:29:50 +0200
Message-Id: <20200619141713.761559667@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2e58743d83bb..3813b544f571 100644
--- a/drivers/mmc/host/meson-mx-sdio.c
+++ b/drivers/mmc/host/meson-mx-sdio.c
@@ -246,6 +246,9 @@ static void meson_mx_mmc_request_done(struct meson_mx_mmc_host *host)
 
 	mrq = host->mrq;
 
+	if (host->cmd->error)
+		meson_mx_mmc_soft_reset(host);
+
 	host->mrq = NULL;
 	host->cmd = NULL;
 
-- 
2.25.1



