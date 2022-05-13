Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF2C526042
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 12:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379597AbiEMKpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 06:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379578AbiEMKpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 06:45:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B305E2A0A53;
        Fri, 13 May 2022 03:45:00 -0700 (PDT)
Date:   Fri, 13 May 2022 10:44:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652438699;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EkUKbhIzdWY6DspgZgLqMzIdvrE6pzQPrbY/UY1c64c=;
        b=gqealpZhrinicZHEZ+BPg/kD3YKC7UeYXQsYz2q2XwynyzlvEOXSHlRoOsWafLtWmX6pPS
        PW9PrNqAPIkh0o7SNonXLufZ1ZNAInfQMW39lfpAeIgvcg4Aq80jJweSd0a8JWTjRgATlm
        iDGwuKK+tKDM2Wmuw1FHlFZJC5fFbbbBmZa87cAbOTH88j0brrp/RTqtKgEmhJ9vWpXCEM
        mS3nrOKXRN/XE/ES7dx4Eg8b+p/epK4luKYeFpYKESzTjse3mP+tV2z75hKyVkzYz6BGjR
        69bNqjPsZw9sthnQ2RsHJ/WnKBlZgVxFy5caMbNpYSrQNHa+2UJ2Iqz34u9ugQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652438699;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EkUKbhIzdWY6DspgZgLqMzIdvrE6pzQPrbY/UY1c64c=;
        b=aWflv7Ujn7hIkDlXmn/LVtKU2E8C+Tm/4mKBJl8xl34p8Ojo+3wzvTsN0UQkmC8ydnGmZI
        SlvceryQKdLXjsCQ==
From:   "tip-bot2 for Adrian-Ken Rueegsegger" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm: Fix marking of unused sub-pmd ranges
Cc:     "Adrian-Ken Rueegsegger" <ken@codelabs.ch>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220509090637.24152-2-ken@codelabs.ch>
References: <20220509090637.24152-2-ken@codelabs.ch>
MIME-Version: 1.0
Message-ID: <165243869785.4207.350965258098905435.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     280abe14b6e0a38de9cc86fe6a019523aadd8f70
Gitweb:        https://git.kernel.org/tip/280abe14b6e0a38de9cc86fe6a019523aadd8f70
Author:        Adrian-Ken Rueegsegger <ken@codelabs.ch>
AuthorDate:    Mon, 09 May 2022 11:06:37 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 13 May 2022 12:41:21 +02:00

x86/mm: Fix marking of unused sub-pmd ranges

The unused part precedes the new range spanned by the start, end parameters
of vmemmap_use_new_sub_pmd(). This means it actually goes from
ALIGN_DOWN(start, PMD_SIZE) up to start.

Use the correct address when applying the mark using memset.

Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220509090637.24152-2-ken@codelabs.ch
---
 arch/x86/mm/init_64.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 96d34eb..e294233 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -902,6 +902,8 @@ static void __meminit vmemmap_use_sub_pmd(unsigned long start, unsigned long end
 
 static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long end)
 {
+	const unsigned long page = ALIGN_DOWN(start, PMD_SIZE);
+
 	vmemmap_flush_unused_pmd();
 
 	/*
@@ -914,8 +916,7 @@ static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long
 	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
 	 */
 	if (!IS_ALIGNED(start, PMD_SIZE))
-		memset((void *)start, PAGE_UNUSED,
-			start - ALIGN_DOWN(start, PMD_SIZE));
+		memset((void *)page, PAGE_UNUSED, start - page);
 
 	/*
 	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of
