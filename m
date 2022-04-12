Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854714FD3F2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350737AbiDLH5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359242AbiDLHmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4695576E;
        Tue, 12 Apr 2022 00:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 594B261045;
        Tue, 12 Apr 2022 07:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68938C385A5;
        Tue, 12 Apr 2022 07:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748038;
        bh=1fAADtwZr8mUN51KJvbjJw10IrVyo6zwcuvu2c/R9yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0G8LGzA9vytDRXkP9gkAHQO702qgKRawGcNogQw88zHS9hn1Q7XFh9kMeMLiHjdV
         nqBmA7zPxoiOe7Fqc67ZJpl2fB2ehKz2bi39oJx2F3UffXra0Zyv5pGq1upJCHQcA1
         jtJi74Cp0NaIkSddDKCQHlz+yjtpN62nFV4VW1lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 280/343] x86/pm: Save the MSR validity status at context setup
Date:   Tue, 12 Apr 2022 08:31:38 +0200
Message-Id: <20220412062959.405582569@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 73924ec4d560257004d5b5116b22a3647661e364 upstream.

The mechanism to save/restore MSRs during S3 suspend/resume checks for
the MSR validity during suspend, and only restores the MSR if its a
valid MSR.  This is not optimal, as an invalid MSR will unnecessarily
throw an exception for every suspend cycle.  The more invalid MSRs,
higher the impact will be.

Check and save the MSR validity at setup.  This ensures that only valid
MSRs that are guaranteed to not throw an exception will be attempted
during suspend.

Fixes: 7a9c2dd08ead ("x86/pm: Introduce quirk framework to save/restore extra MSR registers around suspend/resume")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/power/cpu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -40,7 +40,8 @@ static void msr_save_context(struct save
 	struct saved_msr *end = msr + ctxt->saved_msrs.num;
 
 	while (msr < end) {
-		msr->valid = !rdmsrl_safe(msr->info.msr_no, &msr->info.reg.q);
+		if (msr->valid)
+			rdmsrl(msr->info.msr_no, msr->info.reg.q);
 		msr++;
 	}
 }
@@ -424,8 +425,10 @@ static int msr_build_context(const u32 *
 	}
 
 	for (i = saved_msrs->num, j = 0; i < total_num; i++, j++) {
+		u64 dummy;
+
 		msr_array[i].info.msr_no	= msr_id[j];
-		msr_array[i].valid		= false;
+		msr_array[i].valid		= !rdmsrl_safe(msr_id[j], &dummy);
 		msr_array[i].info.reg.q		= 0;
 	}
 	saved_msrs->num   = total_num;


