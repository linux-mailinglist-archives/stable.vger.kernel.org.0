Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7036AFA551
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfKMCWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbfKMBxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6832245D;
        Wed, 13 Nov 2019 01:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610010;
        bh=j7hhSDZ7CtrD2nv5ImgbrakypO9BBw85VDk4h55n7J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPM1M3+YgPbBv0tJ5e8rTbvxni9ua3rl9XBW6WUH5PgTooUkla15MnFQguqDriWxk
         QjMmu8oyJ+p1T8pw8WPNdMx1fR48MBCY8uLJPAHSFSK/hq9EikekN6fjGG9Fn/lUnm
         2BagWEMWqj5aHllov6BqH7e09Q0dPB0v2ykkIo+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 115/209] gfs2: slow the deluge of io error messages
Date:   Tue, 12 Nov 2019 20:48:51 -0500
Message-Id: <20191113015025.9685-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit b524abcc01483b2ac093cc6a8a2a7375558d2b64 ]

When an io error is hit, it calls gfs2_io_error_bh_i for every
journal buffer it can't write. Since we changed gfs2_io_error_bh_i
recently to withdraw later in the cycle, it sends a flood of
errors to the console. This patch checks for the file system already
being withdrawn, and if so, doesn't send more messages. It doesn't
stop the flood of messages, but it slows it down and keeps it more
reasonable.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/incore.h |  1 +
 fs/gfs2/log.c    |  7 +++++--
 fs/gfs2/util.c   | 13 +++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b96d39c28e17c..5d72e8b66a269 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -623,6 +623,7 @@ enum {
 	SDF_RORECOVERY		= 7, /* read only recovery */
 	SDF_SKIP_DLM_UNLOCK	= 8,
 	SDF_FORCE_AIL_FLUSH     = 9,
+	SDF_AIL1_IO_ERROR	= 10,
 };
 
 enum gfs2_freeze_state {
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index cd85092723dea..90b5c8d0c56ac 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -108,7 +108,9 @@ __acquires(&sdp->sd_ail_lock)
 		gfs2_assert(sdp, bd->bd_tr == tr);
 
 		if (!buffer_busy(bh)) {
-			if (!buffer_uptodate(bh)) {
+			if (!buffer_uptodate(bh) &&
+			    !test_and_set_bit(SDF_AIL1_IO_ERROR,
+					      &sdp->sd_flags)) {
 				gfs2_io_error_bh(sdp, bh);
 				*withdraw = true;
 			}
@@ -206,7 +208,8 @@ static void gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr,
 		gfs2_assert(sdp, bd->bd_tr == tr);
 		if (buffer_busy(bh))
 			continue;
-		if (!buffer_uptodate(bh)) {
+		if (!buffer_uptodate(bh) &&
+		    !test_and_set_bit(SDF_AIL1_IO_ERROR, &sdp->sd_flags)) {
 			gfs2_io_error_bh(sdp, bh);
 			*withdraw = true;
 		}
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 59c811de0dc7a..6a02cc890daf9 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -256,12 +256,13 @@ void gfs2_io_error_bh_i(struct gfs2_sbd *sdp, struct buffer_head *bh,
 			const char *function, char *file, unsigned int line,
 			bool withdraw)
 {
-	fs_err(sdp,
-	       "fatal: I/O error\n"
-	       "  block = %llu\n"
-	       "  function = %s, file = %s, line = %u\n",
-	       (unsigned long long)bh->b_blocknr,
-	       function, file, line);
+	if (!test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
+		fs_err(sdp,
+		       "fatal: I/O error\n"
+		       "  block = %llu\n"
+		       "  function = %s, file = %s, line = %u\n",
+		       (unsigned long long)bh->b_blocknr,
+		       function, file, line);
 	if (withdraw)
 		gfs2_lm_withdraw(sdp, NULL);
 }
-- 
2.20.1

