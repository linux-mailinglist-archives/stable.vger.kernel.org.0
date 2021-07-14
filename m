Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B8D3C8D42
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhGNToR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhGNTnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD64613E8;
        Wed, 14 Jul 2021 19:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291634;
        bh=q2Px6zKs/i7okRqz6Z6BNxv5W0pDtSNaUU/oHMVllOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adEl85eIy/xRoqN8qXQh3xvDlDtzDOQONjeG8yHAX5oOZUiP3WMc7QB9bGepBeAKU
         f7fPbqo9uWg0KF1UCSWc1oE7ci0jcOREDnQIkI/SxOfMjj5hm6XVmI8oXabTfEr5TA
         Ld5t4HUCAym3a2IagzmBjEP/xdlklPJBt8VWMdpCr6fMBkbJYffG1NiEIKc9KAZUrn
         /ZHtJ+u5NczlaNLGN3UleXCuwVnzqTyAXsXx6zFQTOPYzBIxgZiZ/cPoggRO1yJtrc
         dtNaALfM5G47R5TslWSfs2Sdk605zsvl9Pf5pqxnDFUCUrTus8TYAcN/MJNrIzhpxF
         xTV7/+Mr2N4Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 108/108] cifs: prevent NULL deref in cifs_compose_mount_options()
Date:   Wed, 14 Jul 2021 15:38:00 -0400
Message-Id: <20210714193800.52097-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index c87c37cf2914..4e3c15cd403a 100644
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

