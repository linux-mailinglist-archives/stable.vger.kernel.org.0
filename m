Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A7C6DF8D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfGSEgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbfGSEAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:00:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37DD221851;
        Fri, 19 Jul 2019 04:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508837;
        bh=iIs0O6PDTaQYyp7kEH6su754Y8rJtU3sCvAPMYLFbs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbMxivhuENLRZKkYedzizOEIDzkWbhbBpt6cbjP7oMqYetrzoTnthCFTlgZa3mTat
         9umfkd0IVwF6hh426ROMEqryc3E6aNcqSYQJEySuOhwvilNS1ldRS4K0BMDYmRhy4U
         FuY72aA+t7J5jSDASj/Az/qwhmgpKtkASUSsLLec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 117/171] PCI: mobiveil: Fix PCI base address in MEM/IO outbound windows
Date:   Thu, 18 Jul 2019 23:55:48 -0400
Message-Id: <20190719035643.14300-117-sashal@kernel.org>
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

[ Upstream commit f99536e9d2f55996038158a6559d4254a7cc1693 ]

The outbound memory windows PCI base addresses should be taken
from the 'ranges' property of DT node to setup MEM/IO outbound
windows decoding correctly instead of being hardcoded to zero.

Update the code to retrieve the PCI base address for each range
and use it to program the outbound windows address decoders

Fixes: 9af6bcb11e12 ("PCI: mobiveil: Add Mobiveil PCIe Host Bridge IP driver")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Reviewed-by: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index 77052a0712d0..03d697b63e2a 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -552,8 +552,9 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 		if (type) {
 			/* configure outbound translation window */
 			program_ob_windows(pcie, pcie->ob_wins_configured,
-				win->res->start, 0, type,
-				resource_size(win->res));
+					   win->res->start,
+					   win->res->start - win->offset,
+					   type, resource_size(win->res));
 		}
 	}
 
-- 
2.20.1

