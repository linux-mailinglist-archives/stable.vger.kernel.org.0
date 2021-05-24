Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1238F38EF6F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhEXP5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235402AbhEXP4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC7106140B;
        Mon, 24 May 2021 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870979;
        bh=KMpnQluOi1+SqxhiUXyVmM16htn4gqIsZs89RfgJ7XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwMOWkd4VdJO8aopNWO4prVk/BjGL0Dvd/rHqJKEDZ8P5XtuOhSXHNnokwUv7/k8y
         oheczUD4xpjdEZjPFW2Ig+iiZAFq9Dy3DtMJkb+lvPuKg3Ot97GZ5ttIAZ0gh0Et9x
         b1MabpeorDLq8k0RSGBIkFjrBuMX6nJES3kWLb/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 018/127] nvme-loop: fix memory leak in nvme_loop_create_ctrl()
Date:   Mon, 24 May 2021 17:25:35 +0200
Message-Id: <20210524152335.479393062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
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
index 3e189e753bcf..14913a4588ec 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -588,8 +588,10 @@ static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 
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



