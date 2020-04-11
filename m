Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F81A4FF5
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgDKMNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbgDKMNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:13:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 240BA21556;
        Sat, 11 Apr 2020 12:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607189;
        bh=4xxN/LclMpdMStU1HXKQchgd+iyfOMPCUl1uogaTx9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvpZRp3KkMTGWcI2MloNS0+X+xjy294AN7Qoq/zYvCuiOEiF2IsFJ1us9OexwS2+/
         9GK5+3vv3D03r2G9BsnSoehnYOAuWj29GqkUZCUo5ba7vPiJmpJeErExHSIMZkn4x/
         nfNVNKCXQtzy+G2gDyuQciWm2lJf11YFKvZNRL0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 11/38] misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices
Date:   Sat, 11 Apr 2020 14:08:55 +0200
Message-Id: <20200411115439.110258519@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 6b443e5c80b67a7b8a85b33d052d655ef9064e90 upstream.

Adding more than 10 pci-endpoint-test devices results in
"kobject_add_internal failed for pci-endpoint-test.1 with -EEXIST, don't
try to register things with the same name in the same directory". This
is because commit 2c156ac71c6b ("misc: Add host side PCI driver for PCI
test function device") limited the length of the "name" to 20 characters.
Change the length of the name to 24 in order to support upto 10000
pci-endpoint-test devices.

Fixes: 2c156ac71c6b ("misc: Add host side PCI driver for PCI test function device")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/pci_endpoint_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -466,7 +466,7 @@ static int pci_endpoint_test_probe(struc
 	int err;
 	int irq = 0;
 	int id;
-	char name[20];
+	char name[24];
 	enum pci_barno bar;
 	void __iomem *base;
 	struct device *dev = &pdev->dev;


