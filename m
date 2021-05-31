Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C139602B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhEaOXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhEaOSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58BE961494;
        Mon, 31 May 2021 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468641;
        bh=UXce5rBV72IFJ3sK+JaRW192E2yXntiPK9VC/77MEWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o22TjB/7dujTseFYRv3W1vfLPR3DrTD+lZui4K53m2VAoiZYlda0wpf2ySUCh66v/
         Ls/NDcN/67hZw3smhY9D4RAANoVEwPV3ejNhBtbYbMA7aC5tWC/YiqDi8pjhqjHg/5
         w+nnE1H1IqvX7MCm5f2h6ukXgldXCEQak0ZTBScg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 069/177] NFS: Dont corrupt the value of pg_bytes_written in nfs_do_recoalesce()
Date:   Mon, 31 May 2021 15:13:46 +0200
Message-Id: <20210531130650.288542632@linuxfoundation.org>
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

commit 0d0ea309357dea0d85a82815f02157eb7fcda39f upstream.

The value of mirror->pg_bytes_written should only be updated after a
successful attempt to flush out the requests on the list.

Fixes: a7d42ddb3099 ("nfs: add mirroring support to pgio layer")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1019,17 +1019,16 @@ static void nfs_pageio_doio(struct nfs_p
 {
 	struct nfs_pgio_mirror *mirror = nfs_pgio_current_mirror(desc);
 
-
 	if (!list_empty(&mirror->pg_list)) {
 		int error = desc->pg_ops->pg_doio(desc);
 		if (error < 0)
 			desc->pg_error = error;
-		else
+		if (list_empty(&mirror->pg_list)) {
 			mirror->pg_bytes_written += mirror->pg_count;
-	}
-	if (list_empty(&mirror->pg_list)) {
-		mirror->pg_count = 0;
-		mirror->pg_base = 0;
+			mirror->pg_count = 0;
+			mirror->pg_base = 0;
+			mirror->pg_recoalesce = 0;
+		}
 	}
 }
 
@@ -1123,7 +1122,6 @@ static int nfs_do_recoalesce(struct nfs_
 
 	do {
 		list_splice_init(&mirror->pg_list, &head);
-		mirror->pg_bytes_written -= mirror->pg_count;
 		mirror->pg_count = 0;
 		mirror->pg_base = 0;
 		mirror->pg_recoalesce = 0;


