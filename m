Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE98B6042DE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiJSLLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbiJSLKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8239152C49;
        Wed, 19 Oct 2022 03:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01315B82333;
        Wed, 19 Oct 2022 09:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580A5C433D6;
        Wed, 19 Oct 2022 09:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170369;
        bh=I/XUHacc8FBmkhRg2IdQdCttKWx2Fpa5yIMG9Xa+66c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVHMpOdCx78pcRVncNszUqy/vP63O0kUDlry+tS+WQ8VEySAJl/9W0o+W0Rv3tCVP
         0LbgFV2j8bQm2r8R581Exkkh1ssswJDEVF1VxLPasMLADUsfPJs3duR8BNqyFjVN1R
         5Al4bF5EDZYyFhn6NjGa/SBNOnJ5Dhn4tf8pBfLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 628/862] cgroup: Honor callers cgroup NS when resolving path
Date:   Wed, 19 Oct 2022 10:31:55 +0200
Message-Id: <20221019083317.668836387@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 74e4b956eb1cac0e4c10c240339b1bbfbc9a4c48 ]

cgroup_get_from_path() is not widely used function. Its callers presume
the path is resolved under cgroup namespace. (There is one caller
currently and resolving in init NS won't make harm (netfilter). However,
future users may be subject to different effects when resolving
globally.)
Since, there's currently no use for the global resolution, modify the
existing function to take cgroup NS into account.

Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5f2090d051ac..29296a6374ef 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6638,8 +6638,12 @@ struct cgroup *cgroup_get_from_path(const char *path)
 {
 	struct kernfs_node *kn;
 	struct cgroup *cgrp = ERR_PTR(-ENOENT);
+	struct cgroup *root_cgrp;
 
-	kn = kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
+	spin_lock_irq(&css_set_lock);
+	root_cgrp = current_cgns_cgroup_from_root(&cgrp_dfl_root);
+	kn = kernfs_walk_and_get(root_cgrp->kn, path);
+	spin_unlock_irq(&css_set_lock);
 	if (!kn)
 		goto out;
 
-- 
2.35.1



