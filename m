Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0515714E283
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbgA3Smy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgA3Smx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:42:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60BB920702;
        Thu, 30 Jan 2020 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409771;
        bh=prWKBOSnA91RLf3LQDCLLz2iB8AjvxPjxv1Icpu7c/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhOQUTowXtZ2mA/OCqaL8vEul3wypbEfpc28mMdZMWQPoEdhQ97jmq3NXsfUwEQDW
         Lnh9VG1oa1GUdKZRSUfzwPoY+1Et1O+4Taq6HzB6AN/o4nKObdcevWsevmOeYC8uHT
         EBjU+5DwF2TwQfIZbHVOutlDnttj7ZsW4a3FEv/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 026/110] driver core: Fix test_async_driver_probe if NUMA is disabled
Date:   Thu, 30 Jan 2020 19:38:02 +0100
Message-Id: <20200130183618.230187937@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 264d25275a46fce5da501874fa48a2ae5ec571c8 upstream.

Since commit 57ea974fb871 ("driver core: Rewrite test_async_driver_probe
to cover serialization and NUMA affinity"), running the test with NUMA
disabled results in warning messages similar to the following.

test_async_driver test_async_driver.12: NUMA node mismatch -1 != 0

If CONFIG_NUMA=n, dev_to_node(dev) returns -1, and numa_node_id()
returns 0. Both are widely used, so it appears risky to change return
values. Augment the check with IS_ENABLED(CONFIG_NUMA) instead
to fix the problem.

Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Fixes: 57ea974fb871 ("driver core: Rewrite test_async_driver_probe to cover serialization and NUMA affinity")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Link: https://lore.kernel.org/r/20191127202453.28087-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/test/test_async_driver_probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -44,7 +44,8 @@ static int test_probe(struct platform_de
 	 * performing an async init on that node.
 	 */
 	if (dev->driver->probe_type == PROBE_PREFER_ASYNCHRONOUS) {
-		if (dev_to_node(dev) != numa_node_id()) {
+		if (IS_ENABLED(CONFIG_NUMA) &&
+		    dev_to_node(dev) != numa_node_id()) {
 			dev_warn(dev, "NUMA node mismatch %d != %d\n",
 				 dev_to_node(dev), numa_node_id());
 			atomic_inc(&warnings);


