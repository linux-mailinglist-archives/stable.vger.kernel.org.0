Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD23DA0CB
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439373AbfJPWPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbfJPVzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:22 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21C621A4C;
        Wed, 16 Oct 2019 21:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262921;
        bh=OyUlPjNeANd8E09a9byU60G74exCztVEBMkvSlrpIsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxmZmVReLay8DrQimj2CRzCRCyNmreOaSo/Y8bYjzCLxja1T9XJVrPrBd48tsfWki
         NVFP6za4MGp3HRnZrN1oCVDUH9OYTohSjt5M01k8zvbeQXjG55ur8j/z8EglwmKJAD
         Z38zRjIVSQe036NaLAeSGqsEkqn3exbEXZkGR5T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.9 81/92] CIFS: Force reval dentry if LOOKUP_REVAL flag is set
Date:   Wed, 16 Oct 2019 14:50:54 -0700
Message-Id: <20191016214847.125905050@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 0b3d0ef9840f7be202393ca9116b857f6f793715 upstream.

Mark inode for force revalidation if LOOKUP_REVAL flag is set.
This tells the client to actually send a QueryInfo request to
the server to obtain the latest metadata in case a directory
or a file were changed remotely. Only do that if the client
doesn't have a lease for the file to avoid unneeded round
trips to the server.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dir.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -830,10 +830,16 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
+	struct inode *inode;
+
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
 	if (d_really_is_positive(direntry)) {
+		inode = d_inode(direntry);
+		if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode)))
+			CIFS_I(inode)->time = 0; /* force reval */
+
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
 		else {
@@ -844,7 +850,7 @@ cifs_d_revalidate(struct dentry *direntr
 			 * attributes will have been updated by
 			 * cifs_revalidate_dentry().
 			 */
-			if (IS_AUTOMOUNT(d_inode(direntry)) &&
+			if (IS_AUTOMOUNT(inode) &&
 			   !(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
 				spin_lock(&direntry->d_lock);
 				direntry->d_flags |= DCACHE_NEED_AUTOMOUNT;


