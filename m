Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE32300D07
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbhAVT5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbhAVOKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:10:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF6A23A63;
        Fri, 22 Jan 2021 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324565;
        bh=5yugw90Ko4aivb8XQkrgzCxwHwauJny+K5bx2oqNd30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXV+yoMx3wgPUC6uIvBls5erGjhUoUjE9BiNbEuIVd0WGH8x1JbkpSWV+Q4NFnCGR
         FmBmRuWZ3QY8tPQITGSmQFdglFvCffy6EBJQiIkRBF2dqiZy9hWB4RKMyRw2ZwMwoK
         QRFqOYVSWB69J2AuNwsEINIi+3uulOLgr1qx5fAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Youjipeng <wangzhibei1999@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.4 22/31] nfsd4: readdirplus shouldnt return parent of export
Date:   Fri, 22 Jan 2021 15:08:36 +0100
Message-Id: <20210122135732.757781440@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 51b2ee7d006a736a9126e8111d1f24e4fd0afaa6 upstream.

If you export a subdirectory of a filesystem, a READDIRPLUS on the root
of that export will return the filehandle of the parent with the ".."
entry.

The filehandle is optional, so let's just not return the filehandle for
".." if we're at the root of an export.

Note that once the client learns one filehandle outside of the export,
they can trivially access the rest of the export using further lookups.

However, it is also not very difficult to guess filehandles outside of
the export.  So exporting a subdirectory of a filesystem should
considered equivalent to providing access to the entire filesystem.  To
avoid confusion, we recommend only exporting entire filesystems.

Reported-by: Youjipeng <wangzhibei1999@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs3xdr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -821,9 +821,14 @@ compose_entry_fh(struct nfsd3_readdirres
 	if (isdotent(name, namlen)) {
 		if (namlen == 2) {
 			dchild = dget_parent(dparent);
-			/* filesystem root - cannot return filehandle for ".." */
+			/*
+			 * Don't return filehandle for ".." if we're at
+			 * the filesystem or export root:
+			 */
 			if (dchild == dparent)
 				goto out;
+			if (dparent == exp->ex_path.dentry)
+				goto out;
 		} else
 			dchild = dget(dparent);
 	} else


