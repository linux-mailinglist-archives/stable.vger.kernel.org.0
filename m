Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378673D6083
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhGZPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236311AbhGZPWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E2560E09;
        Mon, 26 Jul 2021 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315392;
        bh=Ml+v5mmUAfUMXtSAUxI4wpiAvp73LQMS1oak9jPsWXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOV0I4BXJihIEAdefH9e/XUrrURB0F/mdNPO9DFugLlKpVq4s8qBR7zLxSwls58iW
         V5V2QArlnBK+v8fIsM0iNuab3kiEpwC4ZX8m3nW5NAAIHekeK3yLVi8xatYes4ymKi
         uWziyfsq+0NdbHzKY3nuJ+ANWXZG+eMOlkp3LcgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/167] bnxt_en: dont disable an already disabled PCI device
Date:   Mon, 26 Jul 2021 17:38:32 +0200
Message-Id: <20210726153842.060021157@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit c81cfb6256d90ea5ba4a6fb280ea3b171be4e05c ]

If device is already disabled in reset path and PCI io error is
detected before the device could be enabled, driver could
call pci_disable_device() for already disabled device. Fix this
problem by calling pci_disable_device() only if the device is already
enabled.

Fixes: 6316ea6db93d ("bnxt_en: Enable AER support.")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index db1b89f57079..f003f08de167 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12901,7 +12901,8 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 	if (netif_running(netdev))
 		bnxt_close(netdev);
 
-	pci_disable_device(pdev);
+	if (pci_is_enabled(pdev))
+		pci_disable_device(pdev);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
-- 
2.30.2



