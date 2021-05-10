Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A55B378575
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhEJLA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhEJK4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94DEE61988;
        Mon, 10 May 2021 10:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643494;
        bh=Yvb3fb8FwmIt2g/7FcEThSFq/+iV0/1SU+ZaXPKBt4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+PYRaPCJ/ur9o40QMdOFzV14I4Q86c2Kb+fwr8weRg8Ug1N9eIXFeemHubTOz3yp
         84gOdm+sClx5MQTAXK9WqIBnFMUll9wC7rX9A27rzeM/mNo9ujCUNqKimusRfLSxSX
         rmR51+In7qu5eiglRjXsmSeZJnXLuPa7JSSn+XhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 037/342] scsi: mpt3sas: Block PCI config access from userspace during reset
Date:   Mon, 10 May 2021 12:17:07 +0200
Message-Id: <20210510102011.320303713@linuxfoundation.org>
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 3c8604691d2acc7b7d4795d9695070de9eaa5828 upstream.

While diag reset is in progress there is short duration where all access to
controller's PCI config space from the host needs to be blocked. This is
due to a hardware limitation of the IOC controllers.

Block all access to controller's config space from userland applications by
calling pci_cfg_access_lock() while diag reset is in progress and unlocking
it again after the controller comes back to ready state.

Link: https://lore.kernel.org/r/20210330105137.20728-1-sreekanth.reddy@broadcom.com
Cc: stable@vger.kernel.org #v5.4.108+
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7235,6 +7235,8 @@ _base_diag_reset(struct MPT3SAS_ADAPTER
 
 	ioc_info(ioc, "sending diag reset !!\n");
 
+	pci_cfg_access_lock(ioc->pdev);
+
 	drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
 
 	count = 0;
@@ -7325,10 +7327,12 @@ _base_diag_reset(struct MPT3SAS_ADAPTER
 		goto out;
 	}
 
+	pci_cfg_access_unlock(ioc->pdev);
 	ioc_info(ioc, "diag reset: SUCCESS\n");
 	return 0;
 
  out:
+	pci_cfg_access_unlock(ioc->pdev);
 	ioc_err(ioc, "diag reset: FAILED\n");
 	return -EFAULT;
 }


