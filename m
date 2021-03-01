Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC839328A00
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhCASJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238995AbhCASCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:02:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2155E65109;
        Mon,  1 Mar 2021 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618144;
        bh=8OXa68IVo/IzHQq1VAt2m/4RVBqIiT2CKKRLJPzARfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/ONexQRWmJY4PbLWLz4wnb1c60iApj0pzYSRMAFyr7W8nFyIqEFKyOlgoU8H6EDi
         25N6mXx+QAnde5OP5bmpT4/QfMLy2bL/B36VAI4E5f1q7G5uh+C5RwMYgf/zVsCfeB
         d2I+i0XYmHJ613+HMq0KealAWdAkSmYiJ/A36rWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.4 321/340] gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end
Date:   Mon,  1 Mar 2021 17:14:25 +0100
Message-Id: <20210301161104.094707790@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
@@ -1228,6 +1228,9 @@ static int gfs2_iomap_end(struct inode *
 
 	gfs2_inplace_release(ip);
 
+	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
+		gfs2_quota_unlock(ip);
+
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
 		loff_t blockmask = i_blocksize(inode) - 1;
@@ -1240,9 +1243,6 @@ static int gfs2_iomap_end(struct inode *
 		}
 	}
 
-	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
-		gfs2_quota_unlock(ip);
-
 	if (unlikely(!written))
 		goto out_unlock;
 


