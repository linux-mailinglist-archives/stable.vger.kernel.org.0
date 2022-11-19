Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C6D630A05
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiKSCWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiKSCVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:21:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA92BDEC2;
        Fri, 18 Nov 2022 18:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3B3D6280C;
        Sat, 19 Nov 2022 02:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4659AC4347C;
        Sat, 19 Nov 2022 02:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824076;
        bh=aRsMMGmvgD/lbdqaN0JidPGzRj14aJPQ1+YlVjXftfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phQmmRo463SqSVptHZYhn9/eQCNXTTDYXDRXblqf6qdOkgm4Anp2zO5/OL8Cs7jyy
         ckm8zSFLKFkNBKhrs8JGJTSy0o5j05ggXWQGYVVeMj1ON/5o6w9wYUnu+auD3+CvH5
         vkcYI0W/zrXZIiKZg8vGnLah9z9brmmdV7T4vOiXkSKCAoV2ALT+jXrAignL400h3l
         v9RIIKMNx/sk5JbLiWbBvTkWdXh5oUSQRDuNOHQ6va9x21/ogkcKUg64Z9GdWxbORT
         9BDtOxlFewfqShoIGhFF2Dmf2OH+LFIwzxMYpmBdlMwojPHfq5ayR1/qCih10QRM4/
         VSNu/hQ9QsujA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 23/27] nvmet: fix memory leak in nvmet_subsys_attr_model_store_locked
Date:   Fri, 18 Nov 2022 21:13:48 -0500
Message-Id: <20221119021352.1774592-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
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
index cea30e4f5053..625038057a76 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1189,6 +1189,7 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
 		const char *page, size_t count)
 {
 	int pos = 0, len;
+	char *val;
 
 	if (subsys->subsys_discovered) {
 		pr_err("Can't set model number. %s is already assigned\n",
@@ -1211,9 +1212,11 @@ static ssize_t nvmet_subsys_attr_model_store_locked(struct nvmet_subsys *subsys,
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

