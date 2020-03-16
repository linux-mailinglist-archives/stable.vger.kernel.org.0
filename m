Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271551862F9
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgCPCeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbgCPCeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F66206E9;
        Mon, 16 Mar 2020 02:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326064;
        bh=X2U8BZK1mRjV0hmRrAocA+0FcUAr5GGTKyHMMuN4tbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtVwOheDgvUvC+N9WPF5dOtk0bWPA3qURdR43A5XKjvuG6YnDaKXM7wdNmNED6QPp
         Cb4ztAQ953t9S4j7nN+DD/2kVn4XaI+aq18wihbm2MLsUwtVYz8jC4xrgknGKkLmNj
         Np2e8cbhc6B4YQesp4N3JSfJCZmu7hepTDhjqp/U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 11/35] cifs: fix potential mismatch of UNC paths
Date:   Sun, 15 Mar 2020 22:33:47 -0400
Message-Id: <20200316023411.1263-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>

[ Upstream commit 154255233830e1e4dd0d99ac929a5dce588c0b81 ]

Ensure that full_path is an UNC path that contains '\\' as delimiter,
which is required by cifs_build_devname().

The build_path_from_dentry_optional_prefix() function may return a
path with '/' as delimiter when using SMB1 UNIX extensions, for
example.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 606f26d862dc1..cc3ada12848d9 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -324,6 +324,8 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	if (full_path == NULL)
 		goto cdda_exit;
 
+	convert_delimiter(full_path, '\\');
+
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	if (!cifs_sb_master_tlink(cifs_sb)) {
-- 
2.20.1

