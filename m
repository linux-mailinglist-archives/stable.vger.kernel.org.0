Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04016356D1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbiKWJen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbiKWJeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C859BA06
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C81B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DC7C433C1;
        Wed, 23 Nov 2022 09:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195936;
        bh=3glp74B8zkAU4YV2Zon+InBbMuZ1d8Kiwn1W8kM/w2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUDi3hC/K8S5CqLG9fQvJ5bHiLvqtr3Q705GC7SWcDmEeEnTokrIzd3NPsePxKHgB
         B8932PmZNef/d5sMBnv+wcuMpkBv+ssLCib5/8IJ2AKqjlR7+SMmyps3Y1BS/Yn4sH
         cezhH4/bAbdFPNfafrLF8i8ooy6InpCeXwSYSf5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/181] ata: libata-transport: fix error handling in ata_tdev_add()
Date:   Wed, 23 Nov 2022 09:50:37 +0100
Message-Id: <20221123084605.561911541@linuxfoundation.org>
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

[ Upstream commit 1ff36351309e3eadcff297480baf4785e726de9b ]

In ata_tdev_add(), the return value of transport_add_device() is
not checked. As a result, it causes null-ptr-deref while removing
the module, because transport_remove_device() is called to remove
the device that was not added.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
CPU: 13 PID: 13603 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc3+ #36
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x48/0x3a0
lr : device_del+0x44/0x3a0
Call trace:
 device_del+0x48/0x3a0
 attribute_container_class_device_del+0x28/0x40
 transport_remove_classdev+0x60/0x7c
 attribute_container_device_trigger+0x118/0x120
 transport_remove_device+0x20/0x30
 ata_tdev_delete+0x24/0x50 [libata]
 ata_tlink_delete+0x40/0xa0 [libata]
 ata_tport_delete+0x2c/0x60 [libata]
 ata_port_detach+0x148/0x1b0 [libata]
 ata_pci_remove_one+0x50/0x80 [libata]
 ahci_remove_one+0x4c/0x8c [ahci]

Fix this by checking and handling return value of transport_add_device()
in ata_tdev_add(). In the error path, device_del() is called to delete
the device which was added earlier in this function, and ata_tdev_free()
is called to free ata_dev.

Fixes: d9027470b886 ("[libata] Add ATA transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 5ee46521198d..60f22e1a4943 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -683,7 +683,13 @@ static int ata_tdev_add(struct ata_device *ata_dev)
 		return error;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error) {
+		device_del(dev);
+		ata_tdev_free(ata_dev);
+		return error;
+	}
+
 	transport_configure_device(dev);
 	return 0;
 }
-- 
2.35.1



