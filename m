Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1EE272FD8
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgIURAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbgIUQkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F9C7206DC;
        Mon, 21 Sep 2020 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706418;
        bh=bIgKcud45TJ9ezMaRGKDFfyhxWAd/pP56z2eojzJ0PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSQKzOBm9f9ow1+iDPeWfSkqFzr+6MP6tB8/BhQi2yu98/SBj+wWDeBmVOFgw/F/A
         1shgOEEXUY7gU4pyHH3izSUBwMdh9NdqQ92QKATZosW0Qhuq0iifLonH9+sWgnEhr7
         rPfClSoXrLMtN5DAoVH8ky5rYimq6akxIlmFZIg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.14 61/94] gfs2: initialize transaction tr_ailX_lists earlier
Date:   Mon, 21 Sep 2020 18:27:48 +0200
Message-Id: <20200921162038.353146842@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit cbcc89b630447ec7836aa2b9242d9bb1725f5a61 upstream.

Since transactions may be freed shortly after they're created, before
a log_flush occurs, we need to initialize their ail1 and ail2 lists
earlier. Before this patch, the ail1 list was initialized in gfs2_log_flush().
This moves the initialization to the point when the transaction is first
created.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/glops.c |    2 ++
 fs/gfs2/log.c   |    2 --
 fs/gfs2/trans.c |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -89,6 +89,8 @@ static void gfs2_ail_empty_gl(struct gfs
 	memset(&tr, 0, sizeof(tr));
 	INIT_LIST_HEAD(&tr.tr_buf);
 	INIT_LIST_HEAD(&tr.tr_databuf);
+	INIT_LIST_HEAD(&tr.tr_ail1_list);
+	INIT_LIST_HEAD(&tr.tr_ail2_list);
 	tr.tr_revokes = atomic_read(&gl->gl_ail_count);
 
 	if (!tr.tr_revokes)
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -734,8 +734,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
 	tr = sdp->sd_log_tr;
 	if (tr) {
 		sdp->sd_log_tr = NULL;
-		INIT_LIST_HEAD(&tr->tr_ail1_list);
-		INIT_LIST_HEAD(&tr->tr_ail2_list);
 		tr->tr_first = sdp->sd_log_flush_head;
 		if (unlikely (state == SFS_FROZEN))
 			gfs2_assert_withdraw(sdp, !tr->tr_num_buf_new && !tr->tr_num_databuf_new);
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -56,6 +56,8 @@ int gfs2_trans_begin(struct gfs2_sbd *sd
 						   sizeof(u64));
 	INIT_LIST_HEAD(&tr->tr_databuf);
 	INIT_LIST_HEAD(&tr->tr_buf);
+	INIT_LIST_HEAD(&tr->tr_ail1_list);
+	INIT_LIST_HEAD(&tr->tr_ail2_list);
 
 	sb_start_intwrite(sdp->sd_vfs);
 


