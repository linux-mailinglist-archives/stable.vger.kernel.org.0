Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879D3378463
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhEJKvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhEJKuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8E1A61A06;
        Mon, 10 May 2021 10:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643158;
        bh=5iIoh1B11K02YgNaWLf9YUIRxOgF4N84+f6r312MNU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ot+/gdWsOrn2IAK3Bg38Kcqh7Np22NYBGWnEL6y390PNludmspt7Nxi6JNHAUF1lA
         lN2cleG5zY9WS4tfaYnOKruxCKP3m/J1LPYdRDCcKJXYp9XqQSpQci9+iuDw9A3KuS
         F0GzoIaXXp/cV6Ra+WQXgKNYzAMqMyDi0nRMXR8I=
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
Subject: [PATCH 5.10 166/299] scsi: smartpqi: Use host-wide tag space
Date:   Mon, 10 May 2021 12:19:23 +0200
Message-Id: <20210510102010.432399914@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
index 9d0229656681..9300a677510d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6601,6 +6601,7 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->irq = pci_irq_vector(ctrl_info->pci_dev, 0);
 	shost->unique_id = shost->irq;
 	shost->nr_hw_queues = ctrl_info->num_queue_groups;
+	shost->host_tagset = 1;
 	shost->hostdata[0] = (unsigned long)ctrl_info;
 
 	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);
-- 
2.30.2



