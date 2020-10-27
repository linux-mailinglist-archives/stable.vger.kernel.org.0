Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D0D29B42D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753133AbgJ0O7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784264AbgJ0O67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936BA21527;
        Tue, 27 Oct 2020 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810739;
        bh=ggJJzO3IDdFTXMqxX+gFAyxPP4vjAuX6myg/yhlt5rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzloLawq78BNHJKBISx523Q5hPCI7HMmR6EjJV1lG2vOpiXwO46KqC7B8wjeUqq92
         OZMkiONT+8KDz/hATSXWIZfghETQ3r+4J5UyWmFKGYpJ0CK1IqS1uEUE6bsuAH+ofL
         QSC2eFpKAdwDAI042O4lAO3NWsBXpTX2LYLfQnv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 215/633] pinctrl: devicetree: Keep deferring even on timeout
Date:   Tue, 27 Oct 2020 14:49:18 +0100
Message-Id: <20201027135532.768064508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 84f28fc38d2ff99e2ac623325ba37809da611b8e ]

driver_deferred_probe_check_state() may return -ETIMEDOUT instead of
-EPROBE_DEFER after all built-in drivers have been probed. This can
cause issues for built-in drivers that depend on resources provided by
loadable modules.

One such case happens on Tegra where I2C controllers are used during
early boot to set up the system PMIC, so the I2C driver needs to be a
built-in driver. At the same time, some instances of the I2C controller
depend on the DPAUX hardware for pinmuxing. Since the DPAUX is handled
by the display driver, which is usually not built-in, the pin control
states will not become available until after the root filesystem has
been mounted and the display driver loaded from it.

Fixes: bec6c0ecb243 ("pinctrl: Remove use of driver_deferred_probe_check_state_continue()")
Suggested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20200825143348.1358679-1-thierry.reding@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/devicetree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index c6fe7d64c9137..c7448be64d073 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -129,9 +129,8 @@ static int dt_to_map_one_config(struct pinctrl *p,
 		if (!np_pctldev || of_node_is_root(np_pctldev)) {
 			of_node_put(np_pctldev);
 			ret = driver_deferred_probe_check_state(p->dev);
-			/* keep deferring if modules are enabled unless we've timed out */
-			if (IS_ENABLED(CONFIG_MODULES) && !allow_default &&
-			    (ret == -ENODEV))
+			/* keep deferring if modules are enabled */
+			if (IS_ENABLED(CONFIG_MODULES) && !allow_default && ret < 0)
 				ret = -EPROBE_DEFER;
 			return ret;
 		}
-- 
2.25.1



