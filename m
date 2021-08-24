Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AFA3F676A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbhHXRd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241891AbhHXRbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F316A613BD;
        Tue, 24 Aug 2021 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824749;
        bh=jC2k8/jMccFKLp7Fab7XAL1gkcWiSFXM2hnEXBCN0ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpKpvDWiLExaEmUN1oXYXGy1Dy8mPd+VDeeEAdduTeyUWLwCK+ImX9LOg76L/U/xu
         yfXvXyuRYlZirBYi5zHKp8ZVpWIKCzNkHyLQhKOi1akQXJjSEcAkIhvI9nnvBYNkI7
         fWV0CI+oEwOmnXg5T/dj6KeKV3+G0XUd03s4MYpD4nr0LzafCZ7ICf4m84CGYtHBX5
         NkRnAiqMC4jkQXy/jjH3sB86wll8sSFGhqYrVkTmD9pQYnFFAwgRnQ1fsov2DkU90J
         jiHuWvix8Fpx2x+0jeMHc9UkztMNTRVo3PAMqWsjgfJwAfdQkFNf29Mm55eYvBnkqF
         3UqSeIaPiAxpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 53/64] net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32
Date:   Tue, 24 Aug 2021 13:04:46 -0400
Message-Id: <20210824170457.710623-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 0a298d133893c72c96e2156ed7cb0f0c4a306a3e ]

qlcnic_83xx_unlock_flash() is called on all paths after we call
qlcnic_83xx_lock_flash(), except for one error path on failure
of QLCRD32(), which may cause a deadlock. This bug is suggested
by a static analysis tool, please advise.

Fixes: 81d0aeb0a4fff ("qlcnic: flash template based firmware reset recovery")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20210816131405.24024-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index aae81226a0a4..4994599728dc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3157,8 +3157,10 @@ int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
 
 		indirect_addr = QLC_83XX_FLASH_DIRECT_DATA(addr);
 		ret = QLCRD32(adapter, indirect_addr, &err);
-		if (err == -EIO)
+		if (err == -EIO) {
+			qlcnic_83xx_unlock_flash(adapter);
 			return err;
+		}
 
 		word = ret;
 		*(u32 *)p_data  = word;
-- 
2.30.2

