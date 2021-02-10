Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E705316178
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhBJItV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:49:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231168AbhBJIsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 03:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612946805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/fKn8/oIIEtQRBemsvu5LN2XUOiS7skvs8/edKbJFow=;
        b=UDGottHBeuCN/pRkdVBNEka7m9ju0BwQYOnAGN48qLlv9FytvSCTQ0GmXh/98/RQcJbVh1
        KhuPSD13i2ck9wX8DysPdTt7gxdJ/wZFN3OAS3mysEWJvbEN1TJXsBqIKEgatceWgIV1U/
        WBJhU1NAlxSs9qGCsFo2p6eMAYKx+X0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-f8qAQFrMMCuJjs1ABNQuEQ-1; Wed, 10 Feb 2021 03:46:42 -0500
X-MC-Unique: f8qAQFrMMCuJjs1ABNQuEQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E706193578C
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 08:46:41 +0000 (UTC)
Received: from max.com (ovpn-112-155.ams2.redhat.com [10.36.112.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 496AA5D749;
        Wed, 10 Feb 2021 08:46:37 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end
Date:   Wed, 10 Feb 2021 09:46:35 +0100
Message-Id: <20210210084635.475507-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When starting an iomap write, gfs2_quota_lock_check -> gfs2_quota_lock
-> gfs2_quota_hold is called from gfs2_iomap_begin.  At the end of the
write, before unlocking the quotas, punch_hole -> gfs2_quota_hold can be
called again in gfs2_iomap_end, which is incorrect and leads to a failed
assertion.  Instead, move the call to gfs2_quota_unlock before the call
to punch_hole to fix that.

Fixes: 64bc06bb32ee ("gfs2: iomap buffered write support")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/bmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index cf6ccdd00587..7a358ae05185 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1230,6 +1230,9 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	gfs2_inplace_release(ip);
 
+	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
+		gfs2_quota_unlock(ip);
+
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
 		loff_t blockmask = i_blocksize(inode) - 1;
@@ -1242,9 +1245,6 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		}
 	}
 
-	if (ip->i_qadata && ip->i_qadata->qa_qd_num)
-		gfs2_quota_unlock(ip);
-
 	if (unlikely(!written))
 		goto out_unlock;
 
-- 
2.26.2

