Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88796490D66
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiAQRCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiAQRBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15C4C061798;
        Mon, 17 Jan 2022 09:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEC14B81131;
        Mon, 17 Jan 2022 17:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A665EC36AE3;
        Mon, 17 Jan 2022 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438892;
        bh=GjXLsfRDL+vMnvwCNX4tCqIZuHwbl8YDD1glN2o18Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0Fz9ngGUKpCEQpMoaNrLMm0U1i4ouFOuFn8JWQfSR3BkpH6Zx8pEA+wTIeODf95q
         +bRuIVMFB0t9XNp0ipgX7Cy58wQdXG+3kIyWgq1/YjgIH9ePRZ1QrskZqtGb+NtxHB
         QeOBFASKFTLH00sJFyUQb8nPnQhZTJkImSwlAXVf+wPZTQBpBFNbLCghSTqzySKJhu
         xlqeBBcBGAUq1MaX7Rjj48lcbw2CbQJ+x+YvmD5ovcTlO6vhDTyd8KPdUFnBg0Tp3e
         jGKZjGtPIO1S9nL/aigPqt0Ko05c0xkXvMUeAY4CrcEEoWm/RYhUChw05vBzyExMYl
         VX7s2BGzvEZLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Lawall <Julia.Lawall@lip6.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 02/44] powerpc/6xx: add missing of_node_put
Date:   Mon, 17 Jan 2022 12:00:45 -0500
Message-Id: <20220117170127.1471115-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index 15396333a90bd..a4b020e4b6af0 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -214,6 +214,7 @@ void hlwd_pic_probe(void)
 			irq_set_chained_handler(cascade_virq,
 						hlwd_pic_irq_cascade);
 			hlwd_irq_host = host;
+			of_node_put(np);
 			break;
 		}
 	}
-- 
2.34.1

