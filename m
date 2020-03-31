Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B143198FE7
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgCaJHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgCaJHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8DE20675;
        Tue, 31 Mar 2020 09:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645641;
        bh=8HWl7opAVhbfm8fIWKWNIwlkSWCpWGoZz0bx3PKtFJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFbfKBIewIkZ02UZsS3Sjp4EDGZwmetXnFuab+Sbn5bodh7eNL8j8MBCmedsGNOZT
         vLFV3VkdI1IAkG52/qRXGE7BYby2b9aXrfNhCCL2MKKB2TWAwQSZGBIJLKpRo2pXin
         JZdYIQHbzZvJyai46gV5oFdN8H4Nfp78fBz/DcIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 068/170] cgroup1: dont call release_agent when it is ""
Date:   Tue, 31 Mar 2020 10:58:02 +0200
Message-Id: <20200331085431.650236415@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 84bedb87ae137..a1fbf500d0af7 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -785,7 +785,7 @@ void cgroup1_release_agent(struct work_struct *work)
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-	if (!pathbuf || !agentbuf)
+	if (!pathbuf || !agentbuf || !strlen(agentbuf))
 		goto out;
 
 	spin_lock_irq(&css_set_lock);
-- 
2.20.1



