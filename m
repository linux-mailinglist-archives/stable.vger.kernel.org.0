Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE57419A31
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbhI0RHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235915AbhI0RGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A88160F3A;
        Mon, 27 Sep 2021 17:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762306;
        bh=9AA1UDfGkgHVTGHZkvG70DXeyssfkk/7ic8wzBPZXQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d51rNsVedm3piWrq8okx7nbhAbpu7BEY0znxMra9ofyeGzVLX8Smns+kbbf5KbJBy
         01LLOIxsRNS7APG4sQxaDbw0Yz9pwQPI/YZEmttGgW6UQDy3Rg49uwbMFmhFMWid4a
         Jc3SMQF/4Z/AlgBuQaqL5g0jRzWaVTwrRAV3i89A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/68] scsi: lpfc: Use correct scnprintf() limit
Date:   Mon, 27 Sep 2021 19:02:37 +0200
Message-Id: <20210927170221.387437612@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6dacc371b77f473770ec646e220303a84fe96c11 ]

The limit should be "PAGE_SIZE - len" instead of "PAGE_SIZE".  We're not
going to hit the limit so this fix will not affect runtime.

Link: https://lore.kernel.org/r/20210916132331.GE25094@kili
Fixes: 5b9e70b22cc5 ("scsi: lpfc: raise sg count for nvme to use available sg resources")
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 45db19e31b34..f0ecfe565660 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5881,7 +5881,8 @@ lpfc_sg_seg_cnt_show(struct device *dev, struct device_attribute *attr,
 	len = scnprintf(buf, PAGE_SIZE, "SGL sz: %d  total SGEs: %d\n",
 		       phba->cfg_sg_dma_buf_size, phba->cfg_total_seg_cnt);
 
-	len += scnprintf(buf + len, PAGE_SIZE, "Cfg: %d  SCSI: %d  NVME: %d\n",
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			"Cfg: %d  SCSI: %d  NVME: %d\n",
 			phba->cfg_sg_seg_cnt, phba->cfg_scsi_seg_cnt,
 			phba->cfg_nvme_seg_cnt);
 	return len;
-- 
2.33.0



