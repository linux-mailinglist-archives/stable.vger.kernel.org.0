Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D363555E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbiKWJRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiKWJRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5EB107E59
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D9961B14
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D134C433B5;
        Wed, 23 Nov 2022 09:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195015;
        bh=EufkLu5hVpvvcFy8TLrG9xryAqrRtRYayvU23nKa1Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Her8Cw9G6Bp7/vBVMAMlizavLZXm2N0Gg2vW3p9EUn2YR4e7TesVX8akHij/3Xq5j
         kRRd6VjlO2K/OU8uNU5HKv6yOCP+AgYTzyw+GLHaW7cPqVRFyUGm1YhGR9l4HSiFHL
         I4SOhz0kdCsWaGCG05iT2+62kNiJHatIKwnocqCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/156] ata: libata-transport: fix double ata_host_put() in ata_tport_add()
Date:   Wed, 23 Nov 2022 09:50:53 +0100
Message-Id: <20221123084601.452347106@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index c4f36312b8a4..1069cda6ff36 100644
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



