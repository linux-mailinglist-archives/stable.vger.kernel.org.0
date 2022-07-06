Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DA1568F59
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 18:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiGFQlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 12:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiGFQlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 12:41:17 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE11C938;
        Wed,  6 Jul 2022 09:41:17 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id h19so19028435qtp.6;
        Wed, 06 Jul 2022 09:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wNYT3EUUh0A5BJ8lGJoIFptDo9tLPtEzGQ8q5urBmB0=;
        b=dMKp8xErSwTiUyJoQS+KQBt7xhCLTSYtwhtUUw+YQNlV+HRalMxnKDX4QJ9SMERZuv
         hFixOUXTM2/0fKMW9G7KsAjGS5xKhq94fzGzV3ZPXgR/hQGH3Vd59e6SUosJuMRwefbs
         S8xlqVWAUW8v3bipXwguM2nkxjraZBYmcscQC8A3PeLMcg+pHCWAMy+yns3VvPiSiiUO
         btipaHh6n0pcfRPm+9QYgDaEgxs3go91+YqTMnJe+KEZJJdY72yhQP07Z1ud8MX2Oq6v
         N9FO8Ore4l+ITC3TFxMlX4K9+3xCDT42JDRrCmxKP8bUMXyr2wtodh2wkPPbzgUu8nSO
         zX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wNYT3EUUh0A5BJ8lGJoIFptDo9tLPtEzGQ8q5urBmB0=;
        b=zBd1CUeKEfRomVHJDPPB2peAL0/0PquZTWun/OWMrmHOTSfRih2HmsMMUzgnwEftc5
         tQFqqv9RL6KFPNqKE3xYJDaI2irQ4yqpndVO7Y5ZZlQovTyXJUiX9dL0DYdiPLdeRqP9
         halYo9SVYvRDFH+tmnAuJ+kNKeNNuzCvvD74mZaQofNAKOUAZwAQ/+uexDvwqscjzHX2
         yxIjrY4zJ+Jkjm8THZUfa13JfbGIg/60+aW3VIn7TI3Vld5fAk4pmmnUOk+VeHAc67Im
         /xfp/62lvNIqKmiu9jelYZHafsL555cn97tRJ7vqRwdboiUcJTalhHGmkgzp7Lnts6vk
         bYmw==
X-Gm-Message-State: AJIora8eseJVNMZ3TovC6UGbfA0hz/w05r4yWlIiDYPOw6/JkbobetLh
        3WDh+gUzJIxfja9WQnEgE5d8FalsjmE=
X-Google-Smtp-Source: AGRyM1tEUUheMPtuQLLJk1ir4YLG/oKk+nuSbpPJ3qqgyX1LNgPiMtQH4RRgHOxDz6pzIyxofOVtvA==
X-Received: by 2002:ad4:5bc3:0:b0:472:f2a2:dd7e with SMTP id t3-20020ad45bc3000000b00472f2a2dd7emr14370081qvt.8.1657125676175;
        Wed, 06 Jul 2022 09:41:16 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com ([2001:470:8:67e:84b5:e0c:e62c:c854])
        by smtp.gmail.com with ESMTPSA id v38-20020a05622a18a600b0031a84ecd4d1sm20706429qtc.95.2022.07.06.09.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 09:41:15 -0700 (PDT)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Chen Jun <chenjun102@huawei.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jason Andryuk <jandryuk@gmail.com>, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tpm_tis: Hold locality open during probe
Date:   Wed,  6 Jul 2022 12:40:43 -0400
Message-Id: <20220706164043.417780-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

WEC TPMs (in 1.2 mode) and NTC (in 2.0 mode) have been observer to
frequently, but intermittently, fail probe with:
tpm_tis: probe of 00:09 failed with error -1

Added debugging output showed that the request_locality in
tpm_tis_core_init succeeds, but then the tpm_chip_start fails when its
call to tpm_request_locality -> request_locality fails.

The access register in check_locality would show:
0x80 TPM_ACCESS_VALID
0x82 TPM_ACCESS_VALID | TPM_ACCESS_REQUEST_USE
0x80 TPM_ACCESS_VALID
continuing until it times out. TPM_ACCESS_ACTIVE_LOCALITY (0x20) doesn't
get set which would end the wait.

My best guess is something racy was going on between release_locality's
write and request_locality's write.  There is no wait in
release_locality to ensure that the locality is released, so the
subsequent request_locality could confuse the TPM?

tpm_chip_start grabs locality 0, and updates chip->locality.  Call that
before the TPM_INT_ENABLE write, and drop the explicit request/release
calls.  tpm_chip_stop performs the release.  With this, we switch to
using chip->locality instead of priv->locality.  The probe failure is
not seen after this.

commit 0ef333f5ba7f ("tpm: add request_locality before write
TPM_INT_ENABLE") added a request_locality/release_locality pair around
tpm_tis_write32 TPM_INT_ENABLE, but there is a read of
TPM_INT_ENABLE for the intmask which should also have the locality
grabbed.  tpm_chip_start is moved before that to have the locality open
during the read.

Fixes: 0ef333f5ba7f ("tpm: add request_locality before write TPM_INT_ENABLE")
CC: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
---
The probe failure was seen on 5.4, 5.15 and 5.17.

commit e42acf104d6e ("tpm_tis: Clean up locality release") removed the
release wait.  I haven't tried, but re-introducing that would probably
fix this issue.  It's hard to know apriori when a synchronous wait is
needed, and they don't seem to be needed typically.  Re-introducing the
wait would re-introduce a wait in all cases.

Surrounding the read of TPM_INT_ENABLE with grabbing the locality may
not be necessary?  It looks like the code only grabs a locality for
writing, but that asymmetry is surprising to me.

tpm_chip and tpm_tis_data track the locality separately.  Should the
tpm_tis_data one be removed so they don't get out of sync?
---
 drivers/char/tpm/tpm_tis_core.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index dc56b976d816..529c241800c0 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -986,8 +986,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		goto out_err;
 	}
 
+	/* Grabs locality 0. */
+	rc = tpm_chip_start(chip);
+	if (rc)
+		goto out_err;
+
 	/* Take control of the TPM's interrupt hardware and shut it off */
-	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
+	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(chip->locality), &intmask);
 	if (rc < 0)
 		goto out_err;
 
@@ -995,19 +1000,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 
-	rc = request_locality(chip, 0);
-	if (rc < 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
-	release_locality(chip, 0);
+	tpm_tis_write32(priv, TPM_INT_ENABLE(chip->locality), intmask);
 
-	rc = tpm_chip_start(chip);
-	if (rc)
-		goto out_err;
 	rc = tpm2_probe(chip);
+	/* Releases locality 0. */
 	tpm_chip_stop(chip);
 	if (rc)
 		goto out_err;
-- 
2.36.1

