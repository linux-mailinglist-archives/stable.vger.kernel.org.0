Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B394697AF4
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 12:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjBOLmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 06:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjBOLmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 06:42:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064E83645F;
        Wed, 15 Feb 2023 03:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DBF561B36;
        Wed, 15 Feb 2023 11:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEC5C433EF;
        Wed, 15 Feb 2023 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676461317;
        bh=SWJlG8P6p6sS5hqYjQmZBGBDQEFTQITPRH6dSryBgpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YScuwj+rpZ+NvsZH0JsuUlQ+5HNXT5EBVkV4j80X9GAFlSMZqMEtQPElrt6fLkWh7
         K7J3u6WZAB/y8WGYiEoY8YfsHWvA4GTG+OfAnOgygs6t6MCJ4/Pc7xlkV7CBiUnZDh
         OBe1ejWe0KJp/SaiLKWO0kw7d0o0IDl5UI0XTGpY=
Date:   Wed, 15 Feb 2023 12:41:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     heyuqiang <heyuqiang1@huawei.com>
Cc:     anshuman.khandual@arm.com, catalin.marinas@arm.com,
        james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        stable@vger.kernel.org, will@kernel.org, yuzenghui@huawei.com,
        nixiaoming@huawei.com, lijiahuan5@huawei.com
Subject: Re: [PATCH 5.10 88/91] arm64/kexec: Test page size support with new
 TGRAN range values
Message-ID: <Y+zFA1JuAcjhAogm@kroah.com>
References: <e1daca8f-46d5-d5b0-8152-23b172d5e63a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1daca8f-46d5-d5b0-8152-23b172d5e63a@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 06:58:13PM +0800, heyuqiang wrote:
> There is an error
> 
> tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> master
> head: c911f03f8d444e623724fddd82b07a7e1af42338
> commit: d5924531dd8ad012ad13eb4d6a5e120c3dadfc05 arm64/kexec: Test page size
> support with new TGRAN range values
> # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5924531dd8ad012ad13eb4d6a5e120c3dadfc05
> 
> When I compile the ko file, I add [-Werror=type-limits] compilation options,
> an error is reported during compilation.

Why add that option?  Is that a valid option for the 5.10.y kernel?  Is
this something new?

And note, you are responding to a commit from last November, with no
context at all.  Is this an issue in Linus's tree too?

> 
> The log is as follows:
> 
> ./arch/arm64/include/asm/cpufeature.h: In function
> ‘system_supports_4kb_granule’:
> ./arch/arm64/include/asm/cpufeature.h:653:14: error:
> comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
> return (val >= ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN) &&
> ^~
> ./arch/arm64/include/asm/cpufeature.h: In function
> ‘system_supports_64kb_granule’:
> ./arch/arm64/include/asm/cpufeature.h:666:14: error:
> comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
> return (val >= ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN) &&
> ^~
> 
> "val" variable type is "u32"
> "#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN 0x0"
> "#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN 0x0"
> comparison of val >= 0 is always true.
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: heyuqiang <heyuqiang1@huawei.com>

Please provide a valid fix for this if you wish for it to be resolved.

thanks,

greg k-h
