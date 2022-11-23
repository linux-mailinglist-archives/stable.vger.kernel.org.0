Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0FB6356D0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbiKWJei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiKWJeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B6112C4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9838361B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8EAC433C1;
        Wed, 23 Nov 2022 09:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195933;
        bh=CagHvPziBQnfGexKOXAtwnwfD+TWhnkHZefmba931pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAM8bI5mu/0ywiGfLapAc7Tm2+fRlJ+M3jleQ2FXNjD3AMibSyEl/TbwLp0yJN19f
         P83m0mROuX+2kTPOVgRiXYsnX7Tf+IRCm1Fn9XrtDXopzx8Xujx/qJSOMBK2akc2Jb
         U3wI74iFyPKJhcw8HtXsIY7w/hsDGvTqI4Lcxyt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/181] ata: libata-transport: fix error handling in ata_tlink_add()
Date:   Wed, 23 Nov 2022 09:50:36 +0100
Message-Id: <20221123084605.520487229@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cf0816f6322c5c37ee52655f928e91ecf32da103 ]

In ata_tlink_add(), the return value of transport_add_device() is
not checked. As a result, it causes null-ptr-deref while removing
the module, because transport_remove_device() is called to remove
the device that was not added.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
CPU: 33 PID: 13850 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc3+ #12
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x48/0x39c
lr : device_del+0x44/0x39c
Call trace:
 device_del+0x48/0x39c
 attribute_container_class_device_del+0x28/0x40
 transport_remove_classdev+0x60/0x7c
 attribute_container_device_trigger+0x118/0x120
 transport_remove_device+0x20/0x30
 ata_tlink_delete+0x88/0xb0 [libata]
 ata_tport_delete+0x2c/0x60 [libata]
 ata_port_detach+0x148/0x1b0 [libata]
 ata_pci_remove_one+0x50/0x80 [libata]
 ahci_remove_one+0x4c/0x8c [ahci]

Fix this by checking and handling return value of transport_add_device()
in ata_tlink_add().

Fixes: d9027470b886 ("[libata] Add ATA transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 3dd3b2543086..5ee46521198d 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -428,7 +428,9 @@ int ata_tlink_add(struct ata_link *link)
 		goto tlink_err;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tlink_transport_err;
 	transport_configure_device(dev);
 
 	ata_for_each_dev(ata_dev, link, ALL) {
@@ -443,6 +445,7 @@ int ata_tlink_add(struct ata_link *link)
 		ata_tdev_delete(ata_dev);
 	}
 	transport_remove_device(dev);
+  tlink_transport_err:
 	device_del(dev);
   tlink_err:
 	transport_destroy_device(dev);
-- 
2.35.1



