Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832E75B2661
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiIHTBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiIHTBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 15:01:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781FC1EC76
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 12:01:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k14-20020a25e80e000000b006aa1160dfe3so6366685ybd.5
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 12:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=O4urUyfiGdJyv28nhxclK5Fziywl5uchRNtfEllatqY=;
        b=nSFkuydpP6YjOzhEIc52xjkDtVbdI4kmXCtAq7yCXZcp2do/KumEGdDZoKPE05z/2v
         u2JGZXLhy9MP6gJaMfq37X/cpicPVL108yZsw/2OQimSjod/5s90g6SGxsQXNzaMpDsM
         XZXQwTZGSZ9ap2lVOT9shKtEm9K3z+roK/T7gS3mgdV+tUkx7vHn3u2UQK7LD58dcasi
         fQmNob4SRoltwHmggg/TYlGLnGLYyQJIZv40AoY1E1qcmQlEvvfyWt0OJcLWQlA7jyvn
         XuDA2zH5naXk9ff1EqXLin3O5w0WOEB9KW2kAvefe+5yKU9ilBRYWzQdpZ0h/R1/zI8G
         F7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=O4urUyfiGdJyv28nhxclK5Fziywl5uchRNtfEllatqY=;
        b=MhF7KKp4Mha4Yy87vLmYvKMcu1X5Wiz8Z+qyrPndMZBUm3kPfJaCxJbUIMqbu9mpis
         Uqdumq3zmiGhSAUWfSnU/6TPTQUdGtTRAzCR3UQpIPx+D9csW/EO7Rh+kUjgKoa4/+td
         g/pnqeTF2efOuPbdA23Jh+NMXURediSmN4RclwmzDzDEMRzqSr0utuKH/70ybXNaCHx6
         SVd5b1QD5gackG0i0W+0UOwYoRcERjnJxrwCw2ZUEYcvxeJdwz2kQcrZCUj1c6pqHz/T
         Uov6mQP50XrWHNPNC78hMLND0toCFdz0fvqQ9nPbbSksvPghxu3bSC45rkRGZoLmXvET
         5DAg==
X-Gm-Message-State: ACgBeo08r4NtoEluiTnimGipKlI9l+T/ijU0uHTfkp87YZPIqMGQqXGj
        1Bya3QivKB18nxx43Pbob5+VLmoY5urAmUc0YRUKeg==
X-Google-Smtp-Source: AA6agR6JH4K8ooFy1jWJhKaWW5HBwtz+s+XUeEzFymUz9jxqV82W2wLacKVesqwgLDXnGzEUy2gwHQpImnz/GH8Uz/KkUQ==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:66bd:4175:b3a6:1479])
 (user=isaacmanjarres job=sendgmr) by 2002:a5b:9c4:0:b0:691:7745:afb5 with
 SMTP id y4-20020a5b09c4000000b006917745afb5mr8412716ybq.57.1662663707790;
 Thu, 08 Sep 2022 12:01:47 -0700 (PDT)
Date:   Thu,  8 Sep 2022 12:01:43 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908190144.3731136-1-isaacmanjarres@google.com>
Subject: [PATCH stable-4.14] driver core: Don't probe devices after
 bus_type.match() probe deferral
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 25e9fbf0fd38868a429feabc38abebfc6dbf6542 upstream.

Both __device_attach_driver() and __driver_attach() check the return
code of the bus_type.match() function to see if the device needs to be
added to the deferred probe list. After adding the device to the list,
the logic attempts to bind the device to the driver anyway, as if the
device had matched with the driver, which is not correct.

If __device_attach_driver() detects that the device in question is not
ready to match with a driver on the bus, then it doesn't make sense for
the device to attempt to bind with the current driver or continue
attempting to match with any of the other drivers on the bus. So, update
the logic in __device_attach_driver() to reflect this.

If __driver_attach() detects that a driver tried to match with a device
that is not ready to match yet, then the driver should not attempt to bind
with the device. However, the driver can still attempt to match and bind
with other devices on the bus, as drivers can be bound to multiple
devices. So, update the logic in __driver_attach() to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 drivers/base/dd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index fc27fab62f50..a7bcbb99e820 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -632,6 +632,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		driver_deferred_probe_add(dev);
+		/*
+		 * Device can't match with a driver right now, so don't attempt
+		 * to match or bind with other drivers on the bus.
+		 */
+		return ret;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d", ret);
 		return ret;
@@ -774,6 +779,11 @@ static int __driver_attach(struct device *dev, void *data)
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		driver_deferred_probe_add(dev);
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d", ret);
 		return ret;
-- 
2.37.2.789.g6183377224-goog

