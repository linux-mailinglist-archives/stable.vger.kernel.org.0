Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379813C4515
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhGLGX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234551AbhGLGW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F9A2610A6;
        Mon, 12 Jul 2021 06:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070759;
        bh=lih3W99nVGZKyW4Zkbj1v+KnbsdkmMAQa/vyFDAV83o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfIEyahmW6m3p+e+NdU7lj7On60qNz9RCh5AmjvOPSdayY6qgKD42Evnl2eT45syU
         JmQF6V0En/tCTAsTwukwtmicgSisTMMCKRmagPH1X/tkVX9hrWDdc22hwlASaf+Gw5
         4esIswUdrkSIW9dIo+We7RQZluxDNYltbpw+O6FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Mohammad Alqayeem <mohammad.alqyeem@nutanix.com>
Subject: [PATCH 5.4 129/348] PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
Date:   Mon, 12 Jul 2021 08:08:33 +0200
Message-Id: <20210712060718.451702902@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



