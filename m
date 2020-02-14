Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6176115E4B9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgBNQhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405758AbgBNQX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D9424787;
        Fri, 14 Feb 2020 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697437;
        bh=wdqrxYPyjy0I0lxc+ygjYYNq7crfOp6Bd9hVxhogQZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zx6olH03uxUb2VpWuUPa1+aPNKD+fLB7ndU9WnDrn7KJ7tV2oz5+MMNUqo8pI/Y5T
         x1iI4D53PD/lTFCQrtdrfzHmR9FdY9cbaZC7PxWrkre1Oc12kegT0SmS2SksZJtLbV
         tYptqHtYhdo/+iY9fnfUcLYfVLa+EPE+VsR6xSgE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.9 123/141] cifs: fix NULL dereference in match_prepath
Date:   Fri, 14 Feb 2020 11:21:03 -0500
Message-Id: <20200214162122.19794-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit fe1292686333d1dadaf84091f585ee903b9ddb84 ]

RHBZ: 1760879

Fix an oops in match_prepath() by making sure that the prepath string is not
NULL before we pass it into strcmp().

This is similar to other checks we make for example in cifs_root_iget()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 751bdde6515d5..961fcb40183a4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2927,8 +2927,10 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
-	bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
+	bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		old->prepath;
+	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		new->prepath;
 
 	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
 		return 1;
-- 
2.20.1

