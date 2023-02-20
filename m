Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7C69CEBD
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjBTOCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjBTOCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:02:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9623F1E9D7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AE0FB80D07
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6A8C433EF;
        Mon, 20 Feb 2023 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901697;
        bh=UAK0CyBSGCXSNUyHpIppeaXbRFbax6hoe6kXlhew7WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgH7FdGeF5fXXXMmYxQgtlkM8OUT64yKp2iXvmTPpKlr+DlJSunkeA7YGvA99kL+d
         pIxQ21MxHB7P7YL6R30ckh9DWgKGM9TR3LnKBbB0ZcJ8ZvXvwOvfMnUh7iTIrIA1lc
         La62eKcNiLYJ4VTpHkLpOLk7F+IH2Npd/5GsFWVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1 116/118] nvme-pci: refresh visible attrs for cmb attributes
Date:   Mon, 20 Feb 2023 14:37:12 +0100
Message-Id: <20230220133605.032953693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit e917a849c3fc317c4a5f82bb18726000173d39e6 upstream.

The sysfs group containing the cmb attributes is registered before the
driver knows if they need to be visible or not. Update the group when
cmb attributes are known to exist so the visibility setting is correct.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217037
Fixes: 86adbf0cdb9ec65 ("nvme: simplify transport specific device attribute handling")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -109,6 +109,7 @@ struct nvme_queue;
 
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode);
+static void nvme_update_attrs(struct nvme_dev *dev);
 
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
@@ -1967,6 +1968,8 @@ static void nvme_map_cmb(struct nvme_dev
 	if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
 			(NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
 		pci_p2pmem_publish(pdev, true);
+
+	nvme_update_attrs(dev);
 }
 
 static int nvme_set_host_mem(struct nvme_dev *dev, u32 bits)
@@ -2250,6 +2253,11 @@ static const struct attribute_group *nvm
 	NULL,
 };
 
+static void nvme_update_attrs(struct nvme_dev *dev)
+{
+	sysfs_update_group(&dev->ctrl.device->kobj, &nvme_pci_dev_attrs_group);
+}
+
 /*
  * nirqs is the number of interrupts available for write and read
  * queues. The core already reserved an interrupt for the admin queue.


