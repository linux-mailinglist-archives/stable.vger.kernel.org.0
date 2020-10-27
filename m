Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C03329B541
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790947AbgJ0PKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790230AbgJ0PKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F6122400;
        Tue, 27 Oct 2020 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811400;
        bh=vP/tCCG4Vcuj9W8Dy0G01IexTcr5iDHC+I2q9IXh9jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QggpSqM6vaTmfxYB3YaD4PnKpagRk+ppcZF+EnkbOu1r+OX/b+RpRmeAonPEXkPjv
         bjx7zUCk63o5ZPyqTs10UBpuCyPpduJ/YHTJreHnRy5Naaw0jT14UhrDsmrG34Y55x
         5cpCpwR48L/Rji4eRxP7kbuHfu1vNbQPvH/eXJAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 449/633] module: statically initialize init section freeing data
Date:   Tue, 27 Oct 2020 14:53:12 +0100
Message-Id: <20201027135543.775193156@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit fdf09ab887829cd1b671e45d9549f8ec1ffda0fa ]

Corentin hit the following workqueue warning when running with
CRYPTO_MANAGER_EXTRA_TESTS:

  WARNING: CPU: 2 PID: 147 at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
  Modules linked in: ghash_generic
  CPU: 2 PID: 147 Comm: modprobe Not tainted
      5.6.0-rc1-next-20200214-00068-g166c9264f0b1-dirty #545
  Hardware name: Pine H64 model A (DT)
  pc : __queue_work+0x3b8/0x3d0
  Call trace:
   __queue_work+0x3b8/0x3d0
   queue_work_on+0x6c/0x90
   do_init_module+0x188/0x1f0
   load_module+0x1d00/0x22b0

I wasn't able to reproduce on x86 or rpi 3b+.

This is

  WARN_ON(!list_empty(&work->entry))

from __queue_work(), and it happens because the init_free_wq work item
isn't initialized in time for a crypto test that requests the gcm
module.  Some crypto tests were recently moved earlier in boot as
explained in commit c4741b230597 ("crypto: run initcalls for generic
implementations earlier"), which went into mainline less than two weeks
before the Fixes commit.

Avoid the warning by statically initializing init_free_wq and the
corresponding llist.

Link: https://lore.kernel.org/lkml/20200217204803.GA13479@Red/
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun50i-h6-pine-h64
Tested-on: imx8mn-ddr4-evk
Tested-on: sun50i-a64-bananapi-m64
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 08c46084d8cca..991395d60f59c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -91,8 +91,9 @@ EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
-static struct work_struct init_free_wq;
-static struct llist_head init_free_list;
+static void do_free_init(struct work_struct *w);
+static DECLARE_WORK(init_free_wq, do_free_init);
+static LLIST_HEAD(init_free_list);
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 
@@ -3551,14 +3552,6 @@ static void do_free_init(struct work_struct *w)
 	}
 }
 
-static int __init modules_wq_init(void)
-{
-	INIT_WORK(&init_free_wq, do_free_init);
-	init_llist_head(&init_free_list);
-	return 0;
-}
-module_init(modules_wq_init);
-
 /*
  * This is where the real work happens.
  *
-- 
2.25.1



