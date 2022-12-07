Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71B3645350
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 06:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLGFNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 00:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLGFNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 00:13:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC9D22BC1
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 21:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 482AFB81603
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 05:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78420C433C1;
        Wed,  7 Dec 2022 05:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670389995;
        bh=3UqDgBa+7+Do6rzOZR6belAKqELuWb6uxNGZ5zCHMGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PX8Q3eaJG/yRDtOfNgd5T2K3LoO4idKRzW7+HXfbxWIP1D2w8VYgOkZTuLmvPPR4y
         z/vqAj7Pt3B9N69F09VLGi3NLh56npFFIK3zaDxohXojkRR65ijGu6mjuls0wyciv8
         brbdrisKh96iCxGhj/29svjj/3okE/wthuKwu0DE6CtyqPnrIYmhgG1xff0HJY01xC
         +oW6EdQOd0B8hpoLg9ZlRWNt1pAwiXJp3qmAPg6idA0JgPrNPrn5oXFrHPV4+3bQ1j
         Z9kq3VIArVOZMlfIkiIKEbrtbcN9oABfkibsf9wAU9nTbqZxPMP+50DFK5UNwC58Ll
         0OxLS0bwaGerA==
Date:   Wed, 7 Dec 2022 00:13:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kane Chen <kane.chen@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Message-ID: <Y5Ag6YhxcPPbs4Jr@sashalap>
References: <20221207035722.15749-1-kane.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207035722.15749-1-kane.chen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 11:57:22AM +0800, Kane Chen wrote:
>While runnings s0ix cycling test based on rtc alarm wakeup on ADL-P devices,
>We found the data from CMOS_READ is not reasonable and causes RTC wake up fail.
>
>With the below changes, we don't see unreasonable data from cmos and issue is gone.

Thanks for the analysis, I can queue most of these up. There are two
which won't go in:

>cd17420: rtc: cmos: avoid UIP when writing alarm time
>cdedc45: rtc: cmos: avoid UIP when reading alarm time
>ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
>ea6fa49: rtc: mc146818-lib: fix RTC presence check
>13be2ef: rtc: cmos: Disable irq around direct invocation of cmos_interrupt()
>0dd8d6c: rtc: Check return value from mc146818_get_time()
>e1aba37: rtc: cmos: remove stale REVISIT comments
>6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ

This one fixes a commit which isn't in the 5.10 tree.

>d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
>ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
>211e5db: rtc: mc146818: Detect and handle broken RTCs
>dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()

This one looks like an optimization.

-- 
Thanks,
Sasha
