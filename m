Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C95C490EDF
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiAQRMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244202AbiAQRLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:11:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1924DC0613EF;
        Mon, 17 Jan 2022 09:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE57C61241;
        Mon, 17 Jan 2022 17:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584EFC36AE3;
        Mon, 17 Jan 2022 17:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439206;
        bh=GLtLK6jPA6nPtqriz3ZVOeIfZ5OpRTdv6BTEh612+3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soBlRP+lU57ZB6J3ocmhi6HZnSHT3YyJtUJ2K3BL0w4cjKV3753Fb132m5g6PE5uX
         hr5JgpxCl7mtVHES95st7uvbzLojG1jjn+W61wGVmov+VnTd8kZbc4c5zi8dObpeIe
         ZDM4wCfju2br8HKvs0I4qIZ/d+QToH1jp3ChVN7dMaSgLEC+fnx4lecPyMq09IKEp6
         edHytZvtyzCsNCPtOBuULlGigedK/cNdjE1lUUVKlzZFm8zQX6OafTzBqnhys+8qf2
         8CYjD4OIYGVKtVkFx+uj0nv1OFyBGU3CIT3nM0ZND3r+d/WFvVjeyRwKKrSnjciLvf
         5ROSWPYY8jj6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 03/16] powerpc/powernv: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:06:25 -0500
Message-Id: <20220117170638.1472900-3-sashal@kernel.org>
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
index 6c7ad1d8b32ed..21f0edcfb84ad 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -400,6 +400,7 @@ void __init opal_lpc_init(void)
 		if (!of_get_property(np, "primary", NULL))
 			continue;
 		opal_lpc_chip_id = of_get_ibm_chip_id(np);
+		of_node_put(np);
 		break;
 	}
 	if (opal_lpc_chip_id < 0)
-- 
2.34.1

