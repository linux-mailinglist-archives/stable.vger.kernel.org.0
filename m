Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97573F6522
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbhHXRKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239165AbhHXRIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2663613DB;
        Tue, 24 Aug 2021 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824409;
        bh=10ppWwsutgLxe02LhILcoq5ChQZYGwDKTujjCSNGd5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2w8CO0Gk1c4y0uB7fqFvwpWhRyGM0ehMWW90i9LLR5luS3fT+9ID/D1W7CrZwdgG
         iXf1oPO6HZoC4GOPoXJUbLCzz6ZcbbIEbMDP1KEakv6MALUMPPJC92QZHJ7igXrZkH
         0vrmouN9QjIpOTgu7f8vttHAbcWwJ/Db9hoa9hyQE9CCa/pxWLhWfKLgyt/gCGc3fU
         nLJLL78jC9Nnddz3CTpFBk0NM3cPjOulICNkbbx+qp5K5Yn+mjtrQsGMR4sishBPyQ
         ZhlqIFzj7LIsGMvv7Ob73jEA6vazm3ZK22fejxNS23yl7HMznz4tjBqkTY0++CxfwD
         CFfp0a+hsXDUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/98] net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32
Date:   Tue, 24 Aug 2021 12:58:30 -0400
Message-Id: <20210824165908.709932-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index d8882d0b6b49..d51bac7ba5af 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3156,8 +3156,10 @@ int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
 
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

