Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51AE28805
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390678AbfEWT0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390636AbfEWT0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED22217D9;
        Thu, 23 May 2019 19:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639581;
        bh=kb8W47znFWhlJNjuW2dsbV4ms7hrv9g04OWiTDm4HYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7qFLFttQxBvlJItcEyNPv8rh/f190QGdaTYlnhYUZgQrRcLpm364XTMMBatWcQMS
         zmpnFm/ctwCHr9td9xA0ItG8NE+6sTXmFeknDJAzyhvv9nRdezyxDhwBf76ospMsPM
         LN8e4l/0AfWkfUe37Thsmrig+R8RrGiGhinfvY9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodong Wang <bodong@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 018/122] net/mlx5: Fix peer pf disable hca command
Date:   Thu, 23 May 2019 21:05:40 +0200
Message-Id: <20190523181707.268851900@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

[ Upstream commit dd06486710d251140edc86ec3bbef0c25dcec1cb ]

The command was mistakenly using enable_hca in embedded CPU field.

Fixes: 22e939a91dcb (net/mlx5: Update enable HCA dependency)
Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reported-by: Alex Rosenbaum <alexr@mellanox.com>
Signed-off-by: Alex Rosenbaum <alexr@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -26,7 +26,7 @@ static int mlx5_peer_pf_disable_hca(stru
 
 	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
 	MLX5_SET(disable_hca_in, in, function_id, 0);
-	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	MLX5_SET(disable_hca_in, in, embedded_cpu_function, 0);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 


