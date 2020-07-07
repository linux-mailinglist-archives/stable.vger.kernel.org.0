Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D46217062
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgGGPQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgGGPQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:16:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399C620663;
        Tue,  7 Jul 2020 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135009;
        bh=mZ+94ue3jrh62rM9/yhydqQai/V6Wz+Chq6dMesfcOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e75w6Hl2tX4ZPpslrT6QnK9/SXmYoCqg6fBL7uVA1tMe/Zy8br0nchVFW+aEU+YNl
         tV+PALhnd2bUb4Oq+cFuq5O58Irrh5jtgYjOAonjhllH7UZXSOC2JqCO7SBFj9V9Ji
         aB6C1lhLKQeftAuAHyy4qDOVTkeJCk1ACQYkC01U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elliott Mitchell <ehem+debian@m5p.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.14 19/27] nfsd: apply umask on fs without ACL support
Date:   Tue,  7 Jul 2020 17:15:46 +0200
Message-Id: <20200707145749.870230772@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 22cf8419f1319ff87ec759d0ebdff4cbafaee832 upstream.

The server is failing to apply the umask when creating new objects on
filesystems without ACL support.

To reproduce this, you need to use NFSv4.2 and a client and server
recent enough to support umask, and you need to export a filesystem that
lacks ACL support (for example, ext4 with the "noacl" mount option).

Filesystems with ACL support are expected to take care of the umask
themselves (usually by calling posix_acl_create).

For filesystems without ACL support, this is up to the caller of
vfs_create(), vfs_mknod(), or vfs_mkdir().

Reported-by: Elliott Mitchell <ehem+debian@m5p.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Fixes: 47057abde515 ("nfsd: add support for the umask attribute")
Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/vfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1202,6 +1202,9 @@ nfsd_create_locked(struct svc_rqst *rqst
 		iap->ia_mode = 0;
 	iap->ia_mode = (iap->ia_mode & S_IALLUGO) | type;
 
+	if (!IS_POSIXACL(dirp))
+		iap->ia_mode &= ~current_umask();
+
 	err = 0;
 	host_err = 0;
 	switch (type) {
@@ -1413,6 +1416,9 @@ do_nfsd_create(struct svc_rqst *rqstp, s
 		goto out;
 	}
 
+	if (!IS_POSIXACL(dirp))
+		iap->ia_mode &= ~current_umask();
+
 	host_err = vfs_create(dirp, dchild, iap->ia_mode, true);
 	if (host_err < 0) {
 		fh_drop_write(fhp);


