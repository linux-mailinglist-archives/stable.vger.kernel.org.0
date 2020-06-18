Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973AE1FE387
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgFRCLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbgFRBVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E9C20B1F;
        Thu, 18 Jun 2020 01:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443301;
        bh=YTPK4gDULgXHgBeBf9fRR92kyb9GbSxulZ74DiQGJ14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9YBbNj1ko///M9MmjYguU+JeuQ1ktClbtLncMt7wsfTXfu7A7Y57NzGlV4X+uoPE
         MjDEgCPKjPZ0Y/e0ODyCcs4XI/yeSCn0oYk1CHi0mSmwWHFmTrt61k5ZuSfh2s7GnB
         1oNE3MyxCreTfFhHmqwtEemz+priscEcUKAz2I+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Alexander Fomichev <fomichev.ru@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 240/266] NTB: Revert the change to use the NTB device dev for DMA allocations
Date:   Wed, 17 Jun 2020 21:16:05 -0400
Message-Id: <20200618011631.604574-240-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/ntb/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ntb/core.c b/drivers/ntb/core.c
index c9a0912b175f..f8f75a504a58 100644
--- a/drivers/ntb/core.c
+++ b/drivers/ntb/core.c
@@ -311,4 +311,3 @@ static void __exit ntb_driver_exit(void)
 	bus_unregister(&ntb_bus);
 }
 module_exit(ntb_driver_exit);
-
-- 
2.25.1

