Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B3E198FAB
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbgCaJEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730965AbgCaJEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:04:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C67EB20675;
        Tue, 31 Mar 2020 09:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645470;
        bh=8eomCZrlpS/TCs3dRXpFrmJQOARXZnLrGcwtpcnyBwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SubkYtWUuVg/ndKFzhUi/iUQb3CyjMIby45qow77tLoqatZpgYFvRf0OCoVmc+gQC
         BjyZbuUW9WbXQOtOW+ChvL42y3YMGCWpT1ZQeTJBrTU0PSV+Rxz/+ytBWVchP9FTid
         4kOOtNfTO1AoCx3b376zvIAYO2yO0RDwne8rFNg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Hense <sebastian.hense1@ibm.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 063/170] net/mlx5e: Fix endianness handling in pedit mask
Date:   Tue, 31 Mar 2020 10:57:57 +0200
Message-Id: <20200331085431.190535282@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Hense <sebastian.hense1@ibm.com>

[ Upstream commit 404402abd5f90aa90a134eb9604b1750c1941529 ]

The mask value is provided as 64 bit and has to be casted in
either 32 or 16 bit. On big endian systems the wrong half was
casted which resulted in an all zero mask.

Fixes: 2b64beba0251 ("net/mlx5e: Support header re-write of partial fields in TC pedit offload")
Signed-off-by: Sebastian Hense <sebastian.hense1@ibm.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2432,10 +2432,11 @@ static int offload_pedit_fields(struct p
 			continue;
 
 		if (f->field_bsize == 32) {
-			mask_be32 = *(__be32 *)&mask;
+			mask_be32 = (__be32)mask;
 			mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
 		} else if (f->field_bsize == 16) {
-			mask_be16 = *(__be16 *)&mask;
+			mask_be32 = (__be32)mask;
+			mask_be16 = *(__be16 *)&mask_be32;
 			mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
 		}
 


