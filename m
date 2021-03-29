Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E29934C7DA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhC2ISW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233273AbhC2IRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E81F26193A;
        Mon, 29 Mar 2021 08:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005824;
        bh=kGD9Zz7cfSBPI5bkMvB6A+uKjgg/mNyjnW8fvUtKCUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTu54aZd8xqYpuUyo0mFb3ggsIGAyUZq7EkXdeTa4YjpibHzpZRt9s+XDvudPSFfJ
         T0thg2mS05P7jbTlKFBcF65jrZGvBpLl7zyd85io8QSn1yYmNx9CFQgnpR6azRvuP+
         YprhOhOznJVzWHFJlfO2XotQbYKrxxtm1YrjGXWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Price <anprice@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/221] gfs2: fix use-after-free in trans_drain
Date:   Mon, 29 Mar 2021 09:55:50 +0200
Message-Id: <20210329075629.827560716@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 1a5a2cfd34c17db73c53ef127272c8c1ae220485 ]

This patch adds code to function trans_drain to remove drained
bd elements from the ail lists, if queued, before freeing the bd.
If we don't remove the bd from the ail, function ail_drain will
try to reference the bd after it has been freed by trans_drain.

Thanks to Andy Price for his analysis of the problem.

Reported-by: Andy Price <anprice@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c   | 4 ++++
 fs/gfs2/trans.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 2e9314091c81..1955dea999f7 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -935,12 +935,16 @@ static void trans_drain(struct gfs2_trans *tr)
 	while (!list_empty(head)) {
 		bd = list_first_entry(head, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
+		if (!list_empty(&bd->bd_ail_st_list))
+			gfs2_remove_from_ail(bd);
 		kmem_cache_free(gfs2_bufdata_cachep, bd);
 	}
 	head = &tr->tr_databuf;
 	while (!list_empty(head)) {
 		bd = list_first_entry(head, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
+		if (!list_empty(&bd->bd_ail_st_list))
+			gfs2_remove_from_ail(bd);
 		kmem_cache_free(gfs2_bufdata_cachep, bd);
 	}
 }
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 6d4bf7ea7b3b..7f850ff6a05d 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -134,6 +134,8 @@ static struct gfs2_bufdata *gfs2_alloc_bufdata(struct gfs2_glock *gl,
 	bd->bd_bh = bh;
 	bd->bd_gl = gl;
 	INIT_LIST_HEAD(&bd->bd_list);
+	INIT_LIST_HEAD(&bd->bd_ail_st_list);
+	INIT_LIST_HEAD(&bd->bd_ail_gl_list);
 	bh->b_private = bd;
 	return bd;
 }
-- 
2.30.1



