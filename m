Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0A395E4E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhEaN45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhEaNzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039696143D;
        Mon, 31 May 2021 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468038;
        bh=o8d0MYRmFJEVRBRcBij+FPj3htteyd3KcVJ/xoqEwg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQsFrGkNpxsa3FaGe6GNpBHWPomtIulpX++LIErQbXpgeV+Gmro8nTiubuWTECw/h
         qvIoRhcw5zVGSQAiPIuCh/Eivb5C8GygJJublf4KlQh8exmdm7CYSC0oFyG1MyyKSQ
         dwvB4jg76T+6DYT0Tv25NDCCY7wb+5uzeLodu5u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 094/252] NFS: Dont corrupt the value of pg_bytes_written in nfs_do_recoalesce()
Date:   Mon, 31 May 2021 15:12:39 +0200
Message-Id: <20210531130701.163993326@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -1128,17 +1128,16 @@ static void nfs_pageio_doio(struct nfs_p
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
 
@@ -1228,7 +1227,6 @@ static int nfs_do_recoalesce(struct nfs_
 
 	do {
 		list_splice_init(&mirror->pg_list, &head);
-		mirror->pg_bytes_written -= mirror->pg_count;
 		mirror->pg_count = 0;
 		mirror->pg_base = 0;
 		mirror->pg_recoalesce = 0;


