Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73725490E6A
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiAQRIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54052 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242108AbiAQRGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 818FCB810F5;
        Mon, 17 Jan 2022 17:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9157CC36AED;
        Mon, 17 Jan 2022 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439207;
        bh=eRQgN6+6B/sk/4CSMI+LPdFbwm4PJOHQJ/Ld8kx8M0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+0hxz5tcNXNN02x+OQ5PS9fn043G2ZlOc8FD9Gs1Dbaifqk/bSshFs6X1OpQyEDg
         sj/ArdVdyu861VtuKIccK/1M+dup4cVoE0IadY0InXGeoX8popsx0WWCL2KbK2KudK
         YSxyhh816e9k33mYn1O/pqfOhHa2fvyuRtC/GLoXTo/hbnUiRPvCPpoSH4491TU9rP
         k9Mxub2DbxVqqLXoEuz52EWz7bII6W60iMSVW7zSWrb53FeR1OrLbfHtyW+LSg5Kar
         60lAWow8IJ1xL5BDt48BZsnZMBFKqyrPeFW8DUlNs7qXjbOE8fk3kuZUef0lyvOtwD
         54AM//DANEY5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 04/16] powerpc/cell: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:06:26 -0500
Message-Id: <20220117170638.1472900-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170638.1472900-1-sashal@kernel.org>
References: <20220117170638.1472900-1-sashal@kernel.org>
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
index 4b91ad08eefd9..c4f352387aec3 100644
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

