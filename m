Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1094439602C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhEaOXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232141AbhEaOR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4976141A;
        Mon, 31 May 2021 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468639;
        bh=gebbVy1Mm2m3Q7MPVEAdTF1Wrgd19Rx2KcBF/R7+kZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrDPgQvxlhzBtkMp1qprYJfC550hNY9QT4EFA0eTWyP71LzB6Fm11q122zvjBbVfK
         uLUr6LJGayjd2vbJ1JbbWDb+3H1xsiIBERhmcWbaUUcHrcQL6CXkm+5honvfuSdWsr
         DfFsW7EcOYjZJ8WZENiMW5lSCGVGvHttYO7BK51s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 068/177] NFS: Fix an Oopsable condition in __nfs_pageio_add_request()
Date:   Mon, 31 May 2021 15:13:45 +0200
Message-Id: <20210531130650.251963044@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 56517ab958b7c11030e626250c00b9b1a24b41eb upstream.

Ensure that nfs_pageio_error_cleanup() resets the mirror array contents,
so that the structure reflects the fact that it is now empty.
Also change the test in nfs_pageio_do_add_request() to be more robust by
checking whether or not the list is empty rather than relying on the
value of pg_count.

Fixes: a7d42ddb3099 ("nfs: add mirroring support to pgio layer")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -986,15 +986,16 @@ static int nfs_pageio_do_add_request(str
 
 	struct nfs_page *prev = NULL;
 
-	if (mirror->pg_count != 0) {
-		prev = nfs_list_entry(mirror->pg_list.prev);
-	} else {
+	if (list_empty(&mirror->pg_list)) {
 		if (desc->pg_ops->pg_init)
 			desc->pg_ops->pg_init(desc, req);
 		if (desc->pg_error < 0)
 			return 0;
 		mirror->pg_base = req->wb_pgbase;
-	}
+		mirror->pg_count = 0;
+		mirror->pg_recoalesce = 0;
+	} else
+		prev = nfs_list_entry(mirror->pg_list.prev);
 
 	if (desc->pg_maxretrans && req->wb_nio > desc->pg_maxretrans) {
 		if (NFS_SERVER(desc->pg_inode)->flags & NFS_MOUNT_SOFTERR)


