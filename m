Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41571538249
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241354AbiE3OWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiE3ORJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A48010F350;
        Mon, 30 May 2022 06:44:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C312260F24;
        Mon, 30 May 2022 13:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C3AC3411A;
        Mon, 30 May 2022 13:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918240;
        bh=rYEu55Ty2B3c2tcs9cM3GQF/Ak5ZmrxzY55Tk02GvNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Id9RTnmrR3wIlNvP9f1e9H6URLFa8h8FOt7vGXbEMCI+iI55Z7MH2162zHRpAPd/p
         L0q4M4Zw1wFj5wUFs+dZCqEhMM+aHlg/QhBw4ZtFflgUSueS177BT2TYNmcuDeeVUY
         cO4CozKBrJOV7+v679PNgdgKjUjySjxASGoVXnaJUbN3QDzIiGYeq7RvduY5bgIkJ4
         UcMcWQTe9eZFeFhZhe7SBH4UqLyAXdpa1vdj9S80q+PL83/vUbdZxqt9dyN+uIL33x
         uf2GTGD13GLekBQkv0NbM38pJ2uwdDRQv1ICxbYKc7uCFaVdmyEzDpHiWdX6M9cnz+
         X634QihkbV3Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peterhuewe@gmx.de,
        linux-integrity@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 107/109] char: tpm: cr50_i2c: Suppress duplicated error message in .remove()
Date:   Mon, 30 May 2022 09:38:23 -0400
Message-Id: <20220530133825.1933431-107-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e0687fe958f763f1790f22ed5483025b7624e744 ]

Returning an error value in an i2c remove callback results in an error
message being emitted by the i2c core, but otherwise it doesn't make a
difference. The device goes away anyhow and the devm cleanups are
called.

As tpm_cr50_i2c_remove() emits an error message already and the
additional error message by the i2c core doesn't add any useful
information, change the return value to zero to suppress this error
message.

Note that if i2c_clientdata is NULL, there is something really fishy.
Assuming no memory corruption happened (then all bets are lost anyhow),
tpm_cr50_i2c_remove() is only called after tpm_cr50_i2c_probe() returned
successfully. So there was a tpm chip registered before and after
tpm_cr50_i2c_remove() its privdata is freed but the associated character
device isn't removed. If after that happened userspace accesses the
character device it's likely that the freed memory is accessed. For that
reason the warning message is made a bit more frightening.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_i2c_cr50.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_i2c_cr50.c b/drivers/char/tpm/tpm_tis_i2c_cr50.c
index c89278103703..e2ab6a329732 100644
--- a/drivers/char/tpm/tpm_tis_i2c_cr50.c
+++ b/drivers/char/tpm/tpm_tis_i2c_cr50.c
@@ -754,8 +754,8 @@ static int tpm_cr50_i2c_remove(struct i2c_client *client)
 	struct device *dev = &client->dev;
 
 	if (!chip) {
-		dev_err(dev, "Could not get client data at remove\n");
-		return -ENODEV;
+		dev_crit(dev, "Could not get client data at remove, memory corruption ahead\n");
+		return 0;
 	}
 
 	tpm_chip_unregister(chip);
-- 
2.35.1

