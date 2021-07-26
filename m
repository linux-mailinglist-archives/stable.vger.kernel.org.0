Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E23D61D1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhGZPdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230235AbhGZPa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE6E60C41;
        Mon, 26 Jul 2021 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315886;
        bh=yRxTn9nhUgLEFQU4Vzo6PTxYwODGalh/FW3IwqGn+aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mg+yvW2HGWEAg3droZWA+DGnxn+qN9DNt8e/xVxIWIMgd2CGcCmAwhhvue9+yfoYh
         bIws48rmy1WnDm0bMIVn592FufDywt5+W8S95rXiWF5Fivq7vJoaktotEnYIlBvs8k
         tKi5NqOGwEv/7BuePgkxe7YCaCvPntpgiBs49CC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 104/223] bnxt_en: dont disable an already disabled PCI device
Date:   Mon, 26 Jul 2021 17:38:16 +0200
Message-Id: <20210726153849.679566148@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index aef3fccc27a9..d57fb1613cfc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13315,7 +13315,8 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
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



