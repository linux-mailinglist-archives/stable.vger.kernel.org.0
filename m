Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714745ABD3B
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 07:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiICF0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 01:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiICF0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 01:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73AFD345D;
        Fri,  2 Sep 2022 22:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58FD660B28;
        Sat,  3 Sep 2022 05:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E525C433D7;
        Sat,  3 Sep 2022 05:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662182801;
        bh=B079wv8FTG2FZoN2VxIhQToUfCLjJr0frv6LTV1SiVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W4tKqyF9FUw1vBpORijFWWzJVD0C2XaM5g5h6m19SntJQ4giAynL2VDvuxY+c8lWk
         MmalnC50fWzxphYxCz4b+m51Fs8KIyI7fkrK/Bm+b0SWuF7c7RyEWmrTaXxqIA5TM3
         cb2bF6DIhQn2u0NxOgKTuUveMW7o8hEikC8xAXAU=
Date:   Sat, 3 Sep 2022 07:26:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH bpf v2] bpf: Add config for skipping BTF enum64s
Message-ID: <YxLlouzk1O1Prg3J@kroah.com>
References: <20220828233317.35464-1-yakoyoku@gmail.com>
 <YxI0dO2yuqTK0H6f@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxI0dO2yuqTK0H6f@krava>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 06:51:00PM +0200, Jiri Olsa wrote:
> On Sun, Aug 28, 2022 at 08:33:17PM -0300, Martin Rodriguez Reboredo wrote:
> > After the release of pahole 1.24 some people in the dwarves mailing list
> > notified issues related to building the kernel with the BTF_DEBUG_INFO
> > option toggled. They seem to be happenning due to the kernel and
> > resolve_btfids interpreting btf types erroneously. In the dwarves list
> > I've proposed a change to the scripts that I've written while testing
> > the Rust kernel, it simply passes the --skip_encoding_btf_enum64 to
> > pahole if it has version 1.24.
> > 
> > v1 -> v2:
> > - Switch to off by default and remove the config option.
> > - Send it to stable instead.
> 
> hi,
> we have change that needs to go to stable kernels but does not have the
> equivalent fix in Linus tree

Why isn't it also relevant in Linus's tree?

> what would be the best way to submit it?

Submit it here and document the heck out of why this isn't in Linus's
tree, what changes instead fixed it there, and so on.  Look in the
archives for examples of how this is done, one recent one that I can
think of is here:
	https://lore.kernel.org/r/20220831191348.3388208-1-jannh@google.com

> the issue is that new 'pahole' will generate BTF data that are not supported
> by older kernels, so we need to add --skip_encoding_btf_enum64 option to
> stable kernel's scripts/pahole-flags.sh to generate proper BTF data
> 
> we got complains that after upgrading to latest pahole the stable kernel
> compilation fails

And what is happening in Linus's tree for this same issue?

thanks,

greg k-h
