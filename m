Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE2E54917A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377604AbiFMNel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377599AbiFMNdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:33:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A2172E0B;
        Mon, 13 Jun 2022 04:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4671560B6E;
        Mon, 13 Jun 2022 11:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4ACC341C4;
        Mon, 13 Jun 2022 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119617;
        bh=BW0XEuoI8m9tE28jNunQyhVQ0FFH+oAiHIpWbkAgEyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVqXIIacN3lS/+/QQ8zDfizxTLvof/n6yQEp7zU7MAq/2HFpwW7+/EpyORjN0g1tb
         aqT/x/WJo1seSyOmZRLkYEsIYytoH2FxCD/MchRV2tOY3YCvvKC70qEAtILHL8vVIy
         cMvTGkcxyHEEk6quFi/i4cxMJ7eMvsP5LsCc/9eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Wensheng <zhangwensheng5@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 078/339] driver core: fix deadlock in __device_attach
Date:   Mon, 13 Jun 2022 12:08:23 +0200
Message-Id: <20220613094928.885407235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Wensheng <zhangwensheng5@huawei.com>

[ Upstream commit b232b02bf3c205b13a26dcec08e53baddd8e59ed ]

In __device_attach function, The lock holding logic is as follows:
...
__device_attach
device_lock(dev)      // get lock dev
  async_schedule_dev(__device_attach_async_helper, dev); // func
    async_schedule_node
      async_schedule_node_domain(func)
        entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
	/* when fail or work limit, sync to execute func, but
	   __device_attach_async_helper will get lock dev as
	   well, which will lead to A-A deadlock.  */
	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
	  func;
	else
	  queue_work_node(node, system_unbound_wq, &entry->work)
  device_unlock(dev)

As shown above, when it is allowed to do async probes, because of
out of memory or work limit, async work is not allowed, to do
sync execute instead. it will lead to A-A deadlock because of
__device_attach_async_helper getting lock dev.

To fix the deadlock, move the async_schedule_dev outside device_lock,
as we can see, in async_schedule_node_domain, the parameter of
queue_work_node is system_unbound_wq, so it can accept concurrent
operations. which will also not change the code logic, and will
not lead to deadlock.

Fixes: 765230b5f084 ("driver-core: add asynchronous probing support for drivers")
Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
Link: https://lore.kernel.org/r/20220518074516.1225580-1-zhangwensheng5@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3fc3b5940bb3..ed02a529a896 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -941,6 +941,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 static int __device_attach(struct device *dev, bool allow_async)
 {
 	int ret = 0;
+	bool async = false;
 
 	device_lock(dev);
 	if (dev->p->dead) {
@@ -979,7 +980,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			 */
 			dev_dbg(dev, "scheduling asynchronous probe\n");
 			get_device(dev);
-			async_schedule_dev(__device_attach_async_helper, dev);
+			async = true;
 		} else {
 			pm_request_idle(dev);
 		}
@@ -989,6 +990,8 @@ static int __device_attach(struct device *dev, bool allow_async)
 	}
 out_unlock:
 	device_unlock(dev);
+	if (async)
+		async_schedule_dev(__device_attach_async_helper, dev);
 	return ret;
 }
 
-- 
2.35.1



