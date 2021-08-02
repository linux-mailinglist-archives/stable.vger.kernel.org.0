Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F337B3DD82C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhHBNuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234090AbhHBNth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F11C060FC4;
        Mon,  2 Aug 2021 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912167;
        bh=Av70WNpnlffcxbPAsOpIVE7w5PtPxS+AltYMrv+oQpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSy/4cIyaca+n3Ap70y2oswdz3gLeQLdNOdcwAByQx2gR8EoSR1hXrLJv4slywzMU
         rgZNZyCwgcHmFaHgBIUxMWjZoOwX8J43dtr6c6KVvgm05bcNQn031iZp13QDHn1QU+
         gZvXhgG2PTKQWpUhZsbkb+QQQQNyuUP8Nb9fzGRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/38] mlx4: Fix missing error code in mlx4_load_one()
Date:   Mon,  2 Aug 2021 15:44:53 +0200
Message-Id: <20210802134335.812097570@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 7e4960b3d66d7248b23de3251118147812b42da2 ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx4/main.c:3538 mlx4_load_one() warn:
missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 7ae0e400cd93 ("net/mlx4_core: Flexible (asymmetric) allocation of EQs and MSI-X vectors for PF/VFs")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index c6660b61e836..69692f7a523c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3469,6 +3469,7 @@ slave_start:
 
 		if (!SRIOV_VALID_STATE(dev->flags)) {
 			mlx4_err(dev, "Invalid SRIOV state\n");
+			err = -EINVAL;
 			goto err_close;
 		}
 	}
-- 
2.30.2



