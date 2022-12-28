Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F49657882
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiL1OwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiL1Ov3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:51:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355711C3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDECACE134E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E86C433D2;
        Wed, 28 Dec 2022 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239064;
        bh=bhefCoveFalYjvW0k7lZd7xEECoo+RCh7S24bZQWBws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0q4ZSjm+9m4rSeVhYA6r08FK3huLjKq0WyttTA+Soqxg+msY5cv6Fh0L586U0nOl
         iVL7Wi0dQrABn6NsPmu5CzoptNpWnFR+qtSCsxXurFK+EC6Gnaym5DQcybYqzTFN7q
         Orxi9p0yI7zypEhgriDJwVkzIkQ55CV/IkUxH6vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/731] ocfs2: fix memory leak in ocfs2_stack_glue_init()
Date:   Wed, 28 Dec 2022 15:33:15 +0100
Message-Id: <20221228144259.102369486@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 13b6269dd022aaa69ca8d1df374ab327504121cf ]

ocfs2_table_header should be free in ocfs2_stack_glue_init() if
ocfs2_sysfs_init() failed, otherwise kmemleak will report memleak.

BUG: memory leak
unreferenced object 0xffff88810eeb5800 (size 128):
  comm "modprobe", pid 4507, jiffies 4296182506 (age 55.888s)
  hex dump (first 32 bytes):
    c0 40 14 a0 ff ff ff ff 00 00 00 00 01 00 00 00  .@..............
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000001e59e1cd>] __register_sysctl_table+0xca/0xef0
    [<00000000c04f70f7>] 0xffffffffa0050037
    [<000000001bd12912>] do_one_initcall+0xdb/0x480
    [<0000000064f766c9>] do_init_module+0x1cf/0x680
    [<000000002ba52db0>] load_module+0x6441/0x6f20
    [<000000009772580d>] __do_sys_finit_module+0x12f/0x1c0
    [<00000000380c1f22>] do_syscall_64+0x3f/0x90
    [<000000004cf473bc>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lkml.kernel.org/r/41651ca1-432a-db34-eb97-d35744559de1@linux.alibaba.com
Fixes: 3878f110f71a ("ocfs2: Move the hb_ctl_path sysctl into the stack glue.")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/stackglue.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 16f1bfc407f2..955f475f9aca 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -703,6 +703,8 @@ static struct ctl_table_header *ocfs2_table_header;
 
 static int __init ocfs2_stack_glue_init(void)
 {
+	int ret;
+
 	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
 	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
@@ -712,7 +714,11 @@ static int __init ocfs2_stack_glue_init(void)
 		return -ENOMEM; /* or something. */
 	}
 
-	return ocfs2_sysfs_init();
+	ret = ocfs2_sysfs_init();
+	if (ret)
+		unregister_sysctl_table(ocfs2_table_header);
+
+	return ret;
 }
 
 static void __exit ocfs2_stack_glue_exit(void)
-- 
2.35.1



