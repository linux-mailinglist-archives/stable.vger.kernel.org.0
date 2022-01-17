Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354EE490E97
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243155AbiAQRLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241427AbiAQRID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:08:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A23CEB81162;
        Mon, 17 Jan 2022 17:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAF6C36AED;
        Mon, 17 Jan 2022 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439280;
        bh=t5RLsDi1gqzl5ZKjE09qGfMniqUkYH6q6fx12EjtQxw=;
        h=From:To:Cc:Subject:Date:From;
        b=nHxxi/RJIBXaIBsZrKIhuqa7DjloRRUW4r9xmVk8X/Bm8iDq9MPImfZ81iGN/3ROi
         00Pfsdco3VgYVZunLS8qsHQqfGtIJ6jhAAgErz4tOU5MKe8dpgYrFfFeCpH7YX4EQs
         2tAF7yJs8od3rtVX+eYhoRhW1Kix7wJJnTW9RcTkhkgiDzLpk/yzHa6JWzJ1GOk1lV
         SqCI7WwfRzqLFvOH/K84ouq0dknNkBsw3f2YYZr2Kvip4shPpIvget41FOem2flCvP
         2N1nCZATdlOdNf7oA0UJE4Z++iTBJ9rW1ARt//G38ee48ptIy6XW9We6mEnoK9IBEj
         0DL+VuH5VPkog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 01/12] powerpc/6xx: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:07:45 -0500
Message-Id: <20220117170757.1473318-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index 9485f1024d46c..b3bcdce89c3bb 100644
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

