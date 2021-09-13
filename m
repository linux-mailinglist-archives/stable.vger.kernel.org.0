Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7C840915D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhIMOA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244580AbhIMN6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E62619F5;
        Mon, 13 Sep 2021 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540215;
        bh=DpN0gwAy7LbhWQbQzhZCdmWMr/MbbS1yDoc5zKleJww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTPjhBmKGDHaCCwSnNJI+D3J8vMKvuSqUGwYDIsr43wsrkXSARAEmLfnZgNU086Bc
         kjpMEj52VnUS6Fo1vFvSJQsnGVDuBuTJIeZN3myWCDhnJDVpwKj6FYZvBUIaS0WqvZ
         AKAkcugjcC0TQhsEO5Gz/DY/C4wdRd0ofvx94azg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 101/300] gfs2: Fix memory leak of object lsi on error return path
Date:   Mon, 13 Sep 2021 15:12:42 +0200
Message-Id: <20210913131112.787815130@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a6579cbfd7216b071008db13360c322a6b21400b ]

In the case where IS_ERR(lsi->si_sc_inode) is true the error exit path
to free_local does not kfree the allocated object lsi leading to a memory
leak. Fix this by kfree'ing lst before taking the error exit path.

Addresses-Coverity: ("Resource leak")
Fixes: 97fd734ba17e ("gfs2: lookup local statfs inodes prior to journal recovery")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5f4504dd0875..bd3b3be1a473 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -677,6 +677,7 @@ static int init_statfs(struct gfs2_sbd *sdp)
 			error = PTR_ERR(lsi->si_sc_inode);
 			fs_err(sdp, "can't find local \"sc\" file#%u: %d\n",
 			       jd->jd_jid, error);
+			kfree(lsi);
 			goto free_local;
 		}
 		lsi->si_jid = jd->jd_jid;
-- 
2.30.2



