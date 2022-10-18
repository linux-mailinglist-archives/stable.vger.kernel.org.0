Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5947601E2E
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiJRAIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJRAH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDC986FAE;
        Mon, 17 Oct 2022 17:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BCDF61113;
        Tue, 18 Oct 2022 00:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45A5C433D7;
        Tue, 18 Oct 2022 00:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051664;
        bh=Lxnn2/R98fjTYGBdK4fN9VidlSv0u9M8Uk66lw7OpNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYIBRKTysluyQTCT9iP9QqHPC4YJRpU1iPpvY2VNUn5CwtyksFFEV8HJEncwh7Zxg
         pWZlGWSpRZ2Z15Hrh1pLDKQwkMfbDFzrcBB3SaisqUX5sSTW5Rji2Pv+Lbm4aBZiAO
         seb8djcxuRpgVP8bt8E9+phdgEu53WteUDkW/oc4hJCpJ8wAZZ8mSNQtFXSyuR2+qR
         x4iJTyYrlHT+J9YLUp/Kla91yPHLWWCyE8AflmAJAnC+qXnSJxb9Uree5XN8WwVqMt
         H6W9EgmHkZo8YPPkgXO/crhYUoUksim3WrTEF64KNg/OlN8r9+OdZeCKrpN8VSkTMs
         BWItMyiv97Odg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>,
        Abhishek Shah <abhishek.shah@columbia.edu>,
        Gabriel Ryan <gabe@cs.columbia.edu>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 06/32] cgroup: Remove data-race around cgrp_dfl_visible
Date:   Mon, 17 Oct 2022 20:07:03 -0400
Message-Id: <20221018000729.2730519-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit dc79ec1b232ad2c165d381d3dd2626df4ef9b5a4 ]

There's a seemingly harmless data-race around cgrp_dfl_visible detected by
kernel concurrency sanitizer. Let's remove it by throwing WRITE/READ_ONCE at
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Cc: Gabriel Ryan <gabe@cs.columbia.edu>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/netdev/20220819072256.fn7ctciefy4fc4cu@wittgenstein/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5f2090d051ac..99f00a3e1997 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2173,7 +2173,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6091,7 +6091,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.35.1

