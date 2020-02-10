Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33526157592
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgBJMmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbgBJMmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:07 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11382085B;
        Mon, 10 Feb 2020 12:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338527;
        bh=D6Xx5M7Rs1pV0xGzj0es8MZ19wcAYT/gPZPjlbzvoug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/B1Z0PZc8MugixW6DyuWZMw3cByC1bXIfN+a9j2Dk+og9Xb9REQfCb+avQEkC6ta
         r9JL5ovAk1loy5o6PalBGzUFjcfJBcAAMjz1XgPZ3Mlaqt7IfQ50aoiwvefD3oHzO4
         dNoCvWKfsyEBtIBvzRwEMXWIOg8Ys9gRbjwKeSf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.5 348/367] cifs: fix mode bits from dir listing when mounted with modefromsid
Date:   Mon, 10 Feb 2020 04:34:21 -0800
Message-Id: <20200210122454.675867923@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit e3e056c35108661e418c803adfc054bf683426e7 upstream.

When mounting with -o modefromsid, the mode bits are stored in an
ACE. Directory enumeration (e.g. ls -l /mnt) triggers an SMB Query Dir
which does not include ACEs in its response. The mode bits in this
case are silently set to a default value of 755 instead.

This patch marks the dentry created during the directory enumeration
as needing re-evaluation (i.e. additional Query Info with ACEs) so
that the mode bits can be properly extracted.

Quick repro:

$ mount.cifs //win19.test/data /mnt -o ...,modefromsid
$ touch /mnt/foo && chmod 751 /mnt/foo
$ stat /mnt/foo
  # reports 751 (OK)
$ sleep 2
  # dentry older than 1s by default get invalidated
$ ls -l /mnt
  # since dentry invalid, ls does a Query Dir
  # and reports foo as 755 (WRONG)

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/readdir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -196,7 +196,8 @@ cifs_fill_common_info(struct cifs_fattr
 	 * may look wrong since the inodes may not have timed out by the time
 	 * "ls" does a stat() call on them.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&


