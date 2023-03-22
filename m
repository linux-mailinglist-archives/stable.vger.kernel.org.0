Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15416C560A
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCVUC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjCVUCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:02:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C397A6BC2B;
        Wed, 22 Mar 2023 12:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89822B81B97;
        Wed, 22 Mar 2023 19:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F363C433A0;
        Wed, 22 Mar 2023 19:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515150;
        bh=WtqBU0M7xNp4cbCC9ne0kWRWFFTtrkx01YJanzR9t4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5z6q3QnOrAMbxZwzCJHNyrwKRYVPXCOLI/Mh8yybsplgVpHVgygPo/nWLeDni4sw
         L4OsllpeqHTA3ySC3N72lOX+Yzx+xdWfqT07gjx4rUKP1zkJmGQpCSlwbGYrZC6G3I
         AzTZ/OWMSyspQ3DFdm4prrQ260gvMCQ+51DnIkx2HtIT/G3+nKYaTttKL9ti4y/fVZ
         yw3y24zWNGzAD7sW71dOOlLpJy8TclcX/IARcmtaAeYS1oCZtMy3CCOfkoqXmoOBjm
         KzSpSnKWzXWUVgRgPNG5QIYAYhJb/SAsDXEs18VXhnbfxphxJmOFTMHNZXOYNnNaF/
         91DYS4p+qKqyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Irvin Cote <irvincoteg@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 35/45] nvme-pci: fixing memory leak in probe teardown path
Date:   Wed, 22 Mar 2023 15:56:29 -0400
Message-Id: <20230322195639.1995821-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Irvin Cote <irvincoteg@gmail.com>

[ Upstream commit a61d265533b7fe0026a02a49916aa564ffe38e4c ]

In case the nvme_probe teardown path is triggered the ctrl ref count does
not reach 0 thus creating a memory leak upon failure of nvme_probe.

Signed-off-by: Irvin Cote <irvincoteg@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c11e0cfeef0f3..0a77242794d64 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3126,6 +3126,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nvme_dev_unmap(dev);
 out_uninit_ctrl:
 	nvme_uninit_ctrl(&dev->ctrl);
+	nvme_put_ctrl(&dev->ctrl);
 	return result;
 }
 
-- 
2.39.2

