Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAEF4521A5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346318AbhKPBFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245458AbhKOTUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5DD63546;
        Mon, 15 Nov 2021 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001307;
        bh=NdlbuyPUbLHID873Emt1We51gdaFuEuO+8ed9/mUnpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfqUyohSzeAB1nlrfEfmK50aDThTyb1N/ErG30roVjYiullhSQNhWKL6c96t5SJZ6
         /k1SerALHQl27jPWPu6qtGJIElKzBmG2PluNExJ1cfnGB7W7BAN+0H8F8IuETdhhkJ
         +hYMDKH4rf+Z+dxRQAuWLjyFULTJMDrV/2g9u5Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuliang Zhang <xlzhanga@ambarella.com>,
        Li Chen <lchen@ambarella.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 141/917] PCI: cadence: Add cdns_plat_pcie_probe() missing return
Date:   Mon, 15 Nov 2021 17:53:56 +0100
Message-Id: <20211115165433.545423911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


