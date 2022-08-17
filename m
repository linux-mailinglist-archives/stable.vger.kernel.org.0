Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FF95975D8
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiHQSkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbiHQSko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:40:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3C7A00E8
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:40:40 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 185-20020a6218c2000000b0052d4852d3f6so5290677pfy.5
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=ZYTlBBFnaZ0P/8h1RW7JgkzBP7Qz3/ENWA74waVFHsk=;
        b=rEKzgG4kB4gJbvdPUY9H+lfnRgqahefKDR5Jl73nA4WKGW5kwuqnE88uTY3v00RzaR
         P1XqUhHs+w6cV8koRkvS9gXHlJMZFkJO0Bj5DiMro7jSn6MbktfS4XD+brKZjtIQlDvb
         oF6nNCpMSlQJz8fcZfBUd8ryCNywZ6t4+gIMJS/wasIo4COpmd00eLTiu9rkzKnLBiyj
         jZPGnBjgNjAqfK+18xRawhoR/RLoAcl5bAavj+iTn+QzSSJGMAzogpo0nyPY7URheaJZ
         MLzzf2V3uR8cfruliPSKCDP2Qt73gUn9gGO7Y8hp82RFjbgulhTxsLFZyJSWboAG7dMI
         6FIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=ZYTlBBFnaZ0P/8h1RW7JgkzBP7Qz3/ENWA74waVFHsk=;
        b=sQy4685qi49jrXjYa8IWicK+OozCXx+AsPyUb2EwUNsFPgKqIX6hzc8mthlGH6/odD
         xb0d4FTPekK6s21N9X0Yb1AVxkPDXOSZqlvG5Sf63KoUEPcoxSWpk8Fee2yeuIGt0yX8
         nv4jmpHGb075Su9WFKtW5yVUkenbiKjXtJaRTwj3y3A6n4CqcdfVSWnyFnxPYFo9GJsG
         9pW65OzrgY0CD+z+el6dy5lFO4mSJv8zEtlnw2RkNYQzYi/K8dWKxPqBOfeE5udke0m5
         ZJ15RK5Rhj6A5PWzw468e0SBsg9xVGLvJ2cmi2vLyOviWS1XnB8frtCItznsOb+PljzY
         Alow==
X-Gm-Message-State: ACgBeo15+1TuegiFqAFZg7Bpsg+vXnPTFXbcoHG6IrursHO7w2v3vihr
        /tisNEBMuMgIqhRUIhdW+a9Bw/1mEwPsjMUfJqCeng==
X-Google-Smtp-Source: AA6agR6CY7WhInmP29tG9He+JFpqE/zTM3C8nWq8t4Z4fQTePSj6YMvMB7iBjRaZ4xlxokQyxFxrdpVFfQgF/p2WMWMGoA==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:6c6d:d00:f0dd:6ddf])
 (user=isaacmanjarres job=sendgmr) by 2002:a17:90a:bf0a:b0:1fa:b53c:3f3a with
 SMTP id c10-20020a17090abf0a00b001fab53c3f3amr4095338pjs.126.1660761640140;
 Wed, 17 Aug 2022 11:40:40 -0700 (PDT)
Date:   Wed, 17 Aug 2022 11:40:26 -0700
Message-Id: <20220817184026.3468620-1-isaacmanjarres@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v3] driver core: Don't probe devices after bus_type.match()
 probe deferral
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc:     "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>, kernel-team@android.com,
        linux-kernel@vger.kernel.org
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

Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/dd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

v1 -> v2:
- Fixed the logic in __driver_attach() to allow a driver to continue
  attempting to match and bind with devices in case of any error, not
  just probe deferral.

v2 -> v3:
- Restored the patch back to v1.
- Added Guenter's Tested-by tag.
- Added Saravana's Reviewed-by tag.
- Cc'd stable@vger.kernel.org

Greg,

This is the final version of this patch. Can you please pick this up?

Thanks,
Isaac

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 70f79fc71539..90b31fb141a5 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -881,6 +881,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		dev->can_match = true;
 		driver_deferred_probe_add(dev);
+		/*
+		 * Device can't match with a driver right now, so don't attempt
+		 * to match or bind with other drivers on the bus.
+		 */
+		return ret;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
 		return ret;
@@ -1120,6 +1125,11 @@ static int __driver_attach(struct device *dev, void *data)
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		dev->can_match = true;
 		driver_deferred_probe_add(dev);
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
 		return ret;
-- 
2.37.1.595.g718a3a8f04-goog

