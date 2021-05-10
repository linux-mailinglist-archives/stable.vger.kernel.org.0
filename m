Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A523781DD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhEJKah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhEJK3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3CD461492;
        Mon, 10 May 2021 10:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642443;
        bh=nInd9rGEAUTmqG3sBpalSUoJQWZY9+wmfLSK5N3OnBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLcZR/UO2RmT1Q9B/RRSfDlL2u7RfZB6EcXBs1tcWkEsPCVXzvF2ziEKdWUSwXsaG
         mnakNzYFIDgSr1qexColcmtQ71VXpifyTureZ0wspYVQZEqcEs/nH9xe97haCfuQdS
         8F+laQD37u4daxuAEeIpbCYkq+pdXoIG1sy6fmN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Teel <scott.teel@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Murthy Bhat <Murthy.Bhat@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/184] scsi: smartpqi: Correct request leakage during reset operations
Date:   Mon, 10 May 2021 12:19:51 +0200
Message-Id: <20210510101953.368915076@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



