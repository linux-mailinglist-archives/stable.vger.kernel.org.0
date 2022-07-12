Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D580D5724A0
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiGLTDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbiGLTCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:02:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9333FBE6B9;
        Tue, 12 Jul 2022 11:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8804161248;
        Tue, 12 Jul 2022 18:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D07C3411E;
        Tue, 12 Jul 2022 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651782;
        bh=7W6eWTEXjOF812u7n64OA5d98HorY4GvtJh/QdEio40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iMocFYWny3bZ0vQf+78IpRc/JXE2IWoN6jmwAjRwflIKGrPR9LcLq/424FCgLGjt
         a4Pea+mw1P0Ieh2IbaCrDlkGbkcq/Eqp+bm6ZOH1t1tuL0y+EiAsj71//FxkygEJtg
         GU/YShCLLs+3DsnF62GO0jrecUpT6wX7goJHGSjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 56/78] x86/bugs: Do IBPB fallback check only once
Date:   Tue, 12 Jul 2022 20:39:26 +0200
Message-Id: <20220712183241.163886442@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 0fe4aeea9c01baabecc8c3afc7889c809d939bc2 upstream.

When booting with retbleed=auto, if the kernel wasn't built with
CONFIG_CC_HAS_RETURN_THUNK, the mitigation falls back to IBPB.  Make
sure a warning is printed in that case.  The IBPB fallback check is done
twice, but it really only needs to be done once.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -884,18 +884,13 @@ static void __init retbleed_select_mitig
 	case RETBLEED_CMD_AUTO:
 	default:
 		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
-		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
-
-			if (IS_ENABLED(CONFIG_RETPOLINE) &&
-			    IS_ENABLED(CONFIG_CC_HAS_RETURN_THUNK))
-				retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
-			else
-				retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
-		}
+		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
+			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
 
 		/*
-		 * The Intel mitigation (IBRS) was already selected in
-		 * spectre_v2_select_mitigation().
+		 * The Intel mitigation (IBRS or eIBRS) was already selected in
+		 * spectre_v2_select_mitigation().  'retbleed_mitigation' will
+		 * be set accordingly below.
 		 */
 
 		break;


