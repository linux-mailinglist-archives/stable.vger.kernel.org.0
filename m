Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544D566CAB2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbjAPRGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjAPRFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:05:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CE9301B6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 11CD9CE1296
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BFBC433D2;
        Mon, 16 Jan 2023 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887621;
        bh=prFemcdQev7Zxhkw0pDyGrz+mEdWKAFO7af+R8PrpXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9xliYoFYOYOS4W9MlF8+sW+b8TfLnY2BHcdFVeX2FupNfT5mPTxxlwam6KrTXwvf
         xRFOouwk3qUJoPNDZeZ8tlndwGZJCltHr6FN3MLH9m192vKy6DQPEcj+wzhTuiJHzS
         4tbslKRYWuKcN8PvgrwLVx2T9WdmOEpVy4bmPr3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/521] class: fix possible memory leak in __class_register()
Date:   Mon, 16 Jan 2023 16:48:00 +0100
Message-Id: <20230116154856.910086985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 8c3e8a6bdb5253b97ad532570f8b5db5f7a06407 ]

If class_add_groups() returns error, the 'cp->subsys' need be
unregister, and the 'cp' need be freed.

We can not call kset_unregister() here, because the 'cls' will
be freed in callback function class_release() and it's also
freed in caller's error path, it will cause double free.

So fix this by calling kobject_del() and kfree_const(name) to
cleanup kobject. Besides, call kfree() to free the 'cp'.

Fault injection test can trigger this:

unreferenced object 0xffff888102fa8190 (size 8):
  comm "modprobe", pid 502, jiffies 4294906074 (age 49.296s)
  hex dump (first 8 bytes):
    70 6b 74 63 64 76 64 00                          pktcdvd.
  backtrace:
    [<00000000e7c7703d>] __kmalloc_track_caller+0x1ae/0x320
    [<000000005e4d70bc>] kstrdup+0x3a/0x70
    [<00000000c2e5e85a>] kstrdup_const+0x68/0x80
    [<000000000049a8c7>] kvasprintf_const+0x10b/0x190
    [<0000000029123163>] kobject_set_name_vargs+0x56/0x150
    [<00000000747219c9>] kobject_set_name+0xab/0xe0
    [<0000000005f1ea4e>] __class_register+0x15c/0x49a

unreferenced object 0xffff888037274000 (size 1024):
  comm "modprobe", pid 502, jiffies 4294906074 (age 49.296s)
  hex dump (first 32 bytes):
    00 40 27 37 80 88 ff ff 00 40 27 37 80 88 ff ff  .@'7.....@'7....
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
  backtrace:
    [<00000000151f9600>] kmem_cache_alloc_trace+0x17c/0x2f0
    [<00000000ecf3dd95>] __class_register+0x86/0x49a

Fixes: ced6473e7486 ("driver core: class: add class_groups support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221026082803.3458760-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/class.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 54def4e02f00..d36cdbeaa2c8 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -185,6 +185,11 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	}
 	error = class_add_groups(class_get(cls), cls->class_groups);
 	class_put(cls);
+	if (error) {
+		kobject_del(&cp->subsys.kobj);
+		kfree_const(cp->subsys.kobj.name);
+		kfree(cp);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(__class_register);
-- 
2.35.1



