Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5B2268DFE
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgINOks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgINNFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C0422247;
        Mon, 14 Sep 2020 13:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088706;
        bh=iW7SGnrfadHKhWqhCj6r9zF7flddMAv36Lz03IPT0Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXzYK++EGI3s5iZPIKxet3xvVUPJ3msojn4BH38ybi8G8f9Bxu6Fywp2X4WKpPaZe
         bsXOxHSKFNhoCycdZhLYE138sp8+St88tUG73/6Sfa3irbF9Q3HusYwpr1YPh/k/Bo
         wtSi2yzTxp3LleOm8TCiSWTuc3IjSc6FOBKxXsjA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/19] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Mon, 14 Sep 2020 09:04:45 -0400
Message-Id: <20200914130502.1804708-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130502.1804708-1-sashal@kernel.org>
References: <20200914130502.1804708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit ea403fde7552bd61bad6ea45e3feb99db77cb31e ]

When pm8001_tag_alloc() fails, task should be freed just like it is done in
the subsequent error paths.

Link: https://lore.kernel.org/r/20200823091453.4782-1-dinghao.liu@zju.edu.cn
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 5be4212312cb0..ba79b37d8cf7e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -794,7 +794,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
-- 
2.25.1

