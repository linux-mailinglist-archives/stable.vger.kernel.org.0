Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380385B711C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiIMOfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbiIMOeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:34:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81441D0DB;
        Tue, 13 Sep 2022 07:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F32D614D2;
        Tue, 13 Sep 2022 14:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46925C433D6;
        Tue, 13 Sep 2022 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078692;
        bh=Rirw/bFiPmGRnPlDblleTREFXFCNfTozAJlpW8/c6j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHonDZxhyi4FyXz9pttz8JUA8QzM8f7dipmvAmHfMUb+Bn7lu3SIesbjwrVB4f5Qv
         Sg4dzTmYwtStjjhj9S0aiTq/wPwXNml7zNK26RuXn3GNMMX9Y/4MMzi27RiRqDJxKM
         w2uz5Ldi5QD20R6QIZd6Te1YXyIH3+2WPiVogm1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/121] cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
Date:   Tue, 13 Sep 2022 16:03:57 +0200
Message-Id: <20220913140359.341799961@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 671c11f0619e5ccb380bcf0f062f69ba95fc974a ]

cgroup_update_dfl_csses() write-lock the threadgroup_rwsem as updating the
csses can trigger process migrations. However, if the subtree doesn't
contain any tasks, there aren't gonna be any cgroup migrations. This
condition can be trivially detected by testing whether
mgctx.preloaded_src_csets is empty. Elide write-locking threadgroup_rwsem if
the subtree is empty.

After this optimization, the usage pattern of creating a cgroup, enabling
the necessary controllers, and then seeding it with CLONE_INTO_CGROUP and
then removing the cgroup after it becomes empty doesn't need to write-lock
threadgroup_rwsem at all.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 416dd7db3fb2c..baebd1c7667b7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2949,12 +2949,11 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 	struct cgroup *dsct;
 	struct css_set *src_cset;
+	bool has_tasks;
 	int ret;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
-
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_irq(&css_set_lock);
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
@@ -2965,6 +2964,16 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	}
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * We need to write-lock threadgroup_rwsem while migrating tasks.
+	 * However, if there are no source csets for @cgrp, changing its
+	 * controllers isn't gonna produce any task migrations and the
+	 * write-locking can be skipped safely.
+	 */
+	has_tasks = !list_empty(&mgctx.preloaded_src_csets);
+	if (has_tasks)
+		percpu_down_write(&cgroup_threadgroup_rwsem);
+
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (ret)
@@ -2984,7 +2993,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	if (has_tasks)
+		percpu_up_write(&cgroup_threadgroup_rwsem);
 	return ret;
 }
 
-- 
2.35.1



