Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FDF147C45
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733162AbgAXJut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730713AbgAXJus (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:50:48 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA19206D5;
        Fri, 24 Jan 2020 09:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859448;
        bh=invVvVKYK/1dK5+OevdyADX2bdFmvZK6mtpBfUBztm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYfaJWKTKDnEDjrKCw/nOLtSt7aHwaF1cEBO5yDMmvLKL48B7X8q+FTE5vfeSa019
         8S9e4SUgXdWnIswBYUHCtB3dVGqZitoCNMx9pDa/uBNQusPrmPm20/onx/DrIYgIDY
         SiuK4Y5mZAIjEugKb6VG36bu9JMzzUgLUVR4gLLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Wen Yang <wen.yang99@zte.com.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        linux-pci@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/343] PCI: endpoint: functions: Use memcpy_fromio()/memcpy_toio()
Date:   Fri, 24 Jan 2020 10:28:42 +0100
Message-Id: <20200124092933.745397829@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 726dabfde6aa35a4f1508e235ae37edbbf9fbc65 ]

Functions copying from/to IO addresses should use the
memcpy_fromio()/memcpy_toio() API rather than plain memcpy().

Fix the issue detected through the sparse tool.

Fixes: 349e7a85b25f ("PCI: endpoint: functions: Add an EP function to test PCI")
Suggested-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
[lorenzo.pieralisi@arm.com: updated log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
CC: Niklas Cassel <niklas.cassel@axis.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Cyrille Pitchen <cyrille.pitchen@free-electrons.com>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index f9308c2f22e67..c2541a772abc8 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -177,7 +177,7 @@ static int pci_epf_test_read(struct pci_epf_test *epf_test)
 		goto err_map_addr;
 	}
 
-	memcpy(buf, src_addr, reg->size);
+	memcpy_fromio(buf, src_addr, reg->size);
 
 	crc32 = crc32_le(~0, buf, reg->size);
 	if (crc32 != reg->checksum)
@@ -231,7 +231,7 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 	get_random_bytes(buf, reg->size);
 	reg->checksum = crc32_le(~0, buf, reg->size);
 
-	memcpy(dst_addr, buf, reg->size);
+	memcpy_toio(dst_addr, buf, reg->size);
 
 	/*
 	 * wait 1ms inorder for the write to complete. Without this delay L3
-- 
2.20.1



