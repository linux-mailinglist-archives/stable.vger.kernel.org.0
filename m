Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC0177DE5
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgCCRop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbgCCRop (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:44:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F5F208C3;
        Tue,  3 Mar 2020 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257484;
        bh=hQwEbvFE4SFXvXgDuGGdCJh7c1fW/rXtBRKlLMASIQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFsQg2Q6w0ZgQeWBuEmrIoImM5tTcaIEiO27n/Y/dRfNZQSGTr22bE+ntgbo2p1vu
         /0hWRKcBa7Ke00Wux12+Vhr1H5x3qKEt6S99CA7fw3QPY0PNZEZGPA9TDV+99c6Nms
         Dn6f9T4b0jAV03ll5z3w3CYjvPka9HbmZvxVS+c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 014/176] bnxt_en: Improve device shutdown method.
Date:   Tue,  3 Mar 2020 18:41:18 +0100
Message-Id: <20200303174306.228177249@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 5567ae4a8d569d996d0d88d0eceb76205e4c7ce5 ]

Especially when bnxt_shutdown() is called during kexec, we need to
disable MSIX and disable Bus Master to completely quiesce the device.
Make these 2 calls unconditionally in the shutdown method.

Fixes: c20dc142dd7b ("bnxt_en: Disable bus master during PCI shutdown and driver unload.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11972,10 +11972,10 @@ static void bnxt_shutdown(struct pci_dev
 		dev_close(dev);
 
 	bnxt_ulp_shutdown(bp);
+	bnxt_clear_int_mode(bp);
+	pci_disable_device(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		bnxt_clear_int_mode(bp);
-		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}


