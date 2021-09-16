Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD5C40E258
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhIPQhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244375AbhIPQfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75302613A5;
        Thu, 16 Sep 2021 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809274;
        bh=vYKXHe/jFrjiKy5qDGHYMQHLWC/Ba7C/sDk/9okOIKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0K7xGy5E5of2iKXowdeKHAtHSgIlvjPIDaXdHMBN2JjCE5kqEIiESwJCtQvV9IT2r
         pztAYlywjOpMAWHf9KtaWnEmVeDEddQB+REVO+zG/5BQPXPpoppUki02n4UAcGpLpk
         FcwILtWwe2zdBEOYWW4LmQJ/h3cJntrGHyVAPmWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 094/380] NFSv4/pNFS: Fix a layoutget livelock loop
Date:   Thu, 16 Sep 2021 17:57:31 +0200
Message-Id: <20210916155807.230295170@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e20772cbdf463c12088837e5a08bde1b876bfd25 ]

If NFS_LAYOUT_RETURN_REQUESTED is set, but there is no value set for
the layout plh_return_seq, we can end up in a livelock loop in which
every layout segment retrieved by a new call to layoutget is immediately
invalidated by pnfs_layout_need_return().
To get around this, we should just set plh_return_seq to the current
value of the layout stateid's seqid.

Fixes: d474f96104bd ("NFS: Don't return layout segments that are in use")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index be960e47d7f6..3ee607aa007b 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -347,11 +347,15 @@ pnfs_set_plh_return_info(struct pnfs_layout_hdr *lo, enum pnfs_iomode iomode,
 		iomode = IOMODE_ANY;
 	lo->plh_return_iomode = iomode;
 	set_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags);
-	if (seq != 0) {
-		WARN_ON_ONCE(lo->plh_return_seq != 0 && lo->plh_return_seq != seq);
+	/*
+	 * We must set lo->plh_return_seq to avoid livelocks with
+	 * pnfs_layout_need_return()
+	 */
+	if (seq == 0)
+		seq = be32_to_cpu(lo->plh_stateid.seqid);
+	if (!lo->plh_return_seq || pnfs_seqid_is_newer(seq, lo->plh_return_seq))
 		lo->plh_return_seq = seq;
-		pnfs_barrier_update(lo, seq);
-	}
+	pnfs_barrier_update(lo, seq);
 }
 
 static void
-- 
2.30.2



