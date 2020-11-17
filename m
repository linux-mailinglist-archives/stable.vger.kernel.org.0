Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6337F2B61E3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbgKQNXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgKQNXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:23:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A035820781;
        Tue, 17 Nov 2020 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619398;
        bh=Amaad/paEtKj3YJHDmYvxhyyQB3iDevl/qm2qIEvk1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ehV4z1a5coVywCD6r9z180KAslYgerIweSffCuH0gXheSifuUVbQcTEY8DtGDX02
         bVq265poMwAUYQZIQkjZyu096DaFiVsAgcd6xep6ebjP1kAqn2TLPbrXJ3DjPqUK11
         WmnCo558DMHl1GsCJ/CbpQfMpyJ7e7bI6/v4v1f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/151] afs: Fix warning due to unadvanced marshalling pointer
Date:   Tue, 17 Nov 2020 14:04:15 +0100
Message-Id: <20201117122122.635053869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index d21cf61d86b9f..3b19b009452a2 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -2162,6 +2162,7 @@ int yfs_fs_store_opaque_acl2(struct afs_fs_cursor *fc, const struct afs_acl *acl
 	memcpy(bp, acl->data, acl->size);
 	if (acl->size != size)
 		memset((void *)bp + acl->size, 0, size - acl->size);
+	bp += size / sizeof(__be32);
 	yfs_check_req(call, bp);
 
 	trace_afs_make_fs_call(call, &vnode->fid);
-- 
2.27.0



