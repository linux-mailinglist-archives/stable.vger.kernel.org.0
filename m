Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F25211DCE
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfEBPdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbfEBPdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:33:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B95C204FD;
        Thu,  2 May 2019 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811190;
        bh=K88QpaDu6awBn+i1ugyXXw2XyuEuhunQVRDth2+HNXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD0nsh92A7R9L/CWLkJTq+lwkXXgJzTLSeOY+j/uqNvIg52bmIDzFelK89Z5sUAFx
         yVcVwwdVqH0COoLldjiIPv3QShWu6Jas3iVOfD43r510ScQvX3gXk9xy8CnuiKT4S/
         uTCRruBZbrcviokkv8P+x7+4WNz3qVwHskKhoQ24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Carroll <david.carroll@microsemi.com>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 067/101] scsi: aacraid: Insure we dont access PCIe space during AER/EEH
Date:   Thu,  2 May 2019 17:21:09 +0200
Message-Id: <20190502143344.314278251@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b6554cfe09e1f610aed7d57164ab7760be57acd9 ]

There are a few windows during AER/EEH when we can access PCIe I/O mapped
registers. This will harden the access to insure we do not allow PCIe
access during errors

Signed-off-by: Dave Carroll <david.carroll@microsemi.com>
Reviewed-by: Sagar Biradar <sagar.biradar@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 7 ++++++-
 drivers/scsi/aacraid/commsup.c | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3291d1c16864..8bd09b96ea18 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2640,9 +2640,14 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 	return capacity;
 }
 
+static inline int aac_pci_offline(struct aac_dev *dev)
+{
+	return pci_channel_offline(dev->pdev) || dev->handle_pci_error;
+}
+
 static inline int aac_adapter_check_health(struct aac_dev *dev)
 {
-	if (unlikely(pci_channel_offline(dev->pdev)))
+	if (unlikely(aac_pci_offline(dev)))
 		return -1;
 
 	return (dev)->a_ops.adapter_check_health(dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a3adc954f40f..09367b8a3885 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -672,7 +672,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					return -ETIMEDOUT;
 				}
 
-				if (unlikely(pci_channel_offline(dev->pdev)))
+				if (unlikely(aac_pci_offline(dev)))
 					return -EFAULT;
 
 				if ((blink = aac_adapter_check_health(dev)) > 0) {
@@ -772,7 +772,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
-		if (unlikely(pci_channel_offline(dev->pdev)))
+		if (unlikely(aac_pci_offline(dev)))
 			return -EFAULT;
 
 		fibptr->flags |= FIB_CONTEXT_FLAG_WAIT;
-- 
2.19.1



