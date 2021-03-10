Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8275B333E53
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhCJNZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233269AbhCJNZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E02E4650AF;
        Wed, 10 Mar 2021 13:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382714;
        bh=90KuyW1K61YqK2yYp/VkaKmdnMmrW3b+Qz3/oA9/1FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilMTkIJRpnDqXd/8BooqR3pPJ3a7oIyCJqwY+0J7GA6n7PzRK10GjLN30qErWwXC1
         w3VdgR+3YxrjRXPgWudLnouEjjuoByW9wl/c+q0ZxqKaDhEsFhyeTogPNkUhpGPezr
         mWLl21z1rgaeIbx2YsmFyy/4uDSZT3A02vkdJShs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 08/20] dm table: fix DAX iterate_devices based device capability checks
Date:   Wed, 10 Mar 2021 14:24:45 +0100
Message-Id: <20210310132320.788435114@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.512307035@linuxfoundation.org>
References: <20210310132320.512307035@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jeffle Xu <jefflexu@linux.alibaba.com>

commit 5b0fab508992c2e120971da658ce80027acbc405 upstream.

Fix dm_table_supports_dax() and invert logic of both
iterate_devices_callout_fn so that all devices' DAX capabilities are
properly checked.

Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[jeffle: no dax synchronous]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -889,10 +889,10 @@ void dm_table_set_type(struct dm_table *
 }
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
-static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+static int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			       sector_t start, sector_t len, void *data)
 {
-	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
+	return !bdev_dax_supported(dev->bdev, PAGE_SIZE);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
@@ -908,7 +908,7 @@ static bool dm_table_supports_dax(struct
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_supports_dax, NULL))
+		    ti->type->iterate_devices(ti, device_not_dax_capable, NULL))
 			return false;
 	}
 
@@ -1690,23 +1690,6 @@ static int device_dax_write_cache_enable
 	return false;
 }
 
-static int dm_table_supports_dax_write_cache(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti,
-				device_dax_write_cache_enabled, NULL))
-			return true;
-	}
-
-	return false;
-}
-
 static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
@@ -1854,7 +1837,7 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_DAX, q);
 
-	if (dm_table_supports_dax_write_cache(t))
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled))
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */


