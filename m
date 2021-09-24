Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF34173EE
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbhIXNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345779AbhIXM7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66298613DA;
        Fri, 24 Sep 2021 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487989;
        bh=tmlr2eCu8auE2+TvOyAfmdEJP6DU3HnR6ruJcWdtTz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0iC25wMOXFF33XcNZwK/h9np00io+HBoswvYfDMa+b+lHHmvlCqTbFfZJOWL5XPS
         YpVVdZYEuH7fJ3BWZq74u3gB3s40QVrKvARNbKlCsocjO2yWWQwZwvnq13tup9cwYy
         8Um2PgHYit0gD20l37SNBo2f3ANCUDE917jg8hIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.14 009/100] RDMA/mlx5: Fix xlt_chunk_align calculation
Date:   Fri, 24 Sep 2021 14:43:18 +0200
Message-Id: <20210924124341.771308696@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit f4c6f31011eafe027abddf6cee1288a1b5a05b73 upstream.

The XLT chunk alignment depends on ent_size not sizeof(ent_size) aka
sizeof(size_t). The incoming ent_size is either 8 or 16, so the
miscalculation when 16 is required is only an over-alignment and
functional harmless.

Fixes: 8010d74b9965 ("RDMA/mlx5: Split the WR setup out of mlx5_ib_update_xlt()")
Link: https://lore.kernel.org/r/20210908081849.7948-2-schnelle@linux.ibm.com
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -995,7 +995,7 @@ static struct mlx5_ib_mr *alloc_cacheabl
 static void *mlx5_ib_alloc_xlt(size_t *nents, size_t ent_size, gfp_t gfp_mask)
 {
 	const size_t xlt_chunk_align =
-		MLX5_UMR_MTT_ALIGNMENT / sizeof(ent_size);
+		MLX5_UMR_MTT_ALIGNMENT / ent_size;
 	size_t size;
 	void *res = NULL;
 


