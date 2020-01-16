Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9864C13E34C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgAPRBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388035AbgAPRBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212382081E;
        Thu, 16 Jan 2020 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194072;
        bh=pFIsn7kenSCtRS9qjn/pVoj416ubdkxUCU+LwNIeHs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNKp+kLp1n7LMbd+7PNijqmI5pzCXvH9KH+hzTOEHz3IACz+MD8xm3/YT8/hDvsVM
         c4rThKwQUvckY7zfUeJLpYDnGLJ33u5rbacuXq4Oh4cpcNZG5x3rJNb1TMIs9DKNJ1
         lK4+VEgm+bDOhWF2YCNyUZOobyEHGyXTZsm/BHCs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        linux-pci@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 180/671] PCI: endpoint: functions: Use memcpy_fromio()/memcpy_toio()
Date:   Thu, 16 Jan 2020 11:51:29 -0500
Message-Id: <20200116165940.10720-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3e86fa3c7da3..4bbd26e8a9e2 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -175,7 +175,7 @@ static int pci_epf_test_read(struct pci_epf_test *epf_test)
 		goto err_map_addr;
 	}
 
-	memcpy(buf, src_addr, reg->size);
+	memcpy_fromio(buf, src_addr, reg->size);
 
 	crc32 = crc32_le(~0, buf, reg->size);
 	if (crc32 != reg->checksum)
@@ -230,7 +230,7 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 	get_random_bytes(buf, reg->size);
 	reg->checksum = crc32_le(~0, buf, reg->size);
 
-	memcpy(dst_addr, buf, reg->size);
+	memcpy_toio(dst_addr, buf, reg->size);
 
 	/*
 	 * wait 1ms inorder for the write to complete. Without this delay L3
-- 
2.20.1

