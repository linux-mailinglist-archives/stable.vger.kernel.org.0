Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5454A964E
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357914AbiBDJYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43090 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357508AbiBDJX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26BE0615C6;
        Fri,  4 Feb 2022 09:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F74C004E1;
        Fri,  4 Feb 2022 09:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966635;
        bh=FK7HW77aApN49lJNDt5ACm2k24XuNaZJ0yWAgCuC1Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEU7IKZIkVq3g7OgtAbcm7NdMLU/Zle/b2p2CUIkyToQoaUXQvOUKiKJimqAiK3KD
         5WoqHgja/A0t9E36iDx0zZZUc9NAOdUbJEpL8zjSO4U86BYSXkND7ucGqd2YnZn7ZQ
         F6Z4mnmfykrEG9RVu3ecximMDM/u+wZuZbm4mG5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tabitha Sable <tabitha.c.sable@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 06/32] cgroup-v1: Require capabilities to set release_agent
Date:   Fri,  4 Feb 2022 10:22:16 +0100
Message-Id: <20220204091915.456572247@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
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
@@ -552,6 +552,14 @@ static ssize_t cgroup_release_agent_writ
 
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
@@ -963,6 +971,12 @@ int cgroup1_parse_param(struct fs_contex
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


