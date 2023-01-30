Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2802F681174
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbjA3ONg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbjA3ONb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB51366B5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD20061035
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02CFC4339E;
        Mon, 30 Jan 2023 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088007;
        bh=gpwzdyVOFULh0qWwfN70dlQcQ2gD66eXLB0zvnF8/RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5FoB2SLWTrP/n51MmbnNuE4dJ7FY1jblgs7U9HJFmMlCrnAVD7v2FUfFf6xGrEbl
         USjTJ/MdNibLVtkA39tq8ogEOByRusQlSsrPnIATvdKYc4iBliyxSmRNniPzIG7iOX
         79fG6TMFHaF4WtVqrcVXqNlvYbRVf7nc9sSqWkqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/204] w1: fix deadloop in __w1_remove_master_device()
Date:   Mon, 30 Jan 2023 14:50:49 +0100
Message-Id: <20230130134320.021878580@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index f2ae2e563dc5..8b35fae4cd61 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1166,6 +1166,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index b3e1792d9c49..3a71c5eb2f83 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -51,10 +51,9 @@ static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
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



