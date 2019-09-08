Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C6AACDDC
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfIHMyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733189AbfIHMwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:45 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E1572190F;
        Sun,  8 Sep 2019 12:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947165;
        bh=33mGaRZWrHhwiqP9nSj/0YhKLqDFGd9MZYXKhyZajIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cdzh4pUVZXQsWVhFwZRsJJrrqBqoDZpbSgEowDg87ZEdO3KgZXd/j9x0z4JH0Uhoy
         lVZ7XqWJ4ZNsqN/pWl9d3EIKvq1R9I08eH+A59Rqw+1VEEi+cssD044LpXTNzJdMY4
         4ewV7Nuktxv1Y5KLtmorHML+kjDSaAvYKUJKtxRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 85/94] afs: Fix possible oops in afs_lookup trace event
Date:   Sun,  8 Sep 2019 13:42:21 +0100
Message-Id: <20190908121152.865634230@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c4c613ff08d92e72bf64a65ec35a2c3aa1cfcd06 ]

The afs_lookup trace event can cause the following:

[  216.576777] BUG: kernel NULL pointer dereference, address: 000000000000023b
[  216.576803] #PF: supervisor read access in kernel mode
[  216.576813] #PF: error_code(0x0000) - not-present page
...
[  216.576913] RIP: 0010:trace_event_raw_event_afs_lookup+0x9e/0x1c0 [kafs]

If the inode from afs_do_lookup() is an error other than ENOENT, or if it
is ENOENT and afs_try_auto_mntpt() returns an error, the trace event will
try to dereference the error pointer as a valid pointer.

Use IS_ERR_OR_NULL to only pass a valid pointer for the trace, or NULL.

Ideally the trace would include the error value, but for now just avoid
the oops.

Fixes: 80548b03991f ("afs: Add more tracepoints")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9620f19308f58..9bd5c067d55d1 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -960,7 +960,8 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 				 inode ? AFS_FS_I(inode) : NULL);
 	} else {
 		trace_afs_lookup(dvnode, &dentry->d_name,
-				 inode ? AFS_FS_I(inode) : NULL);
+				 IS_ERR_OR_NULL(inode) ? NULL
+				 : AFS_FS_I(inode));
 	}
 	return d;
 }
-- 
2.20.1



