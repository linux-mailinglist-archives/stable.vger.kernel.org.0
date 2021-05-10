Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB287378702
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhEJLMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235812AbhEJLGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F96161574;
        Mon, 10 May 2021 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644189;
        bh=NtnVhsCrJlwc9ibb08GT/mVphPR7+AFmpmECtR6zvYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di59WkPfNAu3CjoFpV6pz4A0tsNcOFvBKerGLbwNsBm2GnMyR/8ruubPWZFTFQYbg
         VLi6lSZjoytbCg5FQdaz5WuYKqCGcFWB1Jn73wO+uWPJn8Q5fowX+1qOVz+JK8nHNy
         B3nkN1nmJm4Idvyybi/a16AJS6AkDA1tJihAlLJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeongseok Kim <hyeongseok@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.11 289/342] exfat: fix erroneous discard when clear cluster bit
Date:   Mon, 10 May 2021 12:21:19 +0200
Message-Id: <20210510102019.663806438@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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


