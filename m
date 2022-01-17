Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7D9490EC2
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbiAQRLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243671AbiAQRKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:10:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD7AC061A7D;
        Mon, 17 Jan 2022 09:05:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE9F16126B;
        Mon, 17 Jan 2022 17:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F128C36AE3;
        Mon, 17 Jan 2022 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439157;
        bh=jbFpHmEm0LhR9WntBAIKJZUHg3ZypDEqqJtUJca1zAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgeuHgvCXmlLOSVN9Ijl+nKgcyQodHITqeW//oiTzRH7SCXyjCmTFWHant2fhVMnk
         Gh8TbaR0f3XXRlyq7K3zmtQhQoVVE27IvuxDeW16A52R2VYj95fR0AZCm9ogSss3wU
         OYdx7YNDP9xWj0p43He4sVrvlf02RX90jOPnskLSdjkvjk92qYH6oAHuOsuGU9wzVH
         9wqEOAmruJt9Ye1HPx9lF6TBgH+5EGFolfFFtkIwKLZZ+Jl4YP/wQ4Bo1YRsNt8pJ9
         QGCpFQsHtp66B7ycg7xKcO47p3hKxjtmalQyKXFZI6stP08CQ1ZcgotxVnw7/79kY3
         0jG9sNjK8uGWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 02/17] powerpc/6xx: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:05:36 -0500
Message-Id: <20220117170551.1472640-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170551.1472640-1-sashal@kernel.org>
References: <20220117170551.1472640-1-sashal@kernel.org>
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
index 8112b39879d67..7b4edf1cb2c8d 100644
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

