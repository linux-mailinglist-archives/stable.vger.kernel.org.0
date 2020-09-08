Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3482618AE
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgIHR7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731560AbgIHQMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC32D24869;
        Tue,  8 Sep 2020 15:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580317;
        bh=fDqoV5fVIw6t9pvVgOsGrg3g0OZCcVnoJBrIK2iPz5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/QxIcSKfcDT2SF364HACPU6MeMlZhWz3rw9Aypaxux44o01/tS9F9qFeXwfT9ax1
         K/OEslPtxpO5RncF3CXDYKFCSQNU96V89hQI4EkkhUmFZEAzUG5FqCQH31wCa7Tswv
         WbAa8B37+yF6pKK9yMObrbqX5GzpydFCv/h6JDPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/65] bnxt_en: Fix PCI AER error recovery flow
Date:   Tue,  8 Sep 2020 17:26:13 +0200
Message-Id: <20200908152218.488197386@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit df3875ec550396974b1d8a518bd120d034738236 ]

When a PCI error is detected the PCI state could be corrupt, save
the PCI state after initialization and restore it after the slot
reset.

Fixes: 6316ea6db93d ("bnxt_en: Enable AER support.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a189061d8f97e..7de38ae5c18f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8251,6 +8251,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bnxt_parse_log_pcie_link(bp);
 
+	pci_save_state(pdev);
 	return 0;
 
 init_err_cleanup_tc:
@@ -8412,6 +8413,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 			"Cannot re-enable PCI device after reset.\n");
 	} else {
 		pci_set_master(pdev);
+		pci_restore_state(pdev);
+		pci_save_state(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
 		if (!err && netif_running(netdev))
-- 
2.25.1



