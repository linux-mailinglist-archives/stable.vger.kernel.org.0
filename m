Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD91BCACE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgD1Svy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgD1Sgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AC20208E0;
        Tue, 28 Apr 2020 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099006;
        bh=s6XcISL1TY3nhTD3l8bwB8tGpUxjHneG3fVmYe2L/ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBQmZj0+IRXNZfUV3FCpRPeNYc4SA/rWG/cBsGun4HMOjvTCdhVvlPOc+WIY+I0Vb
         2+wMyyHotquC2ZbPWu2bmv8JmjnkTYMohe0rPBvVIfuaw4BJC2AHRi8br5r46DZEaM
         qvTOvDdQ43SLhQ0gcUJ2RRAK+cBaeX4KhAltuuEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Lee <ben@b1c1l1.com>
Subject: [PATCH 5.6 143/167] mei: me: fix irq number stored in hw struct
Date:   Tue, 28 Apr 2020 20:25:19 +0200
Message-Id: <20200428182243.717421299@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Lee <ben@b1c1l1.com>

commit fec874a81b3ec280b91034d892a432fc71fd1522 upstream.

Commit 261b3e1f2a01 ("mei: me: store irq number in the hw struct.")
stores the irq number in the hw struct before MSI is enabled.  This
caused a regression for mei_me_synchronize_irq() waiting for the wrong
irq number.  On my laptop this causes a hang on shutdown.  Fix the issue
by storing the irq number after enabling MSI.

Fixes: 261b3e1f2a01 ("mei: me: store irq number in the hw struct.")
Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200417184538.349550-1-ben@b1c1l1.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/pci-me.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -212,11 +212,12 @@ static int mei_me_probe(struct pci_dev *
 	}
 	hw = to_me_hw(dev);
 	hw->mem_addr = pcim_iomap_table(pdev)[0];
-	hw->irq = pdev->irq;
 	hw->read_fws = mei_me_read_fws;
 
 	pci_enable_msi(pdev);
 
+	hw->irq = pdev->irq;
+
 	 /* request and enable interrupt */
 	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_ONESHOT : IRQF_SHARED;
 


