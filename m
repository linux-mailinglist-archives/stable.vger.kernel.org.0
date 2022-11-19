Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E356309A1
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiKSCP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbiKSCNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:13:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED057DC82;
        Fri, 18 Nov 2022 18:12:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEA066281A;
        Sat, 19 Nov 2022 02:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47176C43151;
        Sat, 19 Nov 2022 02:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823950;
        bh=wx+cZ/J7M+blFaEXEUjPx5yDIGj7Mpl3HkIHjrXyaCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+xmA3DaNldruGzJHXNpnkiATecUqV0L/mMQ/UZstivvSE2w0+PErLQgNhCMPFjfz
         l8kGG3dfjdF+9vYBuEriYV85g5cAJxiZz0HtDabiWaaq8PjPm2YSy1zoYhLFi5XTcn
         pxvKSHQpnOohdRgPQ39ZR6xnZS1MLXbZQyQ8qWXYjjFkFgSFuMK4r9DXmuvwxPmiLF
         AOipWX3Qn5XhfKKsmo5Bzb4jU0I49Lm3L/CR6MAoEEGoWM7nvw6ZZNw2HsVNxvR1Wi
         wMvocyzliGKCBOaodArdGtdqxzpu5/uh3g4OzZbkMR5C01mheas+OhNL5iOYqVWf0n
         8aUMnW/7bl/8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 32/44] nvmet: fix memory leak in nvmet_subsys_attr_model_store_locked
Date:   Fri, 18 Nov 2022 21:11:12 -0500
Message-Id: <20221119021124.1773699-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Aleksandr Miloserdov <a.miloserdov@yadro.com>

[ Upstream commit becc4cac309dc867571f0080fde4426a6c2222e0 ]

Since model_number is allocated before it needs to be freed before
kmemdump_nul.

Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2bcd60758919..962b64b7447e 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1215,6 +1215,7 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 		const char *page, size_t count)
 {
 	int pos = 0, len;
+	char *val;
 
 	if (subsys->subsys_discovered) {
 		pr_err("Can't set model number. %s is already assigned\n",
@@ -1237,9 +1238,11 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 			return -EINVAL;
 	}
 
-	subsys->model_number = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!subsys->model_number)
+	val = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!val)
 		return -ENOMEM;
+	kfree(subsys->model_number);
+	subsys->model_number = val;
 	return count;
 }
 
-- 
2.35.1

