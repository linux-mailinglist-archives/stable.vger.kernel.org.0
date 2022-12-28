Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF236579C7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiL1PEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiL1PEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0301813D44
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FDA96153B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAEBC433D2;
        Wed, 28 Dec 2022 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239877;
        bh=ZjtrfsprdOkf+S+ZZbLRs8+7HS8dh63QMFm//u2RRaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsA64Rd7D68mBVDGUuXzd+sS/cCTx0YzrgD1uqURkaRzHXgxiZOHqvaZV69mccPl+
         zeV3+X9EAMlFrQbIdn30o+c0LWJJGEPE/Pr1pQLcBBUEXjgFLMkRNLNXsQHoqSiuQ2
         obbMztTdHI7Z8ATZNXCG0BoUoPUp0hTr26zJosbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0089/1073] tpm: Add flag to use default cancellation policy
Date:   Wed, 28 Dec 2022 15:27:57 +0100
Message-Id: <20221228144330.474907271@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 29f0db41c0b7..e728a61659f8 100644
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



