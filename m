Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4364049A44A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369437AbiAYABp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1849510AbiAXX0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:26:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF09FC073232;
        Mon, 24 Jan 2022 13:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87718B8105C;
        Mon, 24 Jan 2022 21:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B616CC340E4;
        Mon, 24 Jan 2022 21:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059795;
        bh=noPkjLggVRzhHtJtUyyY8AiSqQGvqU0JZkwRb0GYV3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pxv8rjPpV/6ZrQ5boOZf2hsy7EPGobqRaLYBOJxilQB7Jz7O4DN00LU+lFWBOOuH+
         YILReWVU4I9AxjfzYpbPAJQU+rn1QB8shop4E/ReJwOvNqyDJEEyzp5yxht4T/P1pS
         nd935g9MHZz92Ozhd8HjZa6oSHoanFX5NDp50ckg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0737/1039] powerpc/btext: add missing of_node_put
Date:   Mon, 24 Jan 2022 19:42:06 +0100
Message-Id: <20220124184150.101609634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 803c2a45b22ac..1cffb5e7c38d6 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -241,8 +241,10 @@ int __init btext_find_display(int allow_nonstdout)
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



