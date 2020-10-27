Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6229C376
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822074AbgJ0Rqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758962AbgJ0O0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:26:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C34020780;
        Tue, 27 Oct 2020 14:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808802;
        bh=0PciOSX2gDkQA1NyDpMa1zEgIxCFqywez5dzFi1BmZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkFWXVXrFQg53On2epwsUfWSWQIe+BJrtZ/TEMBF598c7ZOSPUN0F9ll6NqoV9j+4
         +zWiUSJs4QjDAOQa8fg83d50Ufr7+a0hou/olkqxzK1OXVPokul71zqrvqa3Fi6SJM
         WMmwZ8oYGrNB8cq6C0GahaPMbDtzkLHHW8cq3Em4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/264] scsi: mvumi: Fix error return in mvumi_io_attach()
Date:   Tue, 27 Oct 2020 14:54:47 +0100
Message-Id: <20201027135441.406192553@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



