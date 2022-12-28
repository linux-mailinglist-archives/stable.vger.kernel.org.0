Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35F657B93
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiL1PXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiL1PXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3453D13F57
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C55E961544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC013C433EF;
        Wed, 28 Dec 2022 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240986;
        bh=Zvrn+D2zzWMq5m3OMrROzucHzo6HqdNb5UxvnGjcmP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFUL8E6h0msMV/rVq9Ls5pKk9p2WlWAYFKEQfcCYzVVvDGkOLI+Dfpw86ZEHHPq6F
         ztC0DmKmfsj+oFjoqMswSpuzTpWHNgI0dtf9NjnjcrCzMI8Z6+7N83n44CtF0z84JY
         DE6OxTxj1KC+4OyQk/L6S+ovLjpo6xLBspDwsMRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jingyu Wang <jingyuwang_vip@163.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Waiman Long <longman@redhat.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>, Yu Zhe <yuzhe@nfschina.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0192/1146] ipc: fix memory leak in init_mqueue_fs()
Date:   Wed, 28 Dec 2022 15:28:51 +0100
Message-Id: <20221228144335.362963294@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 12b677f2c697d61e5ddbcb6c1650050a39392f54 ]

When setup_mq_sysctls() failed in init_mqueue_fs(), mqueue_inode_cachep is
not released.  In order to fix this issue, the release path is reordered.

Link: https://lkml.kernel.org/r/20221209092929.1978875-1-shaozhengchao@huawei.com
Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jingyu Wang <jingyuwang_vip@163.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Yu Zhe <yuzhe@nfschina.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 467a194b8a2e..d09aa1c1e3e6 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1726,7 +1726,8 @@ static int __init init_mqueue_fs(void)
 
 	if (!setup_mq_sysctls(&init_ipc_ns)) {
 		pr_warn("sysctl registration failed\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto out_kmem;
 	}
 
 	error = register_filesystem(&mqueue_fs_type);
@@ -1744,8 +1745,9 @@ static int __init init_mqueue_fs(void)
 out_filesystem:
 	unregister_filesystem(&mqueue_fs_type);
 out_sysctl:
-	kmem_cache_destroy(mqueue_inode_cachep);
 	retire_mq_sysctls(&init_ipc_ns);
+out_kmem:
+	kmem_cache_destroy(mqueue_inode_cachep);
 	return error;
 }
 
-- 
2.35.1



