Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332426C7340
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 23:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCWWoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 18:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjCWWod (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 18:44:33 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F134EC4B
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 15:44:32 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t10so1000004edd.12
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 15:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679611470;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CdTVHjsADgrUtpOwBKbWNa8pioeAM2MXvG5m5DIb414=;
        b=AIwzE2gWam3D++FFiSRHrZNXHgSo1VxpihXId3P6pZlHiOBzWXAMWJ4L8dzVEp6t2W
         pKQP/XWRlkU3DdEDT1RW4LSYaCX2/kyNQwqHGjEi5C9JfqKreH1ea4SYiOMQYJgBhU1E
         q4fGN4pQlOB0ukBhe4ZfKxTrQxIMM38h0TEjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611470;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CdTVHjsADgrUtpOwBKbWNa8pioeAM2MXvG5m5DIb414=;
        b=gGejaKKRn2yPGXBohDChWymbmZh4Jz21Qg4K8gy071guXkm+mLmx6o80DGIic2RGpM
         9xOEnUmkY1K0AkgFVO2SSxEmShy5ILhPqEMR81mF/bZNNVmUCecrvZe2BT0xLRzHMZjg
         YJS2dOWwxrfSGy96BDW8QOjSviNzPUq7zKi1DheAYZwSOnPTUSHjKG21XSi26EuXAOrZ
         xPXwwP/+jZieW/wV/Axq/p50Ca3pCYbRJFzq1orqHJtvG3MJojewbdBbkKlg8I9koufb
         CtCXlF4Q9R/OluD6tMd5mw/mK8sDkwf4z5tzwWklLcwbMI5vN36xAxoPmImwteZZOJka
         XaLg==
X-Gm-Message-State: AAQBX9eLvdZwHwG8xAAO8w5TKLD/lCuUd6CWc98v8+mlwLTXGcz8Wh4O
        06mepjwUj6wfmVwHeM5hUpoledGYB4/inwaWiTA=
X-Google-Smtp-Source: AKy350ZJP/I9A3v4zuMzczA4RQlJkvjG2p6CEr49BhX1x7mN+ykKSffar9GSBG0y5kjYjVhVqDvlZA==
X-Received: by 2002:a17:906:27c4:b0:931:c2f0:9437 with SMTP id k4-20020a17090627c400b00931c2f09437mr699584ejc.8.1679611469871;
        Thu, 23 Mar 2023 15:44:29 -0700 (PDT)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id 12-20020a170906310c00b00926d614b890sm9142408ejx.204.2023.03.23.15.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 15:44:29 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 23 Mar 2023 23:44:20 +0100
Subject: [PATCH] media: ov8856: Do not check for for module version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230323-ov8856-otp-v1-0-604f7fd23729@chromium.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Dongchun Zhu <dongchun.zhu@mediatek.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Jimmy Su <jimmy.su@intel.com>, stable@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Max Staudt <mstaudt@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=2803; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=cPmW9PIAQV0oW1FFn7JevApQXapAZ6JE7zWGVu77Wy0=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBkHNZHIMdRe56gkWocjJataai80hqI5TEZVZSNly25
 Ts/uY3CJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCZBzWRwAKCRDRN9E+zzrEiJO+D/
 9II07gziHMA171jdsHqZ9+/rGuhg0AK2NG0ghAZ+0my0yCPcSSLrxJwYfQxYMS9NcFBV4sBz1/AkwI
 3orZcbylZAVIJvZxvOmhUgeZotIqj1+A8OCbYkMW8Gy8SFXdds5Y5YT3nGL8GO2WdWHs+AaC316jW0
 BJ8jBlVFGEt8jG3lxmiw0iESS+rl8EBL85CpYbCM/UgSiu6QcOuUiJwnPy9R1jm54ZE6amhC+u7J7T
 GVN3sB+KWlxXzDlX8V4eeH9ti+7axyDQWGaNk508KUymqgXAEnhFWP6L51vOJt9HoxJNyLZtCyKaSb
 +Y8R53bwpWcE4gM7yN9MmbgB89Gf40XEVQeAGyk24AvYdqze5xY2XR3nXDMaGW5bu2C1bcM3vkBc22
 A0QwdqhHkyTyjVkZb+u7yz1s6Q+6OAqYFPV70CzPtcNAJxAa2yMKRw8c+sb3Zu+LK1Zz7ldpFXC7XN
 Xt5c+LEezeA0DPcjGw6cXXQoNsB3y8YGoaN3is4lYG/72hpdMUihGua33yTW+BbCHO3RHpxTRzbLEe
 OdetfsHBoTwYrYPYgRfUgEWbkLJuby5LVQsgsqjbD2bg+n+3qNycWPe7WRNKe/BvEl/wPSt506yY3H
 AOCxSPxtnJVf38k1UT6La4Aw8igQiT3fvqOtVXWu7GY3mP8ZDx+rE1wlqekw==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It the device is probed in non-zero ACPI D state, the module
identification is delayed until the first streamon.

The module identification has two parts: deviceID and version. To rea
the version we have to enable OTP read. This cannot be done during
streamon, becase it modifies REG_MODE_SELECT.

Since the driver has the same behaviour for all the module versions, do
not read the module version from the sensor's OTP.

Cc: stable@vger.kernel.org
Fixes: 0e014f1a8d54 ("media: ov8856: support device probe in non-zero ACPI D state")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
To: Dongchun Zhu <dongchun.zhu@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Bingbu Cao <bingbu.cao@intel.com>
Cc: Max Staudt <mstaudt@chromium.org>
Cc: Jimmy Su <jimmy.su@intel.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/i2c/ov8856.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
index cf8384e09413..b5c7881383ca 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -1709,46 +1709,6 @@ static int ov8856_identify_module(struct ov8856 *ov8856)
 		return -ENXIO;
 	}
 
-	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
-			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STREAMING);
-	if (ret)
-		return ret;
-
-	ret = ov8856_write_reg(ov8856, OV8856_OTP_MODE_CTRL,
-			       OV8856_REG_VALUE_08BIT, OV8856_OTP_MODE_AUTO);
-	if (ret) {
-		dev_err(&client->dev, "failed to set otp mode");
-		return ret;
-	}
-
-	ret = ov8856_write_reg(ov8856, OV8856_OTP_LOAD_CTRL,
-			       OV8856_REG_VALUE_08BIT,
-			       OV8856_OTP_LOAD_CTRL_ENABLE);
-	if (ret) {
-		dev_err(&client->dev, "failed to enable load control");
-		return ret;
-	}
-
-	ret = ov8856_read_reg(ov8856, OV8856_MODULE_REVISION,
-			      OV8856_REG_VALUE_08BIT, &val);
-	if (ret) {
-		dev_err(&client->dev, "failed to read module revision");
-		return ret;
-	}
-
-	dev_info(&client->dev, "OV8856 revision %x (%s) at address 0x%02x\n",
-		 val,
-		 val == OV8856_2A_MODULE ? "2A" :
-		 val == OV8856_1B_MODULE ? "1B" : "unknown revision",
-		 client->addr);
-
-	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
-			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STANDBY);
-	if (ret) {
-		dev_err(&client->dev, "failed to exit streaming mode");
-		return ret;
-	}
-
 	ov8856->identified = true;
 
 	return 0;

---
base-commit: 9fd6ba5420ba2b637d1ecc6de8613ec8b9c87e5a
change-id: 20230323-ov8856-otp-112f3cdc74b1

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
