Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865332ABBE8
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbgKINHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731400AbgKINHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C53A2076E;
        Mon,  9 Nov 2020 13:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927258;
        bh=9lm/JU0khqt138EpXMKsbb/pihlBDG9NtWckqB7q55A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSh0ABGHsy4wStEoNrgljOZ78p4TOXIiqqGfNhhEX/qIM4Hoyidl4s2WDqFPgUKKC
         clEGYRePTjPbr4dVh/L3kGvqMGEqcXHk3q4cZ/FimWCorN5EIwZMYClE6LjCSqFcgj
         HiToQIwFhmHlS880uXPyWJHeFuhikmAU/SoO+jIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 4.14 47/48] PM: runtime: Resume the device earlier in __device_release_driver()
Date:   Mon,  9 Nov 2020 13:55:56 +0100
Message-Id: <20201109125019.080861836@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 9226c504e364158a17a68ff1fe9d67d266922f50 upstream.

Since the device is resumed from runtime-suspend in
__device_release_driver() anyway, it is better to do that before
looking for busy managed device links from it to consumers, because
if there are any, device_links_unbind_consumers() will be called
and it will cause the consumer devices' drivers to unbind, so the
consumer devices will be runtime-resumed.  In turn, resuming each
consumer device will cause the supplier to be resumed and when the
runtime PM references from the given consumer to it are dropped, it
may be suspended.  Then, the runtime-resume of the next consumer
will cause the supplier to resume again and so on.

Update the code accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
Cc: All applicable <stable@vger.kernel.org> # All applicable
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -816,6 +816,8 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
+		pm_runtime_get_sync(dev);
+
 		while (device_links_busy(dev)) {
 			device_unlock(dev);
 			if (parent)
@@ -831,11 +833,12 @@ static void __device_release_driver(stru
 			 * have released the driver successfully while this one
 			 * was waiting, so check for that.
 			 */
-			if (dev->driver != drv)
+			if (dev->driver != drv) {
+				pm_runtime_put(dev);
 				return;
+			}
 		}
 
-		pm_runtime_get_sync(dev);
 		pm_runtime_clean_up_links(dev);
 
 		driver_sysfs_remove(dev);


