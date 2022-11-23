Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59576356CE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiKWJeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbiKWJeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80720112C45
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3276AB81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FBDC433D6;
        Wed, 23 Nov 2022 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195925;
        bh=XNr6piV8rUDhJsvcUY05dK3XOn0SRftBcFMhZIEVIeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEJj0cG/JTD6gxKrVk2dDK6O/NG43sWG1E6882ltt2Nl8RregN1UpxqBJxTgW6RcK
         GjnhIzkF9BOkkbR0nnrgrA5aJcpCyBhIH2IqJY2O0E6glKm54jcCB/+aEX3StWnkzo
         YLGgPf/gWiUN7zXAe/B0DQ1sddDv1D5JGyv+SDdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/181] ata: libata-transport: fix double ata_host_put() in ata_tport_add()
Date:   Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084605.425167392@linuxfoundation.org>
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

[ Upstream commit 8c76310740807ade5ecdab5888f70ecb6d35732e ]

In the error path in ata_tport_add(), when calling put_device(),
ata_tport_release() is called, it will put the refcount of 'ap->host'.

And then ata_host_put() is called again, the refcount is decreased
to 0, ata_host_release() is called, all ports are freed and set to
null.

When unbinding the device after failure, ata_host_stop() is called
to release the resources, it leads a null-ptr-deref(), because all
the ports all freed and null.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
CPU: 7 PID: 18671 Comm: modprobe Kdump: loaded Tainted: G            E      6.1.0-rc3+ #8
pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : ata_host_stop+0x3c/0x84 [libata]
lr : release_nodes+0x64/0xd0
Call trace:
 ata_host_stop+0x3c/0x84 [libata]
 release_nodes+0x64/0xd0
 devres_release_all+0xbc/0x1b0
 device_unbind_cleanup+0x20/0x70
 really_probe+0x158/0x320
 __driver_probe_device+0x84/0x120
 driver_probe_device+0x44/0x120
 __driver_attach+0xb4/0x220
 bus_for_each_dev+0x78/0xdc
 driver_attach+0x2c/0x40
 bus_add_driver+0x184/0x240
 driver_register+0x80/0x13c
 __pci_register_driver+0x4c/0x60
 ahci_pci_driver_init+0x30/0x1000 [ahci]

Fix this by removing redundant ata_host_put() in the error path.

Fixes: 2623c7a5f279 ("libata: add refcounting to ata_host")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-transport.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 93d6920cd86c..2b1e3403570c 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -317,7 +317,6 @@ int ata_tport_add(struct device *parent,
  tport_err:
 	transport_destroy_device(dev);
 	put_device(dev);
-	ata_host_put(ap->host);
 	return error;
 }
 
-- 
2.35.1



