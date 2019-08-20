Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4481C96184
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfHTNsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfHTNkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:36 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FEAE230F2;
        Tue, 20 Aug 2019 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308435;
        bh=B/hLYc7cxxyJ07aBCg1qJhDQzflRg5gX4K4s5PkaqLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzUqS5DmbY3mSkYW32zqkfshDdDxiSpWaWtZ1SoeLxaOngchoE+SiY8eD1t7TDGnr
         V8rKQRtijMV5sqLrjOTT4XhhUEiR3KF4AdMZgpzbINbuiYdZqpSuTPwYAXjiSaDzuI
         hoNl58xwGi9vs8AvD/i1KFRtpV5ykY4Sk7wlIWWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 07/44] afs: Only update d_fsdata if different in afs_d_revalidate()
Date:   Tue, 20 Aug 2019 09:39:51 -0400
Message-Id: <20190820134028.10829-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

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

