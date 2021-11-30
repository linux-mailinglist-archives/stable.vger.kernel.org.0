Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19564463736
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242632AbhK3OwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56804 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbhK3Ovb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3338DCE1A3D;
        Tue, 30 Nov 2021 14:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48403C53FC7;
        Tue, 30 Nov 2021 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283689;
        bh=MdBuqmhN6/fw5t4wHKZqrPoyvfEzCedaWd/sv1eTcrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COG0J0YIg5UgIl+gFqNAgu7pOeVeHWIcICqTvVCqYAcqrtfIHyfwballUGknNBskz
         0QQumEcHj8+oCwlyt8dpx6a56OxebYnoSj/ua3AwgFCCqijDnha4jvMgRYvhCu57ey
         o+BNqcdb0hmiUzQn5llWr1weUsZSXaoLZ6uIy0heo41oo0u5/ojiziZOPzyktVl5tC
         bbaJfMyHUmsZCl8Wze4opVUy60/w9Di9QWJs7+JdPmlTVpPegVYTUFxofUHE2qgwuw
         U2qXWy1Zpf+cw6lsIvmFsKcLxecu94mfYTmz+eeQpo71qwqU7oW15hLjLPRghkbnr9
         WoxhCTXyqqpvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bean Huo <beanhuo@micron.com>, kernel test robot <lkp@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        avri.altman@wdc.com, daejun7.park@samsung.com,
        keosung.park@samsung.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/68] scsi: ufs: ufshpb: Fix warning in ufshpb_set_hpb_read_to_upiu()
Date:   Tue, 30 Nov 2021 09:46:14 -0500
Message-Id: <20211130144707.944580-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 73185a13773af10264f9d8ee70386c01c849ff2c ]

Fix the following sparse warnings in ufshpb_set_hpb_read_to_upiu():

sparse warnings: (new ones prefixed by >>)
drivers/scsi/ufs/ufshpb.c:335:27: sparse: sparse: cast from restricted __be64
drivers/scsi/ufs/ufshpb.c:335:25: sparse: expected restricted __be64 [usertype] ppn_tmp
drivers/scsi/ufs/ufshpb.c:335:25: sparse: got unsigned long long [usertype]

Link: https://lore.kernel.org/r/20211111222452.384089-1-huobean@gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshpb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index a86d0cc50de21..5c8bb6dcc559b 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -331,7 +331,7 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	cdb[0] = UFSHPB_READ;
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ)
-		ppn_tmp = swab64(ppn);
+		ppn_tmp = (__force __be64)swab64((__force u64)ppn);
 
 	/* ppn value is stored as big-endian in the host memory */
 	memcpy(&cdb[6], &ppn_tmp, sizeof(__be64));
-- 
2.33.0

