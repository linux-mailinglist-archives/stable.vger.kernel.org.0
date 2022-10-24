Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB4E60AC5B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiJXOGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiJXOEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2869A60F7;
        Mon, 24 Oct 2022 05:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 533236128D;
        Mon, 24 Oct 2022 12:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60150C433C1;
        Mon, 24 Oct 2022 12:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615766;
        bh=cNzehMzxAo+SjDFKbnQaHGi1kSI6tMK7hRk8V6BETUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dK46kNUaqgoLnvLYLH4KqMP8BsHDQ7qCfP78hzLuheM+0rhufnxALNXkXAUFj3QEg
         +107MNwqXShQIoYhq0DnPebP0ljEjmIF7+IYTGtq585Pjqvqgn2ItJUjnLKHoVRA7j
         GXCX5pGH2CGEiLO55yWZEc6pIVyoPqadkuxJXBlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/530] cgroup: Honor callers cgroup NS when resolving path
Date:   Mon, 24 Oct 2022 13:32:00 +0200
Message-Id: <20221024113102.058138114@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 4b19f7fc4deb..a92990f070d1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6598,8 +6598,12 @@ struct cgroup *cgroup_get_from_path(const char *path)
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



