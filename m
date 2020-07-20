Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C30226892
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733182AbgGTQHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733179AbgGTQHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 302082065E;
        Mon, 20 Jul 2020 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261253;
        bh=tTBF2HeIITZFm7ylSRgKqYf6WmG7CtAMkZcFCOY7XHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4YkZ79F3heiNhM382vlj8tfT0hId3bPHjMyC1sLKFhk0o0KG2M7cAJrdDY8jmSGh
         LNzn2FhFLyCYD/LWj5TTc0ge8+zBI44VrcjB59K3ugAL/roFSp+6DLaxZaGQIysSGt
         aj8BH9W4iGn1dBLrTrLgoGUPiImH9QwAf1Af9oD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 050/244] gfs2: eliminate GIF_ORDERED in favor of list_empty
Date:   Mon, 20 Jul 2020 17:35:21 +0200
Message-Id: <20200720152828.243482080@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 7542486b89b2e321ffe0de82163b425d6a38bc72 ]

In several places, we used the GIF_ORDERED inode flag to determine
if an inode was on the ordered writes list. However, since we always
held the sd_ordered_lock spin_lock during the manipulation, we can
just as easily check list_empty(&ip->i_ordered) instead.
This allows us to keep more than one ordered writes list to make
journal writing improvements.

This patch eliminates GIF_ORDERED in favor of checking list_empty.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/incore.h |  1 -
 fs/gfs2/log.c    | 15 +++++++++------
 fs/gfs2/log.h    |  4 ++--
 fs/gfs2/main.c   |  1 +
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 84a824293a78b..013c029dd16b8 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -395,7 +395,6 @@ enum {
 	GIF_QD_LOCKED		= 1,
 	GIF_ALLOC_FAILED	= 2,
 	GIF_SW_PAGED		= 3,
-	GIF_ORDERED		= 4,
 	GIF_FREE_VFS_INODE      = 5,
 	GIF_GLOP_PENDING	= 6,
 };
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 04882712cd661..62a73bd6575cb 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -613,6 +613,12 @@ static int ip_cmp(void *priv, struct list_head *a, struct list_head *b)
 	return 0;
 }
 
+static void __ordered_del_inode(struct gfs2_inode *ip)
+{
+	if (!list_empty(&ip->i_ordered))
+		list_del_init(&ip->i_ordered);
+}
+
 static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip;
@@ -623,8 +629,7 @@ static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 	while (!list_empty(&sdp->sd_log_ordered)) {
 		ip = list_first_entry(&sdp->sd_log_ordered, struct gfs2_inode, i_ordered);
 		if (ip->i_inode.i_mapping->nrpages == 0) {
-			test_and_clear_bit(GIF_ORDERED, &ip->i_flags);
-			list_del(&ip->i_ordered);
+			__ordered_del_inode(ip);
 			continue;
 		}
 		list_move(&ip->i_ordered, &written);
@@ -643,8 +648,7 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
 	spin_lock(&sdp->sd_ordered_lock);
 	while (!list_empty(&sdp->sd_log_ordered)) {
 		ip = list_first_entry(&sdp->sd_log_ordered, struct gfs2_inode, i_ordered);
-		list_del(&ip->i_ordered);
-		WARN_ON(!test_and_clear_bit(GIF_ORDERED, &ip->i_flags));
+		__ordered_del_inode(ip);
 		if (ip->i_inode.i_mapping->nrpages == 0)
 			continue;
 		spin_unlock(&sdp->sd_ordered_lock);
@@ -659,8 +663,7 @@ void gfs2_ordered_del_inode(struct gfs2_inode *ip)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 
 	spin_lock(&sdp->sd_ordered_lock);
-	if (test_and_clear_bit(GIF_ORDERED, &ip->i_flags))
-		list_del(&ip->i_ordered);
+	__ordered_del_inode(ip);
 	spin_unlock(&sdp->sd_ordered_lock);
 }
 
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index c1cd6ae176597..8965c751a3039 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -53,9 +53,9 @@ static inline void gfs2_ordered_add_inode(struct gfs2_inode *ip)
 	if (gfs2_is_jdata(ip) || !gfs2_is_ordered(sdp))
 		return;
 
-	if (!test_bit(GIF_ORDERED, &ip->i_flags)) {
+	if (list_empty(&ip->i_ordered)) {
 		spin_lock(&sdp->sd_ordered_lock);
-		if (!test_and_set_bit(GIF_ORDERED, &ip->i_flags))
+		if (list_empty(&ip->i_ordered))
 			list_add(&ip->i_ordered, &sdp->sd_log_ordered);
 		spin_unlock(&sdp->sd_ordered_lock);
 	}
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index a1a295b739fb8..4f2edb777a721 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -39,6 +39,7 @@ static void gfs2_init_inode_once(void *foo)
 	atomic_set(&ip->i_sizehint, 0);
 	init_rwsem(&ip->i_rw_mutex);
 	INIT_LIST_HEAD(&ip->i_trunc_list);
+	INIT_LIST_HEAD(&ip->i_ordered);
 	ip->i_qadata = NULL;
 	gfs2_holder_mark_uninitialized(&ip->i_rgd_gh);
 	memset(&ip->i_res, 0, sizeof(ip->i_res));
-- 
2.25.1



