Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D783450F75
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbhKOSbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:31:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241197AbhKOS3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E1F863448;
        Mon, 15 Nov 2021 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999085;
        bh=NdlbuyPUbLHID873Emt1We51gdaFuEuO+8ed9/mUnpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZsTL3jvFGuGk8l73/TcXd67E5RfliNQ6oapR01RZCXbnV5dGdt7ZQd9ISZb0kzkc
         MVBJTi16+VSOddr0Z2QiLzHuMdoFlMryvlfIGsBMDWLdY4UWwQye9W6TkZ/1bC4V6X
         irn3VFufoEbz1CK4c93x4wRNpa36oki+tNyhlGGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuliang Zhang <xlzhanga@ambarella.com>,
        Li Chen <lchen@ambarella.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.14 169/849] PCI: cadence: Add cdns_plat_pcie_probe() missing return
Date:   Mon, 15 Nov 2021 17:54:12 +0100
Message-Id: <20211115165425.898427408@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


