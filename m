Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999B96DD92
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbfGSEJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387809AbfGSEJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 050AA21873;
        Fri, 19 Jul 2019 04:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509390;
        bh=EUQKOd+QxsRwsQ3DH8zKyeAKy6CFTYrYpm1D3J6wkiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E38NOUZ3NGhERXh8VrH3O50QJKFeUI87xVDBlcfOsfBtZ7GeRMfVZrWAULiZJKZIh
         GkhDKmAFgs1R+mDQDonVRRDwEkBL1j8XbOyY62FiC0zSYIRlLEw24Y44On/dyTPOBt
         W1tUlDinSuFTPdnzgmu0fJgWakAXzeTixkUYVUtw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 070/101] PCI: mobiveil: Use the 1st inbound window for MEM inbound transactions
Date:   Fri, 19 Jul 2019 00:07:01 -0400
Message-Id: <20190719040732.17285-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit f7fee1b42fe4f8171a4b1cad05c61907c33c53f6 ]

The inbound and outbound windows have completely separate control
registers sets in the host controller MMIO space. Windows control
register are accessed through an MMIO base address and an offset
that depends on the window index.

Since inbound and outbound windows control registers are completely
separate there is no real need to use different window indexes in the
inbound/outbound windows initialization routines to prevent clashing.

To fix this inconsistency, change the MEM inbound window index to 0,
mirroring the outbound window set-up.

Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
[lorenzo.pieralisi@arm.com: update commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Reviewed-by: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index 2fe7ebdad2d2..a2d1e89d4867 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -553,7 +553,7 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 			resource_size(pcie->ob_io_res));
 
 	/* memory inbound translation window */
-	program_ib_windows(pcie, WIN_NUM_1, 0, MEM_WINDOW_TYPE, IB_WIN_SIZE);
+	program_ib_windows(pcie, WIN_NUM_0, 0, MEM_WINDOW_TYPE, IB_WIN_SIZE);
 
 	/* Get the I/O and memory ranges from DT */
 	resource_list_for_each_entry_safe(win, tmp, &pcie->resources) {
-- 
2.20.1

