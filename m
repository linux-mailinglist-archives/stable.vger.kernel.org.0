Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D590038EF23
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhEXP4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234419AbhEXPwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C290613F7;
        Mon, 24 May 2021 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870742;
        bh=ApvW2V6KWLhOtJ8ac1/OCP6FFLc5dYX2ZjHqXelPi4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fP2xM97S3FCKNIhZvNNd5Pfz1FftVvy2t7gM5QW26KTpuvIhhP1fXYOkWalZzeLQq
         njyiR7qMoG+X/b9i7MYFlIpGW9TZ6/u3RDI+E/L8DhhLMqf6ex1kmh5Rol8C1mg9zz
         sh2+pJcA1df4ERvKgSMh7iUOnC4YsxRly5UQ9bTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/104] nvmet: fix memory leak in nvmet_alloc_ctrl()
Date:   Mon, 24 May 2021 17:25:09 +0200
Message-Id: <20210524152333.299634693@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit fec356a61aa3d3a66416b4321f1279e09e0f256f ]

When creating ctrl in nvmet_alloc_ctrl(), if the cntlid_min is larger
than cntlid_max of the subsystem, and jumps to the
"out_free_changed_ns_list" label, but the ctrl->sqs lack of be freed.
Fix this by jumping to the "out_free_sqs" label.

Fixes: 94a39d61f80f ("nvmet: make ctrl-id configurable")
Signed-off-by: Wu Bo <wubo40@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 870d06cfd815..46e4f7ea34c8 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1360,7 +1360,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		goto out_free_changed_ns_list;
 
 	if (subsys->cntlid_min > subsys->cntlid_max)
-		goto out_free_changed_ns_list;
+		goto out_free_sqs;
 
 	ret = ida_simple_get(&cntlid_ida,
 			     subsys->cntlid_min, subsys->cntlid_max,
-- 
2.30.2



