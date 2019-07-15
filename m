Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2192068CF0
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbfGONzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731823AbfGONzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:55:04 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92AD5212F5;
        Mon, 15 Jul 2019 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198902;
        bh=ezzxhSD1Dmn4AJxk5jGKLJlF5eQJDRM4jGDIi8e52E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zO/C/+ufOhB8BXeCCwQ903tBA/ncVPsQJFs7KThAMlZ6Ubu542jb8+IzAXlaNaxa8
         qR/r4DXmMU6ZgTABIYQHXIZMM2Xe8QYzW9uptSOfzVy+QdSTR4WUTHNARcYt4qxV6y
         +6KIJaAMGP44R/qwHXPThcRWAsKT8xUsOLOlkH8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minwoo Im <minwoo.im.dev@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 135/249] nvme-pci: properly report state change failure in nvme_reset_work
Date:   Mon, 15 Jul 2019 09:45:00 -0400
Message-Id: <20190715134655.4076-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minwoo Im <minwoo.im.dev@gmail.com>

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
index 524d6bd6d095..385ba7a1e23b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2528,6 +2528,7 @@ static void nvme_reset_work(struct work_struct *work)
 	if (!nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_CONNECTING)) {
 		dev_warn(dev->ctrl.device,
 			"failed to mark controller CONNECTING\n");
+		result = -EBUSY;
 		goto out;
 	}
 
-- 
2.20.1

