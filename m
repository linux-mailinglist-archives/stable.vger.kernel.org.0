Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADE74D4A9B
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243385AbiCJOVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243790AbiCJOSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF001166A63;
        Thu, 10 Mar 2022 06:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 817ADB8267C;
        Thu, 10 Mar 2022 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB655C340E8;
        Thu, 10 Mar 2022 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921659;
        bh=46jo3Lac9ZQVbErqXQpZ2hY92m8kz18vN57CNImpM3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w24GdvgCZfFFDOl78pFEUSTB3WoXQy3ObqCWXqBbL2NQrkn2dISFtMDFqFc3nxltH
         MLyLKyt9QnoeV46y1NlKifCORRs0sDb5EaLO6BmUneRmaQ7LJRTZYPZyPHuJFJ4fdZ
         OP5uo2ADNhAmf0R2uRYFcFHI5KEA8tkA/grc9gA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 13/38] x86/speculation: Use generic retpoline by default on AMD
Date:   Thu, 10 Mar 2022 15:13:26 +0100
Message-Id: <20220310140808.524922163@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
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

From: Kim Phillips <kim.phillips@amd.com>

commit 244d00b5dd4755f8df892c86cab35fb2cfd4f14b upstream.

AMD retpoline may be susceptible to speculation. The speculation
execution window for an incorrect indirect branch prediction using
LFENCE/JMP sequence may potentially be large enough to allow
exploitation using Spectre V2.

By default, don't use retpoline,lfence on AMD.  Instead, use the
generic retpoline.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -897,14 +897,6 @@ static enum spectre_v2_mitigation __init
 		return SPECTRE_V2_NONE;
 	}
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
-			pr_err("LFENCE not serializing, switching to generic retpoline\n");
-			return SPECTRE_V2_RETPOLINE;
-		}
-		return SPECTRE_V2_LFENCE;
-	}
-
 	return SPECTRE_V2_RETPOLINE;
 }
 


