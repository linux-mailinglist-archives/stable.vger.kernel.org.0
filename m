Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D09490E63
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiAQRIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241721AbiAQRGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5197B81161;
        Mon, 17 Jan 2022 17:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B940AC36AEC;
        Mon, 17 Jan 2022 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439203;
        bh=qNILM1RdhmA5Zm0cLlQ79sNMcY7CTw2k9YHU8nTci04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQAuAGKXD3/PpBxLOoD3pkbUIRj3etAh0xSE8sPb3qXvSBjNa46HCh7/hFE3Neo1z
         LGXBm2TjmVSoGZawGM7SIyHhZi3lcsP/yijwN7dkwgygJEdLUSfUVB0aOxB1ihcsv6
         XahYbygGn1hWS/7RPTyY9ca5yFk5VFlaARMjOVPz+xwCs63avKfRloRcmzphJoBNDm
         LSWqeidMCxHPkirD+88p8uty+xALISWGP/xuk9BrYu99/w13GGd1fdOxGOyOoloDQS
         2EDknFe4BjJqGxutiXN3OmXUtIKEMmqZ9qm34pqFMMUdlnF8rrDk7FgYHV4JTLfMKV
         FzvUXdE/eKBjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 02/16] powerpc/6xx: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:06:24 -0500
Message-Id: <20220117170638.1472900-2-sashal@kernel.org>
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
index bf4a125faec66..db2ea6b6889de 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -220,6 +220,7 @@ void hlwd_pic_probe(void)
 			irq_set_chained_handler(cascade_virq,
 						hlwd_pic_irq_cascade);
 			hlwd_irq_host = host;
+			of_node_put(np);
 			break;
 		}
 	}
-- 
2.34.1

