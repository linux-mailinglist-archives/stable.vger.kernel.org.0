Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9218A4C0
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgCRUze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgCRUzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B3D20BED;
        Wed, 18 Mar 2020 20:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564932;
        bh=CZB+KZiYdArxmr34T50wC1U0sriUX3k/RvRcHsuKGS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phPvVC6O5fVNmxyP1UYkBIAzD33fMGIIHF8aPMjiVW0dLx/sI+pQnHDVA0uGSNGWb
         1KSdtD8d9ap4om8glS8LVf7/mePVgsW/XS9vbyBY5sRbEoB0/qdUTPtPHqMUGl5FKv
         b98hzqeK7owxdsupzgerKz/diFpjzi28YhnnWdYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tycho Andersen <tycho@tycho.ws>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/37] cgroup1: don't call release_agent when it is ""
Date:   Wed, 18 Mar 2020 16:54:51 -0400
Message-Id: <20200318205509.17053-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

[ Upstream commit 2e5383d7904e60529136727e49629a82058a5607 ]

Older (and maybe current) versions of systemd set release_agent to "" when
shutting down, but do not set notify_on_release to 0.

Since 64e90a8acb85 ("Introduce STATIC_USERMODEHELPER to mediate
call_usermodehelper()"), we filter out such calls when the user mode helper
path is "". However, when used in conjunction with an actual (i.e. non "")
STATIC_USERMODEHELPER, the path is never "", so the real usermode helper
will be called with argv[0] == "".

Let's avoid this by not invoking the release_agent when it is "".

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index c9628b9a41d23..dd8bdbfbbde1e 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -812,7 +812,7 @@ void cgroup1_release_agent(struct work_struct *work)
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-	if (!pathbuf || !agentbuf)
+	if (!pathbuf || !agentbuf || !strlen(agentbuf))
 		goto out;
 
 	spin_lock_irq(&css_set_lock);
-- 
2.20.1

