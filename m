Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960EF490D69
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241924AbiAQRC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241539AbiAQRBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99EC061747;
        Mon, 17 Jan 2022 09:01:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E5B5B81131;
        Mon, 17 Jan 2022 17:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65314C36AE3;
        Mon, 17 Jan 2022 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438895;
        bh=rfnii2i5sU04+NW982sp8A0gGiDGgjs8gxUSp7gBgk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apnRu4j2UHB0ClJBlM9qtvb2WysDL1TLJf0wNDddgh42OSLSeCqL3bWZLd1SxWdaB
         hC0O/B+ILdB2tgtDicpXeXsB76EG5Na210frQomhvaSqoi5WumfauNi9HJ7UYSNokX
         TCJTvk5G8qN+WGGkCxJp9UL88mtfrp+reIPj+E5ZzqntPbNSQjDgi5u1bZY3+1EEY4
         M/tOVEzU2f3en17cwrE38m5ZkEPBSyRVZTrN+bZtFiUQ8HLYWdNogihYd9JHeNPKdH
         0z9FoOIkCe6IwAZvJ2pUKPQcXasiUT2dfy0G+MzztvXQte5JIWQ0uBcOX6sGMWOt4m
         d8recFb+khZ/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 03/44] powerpc/powernv: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:00:46 -0500
Message-Id: <20220117170127.1471115-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit 7d405a939ca960162eb30c1475759cb2fdf38f8c ]

for_each_compatible_node performs an of_node_get on each iteration, so
a break out of the loop requires an of_node_put.

A simplified version of the semantic patch that fixes this problem is as
follows (http://coccinelle.lip6.fr):

// <smpl>
@@
local idexpression n;
expression e;
@@

 for_each_compatible_node(n,...) {
   ...
(
   of_node_put(n);
|
   e = n
|
+  of_node_put(n);
?  break;
)
   ...
 }
... when != n
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1448051604-25256-4-git-send-email-Julia.Lawall@lip6.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-lpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/opal-lpc.c b/arch/powerpc/platforms/powernv/opal-lpc.c
index 1e5d51db40f84..5390c888db162 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -396,6 +396,7 @@ void __init opal_lpc_init(void)
 		if (!of_get_property(np, "primary", NULL))
 			continue;
 		opal_lpc_chip_id = of_get_ibm_chip_id(np);
+		of_node_put(np);
 		break;
 	}
 	if (opal_lpc_chip_id < 0)
-- 
2.34.1

