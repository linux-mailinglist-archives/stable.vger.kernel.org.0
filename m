Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097673C4CBE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242869AbhGLHHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241933AbhGLHGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30EB61279;
        Mon, 12 Jul 2021 07:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073397;
        bh=cGwUjEPu6GVrJ4vuw2Vln/bkM7M4tBAEK+eA5D8vZi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyPcvX1tgIUfTLuXARti7DdUbn2TZe/BTPNuFUBnfwKND2tSvTPU1IECiXjPC3DFV
         wTJgOUGPLjlwqWAJABdL5OHlrb/TUCR+24FR/xeJkA4D8xhMUNZlfccpLBd5txo2bC
         fFuhPmiOylfmZPF2fCNJ8O5x+dQWh5gjHAO0NiZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Mohammad Alqayeem <mohammad.alqyeem@nutanix.com>
Subject: [PATCH 5.12 229/700] PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
Date:   Mon, 12 Jul 2021 08:05:12 +0200
Message-Id: <20210712060959.209095778@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



