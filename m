Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D159B12EF54
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgABWdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbgABWdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:33:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC2720866;
        Thu,  2 Jan 2020 22:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004390;
        bh=rWJp6GDobf35G+1n6raP2ZZNu5JthYLuD+SILOkRHN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfScDTkiEGL9qDZExV6xSsYTOmI2OakDTYj46PNFspWo+kKn+0Mc2AFa8Z9XfIOZS
         Dn6j9XDheI0/V3SNP11DZ/qWb/fRe1sh9sep90zU/Aijm/S9Js6SdIXdWmXO8I0TC5
         PfiQREXK+/lh+grSQWr4eTo9ZV3DyjdG2gjJFsLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 133/171] scsi: ufs: fix potential bug which ends in system hang
Date:   Thu,  2 Jan 2020 23:07:44 +0100
Message-Id: <20200102220605.500917569@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit cfcbae3895b86c390ede57b2a8f601dd5972b47b ]

In function __ufshcd_query_descriptor(), in the event of an error
happening, we directly goto out_unlock and forget to invaliate
hba->dev_cmd.query.descriptor pointer. This results in this pointer still
valid in ufshcd_copy_query_response() for other query requests which go
through ufshcd_exec_raw_upiu_cmd(). This will cause __memcpy() crash and
system hangs. Log as shown below:

Unable to handle kernel paging request at virtual address
ffff000012233c40
Mem abort info:
   ESR = 0x96000047
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
Data abort info:
   ISV = 0, ISS = 0x00000047
   CM = 0, WnR = 1
swapper pgtable: 4k pages, 48-bit VAs, pgdp = 0000000028cc735c
[ffff000012233c40] pgd=00000000bffff003, pud=00000000bfffe003,
pmd=00000000ba8b8003, pte=0000000000000000
 Internal error: Oops: 96000047 [#2] PREEMPT SMP
 ...
 Call trace:
  __memcpy+0x74/0x180
  ufshcd_issue_devman_upiu_cmd+0x250/0x3c0
  ufshcd_exec_raw_upiu_cmd+0xfc/0x1a8
  ufs_bsg_request+0x178/0x3b0
  bsg_queue_rq+0xc0/0x118
  blk_mq_dispatch_rq_list+0xb0/0x538
  blk_mq_sched_dispatch_requests+0x18c/0x1d8
  __blk_mq_run_hw_queue+0xb4/0x118
  blk_mq_run_work_fn+0x28/0x38
  process_one_work+0x1ec/0x470
  worker_thread+0x48/0x458
  kthread+0x130/0x138
  ret_from_fork+0x10/0x1c
 Code: 540000ab a8c12027 a88120c7 a8c12027 (a88120c7)
 ---[ end trace 793e1eb5dff69f2d ]---
 note: kworker/0:2H[2054] exited with preempt_count 1

This patch is to move "descriptor = NULL" down to below the label
"out_unlock".

Fixes: d44a5f98bb49b2(ufs: query descriptor API)
Link: https://lore.kernel.org/r/20191112223436.27449-3-huobean@gmail.com
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 26f259fb6e3c..094e879af121 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2006,10 +2006,10 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 
-	hba->dev_cmd.query.descriptor = NULL;
 	*buf_len = be16_to_cpu(response->upiu_res.length);
 
 out_unlock:
+	hba->dev_cmd.query.descriptor = NULL;
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
 	ufshcd_release(hba);
-- 
2.20.1



