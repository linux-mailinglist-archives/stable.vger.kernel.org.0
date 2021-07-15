Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4103CA976
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbhGOTGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241646AbhGOTFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A709613E7;
        Thu, 15 Jul 2021 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375738;
        bh=TywS3+8OR6jJVRM/MIr9EVIcjLg13f71Y5+XN6BhK9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTRu+E4CJDtNj67AainxPP2FRiUKB78H6zwQVkHMdQoLIKUYa4Cj+WGkIjvAZjwJj
         SAFP3oTGnbuPA43E6vNpZxqM8Xt4YBxE+YCowmJSkBL56cTd5ZsSmVjhGoS4CwUAWs
         nI7YT8dn9feHZQaCNkk0RicZKAkskhzQV52zPNnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.12 216/242] dm writecache: flush origin device when writing and cache is full
Date:   Thu, 15 Jul 2021 20:39:38 +0200
Message-Id: <20210715182631.135048546@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit ee55b92a7391bf871939330f662651b54be51b73 upstream.

Commit d53f1fafec9d086f1c5166436abefdaef30e0363 ("dm writecache: do
direct write if the cache is full") changed dm-writecache, so that it
writes directly to the origin device if the cache is full.
Unfortunately, it doesn't forward flush requests to the origin device,
so that there is a bug where flushes are being ignored.

Fix this by adding missing flush forwarding.

For PMEM mode, we fix this bug by disabling direct writes to the origin
device, because it performs better.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: d53f1fafec9d ("dm writecache: do direct write if the cache is full")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1297,8 +1297,12 @@ static int writecache_map(struct dm_targ
 			writecache_flush(wc);
 			if (writecache_has_error(wc))
 				goto unlock_error;
+			if (unlikely(wc->cleaner))
+				goto unlock_remap_origin;
 			goto unlock_submit;
 		} else {
+			if (dm_bio_get_target_bio_nr(bio))
+				goto unlock_remap_origin;
 			writecache_offload_bio(wc, bio);
 			goto unlock_return;
 		}
@@ -1377,7 +1381,7 @@ read_next_block:
 			}
 			e = writecache_pop_from_freelist(wc, (sector_t)-1);
 			if (unlikely(!e)) {
-				if (!found_entry) {
+				if (!WC_MODE_PMEM(wc) && !found_entry) {
 direct_write:
 					e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
 					if (e) {
@@ -2481,7 +2485,7 @@ overflow:
 		goto bad;
 	}
 
-	ti->num_flush_bios = 1;
+	ti->num_flush_bios = WC_MODE_PMEM(wc) ? 1 : 2;
 	ti->flush_supported = true;
 	ti->num_discard_bios = 1;
 


