Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD4D10BD4E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbfK0U7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731366AbfK0U7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43D3920678;
        Wed, 27 Nov 2019 20:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888339;
        bh=jTWzCOQwRiWhKbKWMLAjSFDku8KDuyLw1gEEl2r4qbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXgYn0HV0AuF01LCnKY92lAQ45eKFi3TwmbGQiq0Fh2K2w4bQosI59YLrmaIKWHoT
         r2o+ybXv9nzVPkhJZrs7KchASlDH9Xwvl/7dfkolAh6OvOJqp3+oFguZaz4oANBYOT
         M9poZMtxOw1wPH4BTya4ttfZ8+SOCgQ6hMLBadQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/306] macintosh/windfarm_smu_sat: Fix debug output
Date:   Wed, 27 Nov 2019 21:29:04 +0100
Message-Id: <20191127203121.773846653@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit fc0c8b36d379a046525eacb9c3323ca635283757 ]

There's some antiquated debug output that's trying
to do a hand-made hexdump and turning into horrible
1-byte-per-line output these days.

Use print_hex_dump() instead

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/windfarm_smu_sat.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index da7f4fc1a51d1..a0f61eb853c55 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -22,14 +22,6 @@
 
 #define VERSION "1.0"
 
-#define DEBUG
-
-#ifdef DEBUG
-#define DBG(args...)	printk(args)
-#else
-#define DBG(args...)	do { } while(0)
-#endif
-
 /* If the cache is older than 800ms we'll refetch it */
 #define MAX_AGE		msecs_to_jiffies(800)
 
@@ -106,13 +98,10 @@ struct smu_sdbp_header *smu_sat_get_sdb_partition(unsigned int sat_id, int id,
 		buf[i+2] = data[3];
 		buf[i+3] = data[2];
 	}
-#ifdef DEBUG
-	DBG(KERN_DEBUG "sat %d partition %x:", sat_id, id);
-	for (i = 0; i < len; ++i)
-		DBG(" %x", buf[i]);
-	DBG("\n");
-#endif
 
+	printk(KERN_DEBUG "sat %d partition %x:", sat_id, id);
+	print_hex_dump(KERN_DEBUG, "  ", DUMP_PREFIX_OFFSET,
+		       16, 1, buf, len, false);
 	if (size)
 		*size = len;
 	return (struct smu_sdbp_header *) buf;
@@ -132,13 +121,13 @@ static int wf_sat_read_cache(struct wf_sat *sat)
 	if (err < 0)
 		return err;
 	sat->last_read = jiffies;
+
 #ifdef LOTSA_DEBUG
 	{
 		int i;
-		DBG(KERN_DEBUG "wf_sat_get: data is");
-		for (i = 0; i < 16; ++i)
-			DBG(" %.2x", sat->cache[i]);
-		DBG("\n");
+		printk(KERN_DEBUG "wf_sat_get: data is");
+		print_hex_dump(KERN_DEBUG, "  ", DUMP_PREFIX_OFFSET,
+			       16, 1, sat->cache, 16, false);
 	}
 #endif
 	return 0;
-- 
2.20.1



