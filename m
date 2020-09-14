Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C838268D67
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgINOWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbgINNGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:06:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2021B22275;
        Mon, 14 Sep 2020 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088739;
        bh=Gq+FUXLYeR0sXqEbuud5W6hNeqLYZJKW3NtM+LU8lh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQ1vhnc4rkHRNzxdyHPvMl7Lrm8Doba8wxXapzJuJ5jWh352qILnY4+nqXym5EHnL
         QgKK7TVbbOTwernM2CAPVc9e6TxH0z4MmkBa6Eg1KoUCS3yUQotq+kVLHK3JWQXUZe
         PQifgGYH5Du1d9CQ3yvIg6iH6iKVFNwbFaA1dU5I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 10/15] nvme-fc: cancel async events before freeing event struct
Date:   Mon, 14 Sep 2020 09:05:21 -0400
Message-Id: <20200914130526.1804913-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130526.1804913-1-sashal@kernel.org>
References: <20200914130526.1804913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

[ Upstream commit e126e8210e950bb83414c4f57b3120ddb8450742 ]

Cancel async event work in case async event has been queued up, and
nvme_fc_submit_async_event() runs after event has been freed.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 13c89cc9d10cf..e95d2f75713e1 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1566,6 +1566,7 @@ nvme_fc_term_aen_ops(struct nvme_fc_ctrl *ctrl)
 	struct nvme_fc_fcp_op *aen_op;
 	int i;
 
+	cancel_work_sync(&ctrl->ctrl.async_event_work);
 	aen_op = ctrl->aen_ops;
 	for (i = 0; i < NVME_FC_NR_AEN_COMMANDS; i++, aen_op++) {
 		if (!aen_op->fcp_req.private)
-- 
2.25.1

