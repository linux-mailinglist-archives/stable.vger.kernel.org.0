Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7479E39210C
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 21:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhEZTok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 15:44:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:38650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhEZToj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 15:44:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622058186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=PDr39Ej3qpXf1ztiFP8D4NcikT1U25GcUHsEX5q8P2Q=;
        b=WPdW5C/mFutCugh4ULAVqQeh1IXJQuKMdVt3cTawXj10HXFKTrDkv792PMVP0fAK1ojyzl
        gG33wErSQyJV8r9Jd85lwcv9DonJRw35MvSX7rEfWuo3pGm92OdWg4fkj7B00OdNObmiOP
        YK5VtRXqU7jSMGIvFWX5IKVsOzvd2dc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622058186;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=PDr39Ej3qpXf1ztiFP8D4NcikT1U25GcUHsEX5q8P2Q=;
        b=Dyko30elgdOA/4/L7YoOPCqGxB6ndErjplaeRLXsmTx5HZrpcACU52cDNXzqXCUJ9a4+jD
        lsWQvn1c3xQuRQDA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4196BAB71;
        Wed, 26 May 2021 19:43:06 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] Input: elants_i2c - Fix NULL dereference at probing
Date:   Wed, 26 May 2021 21:43:01 +0200
Message-Id: <20210526194301.28780-1-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent change in elants_i2c driver to support more chips
introduced a regression leading to Oops at probing.  The driver reads
id->driver_data, but the id may be NULL depending on the device type
the driver gets bound.

Add a NULL check and falls back to the default EKTH3500.

Fixes: 9517b95bdc46 ("Input: elants_i2c - add support for eKTF3624")
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1186454
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/input/touchscreen/elants_i2c.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
index 17540bdb1eaf..172a6951cead 100644
--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -1396,7 +1396,10 @@ static int elants_i2c_probe(struct i2c_client *client,
 	init_completion(&ts->cmd_done);
 
 	ts->client = client;
-	ts->chip_id = (enum elants_chip_id)id->driver_data;
+	if (id)
+		ts->chip_id = (enum elants_chip_id)id->driver_data;
+	else
+		ts->chip_id = EKTH3500;
 	i2c_set_clientdata(client, ts);
 
 	ts->vcc33 = devm_regulator_get(&client->dev, "vcc33");
-- 
2.26.2

