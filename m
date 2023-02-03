Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2456894DF
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjBCKO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjBCKO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139DA8E6B1
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974A961E4C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBE2C433EF;
        Fri,  3 Feb 2023 10:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419293;
        bh=wMh0IIVZuuSsmRUhAmkbOju4A4VotdFHEbV9pEewxlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMjR0pyt6NNMswtMK2rcaPvjcGlibWtyro1rJ1HQ2L5AXkaAJ/w+q+Op4GMtFvhb3
         2q/lLxC0likTTJ6A4z2f/el7k0aoS6xJvPyIaCmXWqmUPG1wjfBw5lJPR78puNj8tV
         LbTRPoxfTv0mUT98bmWmI+cMT64SoegDJeHYVVoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/62] w1: fix deadloop in __w1_remove_master_device()
Date:   Fri,  3 Feb 2023 11:12:16 +0100
Message-Id: <20230203101013.892963324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 25d5648802f12ae486076ceca5d7ddf1fef792b2 ]

I got a deadloop report while doing device(ds2482) add/remove test:

  [  162.241881] w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
  [  163.272251] w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
  [  164.296157] w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
  ...

__w1_remove_master_device() can't return, because the dev->refcnt is not zero.

w1_add_master_device()			|
  w1_alloc_dev()			|
    atomic_set(&dev->refcnt, 2)		|
  kthread_run()				|
					|__w1_remove_master_device()
					|  kthread_stop()
  // KTHREAD_SHOULD_STOP is set,	|
  // threadfn(w1_process) won't be	|
  // called.				|
  kthread()				|
					|  // refcnt will never be 0, it's deadloop.
					|  while (atomic_read(&dev->refcnt)) {...}

After calling w1_add_master_device(), w1_process() is not really
invoked, before w1_process() starting, if kthread_stop() is called
in __w1_remove_master_device(), w1_process() will never be called,
the refcnt can not be decreased, then it causes deadloop in remove
function because of non-zero refcnt.

We need to make sure w1_process() is really started, so move the
set refcnt into w1_process() to fix this problem.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221205080434.3149205-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1.c     | 2 ++
 drivers/w1/w1_int.c | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 6f9e9505b34c..44315f9fd669 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1136,6 +1136,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 1c776178f598..eb851eb44300 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -60,10 +60,9 @@ static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	dev->search_count	= w1_search_count;
 	dev->enable_pullup	= w1_enable_pullup;
 
-	/* 1 for w1_process to decrement
-	 * 1 for __w1_remove_master_device to decrement
+	/* For __w1_remove_master_device to decrement
 	 */
-	atomic_set(&dev->refcnt, 2);
+	atomic_set(&dev->refcnt, 1);
 
 	INIT_LIST_HEAD(&dev->slist);
 	INIT_LIST_HEAD(&dev->async_list);
-- 
2.39.0



