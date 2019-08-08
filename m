Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A277F86976
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404692AbfHHTHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404701AbfHHTHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D732189E;
        Thu,  8 Aug 2019 19:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291256;
        bh=x/rR/f7nKOWNM0gBErSAvQTka5BQv98DsQhI7mYy6TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9lvQ5kk7bir8vcHoHYKvDQXjQeNQfFwPQMQ1/Mji+aQcKBe2R9qxOqtvMGdH17Mo
         P5xtVXKKKj3YofqtrdFtncyawYu0xHYgtlDqy59KipSAa4y7NgYzsIM5XqpHpxGss9
         96MH0ELr48pSEZwUZqpJEKWzeNWTNOrFR2j328o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Srouji <edwards@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.2 39/56] net/mlx5: Fix modify_cq_in alignment
Date:   Thu,  8 Aug 2019 21:05:05 +0200
Message-Id: <20190808190454.634777421@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Srouji <edwards@mellanox.com>

[ Upstream commit 7a32f2962c56d9d8a836b4469855caeee8766bd4 ]

Fix modify_cq_in alignment to match the device specification.
After this fix the 'cq_umem_valid' field will be in the right offset.

Cc: <stable@vger.kernel.org> # 4.19
Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
Signed-off-by: Edward Srouji <edwards@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mlx5/mlx5_ifc.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5865,10 +5865,12 @@ struct mlx5_ifc_modify_cq_in_bits {
 
 	struct mlx5_ifc_cqc_bits cq_context;
 
-	u8         reserved_at_280[0x40];
+	u8         reserved_at_280[0x60];
 
 	u8         cq_umem_valid[0x1];
-	u8         reserved_at_2c1[0x5bf];
+	u8         reserved_at_2e1[0x1f];
+
+	u8         reserved_at_300[0x580];
 
 	u8         pas[0][0x40];
 };


