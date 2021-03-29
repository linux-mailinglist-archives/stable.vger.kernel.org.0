Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E71C34C7FE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhC2IS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233126AbhC2IS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436CB619C7;
        Mon, 29 Mar 2021 08:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005906;
        bh=bYMVX2QpqorTMorYYnTQF9J2xirvafrgBhhBzL0/aNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0H4jlHaTUhbkGIrai05TjojkGz0ryq57xXk3u9OUHFoniut0MZWYnkNv1P/vnvRI
         Jv4xItO5G4AxB06UtbF5V4q3fRR8M+nXYVnrWCutnLgg4S7/aExUEJ/Cvq+GvpKRLc
         39aDsOkoHrNinplBoyh9rdt/OGXGThnsG300AdWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/221] nvme-fc: set NVME_REQ_CANCELLED in nvme_fc_terminate_exchange()
Date:   Mon, 29 Mar 2021 09:56:18 +0200
Message-Id: <20210329075630.744240559@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index fab068c8ba02..d221a98a677b 100644
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



