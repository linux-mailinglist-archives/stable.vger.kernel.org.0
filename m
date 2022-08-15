Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D2359493C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355399AbiHOX4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356218AbiHOXx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2468A15E6A5;
        Mon, 15 Aug 2022 13:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1871260F17;
        Mon, 15 Aug 2022 20:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091AAC433C1;
        Mon, 15 Aug 2022 20:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594714;
        bh=uGV0oAYI1DaH27rMwlkN03ACoMpW3nZ3BAo4v9G+Vaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZd64X0pgkVcA+LCfqnaQ+N7e1HbwXm1wmb2QijwdtZ88nVzcvV6Hhx+TbEQRD4Ji
         OMCTbeKhrNIsFkPKTMCtlmH4EL0UM6A2fRd0MXq6U+XZhOUAnchsVoynLuknad5qso
         XwsTSLUU1lK3nfBE01otG5Gw6WB84uZvzg5bFFAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0535/1157] btrfs: update stripe_sectors::uptodate in steal_rbio
Date:   Mon, 15 Aug 2022 19:58:11 +0200
Message-Id: <20220815180501.056583969@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4d10046613333508d31fe926c545c8c0b620508a ]

[BUG]
With added debugging, it turns out the following write sequence would
cause extra read which is unnecessary:

  # xfs_io -f -s -c "pwrite -b 32k 0 32k" -c "pwrite -b 32k 32k 32k" \
		 -c "pwrite -b 32k 64k 32k" -c "pwrite -b 32k 96k 32k" \
		 $mnt/file

The debug message looks like this (btrfs header skipped):

  partial rmw, full stripe=389152768 opf=0x0 devid=3 type=1 offset=32768 physical=323059712 len=32768
  partial rmw, full stripe=389152768 opf=0x0 devid=1 type=2 offset=0 physical=67174400 len=65536
  full stripe rmw, full stripe=389152768 opf=0x1 devid=3 type=1 offset=0 physical=323026944 len=32768
  full stripe rmw, full stripe=389152768 opf=0x1 devid=2 type=-1 offset=0 physical=323026944 len=32768
  partial rmw, full stripe=298844160 opf=0x0 devid=1 type=1 offset=32768 physical=22052864 len=32768
  partial rmw, full stripe=298844160 opf=0x0 devid=2 type=2 offset=0 physical=277872640 len=65536
  full stripe rmw, full stripe=298844160 opf=0x1 devid=1 type=1 offset=0 physical=22020096 len=32768
  full stripe rmw, full stripe=298844160 opf=0x1 devid=3 type=-1 offset=0 physical=277872640 len=32768
  partial rmw, full stripe=389152768 opf=0x0 devid=3 type=1 offset=0 physical=323026944 len=32768
  partial rmw, full stripe=389152768 opf=0x0 devid=1 type=2 offset=0 physical=67174400 len=65536
  ^^^^
   Still partial read, even 389152768 is already cached by the first.
   write.

  full stripe rmw, full stripe=389152768 opf=0x1 devid=3 type=1 offset=32768 physical=323059712 len=32768
  full stripe rmw, full stripe=389152768 opf=0x1 devid=2 type=-1 offset=32768 physical=323059712 len=32768
  partial rmw, full stripe=298844160 opf=0x0 devid=1 type=1 offset=0 physical=22020096 len=32768
  partial rmw, full stripe=298844160 opf=0x0 devid=2 type=2 offset=0 physical=277872640 len=65536
  ^^^^
   Still partial read for 298844160.

  full stripe rmw, full stripe=298844160 opf=0x1 devid=1 type=1 offset=32768 physical=22052864 len=32768
  full stripe rmw, full stripe=298844160 opf=0x1 devid=3 type=-1 offset=32768 physical=277905408 len=32768

This means every 32K writes, even they are in the same full stripe,
still trigger read for previously cached data.

This would cause extra RAID56 IO, making the btrfs raid56 cache useless.

