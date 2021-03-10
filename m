Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1541333E70
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhCJN0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233381AbhCJNZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BF26501A;
        Wed, 10 Mar 2021 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382727;
        bh=WWPU+F5imDjC+GV73x5lDGmRwV97hDoUeYXijxdR4sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRJoMH+p/wUpdsOBqV5qN5Ud5KVyhgYqHi8WwbdmmMMk/lH0OAVDNDfuu/RJjjQTu
         AihbAfK3acLvAKJsTvz7q9IepgvMA/7tNx4EnTeijJ48QEVVN6aKj6k5f2G9rkCWNE
         uNyyEl26Oq3fBcy5tkzdLOeXtgDPHphF535LVlBM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 07/11] dm table: fix DAX iterate_devices based device capability checks
Date:   Wed, 10 Mar 2021 14:25:06 +0100
Message-Id: <20210310132320.632132455@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
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
[jeffle: no dax write cache, no dax synchronous]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -848,12 +848,12 @@ void dm_table_set_type(struct dm_table *
 }
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
-static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
-			       sector_t start, sector_t len, void *data)
+static int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && blk_queue_dax(q);
+	return q && !blk_queue_dax(q);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
@@ -869,7 +869,7 @@ static bool dm_table_supports_dax(struct
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_supports_dax, NULL))
+		    ti->type->iterate_devices(ti, device_not_dax_capable, NULL))
 			return false;
 	}
 


