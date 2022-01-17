Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBAD490E99
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243206AbiAQRLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58284 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241467AbiAQRIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:08:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7108F611E2;
        Mon, 17 Jan 2022 17:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190C3C36AED;
        Mon, 17 Jan 2022 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439282;
        bh=nRljK2iWbb10p4w6RFd1lQ40Hofhpav2Nn+BCIRYQ08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ay9k+WHiZcFiHgBMiLiDtsMUTcLao1vyqRJyvdFdJFL6D38UnFpgWQzTNTdV7WAYf
         yCGy5FG18cEZ9HF+WHRO0vkO2iAAK7fvyGPHhKkGouDngt0QbZAOsbM3M7s3deius0
         PWHvHytcIg9uSLf/X1hVs06h+KaHAE243e0gBpLQpcxIt4YbyN6j5yErJKcZUidZf/
         QkGHTSvbDY4jSrwx7JmCdfoBPn6Yd8/LCjMN8RG1P/8E8al4LnHwe3vJrjaq6knNDw
         JFonwT60mxISFkxQy3rZMnvF6JdaNdfxs0RtnUBD7TueR/y/m/TwPFLcZSOGexTgBN
         IF8P4y5DNc6QQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 02/12] powerpc/powernv: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:07:46 -0500
Message-Id: <20220117170757.1473318-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170757.1473318-1-sashal@kernel.org>
References: <20220117170757.1473318-1-sashal@kernel.org>
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
index e4169d68cb328..d28c4a9269c38 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -401,6 +401,7 @@ void opal_lpc_init(void)
 		if (!of_get_property(np, "primary", NULL))
 			continue;
 		opal_lpc_chip_id = of_get_ibm_chip_id(np);
+		of_node_put(np);
 		break;
 	}
 	if (opal_lpc_chip_id < 0)
-- 
2.34.1

