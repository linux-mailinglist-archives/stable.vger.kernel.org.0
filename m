Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C0E4F31D5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbiDEInn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbiDEIcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D5810FF2;
        Tue,  5 Apr 2022 01:29:08 -0700 (PDT)
Date:   Tue, 05 Apr 2022 08:29:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649147347;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fe9mJlC687Zaz7e4JSc1XJLsZV5carty3Du71P+qWIE=;
        b=x5NlzsVn1/CdfpqvjfOU+FVbbwuTufv3Sg4irPI84QFEf/vpJO00bNk7Yea7Ul6CIwWhDx
        NfKAWNyiS39tfWeeyexxPke/MdKjdv3Goy4HLt7MsVjWIUrs0J4BR/7N9R5h/LSY37IbmN
        4fwNokbCtTz+g2KXClgwCULOfJW7/ZbJG09yV+BwAn46o1sIEATAOmcJBIQjovvNoOHrLb
        qcmau9K2T705rqyKENMCQfLYCoDVqwlY6v+KXc/iWQ0blyMqAwk4i0uGRA+99Y9QD4YtGf
        8jgb6Jgh39Y5AT54CHjOcFlKA8ghj1kaw0Z4ijVBlRTMeSFsqEsguNXO2d5wgw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649147347;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fe9mJlC687Zaz7e4JSc1XJLsZV5carty3Du71P+qWIE=;
        b=Ab2d/xej9XdJAAwlQUAg7d57HRRchEKTP160WdUlGFIJ3yDiqhX5pzAVigfo1biuVQWRaz
        gM36oOGzcMLtdhAQ==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Update the FRONTEND MSR mask on
 Sapphire Rapids
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1648482543-14923-2-git-send-email-kan.liang@linux.intel.com>
References: <1648482543-14923-2-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <164914734621.389.12529799156249746184.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     e590928de7547454469693da9bc7ffd562e54b7e
Gitweb:        https://git.kernel.org/tip/e590928de7547454469693da9bc7ffd562e54b7e
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 28 Mar 2022 08:49:03 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 05 Apr 2022 09:59:44 +02:00

perf/x86/intel: Update the FRONTEND MSR mask on Sapphire Rapids

On Sapphire Rapids, the FRONTEND_RETIRED.MS_FLOWS event requires the
FRONTEND MSR value 0x8. However, the current FRONTEND MSR mask doesn't
support it.

Update intel_spr_extra_regs[] to support it.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1648482543-14923-2-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index eb17b96..fc7f458 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -302,7 +302,7 @@ static struct extra_reg intel_spr_extra_regs[] __read_mostly = {
 	INTEL_UEVENT_EXTRA_REG(0x012a, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
-	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff1f, FE),
 	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
 	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END
