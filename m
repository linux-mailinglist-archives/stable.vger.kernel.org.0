Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C0D656F88
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiL0Ur1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiL0UqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:46:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CACDF9F;
        Tue, 27 Dec 2022 12:37:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0003B811FC;
        Tue, 27 Dec 2022 20:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A9C433D2;
        Tue, 27 Dec 2022 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173358;
        bh=gLHa8wPVNasYI+GMR7fWgGDvdoezUkTB1n1PKg3VzD0=;
        h=From:To:Cc:Subject:Date:From;
        b=o/m4tllxY/wc4nQSF1hZCL5ejPlXlzGHNGiIRafN+eR5Meo7rar9UvDW95KSKxjAP
         PS5NYWYDn73O2kG9knPFEQVR0k9+nnOKzwpUlHFJoDj7CUJnEJc6CNqbGJRAhoRB/C
         YfxtvOyMQY4P041bYMK8/1uKu6cpZsGoYg3jpDY6bQApS5CQX5xbNS2hpEmCVMBrDW
         LaVL1AouubLrM+nbt7hxTHqKqAEz7UOPxxpiRZ06WDl9QyoCBvjmoccNqBuFYcbDgt
         zP2uTnYtyoM9fDb61EZVTdwoJkFp1YehGevCjtM4XXlkIi+lenhKE/dztEH05/myXm
         4JizYWokHY2dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, ldufour@linux.ibm.com,
        christophe.leroy@csgroup.eu, paulus@ozlabs.org,
        sourabhjain@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 1/4] powerpc/rtas: avoid device tree lookups in rtas_os_term()
Date:   Tue, 27 Dec 2022 15:35:50 -0500
Message-Id: <20221227203555.1214746-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit ed2213bfb192ab51f09f12e9b49b5d482c6493f3 ]

rtas_os_term() is called during panic. Its behavior depends on a couple
of conditions in the /rtas node of the device tree, the traversal of
which entails locking and local IRQ state changes. If the kernel panics
while devtree_lock is held, rtas_os_term() as currently written could
hang.

Instead of discovering the relevant characteristics at panic time,
cache them in file-static variables at boot. Note the lookup for
"ibm,extended-os-term" is converted to of_property_read_bool() since it
is a boolean property, not an RTAS function token.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
[mpe: Incorporate suggested change from Nick]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221118150751.469393-4-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index b492cb1c36fd..4c9ed28465b3 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -717,6 +717,7 @@ void __noreturn rtas_halt(void)
 
 /* Must be in the RMO region, so we place it here */
 static char rtas_os_term_buf[2048];
+static s32 ibm_os_term_token = RTAS_UNKNOWN_SERVICE;
 
 void rtas_os_term(char *str)
 {
@@ -728,14 +729,13 @@ void rtas_os_term(char *str)
 	 * this property may terminate the partition which we want to avoid
 	 * since it interferes with panic_timeout.
 	 */
-	if (RTAS_UNKNOWN_SERVICE == rtas_token("ibm,os-term") ||
-	    RTAS_UNKNOWN_SERVICE == rtas_token("ibm,extended-os-term"))
+	if (ibm_os_term_token == RTAS_UNKNOWN_SERVICE)
 		return;
 
 	snprintf(rtas_os_term_buf, 2048, "OS panic: %s", str);
 
 	do {
-		status = rtas_call(rtas_token("ibm,os-term"), 1, 1, NULL,
+		status = rtas_call(ibm_os_term_token, 1, 1, NULL,
 				   __pa(rtas_os_term_buf));
 	} while (rtas_busy_delay(status));
 
@@ -1332,6 +1332,13 @@ void __init rtas_initialize(void)
 	no_entry = of_property_read_u32(rtas.dev, "linux,rtas-entry", &entry);
 	rtas.entry = no_entry ? rtas.base : entry;
 
+	/*
+	 * Discover these now to avoid device tree lookups in the
+	 * panic path.
+	 */
+	if (of_property_read_bool(rtas.dev, "ibm,extended-os-term"))
+		ibm_os_term_token = rtas_token("ibm,os-term");
+
 	/* If RTAS was found, allocate the RMO buffer for it and look for
 	 * the stop-self token if any
 	 */
-- 
2.35.1

