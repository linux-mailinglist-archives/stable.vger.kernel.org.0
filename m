Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DE43BBF41
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhGEPbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232089AbhGEPbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D87FC61978;
        Mon,  5 Jul 2021 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498944;
        bh=iIjodSY/gAGcSVElEFWD4Ml/sA1x2PVygsJsaiw+aHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeigBurxyPXEZI+zmu6weAorYpU4ZS4bY0n+E5hBhFcfAfb6dpPsgkWP/gmkvMACT
         YpOanFjBEgpdmiud1VDvvdnHuegkTrofpP00V/1xeWf30QXZwz6Ba59AqFdcaWuXb8
         y9vfuhxFVdg3Bpg18MZ0oa9vosu9AHJFQX0WYBkXMQIYgm2iv6jn8XSsNhUz+hdhvT
         9QaOD1MDPSmK8voYHxSXtxAcHZ+0L5FfS3Ba/f8FZuoG4FFrscLgrkPTBe6vd/VEkK
         WHpaYuxcUWYsXVZiRV64mDqzr4AEsvJ6s5fletfuz5IM87SY10agEQ2AQEBzxmc7+o
         n/IVuOAo9QT9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        Mohammad Alqayeem <mohammad.alqyeem@nutanix.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 37/59] PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
Date:   Mon,  5 Jul 2021 11:27:53 -0400
Message-Id: <20210705152815.1520546-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
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
index 6511648271b2..bebe3eeebc4e 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3476,6 +3476,9 @@ static void __exit exit_hv_pci_drv(void)
 
 static int __init init_hv_pci_drv(void)
 {
+	if (!hv_is_hyperv_initialized())
+		return -ENODEV;
+
 	/* Set the invalid domain number's bit, so it will not be used */
 	set_bit(HVPCI_DOM_INVALID, hvpci_dom_map);
 
-- 
2.30.2

