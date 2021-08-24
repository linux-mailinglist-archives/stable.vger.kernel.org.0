Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9682D3F681A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbhHXRkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241964AbhHXRiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D707F61C13;
        Tue, 24 Aug 2021 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824888;
        bh=ErkmxPQ4iJPlEC1yQgCO+iUqMqh4eNxiGZeD9PjrX1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5DwTT//iuC5g/csqML9tQ1YWgpGna7dBaSNL35YeU5EZ+6g9sh6xCgUUKQharztG
         LJoTcg4sNXLpq8Rsz3xOy4zaRjDM0xPN2yEEw6TF4Cs2cXm3FuOhkQJF/n2XG78z3A
         tFE1cld7LB5QeMpaSFfpFzh2W190JCxF4aM28yT4N2iMMge3K4gR6DRXPi688UihFb
         T6MBbzpzXIiaUzStdLVmgtOAXjLnxNRokFD+Y5aV9sn3wPEin/ZOZfKYWU3+/ZfZby
         8N3N0NeANaAjLCw5QeC1klELnzIg2+2bEup0FgItQ7JYDFNSuxGsAjHsmTApv+5qnd
         jlwLwcLGRz31A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Anderson <dianders@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 25/31] mmc: dw_mmc: Wait for data transfer after response errors.
Date:   Tue, 24 Aug 2021 13:07:37 -0400
Message-Id: <20210824170743.710957-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

[ Upstream commit 46d179525a1f6d16957dcb4624517bc04142b3e7 ]

According to the DesignWare state machine description, after we get a
"response error" or "response CRC error" we move into data transfer
mode. That means that we don't necessarily need to special case
trying to deal with the failure right away. We can wait until we are
notified that the data transfer is complete (with or without errors)
and then we can deal with the failure.

It may sound strange to defer dealing with a command that we know will
fail anyway, but this appears to fix a bug. During tuning (CMD19) on
a specific card on an rk3288-based system, we found that we could get
a "response CRC error". Sending the stop command after the "response
CRC error" would then throw the system into a confused state causing
all future tuning phases to report failure.

When in the confused state, the controller would show these (hex codes
are interrupt status register):
 CMD ERR: 0x00000046 (cmd=19)
 CMD ERR: 0x0000004e (cmd=12)
 DATA ERR: 0x00000208
 DATA ERR: 0x0000020c
 CMD ERR: 0x00000104 (cmd=19)
 CMD ERR: 0x00000104 (cmd=12)
 DATA ERR: 0x00000208
 DATA ERR: 0x0000020c
 ...
 ...

It is inherently difficult to deal with the complexity of trying to
correctly send a stop command while a data transfer is taking place
since you need to deal with different corner cases caused by the fact
that the data transfer could complete (with errors or without errors)
during various places in sending the stop command (dw_mci_stop_dma,
send_stop_abort, etc)

Instead of adding a bunch of extra complexity to deal with this, it
seems much simpler to just use the more straightforward (and less
error-prone) path of letting the data transfer finish. There
shouldn't be any huge benefit to sending the stop command slightly
earlier, anyway.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Alim Akhtar <alim.akhtar@gmail.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 581f5d0271f4..afdf539e06e9 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1744,6 +1744,33 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			}
 
 			if (cmd->data && err) {
+				/*
+				 * During UHS tuning sequence, sending the stop
+				 * command after the response CRC error would
+				 * throw the system into a confused state
+				 * causing all future tuning phases to report
+				 * failure.
+				 *
+				 * In such case controller will move into a data
+				 * transfer state after a response error or
+				 * response CRC error. Let's let that finish
+				 * before trying to send a stop, so we'll go to
+				 * STATE_SENDING_DATA.
+				 *
+				 * Although letting the data transfer take place
+				 * will waste a bit of time (we already know
+				 * the command was bad), it can't cause any
+				 * errors since it's possible it would have
+				 * taken place anyway if this tasklet got
+				 * delayed. Allowing the transfer to take place
+				 * avoids races and keeps things simple.
+				 */
+				if ((err != -ETIMEDOUT) &&
+				    (cmd->opcode == MMC_SEND_TUNING_BLOCK)) {
+					state = STATE_SENDING_DATA;
+					continue;
+				}
+
 				dw_mci_stop_dma(host);
 				send_stop_abort(host, data);
 				state = STATE_SENDING_STOP;
-- 
2.30.2

