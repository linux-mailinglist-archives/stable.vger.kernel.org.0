Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DC929B93E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802282AbgJ0PqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368723AbgJ0P1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C1D62242B;
        Tue, 27 Oct 2020 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812429;
        bh=zD1vsWFoSZklVmICOjDnq+LeXaI3xlUtKLWXlgL2+9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heTpcANvXjxZwv0ZnDO2W/YComnXsjwQ7DEGlypdsTbD+y+bkJJOe+KVhbd/wEJ9s
         JI8gSUppFFfCo2UtSytYS1P3BRw54WfgHvesh6VHF5u3TlOsUh9DiI1zXdSvt+zbTW
         GvA7L7DzX9ClEwVvtJWZQAZvCJx7AgSQgFMxfuu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 205/757] scsi: qla2xxx: Fix the size used in a dma_free_coherent() call
Date:   Tue, 27 Oct 2020 14:47:35 +0100
Message-Id: <20201027135500.226204051@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 226f1428d3e52..78ad9827bbb98 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4958,7 +4958,7 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		    "Done %s.\n", __func__);
 	}
 
-	dma_free_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+	dma_free_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
 	   els_cmd_map, els_cmd_map_dma);
 
 	return rval;
-- 
2.25.1



