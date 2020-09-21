Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0404D272F8E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgIUQ6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729262AbgIUQmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950C12076B;
        Mon, 21 Sep 2020 16:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706553;
        bh=g4zpzrrrliWT+jhYfAFzGjxB5RGCcotx6aZMPGxQUeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2OZis0zEWxpRdd7G8Kbnrl9IXd4birRqVHp2Xmgldt8ptfU7ffrSy4xTxIEdpWhc
         P2EtR23NYhhcnYNrIm6iX/LCmvvRds6q63YqPG0NavC2aTTk0F22zW8FyWXaQWRTC2
         UqvVrV99/Y8+K1dqKO4Y2PvaH+sh74Y5c3oq6lCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/49] nvme-fc: cancel async events before freeing event struct
Date:   Mon, 21 Sep 2020 18:28:03 +0200
Message-Id: <20200921162035.518685688@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index bb3b447c56468..73db32f97abf3 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1791,6 +1791,7 @@ nvme_fc_term_aen_ops(struct nvme_fc_ctrl *ctrl)
 	struct nvme_fc_fcp_op *aen_op;
 	int i;
 
+	cancel_work_sync(&ctrl->ctrl.async_event_work);
 	aen_op = ctrl->aen_ops;
 	for (i = 0; i < NVME_NR_AEN_COMMANDS; i++, aen_op++) {
 		if (!aen_op->fcp_req.private)
-- 
2.25.1



