Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFADFA8FED
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbfIDSGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388736AbfIDSGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E78E208E4;
        Wed,  4 Sep 2019 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620400;
        bh=5T5wDFJbje64v9ulSPFeZifoLb4REAAMjvuMG4imxjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6r4iR+DYtx7oofXoJa8p4nuEYePphE0BuiIgmSc6ghLpsV5+uKOL872/KblXuEGj
         qkV1IavsdBOkcaiDB0187FZMO6es9GvKZ5jcl87R2NXIU2cDuwNhlhmPnK6wMygs7+
         uE28PiqVSut5cRxhR6lQXyUYEkBvCBa9rqAchuWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/93] afs: Only update d_fsdata if different in afs_d_revalidate()
Date:   Wed,  4 Sep 2019 19:53:08 +0200
Message-Id: <20190904175303.508008257@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5dc84855b0fc7e1db182b55c5564fd539d6eff92 ]

In the in-kernel afs filesystem, d_fsdata is set with the data version of
the parent directory.  afs_d_revalidate() will update this to the current
directory version, but it shouldn't do this if it the value it read from
d_fsdata is the same as no lock is held and cmpxchg() is not used.

Fix the code to only change the value if it is different from the current
directory version.

Fixes: 260a980317da ("[AFS]: Add "directory write" support.")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 855bf2b79fed4..54e7f6f1405e2 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -937,7 +937,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	dir_version = (long)dir->status.data_version;
 	de_version = (long)dentry->d_fsdata;
 	if (de_version == dir_version)
-		goto out_valid;
+		goto out_valid_noupdate;
 
 	dir_version = (long)dir->invalid_before;
 	if (de_version - dir_version >= 0)
@@ -1001,6 +1001,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 out_valid:
 	dentry->d_fsdata = (void *)dir_version;
+out_valid_noupdate:
 	dput(parent);
 	key_put(key);
 	_leave(" = 1 [valid]");
-- 
2.20.1



