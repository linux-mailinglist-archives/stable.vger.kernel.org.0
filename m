Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608C93A9F43
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhFPPgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234744AbhFPPgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D307613BF;
        Wed, 16 Jun 2021 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857675;
        bh=ypz9PQ9qe0SVB/8adFFM25pP4e02WlCyeIliOP7utIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ifr+dCgnKUbgW2k5HUYpD/A2TY91zKDcIG2Eoe7IGWljFArzWFlv9CKqKC1Hfa/qj
         XRaGiwlNooXdbCvZrnFn4QsaPJk/os28JYaUqLqEKWJo7Ca75VyrzwaRvKoWLpF978
         HaCi0m4oeSO2lXzwDD8xMhUFojZGXjitki5wTDwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/28] nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
Date:   Wed, 16 Jun 2021 17:33:31 +0200
Message-Id: <20210616152834.799739264@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 1c5f8e882a05de5c011e8c3fbeceb0d1c590eb53 ]

When the call to nvme_enable_ctrl() in nvme_loop_configure_admin_queue()
fails the NVME_LOOP_Q_LIVE flag is not cleared.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index b4f5503ae570..f752e9432676 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -395,6 +395,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	return 0;
 
 out_cleanup_queue:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 out_cleanup_fabrics_q:
 	blk_cleanup_queue(ctrl->ctrl.fabrics_q);
-- 
2.30.2



