Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EEF653A97
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 03:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiLVC0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 21:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiLVC0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 21:26:50 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D44E65FB
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 18:26:49 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id i83so349997ioa.11
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 18:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t6eb2QLxGLA5nQWox1Il1mb2LunPDzmdoel/IXxPIUE=;
        b=lqFalmTuR89YV96zutl+2zViNboGd6NP7NUPn24Jfc7wEe13OpK7k5Yxw9oFR1VCVJ
         EjwSUfnQ3groAx71Zed974hxE8G6xpMMpnyHXDlfog3zBI2HFPe66EEt37PzVnkEgs2p
         VSfhsC/OWfr7Kuu7VUfS5etJaDVBJXAEoMcyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6eb2QLxGLA5nQWox1Il1mb2LunPDzmdoel/IXxPIUE=;
        b=TY8g+DfgsXNXWikUxM3AQ6fxAks75WJEEIWT/ghmBCbD2XRWqbQCZ2+r8R91dG1CGW
         9jaKtsUVIfBBDm7i1rpjGAGybUc8KM06q5IKTo7VCXSsZvfjK7z8VM0yiBJpuE5te4C7
         7doKkgJJ/RcGmEAosBcbN2jXNqucyhQTdRnZs8OM+oXRRYUj6EN3oJdC34TGNB7ntMsE
         ZzwOmHtqrbqLN92Nl9xZcZ5AC6zMQmq0tM42pxK0TSVARCMR4kOTN5nzBinOb5fP2dTr
         chVU37+YkiIafYcebUXsEXdZlHOuWYfGsLwjfDI7nn+fIhEiBAunRfLthpPoHBBridVu
         a+Rw==
X-Gm-Message-State: AFqh2kpurKPHqLBdJ4mFgOPjPwXSdvc1dyWpmg5sJJRQK03/uhHui4TM
        TVfOHkZQpv4yHhBqU2gtTId07Q==
X-Google-Smtp-Source: AMrXdXuJdoc6h1EjuJLY3ZLbT/1BvUU+55g84Ob7FJSai4KIMVeLOP7kr2txXkL2JF10O5AQfLYhIA==
X-Received: by 2002:a5d:9347:0:b0:6de:acb8:636d with SMTP id i7-20020a5d9347000000b006deacb8636dmr2382046ioo.19.1671676008773;
        Wed, 21 Dec 2022 18:26:48 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id i1-20020a056602134100b006a129b10229sm6812507iov.31.2022.12.21.18.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 18:26:48 -0800 (PST)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform devices for DT nodes without 'vdd-supply'
Date:   Thu, 22 Dec 2022 02:26:44 +0000
Message-Id: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The primary task of the onboard_usb_hub driver is to control the
power of an onboard USB hub. The driver gets the regulator from the
device tree property "vdd-supply" of the hub's DT node. Some boards
have device tree nodes for USB hubs supported by this driver, but
don't specify a "vdd-supply". This is not an error per se, it just
means that the onboard hub driver can't be used for these hubs, so
don't create platform devices for such nodes.

This change doesn't completely fix the reported regression. It
should fix it for the RPi 3 B Plus and boards with similar hub
configurations (compatible DT nodes without "vdd-supply"), boards
that actually use the onboard hub driver could still be impacted
by the race conditions discussed in that thread. Not creating the
platform devices for nodes without "vdd-supply" is the right
thing to do, independently from the race condition, which will
be fixed in future patch.

Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v2:
- don't create platform devices when "vdd-supply" is missing,
  rather than returning an error from _find_onboard_hub()
- check for "vdd-supply" not "vdd" (Johan)
- updated subject and commit message
- added 'Link' tag (regzbot)

 drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/misc/onboard_usb_hub_pdevs.c b/drivers/usb/misc/onboard_usb_hub_pdevs.c
index ed22a18f4ab7..8cea53b0907e 100644
--- a/drivers/usb/misc/onboard_usb_hub_pdevs.c
+++ b/drivers/usb/misc/onboard_usb_hub_pdevs.c
@@ -101,6 +101,19 @@ void onboard_hub_create_pdevs(struct usb_device *parent_hub, struct list_head *p
 			}
 		}
 
+		/*
+		 * The primary task of the onboard_usb_hub driver is to control
+		 * the power of an USB onboard hub. Some boards have device tree
+		 * nodes for USB hubs supported by this driver, but don't
+		 * specify a "vdd-supply", which is needed by the driver. This is
+		 * not a DT error per se, it just means that the onboard hub
+		 * driver can't be used with these nodes, so don't create a
+		 * a platform device for such a node.
+		 */
+		if (!of_get_property(np, "vdd-supply", NULL) &&
+		    !of_get_property(npc, "vdd-supply", NULL))
+			goto node_put;
+
 		pdev = of_platform_device_create(np, NULL, &parent_hub->dev);
 		if (!pdev) {
 			dev_err(&parent_hub->dev,
-- 
2.39.0.314.g84b9a713c41-goog

