Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB50F3DD84B
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhHBNvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhHBNuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13CCC610FC;
        Mon,  2 Aug 2021 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912195;
        bh=e72jQk2CinegedZsmoOFdvPMlYsDsyV/qHihCuyi9WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6jpegpy10dBrI0KXPwzxwY0n7Tg51m4+StdG4OH111VV1RtVpUBY2yznLI6PpdxE
         2XssKxKFv+UEF3BvNS4uMxwtsaGLwiWJqnYEMm638swsbvcVuiJKVFEDJCpLOIBi4t
         rrVwv5jAU/CuLWtxsON5/ysjW8j+I/fpajfor1rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/30] mlx4: Fix missing error code in mlx4_load_one()
Date:   Mon,  2 Aug 2021 15:44:59 +0200
Message-Id: <20210802134334.743739039@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
References: <20210802134334.081433902@linuxfoundation.org>
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
index a0affcb090a0..d9707d47f1e7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3515,6 +3515,7 @@ slave_start:
 
 		if (!SRIOV_VALID_STATE(dev->flags)) {
 			mlx4_err(dev, "Invalid SRIOV state\n");
+			err = -EINVAL;
 			goto err_close;
 		}
 	}
-- 
2.30.2



