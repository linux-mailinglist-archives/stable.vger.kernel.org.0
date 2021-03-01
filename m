Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72F329221
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhCAUje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243438AbhCAUc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:32:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6E96509F;
        Mon,  1 Mar 2021 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622159;
        bh=3qneO/z9THsDdEXwgnlEi5B1dAn4pxPOp7KHZyxBoUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBluTriAJpIg4rTdGjpJraiNqFb04DYU6ZFw9NLv/zCkDrkr9B2E5ILNO9AsfpLyO
         M3AeANfyt0Xh4R7mvWuA01iP+P6ag4fbGdvoyr7Aa0tAfOdSKK99yGX0CZSF/B+0mL
         yK21CBCx7WETA42CsIa7H9/Hmm+kwIBOwLWD8K6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 762/775] dm era: Verify the data block size hasnt changed
Date:   Mon,  1 Mar 2021 17:15:30 +0100
Message-Id: <20210301161238.971009874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit c8e846ff93d5eaa5384f6f325a1687ac5921aade upstream.

dm-era doesn't support changing the data block size of existing devices,
so check explicitly that the requested block size for a new target
matches the one stored in the metadata.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -564,6 +564,15 @@ static int open_metadata(struct era_meta
 	}
 
 	disk = dm_block_data(sblock);
+
+	/* Verify the data block size hasn't changed */
+	if (le32_to_cpu(disk->data_block_size) != md->block_size) {
+		DMERR("changing the data block size (from %u to %llu) is not supported",
+		      le32_to_cpu(disk->data_block_size), md->block_size);
+		r = -EINVAL;
+		goto bad;
+	}
+
 	r = dm_tm_open_with_sm(md->bm, SUPERBLOCK_LOCATION,
 			       disk->metadata_space_map_root,
 			       sizeof(disk->metadata_space_map_root),
@@ -575,7 +584,6 @@ static int open_metadata(struct era_meta
 
 	setup_infos(md);
 
-	md->block_size = le32_to_cpu(disk->data_block_size);
 	md->nr_blocks = le32_to_cpu(disk->nr_blocks);
 	md->current_era = le32_to_cpu(disk->current_era);
 


