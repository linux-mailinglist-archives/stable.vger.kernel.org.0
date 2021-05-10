Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3F1378508
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhEJK6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233005AbhEJKxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80CB861285;
        Mon, 10 May 2021 10:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643283;
        bh=NtnVhsCrJlwc9ibb08GT/mVphPR7+AFmpmECtR6zvYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3OgHO2ASxZmcb9EqLZoeQZwAVcR9R2f85e4A7nFqb6sWyOA9LEvJc1fVb2lUAJZ0
         fveeD5PnfrfKgsACDijB8fXTQyJ4jIZH+P3NeKA1BoXkWwnGVkQNpS7dXp6Bv5nw3+
         fV1BQ5yO8AAK1Q19jHw1rYGj3jWuM3rWOkKLaIkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeongseok Kim <hyeongseok@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.10 252/299] exfat: fix erroneous discard when clear cluster bit
Date:   Mon, 10 May 2021 12:20:49 +0200
Message-Id: <20210510102013.278838861@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeongseok Kim <hyeongseok@gmail.com>

commit 77edfc6e51055b61cae2f54c8e6c3bb7c762e4fe upstream.

If mounted with discard option, exFAT issues discard command when clear
cluster bit to remove file. But the input parameter of cluster-to-sector
calculation is abnormally added by reserved cluster size which is 2,
leading to discard unrelated sectors included in target+2 cluster.
With fixing this, remove the wrong comments in set/clear/find bitmap
functions.

Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
Acked-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/balloc.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -141,10 +141,6 @@ void exfat_free_bitmap(struct exfat_sb_i
 	kfree(sbi->vol_amap);
 }
 
-/*
- * If the value of "clu" is 0, it means cluster 2 which is the first cluster of
- * the cluster heap.
- */
 int exfat_set_bitmap(struct inode *inode, unsigned int clu)
 {
 	int i, b;
@@ -162,10 +158,6 @@ int exfat_set_bitmap(struct inode *inode
 	return 0;
 }
 
-/*
- * If the value of "clu" is 0, it means cluster 2 which is the first cluster of
- * the cluster heap.
- */
 void exfat_clear_bitmap(struct inode *inode, unsigned int clu)
 {
 	int i, b;
@@ -186,8 +178,7 @@ void exfat_clear_bitmap(struct inode *in
 		int ret_discard;
 
 		ret_discard = sb_issue_discard(sb,
-			exfat_cluster_to_sector(sbi, clu +
-						EXFAT_RESERVED_CLUSTERS),
+			exfat_cluster_to_sector(sbi, clu),
 			(1 << sbi->sect_per_clus_bits), GFP_NOFS, 0);
 
 		if (ret_discard == -EOPNOTSUPP) {


