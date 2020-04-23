Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12731B6963
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgDWXWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:22:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48480 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728183AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bi-JS; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6im-42; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Qu Wenruo" <quwenruo@cn.fujitsu.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date:   Fri, 24 Apr 2020 00:04:45 +0100
Message-ID: <lsq.1587683028.41233826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 058/245] dm flakey: fix reads to be issued if
 drop_writes configured
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 299f6230bc6d0ccd5f95bb0fb865d80a9c7d5ccc upstream.

v4.8-rc3 commit 99f3c90d0d ("dm flakey: error READ bios during the
down_interval") overlooked the 'drop_writes' feature, which is meant to
allow reads to be issued rather than errored, during the down_interval.

Fixes: 99f3c90d0d ("dm flakey: error READ bios during the down_interval")
Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-flakey.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -291,15 +291,13 @@ static int flakey_map(struct dm_target *
 		pb->bio_submitted = true;
 
 		/*
-		 * Map reads as normal only if corrupt_bio_byte set.
+		 * Error reads if neither corrupt_bio_byte or drop_writes are set.
+		 * Otherwise, flakey_end_io() will decide if the reads should be modified.
 		 */
 		if (bio_data_dir(bio) == READ) {
-			/* If flags were specified, only corrupt those that match. */
-			if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
-			    all_corrupt_bio_flags_match(bio, fc))
-				goto map_bio;
-			else
+			if (!fc->corrupt_bio_byte && !test_bit(DROP_WRITES, &fc->flags))
 				return -EIO;
+			goto map_bio;
 		}
 
 		/*
@@ -336,14 +334,21 @@ static int flakey_end_io(struct dm_targe
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	/*
-	 * Corrupt successful READs while in down state.
-	 */
 	if (!error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
-		if (fc->corrupt_bio_byte)
+		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
+		    all_corrupt_bio_flags_match(bio, fc)) {
+			/*
+			 * Corrupt successful matching READs while in down state.
+			 */
 			corrupt_bio_data(bio, fc);
-		else
+
+		} else if (!test_bit(DROP_WRITES, &fc->flags)) {
+			/*
+			 * Error read during the down_interval if drop_writes
+			 * wasn't configured.
+			 */
 			return -EIO;
+		}
 	}
 
 	return error;

