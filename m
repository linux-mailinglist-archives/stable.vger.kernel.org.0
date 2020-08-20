Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7519424B37E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHTJsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbgHTJr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:47:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CEF220724;
        Thu, 20 Aug 2020 09:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916875;
        bh=IBJszxCXxfOf4+9ryc+utwDebGF0s9EEcPjbo1wBxhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEG9qMcYxQVlYBcg5rQlSNjFM/2l7hDoBlJEIx4SbMhWuWisKbi3HES0kAlmxSrU0
         gGOMaPOPPAT1Rl5mqrxscJpCLFreHIqYBc4P9Tma0oIA5zCOdyBH7rSUs4wXqL9TKn
         2yv84YthJnGl2y4rXrlTLNmYKYBCh4LQT/CQyoK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: [PATCH 5.4 048/152] driver core: Avoid binding drivers to dead devices
Date:   Thu, 20 Aug 2020 11:20:15 +0200
Message-Id: <20200820091556.155251735@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 654888327e9f655a9d55ad477a9583e90e8c9b5c upstream.

Commit 3451a495ef24 ("driver core: Establish order of operations for
device_add and device_del via bitflag") sought to prevent asynchronous
driver binding to a device which is being removed.  It added a
per-device "dead" flag which is checked in the following code paths:

* asynchronous binding in __driver_attach_async_helper()
*  synchronous binding in device_driver_attach()
* asynchronous binding in __device_attach_async_helper()

It did *not* check the flag upon:

*  synchronous binding in __device_attach()

However __device_attach() may also be called asynchronously from:

deferred_probe_work_func()
  bus_probe_device()
    device_initial_probe()
      __device_attach()

So if the commit's intention was to check the "dead" flag in all
asynchronous code paths, then a check is also necessary in
__device_attach().  Add the missing check.

Fixes: 3451a495ef24 ("driver core: Establish order of operations for device_add and device_del via bitflag")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.1+
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Link: https://lore.kernel.org/r/de88a23a6fe0ef70f7cfd13c8aea9ab51b4edab6.1594214103.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -872,7 +872,9 @@ static int __device_attach(struct device
 	int ret = 0;
 
 	device_lock(dev);
-	if (dev->driver) {
+	if (dev->p->dead) {
+		goto out_unlock;
+	} else if (dev->driver) {
 		if (device_is_bound(dev)) {
 			ret = 1;
 			goto out_unlock;


