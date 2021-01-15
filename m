Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50942F7BB5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732648AbhAOMba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732634AbhAOMb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F0E423998;
        Fri, 15 Jan 2021 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713828;
        bh=1zs3vFrHTDknk5gPcaIjBIaNaKNOFQblPoXkDQ1jOF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzoCHl/wxHCkEPECUFNhG/WlXW0uPEshg6coRW8bPkM1hMXqN3MFqDitWg51od+n7
         oGW23qSJUmRgcyeZ/m487WohXPhICX7Hga7EFMFBHmx5YwIf+yEOIVVRC+CoKHYqcX
         5osnZbITixvRGKsHj7nXiHql6wsp3XUGoOWiMAQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 4.9 21/25] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
Date:   Fri, 15 Jan 2021 13:27:52 +0100
Message-Id: <20210115121957.735168948@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 5b0bb12c58ac7d22e05b5bfdaa30a116c8c32e32 upstream.

When mlx5_create_flow_group() fails, ft->g should be
freed just like when kvzalloc() fails. The caller of
mlx5e_create_l2_table_groups() does not catch this
issue on failure, which leads to memleak.

Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -930,6 +930,7 @@ err_destroy_groups:
 	ft->g[ft->num_groups] = NULL;
 	mlx5e_destroy_groups(ft);
 	kvfree(in);
+	kfree(ft->g);
 
 	return err;
 }


