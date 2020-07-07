Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4295B2170ED
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgGGPWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729837AbgGGPWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 256A720773;
        Tue,  7 Jul 2020 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135339;
        bh=SZMo4lJ02JixxSULEiH5qQ2oMHm5bYU/eZWP5P/FmwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILhvWnPgGb5okctaSjC27CeuY0KrpA2Q+zFzi8t7nyKQmP7sqReNCOXERZvykZ6hq
         gQwPuvXm/fQQSwoFfJUmQDXnJDpU0gQAfajk5YWDuiLww5+rb64nVpDoH4Kwhnd51I
         ZjTUMuX0kRp+xIjDdQ/Dt9JZSccZxY3pHKC7fBso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/65] nfsd: fix nfsdfs inode reference count leak
Date:   Tue,  7 Jul 2020 17:17:16 +0200
Message-Id: <20200707145754.265692996@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit bf2654017e0268cc83dc88d56f0e67ff4406631d ]

I don't understand this code well, but  I'm seeing a warning about a
still-referenced inode on unmount, and every other similar filesystem
does a dput() here.

Fixes: e8a79fb14f6b ("nfsd: add nfsd/clients directory")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 596ed6a42022d..be418fccc9d86 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1335,6 +1335,7 @@ void nfsd_client_rmdir(struct dentry *dentry)
 	WARN_ON_ONCE(ret);
 	fsnotify_rmdir(dir, dentry);
 	d_delete(dentry);
+	dput(dentry);
 	inode_unlock(dir);
 }
 
-- 
2.25.1



