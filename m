Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07E20625E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391913AbgFWU7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392261AbgFWUkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:40:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38DE72053B;
        Tue, 23 Jun 2020 20:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944842;
        bh=9NE9nisQ1DquUP0EnbAPzo4ORKVh7iHb3MsORRTQgNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dypZ+vxqQdSlzRaUvb5vYawXg5kGkviYTHJPilmyThZDF5XooopyQmgI82GuxzXnh
         p9wirDCvNEsPTjqXeH7fpjGKRdH7K/lDV+tt8IFwwolbo2DcZXbXo18RyYpEozk/Vr
         66SE1ITr84dylIyi3rcVsGwaOJxap0kKRG+3PJDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Alexander Fomichev <fomichev.ru@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/206] NTB: Revert the change to use the NTB device dev for DMA allocations
Date:   Tue, 23 Jun 2020 21:57:54 +0200
Message-Id: <20200623195324.171222781@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 40da7d9a93c8941737ef4a1208d32c13ce017fe1 ]

Commit 417cf39cfea9 ("NTB: Set dma mask and dma coherent mask to NTB
devices") started using the NTB device for DMA allocations which was
turns out was wrong. If the IOMMU is enabled, such alloctanions will
always fail with messages such as:

  DMAR: Allocating domain for 0000:02:00.1 failed

This is because the IOMMU has not setup the device for such use.

Change the tools back to using the PCI device for allocations seeing
it doesn't make sense to add an IOMMU group for the non-physical NTB
device. Also remove the code that sets the DMA mask as it no longer
makes sense to do this.

Fixes: 7f46c8b3a552 ("NTB: ntb_tool: Add full multi-port NTB API support")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Alexander Fomichev <fomichev.ru@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ntb/ntb.c b/drivers/ntb/ntb.c
index c9a0912b175fa..f8f75a504a581 100644
--- a/drivers/ntb/ntb.c
+++ b/drivers/ntb/ntb.c
@@ -311,4 +311,3 @@ static void __exit ntb_driver_exit(void)
 	bus_unregister(&ntb_bus);
 }
 module_exit(ntb_driver_exit);
-
-- 
2.25.1



