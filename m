Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CAF594257
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349795AbiHOVsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349857AbiHOVqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:46:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEFE644E;
        Mon, 15 Aug 2022 12:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE371B810C6;
        Mon, 15 Aug 2022 19:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DB2C433D6;
        Mon, 15 Aug 2022 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591820;
        bh=U0Fp6bBZo1hCOVqL02YpZuqrGduWivDPT289EDLIBxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWmNt/aekYl+c0hJj3yeFWG/tghHKKd5ItCYlipdG5iWPoBWeGjLgQIj4Wz2JFfZl
         Nv/5twuHvw6RVlJSxw9qi9WX0G3XGS8YPYiMzJdLHVRE8ef5TJ+l/P6uvelx/NUXGq
         7jKVvIzLHNSI7LS09gBhMUrdwGHqkwrA3ocZZ/IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zolt=C3=A1n=20K=C5=91v=C3=A1g=C3=B3?= 
        <dirty.ice.hu@gmail.com>, stable@kernel.org,
        Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.19 0013/1157] hwmon: (nct6775) Fix platform driver suspend regression
Date:   Mon, 15 Aug 2022 19:49:29 +0200
Message-Id: <20220815180439.996384192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

commit f4e6960f4f16b1ca5da16cec7612ecc86402ac05 upstream.

Commit c3963bc0a0cf ("hwmon: (nct6775) Split core and platform
driver") introduced a slight change in nct6775_suspend() in order to
avoid an otherwise-needless symbol export for nct6775_update_device(),
replacing a call to that function with a simple dev_get_drvdata()
instead.

As it turns out, there is no guarantee that nct6775_update_device()
is ever called prior to suspend. If this happens, the resume function
ends up writing bad data into the various chip registers, which results
in a crash shortly after resume.

To fix the problem, just add the symbol export and return to using
nct6775_update_device() as was employed previously.

Reported-by: Zoltán Kővágó <dirty.ice.hu@gmail.com>
Tested-by: Zoltán Kővágó <dirty.ice.hu@gmail.com>
Fixes: c3963bc0a0cf ("hwmon: (nct6775) Split core and platform driver")
Cc: stable@kernel.org
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Link: https://lore.kernel.org/r/20220810052646.13825-1-zev@bewilderbeest.net
[groeck: Updated description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-core.c     | 3 ++-
 drivers/hwmon/nct6775-platform.c | 2 +-
 drivers/hwmon/nct6775.h          | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 446964cbae4c..da9ec6983e13 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -1480,7 +1480,7 @@ static int nct6775_update_pwm_limits(struct device *dev)
 	return 0;
 }
 
-static struct nct6775_data *nct6775_update_device(struct device *dev)
+struct nct6775_data *nct6775_update_device(struct device *dev)
 {
 	struct nct6775_data *data = dev_get_drvdata(dev);
 	int i, j, err = 0;
@@ -1615,6 +1615,7 @@ static struct nct6775_data *nct6775_update_device(struct device *dev)
 	mutex_unlock(&data->update_lock);
 	return err ? ERR_PTR(err) : data;
 }
+EXPORT_SYMBOL_GPL(nct6775_update_device);
 
 /*
  * Sysfs callback functions
diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index ab30437221ce..41c97cfacfb8 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -359,7 +359,7 @@ static int __maybe_unused nct6775_suspend(struct device *dev)
 {
 	int err;
 	u16 tmp;
-	struct nct6775_data *data = dev_get_drvdata(dev);
+	struct nct6775_data *data = nct6775_update_device(dev);
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
diff --git a/drivers/hwmon/nct6775.h b/drivers/hwmon/nct6775.h
index 93f708148e65..be41848c3cd2 100644
--- a/drivers/hwmon/nct6775.h
+++ b/drivers/hwmon/nct6775.h
@@ -196,6 +196,8 @@ static inline int nct6775_write_value(struct nct6775_data *data, u16 reg, u16 va
 	return regmap_write(data->regmap, reg, value);
 }
 
+struct nct6775_data *nct6775_update_device(struct device *dev);
+
 bool nct6775_reg_is_word_sized(struct nct6775_data *data, u16 reg);
 int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		  const struct regmap_config *regmapcfg);
-- 
2.37.1



