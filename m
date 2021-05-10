Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A612D37830E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhEJKlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232064AbhEJKh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7214D61944;
        Mon, 10 May 2021 10:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642594;
        bh=6aDdcVRD5XDeRzPu5cDpy+CeTozswdh322xviITHbFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cONWBwIpngOjyZ3aml8NRQsaFpKqlIKpApeWZmM7777pdO4O2oAc4cMGuyquS4b9G
         54KIgTtFL/jj8uN0ERYyqIohbNsVQxRfPsvsYIEOPo0j0CVJV+/QZLQ5vbm6rFCxto
         kUrZVNZgUjzYIl1HgS5UYoylDdXcTCw0HNqby8CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Andrey Zhizhikin <andrey.z@gmail.com>
Subject: [PATCH 5.4 157/184] security: commoncap: fix -Wstringop-overread warning
Date:   Mon, 10 May 2021 12:20:51 +0200
Message-Id: <20210510101955.260466315@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 82e5d8cc768b0c7b03c551a9ab1f8f3f68d5f83f upstream.

gcc-11 introdces a harmless warning for cap_inode_getsecurity:

security/commoncap.c: In function ‘cap_inode_getsecurity’:
security/commoncap.c:440:33: error: ‘memcpy’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
  440 |                                 memcpy(&nscap->data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem here is that tmpbuf is initialized to NULL, so gcc assumes
it is not accessible unless it gets set by vfs_getxattr_alloc().  This is
a legitimate warning as far as I can tell, but the code is correct since
it correctly handles the error when that function fails.

Add a separate NULL check to tell gcc about it as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: James Morris <jamorris@linux.microsoft.com>
Cc: Andrey Zhizhikin <andrey.z@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -391,7 +391,7 @@ int cap_inode_getsecurity(struct inode *
 				 &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0)
+	if (ret < 0 || !tmpbuf)
 		return ret;
 
 	fs_ns = inode->i_sb->s_user_ns;


