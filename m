Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAE11B5A3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbfLKPQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbfLKPQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:16:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24EE720663;
        Wed, 11 Dec 2019 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077362;
        bh=uXh2vBvBRQO36GgVX8ar8zmIAph80dMhJHJkUXgaPvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hxwVOYHrIgi1jvF9vjj/fqMcezjeXr8n1G1BAymBxh1JBzUqUEq6f873X6EQg+rd
         m5AeiDsZzVfxtl33H/bfnK1Lmn1aeaXwLZbiS8mnP6V/nlb5LghQS/apfkWAswzdiy
         kHaasG3gfUu4l1VuKqIlSc7nrwv2n7RZa8Bt/9Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/243] autofs: fix a leak in autofs_expire_indirect()
Date:   Wed, 11 Dec 2019 16:02:53 +0100
Message-Id: <20191211150339.868438289@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 03ad0d703df75c43f78bd72e16124b5b94a95188 ]

if the second call of should_expire() in there ends up
grabbing and returning a new reference to dentry, we need
to drop it before continuing.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/expire.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
index 28d9c2b1b3bb3..70e9afe589fbf 100644
--- a/fs/autofs/expire.c
+++ b/fs/autofs/expire.c
@@ -501,9 +501,10 @@ static struct dentry *autofs_expire_indirect(struct super_block *sb,
 		 */
 		how &= ~AUTOFS_EXP_LEAVES;
 		found = should_expire(expired, mnt, timeout, how);
-		if (!found || found != expired)
-			/* Something has changed, continue */
+		if (found != expired) { // something has changed, continue
+			dput(found);
 			goto next;
+		}
 
 		if (expired != dentry)
 			dput(dentry);
-- 
2.20.1



