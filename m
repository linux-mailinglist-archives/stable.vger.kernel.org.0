Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E76540DC9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354043AbiFGSuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354364AbiFGSq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6762C237FF;
        Tue,  7 Jun 2022 11:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA897B82182;
        Tue,  7 Jun 2022 18:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C83C34115;
        Tue,  7 Jun 2022 18:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624853;
        bh=d7M/rrGTQxwwpheykmHfdAUrTOWJWEeOlwizrmgwhOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSMqcAvx/YVtkoq6fWKyobII3QM4Fsb0FEah+3pPJqVXLDO2hObhLVRvEoKu8Gk3C
         1F5+ZzUrA9Ko+9/0Nj0lsmdiRfqk6AyZXO2dyeWic5IQLrYIERi1CrZIYzAkjslXf+
         g7dAO2JfBy+xZeoeEgpBRJ1v6rAJ42Bnwj1DUxZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/667] Input: stmfts - do not leave device disabled in stmfts_input_open
Date:   Tue,  7 Jun 2022 19:02:20 +0200
Message-Id: <20220607164948.949856048@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index 72e0b767e1ba..c175d44c52f3 100644
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



