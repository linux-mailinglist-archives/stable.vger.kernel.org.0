Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3EC63DFA3
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiK3StG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiK3Ss7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B966732BBB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A39661D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F95C433D6;
        Wed, 30 Nov 2022 18:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834136;
        bh=t/zrEWdsKP4nkibCe8XHi2Juj12u50c+6yrnYnblzq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7hUyOkPf1Dj1VnePhioiHKaGiVr/KFBLWmU2AzRhCGOSugUzXkNyB7CjuGMg29H5
         bclthz/vfmFbmHQ0moq02B6dnAK5KhDlLRUY1kF3RDQ8X2yFerbUnga8pv091lfuMW
         PwJbTzIhPxb4ZvydCwWhNOVjLC9c9kD5GzJmFKK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 116/289] zonefs: Fix race between modprobe and mount
Date:   Wed, 30 Nov 2022 19:21:41 +0100
Message-Id: <20221130180546.768595062@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 4e45886956a20942800259f326a04417292ae314 ]

There is a race between modprobe and mount as below:

 modprobe zonefs                | mount -t zonefs
--------------------------------|-------------------------
 zonefs_init                    |
  register_filesystem       [1] |
                                | zonefs_fill_super    [2]
  zonefs_sysfs_init         [3] |

1. register zonefs suceess, then
2. user can mount the zonefs
3. if sysfs initialize failed, the module initialize failed.

Then the mount process maybe some error happened since the module
initialize failed.

Let's register zonefs after all dependency resource ready. And
reorder the dependency resource release in module exit.

Fixes: 9277a6d4fbd4 ("zonefs: Export open zone resource information through sysfs")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 860f0b1032c6..625749fbedf4 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1905,18 +1905,18 @@ static int __init zonefs_init(void)
 	if (ret)
 		return ret;
 
-	ret = register_filesystem(&zonefs_type);
+	ret = zonefs_sysfs_init();
 	if (ret)
 		goto destroy_inodecache;
 
-	ret = zonefs_sysfs_init();
+	ret = register_filesystem(&zonefs_type);
 	if (ret)
-		goto unregister_fs;
+		goto sysfs_exit;
 
 	return 0;
 
-unregister_fs:
-	unregister_filesystem(&zonefs_type);
+sysfs_exit:
+	zonefs_sysfs_exit();
 destroy_inodecache:
 	zonefs_destroy_inodecache();
 
@@ -1925,9 +1925,9 @@ static int __init zonefs_init(void)
 
 static void __exit zonefs_exit(void)
 {
+	unregister_filesystem(&zonefs_type);
 	zonefs_sysfs_exit();
 	zonefs_destroy_inodecache();
-	unregister_filesystem(&zonefs_type);
 }
 
 MODULE_AUTHOR("Damien Le Moal");
-- 
2.35.1



