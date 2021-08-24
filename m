Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A3E3F63F7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbhHXRAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238439AbhHXQ6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76EEE61528;
        Tue, 24 Aug 2021 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824231;
        bh=xDhQbOxLw/2SU2OWJ+CljTm8FSMGxI4Xfq9H+HN84HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIP0feB89jA7zwRrsmZZGECRyjcjpjFKiMnWUTB/5sTfaC5lQqfqXut//pinfxN5g
         phFGn6iuGi2kdQS6L+xDICi/RCSfL5NNDaSh5c7Db+mnXc2PWtgMKKQJfhgWaD9nN2
         WkPVPl4x8V1vrH84esq7kcPiSIXVrxYfk8x67mwIBEOzKl26WKx1VI3e78o8STeIA7
         WMSJ3pacxN95opFAyQ5/eqZo6Nn9fj9fgSfi/cL2TXnMrgX6v55/ibtltxAwCHlJlG
         3PudKL6JEKxOMjempjap0SBlRtpa3i0Bl7wg0zm+n6JtysY02gu0wBMF7Wqci3j9y7
         UBwZsJwhHSjHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 064/127] ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path
Date:   Tue, 24 Aug 2021 12:55:04 -0400
Message-Id: <20210824165607.709387-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 1b80fec7b043552e01609bae7d0aad07aa742adc ]

In ixgbe_xsk_pool_enable(), if ixgbe_xsk_wakeup() fails,
We should restore the previous state and clean up the
resources. Add the missing clear af_xdp_zc_qps and unmap dma
to fix this bug.

Fixes: d49e286d354e ("ixgbe: add tracking of AF_XDP zero-copy state for each queue pair")
Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for AF_XDP")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20210817203736.3529939-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index f72d2978263b..d60da7a89092 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -52,8 +52,11 @@ static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
 
 		/* Kick start the NAPI context so that receiving will start */
 		err = ixgbe_xsk_wakeup(adapter->netdev, qid, XDP_WAKEUP_RX);
-		if (err)
+		if (err) {
+			clear_bit(qid, adapter->af_xdp_zc_qps);
+			xsk_pool_dma_unmap(pool, IXGBE_RX_DMA_ATTR);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.30.2

