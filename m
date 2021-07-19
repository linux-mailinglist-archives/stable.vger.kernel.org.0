Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631573CD960
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbhGSO24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243828AbhGSO1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:27:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FF3E61205;
        Mon, 19 Jul 2021 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707262;
        bh=8c3zfs0CUf9J7nuikvF4h59MDqBvdx/LyYZBfFifLmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnGCJIpR6lLjCikfrp5Y4jPYaF4xJh6DReXO9JA6zzONiYLpkVuoeYcIi/xa+imR1
         dqYpIG87+DMbuE6+g+ogx4rOdrI2CFXg6zNH7mzkBakAlIgSdNspQdxFZbT6k5XHuL
         PUu5q4B2tfEojorIpr/LnaY54l7ZZSFQtzuEL3XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 090/245] writeback: fix obtain a reference to a freeing memcg css
Date:   Mon, 19 Jul 2021 16:50:32 +0200
Message-Id: <20210719144943.322270676@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 8b0ed8443ae6458786580d36b7d5f8125535c5d4 ]

The caller of wb_get_create() should pin the memcg, because
wb_get_create() relies on this guarantee. The rcu read lock
only can guarantee that the memcg css returned by css_from_id()
cannot be released, but the reference of the memcg can be zero.

  rcu_read_lock()
  memcg_css = css_from_id()
  wb_get_create(memcg_css)
      cgwb_create(memcg_css)
          // css_get can change the ref counter from 0 back to 1
          css_get(memcg_css)
  rcu_read_unlock()

Fix it by holding a reference to the css before calling
wb_get_create(). This is not a problem I encountered in the
real world. Just the result of a code review.

Fixes: 682aa8e1a6a1 ("writeback: implement unlocked_inode_to_wb transaction and use it for stat updates")
Link: https://lore.kernel.org/r/20210402091145.80635-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 008710314240..e7815bebaeb8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -512,9 +512,14 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	/* find and pin the new wb */
 	rcu_read_lock();
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
-	if (memcg_css)
-		isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+	if (memcg_css && !css_tryget(memcg_css))
+		memcg_css = NULL;
 	rcu_read_unlock();
+	if (!memcg_css)
+		goto out_free;
+
+	isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+	css_put(memcg_css);
 	if (!isw->new_wb)
 		goto out_free;
 
-- 
2.30.2



