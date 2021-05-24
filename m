Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A53538EF22
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhEXP4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234411AbhEXPwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7684D61626;
        Mon, 24 May 2021 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870744;
        bh=fMSXUdR7wbsC5swJDfCnN+SJNX5Vn2BTqpfmIwvqvK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neIxO5nxpZVJ5rY4boJjNPVl3I02XrQwQaeqqC+rzaJUum+73mjXvRBNCl9+KwXmg
         galX0bmEJBWIstGGH9JbOQmAd/Aqy9oD00zhaJeXS5s8mbms5hYGBAEgLwbVa10uQ2
         iztzjzdEV45HgkIj4qau2n4zwVNRpPJLGJy6uoDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/104] nvme-loop: fix memory leak in nvme_loop_create_ctrl()
Date:   Mon, 24 May 2021 17:25:10 +0200
Message-Id: <20210524152333.331152784@linuxfoundation.org>
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

[ Upstream commit 03504e3b54cc8118cc26c064e60a0b00c2308708 ]

When creating loop ctrl in nvme_loop_create_ctrl(), if nvme_init_ctrl()
fails, the loop ctrl should be freed before jumping to the "out" label.

Fixes: 3a85a5de29ea ("nvme-loop: add a NVMe loopback host driver")
Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index f6d81239be21..b869b686e962 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -578,8 +578,10 @@ static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_loop_ctrl_ops,
 				0 /* no quirks, we're perfect! */);
-	if (ret)
+	if (ret) {
+		kfree(ctrl);
 		goto out;
+	}
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING))
 		WARN_ON_ONCE(1);
-- 
2.30.2



