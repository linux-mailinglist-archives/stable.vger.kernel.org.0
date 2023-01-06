Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E52E65F9E4
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 04:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjAFDEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 22:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjAFDDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 22:03:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D4A6B5C6;
        Thu,  5 Jan 2023 19:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 464D961CC8;
        Fri,  6 Jan 2023 03:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170B1C433EF;
        Fri,  6 Jan 2023 03:02:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="R4BcOF1Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1672974126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efZSHt3YcBRsaUeR6mOr7PEUQW1tGnk6xcgIkVA9P44=;
        b=R4BcOF1QA8mj1a+6y7oEGCzd6sbEa8PsR9N/ECutO2ta5Mh8weq4/jjAA1D2vLFyffHB5v
        p+HV7w5Ydj4ZLXFu4fr2sJjgIJNf6O8uxYml0nO1ESo5Y0cHbuBC5b0W9zqtwIhr+6u7ke
        XUE7xCY89+EX3PJv8QbQ//54E+N58qI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7620b3ca (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 6 Jan 2023 03:02:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2] tpm: Allow system suspend to continue when TPM suspend fails
Date:   Fri,  6 Jan 2023 04:01:56 +0100
Message-Id: <20230106030156.3258307-1-Jason@zx2c4.com>
In-Reply-To: <Y7dPV5BK6jk1KvX+@zx2c4.com>
References: <Y7dPV5BK6jk1KvX+@zx2c4.com>
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

TPM 1 is sometimes broken across system suspends, due to races or
locking issues or something else that haven't been diagnosed or fixed
yet, most likely having to do with concurrent reads from the TPM's
hardware random number generator driver. These issues prevent the system
from actually suspending, with errors like:

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

In lieu of actually fixing the underlying bug, just allow system suspend
to continue, so that laptops still go to sleep fine. Later, this can be
reverted when the real bug is fixed.

Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
Cc: stable@vger.kernel.org # 6.1+
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
This is basically untested and I haven't worked out if there are any
awful implications of letting the system sleep when TPM suspend fails.
Maybe some PCRs get cleared and that will make everything explode on
resume? Maybe it doesn't matter? Somebody well versed in TPMology should
probably [n]ack this approach.

 drivers/char/tpm/tpm-interface.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d69905233aff..6df9067ef7f9 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -412,7 +412,10 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 suspended:
-	return rc;
+	if (rc)
+		pr_err("Unable to suspend tpm-%d (error %d), but continuing system suspend\n",
+		       chip->dev_num, rc);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 
-- 
2.39.0

