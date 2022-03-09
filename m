Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7374D331E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbiCIQK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235561AbiCIQI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:08:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70F013FAD7;
        Wed,  9 Mar 2022 08:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CA561666;
        Wed,  9 Mar 2022 16:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8232C340E8;
        Wed,  9 Mar 2022 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841931;
        bh=jr+6+1MnJQNcfljlgg0AAAnKF+/2D+Wgaosbrook0EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoNBeee9Gx8wZLxqTLRA9AcwaAVOvYc1oMbGZtcPYpVBuwX9MyCchfxbK7oeT8Uy1
         viGGwexQN/XOuQnnjJJzhyWyPPAop5bhKEIyrX2js4P3E7Wkjm1XRLbT7cKgZ2YRT9
         PbJwtY2L4PIvNZg4ZZ0VUyQoaOPGNFsat4GSRwuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 08/43] x86/speculation: Warn about Spectre v2 LFENCE mitigation
Date:   Wed,  9 Mar 2022 16:59:41 +0100
Message-Id: <20220309155859.484314370@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
References: <20220309155859.239810747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit eafd987d4a82c7bb5aa12f0e3b4f8f3dea93e678 upstream.

With:

  f8a66d608a3e ("x86,bugs: Unconditionally allow spectre_v2=retpoline,amd")

it became possible to enable the LFENCE "retpoline" on Intel. However,
Intel doesn't recommend it, as it has some weaknesses compared to
retpoline.

Now AMD doesn't recommend it either.

It can still be left available as a cmdline option. It's faster than
retpoline but is weaker in certain scenarios -- particularly SMT, but
even non-SMT may be vulnerable in some cases.

So just unconditionally warn if the user requests it on the cmdline.

  [ bp: Massage commit message. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -614,6 +614,7 @@ static inline const char *spectre_v2_mod
 static inline const char *spectre_v2_module_string(void) { return ""; }
 #endif
 
+#define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 
 #ifdef CONFIG_BPF_SYSCALL
@@ -935,6 +936,7 @@ static void __init spectre_v2_select_mit
 		break;
 
 	case SPECTRE_V2_CMD_RETPOLINE_LFENCE:
+		pr_err(SPECTRE_V2_LFENCE_MSG);
 		mode = SPECTRE_V2_LFENCE;
 		break;
 
@@ -1717,6 +1719,9 @@ static char *ibpb_state(void)
 
 static ssize_t spectre_v2_show_state(char *buf)
 {
+	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
+		return sprintf(buf, "Vulnerable: LFENCE\n");
+
 	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
 		return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
 


