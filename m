Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D629B5A3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794856AbgJ0PN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794851AbgJ0PN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7259921D41;
        Tue, 27 Oct 2020 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811636;
        bh=rv4AEcROxj8BAs2llGk0xVhlp4UVGLDxwUVC5kEsDUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gf8FZjHnd6TGhOg6EcXmNtOr2nRsLjjeeaRvR4W7sj1j0iDvJXrCHkC0XZqVqusli
         RD73UPvjFJc/Js/EUb3k8QzJ+axUaVi54Zc8ZOd99RJ78UnlrXPLKIc9xpHew18ehj
         deDDRGHiRcMTVSP3vz2T6a+nG5EDMZGVXbQzAzpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 564/633] scsi: mvumi: Fix error return in mvumi_io_attach()
Date:   Tue, 27 Oct 2020 14:55:07 +0100
Message-Id: <20201027135549.267457995@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 8906aceda4c43..0354898d7cac1 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2425,6 +2425,7 @@ static int mvumi_io_attach(struct mvumi_hba *mhba)
 	if (IS_ERR(mhba->dm_thread)) {
 		dev_err(&mhba->pdev->dev,
 			"failed to create device scan thread\n");
+		ret = PTR_ERR(mhba->dm_thread);
 		mutex_unlock(&mhba->sas_discovery_mutex);
 		goto fail_create_thread;
 	}
-- 
2.25.1



