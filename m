Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0987F4D3352
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiCIQGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiCIQEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:04:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE771390F9;
        Wed,  9 Mar 2022 08:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A714B82191;
        Wed,  9 Mar 2022 16:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAD0C340E8;
        Wed,  9 Mar 2022 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841764;
        bh=rSTOUX5LUvBCX6WBogDAqooyuvYNrP66hsRf3uWRExc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2KtBXmEiR4Bhxyl7ZdJ3FlK49FUCvBPICShztPpV7G29P/xjzTt2qaWTzCa4T7qJ
         LtP0srNGrbSyUSmNIMH+iGrEbCGHQPPgh8gXRX79peDmQ0eK3zmX46xDLV/fS0Hi2h
         HRJ/jyiXskYgB/Hiqu7KMslS+nz3whoQOf1+fMpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 07/18] x86/speculation: Use generic retpoline by default on AMD
Date:   Wed,  9 Mar 2022 16:59:37 +0100
Message-Id: <20220309155856.311120387@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.090281301@linuxfoundation.org>
References: <20220309155856.090281301@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -898,14 +898,6 @@ static enum spectre_v2_mitigation __init
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
 


