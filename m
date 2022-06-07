Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBA9541917
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378169AbiFGVS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380728AbiFGVQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC3E21F9E1;
        Tue,  7 Jun 2022 11:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE7A61794;
        Tue,  7 Jun 2022 18:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1FAC385A2;
        Tue,  7 Jun 2022 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628205;
        bh=iNHK4FsWAeAmGLGVXN+d7gkN/OJ8GAY1t4eehMHASVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsMkhhbx1YaGIOiuB8rTCaIEodtZSB/sMvClPuSJq+mz0eWRNRh0RGitVv9d6GyTu
         kJWPhHNzvll44DgjFLyqUNMlfW/qrQtc7OTX2iVW9EXbxxuZv05u6PRt5wEMi5dbBI
         XtCZy+C3aB1MGs023KIin9edWxVA3KrZFVnsDNsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 203/879] char: tpm: cr50_i2c: Suppress duplicated error message in .remove()
Date:   Tue,  7 Jun 2022 18:55:21 +0200
Message-Id: <20220607165008.738250110@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f6c0affbb456..bf608b6af339 100644
--- a/drivers/char/tpm/tpm_tis_i2c_cr50.c
+++ b/drivers/char/tpm/tpm_tis_i2c_cr50.c
@@ -768,8 +768,8 @@ static int tpm_cr50_i2c_remove(struct i2c_client *client)
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



