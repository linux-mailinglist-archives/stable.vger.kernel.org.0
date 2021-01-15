Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDC42F79E6
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388286AbhAOMjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388284AbhAOMjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE387221FA;
        Fri, 15 Jan 2021 12:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714319;
        bh=pJzcQLGJgnYbYeTux5BdLA0lnaJaEg5KGBBjaOjmW+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV2uflHHIc+5hrLZsbuNVmR5u4LBAr3OkykuAZ2YYHRXfRS/9tLOa+mx/n70ZXNAC
         XaOw514spGMa0msh/KJtoLweMJ6Us+UV6i3gMDfLpC27nO15plfBU+ZH1UusDwTviL
         9vENnpdjucpwlNzicP0lH/iPcnIrMRf+U0iPZyOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 065/103] bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET
Date:   Fri, 15 Jan 2021 13:27:58 +0100
Message-Id: <20210115122009.189313820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 5342fd4255021ef0c4ce7be52eea1c4ebda11c63 upstream.

If BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET is set in incompat feature
set, it means the cache device is created with obsoleted layout with
obso_bucket_site_hi. Now bcache does not support this feature bit, a new
BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE incompat feature bit is added
for a better layout to support large bucket size.

For the legacy compatibility purpose, if a cache device created with
obsoleted BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET feature bit, all bcache
devices attached to this cache set should be set to read-only. Then the
dirty data can be written back to backing device before re-create the
cache device with BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE feature bit
by the latest bcache-tools.

This patch checks BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET feature bit
when running a cache set and attach a bcache device to the cache set. If
this bit is set,
- When run a cache set, print an error kernel message to indicate all
  following attached bcache device will be read-only.
- When attach a bcache device, print an error kernel message to indicate
  the attached bcache device will be read-only, and ask users to update
  to latest bcache-tools.

Such change is only for cache device whose bucket size >= 32MB, this is
for the zoned SSD and almost nobody uses such large bucket size at this
moment. If you don't explicit set a large bucket size for a zoned SSD,
such change is totally transparent to your bcache device.

Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/super.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1341,6 +1341,12 @@ int bch_cached_dev_attach(struct cached_
 	bcache_device_link(&dc->disk, c, "bdev");
 	atomic_inc(&c->attached_dev_nr);
 
+	if (bch_has_feature_obso_large_bucket(&(c->cache->sb))) {
+		pr_err("The obsoleted large bucket layout is unsupported, set the bcache device into read-only\n");
+		pr_err("Please update to the latest bcache-tools to create the cache device\n");
+		set_disk_ro(dc->disk.disk, 1);
+	}
+
 	/* Allow the writeback thread to proceed */
 	up_write(&dc->writeback_lock);
 
@@ -1564,6 +1570,12 @@ static int flash_dev_run(struct cache_se
 
 	bcache_device_link(d, c, "volume");
 
+	if (bch_has_feature_obso_large_bucket(&c->cache->sb)) {
+		pr_err("The obsoleted large bucket layout is unsupported, set the bcache device into read-only\n");
+		pr_err("Please update to the latest bcache-tools to create the cache device\n");
+		set_disk_ro(d->disk, 1);
+	}
+
 	return 0;
 err:
 	kobject_put(&d->kobj);
@@ -2123,6 +2135,9 @@ static int run_cache_set(struct cache_se
 	c->cache->sb.last_mount = (u32)ktime_get_real_seconds();
 	bcache_write_super(c);
 
+	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
+		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
+
 	list_for_each_entry_safe(dc, t, &uncached_devices, list)
 		bch_cached_dev_attach(dc, c, NULL);
 


