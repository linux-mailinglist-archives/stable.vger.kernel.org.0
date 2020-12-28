Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE92E6584
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393741AbgL1QCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390262AbgL1NaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95DB9207FF;
        Mon, 28 Dec 2020 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162165;
        bh=q9A9/ARIjd3r/XPaKErR5Z81PWbqIoSoO65bkl3WWXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0QJLmmMAjWw8hyx720AIHZ5tCypb2uS0icav2JfMbXZDOTYk7/3jOfs7yViqyuDz
         H+dFCiXlSoiPoXBfht/7fflgyMoWczi3wJv6W3tj0ZeXrIkgxk4UtuuWGBBhE/B/da
         mQugCZPJIX1j+PCkWCOBzzUdl2wVM0blAwWy2C/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/346] scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
Date:   Mon, 28 Dec 2020 13:48:48 +0100
Message-Id: <20201228124929.894079334@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 62eebd5247c4e4ce08826ad5995cf4dd7ce919dd ]

Add the missing destroy_workqueue() before return from __qedi_probe in the
error handling case when fails to create workqueue qedi->offload_thread.

Link: https://lore.kernel.org/r/20201109091518.55941-1-miaoqinglang@huawei.com
Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 763c7628356b1..eaa50328de90c 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2580,7 +2580,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
 			rc = -ENODEV;
-			goto free_cid_que;
+			goto free_tmf_thread;
 		}
 
 		/* F/w needs 1st task context memory entry for performance */
@@ -2600,6 +2600,8 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 
 	return 0;
 
+free_tmf_thread:
+	destroy_workqueue(qedi->tmf_thread);
 free_cid_que:
 	qedi_release_cid_que(qedi);
 free_uio:
-- 
2.27.0



