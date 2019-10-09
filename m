Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5EED1589
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbfJIRYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732050AbfJIRX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:59 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3CF021D80;
        Wed,  9 Oct 2019 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641838;
        bh=iezhzlRdqtRKrCvQN3UCRIlAx7UiuWRw/K0Y0zQsiyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOLnLFa8Cl5iUN2TYumhSnQqi2c9jspVTPBlnxUOPOLg0OyesX5zrLBaHTIJFfDMr
         9grLIHUjyiLO06Lr3XmqgXpr8dbRqdaDHDLmO1bCf5FpmZqMKjfWLVvFwV6xCMfTiT
         Sd9QMPUtQwc2hUhOxMiPAYGmtXiHb3wYj5U4ktGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 20/68] nvme: fix an error code in nvme_init_subsystem()
Date:   Wed,  9 Oct 2019 13:04:59 -0400
Message-Id: <20191009170547.32204-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit bc4f6e06a90ea016855fc67212b4d500145f0b8a ]

"ret" should be a negative error code here, but it's either success or
possibly uninitialized.

Fixes: 32fd90c40768 ("nvme: change locking for the per-subsystem controller list")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 28217cee5e762..ac2ac06d870b5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2513,8 +2513,9 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 		list_add_tail(&subsys->entry, &nvme_subsystems);
 	}
 
-	if (sysfs_create_link(&subsys->dev.kobj, &ctrl->device->kobj,
-			dev_name(ctrl->device))) {
+	ret = sysfs_create_link(&subsys->dev.kobj, &ctrl->device->kobj,
+				dev_name(ctrl->device));
+	if (ret) {
 		dev_err(ctrl->device,
 			"failed to create sysfs link from subsystem.\n");
 		goto out_put_subsystem;
-- 
2.20.1

