Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02AB6AF4FF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjCGTVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjCGTVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0CBA188A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16D4A61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131A4C4339B;
        Tue,  7 Mar 2023 19:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215925;
        bh=BzyfmkEhRnsSq4Wk8WeAYEk1vY7xHBSOmthvn82SQ0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EErdqGCrL+GD5A5OeQ/oFge3R9Fiadmt0d4Owvo0l+098jDldv0sVSqZvNt86vxmN
         nDGfgXJMxtY6Q2lA9koIMX6BwMmRRhpkNUgtFFvTzXUfzBHMHtqWQ5CV96uJI0KVWd
         zdJz+eEHyJWXB4aNC6+A3neq9pjd3Y7bqTnOw3cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+f51cb4b9afbd87ec06f2@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/567] gfs2: Improve gfs2_make_fs_rw error handling
Date:   Tue,  7 Mar 2023 18:02:34 +0100
Message-Id: <20230307165923.992729764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index d615974ce4183..775ac3fb10c67 100644
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
2.39.2



