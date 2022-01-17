Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D989F490F10
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbiAQROa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243639AbiAQRM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:12:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93EAC03463F;
        Mon, 17 Jan 2022 09:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C0D5611F2;
        Mon, 17 Jan 2022 17:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A727C36AE7;
        Mon, 17 Jan 2022 17:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439251;
        bh=n+OG6gPeo3Ix3CdWwgkqT9r920PvemF2ny3sKHTPWSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNo4qZse3BvgQtfnYIRkkeDb5b4AS8lGZ4En+r0sw8+qRM1IxJqsY65eA03zHBspN
         GgzkV+SCiPBVBO6bu1n8QQuHr1f4KVlpaY8ZeXjY2fUjEEj8hzHs31WnAldQQ0c5Og
         uKMeLDRx9yMhyrLc1E4vMTclISFBOIvNYkzEVySb/CsKmYhBHfYjq+cuyG0084E1GZ
         uXhMEOUR2Buh0ycPHP+N85KjYLGJiRoI1vzl1F4ipyvitXJOuQgGbKrs3Im57S0w/6
         sKKZQuiHHDRxlOz8VpFyxhkB36bI+9Dz4Dyy8i8OTipSkiCXCYu0nH+nHvOnQ8m6Az
         Fh3uumsY/pFQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nick.child@ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 04/13] powerpc/btext: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:07:12 -0500
Message-Id: <20220117170722.1473137-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170722.1473137-1-sashal@kernel.org>
References: <20220117170722.1473137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

[ Upstream commit a1d2b210ffa52d60acabbf7b6af3ef7e1e69cda0 ]

for_each_node_by_type performs an of_node_get on each iteration, so
a break out of the loop requires an of_node_put.

A simplified version of the semantic patch that fixes this problem is as
follows (http://coccinelle.lip6.fr):

// <smpl>
@@
local idexpression n;
expression e;
@@

 for_each_node_by_type(n,...) {
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
Link: https://lore.kernel.org/r/1448051604-25256-6-git-send-email-Julia.Lawall@lip6.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/btext.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 8275858a434d9..2d91ba38b4524 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -257,8 +257,10 @@ int __init btext_find_display(int allow_nonstdout)
 			rc = btext_initialize(np);
 			printk("result: %d\n", rc);
 		}
-		if (rc == 0)
+		if (rc == 0) {
+			of_node_put(np);
 			break;
+		}
 	}
 	return rc;
 }
-- 
2.34.1

