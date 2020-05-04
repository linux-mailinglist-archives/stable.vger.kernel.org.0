Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0618D1C438E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgEDR70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbgEDR7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1305D2073B;
        Mon,  4 May 2020 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615165;
        bh=kIwCCfweveYoQbi6bP/t2EngD/hoy3ths/sI0RWzOEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLbTlyNUn5u4+RinFpr7lh+V9pzqAkHFDaXrlff59VUSoo3Wl6XjdPvlWJtLsigy3
         uY3Kc+k3PdE/YeOBln21yDSOjsd/lBLlAiqMIN324S2SFy4nXaFvgmH0RZsGuO9t/K
         ux3du9BgBP6jktJ9/mSsW0clWz7uwHPOzBOlyn98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.9 11/18] RDMA/mlx4: Initialize ib_spec on the stack
Date:   Mon,  4 May 2020 19:57:21 +0200
Message-Id: <20200504165444.499591167@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

commit c08cfb2d8d78bfe81b37cc6ba84f0875bddd0d5c upstream.

Initialize ib_spec on the stack before using it, otherwise we will have
garbage values that will break creating default rules with invalid parsing
error.

Fixes: a37a1a428431 ("IB/mlx4: Add mechanism to support flow steering over IB links")
Link: https://lore.kernel.org/r/20200413132235.930642-1-leon@kernel.org
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx4/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1589,8 +1589,9 @@ static int __mlx4_ib_create_default_rule
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pdefault_rules->rules_create_list); i++) {
+		union ib_flow_spec ib_spec = {};
 		int ret;
-		union ib_flow_spec ib_spec;
+
 		switch (pdefault_rules->rules_create_list[i]) {
 		case 0:
 			/* no rule */


