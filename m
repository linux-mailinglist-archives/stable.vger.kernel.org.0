Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E5106EEC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbfKVLMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730485AbfKVK5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F96B2071F;
        Fri, 22 Nov 2019 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420274;
        bh=KB354o3/r9P+JtBFvnw5fnhLSpxOdIW6UqA4GyhnQBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4+daHzcgtnSuY+zY3dvLsWwEezPEcjJqgCqlijtsMO3astqfNbFDoogeoJaxDcIM
         1gb8q6ltmAyRmoBtlfG6gF+3xZTZK5q9iMuQoEpgJIntM6+ZOs6Z3nzQWIOdIBLQHg
         F66390mT42pio8V1M9kgXEpQA+hoCtVgMXvxj3eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/220] watchdog: renesas_wdt: stop when unregistering
Date:   Fri, 22 Nov 2019 11:26:56 +0100
Message-Id: <20191122100915.866371312@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 14de99b44b34dbb9d0f64845b1cbb675e047767e ]

We want to go into a sane state when unregistering. Currently, it
happens that the watchdog stops when unbinding because of RuntimePM
stopping the core clock. When rebinding, the core clock gets reactivated
and the watchdog fires even though it hasn't been opened by userspace
yet. Strange scenario, yes, but sane state is much preferred anyhow.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/renesas_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/renesas_wdt.c b/drivers/watchdog/renesas_wdt.c
index d01efd342dc0c..62d9d3edcdf25 100644
--- a/drivers/watchdog/renesas_wdt.c
+++ b/drivers/watchdog/renesas_wdt.c
@@ -239,6 +239,7 @@ static int rwdt_probe(struct platform_device *pdev)
 	watchdog_set_drvdata(&priv->wdev, priv);
 	watchdog_set_nowayout(&priv->wdev, nowayout);
 	watchdog_set_restart_priority(&priv->wdev, 0);
+	watchdog_stop_on_unregister(&priv->wdev);
 
 	/* This overrides the default timeout only if DT configuration was found */
 	ret = watchdog_init_timeout(&priv->wdev, 0, &pdev->dev);
-- 
2.20.1



