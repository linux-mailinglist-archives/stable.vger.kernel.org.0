Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D3413E124
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAPQrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729406AbgAPQrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7382073A;
        Thu, 16 Jan 2020 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193273;
        bh=3jsVj/McEaAvS2LkEimj1NvVy+s2I+eLlxgU0gAOrLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2BIQR026hRGjHkfnNRVVMbVm58nLqeUxTHvyBW+mV8worC92PfOzdm+UPW/pVrvi
         QxcR9JmCUbgyaeLuSL9dDnFjuwzOMdeBmjSXfIcsS879miwHtlDPPLEBRvvJT1EAPo
         5mzJBAwCpWXBclhBU42n7IzaZzfcUlBQqg7Yebqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 062/205] scsi: hisi_sas: Don't create debugfs dump folder twice
Date:   Thu, 16 Jan 2020 11:40:37 -0500
Message-Id: <20200116164300.6705-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 35160421b63d4753a72e9f72ebcdd9d6f88f84b9 ]

Due to a merge error, we attempt to create 2x debugfs dump folders, which
fails:
[  861.101914] debugfs: Directory 'dump' with parent '0000:74:02.0'
already present!

This breaks the dump function.

To fix, remove the superfluous attempt to create the folder.

Fixes: 7ec7082c57ec ("scsi: hisi_sas: Add hisi_sas_debugfs_alloc() to centralise allocation")
Link: https://lore.kernel.org/r/1571926105-74636-2-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 633effb09c9c..849335d76cf6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3719,9 +3719,6 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	int p, c, d;
 	size_t sz;
 
-	hisi_hba->debugfs_dump_dentry =
-			debugfs_create_dir("dump", hisi_hba->debugfs_dir);
-
 	sz = hw->debugfs_reg_array[DEBUGFS_GLOBAL]->count * 4;
 	hisi_hba->debugfs_regs[DEBUGFS_GLOBAL] =
 				devm_kmalloc(dev, sz, GFP_KERNEL);
-- 
2.20.1

