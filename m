Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD15E54178E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378487AbiFGVEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379270AbiFGVCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFA03CA59;
        Tue,  7 Jun 2022 11:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8655CB81FE1;
        Tue,  7 Jun 2022 18:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE9EC385A2;
        Tue,  7 Jun 2022 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627633;
        bh=yKGJ+d5ZKU97vSb+zzxqTj/aDTnvOOGjazdAMaubQE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0Bo8cXIDHh9rSsAWQOntqs82cU04dud38mNmvG1PSUTnAmcI0V6IiHfllq9j5p5A
         zLCosj+7JrtK3nhVQReUSIUjk2bQiFgX0gmRo9q5Xke0zN8ZnDzStnw9W0oLN7D5Vo
         rbn/rqw6iIsXmvwEx8yit/5G4XO0QhoFDlt6qPHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.18 038/879] perf/x86/intel: Fix event constraints for ICL
Date:   Tue,  7 Jun 2022 18:52:36 +0200
Message-Id: <20220607165003.783888970@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 86dca369075b3e310c3c0adb0f81e513c562b5e4 upstream.

According to the latest event list, the event encoding 0x55
INST_DECODED.DECODERS and 0x56 UOPS_DECODED.DEC0 are only available on
the first 4 counters. Add them into the event constraints table.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220525133952.1660658-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -276,7 +276,7 @@ static struct event_constraint intel_icl
 	INTEL_EVENT_CONSTRAINT_RANGE(0x03, 0x0a, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x1f, 0x28, 0xf),
 	INTEL_EVENT_CONSTRAINT(0x32, 0xf),	/* SW_PREFETCH_ACCESS.* */
-	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x54, 0xf),
+	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x56, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x60, 0x8b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_TOTAL */
 	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.CYCLES_MEM_ANY */


