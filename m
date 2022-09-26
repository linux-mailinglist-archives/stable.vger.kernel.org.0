Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3B5EB1B6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIZT4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiIZTz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:55:58 -0400
Received: from rhlx01.hs-esslingen.de (rhlx01.hs-esslingen.de [129.143.116.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A75B20F43;
        Mon, 26 Sep 2022 12:55:55 -0700 (PDT)
Received: by rhlx01.hs-esslingen.de (Postfix, from userid 102)
        id 5F0A6223A1A3; Mon, 26 Sep 2022 21:55:52 +0200 (CEST)
Date:   Mon, 26 Sep 2022 21:55:52 +0200
From:   Andreas Mohr <andi@lisas.de>
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        andi@lisas.de, puwen@hygon.cn, mario.limonciello@amd.com,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Message-ID: <YzIDyLbGgzEv0wzP@rhlx01.hs-esslingen.de>
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
 <YzGWHMIsD7RBhEP+@hirez.programming.kicks-ass.net>
 <9875e20e-8363-74ef-349d-d339eddb3cc2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9875e20e-8363-74ef-349d-d339eddb3cc2@amd.com>
X-Priority: none
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Am Mon, Sep 26, 2022 at 10:02:44PM +0530 schrieb K Prateek Nayak:
> Hello Peter,
> 
> On 9/26/2022 5:37 PM, Peter Zijlstra wrote:
> > For how many of the above have you changed behaviour?
> 
> The proposed logic does alter the behavior for x86 chipsets that depend
> on acpi_idle driver and have IOPORT based C-state. Based on what
> Rafael and Dave suggested, I have marked all Intel processors to be
> affected by this bug. In light of Andreas' report, I've also marked
> all the pre-family 17h AMD processors to be affected by this bug to avoid
> causing any regression.
> 
> It is hard to tell if any other vendor had this bug in their chipsets.
> Dave's patch does not make this consideration either and limits the
> dummy operation to only Intel chipsets using acpi_idle driver.
> (https://lore.kernel.org/all/78d13a19-2806-c8af-573e-7f2625edfab8@intel.com/)
> If folks reported a regression, I would have been happy to fix it for
> them.

Despite certain, umm, controversies, the discussion/patch activities
appear to be heading into a good direction ;)



This text somehow prompted me to think of
whether STPCLK# [quirk] behaviour is
a property of the CPU family, or the chipset, or actually a combination of it.

Given that [from recollection] VIA 8233/8235 spec PDFs do mention STPCLK#,
possibly a chipset does have a say in it? (which
obviously would then mean that
the kernel's quirk state decision-making would have to be refined)

Minor reference (note 8237, not 8233):
http://www.chipset-ic.com/datasheet/VT8237.pdf
  "STPCLK# is asserted by the VT8237R to the CPU to throttle the processor."
  (and many other STPCLK# mentions there)

Greetings

Andreas Mohr
