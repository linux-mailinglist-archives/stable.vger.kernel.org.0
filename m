Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9C166C8C8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjAPQm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbjAPQmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:42:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023A32F78F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 920D761057
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BE2C433D2;
        Mon, 16 Jan 2023 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886624;
        bh=QlhaI9/s2EQZ3Ica7fZLpGbjmNEy1NFh+wztxGQIkbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfOyehCC3B0Nhj71A24S6FoSnsmyiJD57UTeESX5j3l2OEuNCnMkz+74HhOncuF07
         tfpaPsc+0eyevtkJ7R8A5MTZuuGgY6aqSDfRnqYFEJsIPNIfsytYEPHna6yq3TbPsW
         tmDmR2T19A09WIjiIDCuNNXsilVQGQQkTHtEz/+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 500/658] x86/microcode/intel: Do not retry microcode reloading on the APs
Date:   Mon, 16 Jan 2023 16:49:48 +0100
Message-Id: <20230116154932.378242054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

commit be1b670f61443aa5d0d01782e9b8ea0ee825d018 upstream.

The retries in load_ucode_intel_ap() were in place to support systems
with mixed steppings. Mixed steppings are no longer supported and there is
only one microcode image at a time. Any retries will simply reattempt to
apply the same image over and over without making progress.

  [ bp: Zap the circumstantial reasoning from the commit message. ]

Fixes: 06b8534cb728 ("x86/microcode: Rework microcode loading")
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221129210832.107850-3-ashok.raj@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -659,7 +659,6 @@ void load_ucode_intel_ap(void)
 	else
 		iup = &intel_ucode_patch;
 
-reget:
 	if (!*iup) {
 		patch = __load_ucode_intel(&uci);
 		if (!patch)
@@ -670,12 +669,7 @@ reget:
 
 	uci.mc = *iup;
 
-	if (apply_microcode_early(&uci, true)) {
-		/* Mixed-silicon system? Try to refetch the proper patch: */
-		*iup = NULL;
-
-		goto reget;
-	}
+	apply_microcode_early(&uci, true);
 }
 
 static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)


