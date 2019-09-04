Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC25A8FF4
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbfIDSGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732321AbfIDSGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5221B206B8;
        Wed,  4 Sep 2019 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620408;
        bh=as9IDoLOXjKLbKXbU0yPfgoS6voJ46GA2f3Iehu/nrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2+E4bQbk9SvTllTcQ2S861ycwt0pABH01w2F/MJaJDgc4nmNT7N/StZ8ga9HxLwK
         L1QS1kiMIdTLGP1jv5GgSc/3+IOOCNNajGDsHpvmPA0HG8aibm0ZOFpTSDIyRpHnNt
         mZe5o+vuB5nHCUQTjFFPxXiFAK/jSCs7kDARjo1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhong <lizhongfs@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/93] nvme-pci: Fix async probe remove race
Date:   Wed,  4 Sep 2019 19:53:11 +0200
Message-Id: <20190904175303.925353679@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bd46a90634302bfe791e93ad5496f98f165f7ae0 ]

Ensure the controller is not in the NEW state when nvme_probe() exits.
This will always allow a subsequent nvme_remove() to set the state to
DELETING, fixing a potential race between the initial asynchronous probe
and device removal.

Reported-by: Li Zhong <lizhongfs@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0a5d064f82ca3..a64a8bca0d5b9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2468,7 +2468,7 @@ static void nvme_async_probe(void *data, async_cookie_t cookie)
 {
 	struct nvme_dev *dev = data;
 
-	nvme_reset_ctrl_sync(&dev->ctrl);
+	flush_work(&dev->ctrl.reset_work);
 	flush_work(&dev->ctrl.scan_work);
 	nvme_put_ctrl(&dev->ctrl);
 }
@@ -2535,6 +2535,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev_info(dev->ctrl.device, "pci function %s\n", dev_name(&pdev->dev));
 
+	nvme_reset_ctrl(&dev->ctrl);
 	nvme_get_ctrl(&dev->ctrl);
 	async_schedule(nvme_async_probe, dev);
 
-- 
2.20.1



