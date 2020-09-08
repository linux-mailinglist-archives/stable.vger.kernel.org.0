Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8762616CD
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgIHRTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731748AbgIHQSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:18:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D0724823;
        Tue,  8 Sep 2020 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579857;
        bh=crnGPu0tyhKeHX2naCZdLKAQ0FrvUkbm16b+X1HG0cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/FP/JLM/DiF9gUtzm8hxNgfiuuPyFfctNryCK9brx/KHWCVe9tn5b+lZvAtpx8Gs
         skkoREw6sdxQN7Lal44qWYKyA5juwcuY/hhSCbpwSIf3y1wNMmfqeFry1S0ULwjqj1
         P9DFsqIlpjzdkuqzXjgI/Pf5Fi5nso7SxieHCcMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/129] bnxt_en: Fix PCI AER error recovery flow
Date:   Tue,  8 Sep 2020 17:24:45 +0200
Message-Id: <20200908152231.904065833@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
index 2cbfe0cd7eefa..7cb74d7a78e3c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11900,6 +11900,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    (long)pci_resource_start(pdev, 0), dev->dev_addr);
 	pcie_print_link_status(pdev);
 
+	pci_save_state(pdev);
 	return 0;
 
 init_err_cleanup:
@@ -12066,6 +12067,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 			"Cannot re-enable PCI device after reset.\n");
 	} else {
 		pci_set_master(pdev);
+		pci_restore_state(pdev);
+		pci_save_state(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
 		if (!err && netif_running(netdev))
-- 
2.25.1



