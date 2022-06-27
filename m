Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C81355DAA3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbiF0LwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbiF0LvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3772639;
        Mon, 27 Jun 2022 04:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B582B80D92;
        Mon, 27 Jun 2022 11:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729EAC3411D;
        Mon, 27 Jun 2022 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330239;
        bh=3et7C20MPNxTW5cx0titcr+mDahhou3MD2NyUskSB3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/BVIg5rnI4lla3rzcWRrRa4zXWhM5W7/hFHMiys9WGIjh4JZ+VLHF/nkEOaQGqxu
         aGZ5PqNpKDrKIIBcCO95S50pX5IyNXIVl4Hkevma7PKDHPmlI78ieKBFl5ixVuXnRS
         eU2jpiEkanMgZ09oW2V9CIlzHBms+M6rEZ9W41Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.18 128/181] f2fs: fix iostat related lock protection
Date:   Mon, 27 Jun 2022 13:21:41 +0200
Message-Id: <20220627111948.403218635@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daeho Jeong <daehojeong@google.com>

commit 61803e984307c767a96d85f3b61ca50e1705fc67 upstream.

Made iostat related locks safe to be called from irq context again.

Cc: <stable@vger.kernel.org>
Fixes: a1e09b03e6f5 ("f2fs: use iomap for direct I/O")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Tested-by: Eddie Huang <eddie.huang@mediatek.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/iostat.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -91,8 +91,9 @@ static inline void __record_iostat_laten
 	unsigned int cnt;
 	struct f2fs_iostat_latency iostat_lat[MAX_IO_TYPE][NR_PAGE_TYPE];
 	struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
+	unsigned long flags;
 
-	spin_lock_bh(&sbi->iostat_lat_lock);
+	spin_lock_irqsave(&sbi->iostat_lat_lock, flags);
 	for (idx = 0; idx < MAX_IO_TYPE; idx++) {
 		for (io = 0; io < NR_PAGE_TYPE; io++) {
 			cnt = io_lat->bio_cnt[idx][io];
@@ -106,7 +107,7 @@ static inline void __record_iostat_laten
 			io_lat->bio_cnt[idx][io] = 0;
 		}
 	}
-	spin_unlock_bh(&sbi->iostat_lat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lat_lock, flags);
 
 	trace_f2fs_iostat_latency(sbi, iostat_lat);
 }
@@ -115,14 +116,15 @@ static inline void f2fs_record_iostat(st
 {
 	unsigned long long iostat_diff[NR_IO_TYPE];
 	int i;
+	unsigned long flags;
 
 	if (time_is_after_jiffies(sbi->iostat_next_period))
 		return;
 
 	/* Need double check under the lock */
-	spin_lock_bh(&sbi->iostat_lock);
+	spin_lock_irqsave(&sbi->iostat_lock, flags);
 	if (time_is_after_jiffies(sbi->iostat_next_period)) {
-		spin_unlock_bh(&sbi->iostat_lock);
+		spin_unlock_irqrestore(&sbi->iostat_lock, flags);
 		return;
 	}
 	sbi->iostat_next_period = jiffies +
@@ -133,7 +135,7 @@ static inline void f2fs_record_iostat(st
 				sbi->prev_rw_iostat[i];
 		sbi->prev_rw_iostat[i] = sbi->rw_iostat[i];
 	}
-	spin_unlock_bh(&sbi->iostat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lock, flags);
 
 	trace_f2fs_iostat(sbi, iostat_diff);
 
@@ -145,25 +147,27 @@ void f2fs_reset_iostat(struct f2fs_sb_in
 	struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
 	int i;
 
-	spin_lock_bh(&sbi->iostat_lock);
+	spin_lock_irq(&sbi->iostat_lock);
 	for (i = 0; i < NR_IO_TYPE; i++) {
 		sbi->rw_iostat[i] = 0;
 		sbi->prev_rw_iostat[i] = 0;
 	}
-	spin_unlock_bh(&sbi->iostat_lock);
+	spin_unlock_irq(&sbi->iostat_lock);
 
-	spin_lock_bh(&sbi->iostat_lat_lock);
+	spin_lock_irq(&sbi->iostat_lat_lock);
 	memset(io_lat, 0, sizeof(struct iostat_lat_info));
-	spin_unlock_bh(&sbi->iostat_lat_lock);
+	spin_unlock_irq(&sbi->iostat_lat_lock);
 }
 
 void f2fs_update_iostat(struct f2fs_sb_info *sbi,
 			enum iostat_type type, unsigned long long io_bytes)
 {
+	unsigned long flags;
+
 	if (!sbi->iostat_enable)
 		return;
 
-	spin_lock_bh(&sbi->iostat_lock);
+	spin_lock_irqsave(&sbi->iostat_lock, flags);
 	sbi->rw_iostat[type] += io_bytes;
 
 	if (type == APP_BUFFERED_IO || type == APP_DIRECT_IO)
@@ -172,7 +176,7 @@ void f2fs_update_iostat(struct f2fs_sb_i
 	if (type == APP_BUFFERED_READ_IO || type == APP_DIRECT_READ_IO)
 		sbi->rw_iostat[APP_READ_IO] += io_bytes;
 
-	spin_unlock_bh(&sbi->iostat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lock, flags);
 
 	f2fs_record_iostat(sbi);
 }
@@ -185,6 +189,7 @@ static inline void __update_iostat_laten
 	struct f2fs_sb_info *sbi = iostat_ctx->sbi;
 	struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
 	int idx;
+	unsigned long flags;
 
 	if (!sbi->iostat_enable)
 		return;
@@ -202,12 +207,12 @@ static inline void __update_iostat_laten
 			idx = WRITE_ASYNC_IO;
 	}
 
-	spin_lock_bh(&sbi->iostat_lat_lock);
+	spin_lock_irqsave(&sbi->iostat_lat_lock, flags);
 	io_lat->sum_lat[idx][iotype] += ts_diff;
 	io_lat->bio_cnt[idx][iotype]++;
 	if (ts_diff > io_lat->peak_lat[idx][iotype])
 		io_lat->peak_lat[idx][iotype] = ts_diff;
-	spin_unlock_bh(&sbi->iostat_lat_lock);
+	spin_unlock_irqrestore(&sbi->iostat_lat_lock, flags);
 }
 
 void iostat_update_and_unbind_ctx(struct bio *bio, int rw)


