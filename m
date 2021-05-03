Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF23371C28
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhECQvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhECQte (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0446961879;
        Mon,  3 May 2021 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060028;
        bh=nInd9rGEAUTmqG3sBpalSUoJQWZY9+wmfLSK5N3OnBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psIy35NJQRserY32JwWyIt1Q1VLOb5YP4STlVFUNAxH81LkJv37N+CEt6GRAVu+Ap
         irdZVLbA3Fww0KeIZ1lWQDO+DF6YrEpx5BFzJu8U/frkZp0WKdPPKWIcXYZay4auAI
         6UkCJkKjcEBVHpfVUyTVNWJK8J87DUTHEwLw+aoykGMFysaFFxVES49whtAhclQz5v
         NAj1EMnlqqBiMAwzll4hwq2FYT/wLGdLMs+BjRlb5nVTestE5yLuJDEDxWaS9nDgEZ
         xvf+oGSKSX7vkUTajRcz3zAiAMNdxyVXkENXp6ek0zpM5/S6zPZxLoKyJtSN2RQs8U
         RECc96nikBhMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murthy Bhat <Murthy.Bhat@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/57] scsi: smartpqi: Correct request leakage during reset operations
Date:   Mon,  3 May 2021 12:39:14 -0400
Message-Id: <20210503163941.2853291-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

[ Upstream commit b622a601a13ae5974c5b0aeecb990c224b8db0d9 ]

While failing queued I/Os in TMF path, there was a request leak and hence
stale entries in request pool with ref count being non-zero. In shutdown
path we have a BUG_ON to catch stuck I/O either in firmware or in the
driver. The stale requests caused a system crash. The I/O request pool
leakage also lead to a significant performance drop.

Link: https://lore.kernel.org/r/161549370379.25025.12793264112620796062.stgit@brunhilda
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 093ed5d1eef2..3480a0a66771 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5513,6 +5513,8 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 
@@ -5549,6 +5551,8 @@ static void pqi_fail_io_queued_for_all_devices(struct pqi_ctrl_info *ctrl_info)
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 
-- 
2.30.2

