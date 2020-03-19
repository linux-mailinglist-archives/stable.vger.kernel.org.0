Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A6518B69D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgCSN2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbgCSN1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B3CA20B80;
        Thu, 19 Mar 2020 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624467;
        bh=GBW4HS3rcU46yI/YSEUk0+2oIxX7o1ouHTysQw84VJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJE8zY3zFiHu1G9GgaeObnTvoqvho2FamydIMZ/2me2qdommr6cVvo9fza2KFu8mb
         sk995LTuFBHpQg0E9S3Ve6S0Li8I8g0onqIXgfRU0IIGYPJl7DFVqshrYMipIuRB6M
         62fZ7mxNC5Bx+/kPDFr7nj5IqRcAtHnBB1EFsH2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 55/65] mlxsw: pci: Wait longer before accessing the device after reset
Date:   Thu, 19 Mar 2020 14:04:37 +0100
Message-Id: <20200319123943.593234706@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit ac004e84164e27d69017731a97b11402a69d854b ]

During initialization the driver issues a reset to the device and waits
for 100ms before checking if the firmware is ready. The waiting is
necessary because before that the device is irresponsive and the first
read can result in a completion timeout.

While 100ms is sufficient for Spectrum-1 and Spectrum-2, it is
insufficient for Spectrum-3.

Fix this by increasing the timeout to 200ms.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index e0d7d2d9a0c81..43fa8c85b5d9f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -28,7 +28,7 @@
 #define MLXSW_PCI_SW_RESET			0xF0010
 #define MLXSW_PCI_SW_RESET_RST_BIT		BIT(0)
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
-#define MLXSW_PCI_SW_RESET_WAIT_MSECS		100
+#define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
-- 
2.20.1



