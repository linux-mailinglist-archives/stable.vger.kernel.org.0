Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7E865EF32
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjAEOsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbjAEOsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:48:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3B037273;
        Thu,  5 Jan 2023 06:48:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 172E361ADB;
        Thu,  5 Jan 2023 14:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78C3C433D2;
        Thu,  5 Jan 2023 14:48:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="qGFtc44q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1672930083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0ck3abVJY2ouhKZmMHaxzbj9CCExwJe2tQnda+R1m0=;
        b=qGFtc44q5akffwi5JVAownpi+dfiyBqRDRp7CQGSrlezApoND+xq4NLG+G6s2V/rWeV/kV
        pFTSnVhXlz93c9qkE8tZQ2HQfo4y+ZoxZ50Mr4q9wgUexGWJIWMgHtuaGHYIaJ8tUc35HI
        WQMb5q5soEW63quDCcmwK0QcFqMhtwk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3ea1ba23 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 5 Jan 2023 14:48:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Altmanninger <aclopte@gmail.com>
Cc:     stable@vger.kernel.org
Subject: [PATCH] tpm: Disable hwrng for TPM 1 if PM_SLEEP is enabled
Date:   Thu,  5 Jan 2023 15:47:42 +0100
Message-Id: <20230105144742.3219571-1-Jason@zx2c4.com>
In-Reply-To: <370a2808-a19b-b512-4cd3-72dc69dfe8b0@suse.cz>
References: <370a2808-a19b-b512-4cd3-72dc69dfe8b0@suse.cz>
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

TPM 1's support for its hardware RNG is broken across system suspends,
due to races or locking issues or something else that haven't been
diagnosed or fixed yet. These issues prevent the system from actually
suspending. So disable the driver in this case. Later, when this is
fixed properly, we can remove this.

Current breakage amounts to something like:

  tpm tpm0: A TPM error (28) occurred continue selftest
  ...
  tpm tpm0: A TPM error (28) occurred attempting get random
  ...
  tpm tpm0: Error (28) sending savestate before suspend
  tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
  tpm_tis 00:08: PM: dpm_run_callback(): pnp_bus_suspend+0x0/0x10 returns 28
  tpm_tis 00:08: PM: failed to suspend: error 28
  PM: Some devices failed to suspend, or early wake event detected

This issue was partially fixed by 23393c646142 ("char: tpm: Protect
tpm_pm_suspend with locks"), in a last minute 6.1 commit that Linus took
directly because the TPM maintainers weren't available. However, it
seems like this just addresses the most common cases of the bug, rather
than addressing it entirely. So there are more things to fix still,
apparently.

The hwrng driver appears already to be occasionally disabled due to
other conditions, so this shouldn't be too large of a surprise.

Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/tpm/tpm-chip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 741d8f3e8fb3..eed67ea8d3a7 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -524,6 +524,14 @@ static int tpm_add_hwrng(struct tpm_chip *chip)
 	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
 		return 0;
 
+	/*
+	 * This driver's support for using the RNG across suspend is broken on
+	 * TPM1. Until somebody fixes this, just stop registering a HWRNG in
+	 * that case.
+	 */
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2) && IS_ENABLED(CONFIG_PM_SLEEP))
+		return 0;
+
 	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
 		 "tpm-rng-%d", chip->dev_num);
 	chip->hwrng.name = chip->hwrng_name;
-- 
2.39.0

