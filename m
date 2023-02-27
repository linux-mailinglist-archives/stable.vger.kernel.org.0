Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388E56A3788
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjB0CKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjB0CJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:09:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8311B316;
        Sun, 26 Feb 2023 18:08:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D24860CFA;
        Mon, 27 Feb 2023 02:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A4FC433EF;
        Mon, 27 Feb 2023 02:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463647;
        bh=NBsMRiGIBkKPZEIyH/zYnTizEGU9jmU/IIXS8ILElm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kj2L32tuetKSfVQoXTtnmbSRBTBF7ujn09vrgGQC5OPrsJ/xakbPvLAkIEaJEdwiA
         OOQl/TGQZiyZE9z+jYMDkLELH+mTXTGOl/PQ+Q+1nqGUDrC3SsfxH0kxVSwOzIe+HS
         nr5bxW2/hysx+G9x9yZ+SmeIzgJjEbiCjvmI9Dmjpy4M3K4sgJh+NtJq3bemiMml98
         KDomeSFqIyJ1Sd1T53i2+nVLp8XfcxTz+W659YSwXKpiAnvRscPJ8v+2iX6QNp57gX
         9bAhaBYAYQcij6wI2dn3C3NLsjCsyMieHrwdh3ZiV+lGyApgDcZUqRcbHn8i5ozQqu
         QTMrmK9/YMR1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+f51cb4b9afbd87ec06f2@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 6.1 39/58] gfs2: Improve gfs2_make_fs_rw error handling
Date:   Sun, 26 Feb 2023 21:04:37 -0500
Message-Id: <20230227020457.1048737-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit b66f723bb552ad59c2acb5d45ea45c890f84498b ]

In gfs2_make_fs_rw(), make sure to call gfs2_consist() to report an
inconsistency and mark the filesystem as withdrawn when
gfs2_find_jhead() fails.

At the end of gfs2_make_fs_rw(), when we discover that the filesystem
has been withdrawn, make sure we report an error.  This also replaces
the gfs2_withdrawn() check after gfs2_find_jhead().

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: syzbot+f51cb4b9afbd87ec06f2@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 011f9e7660ef8..2015bd05cba10 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -138,8 +138,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 		return -EIO;
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-	if (error || gfs2_withdrawn(sdp))
+	if (error) {
+		gfs2_consist(sdp);
 		return error;
+	}
 
 	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
 		gfs2_consist(sdp);
@@ -151,7 +153,9 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	gfs2_log_pointers_init(sdp, head.lh_blkno);
 
 	error = gfs2_quota_init(sdp);
-	if (!error && !gfs2_withdrawn(sdp))
+	if (!error && gfs2_withdrawn(sdp))
+		error = -EIO;
+	if (!error)
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	return error;
 }
-- 
2.39.0

