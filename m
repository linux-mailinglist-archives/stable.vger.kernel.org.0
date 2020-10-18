Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750A9291C18
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbgJRTfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731492AbgJRT0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30F85222E7;
        Sun, 18 Oct 2020 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049159;
        bh=ADwdWwiFKwBdtf3Rz+fuqdN20bUstmwYzptpeS9bQj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1q/WQtdEh3/um3XY54BCMuROyUoWkbdDPu59HRCV8d+S6zCKcvgr/YSGgIN7tyy3O
         3lfWGYuDHbKP7sijAIYpdtxod3oEmaH9HbEdbyf2HP1uTbfIdEYTkQuzBRxP731O2P
         +usSeYjWFFPRG0k/rysvUyggFCaHT3G2890uPbW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/52] scsi: mvumi: Fix error return in mvumi_io_attach()
Date:   Sun, 18 Oct 2020 15:25:01 -0400
Message-Id: <20201018192530.4055730-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 055f15ab2cb4a5cbc4c0a775ef3d0066e0fa9b34 ]

Return PTR_ERR() from the error handling case instead of 0.

Link: https://lore.kernel.org/r/20200910123848.93649-1-jingxiangfeng@huawei.com
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvumi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index fe97401ad1927..1fffa301c1b9f 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2439,6 +2439,7 @@ static int mvumi_io_attach(struct mvumi_hba *mhba)
 	if (IS_ERR(mhba->dm_thread)) {
 		dev_err(&mhba->pdev->dev,
 			"failed to create device scan thread\n");
+		ret = PTR_ERR(mhba->dm_thread);
 		mutex_unlock(&mhba->sas_discovery_mutex);
 		goto fail_create_thread;
 	}
-- 
2.25.1

