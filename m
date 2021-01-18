Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEEE2FA9D2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436981AbhARTOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390498AbhARLiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 992D2221EC;
        Mon, 18 Jan 2021 11:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969908;
        bh=dXuMAfBKCBi2SX5HxRW7MZYwE9tglm8NkGuh2VHqTmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN40YwXqM6XYVoq0tCpWlgVKgmMWE+EFKAeD1GQFPsVqG6eIKtLdzbvRoV6WAIkoX
         HDTeJ3XoXslQhWNyVqrIcHGhzzgwjb9XcP5voCLzhH3caaS1/5oo6LtbyYNJ/1izEj
         NvCrv6NGsgX32OGNtlckU7QE/JEqhvNDOoSpM4I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/76] habanalabs: register to pci shutdown callback
Date:   Mon, 18 Jan 2021 12:34:33 +0100
Message-Id: <20210118113342.564351641@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit fcaebc7354188b0d708c79df4390fbabd4d9799d ]

We need to make sure our device is idle when rebooting a virtual
machine. This is done in the driver level.

The firmware will later handle FLR but we want to be extra safe and
stop the devices until the FLR is handled.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/habanalabs_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/habanalabs/habanalabs_drv.c b/drivers/misc/habanalabs/habanalabs_drv.c
index 8c342fb499ca6..ae50bd55f30af 100644
--- a/drivers/misc/habanalabs/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/habanalabs_drv.c
@@ -443,6 +443,7 @@ static struct pci_driver hl_pci_driver = {
 	.id_table = ids,
 	.probe = hl_pci_probe,
 	.remove = hl_pci_remove,
+	.shutdown = hl_pci_remove,
 	.driver.pm = &hl_pm_ops,
 };
 
-- 
2.27.0



