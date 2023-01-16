Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D066C6DB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbjAPQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjAPQZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:25:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDDB2B2AA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:14:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C839DB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDDFC433F0;
        Mon, 16 Jan 2023 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885640;
        bh=gjjed9r8e7W6DB9U2pJosuYea/5yQuY5MqTPMijgpDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP6HS2/jlr2MtW5KY7G2hr9z9s1B775gzANKBrjhaZ/4cusBoUZtZZEjhn1mwx5kf
         HQKVsDF0hBie2+A3bgdbei3W/AN2jKQHAt7VkY1X5L/nIA0mgXWgyJnUBRbQZ/CCy5
         PGx9RI6nYgWhx07jZafX1KYWw6zgspqHHI0qYwb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/658] PM: runtime: Do not call __rpm_callback() from rpm_idle()
Date:   Mon, 16 Jan 2023 16:42:57 +0100
Message-Id: <20230116154913.641851336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit bc80c2e438dcbfcf748452ec0f7ad5b79ff3ad88 ]

Calling __rpm_callback() from rpm_idle() after adding device links
support to the former is a clear mistake.

Not only it causes rpm_idle() to carry out unnecessary actions, but it
is also against the assumption regarding the stability of PM-runtime
status across __rpm_callback() invocations, because rpm_suspend() and
rpm_resume() may run in parallel with __rpm_callback() when it is called
by rpm_idle() and the device's PM-runtime status can be updated by any
of them.

Fixes: 21d5c57b3726 ("PM / runtime: Use device links")
Link: https://lore.kernel.org/linux-pm/36aed941-a73e-d937-2721-4f0decd61ce0@quicinc.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 24a3013728c3..9ee58bf49d13 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -465,7 +465,17 @@ static int rpm_idle(struct device *dev, int rpmflags)
 
 	dev->power.idle_notification = true;
 
-	retval = __rpm_callback(callback, dev);
+	if (dev->power.irq_safe)
+		spin_unlock(&dev->power.lock);
+	else
+		spin_unlock_irq(&dev->power.lock);
+
+	retval = callback(dev);
+
+	if (dev->power.irq_safe)
+		spin_lock(&dev->power.lock);
+	else
+		spin_lock_irq(&dev->power.lock);
 
 	dev->power.idle_notification = false;
 	wake_up_all(&dev->power.wait_queue);
-- 
2.35.1



