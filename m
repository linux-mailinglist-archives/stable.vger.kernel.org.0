Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E237AAA83A
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbfIEQSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33932 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388676AbfIEQSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id r12so2091087pfh.1
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hTEru9Lo54OU309HOwpQ2LAFUsKEGLtu5GnynJbae0I=;
        b=UXrdRBNRv4eBFBI2US9eb56BJw2QFySRmdCdiI/+LAIvG/m2c60c9K3NqHc9JzTcvb
         d8dwqHteqwZIJwmYizpsubVkvO7TeVXDOVTe6aX5zdW2UD3IAtqJ/uiyS9Lx2SPK8Tif
         Ec3qJAS3tr4mZ7bec9KhbwJfgkz2i4i8m38SHu1mvaoBC5wPzGtmlDymSmvre0XS7bbB
         i4Ro8UZZSf2iDGafbRHglF0mzarE9YVWxA+kdHTx/AktvE3YQZ90hkW58NANUCfMxmkq
         vIUoM/uekP6tFp8QDwySUHFho1wZKNrREHBB6M0EcCmSSQ1TR8BMwXKfB/JtNSwWr7kI
         o+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hTEru9Lo54OU309HOwpQ2LAFUsKEGLtu5GnynJbae0I=;
        b=SyJFv7VgOvkyCMOWbHf5BryLp44gfCdtgBCXsdW+YHnEpDfB2zivW9AmNfS8T0qhhc
         +vi1108ibazIQkctnLk7AlssEozxmRC+w2d5SgBlVPFSXqFF8OlTp32xNgj+AK7aVEgM
         fSjpUeBg8he48I1fea4sTeqEAJZ5gsy2uyz1jzkUBQ5Mdkq3i/1OR5SumdcISmcR8HUs
         ekM67Bq8bSTCZ7K2T9Dxk/lIyOFQLRxiqRDvLDHuNW+zRIIhaoimUYHnyP0jTOmciOQn
         dS3V7miBCdT+RdftPjikMnmsgN8Hjg34JCz8G+r89sUuievVSlGYQqB0LldFh96zfGiT
         6EOw==
X-Gm-Message-State: APjAAAVmgZdfsG/ZvmwHGX5vW1mB1NkGapmcgQmQyJi3rx9KSK0l1zVE
        HPVVCEbubRP31yp93P8XFl8qkVXWj+Y=
X-Google-Smtp-Source: APXvYqw5OdtGz9h32B1utEihP+LRew80y2W8OC4yKoEUMG1OkpNOOTrJlR12V0LXuIQ89YtUTd464w==
X-Received: by 2002:a63:a35c:: with SMTP id v28mr3980810pgn.144.1567700301882;
        Thu, 05 Sep 2019 09:18:21 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:21 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 17/18] i2c: omap: Trigger bus recovery in lockup case
Date:   Thu,  5 Sep 2019 10:17:58 -0600
Message-Id: <20190905161759.28036-18-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Foellmi <claudio.foellmi@ergon.ch>

commit 93367bfca98f36cece57c01dbce6ea1b4ac58245 upstream

A very conservative check for bus activity (to prevent interference
in multimaster setups) prevented the bus recovery methods from being
triggered in the case that SDA or SCL was stuck low.
This defeats the purpose of the recovery mechanism, which was introduced
for exactly this situation (a slave device keeping SDA pulled down).

Also added a check to make sure SDA is low before attempting recovery.
If SDA is not stuck low, recovery will not help, so we can skip it.

Note that bus lockups can persist across reboots. The only other options
are to reset or power cycle the offending slave device, and many i2c
slaves do not even have a reset pin.

If we see that one of the lines is low for the entire timeout duration,
we can actually be sure that there is no other master driving the bus.
It is therefore save for us to attempt a bus recovery.

Signed-off-by: Claudio Foellmi <claudio.foellmi@ergon.ch>
Tested-by: Vignesh R <vigneshr@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
[wsa: fixed one return code to -EBUSY]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/i2c/busses/i2c-omap.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 12ba183693d6..a03564f41ad0 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -486,6 +486,22 @@ static int omap_i2c_init(struct omap_i2c_dev *omap)
 	return 0;
 }
 
+/*
+ * Try bus recovery, but only if SDA is actually low.
+ */
+static int omap_i2c_recover_bus(struct omap_i2c_dev *omap)
+{
+	u16 systest;
+
+	systest = omap_i2c_read_reg(omap, OMAP_I2C_SYSTEST_REG);
+	if ((systest & OMAP_I2C_SYSTEST_SCL_I_FUNC) &&
+	    (systest & OMAP_I2C_SYSTEST_SDA_I_FUNC))
+		return 0; /* bus seems to already be fine */
+	if (!(systest & OMAP_I2C_SYSTEST_SCL_I_FUNC))
+		return -EBUSY; /* recovery would not fix SCL */
+	return i2c_recover_bus(&omap->adapter);
+}
+
 /*
  * Waiting on Bus Busy
  */
@@ -496,7 +512,7 @@ static int omap_i2c_wait_for_bb(struct omap_i2c_dev *omap)
 	timeout = jiffies + OMAP_I2C_TIMEOUT;
 	while (omap_i2c_read_reg(omap, OMAP_I2C_STAT_REG) & OMAP_I2C_STAT_BB) {
 		if (time_after(jiffies, timeout))
-			return i2c_recover_bus(&omap->adapter);
+			return omap_i2c_recover_bus(omap);
 		msleep(1);
 	}
 
@@ -577,8 +593,13 @@ static int omap_i2c_wait_for_bb_valid(struct omap_i2c_dev *omap)
 		}
 
 		if (time_after(jiffies, timeout)) {
+			/*
+			 * SDA or SCL were low for the entire timeout without
+			 * any activity detected. Most likely, a slave is
+			 * locking up the bus with no master driving the clock.
+			 */
 			dev_warn(omap->dev, "timeout waiting for bus ready\n");
-			return -ETIMEDOUT;
+			return omap_i2c_recover_bus(omap);
 		}
 
 		msleep(1);
-- 
2.17.1

