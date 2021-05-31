Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8968395B44
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhEaNSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhEaNSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125EC61377;
        Mon, 31 May 2021 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467012;
        bh=YuuDDbunUMPyy+mqVzckjE5gDPn/e+4GqX6B5PBFjTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdVhXS9RQcKTn2DnmMAmXkX4wr1H46oiOQfiJcTVnx13ejNUDDLQg77qjp8UoV/wG
         ce7RJr9/Ivd8N1PQRKf5mzYpykTEfBuxZwI/aLLxGwI8zDiUuA1xToqYzNVNhd5IT5
         po328+hiF7dpwy2MwftOPxmoirpermUxamWZZL/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.4 24/54] NFS: Dont corrupt the value of pg_bytes_written in nfs_do_recoalesce()
Date:   Mon, 31 May 2021 15:13:50 +0200
Message-Id: <20210531130635.850766475@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
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
@@ -993,17 +993,16 @@ static void nfs_pageio_doio(struct nfs_p
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
 
@@ -1089,7 +1088,6 @@ static int nfs_do_recoalesce(struct nfs_
 
 	do {
 		list_splice_init(&mirror->pg_list, &head);
-		mirror->pg_bytes_written -= mirror->pg_count;
 		mirror->pg_count = 0;
 		mirror->pg_base = 0;
 		mirror->pg_recoalesce = 0;


