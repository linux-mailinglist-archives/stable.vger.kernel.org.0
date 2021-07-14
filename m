Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24D63C8FB4
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbhGNTxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240404AbhGNTtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B8161440;
        Wed, 14 Jul 2021 19:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291912;
        bh=1hhfoDnLR//qSYDnY8xRYaUZegP8wJGVxsQXmHk7HfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E07+Z5LZkv2JGpkpOOTpu1MtBhbb45Qk5njpoa5DQFmNs580aGrsKJZOcIxC5eQe1
         s+0UngZBpJpIo/+Atf3zdq4P0dwAbu5yjmOTmeyk8vFd7iXjWikxeQD6jiNjR1kFiY
         Hgg+7fmLjvkToBL5k14Ph0K4ilhoH9OQ4ARHUQ5hnOKBBO1vVyJ3f9sS1zUzXS5G2f
         ZYe2byM87BRHqbuHQnFm//Jel5Pn8H+upeI/NhJROpY0VnFuMpSP8AqCQpYqZQCcZB
         kwvrTEgEt7OkrAaDJIomG8LGE7BDO57TdN7egXAXB9L7W8ZGl4jQYJeNHAwySR5mPI
         XiMP55XuoXLJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 88/88] cifs: prevent NULL deref in cifs_compose_mount_options()
Date:   Wed, 14 Jul 2021 15:43:03 -0400
Message-Id: <20210714194303.54028-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

