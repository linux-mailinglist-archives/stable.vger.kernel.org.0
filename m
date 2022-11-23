Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEBC6355EE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbiKWJ0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiKWJZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:25:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25609CE37
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C515CB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B737C433D7;
        Wed, 23 Nov 2022 09:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195468;
        bh=/IsUeQ5TSeFo1EJeRR10jo5s/IPoa5AniyKUTFgwv1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDs60iIPB1qXETAlpRqaAgRZFpr6/okG5ad6K21MtTGC1JWjRalvaHUL5FG1niTWV
         VIQCc8QIN5hB9Ez7Jk7rDM/d677/d8RsxBxHYI+MHpEQrmQOSRBBQV1S3hXrvz8I1s
         5B+L7oUg3dgAtX8Pjcjpzx9ZrSEhwsnQQQmgKKSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/149] ata: libata-transport: fix error handling in ata_tdev_add()
Date:   Wed, 23 Nov 2022 09:50:44 +0100
Message-Id: <20221123084600.118003661@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
index e386e5f35015..31a66fc0c31d 100644
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



