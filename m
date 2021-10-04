Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4262E420D47
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhJDNOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235238AbhJDNLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0406F61B56;
        Mon,  4 Oct 2021 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352663;
        bh=y86zAI1RbSfboZD7+j8pHcbrgsxRAaITEgR4jcjDvXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uapm6jk4L8asnrUG9MNCDygeoVVGfGAoHrrKKD65U2pcgJkX9oBSTItNq2yCYGUqF
         xMPmZeOEzdyX56/+y4PF0LElLx5bdkCZfrg0uI2Ft8YS7h4WbkByxFEKKR/y+vJ7wg
         jtTuhV8xZd3okUBYSVFPd22z0NHRliW1Z+si7tC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 73/95] scsi: csiostor: Add module softdep on cxgb4
Date:   Mon,  4 Oct 2021 14:52:43 +0200
Message-Id: <20211004125035.960917794@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 79a7482249a7353bc86aff8127954d5febf02472 ]

Both cxgb4 and csiostor drivers run on their own independent Physical
Function. But when cxgb4 and csiostor are both being loaded in parallel via
modprobe, there is a race when firmware upgrade is attempted by both the
drivers.

When the cxgb4 driver initiates the firmware upgrade, it halts the firmware
and the chip until upgrade is complete. When the csiostor driver is coming
up in parallel, the firmware mailbox communication fails with timeouts and
the csiostor driver probe fails.

Add a module soft dependency on cxgb4 driver to ensure loading csiostor
triggers cxgb4 to load first when available to avoid the firmware upgrade
race.

Link: https://lore.kernel.org/r/1632759248-15382-1-git-send-email-rahul.lakkireddy@chelsio.com
Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 1793981337dd..b59bcd2553d1 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1263,3 +1263,4 @@ MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
 MODULE_FIRMWARE(FW_FNAME_T6);
+MODULE_SOFTDEP("pre: cxgb4");
-- 
2.33.0



