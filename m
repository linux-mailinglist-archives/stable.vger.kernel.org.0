Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2775E3C8E7D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhGNTsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237489AbhGNTq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C9D161408;
        Wed, 14 Jul 2021 19:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291780;
        bh=O0csXEgYRC6D4Ovgk61aLtj/+X0YhNXx8mySag30PNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWypnav7k8hgwH1cyHAiI4iR3CBYY8kPc04+J01QgxQ7KG7uLALxW3YNAQ6m39Ej7
         IpCh0/XasT9GagJDIwD9CO/reEkoS0iNoaKUsa5Sehka/yZlIlgbUHuuUNdRMRe1wq
         6+UNYENgMnpqSrya2GXqtR3OFYclQXHyJMEwXgJgRBYJ82lV9yTspdDtXgDJkDlRv5
         IfNBNiO4bmNPFIsl7vAqxi0xLc3wVnPXsHPX86IwGZvHUMhNIamk3L3Yp40uN2MwID
         h2btW9vpobbfx7mXa0DvrYHsNhgy7si5dcy0T+MVFiLaKoqLMgjFQ1vMjUQ36l81Fg
         8B25IjeKVxq7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.12 102/102] cifs: prevent NULL deref in cifs_compose_mount_options()
Date:   Wed, 14 Jul 2021 15:40:35 -0400
Message-Id: <20210714194036.53141-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 6b1ce4efb591..2891089aadbb 100644
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

