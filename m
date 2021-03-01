Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46F2328FD7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbhCAT6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhCATqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:46:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADDA96528F;
        Mon,  1 Mar 2021 17:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619952;
        bh=QhClLIPplYrAGzkYRZh3kFb3KAaJQQQcTn0+ZSLK4F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lak8GRJKd8QKSyAcoPROLtaof/PT/Nkp+EIn8vue7fXb73c3RRBMUPe0imCLj1kmb
         sFGEbttGFDpGZ1F1EeNwuxCyvRW0cCz9K8j/K+ZeO1UJjmjeZyZU9RKcuJsmyJsRPf
         /mmtJBbN/V5EoxQDp4IOCdY8QXUuOdxTHUzJFy3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.10 640/663] gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end
Date:   Mon,  1 Mar 2021 17:14:48 +0100
Message-Id: <20210301161213.524410868@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
 


