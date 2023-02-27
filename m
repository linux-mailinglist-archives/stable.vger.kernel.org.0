Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC46A4BD3
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 20:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjB0T7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 14:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjB0T7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 14:59:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C801CAE1;
        Mon, 27 Feb 2023 11:59:10 -0800 (PST)
Date:   Mon, 27 Feb 2023 19:59:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677527940;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4KEBBZ/Pg7k5qKdW9OQ/6jkuLtTjqleiDqhex5agCM=;
        b=ksJ5W/bvKui0QivzeqYvJV/0oGvZ1tMmr6zbBONgSC/0CVow65JSIxRI7QCRRA+mdzsszj
        MgJ0vXlFa7t0P77smn7EuEAKMGFr7qjyRmypraaaKdvgqZgZWHu7GHvtHyZkEm6/2GkIv+
        GIqCA2K1/WTbvK+eQhplxdceLRSa6JGl0AD6dBsE1pUI11ufqXaE5gW8LE8tp5T+bjkuxj
        +uW+A1MsXSGZslvwioDfi2aqiLz56VRjmiScNm5d+V8wGbrGSPrMGL9RWhsY/kmGy8/I6M
        Fept1B5ajQpYoZUlOEL0Me6midmJL4ejwV9FsdUJQVpE4TZtzU81kgvqo3bKUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677527940;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4KEBBZ/Pg7k5qKdW9OQ/6jkuLtTjqleiDqhex5agCM=;
        b=Qf1vkK27PCsj3pQUv1HWsphgyNYhrWKbq2H4GdM6Js98+b5pFaub/cFyv04nwmQ+8NXG39
        UJuVXLQyVy6S3TDQ==
From:   "tip-bot2 for KP Singh" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/speculation: Allow enabling STIBP with legacy IBRS
Cc:     joseloliveira11@gmail.com,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        KP Singh <kpsingh@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230220120127.1975241-1-kpsingh@kernel.org>
References: <20230220120127.1975241-1-kpsingh@kernel.org>
MIME-Version: 1.0
Message-ID: <167752794021.5837.7575103462334259742.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     6921ed9049bc7457f66c1596c5b78aec0dae4a9d
Gitweb:        https://git.kernel.org/tip/6921ed9049bc7457f66c1596c5b78aec0da=
e4a9d
Author:        KP Singh <kpsingh@kernel.org>
AuthorDate:    Mon, 27 Feb 2023 07:05:40 +01:00
Committer:     Borislav Petkov (AMD) <bp@alien8.de>
CommitterDate: Mon, 27 Feb 2023 18:57:09 +01:00

x86/speculation: Allow enabling STIBP with legacy IBRS

When plain IBRS is enabled (not enhanced IBRS), the logic in
spectre_v2_user_select_mitigation() determines that STIBP is not needed.

The IBRS bit implicitly protects against cross-thread branch target
injection. However, with legacy IBRS, the IBRS bit is cleared on
returning to userspace for performance reasons which leaves userspace
threads vulnerable to cross-thread branch target injection against which
STIBP protects.

Exclude IBRS from the spectre_v2_in_ibrs_mode() check to allow for
enabling STIBP (through seccomp/prctl() by default or always-on, if
selected by spectre_v2_user kernel cmdline parameter).

  [ bp: Massage. ]

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs option to suppor=
t Kernel IBRS")
Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230220120127.1975241-1-kpsingh@kernel.org
Link: https://lore.kernel.org/r/20230221184908.2349578-1-kpsingh@kernel.org
---
 arch/x86/kernel/cpu/bugs.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index cf81848..f9d060e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1133,14 +1133,18 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
=20
-static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
 {
-	return mode =3D=3D SPECTRE_V2_IBRS ||
-	       mode =3D=3D SPECTRE_V2_EIBRS ||
+	return mode =3D=3D SPECTRE_V2_EIBRS ||
 	       mode =3D=3D SPECTRE_V2_EIBRS_RETPOLINE ||
 	       mode =3D=3D SPECTRE_V2_EIBRS_LFENCE;
 }
=20
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return spectre_v2_in_eibrs_mode(mode) || mode =3D=3D SPECTRE_V2_IBRS;
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1203,12 +1207,19 @@ spectre_v2_user_select_mitigation(void)
 	}
=20
 	/*
-	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
-	 * STIBP is not required.
+	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIBP
+	 * is not required.
+	 *
+	 * Enhanced IBRS also protects against cross-thread branch target
+	 * injection in user-mode as the IBRS bit remains always set which
+	 * implicitly enables cross-thread protections.  However, in legacy IBRS
+	 * mode, the IBRS bit is set only on kernel entry and cleared on return
+	 * to userspace. This disables the implicit cross-thread protection,
+	 * so allow for STIBP to be selected in that case.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
=20
 	/*
@@ -2340,7 +2351,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
=20
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
=20
 	switch (spectre_v2_user_stibp) {
