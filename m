Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32192E387A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgL1NKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbgL1NKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F79207C9;
        Mon, 28 Dec 2020 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161011;
        bh=E1Po2a34Nul6cELi0O22gqoF+HdPOMydSDjCgxKwYAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOFdKnqZ7+u6YWyeZszwsIibERg2iFNguSvsgHnV2ue4OpIjT52Z30HcWx9hSOXKf
         7vgWtmH+bRUaFYXBwYGdzhqxQwWYCK4ysQIQgdf+A0dH7oOZu2y1nvY7cOedAAcJVo
         IjrypHXkxGXcRdyjMDTsmg4hqOZX1WsfwM8q40cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyue Ren <rentianyue@kylinos.cn>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/242] selinux: fix error initialization in inode_doinit_with_dentry()
Date:   Mon, 28 Dec 2020 13:47:54 +0100
Message-Id: <20201228124908.081784056@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyue Ren <rentianyue@kylinos.cn>

[ Upstream commit 83370b31a915493231e5b9addc72e4bef69f8d31 ]

Mark the inode security label as invalid if we cannot find
a dentry so that we will retry later rather than marking it
initialized with the unlabeled SID.

Fixes: 9287aed2ad1f ("selinux: Convert isec->lock into a spinlock")
Signed-off-by: Tianyue Ren <rentianyue@kylinos.cn>
[PM: minor comment tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5def19ec11797..af8ddae0ddedb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1569,7 +1569,13 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			goto out;
+			isec->initialized = LABEL_INVALID;
+			/*
+			 * There is nothing useful to jump to the "out"
+			 * label, except a needless spin lock/unlock
+			 * cycle.
+			 */
+			return 0;
 		}
 
 		len = INITCONTEXTLEN;
@@ -1677,8 +1683,15 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry)
-				goto out;
+			if (!dentry) {
+				isec->initialized = LABEL_INVALID;
+				/*
+				 * There is nothing useful to jump to the "out"
+				 * label, except a needless spin lock/unlock
+				 * cycle.
+				 */
+				return 0;
+			}
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);
-- 
2.27.0



