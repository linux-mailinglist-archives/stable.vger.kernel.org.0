Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192955B6F60
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbiIMOOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiIMONj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:13:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0D260507;
        Tue, 13 Sep 2022 07:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FDCCB80EFE;
        Tue, 13 Sep 2022 14:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B04C433D6;
        Tue, 13 Sep 2022 14:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078226;
        bh=Qm1cRi9UuEqonvEB4PtJ1JkaTSgK7S2x+P8sZWLr4MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8SCuwAtVwEChFpKotswbnR1jAtX8q1EIhanqWtkHsaefP8d9e5Lw1DIDn2ea2TNR
         Zeq8OuqexdSynrzaieCCh/9QC6RAL/ZEimrZ/QbPbqF+I0LYYLUxbWNFCmyg4sWLVR
         aEr4EypPkPL4pnb6yqwQT7t2IcxdC77anTSMhpts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 060/192] cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
Date:   Tue, 13 Sep 2022 16:02:46 +0200
Message-Id: <20220913140412.936612740@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index ce95aee05e8ae..ed4d6bf85e725 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2950,12 +2950,11 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
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
@@ -2966,6 +2965,16 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
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
@@ -2985,7 +2994,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
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



