Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0DE6DF85
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGSEAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbfGSEAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:00:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F155821851;
        Fri, 19 Jul 2019 04:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508842;
        bh=ItxFliTD6WeA+ql+n36UYHQERTf9F0u/4k5yMPa57MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTy6bbSdW0ofhuG+3GgLMdNEFFaT0uSMVqJdtVsdUbD0gCRJ5A0jjRJhL+pS5aHqt
         OwFhTT0KfiCr30rTOlFI2ihnhQ944Ov1T8nkk/RN/t/UWoTBlRcgAcJefILdkG9UOH
         rNDvjexIjONYtgRPuckiyTdIgpWuUHEKZDh5pWnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 121/171] PCI: mobiveil: Use the 1st inbound window for MEM inbound transactions
Date:   Thu, 18 Jul 2019 23:55:52 -0400
Message-Id: <20190719035643.14300-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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
index e4a1964e1b43..387a20f3c240 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -546,7 +546,7 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 			resource_size(pcie->ob_io_res));
 
 	/* memory inbound translation window */
-	program_ib_windows(pcie, WIN_NUM_1, 0, MEM_WINDOW_TYPE, IB_WIN_SIZE);
+	program_ib_windows(pcie, WIN_NUM_0, 0, MEM_WINDOW_TYPE, IB_WIN_SIZE);
 
 	/* Get the I/O and memory ranges from DT */
 	resource_list_for_each_entry_safe(win, tmp, &pcie->resources) {
-- 
2.20.1

