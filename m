Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739B13BC03E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhGEPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhGEPeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7485E619B6;
        Mon,  5 Jul 2021 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499062;
        bh=lih3W99nVGZKyW4Zkbj1v+KnbsdkmMAQa/vyFDAV83o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBuBrUu5NM/0lAMIFN8JfmRIURaT0yvRr8VlGL7mOU0ROHS22uDRGVWVTTjL9KV2d
         csiqa0w3XNqjWAoYJvp3bLJUnegouCKsjlzr7mgIwaZIXGRCkG2xqt51Wt2DUCQU37
         wO5YNPMjAUWmFEVcAIqhgKFkV+GckCAc8662I8pnsbVjtzWCzvVNC3ahoW1dDLfjEX
         +pri3rUaenbSWn7qq07EuLSYr4U8WYbPv7SEpmxp9kDEtHwPikdUWCrMu5aHPo3EoM
         atoTmKuRWTNTu/Qh2N9kt+agpDmeuZ+KoocJl0n+DDQxluiz3ZkO+bUa18pfKlN1Z2
         /ydOFhKV/oE3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        Mohammad Alqayeem <mohammad.alqyeem@nutanix.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/26] PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
Date:   Mon,  5 Jul 2021 11:30:31 -0400
Message-Id: <20210705153039.1521781-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 7d815f4afa87f2032b650ae1bba7534b550a6b8b ]

Add check for hv_is_hyperv_initialized() at the top of
init_hv_pci_drv(), so if the pci-hyperv driver is force-loaded on non
Hyper-V platforms, the init_hv_pci_drv() will exit immediately, without
any side effects, like assignments to hvpci_block_ops, etc.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-and-tested-by: Mohammad Alqayeem <mohammad.alqyeem@nutanix.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Link: https://lore.kernel.org/r/1621984653-1210-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index f1f300218fab..8c45d6c32c30 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3121,6 +3121,9 @@ static void __exit exit_hv_pci_drv(void)
 
 static int __init init_hv_pci_drv(void)
 {
+	if (!hv_is_hyperv_initialized())
+		return -ENODEV;
+
 	/* Set the invalid domain number's bit, so it will not be used */
 	set_bit(HVPCI_DOM_INVALID, hvpci_dom_map);
 
-- 
2.30.2

