Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4EE3E812E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhHJR4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236717AbhHJRxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D56761139;
        Tue, 10 Aug 2021 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617433;
        bh=f9UhnWwa5T73f8ihiV0RQ3Gmg/eZofmD7tSHlxpW6IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4JXLwBmoe6WVqULn04tixURFVCIu4TgUP0qwqgOJaSMWBaskXZcniNSfImXOGlwN
         faVOaiTwNnEULA3ubAkLcp896ZWNDAj6QX1KNKb8X/WORtHFlam9opHaWXDzwL+qPZ
         UUFCd7f5BWmhUGKDUPuYp0eqJXemP3ZuRhiVR7zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 055/175] RDMA/hns: Fix the double unlock problem of poll_sem
Date:   Tue, 10 Aug 2021 19:29:23 +0200
Message-Id: <20210810173002.754813887@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit 8b436a99cd708bd158231a0630ffa49b1d6175e4 ]

If hns_roce_cmd_use_events() fails then it means that the poll_sem is not
obtained, but the poll_sem is released in hns_roce_cmd_use_polling(), this
will cause an unlock problem.

This is the static checker warning:
	drivers/infiniband/hw/hns/hns_roce_main.c:926 hns_roce_init()
	error: double unlocked '&hr_dev->cmd.poll_sem' (orig line 879)

Event mode and polling mode are mutually exclusive and resources are
separated, so there is no need to process polling mode resources in event
mode.

The initial mode of cmd is polling mode, so even if cmd fails to switch to
event mode, it is not necessary to switch to polling mode.

Fixes: a389d016c030 ("RDMA/hns: Enable all CMDQ context")
Fixes: 3d50503b3b33 ("RDMA/hns: Optimize cmd init and mode selection for hip08")
Link: https://lore.kernel.org/r/1627887374-20019-1-git-send-email-liangwenpeng@huawei.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c  | 7 +++----
 drivers/infiniband/hw/hns/hns_roce_main.c | 4 +---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 8f68cc3ff193..84f3f2b5f097 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -213,8 +213,10 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 
 	hr_cmd->context =
 		kcalloc(hr_cmd->max_cmds, sizeof(*hr_cmd->context), GFP_KERNEL);
-	if (!hr_cmd->context)
+	if (!hr_cmd->context) {
+		hr_dev->cmd_mod = 0;
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < hr_cmd->max_cmds; ++i) {
 		hr_cmd->context[i].token = i;
@@ -228,7 +230,6 @@ int hns_roce_cmd_use_events(struct hns_roce_dev *hr_dev)
 	spin_lock_init(&hr_cmd->context_lock);
 
 	hr_cmd->use_events = 1;
-	down(&hr_cmd->poll_sem);
 
 	return 0;
 }
@@ -239,8 +240,6 @@ void hns_roce_cmd_use_polling(struct hns_roce_dev *hr_dev)
 
 	kfree(hr_cmd->context);
 	hr_cmd->use_events = 0;
-
-	up(&hr_cmd->poll_sem);
 }
 
 struct hns_roce_cmd_mailbox *
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 6c6e82b11d8b..33b84f219d0d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -897,11 +897,9 @@ int hns_roce_init(struct hns_roce_dev *hr_dev)
 
 	if (hr_dev->cmd_mod) {
 		ret = hns_roce_cmd_use_events(hr_dev);
-		if (ret) {
+		if (ret)
 			dev_warn(dev,
 				 "Cmd event  mode failed, set back to poll!\n");
-			hns_roce_cmd_use_polling(hr_dev);
-		}
 	}
 
 	ret = hns_roce_init_hem(hr_dev);
-- 
2.30.2



