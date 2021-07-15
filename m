Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E01C3CA7F7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhGOS5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239976AbhGOS4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4295F613D9;
        Thu, 15 Jul 2021 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375237;
        bh=sVhJ9Ua9XktMFt+Jrg29u7/0hwbuCGE/h+8ziQOROd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nD+Yj6kO13zhtb7uRrjx5o4pDcCVv2iBm8VCowe3yArdQS/YqrnIR8etHB8A52k2U
         UmNBvF1RObmIzjUACR26oFxqtfiVdv/j91DKZOFqSd0dG783g2vqbAxqTpxkv08jrv
         PBcvK364RV2ENGLwiUXjhodK9ecvszX6Qtq7hkBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 196/215] dm writecache: flush origin device when writing and cache is full
Date:   Thu, 15 Jul 2021 20:39:28 +0200
Message-Id: <20210715182633.802741131@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
@@ -2483,7 +2487,7 @@ overflow:
 		goto bad;
 	}
 
-	ti->num_flush_bios = 1;
+	ti->num_flush_bios = WC_MODE_PMEM(wc) ? 1 : 2;
 	ti->flush_supported = true;
 	ti->num_discard_bios = 1;
 


