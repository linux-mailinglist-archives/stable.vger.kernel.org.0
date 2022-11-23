Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C576363560D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbiKWJZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbiKWJYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:24:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D639AECCEA
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E7BAB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9C7C433C1;
        Wed, 23 Nov 2022 09:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195410;
        bh=k2LmRVINWteAGO0PNjX/T/sGSCjR0EQ2bojLQLg9Q9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/n44O9TksNz9xxclz2j6TUTbI9KrfwqDOsWFvNZFwDGUzzDIm8aHUiY6OX+1X2PZ
         dfLhY+jvKZ8SOPzjurq1CXLN4wqG1GWr8N3kRz23rIOmsS2BftpwJ97vqo32njwe7p
         xMLWidX76i37EWRNxbLRhrWpTEYYjZKH68s2xeDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/149] ata: libata-transport: fix error handling in ata_tport_add()
Date:   Wed, 23 Nov 2022 09:50:42 +0100
Message-Id: <20221123084600.057209223@linuxfoundation.org>
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

[ Upstream commit 3613dbe3909dcc637fe6be00e4dc43b4aa0470ee ]

In ata_tport_add(), the return value of transport_add_device() is
not checked. As a result, it causes null-ptr-deref while removing
the module, because transport_remove_device() is called to remove
the device that was not added.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
CPU: 12 PID: 13605 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc3+ #8
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x48/0x39c
lr : device_del+0x44/0x39c
Call trace:
 device_del+0x48/0x39c
 attribute_container_class_device_del+0x28/0x40
 transport_remove_classdev+0x60/0x7c
 attribute_container_device_trigger+0x118/0x120
 transport_remove_device+0x20/0x30
 ata_tport_delete+0x34/0x60 [libata]
 ata_port_detach+0x148/0x1b0 [libata]
 ata_pci_remove_one+0x50/0x80 [libata]
 ahci_remove_one+0x4c/0x8c [ahci]

Fix this by checking and handling return value of transport_add_device()
in ata_tport_add().

Fixes: d9027470b886 ("[libata] Add ATA transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 8a9850bd5d6c..da1b144d8288 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -301,7 +301,9 @@ int ata_tport_add(struct device *parent,
 	pm_runtime_enable(dev);
 	pm_runtime_forbid(dev);
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tport_transport_add_err;
 	transport_configure_device(dev);
 
 	error = ata_tlink_add(&ap->link);
@@ -312,6 +314,7 @@ int ata_tport_add(struct device *parent,
 
  tport_link_err:
 	transport_remove_device(dev);
+ tport_transport_add_err:
 	device_del(dev);
 
  tport_err:
-- 
2.35.1



