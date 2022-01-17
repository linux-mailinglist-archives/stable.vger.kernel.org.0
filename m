Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEFC490CC3
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 17:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbiAQQ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48288 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241175AbiAQQ7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5334611DD;
        Mon, 17 Jan 2022 16:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954A3C36AF7;
        Mon, 17 Jan 2022 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438746;
        bh=Tivkv/sFkps9YthhNWqLu2xQYDfifae22GMxPKEtHvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/bz36Er1TLfv0DWtHLPsTUEZ75p6QgZbmDsXhpwSBq6qyxjO5KRkCcsAzLu1JTUp
         tgIA3NMOhgXprda5Av8qMlg1OUnHbEGkyeJeJBp3rdpMWGu9MaRN3ZG1mE0PyTVPyQ
         2nXwQ1zitP0/PjohTpH9pJlubqKOeNS6RNG/vtEKcTgEj7PKB869HrenC1x2GxmR7H
         xXudE9hCSFuTI4uLSEungVNb+b1pJVAGgIBOR63N2AHvWeko0gaLh4IB2uD/P54wrb
         3Ne8RWrzXYaO40G2CL0YiATNZ6FEx6uuoN3CrD5WpDWVeCq1g7HSGknRIZyAXwFKi2
         aiWZQy+fydb8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.16 05/52] powerpc/cell: add missing of_node_put
Date:   Mon, 17 Jan 2022 11:58:06 -0500
Message-Id: <20220117165853.1470420-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fa08699aedeb8..d32f24de84798 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -977,6 +977,7 @@ static int __init cell_iommu_fixed_mapping_init(void)
 			if (hbase < dbase || (hend > (dbase + dsize))) {
 				pr_debug("iommu: hash window doesn't fit in"
 					 "real DMA window\n");
+				of_node_put(np);
 				return -1;
 			}
 		}
-- 
2.34.1

