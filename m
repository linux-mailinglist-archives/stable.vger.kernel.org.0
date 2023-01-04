Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A1A65D8CD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbjADQSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbjADQSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:18:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A079E41D54
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B4CC617A7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEDFC433EF;
        Wed,  4 Jan 2023 16:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849098;
        bh=FPkcEypsfjMdI/mc7/1vbjpu8SN1fPpgAwJ0Tfp+sPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eltu4gFXuTlFVpH6TTWfNNBuZbEAGMiXz5j4aCGrZaY7SJ4w3tJsPOXD9X8XeijPX
         ws70le/smmyaWemb0oCQPvQTr2UvL5Zl7/0UbMOYacU4zhAm+Z78ykJnr2NGOblqhm
         26nDyDnzU7CMh9lMUOGCLQ2Sj5RbfQ1I+erM69s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.0 063/177] x86/microcode/intel: Do not retry microcode reloading on the APs
Date:   Wed,  4 Jan 2023 17:05:54 +0100
Message-Id: <20230104160509.565755129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -621,7 +621,6 @@ void load_ucode_intel_ap(void)
 	else
 		iup = &intel_ucode_patch;
 
-reget:
 	if (!*iup) {
 		patch = __load_ucode_intel(&uci);
 		if (!patch)
@@ -632,12 +631,7 @@ reget:
 
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


