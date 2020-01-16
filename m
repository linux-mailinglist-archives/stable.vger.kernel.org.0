Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16B613FF8C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbgAPXYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388172AbgAPXY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1299E2072B;
        Thu, 16 Jan 2020 23:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217069;
        bh=oXcqTYvmKHG2Oyu7/RIiGJnpCLc/p7lAUB5yf0Pq8iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnLln8KxGw8bsVYiJIxiLm+Nd1FHoMwm1juzz/yWc/GxZxtvUakX8aNzLIpj4u4lt
         8tAuHRRu3msQoIXQRQrwunbm9+qUjxfFPEgzUPffZtQW0QWWEIGDejDmnro9k7E1h+
         OCVUfN6Xl4miLsCgYEzaWWYdjJzZcreepsH6dtf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>
Subject: [PATCH 5.4 135/203] PCI: Fix missing bridge dma_ranges resource list cleanup
Date:   Fri, 17 Jan 2020 00:17:32 +0100
Message-Id: <20200116231756.875627199@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit 7608158df3ed87a5c938c4a0b91f5b11101a9be1 upstream.

Commit e80a91ad302b ("PCI: Add dma_ranges window list") added a
dma_ranges resource list, but failed to correctly free the list when
devm_pci_alloc_host_bridge() is used.

Only the iproc host bridge driver is using the dma_ranges list.

Fixes: e80a91ad302b ("PCI: Add dma_ranges window list")
Link: https://lore.kernel.org/r/20191008012325.25700-1-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Srinath Mannam <srinath.mannam@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -572,6 +572,7 @@ static void devm_pci_release_host_bridge
 		bridge->release_fn(bridge);
 
 	pci_free_resource_list(&bridge->windows);
+	pci_free_resource_list(&bridge->dma_ranges);
 }
 
 static void pci_release_host_bridge_dev(struct device *dev)


