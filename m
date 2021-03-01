Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B63291F0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243576AbhCAUg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243471AbhCAUaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:30:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B5865424;
        Mon,  1 Mar 2021 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622088;
        bh=QhClLIPplYrAGzkYRZh3kFb3KAaJQQQcTn0+ZSLK4F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8Lx6zw+Jj+/f6ep8lkcWBurRtuyrcQYz4lNeotzKdL/H7qHauur8gf7Cq/v3KvsQ
         UM0amzizYDOc8c0lkU/BoVLxq85Bui99shqg6ebMcwlE3I1oT0+9/7p44N5ynCKEsE
         /41H0VULl732rBCl+cTBKhG2OdHMXyafUKbR7ycM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.11 752/775] gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end
Date:   Mon,  1 Mar 2021 17:15:20 +0100
Message-Id: <20210301161238.477034084@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 7009fa9cd9a5262944b30eb7efb1f0561d074b68 upstream.

When starting an iomap write, gfs2_quota_lock_check -> gfs2_quota_lock
-> gfs2_quota_hold is called from gfs2_iomap_begin.  At the end of the
write, before unlocking the quotas, punch_hole -> gfs2_quota_hold can be
called again in gfs2_iomap_end, which is incorrect and leads to a failed
assertion.  Instead, move the call to gfs2_quota_unlock before the call
to punch_hole to fix that.

Fixes: 64bc06bb32ee ("gfs2: iomap buffered write support")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/bmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1230,6 +1230,9 @@ static int gfs2_iomap_end(struct inode *
 
 	gfs2_inplace_release(ip);
 
+	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
+		gfs2_quota_unlock(ip);
+
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
 		loff_t blockmask = i_blocksize(inode) - 1;
@@ -1242,9 +1245,6 @@ static int gfs2_iomap_end(struct inode *
 		}
 	}
 
-	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
-		gfs2_quota_unlock(ip);
-
 	if (unlikely(!written))
 		goto out_unlock;
 


