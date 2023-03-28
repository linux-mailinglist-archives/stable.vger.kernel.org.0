Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540736CC19C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjC1OAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbjC1OAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:00:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1764419C;
        Tue, 28 Mar 2023 06:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A71B2B81D5B;
        Tue, 28 Mar 2023 13:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE48FC433EF;
        Tue, 28 Mar 2023 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680011970;
        bh=7d9PVKwq4fSFcNvrchiGI92QiSv0vEPNvjbEycB5mBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CUX0vuehyo0rHtdD+gOFi+s52HGAY2qXbj78jn3dwm4EmGnvrvzhrQ8lin1DbEd4v
         +yfeIAuNlsaEcsPsuD9MzWYSbyweAsz5cea19C1d8SBQcud3U8+/Z2cj/pEnDqCHoi
         qHICtGDXvL+SnwWLnFAsVZxXBBXNtSKOLhyN4JFxY6tZq6lyS52NZqBAPPzsjDBM/e
         etSGcouGq/HOcUIta5yNewUizOm9HY9qwktE1Epotg9/bocS/sjZ+JZbIp27HHYg3k
         iMU5FCKm5kPzl58vy4jTJk8hhs/Hz+hBuHQ4toSW/+VKaWqqPKr9wfmmvqxKvxqqDj
         liS7yp0pYGiSQ==
Date:   Tue, 28 Mar 2023 14:59:24 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Thomas Gleixner <tglx@linotronix.de>, stable@vger.kernel.org,
        Yogesh Lal <quic_ylal@quicinc.com>
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock
 when non-boot CPUs need counter workaround
Message-ID: <20230328135923.GB1333@willie-the-truck>
References: <20230113111648.1977473-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113111648.1977473-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Fri, Jan 13, 2023 at 11:16:48AM +0000, Marc Zyngier wrote:
> When booting on a CPU that has a countertum on the counter read,
> we use the arch_counter_get_cnt{v,p}ct_stable() backend which
> applies the workaround.
> 
> However, we don't do the same thing when an affected CPU is
> a secondary CPU, and we're stuck with the standard sched_clock()
> backend that knows nothing about the workaround.
> 
> Fix it by always indirecting sched_clock(), making arch_timer_read_counter
> a function instead of a function pointer. In turn, we update the
> pointer (now private to the driver code) when detecting a new
> workaround.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@kernel.org>
> Cc: Thomas Gleixner <tglx@linotronix.de>
> Cc: stable@vger.kernel.org
> Reported-by: Yogesh Lal <quic_ylal@quicinc.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter to access stable counters")
> Link: https://lore.kernel.org/r/ca4679a0-7f29-65f4-54b9-c575248192f1@quicinc.com
> ---
>  drivers/clocksource/arm_arch_timer.c | 56 +++++++++++++++++-----------
>  include/clocksource/arm_arch_timer.h |  2 +-
>  2 files changed, 36 insertions(+), 22 deletions(-)

I'm just going through the patch backlog and I think this thread ended
with Mark's review. Do you intend to post an updated version?

Cheers,

Will
