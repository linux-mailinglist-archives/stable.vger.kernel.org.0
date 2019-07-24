Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2C73D6E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391596AbfGXTub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391594AbfGXTua (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:50:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43BF420665;
        Wed, 24 Jul 2019 19:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997829;
        bh=PHfpj0Kk7aJ4IC0pjE/zbgjHra14MWgefuEMGmYyf1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRh8q4otRmjnXH7ZmrGblddq4W4ppdYoCaajJG/ye3lgEUoLMKbDslhKXp3CizHcm
         POj1hrrJ8p5pBnKSffXG8CcLy8YN4LHJBMpBY3/AapR/0VwQdXnDOd0r1n6EY8yRcv
         skXdTDQoZPQ6HfYjJBphAOQmue7CUBK3DGEu1AL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 121/371] nvme-pci: properly report state change failure in nvme_reset_work
Date:   Wed, 24 Jul 2019 21:17:53 +0200
Message-Id: <20190724191733.952879949@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cee6c269b016ba89c62e34d6bccb103ee2c7de4f ]

If the state change to NVME_CTRL_CONNECTING fails, the dmesg is going to
be like:

  [  293.689160] nvme nvme0: failed to mark controller CONNECTING
  [  293.689160] nvme nvme0: Removing after probe failure status: 0

Even it prints the first line to indicate the situation, the second line
is not proper because the status is 0 which means normally success of
the previous operation.

This patch makes it indicate the proper error value when it fails.
  [   25.932367] nvme nvme0: failed to mark controller CONNECTING
  [   25.932369] nvme nvme0: Removing after probe failure status: -16

This situation is able to be easily reproduced by:
  root@target:~# rmmod nvme && modprobe nvme && rmmod nvme

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 693f2a856200..21a51a0ff4d7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2545,6 +2545,7 @@ static void nvme_reset_work(struct work_struct *work)
 	if (!nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_CONNECTING)) {
 		dev_warn(dev->ctrl.device,
 			"failed to mark controller CONNECTING\n");
+		result = -EBUSY;
 		goto out;
 	}
 
-- 
2.20.1



