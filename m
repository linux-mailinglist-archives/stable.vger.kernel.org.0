Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C8F3D28F7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbhGVQAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233947AbhGVP7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E91BE610F7;
        Thu, 22 Jul 2021 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972017;
        bh=1hhfoDnLR//qSYDnY8xRYaUZegP8wJGVxsQXmHk7HfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDxe5WcCZjv88hC4YC8CseWYwhAE7GmShcXKoH0HJmYhg7JZ0CI2OS2/c0vAVbnYt
         PlOXXPP6m+JM6+082USnJ2dijW/vyKJ1dJFbMrHVKvpGMF/uZZ//k7UxVl6+mObzUW
         AdTleeruWx+m5G79eJ23PsnGs1aNSQh0+CT3V0R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/125] cifs: prevent NULL deref in cifs_compose_mount_options()
Date:   Thu, 22 Jul 2021 18:31:11 +0200
Message-Id: <20210722155627.347431576@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 03313d1c3a2f086bb60920607ab79ac8f8578306 ]

The optional @ref parameter might contain an NULL node_name, so
prevent dereferencing it in cifs_compose_mount_options().

Addresses-Coverity: 1476408 ("Explicit null dereferenced")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index cc3ada12848d..42125601ebb1 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -151,6 +151,9 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		return ERR_PTR(-EINVAL);
 
 	if (ref) {
+		if (WARN_ON_ONCE(!ref->node_name || ref->path_consumed < 0))
+			return ERR_PTR(-EINVAL);
+
 		if (strlen(fullpath) - ref->path_consumed) {
 			prepath = fullpath + ref->path_consumed;
 			/* skip initial delimiter */
-- 
2.30.2



