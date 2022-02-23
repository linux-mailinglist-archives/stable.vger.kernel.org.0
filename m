Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35D64C1AA3
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 19:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbiBWSIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 13:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243808AbiBWSH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 13:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC8347059
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 10:07:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD4DB8213C
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 18:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2162FC340E7;
        Wed, 23 Feb 2022 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645639647;
        bh=YbjYIBhR1HjxfOfUt/6f9pPKawMqR70iFjlCdbKbXeY=;
        h=Subject:To:Cc:From:Date:From;
        b=NzO9GnVjUUD8t7HmvdcbzZliDw61u9q6VGMtG8C0v0PvJaqD1vUrTOUcWh0hOqP+N
         G5TOKV2mXaiJ8ua5npJzL1KNxOQuArcQXC32mayogXQyQ30nnGfoRz/db5ywQPAMCE
         mJfTgtCv82CeU8dGJvEjjEJk6Cx1tS13rw5Dwg34=
Subject: FAILED: patch "[PATCH] cgroup-v1: Correct privileges check in release_agent writes" failed to apply to 5.10-stable tree
To:     mkoutny@suse.com, masami.ichikawa@cybertrust.co.jp, tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Feb 2022 19:07:12 +0100
Message-ID: <1645639632780@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 467a726b754f474936980da793b4ff2ec3e382a7 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Date: Thu, 17 Feb 2022 17:11:28 +0100
Subject: [PATCH] cgroup-v1: Correct privileges check in release_agent writes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The idea is to check: a) the owning user_ns of cgroup_ns, b)
capabilities in init_user_ns.

The commit 24f600856418 ("cgroup-v1: Require capabilities to set
release_agent") got this wrong in the write handler of release_agent
since it checked user_ns of the opener (may be different from the owning
user_ns of cgroup_ns).
Secondly, to avoid possibly confused deputy, the capability of the
opener must be checked.

Fixes: 24f600856418 ("cgroup-v1: Require capabilities to set release_agent")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/stable/20220216121142.GB30035@blackbody.suse.cz/
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 0e877dbcfeea..afc6c0e9c966 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -546,6 +546,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 					  char *buf, size_t nbytes, loff_t off)
 {
 	struct cgroup *cgrp;
+	struct cgroup_file_ctx *ctx;
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
@@ -553,8 +554,9 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 	 * Release agent gets called with all capabilities,
 	 * require capabilities to set release agent.
 	 */
-	if ((of->file->f_cred->user_ns != &init_user_ns) ||
-	    !capable(CAP_SYS_ADMIN))
+	ctx = of->priv;
+	if ((ctx->ns->user_ns != &init_user_ns) ||
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);

