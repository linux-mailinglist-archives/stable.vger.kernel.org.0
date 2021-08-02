Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41683DD8EB
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhHBNzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236156AbhHBNzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5399561185;
        Mon,  2 Aug 2021 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912408;
        bh=UfUyn9/pYIKv79cGUxfwYbkVUZbl5aotPAlYrdeQfqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5VD5L9FtQkKuUZ0DvMZMmon7TwE9g2bR5u0jxJbpCog+tlmYB+BhpHMrL5SVwaTe
         HfRRakeT0OROJK/BxckhKL0ciqfGMLdJDcKZZwa3AIZi0gt3Kf0kB2hLM0YXMR0E8u
         oNVvRtZ9nuUqs1JFiZefDOjrjjv6hd6JkfqxzrP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/67] mlx4: Fix missing error code in mlx4_load_one()
Date:   Mon,  2 Aug 2021 15:45:09 +0200
Message-Id: <20210802134340.600483859@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
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
index 00c84656b2e7..28ac4693da3c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3535,6 +3535,7 @@ slave_start:
 
 		if (!SRIOV_VALID_STATE(dev->flags)) {
 			mlx4_err(dev, "Invalid SRIOV state\n");
+			err = -EINVAL;
 			goto err_close;
 		}
 	}
-- 
2.30.2



