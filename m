Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D919268D8D
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgINOZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgINNGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:06:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B2621D7E;
        Mon, 14 Sep 2020 13:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088729;
        bh=PQSAbPp/SO39R20BoR+qN6FK+isHUo3NjRid7Kpzh9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Reu0Lh6NdgwtUdo9WR0G6L5oJEyPnWl0xjZpZKX/5RJtooe4QSGcrSakBK8U41WEK
         C4fS7uVsxXfOOijacdzenaaOAvknWNhQs/9fu36wmXPZoLst67HqIkrHco9dT0219T
         X29PE08Lld8zz/VtWqT++/HuhCD1Uf1ABETePxmM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/15] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Mon, 14 Sep 2020 09:05:13 -0400
Message-Id: <20200914130526.1804913-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130526.1804913-1-sashal@kernel.org>
References: <20200914130526.1804913-1-sashal@kernel.org>
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
index e64a13f0bce17..61a2da30f94b7 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -795,7 +795,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
-- 
2.25.1

