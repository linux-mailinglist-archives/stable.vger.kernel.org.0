Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777015598C0
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 13:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiFXLor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 07:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiFXLoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 07:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693B24EDEC;
        Fri, 24 Jun 2022 04:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0496762217;
        Fri, 24 Jun 2022 11:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0A4C34114;
        Fri, 24 Jun 2022 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656071084;
        bh=AcvMVXTJvvDQHsxFy3AQJir0CG0f8T75wQupw6/jENE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4BOHPFOKTKfh60lu4Lk8o4a5f0ylzGKfok36U5sdharBpc+04raj+x1Tdtdm97Gh
         fD4xz+TQm32fuy4OQ02Qytltg9xzaQHtnZL2C1WUtuPWGSAYLQgrv5E2o6zqRAcXoC
         qRHv5ws0gMheJc5CAOMCvmsye0e9GXXpH9BdDLuU=
Date:   Fri, 24 Jun 2022 13:09:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.15 33/33] selftests/bpf: Add test for reg2btf_ids out
 of bounds access
Message-ID: <YrWbZi7jt1x83tRC@kroah.com>
References: <20220429104052.345760505@linuxfoundation.org>
 <20220429104053.296096344@linuxfoundation.org>
 <CAMy_GT9YbgqsoLbCDqhHpXNW6EejgK+YaE4YPxpxcmer+qn-1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMy_GT9YbgqsoLbCDqhHpXNW6EejgK+YaE4YPxpxcmer+qn-1g@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 24, 2022 at 06:33:57PM +0800, Po-Hsu Lin wrote:
> On Fri, Apr 29, 2022 at 6:47 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >
> > commit 13c6a37d409db9abc9c0bfc6d0a2f07bf0fff60e upstream.
> >
> > This test tries to pass a PTR_TO_BTF_ID_OR_NULL to the release function,
> > which would trigger a out of bounds access without the fix in commit
> > 45ce4b4f9009 ("bpf: Fix crash due to out of bounds access into reg2btf_ids.")
> > but after the fix, it should only index using base_type(reg->type),
> > which should be less than __BPF_REG_TYPE_MAX, and also not permit any
> > type flags to be set for the reg->type.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Link: https://lore.kernel.org/bpf/20220220023138.2224652-1-memxor@gmail.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  tools/testing/selftests/bpf/verifier/calls.c |   19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > --- a/tools/testing/selftests/bpf/verifier/calls.c
> > +++ b/tools/testing/selftests/bpf/verifier/calls.c
> > @@ -108,6 +108,25 @@
> >         .errstr = "R0 min value is outside of the allowed memory range",
> >  },
> >  {
> > +       "calls: trigger reg2btf_ids[reg->type] for reg->type > __BPF_REG_TYPE_MAX",
> > +       .insns = {
> > +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
> > +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
> > +       BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
> > +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> > +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> > +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> > +       .result = REJECT,
> > +       .errstr = "arg#0 pointer type STRUCT prog_test_ref_kfunc must point",
> > +       .fixup_kfunc_btf_id = {
> > +               { "bpf_kfunc_call_test_acquire", 3 },
> > +               { "bpf_kfunc_call_test_release", 5 },
> > +       },
> > +},
> > +{
> >         "calls: overlapping caller/callee",
> >         .insns = {
> >         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 0),
> >
> >
> 
> Hello Greg,
> 
> When I tried to build the bpf selftest from 5.15.49 source tree on a
> Ubuntu Jammy instance running with 5.15.49-051549-generic, I got the
> following error message:
> 
> In file included from
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/tests.h:21,
>                  from test_verifier.c:432:
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:124:10:
> error: ‘struct bpf_test’ has no member named ‘fixup_kfunc_btf_id’
>   124 |         .fixup_kfunc_btf_id = {
>       |          ^~~~~~~~~~~~~~~~~~
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:124:9:
> warning: braces around scalar initializer
>   124 |         .fixup_kfunc_btf_id = {
>       |         ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:124:9:
> note: (near initialization for ‘tests[150].errstr_unpriv’)
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:17:
> warning: braces around scalar initializer
>   125 |                 { "bpf_kfunc_call_test_acquire", 3 },
>       |                 ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:17:
> note: (near initialization for ‘tests[150].errstr_unpriv’)
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:50:
> warning: excess elements in scalar initializer
>   125 |                 { "bpf_kfunc_call_test_acquire", 3 },
>       |                                                  ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:50:
> note: (near initialization for ‘tests[150].errstr_unpriv’)
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
> warning: braces around scalar initializer
>   126 |                 { "bpf_kfunc_call_test_release", 5 },
>       |                 ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
> note: (near initialization for ‘tests[150].errstr_unpriv’)
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:50:
> warning: excess elements in scalar initializer
>   126 |                 { "bpf_kfunc_call_test_release", 5 },
>       |                                                  ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:50:
> note: (near initialization for ‘tests[150].errstr_unpriv’)
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
> warning: excess elements in scalar initializer
>   126 |                 { "bpf_kfunc_call_test_release", 5 },
>       |                 ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
> note: (near initialization for ‘tests[150].errstr_unpriv’)
> make: *** [Makefile:508:
> /home/ubuntu/linux/tools/testing/selftests/bpf/test_verifier] Error 1
> 
> Which is introduced by this commit f59e6886c "selftests/bpf: Add test
> for reg2btf_ids out of bounds access" on 5.15. With this commit
> reverted, there will be another error in progs/timer_crash.c like in
> 5.10 [1]:
> 
> progs/timer_crash.c:8:19: error: field has incomplete type 'struct bpf_timer'
>         struct bpf_timer timer;
>                          ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:39:8:
> note: forward declaration of 'struct bpf_timer'
> struct bpf_timer;
>        ^
> 1 error generated.
> 
> Maybe commit "selftests/bpf: Add test for bpf_timer overwriting crash"
> should be reverted on 5.15 as well.

Should the test be fixed instead?

I'll take patches for either, thanks.

greg k-h
