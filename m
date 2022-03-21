Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5844B4E26D6
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 13:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbiCUMsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 08:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347539AbiCUMsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 08:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2512E986F0;
        Mon, 21 Mar 2022 05:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C087EB81115;
        Mon, 21 Mar 2022 12:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A36C340F2;
        Mon, 21 Mar 2022 12:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647866792;
        bh=BkBf+XFWCAFnCR/tIuvZqXB3Sz74SS7v8oRpDMkj3uM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OJZ11NuW33i8Nzk5Pj4MfF+w79QvgPBxptvAIOI39vAFc2EZjKLDYNoQd2oVBaNiy
         mci7fV94a9SUIa4t2sTeyU1nbx4HI+NY7/KFd1rBTH+pQWcAOB2NOc3c0PL4IECDy6
         vtHm55IA1FPfSNFNe0TcPTUm8jrYOG6AXu4UMQUw=
Date:   Mon, 21 Mar 2022 13:46:29 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Geliang Tang <geliang.tang@suse.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "memxor@gmail.com" <memxor@gmail.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@suse.com>,
        Kai Liu <kai.liu@suse.com>
Subject: Re: [PATCH 5.10 37/71] selftests/bpf: Add test for bpf_timer
 overwriting crash
Message-ID: <YjhzpQgUR06JGYdG@kroah.com>
References: <HE1PR0402MB3497CB13A12C4D15D20A1FCCF8139@HE1PR0402MB3497.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0402MB3497CB13A12C4D15D20A1FCCF8139@HE1PR0402MB3497.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 02:42:49PM +0000, Geliang Tang wrote:
> Hi Greg,
> 
> I got this bpf selftests build break today on the stable branch 5.10.106:
> 
> =========================================================================
> CLNG-LLC [test_maps] test_tracepoint.o
> progs/timer_crash.c:8:19: error: field has incomplete type 'struct bpf_timer'
>         struct bpf_timer timer;
>                          ^
> progs/timer_crash.c:8:9: note: forward declaration of 'struct bpf_timer'
>         struct bpf_timer timer;
>                ^
> progs/timer_crash.c:35:6: warning: implicit declaration of function 'bpf_get_current_task_btf' is invalid in C99 [-Wimplicit-function-declaration]
>         if (bpf_get_current_task_btf()->tgid != pid)
>             ^
> progs/timer_crash.c:35:34: error: member reference type 'int' is not a pointer
>         if (bpf_get_current_task_btf()->tgid != pid)
>             ~~~~~~~~~~~~~~~~~~~~~~~~~~  ^
> progs/timer_crash.c:49:3: warning: implicit declaration of function 'bpf_timer_cancel' is invalid in C99 [-Wimplicit-function-declaration]
>                 bpf_timer_cancel(&e->timer);
>                 ^
> 2 warnings and 2 errors generated.
>   CLNG-LLC [test_maps] test_trace_ext_tracing.o
> llc: error: llc: <stdin>:1:1: error: expected top-level entity
> BPF obj compilation failed
> ^
> make: *** [Makefile:402: tools/testing/selftests/bpf/timer_crash.o] Error 1
> make: *** Waiting for unfinished jobs....
>   CLNG-LLC [test_maps] test_trace_ext.o
> =========================================================================
> 
> It is introduced by this commit, "selftests/bpf: Add test for bpf_timer
> overwriting crash". Since the commit "bpf: Introduce bpf timers." has not
> been merged into the stable branch yet.
> 
> I am writing to you to report this bug.
> 

Now reverted, thanks!

greg k-h
