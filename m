Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745D66743D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbjALOEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbjALODu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:03:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B91E52749
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:03:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2803162026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F56C433EF;
        Thu, 12 Jan 2023 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532228;
        bh=g78DcDhKUyC1cxNsp9sbe/nDNJz9HwIJx5gmwF0nKr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGOsv815VeBkm0GoVR7YGNdgej/vLb2bQs4n9k0xPsMVbJOUo3maaBBVBUn8QWa3q
         SCwSTiAuDS77b3l3ESdup5sRZ2luxFML06XbBS/r4iFWHM64K5A6/qPfwq5gNfVOgD
         kCErSKJAdh6+KxmyLnnkKJnr4v6Av6hIGzWnS3sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/783] PM: runtime: Do not call __rpm_callback() from rpm_idle()
Date:   Thu, 12 Jan 2023 14:46:48 +0100
Message-Id: <20230112135528.445399992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 532d910fe1cf..360094692d29 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -483,7 +483,17 @@ static int rpm_idle(struct device *dev, int rpmflags)
 
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



