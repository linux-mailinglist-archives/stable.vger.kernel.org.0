Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481D8420FE1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbhJDNjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237952AbhJDNhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E946136F;
        Mon,  4 Oct 2021 13:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353423;
        bh=3C6iHA7wH4RyXJEFJq7ukVmCEwCLUOLvkiHSGmNUM4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2yMjfcxLI17MJ1AXu/7lWWshYM7z4E7J1PL2TJAP/r5ZH3VjwWAufpiCvOJjAZmR
         AGYusdQffXosGFxQwdwUyUnuK5NW685tHTuOPeWQIEXcoFhPgZBA26CmOiV1896Rou
         6oWuboBLkRenSxti8rocOnDn+HFU9CCkvfLpPHq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 122/172] scsi: csiostor: Add module softdep on cxgb4
Date:   Mon,  4 Oct 2021 14:52:52 +0200
Message-Id: <20211004125048.920060453@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
index 390b07bf92b9..ccbded3353bd 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1254,3 +1254,4 @@ MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
 MODULE_FIRMWARE(FW_FNAME_T6);
+MODULE_SOFTDEP("pre: cxgb4");
-- 
2.33.0



