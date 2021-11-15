Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCDE4526FA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245420AbhKPCOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238709AbhKORsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:48:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D9E9632A5;
        Mon, 15 Nov 2021 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997417;
        bh=NdlbuyPUbLHID873Emt1We51gdaFuEuO+8ed9/mUnpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxO9Kgc2diLRLId7X5kKwpBvRbjXZwTkh1DYZgVPt+y6ckiCqcyLlNhh2tg4aKaBj
         J1RlS7QgCboE7JRNMfFe69Lh95Ym2MjTvqslQreRTAMopaMC4W5K8OxsTlEwNqz2mP
         BhWj3bQgfG00545ohKECVPGmsKvnNz3AUKvEm9gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuliang Zhang <xlzhanga@ambarella.com>,
        Li Chen <lchen@ambarella.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 139/575] PCI: cadence: Add cdns_plat_pcie_probe() missing return
Date:   Mon, 15 Nov 2021 17:57:44 +0100
Message-Id: <20211115165348.499850889@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Chen <lchen@ambarella.com>

commit 27cd7e3c9bb1ae13bc16f08138edd6e4df3cd211 upstream.

When cdns_plat_pcie_probe() succeeds, return success instead of falling
into the error handling code.

Fixes: bd22885aa188 ("PCI: cadence: Refactor driver to use as a core library")
Link: https://lore.kernel.org/r/DM6PR19MB40271B93057D949310F0B0EDA0BF9@DM6PR19MB4027.namprd19.prod.outlook.com
Signed-off-by: Xuliang Zhang <xlzhanga@ambarella.com>
Signed-off-by: Li Chen <lchen@ambarella.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/cadence/pcie-cadence-plat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -127,6 +127,8 @@ static int cdns_plat_pcie_probe(struct p
 			goto err_init;
 	}
 
+	return 0;
+
  err_init:
  err_get_sync:
 	pm_runtime_put_sync(dev);


