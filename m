Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F623788FD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhEJLZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233601AbhEJLOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF49161424;
        Mon, 10 May 2021 11:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645041;
        bh=Rm//JxqJELkUL8BRgI54ulf7oVv8a4orV4V0NwUxU2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rvbd9EDQcJvCA3LstLbuNbssNwdOIkBL26Pk85IjUY0CyVoLE9sNnkVquZfkAGyHt
         m1PftWr2tebvnjuCgvGG3pljCGvX0Hq7/iX6xJUezV5DyU26ZNZKT9HToKcbPTkRVK
         tq0XRD7Wi2yvHwHVFnKkVS5tr/k8saeJn2SmAvhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Andrey Zhizhikin <andrey.z@gmail.com>
Subject: [PATCH 5.12 327/384] security: commoncap: fix -Wstringop-overread warning
Date:   Mon, 10 May 2021 12:21:56 +0200
Message-Id: <20210510102025.573829288@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
@@ -400,7 +400,7 @@ int cap_inode_getsecurity(struct user_na
 				      &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0)
+	if (ret < 0 || !tmpbuf)
 		return ret;
 
 	fs_ns = inode->i_sb->s_user_ns;


