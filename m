Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D86490F34
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242227AbiAQRQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243775AbiAQRNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:13:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A89CC08E8AA;
        Mon, 17 Jan 2022 09:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F0B611F0;
        Mon, 17 Jan 2022 17:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5330C36AEF;
        Mon, 17 Jan 2022 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439286;
        bh=bZMho04zzMVM6kYWcyHEghrY3neLzEAufpfoVc5JEsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrOOne6mhIPMCQgjTbjjmtxb1BMgpsIzxuuR1WndIV1hr+7b3HK/eKha1BDJ5q6kW
         jzHMwTNmcW3LnNJ49VrSEccwmlOLIBM6JcX3t6vNXuL12/EBfjkwPcwJLD8zu5rVCR
         zkm6qNd7mUTOsWU6gP6Kv5sNl9AoovbIQRWWcZ6xFzMDO6PqeTFvnyTsTpDmDkL2mc
         pEtiAUx141ucaIsZaXtf0aE6AgZVfJPpqZh7jpiG/aMW2mUY/MPQiH3e7qvDQ4HV0N
         04aJ0MK6g56/G0G95fR7ypo/YJ+o/kS/T6HF8vSv7x9Zv2SAX3MALrpAbOU5uhGFHY
         eDivXIM+jQEgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nick.child@ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 04/12] powerpc/btext: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:07:48 -0500
Message-Id: <20220117170757.1473318-4-sashal@kernel.org>
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
index 41c011cb60706..8d05ef26dea9d 100644
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

