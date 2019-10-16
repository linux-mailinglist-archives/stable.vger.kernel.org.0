Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D2DD9F44
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394915AbfJPVxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394907AbfJPVxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:52 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D75321925;
        Wed, 16 Oct 2019 21:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262832;
        bh=4PRr/WjD56JOyIXFFF9MLjhZ3i2W8e6bDo2POCKbhnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFaQ4otZ29Ke1Sz1eshYYyCH60veluCPPn7icPW7YvnqFKsfXUHzsXMVJIiaMQX0W
         w6KF1fTMGgxSeaelMYOPwsHIY3O2zZmJ/2fSysvK9VRR8TELVS1Y5FlY/72pnqhGzy
         znMXk90lGLnip1IsGqavdi5naUMM6s9UJjLDvQ0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 75/79] CIFS: Force revalidate inode when dentry is stale
Date:   Wed, 16 Oct 2019 14:50:50 -0700
Message-Id: <20191016214833.436582478@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

[ Upstream commit c82e5ac7fe3570a269c0929bf7899f62048e7dbc ]

Currently the client indicates that a dentry is stale when inode
numbers or type types between a local inode and a remote file
don't match. If this is the case attributes is not being copied
from remote to local, so, it is already known that the local copy
has stale metadata. That's why the inode needs to be marked for
revalidation in order to tell the VFS to lookup the dentry again
before openning a file. This prevents unexpected stale errors
to be returned to the user space when openning a file.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3d3c66fcb5ee6..0a219545940d9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -405,6 +405,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* if uniqueid is different, return error */
 		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
+			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
 		}
@@ -412,6 +413,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* if filetype is different, return error */
 		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
 		}
@@ -887,6 +889,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		/* if uniqueid is different, return error */
 		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
+			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgii_exit;
 		}
@@ -894,6 +897,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		/* if filetype is different, return error */
 		if (unlikely(((*inode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgii_exit;
 		}
-- 
2.20.1



