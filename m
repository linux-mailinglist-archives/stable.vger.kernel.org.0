Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0114A6B4A21
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbjCJPTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbjCJPSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:18:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544CA135961
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCF2DB82327
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2517EC433D2;
        Fri, 10 Mar 2023 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460393;
        bh=95Nk6mPeo+s1Hw10e97abRymircgby0Ah2xbzWPfa4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3tkSN55T56WByPCZmx7RBw+3OJc1W1pANa3BlW+z+Gr7AH28lIlwAuVQ2z+ms6rr
         uNUqrnRjcHfM1VlpV+Xwcb/ewngq97JxI/UKnBvXUP57S9YiQlaQP1EbYE1GnFR8TG
         JU8yBpa8Un7TimXFwtjS9/K/LN8MaZmxbgPn1cE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+f51cb4b9afbd87ec06f2@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/529] gfs2: Improve gfs2_make_fs_rw error handling
Date:   Fri, 10 Mar 2023 14:37:43 +0100
Message-Id: <20230310133819.821817740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index d14b98aa1c3eb..5cb7e771b57ab 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -145,8 +145,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 		return -EIO;
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-	if (error || gfs2_withdrawn(sdp))
+	if (error) {
+		gfs2_consist(sdp);
 		return error;
+	}
 
 	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
 		gfs2_consist(sdp);
@@ -158,7 +160,9 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
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



