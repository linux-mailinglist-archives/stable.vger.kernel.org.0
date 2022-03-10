Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F594D4858
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 14:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbiCJNrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 08:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242527AbiCJNrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 08:47:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23C614F996
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 05:46:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69051B82642
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1154C340E8;
        Thu, 10 Mar 2022 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646919980;
        bh=BRcba2F6mZjWuxv7z7U0+ALLPPIUuMyN1QZcdQLe7HA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3QXLP2YuEPdYaOzCe1VIE/pfG3sj1p0fdtb3R94PGC8aZzdmVw1wb2I/FJxOioma
         4VJSohhDJdCvYSBQb/zrlztJPZpY6hJP2MZDrKfvJxQ5vBrs5GezXBzHHbrzvUzFX6
         6pxbv8MYalRmr6hczc2HTezcSz0/S6sLru3JpJVY=
Date:   Thu, 10 Mar 2022 14:46:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc queue/4.19 x86 and i386 builds failed
Message-ID: <YioBKLADXDI0b60b@kroah.com>
References: <CA+G9fYtEAa1C7PQGKXxMdeQPBxQJD=vre8BU-i+GzuDpXr9DyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtEAa1C7PQGKXxMdeQPBxQJD=vre8BU-i+GzuDpXr9DyA@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 06:20:16PM +0530, Naresh Kamboju wrote:
> stable-rc queue/4.19 x86 and i386 gcc-11 builds failed due to following
> multiple warnings and errors.
> 
> metadata:
>     git_describe: v4.19.233-22-g83c76d59eabe
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
>     git_sha: 83c76d59eabe7545b86485336a9aeb0f652666be
>     git_short_log: 83c76d59eabe (\ARM: fix build warning in proc-v7-bugs.c\)
>     target_arch: x86_64
>     toolchain: gcc-11
> 
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/2/build ARCH=x86_64
> CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> arch/x86/entry/entry_64.S: Assembler messages:
> arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic
> suffix given and no register operands; using default for `sysret'
> arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> function 'unprivileged_ebpf_enabled'
> [-Werror=implicit-function-declaration]
>   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> 
> drivers/crypto/ccp/sp-platform.c:37:34: warning: array 'sp_of_match'
> assumed to have one element
>    37 | static const struct of_device_id sp_of_match[];
>       |                                  ^~~~~~~~~~~
> drivers/gpu/drm/i915/intel_dp.c: In function 'intel_dp_check_mst_status':
> drivers/gpu/drm/i915/intel_dp.c:4129:30: warning:
> 'drm_dp_channel_eq_ok' reading 6 bytes from a region of size 4
> [-Wstringop-overread]
>  4129 |                             !drm_dp_channel_eq_ok(&esi[10],
> intel_dp->lane_count)) {
>       |
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpu/drm/i915/intel_dp.c:4129:30: note: referencing argument 1
> of type 'const u8 *' {aka 'const unsigned char *'}
> In file included from drivers/gpu/drm/i915/intel_dp.c:39:
> include/drm/drm_dp_helper.h:954:6: note: in a call to function
> 'drm_dp_channel_eq_ok'
>   954 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
>       |      ^~~~~~~~~~~~~~~~~~~~
> make[1]: Target '_all' not remade because of errors.
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build link [1] & [2]
> 

Should now be fixed, thanks.

greg k-h
