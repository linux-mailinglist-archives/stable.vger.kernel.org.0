Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31310185C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfKSFcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbfKSFce (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A135521783;
        Tue, 19 Nov 2019 05:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141554;
        bh=IPfFpNkXVBfD3r8yyTcbXoGbM9yP96Lps47iWKfbr+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNN+tA99KT6sbMWe1yDWHQtnp+5OJQaT5Iz8TjTecFe4dDw14AcEzjax26WF/ZDI3
         +ZwqULIzYw0Qjr6ol6C/CWf9L3F1JXqUAgd7CkNPljqgSGH7J7irHbfhJ1oZGBHmf5
         glPtmz4tZbP2l1JbzhBUeNoiHV0GJUm7nGDwUN38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/422] scsi: pm80xx: Corrected dma_unmap_sg() parameter
Date:   Tue, 19 Nov 2019 06:16:20 +0100
Message-Id: <20191119051410.334604538@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Ukey <deepak.ukey@microchip.com>

[ Upstream commit 76cb25b058034d37244be6aca97a2ad52a5fbcad ]

For the function dma_unmap_sg(), the <nents> parameter should be number of
elements in the scatter list prior to the mapping, not after the mapping.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 947d6017d004c..576a0f091933b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -466,7 +466,7 @@ err_out:
 	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(t->task_proto))
 		if (n_elem)
-			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,
+			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
 				t->data_dir);
 out_done:
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-- 
2.20.1



