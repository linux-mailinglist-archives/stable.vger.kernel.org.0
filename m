Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED602FA2E1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404855AbhAROWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390610AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2CBA22E02;
        Mon, 18 Jan 2021 11:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970255;
        bh=R1Gg9szGqRp7szDQbVm8G4rG8+I5sS1lsQ2r0lXUOpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUAdz1yXHpIh0ddoVwiHF/dctmj6vExfEywdAPtwctuIpsHrjqdedygs5eZEsHE2y
         A/5aBc8Mk/435iwsbkgblUwPeWOHuM4l0txNDKP/KOAh9LGiW6DgRrtVesooGmod2s
         5Me8twJgYdife78BWMBkKSe49Uzgl4JQR/CJqsJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/152] habanalabs: register to pci shutdown callback
Date:   Mon, 18 Jan 2021 12:34:06 +0100
Message-Id: <20210118113356.189219327@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
 drivers/misc/habanalabs/common/habanalabs_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index f9067d3ef4376..3bcef64a677ae 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -528,6 +528,7 @@ static struct pci_driver hl_pci_driver = {
 	.id_table = ids,
 	.probe = hl_pci_probe,
 	.remove = hl_pci_remove,
+	.shutdown = hl_pci_remove,
 	.driver.pm = &hl_pm_ops,
 	.err_handler = &hl_pci_err_handler,
 };
-- 
2.27.0



