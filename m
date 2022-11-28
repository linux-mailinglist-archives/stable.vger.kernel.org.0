Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE6063B2A7
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 20:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiK1T6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 14:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbiK1T6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 14:58:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15D0B27;
        Mon, 28 Nov 2022 11:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5BF85CE1054;
        Mon, 28 Nov 2022 19:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D639DC433D7;
        Mon, 28 Nov 2022 19:57:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="o7HB8omO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1669665472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m+iodXvVaGO3w4QAQvXUTnn8uFbQvqV8cvcIq17x8pk=;
        b=o7HB8omOA47EFDy7hMWwqFoQfP8SzKI7Hiwr2zSXBF18xLG1dXIrU794PbLD82ro2flwU3
        GjkuPKeUnKW52xqpxZdEmBK/RYtXZ+1o51MRD+t7AVl+vfpg28dep1gm5ya7cM+WDyTWza
        SzfxbOW6IE9DGbhExXaD2cjPRnuYB3I=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id adff6e4d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 28 Nov 2022 19:57:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?q?Jan=20D=C4=85bro=C5=9B?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Date:   Mon, 28 Nov 2022 20:56:51 +0100
Message-Id: <20221128195651.322822-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Dabros <jsd@semihalf.com>

Currently tpm transactions are executed unconditionally in
tpm_pm_suspend() function, which may lead to races with other tpm
accessors in the system. Specifically, the hw_random tpm driver makes
use of tpm_get_random(), and this function is called in a loop from a
kthread, which means it's not frozen alongside userspace, and so can
race with the work done during system suspend:

[    3.277834] tpm tpm0: tpm_transmit: tpm_recv: error -52
[    3.278437] tpm tpm0: invalid TPM_STS.x 0xff, dumping stack for forensics
[    3.278445] CPU: 0 PID: 1 Comm: init Not tainted 6.1.0-rc5+ #135
[    3.278450] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
[    3.278453] Call Trace:
[    3.278458]  <TASK>
[    3.278460]  dump_stack_lvl+0x34/0x44
[    3.278471]  tpm_tis_status.cold+0x19/0x20
[    3.278479]  tpm_transmit+0x13b/0x390
[    3.278489]  tpm_transmit_cmd+0x20/0x80
[    3.278496]  tpm1_pm_suspend+0xa6/0x110
[    3.278503]  tpm_pm_suspend+0x53/0x80
[    3.278510]  __pnp_bus_suspend+0x35/0xe0
[    3.278515]  ? pnp_bus_freeze+0x10/0x10
[    3.278519]  __device_suspend+0x10f/0x350

Fix this by calling tpm_try_get_ops(), which itself is a wrapper around
tpm_chip_start(), but takes the appropriate mutex.

Signed-off-by: Jan Dabros <jsd@semihalf.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/all/c5ba47ef-393f-1fba-30bd-1230d1b4b592@suse.cz/
Cc: stable@vger.kernel.org
Fixes: e891db1a18bf ("tpm: turn on TPM on suspend for TPM 1.x")
[Jason: reworked commit message, added metadata]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/tpm/tpm-interface.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1621ce818705..d69905233aff 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -401,13 +401,14 @@ int tpm_pm_suspend(struct device *dev)
 	    !pm_suspend_via_firmware())
 		goto suspended;
 
-	if (!tpm_chip_start(chip)) {
+	rc = tpm_try_get_ops(chip);
+	if (!rc) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
 			tpm2_shutdown(chip, TPM2_SU_STATE);
 		else
 			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
 
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
 
 suspended:
-- 
2.38.1

