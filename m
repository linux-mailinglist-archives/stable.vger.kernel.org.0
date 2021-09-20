Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27C9411B40
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhITQ4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343557AbhITQyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A1F76138F;
        Mon, 20 Sep 2021 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156649;
        bh=X73W8+lecl+2gQJjUWNNpqFRg2L8jX9VBx6ncKnREhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYjPAFKVL+c/SQ3Glr8cuCMs2LTkiTh9hW6I2OYzE7JT/hhaEmi49vNo1Pe96dc9c
         SIYE4fE0m74A/4yPMDNhdbjvYqVJ7Gc9Sw2KvDlq1Ek/vXty0cFLIRWzWcX7csTRBv
         UKBLULpswROmKZ1GsC0EbbOledtTE/8uEsRS0x9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 022/175] nvme-pci: Fix an error handling path in nvme_probe()
Date:   Mon, 20 Sep 2021 18:41:11 +0200
Message-Id: <20210920163918.799178405@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit b00c9b7aa06786fc5469783965ff3e2a705a1dec upstream.

Release resources in the correct order in order not to miss a
'put_device()' if 'nvme_dev_map()' fails.

Fixes: b00a726a9fd8 ("NVMe: Don't unmap controller registers on reset")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1927,7 +1927,7 @@ static int nvme_probe(struct pci_dev *pd
 
 	result = nvme_dev_map(dev);
 	if (result)
-		goto free;
+		goto put_pci;
 
 	INIT_WORK(&dev->reset_work, nvme_reset_work);
 	INIT_WORK(&dev->remove_work, nvme_remove_dead_ctrl_work);
@@ -1938,7 +1938,7 @@ static int nvme_probe(struct pci_dev *pd
 
 	result = nvme_setup_prp_pools(dev);
 	if (result)
-		goto put_pci;
+		goto unmap;
 
 	result = nvme_init_ctrl(&dev->ctrl, &pdev->dev, &nvme_pci_ctrl_ops,
 			id->driver_data);
@@ -1953,9 +1953,10 @@ static int nvme_probe(struct pci_dev *pd
 
  release_pools:
 	nvme_release_prp_pools(dev);
+ unmap:
+	nvme_dev_unmap(dev);
  put_pci:
 	put_device(dev->dev);
-	nvme_dev_unmap(dev);
  free:
 	kfree(dev->queues);
 	kfree(dev);


