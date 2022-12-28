Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40D3657A6C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiL1PLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiL1PK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:10:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6B313E00
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F37FB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01611C433D2;
        Wed, 28 Dec 2022 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240256;
        bh=5p5XapdduFu5x6RJ/vft6XaAAqGCL1qDdotRGVHZb/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7/3c1FP92sTMkXfMB+VZCfxn1RFquY00WNqxc8vjMwEc87X7vTDo4kPXeJUtrH3c
         UFGbHuHf41lz1HvdtBI2RoyiUcI5E79eq5UzY1Xk7DU97qWeKeA7G+0lq589YtGuco
         12UpSQfpjrLX6jTtNuWOH7HH9bxFX5fqx1D/73gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0101/1146] tpm: Add flag to use default cancellation policy
Date:   Wed, 28 Dec 2022 15:27:20 +0100
Message-Id: <20221228144332.886471322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 7bfda9c73fa9710a842a7d6f89b024351c80c19c ]

The check for cancelled request depends on the VID of the chip, but
some chips share VID which shouldn't share their cancellation
behavior. This is the case for the Nuvoton NPCT75X, which should use
the default cancellation check, not the Winbond one.
To avoid changing the existing behavior, add a new flag to indicate
that the chip should use the default cancellation check and set it
for the I2C TPM2 TIS driver.

Fixes: bbc23a07b072 ("tpm: Add tpm_tis_i2c backend for tpm_tis_core")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Tested-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 20 ++++++++++++--------
 drivers/char/tpm/tpm_tis_core.h |  1 +
 drivers/char/tpm/tpm_tis_i2c.c  |  1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 757623bacfd5..3f98e587b3e8 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -682,15 +682,19 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	switch (priv->manufacturer_id) {
-	case TPM_VID_WINBOND:
-		return ((status == TPM_STS_VALID) ||
-			(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
-	case TPM_VID_STM:
-		return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
-	default:
-		return (status == TPM_STS_COMMAND_READY);
+	if (!test_bit(TPM_TIS_DEFAULT_CANCELLATION, &priv->flags)) {
+		switch (priv->manufacturer_id) {
+		case TPM_VID_WINBOND:
+			return ((status == TPM_STS_VALID) ||
+				(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
+		case TPM_VID_STM:
+			return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
+		default:
+			break;
+		}
 	}
+
+	return status == TPM_STS_COMMAND_READY;
 }
 
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 66a5a13cd1df..b68479e0de10 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -86,6 +86,7 @@ enum tis_defaults {
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
 	TPM_TIS_INVALID_STATUS		= BIT(1),
+	TPM_TIS_DEFAULT_CANCELLATION	= BIT(2),
 };
 
 struct tpm_tis_data {
diff --git a/drivers/char/tpm/tpm_tis_i2c.c b/drivers/char/tpm/tpm_tis_i2c.c
index 635a69dfcbbd..f3a7251c8e38 100644
--- a/drivers/char/tpm/tpm_tis_i2c.c
+++ b/drivers/char/tpm/tpm_tis_i2c.c
@@ -329,6 +329,7 @@ static int tpm_tis_i2c_probe(struct i2c_client *dev,
 	if (!phy->io_buf)
 		return -ENOMEM;
 
+	set_bit(TPM_TIS_DEFAULT_CANCELLATION, &phy->priv.flags);
 	phy->i2c_client = dev;
 
 	/* must precede all communication with the tpm */
-- 
2.35.1



