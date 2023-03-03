Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C556AA27F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjCCVsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjCCVrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:47:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269DA6423F;
        Fri,  3 Mar 2023 13:45:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E406161922;
        Fri,  3 Mar 2023 21:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AEEC4339B;
        Fri,  3 Mar 2023 21:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879778;
        bh=42NXa3rkxB0hPj2cneXedkTKdbGvXlgJG/EirB3pMUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h56XmmgxxJSqwpoesW7U92oxJHKf4xnOA2YEAIaW89I3EDlySteAEqL1lpAwQQP6z
         +8SJXdplyly0n98R5lMqk06hQZNfoIZUBkmgIsN8aZfgBT3/YeL1ane+u02XSAzITo
         oyD3tw+E7W3bX8VWqpCDbQMST7JI6onj4XIA44Eggvs9XLMSF7IzY55RSuoRZ2App+
         tUXc7F6f8bx5wXyInw30iByS3etwPy7yV1+gdRaIueiOWXphlCfl1MnHN8mo0todj1
         OjDXUk+0elFt5HrYTcnoqhmRu5h21j0A7z2T76BbzqWr+TbDVkQO6EfpmcpHm4Rwol
         8heiYRL3/JQNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.2 56/64] kernel/fail_function: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:58 -0500
Message-Id: <20230303214106.1446460-56-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2bb3669f576559db273efe49e0e69f82450efbca ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230202151633.2310897-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fail_function.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index a7ccd2930c5f4..d971a01893197 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -163,10 +163,7 @@ static void fei_debugfs_add_attr(struct fei_attr *attr)
 
 static void fei_debugfs_remove_attr(struct fei_attr *attr)
 {
-	struct dentry *dir;
-
-	dir = debugfs_lookup(attr->kp.symbol_name, fei_debugfs_dir);
-	debugfs_remove_recursive(dir);
+	debugfs_lookup_and_remove(attr->kp.symbol_name, fei_debugfs_dir);
 }
 
 static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs)
-- 
2.39.2

