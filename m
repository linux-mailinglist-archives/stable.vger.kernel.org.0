Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CEC2E433A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407422AbgL1PeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405014AbgL1Nuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11248206D4;
        Mon, 28 Dec 2020 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163396;
        bh=2FhLYakiejrjUTLx5UvoDzFh8fQtHXIRD5RyFN2aFbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq57ZJ+OKHwcPmxjTIR4vjNIZN/dnACyw3DrKDGT4zzaXugwohzOLQ2Tz80WHxDdY
         nF1t5kpLECN1ACVP8RYUiwcX7ln8YimSlTF33QSkBLGu/TadurlzBVkMYvTPuqYMux
         PptaohGPmnmBlX/rgHNlqNs4reA2n1BTh58LMbow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/453] scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
Date:   Mon, 28 Dec 2020 13:47:56 +0100
Message-Id: <20201228124948.771701275@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index acb930b8c6a64..35c96ea2653be 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2630,7 +2630,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
 			rc = -ENODEV;
-			goto free_cid_que;
+			goto free_tmf_thread;
 		}
 
 		/* F/w needs 1st task context memory entry for performance */
@@ -2650,6 +2650,8 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 
 	return 0;
 
+free_tmf_thread:
+	destroy_workqueue(qedi->tmf_thread);
 free_cid_que:
 	qedi_release_cid_que(qedi);
 free_uio:
-- 
2.27.0



