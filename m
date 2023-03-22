Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88E96C532B
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCVSBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjCVSBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:01:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1798B62FF4;
        Wed, 22 Mar 2023 11:01:29 -0700 (PDT)
Date:   Wed, 22 Mar 2023 18:01:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679508088;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=5PgEDmro4yjI2UKRUYxXDJNpNbStexhsQitnTZusH+Q=;
        b=hDCQBhCO/OuDoULIKRwyVWns1Bj5daKW2trAzdA3ebmbUWm5/Qck/cQVUapCyRBIU4Vvy+
        2T2I7oo+vKc+ApGwrlIZkzBFb7WZsFpLzP+cgJKzRdk79TeZSMAINb62STSqEEIpI56eE4
        jb/cAntlU5j9eoNqEq4O3iqpllW5F8CLg5rxO+C18bBD8xVQSn0JxkHt3ujy3NZio3yBh7
        nK63V2hQ62qNuZ+TDhkK8Ip62Dd2n66clkOmRtMBpckpFCKB3gFs7vmaidNPGy9qzNh8SH
        5tYfDA6RhQ4DFeREnKnQSyn6L/o2rGZZNbCXXszcij8DxHQ26UnN7mFg4Slqyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679508088;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=5PgEDmro4yjI2UKRUYxXDJNpNbStexhsQitnTZusH+Q=;
        b=25xBVLzHo1BGnw8kKlEJyzYaHa79YGuoEANTrryyQlxc0bG2u2KXu1YL63o/X75FCRGBod
        iLDijwa7kpsVSQDQ==
From:   tip-bot2 for Michal =?utf-8?q?Koutn=C3=BD?= 
        <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm: Do not shuffle CPU entry areas without KASLR
Cc:     mkoutny@suse.com, Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <167950808805.5837.638304039500769110.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a3f547addcaa10df5a226526bc9e2d9a94542344
Gitweb:        https://git.kernel.org/tip/a3f547addcaa10df5a226526bc9e2d9a945=
42344
Author:        Michal Koutn=C3=BD <mkoutny@suse.com>
AuthorDate:    Mon, 06 Mar 2023 20:31:44 +01:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Wed, 22 Mar 2023 10:42:47 -07:00

x86/mm: Do not shuffle CPU entry areas without KASLR

The commit 97e3d26b5e5f ("x86/mm: Randomize per-cpu entry area") fixed
an omission of KASLR on CPU entry areas. It doesn't take into account
KASLR switches though, which may result in unintended non-determinism
when a user wants to avoid it (e.g. debugging, benchmarking).

Generate only a single combination of CPU entry areas offsets -- the
linear array that existed prior randomization when KASLR is turned off.

Since we have 3f148f331814 ("x86/kasan: Map shadow for percpu pages on
demand") and followups, we can use the more relaxed guard
kasrl_enabled() (in contrast to kaslr_memory_enabled()).

Fixes: 97e3d26b5e5f ("x86/mm: Randomize per-cpu entry area")
Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20230306193144.24605-1-mkoutny%40suse.com
---
 arch/x86/mm/cpu_entry_area.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 7316a82..e91500a 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -10,6 +10,7 @@
 #include <asm/fixmap.h>
 #include <asm/desc.h>
 #include <asm/kasan.h>
+#include <asm/setup.h>
=20
 static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_stor=
age);
=20
@@ -29,6 +30,12 @@ static __init void init_cea_offsets(void)
 	unsigned int max_cea;
 	unsigned int i, j;
=20
+	if (!kaslr_enabled()) {
+		for_each_possible_cpu(i)
+			per_cpu(_cea_offset, i) =3D i;
+		return;
+	}
+
 	max_cea =3D (CPU_ENTRY_AREA_MAP_SIZE - PAGE_SIZE) / CPU_ENTRY_AREA_SIZE;
=20
 	/* O(sodding terrible) */
