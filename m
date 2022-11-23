Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1235635850
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbiKWJyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbiKWJxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:53:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2398FAE99
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F47561B22
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32977C433D6;
        Wed, 23 Nov 2022 09:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197002;
        bh=sezWZ4QYSxPdkxAxY15z4Bqw8sXcw2zQ3DKWwec9j2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpXJxXRKpEyY3HhW5mSVadb6JNT8/6yKXhHKi+DbsA0wcQ+R/t+ZOLu5vMjL8BHp7
         sWxsVaNPF6bb/UZWbUfm6EiNfwnMuKHxa/rQtojByV11KkveF8OR06+OpWme/27wU4
         6ftRngybfkd+sHZE8A4Bj8Gw65KlLTgRQmn0yCl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 140/314] ata: libata-transport: fix error handling in ata_tdev_add()
Date:   Wed, 23 Nov 2022 09:49:45 +0100
Message-Id: <20221123084631.886139338@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index aac9336e8153..e4fb9d1b9b39 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -713,7 +713,13 @@ static int ata_tdev_add(struct ata_device *ata_dev)
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



