Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD321A6109
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 01:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgDLXBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 19:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 19:01:21 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C7FC0A88B5;
        Sun, 12 Apr 2020 16:01:20 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x2so5978073qtr.0;
        Sun, 12 Apr 2020 16:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TTh3si+Pxk39+ozOcCWA1AMtqICiWo5TtnbN1JHGzqk=;
        b=ib14dN8Lklq3veeE1o9eOI3BzOB/3eBy58DC5AHaP5bHDLLrvmGBXdpkRFPEugI0mt
         ijZGdzlf5dUWT07r5SuE8/H/hHVJ7F9oM5grEAe60nDJJQmi08s3QhgbZAsgbcvFON4c
         f7sv1+kTb95adVrJKTqfddUo/6pHig7uJJPbD8mirVx2EsdU8ynJ7csWCs5tUxGjjWbK
         5CoGQmk6HHagbTRyelfkm6zqZ9zfIxLnktXKIQ0rYxV6vN3GirzUVwY4LtfKOpGecQhQ
         g2pttCCpiV27Zs8lka3lSGwpbAXNVo6sLaGYOtrt5B6mPb0T/wuESnVqgwlRVBfypNh9
         EdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TTh3si+Pxk39+ozOcCWA1AMtqICiWo5TtnbN1JHGzqk=;
        b=Q12RElAMprynRSDTxUMjKDGCTTeKVQM54Xyr2+1vpSyheCu5joKGPtZBdENz28dejp
         9sd7grBG3ASjBaax2/YkhM7VvHYHAym/73mGGLEUIlltcQM17WPzB5xarlpOwdH0LYel
         O3S0tf+C7S6vu5OSze73z8vv5SijKxON2IsUtWW3AioFTXz4u1mjYyfYGOc35/IpJ2NP
         JoP9LJ4ZnZxkEsM+uFYZXoY2xc+NGH7IZx+SYvLT/pa5vz1Q2j/7J0mIrs5dMjzVsPzQ
         UglA2qY9GVyn/lUrogLfnOmUw5MAsNXJCUsw3G99S5RcAyaPvTULTgY7nf0fgBaX+CRe
         UVyQ==
X-Gm-Message-State: AGi0PubYA8T/YNZkAHZ+LOu/Rr4d8RoorRl0S7Mm5NXCUyJZZQrZ6L0R
        6x4/15wDJD7dWEcYBDmV2jR8vJporlE=
X-Google-Smtp-Source: APiQypIrbo5Ru/sT2g6r0alQ3CYE0gLeKCRJaJntiTQTXawNjEeRVkgw5Q++s9KEgPPozBpodcdv3A==
X-Received: by 2002:ac8:3421:: with SMTP id u30mr9151202qtb.303.1586732478741;
        Sun, 12 Apr 2020 16:01:18 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:5bb::3])
        by smtp.gmail.com with ESMTPSA id p24sm6736046qkp.60.2020.04.12.16.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:01:17 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     linux@roeck-us.net
Cc:     wim@linux-watchdog.org, linux-imx@nxp.com,
        linux-watchdog@vger.kernel.org, brenomatheus@gmail.com,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] watchdog: imx_sc_wdt: Fix reboot on crash
Date:   Sun, 12 Apr 2020 20:01:22 -0300
Message-Id: <20200412230122.5601-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently when running the samples/watchdog/watchdog-simple.c
application and forcing a kernel crash by doing:

# ./watchdog-simple &
# echo c > /proc/sysrq-trigger

The system does not reboot as expected.

Fix it by calling imx_sc_wdt_set_timeout() to configure the i.MX8QXP
watchdog with a proper timeout.

Cc: <stable@vger.kernel.org>
Fixes: 986857acbc9a ("watchdog: imx_sc: Add i.MX system controller watchdog support")
Reported-by: Breno Lima <breno.lima@nxp.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/watchdog/imx_sc_wdt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/watchdog/imx_sc_wdt.c b/drivers/watchdog/imx_sc_wdt.c
index 60a32469f7de..e9ee22a7cb45 100644
--- a/drivers/watchdog/imx_sc_wdt.c
+++ b/drivers/watchdog/imx_sc_wdt.c
@@ -175,6 +175,11 @@ static int imx_sc_wdt_probe(struct platform_device *pdev)
 	wdog->timeout = DEFAULT_TIMEOUT;
 
 	watchdog_init_timeout(wdog, 0, dev);
+
+	ret = imx_sc_wdt_set_timeout(wdog, wdog->timeout);
+	if (ret)
+		return ret;
+
 	watchdog_stop_on_reboot(wdog);
 	watchdog_stop_on_unregister(wdog);
 
-- 
2.17.1

