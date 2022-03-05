Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D374CE512
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiCENvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217BFB0D25
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD17AB80BEB
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013FC004E1;
        Sat,  5 Mar 2022 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646488249;
        bh=pFFRxufB1K0c189fDCrd16gRgkRT/ePcT3STv3y8u7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNo6FJQUtPRlMkmeChdAwmcjXtfZeJQJu/jT252D1Fl5Hbk4gh6WYbgCi4KotvfQS
         S9dgx3KMhpj14f2L2kTbm4obyCqPOFSjiZCfQdV68hKbJhw7L3LWWWJbi7rHGTZVQT
         WtHkIwU4204dkJXhpjkeBx7czRt9olXSnqdu2AB4=
Date:   Sat, 5 Mar 2022 14:50:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <YiNqtoeFno9LxaRF@kroah.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com>
 <Yg6AbfbFgDqbhq0e@google.com>
 <YhNg4uM1gIN89B7U@google.com>
 <YhNoZy415MYPH+GR@kroah.com>
 <YhNtE/sIdv5OkBQT@google.com>
 <f01b6557-ed8f-1385-c5f6-95f73b940b7f@iogearbox.net>
 <577A5957-B1ED-41D8-A17C-227E15C23925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <577A5957-B1ED-41D8-A17C-227E15C23925@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 07:04:40PM -0300, Rafael David Tinoco wrote:
> 
> >> The bad-commit mentioned in "the Fixes tag":
> >> Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
> >> Which as you say, could well have been fixing another issue.
> >> In fact, yes it was:
> >> https://lore.kernel.org/stable/20210821203108.215937-2-rafaeldtinoco@gmail.com/
> >> Daniel, what do you suggest please?
> > 
> > Hm, okay, so a23740ec43ba ("bpf: Track contents of read-only maps as scalars") was
> > backported to 5.4.144 given Rafael needed it to fix a failing regression test [0].
> > 
> > Normally, I would have said that we should just revert a23740ec43ba given it was
> > not a 'fix' in the first place, but then we are getting into a situation where it
> > would break Rafael's now functioning test case again on 5.4.144+ released kernels.
> > 
> 
> IIRC, Without this patch, eBPF programs with extern variables, either from ksyms
> or kconfig relocations, done by libbpf, used as branch conditions, won't work in
> <= 5.4.144.
> 
> Something like:
> 
> extern u32 CONFIG_ARCH_HAS_SYSCALL_WRAPPER __kconfig;
> ...
> if (CONFIG_ARCH_HAS_SYSCALL_WRAPPER) {
>    valid BTF type declared/used
> } else {
>    <dead code>: invalid BTF type declared/used
> }
> ...
> 
> The dead code is always evaluated and object load does not pass the verifier.
> 
> The workaround to mitigate this is to always rely in type/field existence checks
> for the branch conditions, instead of relying in kconfig/ksyms relocations.
> 
> We've been doing this to support same CO-RE BPF obj in kernels < 5.4 so I guess
> we could continue doing this for 5.4 as well (allowing you to drop this "fix").
> 
> Sorry for the burden (about having to introduce another fix, needed because of
> that patch). I hope nobody else is relying on it and, if they are, there is a
> mitigation described above.
> 
> So, feel free to drop it if it's easier for 5.4 maintenance, I'll mitigate
> code on our side.

Thanks for the info.

Lee, can you make up a revert patch for 5.4 with the above information
in it so that I can queue it up?

thanks,

greg k-h
