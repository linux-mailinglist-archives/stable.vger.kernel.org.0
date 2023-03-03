Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967716AA493
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjCCWiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjCCWhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:37:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA320BBAE;
        Fri,  3 Mar 2023 14:35:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6602B81A16;
        Fri,  3 Mar 2023 21:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF363C433A0;
        Fri,  3 Mar 2023 21:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879908;
        bh=42NXa3rkxB0hPj2cneXedkTKdbGvXlgJG/EirB3pMUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3aIrSuGRyA7kUN4oKPcqSBHf0vfBem9/KuwvKt0dD2AeKpHFMEDVwnGJ2MZd6HKE
         9mX443exYiN/sFnaYD7boYc1i3TjNw0vh08Cgv7S3TMAzUM5UUVUjjUqYEOv2zj3BJ
         ewkUR8uiWeZFI/uiUVcrQBGJo7PIyOd7ab4fmDrSMujSD2rD4zH0q2uU0yuFceIAjJ
         ICq+Ozq5bOhlUnWKw1pgBVgf5a94sf9vX3pd8T4oMKdx/fPi1Kv/HsXJ7UTu/h+40+
         /yE3mVLRsp7ilTD8iAtsiLrKqY0Gqlx8L9lwDvgoLJ4/WpCxmg2DDctIv/WR83uHRV
         Cv0bPU1GxOoiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 52/60] kernel/fail_function: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:43:06 -0500
Message-Id: <20230303214315.1447666-52-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

