Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA55AF2B2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 19:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiIFRe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 13:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiIFReL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 13:34:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71352186
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 10:29:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l12-20020a25ad4c000000b006a8e04c284dso5642994ybe.11
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 10:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=kiOrB5yWFxCLoNxe+9LT00TIOWI2BPkFlWeuOIoCnH0=;
        b=D7wUnaukzGksmUg3rCY79VHdeMa6j7UOfHsOqV2yuo7aHI/jmAwDDTmEpmMGngTrZ+
         +W8b5/x5OiSmoyAWh2YTrFFZ7AOWRgrbpa7ZZcN+IYHUj8AinkQreG4wMRJAVuiYhBs4
         BNhbS1npw+86kYMSnnn7EdkQS951AW5evheBAx3C+YWbCMcfiZsyCaIhOshoj/MbHJgL
         XI112cvhbsj0p9fQ8ckBAuEfMhM4erj/aEQquw/UpIJKWlUnF6txko3uxgP4iICk7i3B
         d+RioD0OlCTPaAC1erm6uCRJ2tO2q/oZ8OBEklUWTZ7Vq4diU8FD2vLa0CyxJruG36Fa
         h5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=kiOrB5yWFxCLoNxe+9LT00TIOWI2BPkFlWeuOIoCnH0=;
        b=S0gJdPFyTuH30gCjDiJotWPaRHUJ/e2cRf5KVfuSIZkG2Z3jyDklwcMAgMVVJOErBe
         Va1iwUWQq5Dq663aQutIvbnC14nTxrv98T0So65d7YzSlSkNKCOkA3FRCS3+SFOu3twl
         EzWBMQVI2t+eKkbW7jyeH5hkjsoVfn0nXggDNnHCt72A83euOFtQZsS40BvRfyTJjdij
         665z6w4K9Yz9c7aEx2fX0J5DSanr2fUvSwnCrE9KFcdjYLE6bidACkPpQl0D48tP/RqW
         /lsxdj3ll0poMF3jZQhFjDxCyKMYpnDv4UNlIiyHp7nlq061B00WK+OU8t/4qK12pq0A
         q3cQ==
X-Gm-Message-State: ACgBeo2MX0w9I4nGlqLDoX8JVBnBCFV9yVQxVglSuv+oz2GPki8KI1o4
        RsXlXxK0ouRkoLQF8Ex3RVDT3p1saeMeQtkVsd65Pg==
X-Google-Smtp-Source: AA6agR6g8n5FIE5HRy5n8m5MNBxDTfEelEAVRECD1wsrGQA7m2kQlteRDHIhgST4uqLOWlel4EKGOZ11NE16U7UFd67Z8Q==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:96d9:b0ea:9ff9:ee9f])
 (user=isaacmanjarres job=sendgmr) by 2002:a5b:a0f:0:b0:691:6fea:deda with
 SMTP id k15-20020a5b0a0f000000b006916feadedamr37037278ybq.377.1662485377308;
 Tue, 06 Sep 2022 10:29:37 -0700 (PDT)
Date:   Tue,  6 Sep 2022 10:29:33 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906172933.410698-1-isaacmanjarres@google.com>
Subject: [PATCH stable-4.19/4.14/4.9] driver core: Don't probe devices after
 bus_type.match() probe deferral
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 26ba7a99b7d5..63390a416b44 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -738,6 +738,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
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
@@ -891,6 +896,11 @@ static int __driver_attach(struct device *dev, void *data)
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

