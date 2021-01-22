Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E9300633
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbhAVOyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbhAVOXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE3F523A75;
        Fri, 22 Jan 2021 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325118;
        bh=b6V83M4iMgaTz4tyvtTlXfifc0FFYNtDUYjw40JPDko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQJn1tBSy4jhkc9fPp4/2WyZztWTxKX9Dm3luWnPTNiUAydfjz1UScKnpwTe2Pm8z
         2EmwQGsHS+3G5hdC/N9Np1sGvY+P2YQxpqAZ6InCJ9rUCZ6GMN011kBEle0IGaEoQd
         KzcVUFPtMMeXXs+ImDtx9ck6SO7lmVJuTbQqkXGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Youjipeng <wangzhibei1999@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 07/43] nfsd4: readdirplus shouldnt return parent of export
Date:   Fri, 22 Jan 2021 15:12:23 +0100
Message-Id: <20210122135735.953038471@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
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
@@ -863,9 +863,14 @@ compose_entry_fh(struct nfsd3_readdirres
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


