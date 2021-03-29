Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F096C34C9F9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbhC2Ief (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234653AbhC2IdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0A42619CA;
        Mon, 29 Mar 2021 08:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006765;
        bh=u2WoqnrokWYYEN1yuapQYMfVOIeZTzxABQuyxzush1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPxmLP4I/04TMEDnOaKtdjgAu/+Kz2qCKM2r9OXz3w5xWXm0BNl4dazqnjuVpZ7P/
         7+5Z1Y7lIEnAqN4PqKKhUKgDhILKBDDOS+H1/O/0pNRkgqdXAi0qPKqa3zgF+DQKcR
         KZZVolTkHhpZlM+A1CR9hMqy9oP3uRCkq2GfkR24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 051/254] nvme-fc: set NVME_REQ_CANCELLED in nvme_fc_terminate_exchange()
Date:   Mon, 29 Mar 2021 09:56:07 +0200
Message-Id: <20210329075634.851433311@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 3c7aafbc8d3d4d90430dfa126847a796c3e4ecfc ]

nvme_fc_terminate_exchange() is being called when exchanges are
being deleted, and as such we should be setting the NVME_REQ_CANCELLED
flag to have identical behaviour on all transports.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 7ec6869b3e5b..0ddd2514b401 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2443,6 +2443,7 @@ nvme_fc_terminate_exchange(struct request *req, void *data, bool reserved)
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 	struct nvme_fc_fcp_op *op = blk_mq_rq_to_pdu(req);
 
+	op->nreq.flags |= NVME_REQ_CANCELLED;
 	__nvme_fc_abort_op(ctrl, op);
 	return true;
 }
-- 
2.30.1



