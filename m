Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05FB1AC345
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898121AbgDPNke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898122AbgDPNkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:40:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8299214D8;
        Thu, 16 Apr 2020 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044432;
        bh=RsUqFbevd0j8uU6mYkKun4A8c/pDL5nw1j9+lNF+rHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGr8nXWilphGU102yFpLuurTJeQDyINsfhohjYGB1H3U7E7O3HgTVAhLsSs03pSe5
         Yxp0UQLDkF+cpkmPG6KomhqD3tVLEriUjRmccPKoo7P3VMI5h5FKXOMcAncDXBmVQv
         1ca/1R+2TnzaFfUDXMDyYTPyHkcTFLxYBeJ1ynuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.5 216/257] nfsd: fsnotify on rmdir under nfsd/clients/
Date:   Thu, 16 Apr 2020 15:24:27 +0200
Message-Id: <20200416131353.008008560@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 69afd267982e733a555fede4e85fe30329ed0588 upstream.

Userspace should be able to monitor nfsd/clients/ to see when clients
come and go, but we're failing to send fsnotify events.

Cc: stable@kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1333,6 +1333,7 @@ void nfsd_client_rmdir(struct dentry *de
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
 	WARN_ON_ONCE(ret);
+	fsnotify_rmdir(dir, dentry);
 	d_delete(dentry);
 	inode_unlock(dir);
 }


