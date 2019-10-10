Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 911A6D25BB
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387971AbfJJIjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387983AbfJJIjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ACA421BE5;
        Thu, 10 Oct 2019 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696792;
        bh=R1bCjxSjjgxEB7TD52IG9AYkmyv3+Iqr6N7u8GuakFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3RI2FjI9vaNTM8hwruc9NniYs1GsU+0N+CJ2kLAQK+a5710s5ZhIkVMU/trDeUIg
         zRt5xYYVllXrDsntscGi3ypUuZ4rT+OqfzRygQDLgFKI7hcKc4oB/drYHgwMBtSkTR
         OJhPkPWR7/uNDoebm5qjPFUafGQbVJ1WMSHyFeLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.3 054/148] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it
Date:   Thu, 10 Oct 2019 10:35:15 +0200
Message-Id: <20191010083614.419687555@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 533ca1feed98b0bf024779a14760694c7cb4d431 upstream.

The slot must be removed before the pci_dev is removed, otherwise a panic
can happen due to use-after-free.

Fixes: 15becc2b56c6 ("PCI: hv: Add hv_pci_remove_slots() when we unload the driver")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-hyperv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2701,8 +2701,8 @@ static int hv_pci_remove(struct hv_devic
 		/* Remove the bus from PCI's point of view. */
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
-		pci_remove_root_bus(hbus->pci_bus);
 		hv_pci_remove_slots(hbus);
+		pci_remove_root_bus(hbus->pci_bus);
 		pci_unlock_rescan_remove();
 		hbus->state = hv_pcibus_removed;
 	}


