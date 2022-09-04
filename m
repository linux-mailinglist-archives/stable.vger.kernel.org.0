Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715E95AC2F4
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 08:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiIDGS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 02:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDGS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 02:18:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697DD474FE;
        Sat,  3 Sep 2022 23:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6DD60DE3;
        Sun,  4 Sep 2022 06:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8918C433D6;
        Sun,  4 Sep 2022 06:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662272306;
        bh=/suyhRp9htNZ81ks9sWUMbjb7xBK3OarUmyTbyGexNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A2OgtPlKClwMv/Q+gv0/o3j6NgvEXUGIigr3Ika3eRo3Q60dEqwxoO8i4699+0Gb3
         3dAZ70P+B64g5VQDcdqeyp2RcGJu7KAOxYmoj8lX6xGve56HXeA+HZOmEYaYBnEMts
         p8IeXjWZ5NqyvM873vWTbdowznbjqai+u3H1QfPE=
Date:   Sun, 4 Sep 2022 08:18:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, stable@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf v2] bpf: Add config for skipping BTF enum64s
Message-ID: <YxRDLrgR0SLBhGum@kroah.com>
References: <20220828233317.35464-1-yakoyoku@gmail.com>
 <YxI0dO2yuqTK0H6f@krava>
 <YxLlouzk1O1Prg3J@kroah.com>
 <YxNhGc7Q+eiHCIr5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxNhGc7Q+eiHCIr5@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 03, 2022 at 11:13:45AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Sep 03, 2022 at 07:26:58AM +0200, Greg KH escreveu:
> > On Fri, Sep 02, 2022 at 06:51:00PM +0200, Jiri Olsa wrote:
> > > On Sun, Aug 28, 2022 at 08:33:17PM -0300, Martin Rodriguez Reboredo wrote:
> > > > After the release of pahole 1.24 some people in the dwarves mailing list
> > > > notified issues related to building the kernel with the BTF_DEBUG_INFO
> > > > option toggled. They seem to be happenning due to the kernel and
> > > > resolve_btfids interpreting btf types erroneously. In the dwarves list
> > > > I've proposed a change to the scripts that I've written while testing
> > > > the Rust kernel, it simply passes the --skip_encoding_btf_enum64 to
> > > > pahole if it has version 1.24.
> > > > 
> > > > v1 -> v2:
> > > > - Switch to off by default and remove the config option.
> > > > - Send it to stable instead.
> > > 
> > > hi,
> > > we have change that needs to go to stable kernels but does not have the
> > > equivalent fix in Linus tree
> > 
> > Why isn't it also relevant in Linus's tree?
> 
> See below.
>  
> > > what would be the best way to submit it?
> > 
> > Submit it here and document the heck out of why this isn't in Linus's
> > tree, what changes instead fixed it there, and so on.  Look in the
> > archives for examples of how this is done, one recent one that I can
> > think of is here:
> > 	https://lore.kernel.org/r/20220831191348.3388208-1-jannh@google.com
> > 
> > > the issue is that new 'pahole' will generate BTF data that are not supported
> > > by older kernels, so we need to add --skip_encoding_btf_enum64 option to
> > > stable kernel's scripts/pahole-flags.sh to generate proper BTF data
> > > 
> > > we got complains that after upgrading to latest pahole the stable kernel
> > > compilation fails
> > 
> > And what is happening in Linus's tree for this same issue?
> 
> So, BTF_KIND_ENUM64 is a new BTF tag, one that is not accepted by older
> kernels, but is accepted by the BPF verifier on Linus' tree.
> 
> Its about avoiding having a pahole command line with lots of
> --enable-new-feature-foo for new stuff with the default producing the
> most recent BTF spec.
> 
> One way to documenting it: if you update pahole, then please use
> --skip_encoding_FOO for these new FOO features on kernels where those
> aren't supported.
> 
> So this isn't a backport from a fix on Linus' tree, as both the older
> pahole that doesn't encode BTF_KIND_ENUM64 and the new one, that encodes
> it by default, work with Linus' tree.
> 
> Does this violates the stable@ rules?

Not really, if it fixes an issue for those kernels when using newer
tools, that's fine.  Just document it well like you did here.

thanks,

greg k-h
