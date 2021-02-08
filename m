Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A1D31372E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhBHPVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233513AbhBHPOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:14:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F1764ECD;
        Mon,  8 Feb 2021 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797044;
        bh=81GN6TDcD9uC2LArZDvYnnFtAGNAZm6PGEZzSFS7UDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3XUYA3fxwTaCdkGts2rpAHSol/ZLQylq0814krc4AWxnxRkQvOpabsxUOO2Wqlgb
         OBYknrFsVIDWETxPDJr16UCwIRoEvNEai8tpki19oo09vIOa5ZNFeRM3yuwBdz/tdD
         NJ4g0MLuZaJVt9JGlikTdKErolpZp8UTWw8XjhjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 39/65] cifs: report error instead of invalid when revalidating a dentry fails
Date:   Mon,  8 Feb 2021 16:01:11 +0100
Message-Id: <20210208145811.739646660@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit 21b200d091826a83aafc95d847139b2b0582f6d1 upstream.

Assuming
- //HOST/a is mounted on /mnt
- //HOST/b is mounted on /mnt/b

On a slow connection, running 'df' and killing it while it's
processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.

This triggers the following chain of events:
=> the dentry revalidation fail
=> dentry is put and released
=> superblock associated with the dentry is put
=> /mnt/b is unmounted

This patch makes cifs_d_revalidate() return the error instead of 0
(invalid) when cifs_revalidate_dentry() fails, except for ENOENT (file
deleted) and ESTALE (file recreated).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
Reviewed-by: Shyam Prasad N <nspmangalore@gmail.com>
CC: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/dir.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -738,6 +738,7 @@ static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
 	struct inode *inode;
+	int rc;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -747,8 +748,25 @@ cifs_d_revalidate(struct dentry *direntr
 		if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode)))
 			CIFS_I(inode)->time = 0; /* force reval */
 
-		if (cifs_revalidate_dentry(direntry))
-			return 0;
+		rc = cifs_revalidate_dentry(direntry);
+		if (rc) {
+			cifs_dbg(FYI, "cifs_revalidate_dentry failed with rc=%d", rc);
+			switch (rc) {
+			case -ENOENT:
+			case -ESTALE:
+				/*
+				 * Those errors mean the dentry is invalid
+				 * (file was deleted or recreated)
+				 */
+				return 0;
+			default:
+				/*
+				 * Otherwise some unexpected error happened
+				 * report it as-is to VFS layer
+				 */
+				return rc;
+			}
+		}
 		else {
 			/*
 			 * If the inode wasn't known to be a dfs entry when


