Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747D66557A6
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbiLXBiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbiLXBhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:37:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C750532E9;
        Fri, 23 Dec 2022 17:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C5561FAA;
        Sat, 24 Dec 2022 01:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710AEC4339B;
        Sat, 24 Dec 2022 01:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845543;
        bh=q+tZE9wQPv6WvHJsaIuC+jJOEkR+mGJaWDXaMBaY0I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwWywhB+jer4RwmOfFat3OZN1abJy5+txsEJGxprbGGSe3aDRLZcDHA0qOoHYywQ7
         gnSqAAqPmvkKUYfiHPJBw79Q1/uzlqrMw8WnDovD1YuJ3S/dKqn+wAHMCHZ/xYmQ5s
         kN4lopUGU6b/naHJF0GnS3yisZouzCSO8Xwif8jreZyOKbq6Yn0Ii+TP4QmFxZBy0c
         brghvA7WCtZmgF/XqTi9+og9kdgf2lzlgWsae+nB23U1GRKhk5mqk9fuxvqFK2x2wv
         I9UFB548hgmS1YhFmH9g3bZv9vwPS0oEB918lsIpjWKlNuE0DdTHfb0v9ts3qShgcn
         e7lmy9kO8c1JA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shang XiaoJing <shangxiaojing@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/11] chardev: Fix potential memory leak when cdev_add() failed
Date:   Fri, 23 Dec 2022 20:31:56 -0500
Message-Id: <20221224013202.393372-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013202.393372-1-sashal@kernel.org>
References: <20221224013202.393372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 4634c973096a64662a24d9914c47cebc2a8b72f4 ]

Some init function of cdev(like comedi) will call kobject_set_name()
before cdev_add(), but won't free the cdev.kobj.name or put the ref cnt
of cdev.kobj when cdev_add() failed. As the result, cdev.kobj.name will
be leaked.

Free the name of kobject in cdev_add() fail path to prevent memleak. With
this fix, the callers don't need to care about freeing the name of
kobject if cdev_add() fails.

unreferenced object 0xffff8881000fa8c0 (size 8):
  comm "modprobe", pid 239, jiffies 4294905173 (age 51.308s)
  hex dump (first 8 bytes):
    63 6f 6d 65 64 69 00 ff                          comedi..
  backtrace:
    [<000000005f9878f7>] __kmalloc_node_track_caller+0x4c/0x1c0
    [<000000000fd70302>] kstrdup+0x3f/0x70
    [<000000009428bc33>] kstrdup_const+0x46/0x60
    [<00000000ed50d9de>] kvasprintf_const+0xdb/0xf0
    [<00000000b2766964>] kobject_set_name_vargs+0x3c/0xe0
    [<00000000f2424ef7>] kobject_set_name+0x62/0x90
    [<000000005d5a125b>] 0xffffffffa0013098
    [<00000000f331e663>] do_one_initcall+0x7a/0x380
    [<00000000aa7bac96>] do_init_module+0x5c/0x230
    [<000000005fd72335>] load_module+0x227d/0x2420
    [<00000000ad550cf1>] __do_sys_finit_module+0xd5/0x140
    [<00000000069a60c5>] do_syscall_64+0x3f/0x90
    [<00000000c5e0d521>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Link: https://lore.kernel.org/r/20221102072659.23671-1-shangxiaojing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/char_dev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index ba0ded7842a7..340e4543b24a 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -483,17 +483,24 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	p->dev = dev;
 	p->count = count;
 
-	if (WARN_ON(dev == WHITEOUT_DEV))
-		return -EBUSY;
+	if (WARN_ON(dev == WHITEOUT_DEV)) {
+		error = -EBUSY;
+		goto err;
+	}
 
 	error = kobj_map(cdev_map, dev, count, NULL,
 			 exact_match, exact_lock, p);
 	if (error)
-		return error;
+		goto err;
 
 	kobject_get(p->kobj.parent);
 
 	return 0;
+
+err:
+	kfree_const(p->kobj.name);
+	p->kobj.name = NULL;
+	return error;
 }
 
 /**
-- 
2.35.1

