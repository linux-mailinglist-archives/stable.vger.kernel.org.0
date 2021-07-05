Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672603BBFAB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhGEPcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhGEPcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA4361997;
        Mon,  5 Jul 2021 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498995;
        bh=cGwUjEPu6GVrJ4vuw2Vln/bkM7M4tBAEK+eA5D8vZi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjB1RJFypU3CF2yMV2kGcLr5b/iVpflBO1b9ewV3NXOz8QmGe0XEq7/9uiQRhov1U
         qvkdREfmQvF5MicMoF51J2QgfGlgySMRbl8PtWw/XNAw4W6X1iWyHVun6y7SKVGoZy
         0aA1VdJpx7KwMlvR3ZjGd44sxYFh5SCoQ2iHlWhQvgYAgjiG1/TGdbrPUUu01OQVVo
         bJmiycC3TCsns8M1+tS/R2zD5yPe13/CpH4SL+WKFrnOx90ZKOt3la9uvNkQUYq3W3
         xahzGuDS4yKLNZJ9jvk5A0Og1EU0E44i/XkCiLeyLVH6WfKMgbVU7LeG7iz8GNkqjU
         m4CWNNLqx3zew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        Mohammad Alqayeem <mohammad.alqyeem@nutanix.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 34/52] PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
Date:   Mon,  5 Jul 2021 11:28:55 -0400
Message-Id: <20210705152913.1521036-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
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
index 27a17a1e4a7c..7479edf3676c 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3480,6 +3480,9 @@ static void __exit exit_hv_pci_drv(void)
 
 static int __init init_hv_pci_drv(void)
 {
+	if (!hv_is_hyperv_initialized())
+		return -ENODEV;
+
 	/* Set the invalid domain number's bit, so it will not be used */
 	set_bit(HVPCI_DOM_INVALID, hvpci_dom_map);
 
-- 
2.30.2

