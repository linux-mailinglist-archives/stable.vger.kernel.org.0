Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68AD490EE0
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiAQRMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbiAQRLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:11:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA15C061760;
        Mon, 17 Jan 2022 09:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E06B81170;
        Mon, 17 Jan 2022 17:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D97C36AE7;
        Mon, 17 Jan 2022 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439209;
        bh=31mIpIf4U5NaA21ma6Md0jO8Atfeo/xK83c8MkT/dOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsPm657aHRZ+oSdxyeS/GeSKnG1o26YEyMUBGeMHW+N/PGU66ut66iULsCzMatGOY
         w7pwo+1enj/i7iDtPQHlk65HLiVDGybVc06VojU4UI5YjS3P8cUZoEy6rX6fw9ngs6
         hJjEgN4PhtatVyUUbw4xsW6V4VzK56oFLYwd9v9TT0IGCWR4bKJy6JoRWZ6TDldSdI
         epp4+SgujkLh7KfFGcepYTtyHllWZIfBdCb4Vsl4MDCBwlBA5fq0V71Gb6FZ+5rvp4
         del6QaOnC4TWtX9f5w2jH2IoqUCYQDyJdyoeSmv+vtyyXM79IDpEh4+GrbQtlO0Fx+
         6eiazH6mPFWjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nick.child@ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 05/16] powerpc/btext: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:06:27 -0500
Message-Id: <20220117170638.1472900-5-sashal@kernel.org>
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
index 6537cba1a7580..d1a2fc7186ce7 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -258,8 +258,10 @@ int __init btext_find_display(int allow_nonstdout)
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

