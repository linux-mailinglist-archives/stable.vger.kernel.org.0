Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366062B62C6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgKQNbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732091AbgKQNbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D0421534;
        Tue, 17 Nov 2020 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619900;
        bh=tX1AUp7YXM1xeAU3l7AFF7gZIUQEzeqmL7IKskPm3mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjMeQcGVtl67zK4HLqbiNyEtvouKaaaJHqVCMEE5lBm+pdQ8hrI9DtD/4S5md3pxl
         n6oOr3oUT/qE45S//la1p1I4ZAj1OF1vJ8mFnUoHHEZNPB0aHVNWZHwLq3er+HLQ21
         0JHiK0owYjgsBTbVrR2ZvXmwZIMW/fzV1/Hwo3D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 042/255] afs: Fix warning due to unadvanced marshalling pointer
Date:   Tue, 17 Nov 2020 14:03:02 +0100
Message-Id: <20201117122140.998740618@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c80afa1d9c3603d5eddeb8d63368823b1982f3f0 ]

When using the afs.yfs.acl xattr to change an AuriStor ACL, a warning
can be generated when the request is marshalled because the buffer
pointer isn't increased after adding the last element, thereby
triggering the check at the end if the ACL wasn't empty.  This just
causes something like the following warning, but doesn't stop the call
from happening successfully:

    kAFS: YFS.StoreOpaqueACL2: Request buffer underflow (36<108)

Fix this simply by increasing the count prior to the check.

Fixes: f5e4546347bc ("afs: Implement YFS ACL setting")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/yfsclient.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 3b1239b7e90d8..bd787e71a657f 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -1990,6 +1990,7 @@ void yfs_fs_store_opaque_acl2(struct afs_operation *op)
 	memcpy(bp, acl->data, acl->size);
 	if (acl->size != size)
 		memset((void *)bp + acl->size, 0, size - acl->size);
+	bp += size / sizeof(__be32);
 	yfs_check_req(call, bp);
 
 	trace_afs_make_fs_call(call, &vp->fid);
-- 
2.27.0



