Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B7450570D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241517AbiDRNpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244449AbiDRNo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:44:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAED3F33B;
        Mon, 18 Apr 2022 05:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C3C2B80E44;
        Mon, 18 Apr 2022 12:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2B8C385A1;
        Mon, 18 Apr 2022 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286796;
        bh=1m3xIrLcO5FIijhI2wj1F439x8Le5NCM2hWe+oEGa6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fm20q065B9sfyYAMC2+g25FnrZ8yj0du2/kDTVdMh1cUMejUrLb57jdI2+GNgNOrk
         hbtIpkF1Od2j8QRONCHSMgMdlmdIUvlSes7Irq6RBmUAVQto9K2300UN8YtSTTsxaI
         KczD8ugvAOzpuqTK3yadkSfmlWUP15Q9mc3d+wZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 247/284] x86/pm: Save the MSR validity status at context setup
Date:   Mon, 18 Apr 2022 14:13:48 +0200
Message-Id: <20220418121219.177917828@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
@@ -41,7 +41,8 @@ static void msr_save_context(struct save
 	struct saved_msr *end = msr + ctxt->saved_msrs.num;
 
 	while (msr < end) {
-		msr->valid = !rdmsrl_safe(msr->info.msr_no, &msr->info.reg.q);
+		if (msr->valid)
+			rdmsrl(msr->info.msr_no, msr->info.reg.q);
 		msr++;
 	}
 }
@@ -426,8 +427,10 @@ static int msr_build_context(const u32 *
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


