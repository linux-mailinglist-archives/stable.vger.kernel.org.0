Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7698F4D56E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 19:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfFTRug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:50:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40825 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfFTRug (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 13:50:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so3917170wre.7;
        Thu, 20 Jun 2019 10:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4eo8XIVIYev23OnO80+wbqMoVimiFq3yayx0KvqUr5w=;
        b=j5zicp6+maY+GOPyFK/PvDoc1wrPyoWiFtqphAKZgLb1cXQq2Gc+OXg9ff3UfCvDlS
         L6snkim8YEzbPNCQtVSwkJ/iYPbJNseNGK+y8f5pfln/rg2nw1Kdo6H80p04s8xhK6gP
         kIiH1bTMqiRYbEl3QTvpazK5Mc2TuH6g/TiYvCTRChoIy9FWXYuxSeBPiJpinbhEJf8k
         /vGI9Zhgoxgbv4wc8KG6mw1X2E3rgt2f3/sG9vrOdQpYxqxYfslajPjMzbU2VF4zllUJ
         CPgBFj28ReelvV8Xma0yXuuM9GD42qHmSclXf1KnPWII+EI8Z2v9e6ZCdKJOTQ3390m7
         Uusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4eo8XIVIYev23OnO80+wbqMoVimiFq3yayx0KvqUr5w=;
        b=ro51OE7RO1JuOSUjtxQTh9wcKhWhEbyF0sRKk3NSaWvtPkTyr2dwaO5SMrWnXNFNfj
         GFEGnnzUO8NitExUhnpR7b/K9pt/0Lsdjukj1cngcrtdNiqJXG/ir52WV8x6YUT2/j5r
         aq6LjFP9glthQNPxakwFctNxvuhGpl94oA9BcHME6Q1w4JZybSKufuuZdNenmZUNl5ZC
         xVdirsynmTKPJiFAFK1BnnBaV52GjgnY6NARFt6IA9nxhw9knpxFeFS9n3aV601UFzeZ
         6alVKNu8e55M/1A7x+e3r31f+o4iJIwXINYWpKh7zTh+JzXbyvAvvGfhQEcv9AJJVBYK
         TGRw==
X-Gm-Message-State: APjAAAXYgLADqxpy+5teadIE00BJgDb/22K0snN1R70BQswOoS6QdX4G
        QlA5euwVWIEiKD9RztPdaiM=
X-Google-Smtp-Source: APXvYqy3FJVNfRc3t3aR+Tq1J8OvbfdS3/X94VpeWR5oYw0CxV/mmojM9wqtuoxFsq5qi4xaY049Nw==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr37480642wrt.233.1561053033510;
        Thu, 20 Jun 2019 10:50:33 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:33c2:e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l1sm568745wrf.46.2019.06.20.10.50.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 10:50:32 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hminas@synopsys.com, linux-usb@vger.kernel.org,
        felipe.balbi@linux.intel.com
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH] usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()
Date:   Thu, 20 Jun 2019 19:50:22 +0200
Message-Id: <20190620175022.29348-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
consistent with the other "wait for AHB master IDLE state" ocurrences.

This fixes a problem for me where dwc2 would not want to initialize when
updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
4.14.
Testing on my board shows that it takes 180us until AHB master IDLE
state is signalled. The very old vendor driver for this SoC (ifxhcd)
used a 1 second timeout.
Use the same timeout that is used everywhere when polling for
GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
(180us in my case) to have consistent behavior across the dwc2 driver.

Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/usb/dwc2/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index 8b499d643461..8e41d70fd298 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -531,7 +531,7 @@ int dwc2_core_reset(struct dwc2_hsotg *hsotg, bool skip_wait)
 	}
 
 	/* Wait for AHB master IDLE state */
-	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 50)) {
+	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 10000)) {
 		dev_warn(hsotg->dev, "%s: HANG! AHB Idle timeout GRSTCTL GRSTCTL_AHBIDLE\n",
 			 __func__);
 		return -EBUSY;
-- 
2.22.0

