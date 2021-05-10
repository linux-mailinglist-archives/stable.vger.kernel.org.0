Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471B4378851
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbhEJLVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236995AbhEJLLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD89613CA;
        Mon, 10 May 2021 11:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644773;
        bh=4+PkIHY2y6oqKlC6HY2EbZ4VSkUTCZHr2F48zrTGS6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaVVeZQwBKZNLudrgsgd2c8VVNdK9OgMihSjKQWjBqsVpxDDPLE60ornyXr4wh2qC
         sg/KPxkPrG0kngkF1WHAs50L3UAclYHoMBQfOGHT4K9r4zGAttShB0eTEiD5hSaYw4
         O87nXjj00YVil3/G0rk9imSqfQkqFRE/j9Rb7WKA=
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
Subject: [PATCH 5.12 217/384] scsi: smartpqi: Correct request leakage during reset operations
Date:   Mon, 10 May 2021 12:20:06 +0200
Message-Id: <20210510102022.049209088@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index 3795804ea869..52e4d5618dc7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5488,6 +5488,8 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 
@@ -5524,6 +5526,8 @@ static void pqi_fail_io_queued_for_all_devices(struct pqi_ctrl_info *ctrl_info)
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 
-- 
2.30.2



