Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68A75415AB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376823AbiFGUhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378183AbiFGUez (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B111EB407;
        Tue,  7 Jun 2022 11:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E416EB82349;
        Tue,  7 Jun 2022 18:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED74C341C0;
        Tue,  7 Jun 2022 18:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627060;
        bh=d7M/rrGTQxwwpheykmHfdAUrTOWJWEeOlwizrmgwhOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGOtOdV/QC/OmdD7lih1kkFaudcnrVgA2ZTqzWOFjCMmVPQ1Od3/hfhBYb/AH/vuh
         C0p90qJDszZbtF2Zj+CWVABKGnE+nRkYjfDLN0JWDvAUwnDWnZuMsxNUwLvYdkK9Ez
         19TvgsRCP78SaNzKCIMbKxASWmUgFA28qhcfTQjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 562/772] Input: stmfts - do not leave device disabled in stmfts_input_open
Date:   Tue,  7 Jun 2022 19:02:34 +0200
Message-Id: <20220607165005.518300768@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



