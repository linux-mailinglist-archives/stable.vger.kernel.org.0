Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2923068B495
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 04:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjBFDnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 22:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBFDnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 22:43:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011CA40DE;
        Sun,  5 Feb 2023 19:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BD10B80D2C;
        Mon,  6 Feb 2023 03:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F54C433EF;
        Mon,  6 Feb 2023 03:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675655027;
        bh=I6XJ1YYl5GhAsWCjBFGIoN3YE0rbCKgyl8VhuEMuFvI=;
        h=From:To:Cc:Subject:Date:From;
        b=PouiTb7sHTX8feMHRonqeyUnuKRbiu6PSrAtYhpbrz2sPg3lngHUQQgRKGAOmYg6u
         MucWH1lBavZTEh6cWYltL2uk2eL/N/XFTa9RoDmHY3CRqefsNbDj27q5jKTBzj58UM
         QZcsjJA0g6SQBikBKmtdiGBfYVxISa6kmdgAl6P9BdOv3/6w49iZY03NV8L1y6TC9q
         0/CwMJCx2h8ss9+S0oycq0ihQ8RP1CvyLOHpuicr8iySmXoVJMXza4wcu/MVFAW/S4
         B49EB59s7ZwkHC5TmKhEMba5Ri+yBp2rltygOIUvmaR+fLoiLddGujaeS/u2RQSN0p
         WPcuiRd1qEvVg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: fix kernel crash due to null io->bio
Date:   Sun,  5 Feb 2023 19:43:44 -0800
Message-Id: <20230206034344.724593-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should return when io->bio is null before doing anything. Otherwise, panic.

BUG: kernel NULL pointer dereference, address: 0000000000000010
RIP: 0010:__submit_merged_write_cond+0x164/0x240 [f2fs]
Call Trace:
 <TASK>
 f2fs_submit_merged_write+0x1d/0x30 [f2fs]
 commit_checkpoint+0x110/0x1e0 [f2fs]
 f2fs_write_checkpoint+0x9f7/0xf00 [f2fs]
 ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
 __checkpoint_and_complete_reqs+0x84/0x190 [f2fs]
 ? preempt_count_add+0x82/0xc0
 ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
 issue_checkpoint_thread+0x4c/0xf0 [f2fs]
 ? __pfx_autoremove_wake_function+0x10/0x10
 kthread+0xff/0x130
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2c/0x50
 </TASK>

Cc: stable@vger.kernel.org # v5.18+
Fixes: 64bf0eef0171 ("f2fs: pass the bio operation to bio_alloc_bioset")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 12f233f2fd58..ea8311a58ab7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -653,6 +653,9 @@ static void __f2fs_submit_merged_write(struct f2fs_sb_info *sbi,
 
 	f2fs_down_write(&io->io_rwsem);
 
+	if (!io->bio)
+		goto unlock_out;
+
 	/* change META to META_FLUSH in the checkpoint procedure */
 	if (type >= META_FLUSH) {
 		io->fio.type = META_FLUSH;
@@ -661,6 +664,7 @@ static void __f2fs_submit_merged_write(struct f2fs_sb_info *sbi,
 			io->bio->bi_opf |= REQ_PREFLUSH | REQ_FUA;
 	}
 	__submit_merged_bio(io);
+unlock_out:
 	f2fs_up_write(&io->io_rwsem);
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

