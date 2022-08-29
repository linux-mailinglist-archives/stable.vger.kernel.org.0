Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B1B5A43B1
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiH2HX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiH2HXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455864DF36
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 670DD61133
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A458C433D6;
        Mon, 29 Aug 2022 07:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661757802;
        bh=dqYHyNSixTCbvTEM+7ebxJ4qhfsTW75OQr8l6gowz88=;
        h=Subject:To:Cc:From:Date:From;
        b=DqzUoEMI8RZMFayKjM1rIVEiMyYG46nOMwh2XiAU9MD2MOhIBFoyPbHJBgznHy4bG
         atOK4Uwnh0oB2bT5VHJxeXZOzU8nsoU1hrT8oJcJVVOo1YpucGGUpKX0Uc5zGGj9Kg
         MMPTxfosAd9hty1Z7kxkRzWz32W9zPq8V9Wbgd8M=
Subject: FAILED: patch "[PATCH] perf/x86/intel: Fix pebs event constraints for ADL" failed to apply to 5.15-stable tree
To:     kan.liang@linux.intel.com, ammy.yi@intel.com, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:23:19 +0200
Message-ID: <1661757799236242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cde643ff75bc20c538dfae787ca3b587bab16b50 Mon Sep 17 00:00:00 2001
From: Kan Liang <kan.liang@linux.intel.com>
Date: Thu, 18 Aug 2022 11:44:29 -0700
Subject: [PATCH] perf/x86/intel: Fix pebs event constraints for ADL

According to the latest event list, the LOAD_LATENCY PEBS event only
works on the GP counter 0 and 1 for ADL and RPL.

Update the pebs event constraints table.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220818184429.2355857-1-kan.liang@linux.intel.com

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index e5b587499122..de1f55d51784 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -830,7 +830,7 @@ struct event_constraint intel_glm_pebs_event_constraints[] = {
 
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0xf),
+	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
 	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xf),
 	EVENT_CONSTRAINT_END
 };

