Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2D29B40B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782759AbgJ0O5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782741AbgJ0O5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D8B620714;
        Tue, 27 Oct 2020 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810654;
        bh=kLe7/vY0Ls6IeBaiIiu8SqNpxvuanMu5PQdyxxmZd2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kB0FE2+jGgNVTtUPrmyORdssw6AN4HbMiRFwKkoYej79+XRd2yGzy/a04RPVDco/W
         L4miEVOF/9jUWrHE1gcmCqIS3dNZO/sif/0a1evk6ZHawza8eG4OKLM0Z5/BOvgclF
         E5KupJFBUdFdVBjL/Dy3Smi/kLsfEHr0AXNb7CEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 175/633] scsi: qla2xxx: Fix the size used in a dma_free_coherent() call
Date:   Tue, 27 Oct 2020 14:48:38 +0100
Message-Id: <20201027135530.891528596@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 650b323c8e7c3ac4830a20895b1d444fd68dd787 ]

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

[mkp: removed memset() hunk that has already been addressed]

Link: https://lore.kernel.org/r/20200802110721.677707-1-christophe.jaillet@wanadoo.fr
Fixes: 4161cee52df8 ("[SCSI] qla4xxx: Add host statistics support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index fdb2ce7acb912..9f5d3aa1d8745 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4908,7 +4908,7 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		    "Done %s.\n", __func__);
 	}
 
-	dma_free_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	dma_free_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
 	   els_cmd_map, els_cmd_map_dma);
 
 	return rval;
-- 
2.25.1



