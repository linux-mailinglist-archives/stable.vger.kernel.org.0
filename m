Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C810291C9A
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbgJRTYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbgJRTYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C64DC207DE;
        Sun, 18 Oct 2020 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049090;
        bh=0PciOSX2gDkQA1NyDpMa1zEgIxCFqywez5dzFi1BmZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGyKfJ+CeN2FiyyglK5FN6Ipz72y12JfXmHnCgNJkWnUJGujhZc09iw96eXk3r3f0
         vo4fIJ9nhEAAgNCTj6Q0fF20Jy0Oc7nfcuY91PmV/USnLWv7mqNXuv+QETNz0klRkP
         R7iiUBy0c4DYzDccfNPCLv5dLrrMOCDQfWZAyO8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/56] scsi: mvumi: Fix error return in mvumi_io_attach()
Date:   Sun, 18 Oct 2020 15:23:47 -0400
Message-Id: <20201018192417.4055228-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
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
index b3cd9a6b1d306..b3df114a1200f 100644
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

