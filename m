Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2552490DFF
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241942AbiAQRGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51308 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbiAQRDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:03:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6EA4B8115B;
        Mon, 17 Jan 2022 17:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DDFC36AE3;
        Mon, 17 Jan 2022 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439013;
        bh=ETddzE3Lq3EU9bMSDlE2ShnRd8iiKQWFS2i5TL7wyWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxXzX+AOF1dIPLuJrAPplQZUD8zA6BLh0vOCN/RUQGqgO3L2uGHJB4RQK3I0VZYWh
         lJdBiT0s4DZ2KjP3UzR4pIWdzeQpUWlWTJtuf/LoMGbp7jMRFxIwsoWiV4GsYbwWET
         yvjU/GPI8CpInUCufY1U/b2bJrpgcFab34hzNn/JU4OBiffFGjz1xFptj1LZGpZxCC
         EJP+mv8J3mbmU6eXQnGc3hcM0FX0mTad/MjQB2JdZ3rtCWZjmfCqeVHIXwdlndrEM3
         tiL1QbNAwfk9AvG/WyPntboHFwItk2pkJHWttmfgNSDZLIP2IpEVZyN/Xe4A+HOOv2
         w0kL8Fuy7TNWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 03/34] powerpc/6xx: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:02:53 -0500
Message-Id: <20220117170326.1471712-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit f6e82647ff71d427d4148964b71f239fba9d7937 ]

for_each_compatible_node performs an of_node_get on each iteration, so
a break out of the loop requires an of_node_put.

A simplified version of the semantic patch that fixes this problem is as
follows (http://coccinelle.lip6.fr):

// <smpl>
@@
expression e;
local idexpression n;
@@

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
Link: https://lore.kernel.org/r/1448051604-25256-2-git-send-email-Julia.Lawall@lip6.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index a1b7f79a8a152..de10c13de15c6 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -215,6 +215,7 @@ void hlwd_pic_probe(void)
 			irq_set_chained_handler(cascade_virq,
 						hlwd_pic_irq_cascade);
 			hlwd_irq_host = host;
+			of_node_put(np);
 			break;
 		}
 	}
-- 
2.34.1

