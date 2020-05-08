Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36101CAB09
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgEHMjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728556AbgEHMjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E2F21835;
        Fri,  8 May 2020 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941551;
        bh=nhgI8sQHAkUUqcnjnsYm15g+i/k1tdlkH1b4JEBHZdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6vxOoXEYfsHZZJI/V7Gt3lO0bsjwht7yv8qduShmWoP08yrF+Z/i+J/bqHdqxbAq
         dxPiAXb/hI+wv7+eDBxu9wNoxsRIzuUnnGXnU3KW2mJWGDQpvMk5amh1hiTCw9l7DB
         4XptfQl4c5689Gf0uSaWBiwkUq5oOKe2kkHl8xDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 078/312] net/mlx5: Fix masking of reserved bits in XRCD number
Date:   Fri,  8 May 2020 14:31:09 +0200
Message-Id: <20200508123130.004639586@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Majd Dibbiny <majd@mellanox.com>

commit 9cd3411c42c5d5ba55d6e745edfe7df53c1ffa41 upstream.

Mask the reserved bits when reading the number of newly
created XRCD.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -393,7 +393,7 @@ int mlx5_core_xrcd_alloc(struct mlx5_cor
 	if (out.hdr.status)
 		err = mlx5_cmd_status_to_err(&out.hdr);
 	else
-		*xrcdn = be32_to_cpu(out.xrcdn);
+		*xrcdn = be32_to_cpu(out.xrcdn) & 0xffffff;
 
 	return err;
 }


