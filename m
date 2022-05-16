Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C399529129
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348386AbiEPUGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348576AbiEPT6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B63DA4D;
        Mon, 16 May 2022 12:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E7E960ABE;
        Mon, 16 May 2022 19:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EADC34100;
        Mon, 16 May 2022 19:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730647;
        bh=jpiRU41G7rib5KT8rX+ATDSBSQFLApOjYbiJIWyGoGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzBojgvKSlq6PdEqdqObIml/cSWWgbmMBhV47oM8/Jt+3Am2HBvVw+WWRcrSP214W
         2dcdNlD5qXF5rfnjUlcL/k/lsEA7jQoKKIJICck1BtH8LeBm2CxNLepEnB875fC7NE
         cpcBqSEV81gXxr9dryOHhy/7COj+bjsXA0jlm0zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian-Ken Rueegsegger <ken@codelabs.ch>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.15 066/102] x86/mm: Fix marking of unused sub-pmd ranges
Date:   Mon, 16 May 2022 21:36:40 +0200
Message-Id: <20220516193625.892146402@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian-Ken Rueegsegger <ken@codelabs.ch>

commit 280abe14b6e0a38de9cc86fe6a019523aadd8f70 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init_64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -902,6 +902,8 @@ static void __meminit vmemmap_use_sub_pm
 
 static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long end)
 {
+	const unsigned long page = ALIGN_DOWN(start, PMD_SIZE);
+
 	vmemmap_flush_unused_pmd();
 
 	/*
@@ -914,8 +916,7 @@ static void __meminit vmemmap_use_new_su
 	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
 	 */
 	if (!IS_ALIGNED(start, PMD_SIZE))
-		memset((void *)start, PAGE_UNUSED,
-			start - ALIGN_DOWN(start, PMD_SIZE));
+		memset((void *)page, PAGE_UNUSED, start - page);
 
 	/*
 	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of


