Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0335406B4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347445AbiFGRhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348686AbiFGRgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:36:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B241145C;
        Tue,  7 Jun 2022 10:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66352614B5;
        Tue,  7 Jun 2022 17:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7899DC34119;
        Tue,  7 Jun 2022 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623163;
        bh=tmYD8/nsll7NJKmVEHlF3A1b8W1FaCtSrxRU7QBuKKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MELragdlSxVByOX+qI2YOR/hqhjTYfcmOG1NMF6sy5xkZg0aDhBHLyna/HDuaezWI
         Fjdj3/6sV4/p/PChtU4aTwdX+Y00pRbugibOmADsk9uT0NBTiN6XjhdpCTbZJwijpt
         GB3dbDMglWa1/MDS8DCfwwfSo0sq1qXP7ButIP4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/452] Input: stmfts - do not leave device disabled in stmfts_input_open
Date:   Tue,  7 Jun 2022 19:02:54 +0200
Message-Id: <20220607164918.004714780@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 64b690a72d10..a05a7a66b4ed 100644
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



