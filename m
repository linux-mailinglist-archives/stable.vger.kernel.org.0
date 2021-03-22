Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A06344298
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhCVMoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhCVMlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E4361992;
        Mon, 22 Mar 2021 12:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416766;
        bh=nU6vJ7x98GC7m4TzEeEXHwcNC7UYiPgPSiWQSRqdCCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5kpfFBJsqLdqcjX3qX/7/GJ8uR0pIGa1oVqqEel7AkU83Nc00LrffOk395QjPS0z
         gSIhFONKxOUty5vOrzmXUbRGVNROMVUf4cjGKrqedKzagRhv5MzOcSkoRN3XENpQu+
         M6MfBsRYg7w17BUGAIr8OEvQpFQp4mEKnBSI/9L0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+50a8a9cf8127f2c6f5df@syzkaller.appspotmail.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/157] gfs2: bypass signal_our_withdraw if no journal
Date:   Mon, 22 Mar 2021 13:27:51 +0100
Message-Id: <20210322121937.389316438@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
index a1ecb2b48250..3ece99e6490c 100644
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



