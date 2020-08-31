Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC2257CC7
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgHaPb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgHaPb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A76207EA;
        Mon, 31 Aug 2020 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887887;
        bh=ObXwBHcpH2/Zv36wN1h9V35sVGYuyTclfNAs+hcl7B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g95JNU6285xSqpnoW3OxnU4R8HlnXEhxWhGGAdLY52KFoeugCj3P9vPQBuTQ2eolY
         ypuaqrymgCrNGSkX6RbCoK0bTaxLaya0s5KA1YAfHgA2S1xH2vm8N/1/aCLy0KSUkO
         GONKvt1enolcyJg1HbsFu8xvRryUV5HWwQ0/OUIo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Engel <amit.engel@dell.com>, Sagi Grimberg <sagi@grimberg.me>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 06/11] nvmet: Disable keep-alive timer when kato is cleared to 0h
Date:   Mon, 31 Aug 2020 11:31:12 -0400
Message-Id: <20200831153117.1024537-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153117.1024537-1-sashal@kernel.org>
References: <20200831153117.1024537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Engel <amit.engel@dell.com>

[ Upstream commit 0d3b6a8d213a30387b5104b2fb25376d18636f23 ]

Based on nvme spec, when keep alive timeout is set to zero
the keep-alive timer should be disabled.

Signed-off-by: Amit Engel <amit.engel@dell.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 776b7e9e23b9e..f28df233dfcd0 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -307,6 +307,9 @@ static void nvmet_keep_alive_timer(struct work_struct *work)
 
 static void nvmet_start_keep_alive_timer(struct nvmet_ctrl *ctrl)
 {
+	if (unlikely(ctrl->kato == 0))
+		return;
+
 	pr_debug("ctrl %d start keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
 
@@ -316,6 +319,9 @@ static void nvmet_start_keep_alive_timer(struct nvmet_ctrl *ctrl)
 
 static void nvmet_stop_keep_alive_timer(struct nvmet_ctrl *ctrl)
 {
+	if (unlikely(ctrl->kato == 0))
+		return;
+
 	pr_debug("ctrl %d stop keep-alive\n", ctrl->cntlid);
 
 	cancel_delayed_work_sync(&ctrl->ka_work);
-- 
2.25.1

