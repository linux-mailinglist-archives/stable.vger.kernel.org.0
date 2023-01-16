Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342E766CA0E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbjAPQ7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbjAPQ63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:58:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8B82CFF6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:41:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4E961042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4226FC433EF;
        Mon, 16 Jan 2023 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887279;
        bh=CqvN2XiVUKBe4FXQZWQvRqa25ELvyDHPjKfj7hTxNmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/FcI3MmbqCg2PGNcgGW4yCx+k6Teuyn3CzMKUCO76BJjfMNKNKxqx26YeLmo+gw1
         IJ2Q+whP8u5jVBYtZcoO2OSJFcjVW0Zu8UtqtBUddyuwmO8+3jZEJ7wODsSJ4zbpzw
         9+tmT3FmEJzDWO3dM5jwETwXFvkEkO1A8l4JM9pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/521] PM: runtime: Do not call __rpm_callback() from rpm_idle()
Date:   Mon, 16 Jan 2023 16:45:33 +0100
Message-Id: <20230116154850.394460384@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 8a018e6d7976..911bb8a4bf6d 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -422,7 +422,17 @@ static int rpm_idle(struct device *dev, int rpmflags)
 
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



