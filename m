Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261925B5C64
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 16:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiILOlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 10:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiILOlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 10:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FEF1FCF7;
        Mon, 12 Sep 2022 07:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0B9261224;
        Mon, 12 Sep 2022 14:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFAC433C1;
        Mon, 12 Sep 2022 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662993681;
        bh=LIlb3/sVDRiailHPluUwQ0BEaWEPEWV2j5OvEnX4BQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z20p49e/gOyYdaaXvpTh9ebRDz8SRpomkbTdwpuTeoWcY4Lh29F9pV38PlR5cqRSO
         DUzd+p80O5DoQCbthS5VXjG2YJADK0OSPf4+cSH121d1mBq1FixCRa8gdugzKk0DuA
         SpxXG4RJj08HbLRaFz32mZ8AHg0CVJJUJIZTeUwE=
Date:   Mon, 12 Sep 2022 16:41:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ionela Voinescu <ionela.voinescu@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.10] arm64: errata: add detection for AMEVCNTR01
 incrementing incorrectly
Message-ID: <Yx9FKf1Fxl4LwW4G@kroah.com>
References: <20220912135226.31027-1-ionela.voinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912135226.31027-1-ionela.voinescu@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 02:52:26PM +0100, Ionela Voinescu wrote:
> commit e89d120c4b720e232cc6a94f0fcbd59c15d41489 upstream.
> 
> The AMU counter AMEVCNTR01 (constant counter) should increment at the same
> rate as the system counter. On affected Cortex-A510 cores, AMEVCNTR01
> increments incorrectly giving a significantly higher output value. This
> results in inaccurate task scheduler utilization tracking.
> 
> Work around this problem by keeping the reference values of affected
> counters to 0. This results in disabling the single user of this
> counter: Frequency Invariance Engine (FIE).
> This effect is the same to firmware disabling affected counters, in
> which case 0 will be returned when reading the disabled counters.
> 
> Therefore, AMU counters will not be used for frequency invariance for
> affected CPUs and CPUs in the same cpufreq policy. AMUs can still be used
> for frequency invariance for unaffected CPUs in the system.
> 
> The above is achieved through adding a new erratum: ARM64_ERRATUM_2457168.
> 
> Signed-off-by: Ionela Voinescu <ionela.voinescu@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Link: https://lore.kernel.org/r/20220819103050.24211-1-ionela.voinescu@arm.com
> ---
> 
> Hi,
> 
> This is a backport to stable 5.10.142 of the upstream commit
> e89d120c4b72  arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly
> 
> This is sent separately as there were conflicts that needed resolving
> when applying the mainline patch. Compared to the upstream version this
> no longer handles the FFH usecase, as FFH support is not present in 5.10.
> Therefore the commit message and Kconfig description are modified to
> only describe the effect on FIE caused by this erratum.

Both backports now queued up, thanks.

greg k-h
