Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8FB566FE0
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 15:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiGENva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 09:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbiGENvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 09:51:14 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C1F237D0;
        Tue,  5 Jul 2022 06:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1657027484;
  x=1688563484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=keBvT11AkM8MQQ8xbVHjfoxCbaKO5OZ97FSscysqk+U=;
  b=FztiFUgZorB99QtAgjs1xMiIyiUgbG9iN5HlrIx2suNb7C2xm0fshSVT
   P/OtsCHEPJgBGR49kVr36hmBH9iwFVrys623ynfypC8YH7waThBdng7wj
   GWmawjnBLI5AoGHd8h2E00DeQituMKuhyWWLyB9flK44SOqUzPnArdUcr
   9RINt0BboYoH7OCjdRNrgk7p7p4my6mDUHdScC6s8cdNFLVJKt63Pj1+/
   xkbGcGOadcb+MSIn4s2ALvIYVhK1ciY2xOI4MPRVE0LzLFvT8VtuvSAzP
   trYo1jKq6qpq3fii3ZagqOBQQXeMUtnVBogIjsdMEAlKYjUuf8A247YC4
   A==;
From:   =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, <linux-integrity@vger.kernel.org>,
        <kernel@axis.com>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] tpm: Add check for Failure mode for TPM2 modules
Date:   Tue, 5 Jul 2022 15:24:23 +0200
Message-ID: <20220705132423.232603-1-marten.lindahl@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 0aa698787aa2 ("tpm: Add Upgrade/Reduced mode support for
TPM2 modules") it was said that:

"If the TPM is in Failure mode, it will successfully respond to both
tpm2_do_selftest() and tpm2_startup() calls. Although, will fail to
answer to tpm2_get_cc_attrs_tbl(). Use this fact to conclude that TPM
is in Failure mode."

But a check was never added in the commit when calling
tpm2_get_cc_attrs_tbl() to conclude that the TPM is in Failure mode.
This commit corrects this by adding a check.

Fixes: 0aa698787aa2 ("tpm: Add Upgrade/Reduced mode support for TPM2 modules")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v3:
 - Add Jarkkos Reviewed-by tag.
 - Add Fixes tag and Cc.

v2:
 - Add missed check for TPM error code.

 drivers/char/tpm/tpm2-cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index c1eb5d223839..65d03867e114 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -752,6 +752,12 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	}
 
 	rc = tpm2_get_cc_attrs_tbl(chip);
+	if (rc == TPM2_RC_FAILURE || (rc < 0 && rc != -ENOMEM)) {
+		dev_info(&chip->dev,
+			 "TPM in field failure mode, requires firmware upgrade\n");
+		chip->flags |= TPM_CHIP_FLAG_FIRMWARE_UPGRADE;
+		rc = 0;
+	}
 
 out:
 	/*
-- 
2.30.2

