Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49354B3B04
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 12:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiBMLKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 06:10:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBMLKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 06:10:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84E85EDCD
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 03:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C3B8B80AC8
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1461C004E1;
        Sun, 13 Feb 2022 11:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644750643;
        bh=okYU5kjXgur5R4CBuIybznQ+wpubvd9X7v/F3WAVLqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2v5BzwqAU8dLWAbw7wit5ZJ5UGVip7eCNbxe9X8PQ/HPrbwPB6uUizrNN1tjZczLu
         UZg3tQkiGruN13zCwRMhjY7eNVXKk4w0i5lMkD3GAYubZppoKUMHPFqQeQpmzoXdjN
         x+gqbhQNh9X0KfTAL6PRxGRpb4r9qZFOMNcHBUkE=
Date:   Sun, 13 Feb 2022 12:10:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 4.9] bpf: Add kconfig knob for disabling unpriv bpf by
 default
Message-ID: <YgjnMEHWI0kffEg4@kroah.com>
References: <20220212212149.6421-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212212149.6421-1-fllinden@amazon.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 12, 2022 at 09:21:49PM +0000, Frank van der Linden wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> commit 08389d888287c3823f80b0216766b71e17f0aba5 upstream.
> 
> Add a kconfig knob which allows for unprivileged bpf to be disabled by default.
> If set, the knob sets /proc/sys/kernel/unprivileged_bpf_disabled to value of 2.
> 
> This still allows a transition of 2 -> {0,1} through an admin. Similarly,
> this also still keeps 1 -> {1} behavior intact, so that once set to permanently
> disabled, it cannot be undone aside from a reboot.
> 
> We've also added extra2 with max of 2 for the procfs handler, so that an admin
> still has a chance to toggle between 0 <-> 2.
> 
> Either way, as an additional alternative, applications can make use of CAP_BPF
> that we added a while ago.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net
> [fllinden@amazon.com: backported to 4.9]
> Signed-off-by: Frank van der Linden <fllinden@amazon.com>
> ---
>  Documentation/sysctl/kernel.txt | 21 +++++++++++++++++++++
>  init/Kconfig                    | 10 ++++++++++
>  kernel/bpf/syscall.c            |  3 ++-
>  kernel/sysctl.c                 | 29 +++++++++++++++++++++++++----
>  4 files changed, 58 insertions(+), 5 deletions(-)

Now queued up, thanks.

greg k-h
