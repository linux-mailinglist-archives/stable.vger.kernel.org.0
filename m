Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E50B653A9A
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 03:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiLVC0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 21:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiLVC0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 21:26:50 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351EDFD2B
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 18:26:50 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id 3so347113iou.12
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 18:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVWA7/D2KvjMyMicmKIzWkp9wEe3Q6Twufyriuc4mnk=;
        b=F+cvtx7SUTBiDbyXWwC1K3FSy9wvZ3+6N3Ol2twXHs8J8w4KDcC3F1O1+gSzcMeK3X
         Aj4VfFDE8EzvrmHmiq0I9CxoJZAMmE+mYUaWWJzu6CNM+4jWd/SyDIjcr/BmG40Sdr3s
         e+ao1Efe1LBSnUNdNyzTedN629/nEG+bd9ZuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fVWA7/D2KvjMyMicmKIzWkp9wEe3Q6Twufyriuc4mnk=;
        b=arRa+gnIorjuvzV+441nqX4aYMteKPh9QV3bdU/wMe0VtBi697YeYI0GwUKoNOCl+V
         LxpPYbDc7qp4P+kv5t2kLcm+eptC+71t0slfT0NBI6SYQl9n3s4bql4AnHkA7UNyo8Lb
         H0AvEXnx74NPtdQKgHAklX9aoyeggzeYD5q2qx+vrJCZCPynOBLS7Qk4qZXjw22ysyxX
         cNKy48nQCRYD1J2xvm50NBjpLX6A8ws4ZVYGDK48WUnDU0QpWBPgCVynyb4nzB4ftGWa
         OvD/pliZfQUg5fm26WN1WBQlMlX+HW4QhXTqhVV91dPLxLLPsXsycHeyhgIaMSecfwMR
         IzLg==
X-Gm-Message-State: AFqh2kpPrkNbS2qXyG0DzTMtH1h1ipjd0brjb89EMbQvaj7pWLQTYBs8
        dCUt3qKIx0FhMWM+Wo60+UpP9Q==
X-Google-Smtp-Source: AMrXdXta0auQ6KBKrMkNKxV0MubHW/Vl+yjQV7HxmnSm0MYbIwEb5899dmogvKr3NTgh01lj6IJOZw==
X-Received: by 2002:a6b:dc02:0:b0:6e2:d3fa:76eb with SMTP id s2-20020a6bdc02000000b006e2d3fa76ebmr2618945ioc.20.1671676009612;
        Wed, 21 Dec 2022 18:26:49 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id x43-20020a0294ae000000b00375783003fcsm5994321jah.136.2022.12.21.18.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 18:26:49 -0800 (PST)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: [PATCH v2 2/2] usb: misc: onboard_hub: Fail silently when there is no platform device
Date:   Thu, 22 Dec 2022 02:26:45 +0000
Message-Id: <20221222022605.v2.2.I0c5ce35d591fa1f405f213c444522585be5601f0@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some boards with an onboard USB hub supported by the onboard_hub
driver have a device tree node for the hub, but the node doesn't
specify all properties needed by the driver (which is not a DT
error per se). For such a hub no onboard_hub platform device is
created. However the USB portion of the onboard hub driver still
probes and uses _find_onboard_hub() to find the platform device
that corresponds to the hub. If the DT node of the hub doesn't
have an associated platform device the function looks for a
"peer-hub" node (to get the platform device from there), if
that doesn't exist either it logs an error and returns -EINVAL.

The absence of a platform device is expected in some
configurations, so drop the error log and fail silently with
-ENODEV.

Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v2:
- patch added to the series

 drivers/usb/misc/onboard_usb_hub.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/onboard_usb_hub.c b/drivers/usb/misc/onboard_usb_hub.c
index d63c63942af1..44a0b0ddee55 100644
--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -348,10 +348,8 @@ static struct onboard_hub *_find_onboard_hub(struct device *dev)
 	pdev = of_find_device_by_node(dev->of_node);
 	if (!pdev) {
 		np = of_parse_phandle(dev->of_node, "peer-hub", 0);
-		if (!np) {
-			dev_err(dev, "failed to find device node for peer hub\n");
-			return ERR_PTR(-EINVAL);
-		}
+		if (!np)
+			return ERR_PTR(-ENODEV);
 
 		pdev = of_find_device_by_node(np);
 		of_node_put(np);
-- 
2.39.0.314.g84b9a713c41-goog

