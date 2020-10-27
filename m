Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80A229C2A1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820764AbgJ0RiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760550AbgJ0OfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AEFE20709;
        Tue, 27 Oct 2020 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809304;
        bh=QoV0sOGotoRLrNP8yMdiqkTdSfiy1IoMZEqqfGacw0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4U2dVJrDHSlu4AcR2HPhljQ8TZZMGB0ezSRqTTiLsHuWd8wHpyHpjyia0lomIc34
         kxpMQCeMsYBSvWoPaTojwPsVL3nsNUpkedx1dyWIBG84Wrs6cx5jqsD7n0g2tpsD+0
         /mXR9ItXEkomFcR6ibF/h7oIwGPSip1OePVliQcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/408] scsi: qla4xxx: Fix an error handling path in qla4xxx_get_host_stats()
Date:   Tue, 27 Oct 2020 14:50:56 +0100
Message-Id: <20201027135500.579382654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 574918e69720fe62ab3eb42ec3750230c8d16b06 ]

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

Link: https://lore.kernel.org/r/20200802101527.676054-1-christophe.jaillet@wanadoo.fr
Fixes: 4161cee52df8 ("[SCSI] qla4xxx: Add host statistics support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5504ab11decc7..df43cf6405a8e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1220,7 +1220,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 			le64_to_cpu(ql_iscsi_stats->iscsi_sequence_error);
 exit_host_stats:
 	if (ql_iscsi_stats)
-		dma_free_coherent(&ha->pdev->dev, host_stats_size,
+		dma_free_coherent(&ha->pdev->dev, stats_size,
 				  ql_iscsi_stats, iscsi_stats_dma);
 
 	ql4_printk(KERN_INFO, ha, "%s: Get host stats done\n",
-- 
2.25.1



