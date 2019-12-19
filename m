Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E69126C5A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfLSTDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbfLSSsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B26E2465E;
        Thu, 19 Dec 2019 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781320;
        bh=cvmxQ3pO4VoFUH6m+dMfaat/Qo5N3IdyNKWRcLij1as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KA/DQ0CSUchn8h8JWeYr4VG6AqZOXfycAmwutq8ssIT3UqCZYyMfgtun2s4qMG01+
         pgGy/gC4ctXFHAdYv/grqfSk1dpNQCkqlwBJVI4LbpZft5HcGL6k4RmoTA0rL1gWDY
         9VHsBna9HvKvmX1cUbDu2Q3DahloHfhyoX8oyPr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 174/199] kernel/module.c: wakeup processes in module_wq on module unload
Date:   Thu, 19 Dec 2019 19:34:16 +0100
Message-Id: <20191219183225.177799954@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khorenko <khorenko@virtuozzo.com>

[ Upstream commit 5d603311615f612320bb77bd2a82553ef1ced5b7 ]

Fix the race between load and unload a kernel module.

sys_delete_module()
 try_stop_module()
  mod->state = _GOING
					add_unformed_module()
					 old = find_module_all()
					 (old->state == _GOING =>
					  wait_event_interruptible())

					 During pre-condition
					 finished_loading() rets 0
					 schedule()
					 (never gets waken up later)
 free_module()
  mod->state = _UNFORMED
   list_del_rcu(&mod->list)
   (dels mod from "modules" list)

return

The race above leads to modprobe hanging forever on loading
a module.

Error paths on loading module call wake_up_all(&module_wq) after
freeing module, so let's do the same on straight module unload.

Fixes: 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
Reviewed-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index fb9e07aec49e0..9cb1437151ae7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -995,6 +995,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
 
 	free_module(mod);
+	/* someone could wait for the module in add_unformed_module() */
+	wake_up_all(&module_wq);
 	return 0;
 out:
 	mutex_unlock(&module_mutex);
-- 
2.20.1



