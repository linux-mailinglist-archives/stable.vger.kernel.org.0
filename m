Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD06C4F27DA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiDEIJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiDEH5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AA1939AF;
        Tue,  5 Apr 2022 00:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75897B81B90;
        Tue,  5 Apr 2022 07:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6806C3410F;
        Tue,  5 Apr 2022 07:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145102;
        bh=oHVFxPkpSQYF4vQXl0hmS/0XMzT+M/SqED4Ids4AGWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwo6vvNLrKYJYz7AOc6FI2StfYu5A+mFjpZT5qyN9XR6QSIw8pCC3MS3AurrevFGK
         wHDKzlOLBSRNaEKSKlB+ONMS+JCsJatSXrF05o9w7HK6QAA02Re08Hbx+BO/FjWuhm
         xbqSiqfLY5Nzu8c7SrYIbfIxuMZOA/uQTuo/KWc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0285/1126] fs: erofs: add sanity check for kobject in erofs_unregister_sysfs
Date:   Tue,  5 Apr 2022 09:17:12 +0200
Message-Id: <20220405070415.978906974@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit a942da24abc5839c11a8fc2a4b7cb268ea94ba54 ]

Syzkaller hit 'WARNING: kobject bug in erofs_unregister_sysfs'. This bug
is triggered by injecting fault in kobject_init_and_add of
erofs_unregister_sysfs.

Fix this by adding sanity check for kobject in erofs_unregister_sysfs

Note that I've tested the patch and the crash does not occur any more.

Link: https://lore.kernel.org/r/20220315132814.12332-1-dzm91@hust.edu.cn
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: 168e9a76200c ("erofs: add sysfs interface")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/sysfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index dac252bc9228..f3babf1e6608 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -221,9 +221,11 @@ void erofs_unregister_sysfs(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	kobject_del(&sbi->s_kobj);
-	kobject_put(&sbi->s_kobj);
-	wait_for_completion(&sbi->s_kobj_unregister);
+	if (sbi->s_kobj.state_in_sysfs) {
+		kobject_del(&sbi->s_kobj);
+		kobject_put(&sbi->s_kobj);
+		wait_for_completion(&sbi->s_kobj_unregister);
+	}
 }
 
 int __init erofs_init_sysfs(void)
-- 
2.34.1



