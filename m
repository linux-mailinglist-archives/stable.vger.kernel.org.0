Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32126419AF5
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhI0ROn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236794AbhI0RNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C6D76128B;
        Mon, 27 Sep 2021 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762546;
        bh=XZgCO0DMojag3ZFXwfmZqZRgfTlRuQ9uywSc944xQpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxfaGk/JTMbdwE/yXH1JRFzYyt9bUMVB3Fumm3MCHP2XZbT/9+cNnftdz2UVLhNNC
         ypHfO785sWMkVO4L7BOOps6z1q5PfMP/ZbIpthc5a93egl07ot0QA3fx81v3QJBnWP
         b8loEfMZzjF3SsYGOlhjggMcgFWnddgutT0ZYrkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/103] scsi: lpfc: Use correct scnprintf() limit
Date:   Mon, 27 Sep 2021 19:02:37 +0200
Message-Id: <20210927170228.032608560@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index bdea2867516c..2c59a5bf3539 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6005,7 +6005,8 @@ lpfc_sg_seg_cnt_show(struct device *dev, struct device_attribute *attr,
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



