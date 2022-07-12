Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4544557241E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiGLS4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiGLS4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:56:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD94EB03B;
        Tue, 12 Jul 2022 11:46:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E748560A5A;
        Tue, 12 Jul 2022 18:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70F4C3411C;
        Tue, 12 Jul 2022 18:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651602;
        bh=MwuU+xseDp9KXWFIrzDY8KulQryfkv/g26Hg1/eETvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzctrIWzScPD9gGHbJWX0AlVLH+GYPGBRDQbsf22kJoobP1T7XYpLWKpm/lThR9fT
         D1t3aLs5hDkLeEUMQuPOc2hp4K1n55pXpafonV1cT6CY/Q4hz5KONGcMY0O6FEvNTX
         DYA1gSkLJ27jFT0+12t4CRlRQmceERt5ryjHMp5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 127/130] x86/bugs: Do not enable IBPB-on-entry when IBPB is not supported
Date:   Tue, 12 Jul 2022 20:39:33 +0200
Message-Id: <20220712183252.325226631@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 2259da159fbe5dba8ac00b560cf00b6a6537fa18 upstream.

There are some VM configurations which have Skylake model but do not
support IBPB. In those cases, when using retbleed=ibpb, userspace is going
to be killed and kernel is going to panic.

If the CPU does not support IBPB, warn and proceed with the auto option. Also,
do not fallback to IBPB on AMD/Hygon systems if it is not supported.

Fixes: 3ebc17006888 ("x86/bugs: Add retbleed=ibpb")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -821,7 +821,10 @@ static void __init retbleed_select_mitig
 		break;
 
 	case RETBLEED_CMD_IBPB:
-		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
+		if (!boot_cpu_has(X86_FEATURE_IBPB)) {
+			pr_err("WARNING: CPU does not support IBPB.\n");
+			goto do_cmd_auto;
+		} else if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
 			retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
 		} else {
 			pr_err("WARNING: kernel not compiled with CPU_IBPB_ENTRY.\n");
@@ -836,7 +839,7 @@ do_cmd_auto:
 		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
 			if (IS_ENABLED(CONFIG_CPU_UNRET_ENTRY))
 				retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
-			else if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY))
+			else if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY) && boot_cpu_has(X86_FEATURE_IBPB))
 				retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
 		}
 


