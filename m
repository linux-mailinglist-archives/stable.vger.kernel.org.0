Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF39656ECC
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiL0UeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiL0Ud1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58087D2F2;
        Tue, 27 Dec 2022 12:33:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 092EFB811F8;
        Tue, 27 Dec 2022 20:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BFFC43396;
        Tue, 27 Dec 2022 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173203;
        bh=BrDUbIrVoW2BUe2qufHgJh+G9VbCZValrLnWyScWb6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNjlLifk6wXmuOGsmEh3u/46gwSrkGvBaOrzHdoRXszmxDXZ4BgeKjwp/j7WJnUAy
         nUizh1dbugEmgOGLJfVqkBhnR3u8lQjXbWPsJIST1kM24AWDcubVV7IFngr+PW7Z8B
         Ks97WgFsSu+Zj1deIlIRCsGQTorUJ37uHr5sNsOoF2oM57K61FAVgoy0gc/bhviqj7
         SCZ6P/+hF3n0o7hl0O9d+bveYp20/djLSqbXHNWfStyWhgLvyjYmciuH/OUQm0A8LV
         3cDGCag4PtA8wRbunsw+44Snw5WoiCeJORjUAn3MJ/Q+cUdT5Ji2kcIeMMdTcWQ/f3
         S8cPnEZ1OXc3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, ldufour@linux.ibm.com,
        paulus@ozlabs.org, christophe.leroy@csgroup.eu,
        sourabhjain@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 21/28] powerpc/rtas: avoid device tree lookups in rtas_os_term()
Date:   Tue, 27 Dec 2022 15:32:42 -0500
Message-Id: <20221227203249.1213526-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
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
index e847f9b1c5b9..6b5f49c9ad79 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -889,6 +889,7 @@ void __noreturn rtas_halt(void)
 
 /* Must be in the RMO region, so we place it here */
 static char rtas_os_term_buf[2048];
+static s32 ibm_os_term_token = RTAS_UNKNOWN_SERVICE;
 
 void rtas_os_term(char *str)
 {
@@ -900,14 +901,13 @@ void rtas_os_term(char *str)
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
 
@@ -1277,6 +1277,13 @@ void __init rtas_initialize(void)
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

