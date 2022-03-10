Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15754D48C1
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbiCJOLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiCJOLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:11:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F371790CD6;
        Thu, 10 Mar 2022 06:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 778A061B7A;
        Thu, 10 Mar 2022 14:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C871C340F3;
        Thu, 10 Mar 2022 14:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921420;
        bh=jyBDepQzs3J3bAr8lcobZCUKcw7lYEkUHhe0ftiGO0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZvsr93JHqZc8qB2xKaralMM/+oWvaB3FnLUcC7bWxziiuPCkC6I0YMVdotf7HXsP
         BuIo/n8y2nbcPk5xqG3rPg2Av6ZrAhnMrfOqriQDnlg7BC5cp2S0GNGTBFja4HUfCs
         iRUMTcuuF8oYA35a2JXwqS+tq4agZo/nNMEd8yDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.16 05/53] x86/speculation: Use generic retpoline by default on AMD
Date:   Thu, 10 Mar 2022 15:09:10 +0100
Message-Id: <20220310140811.990617007@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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
 arch/x86/kernel/cpu/bugs.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -941,15 +941,6 @@ static enum spectre_v2_mitigation __init
 		return SPECTRE_V2_NONE;
 	}
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
-	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
-		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
-			pr_err("LFENCE not serializing, switching to generic retpoline\n");
-			return SPECTRE_V2_RETPOLINE;
-		}
-		return SPECTRE_V2_LFENCE;
-	}
-
 	return SPECTRE_V2_RETPOLINE;
 }
 