[CAUSE]
Commit d4e28d9b5f04 ("btrfs: raid56: make steal_rbio() subpage
compatible") tries to make steal_rbio() subpage compatible, but during
that conversion, there is one thing missing.

We no longer rely on PageUptodate(rbio->stripe_pages[i]), but
rbio->stripe_nsectors[i].uptodate to determine if a sector is uptodate.

This means, previously if we switch the pointer, everything is done,
as the PageUptodate flag is still bound to that page.

But now we have to manually mark the involved sectors uptodate, or later
raid56_rmw_stripe() will find the stolen sector is not uptodate, and
assemble the read bio for it, wasting IO.

[FIX]
We can easily fix the bug, by also update the
rbio->stripe_sectors[].uptodate in steal_rbio().

With this fixed, now the same write pattern no longer leads to the same
unnecessary read:

  partial rmw, full stripe=389152768 opf=0x0 devid=3 type=1 offset=32768 physical=323059712 len=32768
  partial rmw, full stripe=389152768 opf=0x0 devid=1 type=2 offset=0 physical=67174400 len=65536
  full stripe rmw, full stripe=389152768 opf=0x1 devid=3 type=1 offset=0 physical=323026944 len=32768
  full stripe rmw, full stripe=389152768 opf=0x1 devid=2 type=-1 offset=0 physical=323026944 len=32768
  partial rmw, full stripe=298844160 opf=0x0 devid=1 type=1 offset=32768 physical=22052864 len=32768
  partial rmw, full stripe=298844160 opf=0x0 devid=2 type=2 offset=0 physical=277872640 len=65536
  full stripe rmw, full stripe=298844160 opf=0x1 devid=1 type=1 offset=0 physical=22020096 len=32768
  full stripe rmw, full stripe=298844160 opf=0x1 devid=3 type=-1 offset=0 physical=277872640 len=32768
  ^^^ No more partial read, directly into the write path.
  full stripe rmw, full stripe=389152768 opf=0x1 devid=3 type=1 offset=32768 physical=323059712 len=32768
  full stripe rmw, full stripe=389152768 opf=0x1 devid=2 type=-1 offset=32768 physical=323059712 len=32768
  full stripe rmw, full stripe=298844160 opf=0x1 devid=1 type=1 offset=32768 physical=22052864 len=32768
  full stripe rmw, full stripe=298844160 opf=0x1 devid=3 type=-1 offset=32768 physical=277905408 len=32768

Fixes: d4e28d9b5f04 ("btrfs: raid56: make steal_rbio() subpage compatible")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid56.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a5b623ee6fac..13e0bb0479e6 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -347,6 +347,24 @@ static void index_stripe_sectors(struct btrfs_raid_bio *rbio)
 	}
 }
 
+static void steal_rbio_page(struct btrfs_raid_bio *src,
+			    struct btrfs_raid_bio *dest, int page_nr)
+{
+	const u32 sectorsize = src->bioc->fs_info->sectorsize;
+	const u32 sectors_per_page = PAGE_SIZE / sectorsize;
+	int i;
+
+	if (dest->stripe_pages[page_nr])
+		__free_page(dest->stripe_pages[page_nr]);
+	dest->stripe_pages[page_nr] = src->stripe_pages[page_nr];
+	src->stripe_pages[page_nr] = NULL;
+
+	/* Also update the sector->uptodate bits. */
+	for (i = sectors_per_page * page_nr;
+	     i < sectors_per_page * page_nr + sectors_per_page; i++)
+		dest->stripe_sectors[i].uptodate = true;
+}
+
 /*
  * Stealing an rbio means taking all the uptodate pages from the stripe array
  * in the source rbio and putting them into the destination rbio.
@@ -358,7 +376,6 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
 {
 	int i;
 	struct page *s;
-	struct page *d;
 
 	if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
 		return;
@@ -368,12 +385,7 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
 		if (!s || !full_page_sectors_uptodate(src, i))
 			continue;
 
-		d = dest->stripe_pages[i];
-		if (d)
-			__free_page(d);
-
-		dest->stripe_pages[i] = s;
-		src->stripe_pages[i] = NULL;
+		steal_rbio_page(src, dest, i);
 	}
 	index_stripe_sectors(dest);
 	index_stripe_sectors(src);
-- 
2.35.1



