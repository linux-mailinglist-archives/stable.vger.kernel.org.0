Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB78FA8B08
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbfIDQBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbfIDQBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82E72070C;
        Wed,  4 Sep 2019 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612893;
        bh=gJ+j8xvF3QHkqRQXLGe2LZiL1kQ2dtxg0eY4AnzEdXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUGc+krITn5lTV6BCRZoR1upwLB4zq6hTbIsqV5BBLVu0F1iC7sTSjgONU/TM26sX
         8xqnCzqYvb77Zc28XQ+zrk5Qz7FW4cvjnST38ZwlANYdjSM/w4V78Nqdz1V1AA0C4r
         Wiqp+A0UG+WEoQ3DPgiXqUD74qx0i8aUOqAna9kI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/36] NFSv4: Fix return values for nfs4_file_open()
Date:   Wed,  4 Sep 2019 12:00:55 -0400
Message-Id: <20190904160122.4179-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 90cf500e338ab3f3c0f126ba37e36fb6a9058441 ]

Currently, we are translating RPC level errors such as timeouts,
as well as interrupts etc into EOPENSTALE, which forces a single
replay of the open attempt. What we actually want to do is
force the replay only in the cases where the returned error
indicates that the file may have changed on the server.

So the fix is to spell out the exact set of errors where we want
to return EOPENSTALE.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 2b3e0f1ca572f..b8d316a338bc9 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -74,13 +74,13 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		switch (err) {
-		case -EPERM:
-		case -EACCES:
-		case -EDQUOT:
-		case -ENOSPC:
-		case -EROFS:
-			goto out_put_ctx;
 		default:
+			goto out_put_ctx;
+		case -ENOENT:
+		case -ESTALE:
+		case -EISDIR:
+		case -ENOTDIR:
+		case -ELOOP:
 			goto out_drop;
 		}
 	}
-- 
2.20.1

