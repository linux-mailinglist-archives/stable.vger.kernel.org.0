Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE62881CD8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfHEN1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbfHENYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C550920644;
        Mon,  5 Aug 2019 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011484;
        bh=qZUoQsNFF8x1QEte1TYFLVH5sAbJwW4O0DOzKBslNRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkmDqtu80jOfUcowf2CUm882ROvb66gsgNleXGf0puHiTQX9jug/R6NN+DmNywfF5
         WoDmJkWwIsUoO0YyQfLXxxEkhpT4n/uQS+ic3u2qXEJ0OIzTtHu5lSoqIT+KdKmDF8
         S+IJfFkOvPcL2NvaiAGht7Gv0bQzGiys4dfxl8Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.2 078/131] tpm: Fix null pointer dereference on chip register error path
Date:   Mon,  5 Aug 2019 15:02:45 +0200
Message-Id: <20190805124957.042182129@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milan Broz <gmazyland@gmail.com>

commit 1e5ac6300a07ceecfc70a893ebef3352be21e6f8 upstream.

If clk_enable is not defined and chip initialization
is canceled code hits null dereference.

Easily reproducible with vTPM init fail:
  swtpm chardev --tpmstate dir=nonexistent_dir --tpm2 --vtpm-proxy

BUG: kernel NULL pointer dereference, address: 00000000
...
Call Trace:
 tpm_chip_start+0x9d/0xa0 [tpm]
 tpm_chip_register+0x10/0x1a0 [tpm]
 vtpm_proxy_work+0x11/0x30 [tpm_vtpm_proxy]
 process_one_work+0x214/0x5a0
 worker_thread+0x134/0x3e0
 ? process_one_work+0x5a0/0x5a0
 kthread+0xd4/0x100
 ? process_one_work+0x5a0/0x5a0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x19/0x24

Fixes: 719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Milan Broz <gmazyland@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-chip.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -77,6 +77,18 @@ static int tpm_go_idle(struct tpm_chip *
 	return chip->ops->go_idle(chip);
 }
 
+static void tpm_clk_enable(struct tpm_chip *chip)
+{
+	if (chip->ops->clk_enable)
+		chip->ops->clk_enable(chip, true);
+}
+
+static void tpm_clk_disable(struct tpm_chip *chip)
+{
+	if (chip->ops->clk_enable)
+		chip->ops->clk_enable(chip, false);
+}
+
 /**
  * tpm_chip_start() - power on the TPM
  * @chip:	a TPM chip to use
@@ -89,13 +101,12 @@ int tpm_chip_start(struct tpm_chip *chip
 {
 	int ret;
 
-	if (chip->ops->clk_enable)
-		chip->ops->clk_enable(chip, true);
+	tpm_clk_enable(chip);
 
 	if (chip->locality == -1) {
 		ret = tpm_request_locality(chip);
 		if (ret) {
-			chip->ops->clk_enable(chip, false);
+			tpm_clk_disable(chip);
 			return ret;
 		}
 	}
@@ -103,8 +114,7 @@ int tpm_chip_start(struct tpm_chip *chip
 	ret = tpm_cmd_ready(chip);
 	if (ret) {
 		tpm_relinquish_locality(chip);
-		if (chip->ops->clk_enable)
-			chip->ops->clk_enable(chip, false);
+		tpm_clk_disable(chip);
 		return ret;
 	}
 
@@ -124,8 +134,7 @@ void tpm_chip_stop(struct tpm_chip *chip
 {
 	tpm_go_idle(chip);
 	tpm_relinquish_locality(chip);
-	if (chip->ops->clk_enable)
-		chip->ops->clk_enable(chip, false);
+	tpm_clk_disable(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_stop);
 


