Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD633C4AB1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbhGLGxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240474AbhGLGvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2990560233;
        Mon, 12 Jul 2021 06:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072545;
        bh=2p0LV09DU4XBRi4be1oKdxfsnEJBokTocuSadVmwvNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp7HDiqcgIhjyMDIcoJoSTESolH41eWgHjfv/Xp1nJy/bNCbbo2ZJnTeWpoxSkAJz
         nK37BvxxvR/XdZ/daJFjH15zETgUKk6VUhSE7++IlTe9T0DYRp5vyC+m/nv81dLySc
         iufPVnItVp/9I4uIKH0JJpP5fTloitqLLAHKY3d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 534/593] habanalabs: Fix an error handling path in hl_pci_probe()
Date:   Mon, 12 Jul 2021 08:11:34 +0200
Message-Id: <20210712060952.354346341@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3002f467a0b0a70aec01d9f446da4ac8c6fda10b ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 2e5eda4681f9 ("habanalabs: PCIe Advanced Error Reporting support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/habanalabs_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index 3bcef64a677a..ded92b3cbdb2 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -421,6 +421,7 @@ static int hl_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 disable_device:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_set_drvdata(pdev, NULL);
 	destroy_hdev(hdev);
 
-- 
2.30.2



