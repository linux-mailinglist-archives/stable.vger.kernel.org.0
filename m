Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02836B851A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406507AbfISWRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406488AbfISWRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE4320678;
        Thu, 19 Sep 2019 22:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931460;
        bh=euDTmi3o+maZTn2OyWRJ//BCsc8MPWXUgCcZXYSqCJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PR0oHqXoUFt94KBPPN5JYiI3Q3H3l9f6lGCT9m6h+RiPqb7VS/P3Wp7qm/6Jo6tIr
         19LITOm8G+X/6QPmw4/O4kNKC6o+jE5T6ZnqI4+PfFldQ21Mg2QFJlHIBN15bQT8wP
         ZOsJ2Xw3E1f2sZ8Q/ZLG4TRzgy5FpbDKKEYqVa4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 54/59] PCI: kirin: Fix section mismatch warning
Date:   Fri, 20 Sep 2019 00:04:09 +0200
Message-Id: <20190919214808.159977294@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 6870b673509779195cab300aedc844b352d9cfbc upstream.

The PCI kirin driver compilation produces the following section mismatch
warning:

WARNING: vmlinux.o(.text+0x4758cc): Section mismatch in reference from
the function kirin_pcie_probe() to the function
.init.text:kirin_add_pcie_port()
The function kirin_pcie_probe() references
the function __init kirin_add_pcie_port().
This is often because kirin_pcie_probe lacks a __init
annotation or the annotation of kirin_add_pcie_port is wrong.

Remove '__init' from kirin_add_pcie_port() to fix it.

Fixes: fc5165db245a ("PCI: kirin: Add HiSilicon Kirin SoC PCIe controller driver")
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
[lorenzo.pieralisi@arm.com: updated commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/dwc/pcie-kirin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/dwc/pcie-kirin.c
+++ b/drivers/pci/dwc/pcie-kirin.c
@@ -449,8 +449,8 @@ static const struct dw_pcie_host_ops kir
 	.host_init = kirin_pcie_host_init,
 };
 
-static int __init kirin_add_pcie_port(struct dw_pcie *pci,
-				      struct platform_device *pdev)
+static int kirin_add_pcie_port(struct dw_pcie *pci,
+			       struct platform_device *pdev)
 {
 	pci->pp.ops = &kirin_pcie_host_ops;
 


