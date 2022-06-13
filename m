Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E334549216
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352551AbiFMLUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352824AbiFMLS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:18:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E64396A3;
        Mon, 13 Jun 2022 03:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86A7EB80EAD;
        Mon, 13 Jun 2022 10:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB13BC3411C;
        Mon, 13 Jun 2022 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116838;
        bh=WBZmf+CrEdtcxiZFnX4Xwx8RWqhSiu8hMOkOUC/WBWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHkdwdCrVOmq0W9rifOKKZx5zGwS6HCETL/8oqazEO0cZFTty47PCrRK0NMBPwvj+
         CGEyhn0E3ZEYFbcLJlBtZNhXFW7t21w1QSlR/kjq3krip5y04blkVXl+XZM3DHmvSU
         WbCZD5F5B5fDViiISn9ed11KiHuQ9tp50O7U2MvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/411] Input: stmfts - do not leave device disabled in stmfts_input_open
Date:   Mon, 13 Jun 2022 12:07:48 +0200
Message-Id: <20220613094934.509129154@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5f76955ab1e43e5795a9631b22ca4f918a0ae986 ]

The commit 26623eea0da3 attempted to deal with potential leak of runtime
PM counter when opening the touchscreen device, however it ended up
erroneously dropping the counter in the case of successfully enabling the
device.

Let's address this by using pm_runtime_resume_and_get() and then executing
pm_runtime_put_sync() only when we fail to send "sense on" command to the
device.

Fixes: 26623eea0da3 ("Input: stmfts - fix reference leak in stmfts_input_open")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/stmfts.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index be1dd504d5b1..20bc2279a2f2 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -337,13 +337,15 @@ static int stmfts_input_open(struct input_dev *dev)
 	struct stmfts_data *sdata = input_get_drvdata(dev);
 	int err;
 
-	err = pm_runtime_get_sync(&sdata->client->dev);
-	if (err < 0)
-		goto out;
+	err = pm_runtime_resume_and_get(&sdata->client->dev);
+	if (err)
+		return err;
 
 	err = i2c_smbus_write_byte(sdata->client, STMFTS_MS_MT_SENSE_ON);
-	if (err)
-		goto out;
+	if (err) {
+		pm_runtime_put_sync(&sdata->client->dev);
+		return err;
+	}
 
 	mutex_lock(&sdata->mutex);
 	sdata->running = true;
@@ -366,9 +368,7 @@ static int stmfts_input_open(struct input_dev *dev)
 				 "failed to enable touchkey\n");
 	}
 
-out:
-	pm_runtime_put_noidle(&sdata->client->dev);
-	return err;
+	return 0;
 }
 
 static void stmfts_input_close(struct input_dev *dev)
-- 
2.35.1



