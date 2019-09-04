Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB74CA906B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389959AbfIDSJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389399AbfIDSJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E071022DBF;
        Wed,  4 Sep 2019 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620574;
        bh=IH51GWUmZgIxiBJuFdoD1/Ikf2kGDZwYz5VVJH1ge44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nt8LF6r0500hVJ1I1to0YkTlEQYd+StgYupdihkyMxSd5M/Geh0YFSAvE7rherHYG
         udevyc0nHINrTgh7WP8QHndYCITsZKMRSpSh+oXelodMKuL8nuCMGjmMIYdogXcpjC
         EEcyAlagr71H5sh8MLz88A5FbwZC+CvPmMxHPBQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 007/143] afs: Only update d_fsdata if different in afs_d_revalidate()
Date:   Wed,  4 Sep 2019 19:52:30 +0200
Message-Id: <20190904175314.436310246@linuxfoundation.org>
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
index 9750ac70f8ffb..b87b41721eaa8 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1018,7 +1018,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	dir_version = (long)dir->status.data_version;
 	de_version = (long)dentry->d_fsdata;
 	if (de_version == dir_version)
-		goto out_valid;
+		goto out_valid_noupdate;
 
 	dir_version = (long)dir->invalid_before;
 	if (de_version - dir_version >= 0)
@@ -1082,6 +1082,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 out_valid:
 	dentry->d_fsdata = (void *)dir_version;
+out_valid_noupdate:
 	dput(parent);
 	key_put(key);
 	_leave(" = 1 [valid]");
-- 
2.20.1



