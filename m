Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833214C75AD
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiB1R4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240764AbiB1Ryg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC4F522EC;
        Mon, 28 Feb 2022 09:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A3066066C;
        Mon, 28 Feb 2022 17:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34904C340E7;
        Mon, 28 Feb 2022 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070189;
        bh=HrLjEndDO//JD/2Xs5TV5gBE1S7WGnjDJ4hoAuKHawo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlulyREPTgjQfgz3uC0OiGEDpEru9Y27DtYVx528QVEGI1AKyRRWdqNr3i9vvA2b7
         hgwsd3W+tDoVBnZddZ6Mx3YtCytFo3VhzSSUyGwHPC2ZGIjqYRemEktx6Tjbw8O1y4
         FhPwJAgONP54AtWO8kTkE9QP7VmhTfiPf55CqES0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        "Masami Ichikawa(CIP)" <masami.ichikawa@cybertrust.co.jp>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.16 003/164] cgroup-v1: Correct privileges check in release_agent writes
Date:   Mon, 28 Feb 2022 18:22:45 +0100
Message-Id: <20220228172359.945412729@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

commit 467a726b754f474936980da793b4ff2ec3e382a7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -546,6 +546,7 @@ static ssize_t cgroup_release_agent_writ
 					  char *buf, size_t nbytes, loff_t off)
 {
 	struct cgroup *cgrp;
+	struct cgroup_file_ctx *ctx;
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
@@ -553,8 +554,9 @@ static ssize_t cgroup_release_agent_writ
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


