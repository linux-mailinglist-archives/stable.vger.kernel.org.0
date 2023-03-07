Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D210E6AEF69
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjCGSXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjCGSXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9E1960B0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123DB614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D64C4339B;
        Tue,  7 Mar 2023 18:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213064;
        bh=LdwjwUkqCg3VSslKLuyiKhIyndt7sTH9884XM14g574=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTGqNv4EjaPfj7CKCrpAYfCQUVvwv1+KZSwiKgy1F4x3IKF5YBYz6Z4x9tYjUQYml
         PDy78xy9RDBsCOdXmP9Cgf6yYIA3x6zFMj4hVZi++RpUep5I2BAQgxq46BBJwRV+qP
         Wm7vJzX6pcqQIJNU7rBLfilMNaxRI6slaAVARdRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vincent Knecht <vincent.knecht@mailoo.org>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 387/885] leds: is31fl319x: Wrap mutex_destroy() for devm_add_action_or_rest()
Date:   Tue,  7 Mar 2023 17:55:21 +0100
Message-Id: <20230307170019.162892958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a82c7cf803d98751cd3ddb35828faad925d71982 ]

Clang complains that devm_add_action() takes a parameter with a wrong type:

warning: cast from 'void (*)(struct mutex *)' to 'void (*)(void *)' converts to incompatible function type [-Wcast-function-type-strict]
    err = devm_add_action(dev, (void (*)(void *))mutex_destroy, &is31->lock);
                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1 warning generated.

It appears that the commit e1af5c815586 ("leds: is31fl319x: Fix devm vs.
non-devm ordering") missed two things:

- whilst the commit mentions devm_add_action_or_reset() the actual change
  utilised devm_add_action() call by mistake
- strictly speaking the parameter is not compatible by type

Fix both issues by switching to devm_add_action_or_reset() and adding a
wrapper for mutex_destroy() call.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e1af5c815586 ("leds: is31fl319x: Fix devm vs. non-devm ordering")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Vincent Knecht <vincent.knecht@mailoo.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221228093238.82713-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-is31fl319x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-is31fl319x.c b/drivers/leds/leds-is31fl319x.c
index b2f4c4ec7c567..7c908414ac7e0 100644
--- a/drivers/leds/leds-is31fl319x.c
+++ b/drivers/leds/leds-is31fl319x.c
@@ -495,6 +495,11 @@ static inline int is31fl3196_db_to_gain(u32 dezibel)
 	return dezibel / IS31FL3196_AUDIO_GAIN_DB_STEP;
 }
 
+static void is31f1319x_mutex_destroy(void *lock)
+{
+	mutex_destroy(lock);
+}
+
 static int is31fl319x_probe(struct i2c_client *client)
 {
 	struct is31fl319x_chip *is31;
@@ -511,7 +516,7 @@ static int is31fl319x_probe(struct i2c_client *client)
 		return -ENOMEM;
 
 	mutex_init(&is31->lock);
-	err = devm_add_action(dev, (void (*)(void *))mutex_destroy, &is31->lock);
+	err = devm_add_action_or_reset(dev, is31f1319x_mutex_destroy, &is31->lock);
 	if (err)
 		return err;
 
-- 
2.39.2



