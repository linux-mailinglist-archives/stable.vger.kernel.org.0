Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596DF4A96A9
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357384AbiBDJ1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357659AbiBDJ0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96446B836F8;
        Fri,  4 Feb 2022 09:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA43FC004E1;
        Fri,  4 Feb 2022 09:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966764;
        bh=aWaycIVeAhO1p4ZgtcI+rJ4obhF3IJc4kVHZVcCnsLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqI4KgdGHNaBBlrGyX9Me+BAeZ0HckijPy8Z2Kq9DLvfbJ1PPj0aZf5chzKubKzPk
         sPbjI3+9xr1myqwxoTXetaQbVTPr77IXii15OfwLpL2/7jGKMYXkmde7+O3qcgG9k0
         4L0kiWvxTCmL1hVEmkKFoGRRUh7gzJgqSZwZ4OdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tabitha Sable <tabitha.c.sable@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.16 06/43] cgroup-v1: Require capabilities to set release_agent
Date:   Fri,  4 Feb 2022 10:22:13 +0100
Message-Id: <20220204091917.394618030@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 24f6008564183aa120d07c03d9289519c2fe02af upstream.

The cgroup release_agent is called with call_usermodehelper.  The function
call_usermodehelper starts the release_agent with a full set fo capabilities.
Therefore require capabilities when setting the release_agaent.

Reported-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Tested-by: Tabitha Sable <tabitha.c.sable@gmail.com>
Fixes: 81a6a5cdd2c5 ("Task Control Groups: automatic userspace notification of idle cgroups")
Cc: stable@vger.kernel.org # v2.6.24+
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -549,6 +549,14 @@ static ssize_t cgroup_release_agent_writ
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
+	/*
+	 * Release agent gets called with all capabilities,
+	 * require capabilities to set release agent.
+	 */
+	if ((of->file->f_cred->user_ns != &init_user_ns) ||
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
@@ -954,6 +962,12 @@ int cgroup1_parse_param(struct fs_contex
 		/* Specifying two release agents is forbidden */
 		if (ctx->release_agent)
 			return invalfc(fc, "release_agent respecified");
+		/*
+		 * Release agent gets called with all capabilities,
+		 * require capabilities to set release agent.
+		 */
+		if ((fc->user_ns != &init_user_ns) || !capable(CAP_SYS_ADMIN))
+			return invalfc(fc, "Setting release_agent not allowed");
 		ctx->release_agent = param->string;
 		param->string = NULL;
 		break;


