Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B502ABA0E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgKINPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732868AbgKINPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D00F62083B;
        Mon,  9 Nov 2020 13:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927714;
        bh=W5IgeIx3Jf/YRZvTtGpprJ0NmG+awwEypcUFt7nTa8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eww1/HDxzjSpiuOZ1aTGKc4SMcRMl2YHATS4hDUIKztK4+ucH2j7XewKIJsPBD4sT
         wNm6ber9qHZ0HF1GDcxoqHy8Og5+4qj/0bPj2e5Zlq5rW64s37VglR+NFrlV5fqJRO
         dNuIDTOIXoyLgG0XPxyOzhWgBlx0zcdwNxFEltQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 5.4 82/85] PM: runtime: Resume the device earlier in __device_release_driver()
Date:   Mon,  9 Nov 2020 13:56:19 +0100
Message-Id: <20201109125026.519215147@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
 drivers/base/dd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1105,6 +1105,8 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
+		pm_runtime_get_sync(dev);
+
 		while (device_links_busy(dev)) {
 			__device_driver_unlock(dev, parent);
 
@@ -1116,12 +1118,12 @@ static void __device_release_driver(stru
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
-
 		driver_sysfs_remove(dev);
 
 		if (dev->bus)


