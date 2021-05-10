Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD8B378631
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhEJLEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235024AbhEJK5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E929616EB;
        Mon, 10 May 2021 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643870;
        bh=njMlaKgEdYEuAJ20yXYEwbSILrD2jeEs440hPpsivlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDvacCdcnYTO5bxhiPyc7npW3He1jTJ+loY9spZ7GEmxEaqIBnrXHlX+XekerZhaU
         JQpZB8aMm6ZD6iKHuPMXEFM4ZxIKanPdyJsJ+7aMgkFtR2O3cnv23PHJ3YRWzfvWjX
         wsI6kcU3ZQyyClIKQDuqVK1LsmB0JWfz/lZvjAyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Mike McGowen <mike.mcgowen@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 193/342] scsi: smartpqi: Use host-wide tag space
Date:   Mon, 10 May 2021 12:19:43 +0200
Message-Id: <20210510102016.468176284@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Don Brace <don.brace@microchip.com>

[ Upstream commit c6d3ee209b9e863c6251f72101511340451ca324 ]

Correct SCSI midlayer sending more requests than exposed host queue depth
causing firmware ASSERT and lockup issues by enabling host-wide tags.

Note: This also results in better performance.

Link: https://lore.kernel.org/r/161549369787.25025.8975999483518581619.stgit@brunhilda
Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: John Garry <john.garry@huawei.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c53f456fbd09..61e3a5afaf07 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6599,6 +6599,7 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->irq = pci_irq_vector(ctrl_info->pci_dev, 0);
 	shost->unique_id = shost->irq;
 	shost->nr_hw_queues = ctrl_info->num_queue_groups;
+	shost->host_tagset = 1;
 	shost->hostdata[0] = (unsigned long)ctrl_info;
 
 	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);
-- 
2.30.2



