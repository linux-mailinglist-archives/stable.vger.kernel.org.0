Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265D65E6CC5
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiIVUK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 16:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiIVUK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 16:10:27 -0400
X-Greylist: delayed 1684 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Sep 2022 13:10:23 PDT
Received: from rhlx01.hs-esslingen.de (rhlx01.hs-esslingen.de [129.143.116.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF1BC995D;
        Thu, 22 Sep 2022 13:10:22 -0700 (PDT)
Received: by rhlx01.hs-esslingen.de (Postfix, from userid 102)
        id 17836277FBA8; Thu, 22 Sep 2022 22:10:21 +0200 (CEST)
Date:   Thu, 22 Sep 2022 22:10:21 +0200
From:   Andreas Mohr <andi@lisas.de>
To:     Andreas Mohr <andi@lisas.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YyzBLc+OFIN2BMz5@rhlx01.hs-esslingen.de>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de>
X-Priority: none
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 09:42:15PM +0200, Andreas Mohr wrote:
> So one can see where my profiling effort went
> (*optimizing* things, not degrading them)
> --> hints that current Zen3-originating effort is not
> about a regression in the "regression bug" sense -
> merely a (albeit rather appreciable/sizeable... congrats!)
> performance deterioration vs.
> an optimal (currently non-achieved) software implementation state
> (also: of PORT-based handling [vs. MWAIT], mind you!).

I'd like to add a word of caution here:

AFAIK power management (here: ACPI Cx) handling generally is
about a painful *tradeoff* between
achieving best-possible performance (that's
the respectable Zen3 32MB/s vs. 33MB/s argument) and
achieving maximum power savings.
We all know that one can configure the system for
non-idle mode (idle=poll cmdline?) and
achieve record numbers in performance (...*and* power consumption - ouch!).

Current decision/implementation aspects AFAICS:
- why is the Zen3 config used here choosing
  less-favourable(?) PORT-based operation mode?
- Zen3 is said to not have the STPCLK# issue
  (- but then what about other more modern chipsets?)

--> we need to achieve (hopefully sufficiently precisely) a solution which
takes into account Zen3 STPCLK# improvements while
preserving "accepted" behaviour/requirements on *all* STPCLK#-hampered chipsets
("STPCLK# I/O wait is default/traditional handling"?).

Greetings

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
