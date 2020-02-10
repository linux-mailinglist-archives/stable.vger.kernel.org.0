Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1B1574FF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgBJMhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgBJMhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:42 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5399F20838;
        Mon, 10 Feb 2020 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338262;
        bh=u5gjxbGuLQJXByiCbFPs4mdb0PD/2AnCQv8x4gXAxPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G97qjJKq9SuagjmwttD14MFPhmey7+B86kOxawIFX4WgY/qmeKH6NV4zXG+rtyEbt
         EgwBoHu7xBO0eYP05G6R5YiWSA5Uc6td/y0T9GBguebrLGs4mRcFK5e6QvgJhf5BFr
         fjbQIlNrRx2FK90LvtVDMKg/ejT4U9lYqeTo6BuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 084/309] PCI: keystone: Fix error handling when "num-viewport" DT property is not populated
Date:   Mon, 10 Feb 2020 04:30:40 -0800
Message-Id: <20200210122413.927268328@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit b0de922af53eede340986a2d05b6cd4b6d6efa43 upstream.

Fix error handling when "num-viewport" DT property is not populated.

Fixes: 23284ad677a9 ("PCI: keystone: Add support for PCIe EP in AM654x Platforms")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/dwc/pci-keystone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1354,7 +1354,7 @@ static int __init ks_pcie_probe(struct p
 		ret = of_property_read_u32(np, "num-viewport", &num_viewport);
 		if (ret < 0) {
 			dev_err(dev, "unable to read *num-viewport* property\n");
-			return ret;
+			goto err_get_sync;
 		}
 
 		/*


