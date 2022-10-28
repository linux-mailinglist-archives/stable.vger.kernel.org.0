Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBAC61106A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJ1MFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiJ1MFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186C62A956
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46AF62807
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60A6C433D6;
        Fri, 28 Oct 2022 12:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958712;
        bh=sL3uA0vIfzCwFggOy1MGxMSWIBjwymVUOWgvUHstnQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJ1EpbcjqOqDJKJJsI7zWBs5bfxKtauYkAHsG6QQnqSIeHRGDf6qLEXDfiOAeSG3t
         AxQlGdoDnwpfjwBFiOVTrTE37PbfxLbSPCg2YcEbzXlRnv7Q5qaEEzdoGh+nNclyxR
         4DuqrQC5IUlbqwM8TseBOm08B4uG6g0U4B1w/DGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C8=98tefan=20Talpalaru?= <stefantalpalaru@yahoo.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 06/73] x86/microcode/AMD: Apply the patch early on every logical thread
Date:   Fri, 28 Oct 2022 14:03:03 +0200
Message-Id: <20221028120232.642150765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit e7ad18d1169c62e6c78c01ff693fd362d9d65278 upstream.

Currently, the patch application logic checks whether the revision
needs to be applied on each logical CPU (SMT thread). Therefore, on SMT
designs where the microcode engine is shared between the two threads,
the application happens only on one of them as that is enough to update
the shared microcode engine.

However, there are microcode patches which do per-thread modification,
see Link tag below.

Therefore, drop the revision check and try applying on each thread. This
is what the BIOS does too so this method is very much tested.

Btw, change only the early paths. On the late loading paths, there's no
point in doing per-thread modification because if is it some case like
in the bugzilla below - removing a CPUID flag - the kernel cannot go and
un-use features it has detected are there early. For that, one should
use early loading anyway.

  [ bp: Fixes does not contain the oldest commit which did check for
    equality but that is good enough. ]

Fixes: 8801b3fcb574 ("x86/microcode/AMD: Rework container parsing")
Reported-by:  Ștefan Talpalaru <stefantalpalaru@yahoo.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by:  Ștefan Talpalaru <stefantalpalaru@yahoo.com>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216211
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -441,7 +441,13 @@ apply_microcode_early_amd(u32 cpuid_1_ea
 		return ret;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev >= mc->hdr.patch_id)
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (rev > mc->hdr.patch_id)
 		return ret;
 
 	if (!__apply_microcode_amd(mc)) {
@@ -523,8 +529,12 @@ void load_ucode_amd_ap(unsigned int cpui
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* Check whether we have saved a new patch already: */
-	if (*new_rev && rev < mc->hdr.patch_id) {
+	/*
+	 * Check whether a new patch has been saved already. Also, allow application of
+	 * the same revision in order to pick up SMT-thread-specific configuration even
+	 * if the sibling SMT thread already has an up-to-date revision.
+	 */
+	if (*new_rev && rev <= mc->hdr.patch_id) {
 		if (!__apply_microcode_amd(mc)) {
 			*new_rev = mc->hdr.patch_id;
 			return;


