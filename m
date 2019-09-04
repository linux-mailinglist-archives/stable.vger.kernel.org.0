Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1023AA9069
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbfIDSJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389946AbfIDSJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4650522DBF;
        Wed,  4 Sep 2019 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620571;
        bh=APqCzItaMLRksySs4tnt/4wUpoPJu0C59n8m8Bke+8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdNJdHktfkPXqTnZw3KDz/Uz3oKWQ/u3dVoqz5stjSEWrFD7xh2rxk3e8paL7MXGH
         FTvDfCgJUvnP+MGJahGARdx+EZHsNG6GSLKwXHD/f/HY43a5zBzDyPahzz6va2lq3u
         2NKRPUuk105EQJsXZ99C2YgPu1ftVtl2GDZUq+mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 006/143] afs: Fix off-by-one in afs_rename() expected data version calculation
Date:   Wed,  4 Sep 2019 19:52:29 +0200
Message-Id: <20190904175314.407816191@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 37c0bbb3326674940e657118306ac52364314523 ]

When afs_rename() calculates the expected data version of the target
directory in a cross-directory rename, it doesn't increment it as it
should, so it always thinks that the target inode is unexpectedly modified
on the server.

Fixes: a58823ac4589 ("afs: Fix application of status and callback to be under same lock")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index da9563d62b327..9750ac70f8ffb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1807,7 +1807,7 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				afs_end_vnode_operation(&fc);
 				goto error_rehash;
 			}
-			new_data_version = new_dvnode->status.data_version;
+			new_data_version = new_dvnode->status.data_version + 1;
 		} else {
 			new_data_version = orig_data_version;
 			new_scb = &scb[0];
-- 
2.20.1



