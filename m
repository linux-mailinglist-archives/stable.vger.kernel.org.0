Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C8F498CFC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350323AbiAXT0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:26:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346355AbiAXTW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:22:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 160F2B8121B;
        Mon, 24 Jan 2022 19:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBA4C340E5;
        Mon, 24 Jan 2022 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052175;
        bh=KMxJK1iIQOsIy0NuPpIiSoxPGHXz/J4x23TAqBxugmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2qDPfA1umsqqPCqNi5+nJ6KvpMNECCRhev1vYRpSFhfPYMdxz/92PM4O5FK5Cxrz
         JwlA4EtvfIPuKqzQgygKU/RQQFYalEkwLKIqzL84CdKbZ+2pOWv2ozeWhsMLBqniDo
         rnr0BjlZrV5JuGm1sK50h0x2XbtpWFGIZ3E+q/Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/239] powerpc/cell: add missing of_node_put
Date:   Mon, 24 Jan 2022 19:43:38 +0100
Message-Id: <20220124183948.822127222@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit a841fd009e51c8c0a8f07c942e9ab6bb48da8858 ]

for_each_node_by_name performs an of_node_get on each iteration, so
a break out of the loop requires an of_node_put.

A simplified version of the semantic patch that fixes this problem is as
follows (http://coccinelle.lip6.fr):

// <smpl>
@@
expression e,e1;
local idexpression n;
@@

 for_each_node_by_name(n, e1) {
   ... when != of_node_put(n)
       when != e = n
(
   return n;
|
+  of_node_put(n);
?  return ...;
)
   ...
 }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1448051604-25256-7-git-send-email-Julia.Lawall@lip6.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 12352a58072ab..d9c2c4cc60be1 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -1088,6 +1088,7 @@ static int __init cell_iommu_fixed_mapping_init(void)
 			if (hbase < dbase || (hend > (dbase + dsize))) {
 				pr_debug("iommu: hash window doesn't fit in"
 					 "real DMA window\n");
+				of_node_put(np);
 				return -1;
 			}
 		}
-- 
2.34.1



