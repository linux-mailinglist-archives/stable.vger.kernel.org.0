Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69639E19B
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfH0INW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbfH0H6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD0620828;
        Tue, 27 Aug 2019 07:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892698;
        bh=BQoWxrPXHX8BCycKMjfBLqvZlT824d107z5VBJa1TOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIHvnjdmhkteBTEKAKyCIqEoX0SJbmHx0Z+GbjsmUjUQsOI8pI0dRmRyfz6zzUsNx
         GZhqCDKEEnTtC8H2NaY4/YcAPrEhzjDAxwCjhb4qd2FqZQ52IYWctBeKU4ULV7qTp1
         RKQJv3FxQ6pfxx/TBT/NdZQ/ZEBe9gdPcf9He4V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 81/98] dm zoned: improve error handling in reclaim
Date:   Tue, 27 Aug 2019 09:51:00 +0200
Message-Id: <20190827072722.318146854@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

commit b234c6d7a703661b5045c5bf569b7c99d2edbf88 upstream.

There are several places in reclaim code where errors are not
propagated to the main function, dmz_reclaim(). This function
is responsible for unlocking zones that might be still locked
at the end of any failed reclaim iterations. As the result,
some device zones may be left permanently locked for reclaim,
degrading target's capability to reclaim zones.

This patch fixes these issues as follows -

Make sure that dmz_reclaim_buf(), dmz_reclaim_seq_data() and
dmz_reclaim_rnd_data() return error codes to the caller.

dmz_reclaim() function is renamed to dmz_do_reclaim() to avoid
clashing with "struct dmz_reclaim" and is modified to return the
error to the caller.

dmz_get_zone_for_reclaim() now returns an error instead of NULL
pointer and reclaim code checks for that error.

Error logging/debug messages are added where necessary.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-metadata.c |    4 ++--
 drivers/md/dm-zoned-reclaim.c  |   28 +++++++++++++++++++---------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1534,7 +1534,7 @@ static struct dm_zone *dmz_get_rnd_zone_
 	struct dm_zone *zone;
 
 	if (list_empty(&zmd->map_rnd_list))
-		return NULL;
+		return ERR_PTR(-EBUSY);
 
 	list_for_each_entry(zone, &zmd->map_rnd_list, link) {
 		if (dmz_is_buf(zone))
@@ -1545,7 +1545,7 @@ static struct dm_zone *dmz_get_rnd_zone_
 			return dzone;
 	}
 
-	return NULL;
+	return ERR_PTR(-EBUSY);
 }
 
 /*
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -215,7 +215,7 @@ static int dmz_reclaim_buf(struct dmz_re
 
 	dmz_unlock_flush(zmd);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -259,7 +259,7 @@ static int dmz_reclaim_seq_data(struct d
 
 	dmz_unlock_flush(zmd);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -312,7 +312,7 @@ static int dmz_reclaim_rnd_data(struct d
 
 	dmz_unlock_flush(zmd);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -334,7 +334,7 @@ static void dmz_reclaim_empty(struct dmz
 /*
  * Find a candidate zone for reclaim and process it.
  */
-static void dmz_reclaim(struct dmz_reclaim *zrc)
+static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 {
 	struct dmz_metadata *zmd = zrc->metadata;
 	struct dm_zone *dzone;
@@ -344,8 +344,8 @@ static void dmz_reclaim(struct dmz_recla
 
 	/* Get a data zone */
 	dzone = dmz_get_zone_for_reclaim(zmd);
-	if (!dzone)
-		return;
+	if (IS_ERR(dzone))
+		return PTR_ERR(dzone);
 
 	start = jiffies;
 
@@ -391,13 +391,20 @@ static void dmz_reclaim(struct dmz_recla
 out:
 	if (ret) {
 		dmz_unlock_zone_reclaim(dzone);
-		return;
+		return ret;
 	}
 
-	(void) dmz_flush_metadata(zrc->metadata);
+	ret = dmz_flush_metadata(zrc->metadata);
+	if (ret) {
+		dmz_dev_debug(zrc->dev,
+			      "Metadata flush for zone %u failed, err %d\n",
+			      dmz_id(zmd, rzone), ret);
+		return ret;
+	}
 
 	dmz_dev_debug(zrc->dev, "Reclaimed zone %u in %u ms",
 		      dmz_id(zmd, rzone), jiffies_to_msecs(jiffies - start));
+	return 0;
 }
 
 /*
@@ -442,6 +449,7 @@ static void dmz_reclaim_work(struct work
 	struct dmz_metadata *zmd = zrc->metadata;
 	unsigned int nr_rnd, nr_unmap_rnd;
 	unsigned int p_unmap_rnd;
+	int ret;
 
 	if (!dmz_should_reclaim(zrc)) {
 		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
@@ -471,7 +479,9 @@ static void dmz_reclaim_work(struct work
 		      (dmz_target_idle(zrc) ? "Idle" : "Busy"),
 		      p_unmap_rnd, nr_unmap_rnd, nr_rnd);
 
-	dmz_reclaim(zrc);
+	ret = dmz_do_reclaim(zrc);
+	if (ret)
+		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
 
 	dmz_schedule_reclaim(zrc);
 }


