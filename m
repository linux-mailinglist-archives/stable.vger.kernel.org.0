Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABA166C2ED
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjAPO42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjAPO4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:56:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DA32684E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 06:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE9E60FE2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 14:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C1FC433D2;
        Mon, 16 Jan 2023 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673880306;
        bh=lUZaH+1G+kNfvawM7MZyTt01BvbG+LMdUGsyODpCT+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zqsrRw/rU1nE7Md/hSbmvlu3T6DAMQcvH9WgZZ+oDAKjG1v+h89UiYtCT9ChGhHLN
         zXgB9kSUjBxuBVt86rC7dohQLluXeWF4FkSIBur1jRczRPIf5UJwQzsSPZtVFrywR8
         LaoVhcMbXpxMli8u/1yCH+luHhRL74xG8v/EwENo=
Date:   Mon, 16 Jan 2023 15:45:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Jocelyn Falempe <jfalempe@redhat.com>, llvm@lists.linux.dev,
        stable@vger.kernel.org, Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 6.1] drm/i915: Fix CFI violations in gt_sysfs
Message-ID: <Y8Vi7+jDz64IMyUm@kroah.com>
References: <20230116033551.191731-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116033551.191731-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 15, 2023 at 08:35:52PM -0700, Nathan Chancellor wrote:
> commit a8a4f0467d706fc22d286dfa973946e5944b793c upstream.
> 
> When booting with CONFIG_CFI_CLANG, there are numerous violations when
> accessing the files under
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/gt/gt0:
> 
>   $ cd /sys/devices/pci0000:00/0000:00:02.0/drm/card0/gt/gt0
> 
>   $ grep . *
>   id:0
>   punit_req_freq_mhz:350
>   rc6_enable:1
>   rc6_residency_ms:214934
>   rps_act_freq_mhz:1300
>   rps_boost_freq_mhz:1300
>   rps_cur_freq_mhz:350
>   rps_max_freq_mhz:1300
>   rps_min_freq_mhz:350
>   rps_RP0_freq_mhz:1300
>   rps_RP1_freq_mhz:350
>   rps_RPn_freq_mhz:350
>   throttle_reason_pl1:0
>   throttle_reason_pl2:0
>   throttle_reason_pl4:0
>   throttle_reason_prochot:0
>   throttle_reason_ratl:0
>   throttle_reason_status:0
>   throttle_reason_thermal:0
>   throttle_reason_vr_tdc:0
>   throttle_reason_vr_thermalert:0
> 
>   $ sudo dmesg &| grep "CFI failure at"
>   [  214.595903] CFI failure at kobj_attr_show+0x19/0x30 (target: id_show+0x0/0x70 [i915]; expected type: 0xc527b809)
>   [  214.596064] CFI failure at kobj_attr_show+0x19/0x30 (target: punit_req_freq_mhz_show+0x0/0x40 [i915]; expected type: 0xc527b809)
>   [  214.596407] CFI failure at kobj_attr_show+0x19/0x30 (target: rc6_enable_show+0x0/0x40 [i915]; expected type: 0xc527b809)
>   [  214.596528] CFI failure at kobj_attr_show+0x19/0x30 (target: rc6_residency_ms_show+0x0/0x270 [i915]; expected type: 0xc527b809)
>   [  214.596682] CFI failure at kobj_attr_show+0x19/0x30 (target: act_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.596792] CFI failure at kobj_attr_show+0x19/0x30 (target: boost_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.596893] CFI failure at kobj_attr_show+0x19/0x30 (target: cur_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.596996] CFI failure at kobj_attr_show+0x19/0x30 (target: max_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.597099] CFI failure at kobj_attr_show+0x19/0x30 (target: min_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.597198] CFI failure at kobj_attr_show+0x19/0x30 (target: RP0_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.597301] CFI failure at kobj_attr_show+0x19/0x30 (target: RP1_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.597405] CFI failure at kobj_attr_show+0x19/0x30 (target: RPn_freq_mhz_show+0x0/0xe0 [i915]; expected type: 0xc527b809)
>   [  214.597538] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.597701] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.597836] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.597952] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.598071] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.598177] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.598307] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.598439] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
>   [  214.598542] CFI failure at kobj_attr_show+0x19/0x30 (target: throttle_reason_bool_show+0x0/0x50 [i915]; expected type: 0xc527b809)
> 
> With kCFI, indirect calls are validated against their expected type
> versus actual type and failures occur when the two types do not match.
> The ultimate issue is that these sysfs functions are expecting to be
> called via dev_attr_show() but they may also be called via
> kobj_attr_show(), as certain files are created under two different
> kobjects that have two different sysfs_ops in intel_gt_sysfs_register(),
> hence the warnings above. When accessing the gt_ files under
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0, which are using the same
> sysfs functions, there are no violations, meaning the functions are
> being called with the proper type.
> 
> To make everything work properly, adjust certain functions to match the
> type of the ->show() and ->store() members in 'struct kobj_attribute'.
> Add a macro to generate functions for that can be called via both
> dev_attr_{show,store}() or kobj_attr_{show,store}() so that they can be
> called through both kobject locations without violating kCFI and adjust
> the attribute groups to account for this.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1716
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20221013205909.1282545-1-nathan@kernel.org
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> 
> Hi Greg and Sasha,
> 
> I received a report from a user of kCFI in 6.1 that the violation fixed
> by this patch is visible there (which is expected, since this was only
> merged in 6.2-rc1). This has been boot tested on real hardware and
> confirmed to fix that crash.
> 
> Additionally, Jocelyn reports that this patch also fixes a separate
> crash:
> 
> https://lore.kernel.org/4dcf830e-62a5-837b-7590-ac5395f84c14@redhat.com/
> 
> The patch is a little on the larger side of things but it should be
> pretty safe (the i915 folks can override me if they feel this is out of
> place).
> 

Seems sane, now queued up, thanks.

greg k-h
