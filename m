Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5964C341C9D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCSMVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhCSMV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107E864F74;
        Fri, 19 Mar 2021 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156489;
        bh=ku6UCkzG6k0qIJeLH6CK6P17peVO/1vMx6GQEsgIhuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cd46iN9EeY0bcu1Jh3ABia7LxNix77w6Iz9WWpFu1NY3cC+D79rPyLZfsVSb0ZfY1
         +NJLC7E3wAPZ7LNgDEEEpModzdP2Syw4Jm5O6DjvoqL6tg/N1VFOe0qNOSEWcgwpEp
         gGsYRF2XI2+PpOBTgdFrlqWhN4BfMClnMZFNdW+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+50a8a9cf8127f2c6f5df@syzkaller.appspotmail.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 19/31] gfs2: bypass signal_our_withdraw if no journal
Date:   Fri, 19 Mar 2021 13:19:13 +0100
Message-Id: <20210319121747.822193917@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit d5bf630f355d8c532bef2347cf90e8ae60a5f1bd ]

Before this patch, function signal_our_withdraw referenced the journal
inode immediately. But corrupt file systems may have some invalid
journals, in which case our attempt to read it in will withdraw and the
resulting signal_our_withdraw would dereference the NULL value.

This patch adds a check to signal_our_withdraw so that if the journal
has not yet been initialized, it simply returns and does the old-style
withdraw.

Thanks, Andy Price, for his analysis.

Reported-by: syzbot+50a8a9cf8127f2c6f5df@syzkaller.appspotmail.com
Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/util.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 8d3c670c990f..dc4985429cf2 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -119,17 +119,22 @@ void gfs2_freeze_unlock(struct gfs2_holder *freeze_gh)
 static void signal_our_withdraw(struct gfs2_sbd *sdp)
 {
 	struct gfs2_glock *live_gl = sdp->sd_live_gh.gh_gl;
-	struct inode *inode = sdp->sd_jdesc->jd_inode;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_glock *i_gl = ip->i_gl;
-	u64 no_formal_ino = ip->i_no_formal_ino;
+	struct inode *inode;
+	struct gfs2_inode *ip;
+	struct gfs2_glock *i_gl;
+	u64 no_formal_ino;
 	int log_write_allowed = test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	int ret = 0;
 	int tries;
 
-	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags))
+	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags) || !sdp->sd_jdesc)
 		return;
 
+	inode = sdp->sd_jdesc->jd_inode;
+	ip = GFS2_I(inode);
+	i_gl = ip->i_gl;
+	no_formal_ino = ip->i_no_formal_ino;
+
 	/* Prevent any glock dq until withdraw recovery is complete */
 	set_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags);
 	/*
-- 
2.30.1



