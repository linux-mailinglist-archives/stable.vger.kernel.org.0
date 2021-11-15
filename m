Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7591445251A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbhKPBqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240916AbhKOSZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 680CC6332C;
        Mon, 15 Nov 2021 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998975;
        bh=8F6XOyHqUfGHNq6+9r9Cd1I2ohFazSk8LLzWXC180F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZ2L8op9s1da6ow1DpDnYv2atZSJEelfTr9rkMukD7mj65hGz6hYvzIHBpIzitmgq
         KyUqJFDMKsNfJ3FbCsA1bRRa0nq88NLdUBTIhd1KoEUuKPUYNB4RGLz7oS4qVs7jyH
         axtKp4k2t4DxpXc0s7IeC8w87A3lyd3Yl7QG6dzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.14 130/849] mwifiex: Try waking the firmware until we get an interrupt
Date:   Mon, 15 Nov 2021 17:53:33 +0100
Message-Id: <20211115165424.499627993@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

commit 8e3e59c31fea5de95ffc52c46f0c562c39f20c59 upstream.

It seems that the PCIe+USB firmware (latest version 15.68.19.p21) of the
88W8897 card sometimes ignores or misses when we try to wake it up by
writing to the firmware status register. This leads to the firmware
wakeup timeout expiring and the driver resetting the card because we
assume the firmware has hung up or crashed.

Turns out that the firmware actually didn't hang up, but simply "missed"
our wakeup request and didn't send us an interrupt with an AWAKE event.

Trying again to read the firmware status register after a short timeout
usually makes the firmware wake up as expected, so add a small retry
loop to mwifiex_pm_wakeup_card() that looks at the interrupt status to
check whether the card woke up.

The number of tries and timeout lengths for this were determined
experimentally: The firmware usually takes about 500 us to wake up
after we attempt to read the status register. In some cases where the
firmware is very busy (for example while doing a bluetooth scan) it
might even miss our requests for multiple milliseconds, which is why
after 15 tries the waiting time gets increased to 10 ms. The maximum
number of tries it took to wake the firmware when testing this was
around 20, so a maximum number of 50 tries should give us plenty of
safety margin.

Here's a reproducer for those firmware wakeup failures I've found:

1) Make sure wifi powersaving is enabled (iw dev wlp1s0 set power_save on)
2) Connect to any wifi network (makes firmware go into wifi powersaving
mode, not deep sleep)
3) Make sure bluetooth is turned off (to ensure the firmware actually
enters powersave mode and doesn't keep the radio active doing bluetooth
stuff)
4) To confirm that wifi powersaving is entered ping a device on the LAN,
pings should be a few ms higher than without powersaving
5) Run "while true; do iwconfig; sleep 0.0001; done", this wakes and
suspends the firmware extremely often
6) Wait until things explode, for me it consistently takes <5 minutes

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211011133224.15561-3-verdre@v0yd.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -17,6 +17,7 @@
  * this warranty disclaimer.
  */
 
+#include <linux/iopoll.h>
 #include <linux/firmware.h>
 
 #include "decl.h"
@@ -636,11 +637,15 @@ static void mwifiex_delay_for_sleep_cook
 			    "max count reached while accessing sleep cookie\n");
 }
 
+#define N_WAKEUP_TRIES_SHORT_INTERVAL 15
+#define N_WAKEUP_TRIES_LONG_INTERVAL 35
+
 /* This function wakes up the card by reading fw_status register. */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int retval;
 
 	mwifiex_dbg(adapter, EVENT,
 		    "event: Wakeup device...\n");
@@ -648,11 +653,24 @@ static int mwifiex_pm_wakeup_card(struct
 	if (reg->sleep_cookie)
 		mwifiex_pcie_dev_wakeup_delay(adapter);
 
-	/* Accessing fw_status register will wakeup device */
-	if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
-		mwifiex_dbg(adapter, ERROR,
-			    "Writing fw_status register failed\n");
-		return -1;
+	/* The 88W8897 PCIe+USB firmware (latest version 15.68.19.p21) sometimes
+	 * appears to ignore or miss our wakeup request, so we continue trying
+	 * until we receive an interrupt from the card.
+	 */
+	if (read_poll_timeout(mwifiex_write_reg, retval,
+			      READ_ONCE(adapter->int_status) != 0,
+			      500, 500 * N_WAKEUP_TRIES_SHORT_INTERVAL,
+			      false,
+			      adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
+		if (read_poll_timeout(mwifiex_write_reg, retval,
+				      READ_ONCE(adapter->int_status) != 0,
+				      10000, 10000 * N_WAKEUP_TRIES_LONG_INTERVAL,
+				      false,
+				      adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
+			mwifiex_dbg(adapter, ERROR,
+				    "Firmware didn't wake up\n");
+			return -EIO;
+		}
 	}
 
 	if (reg->sleep_cookie) {


