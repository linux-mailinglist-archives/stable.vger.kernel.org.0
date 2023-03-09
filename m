Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0178A6B3033
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 23:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCIWIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 17:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCIWIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 17:08:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C3A6041B;
        Thu,  9 Mar 2023 14:08:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0E8DB81FBF;
        Thu,  9 Mar 2023 22:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C540C433D2;
        Thu,  9 Mar 2023 22:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678399698;
        bh=UlVzCuI7NYuxlEdiiI1qMZINXF4BqeCaJQDPkbWf9EM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Yu+MLyjR8Tc86tc5zgamnZfDXDGH4iSw8VNW+eEKsg1iHzK6o4EMX/Y7vYuZeD5Vo
         wY8UwG2ogbOgmMVhakDk8ETIASlYCXKIF6l1J7+tfpG9zdCV96trNZUI0LAUpd3oeB
         0BS7oOjEBKjZkCn35i+J2yWLmI04Tfm13eMZtEK32HFF9dzUnnFNfsp/6SCbSw6X8C
         9ReAttTlgATYH/NO/iAqFpqEKZgZSJ3/fG+dhn7kEzWrIVEUcUT6mtwIdh2nkwkInO
         mFguephkbQz0FQ7yn+miOhO2CiDX3ElS/Era2HHJWvjJnvexcHD8CEpgWDWiuXL5Wl
         iXZYaT1yNWvFw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 143211548D6E; Thu,  9 Mar 2023 14:08:18 -0800 (PST)
Date:   Thu, 9 Mar 2023 14:08:18 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Marco Elver <elver@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, Haibo Li <haibo.li@mediatek.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] kcsan: Avoid READ_ONCE() in read_instrumented_memory()
Message-ID: <510ecaa9-508c-4f85-b6aa-fc42d2a96254@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230309101752.2025459-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309101752.2025459-1-elver@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 09, 2023 at 11:17:52AM +0100, Marco Elver wrote:
> Haibo Li reported:
> 
>  | Unable to handle kernel paging request at virtual address
>  |   ffffff802a0d8d7171
>  | Mem abort info:o:
>  |   ESR = 0x9600002121
>  |   EC = 0x25: DABT (current EL), IL = 32 bitsts
>  |   SET = 0, FnV = 0 0
>  |   EA = 0, S1PTW = 0 0
>  |   FSC = 0x21: alignment fault
>  | Data abort info:o:
>  |   ISV = 0, ISS = 0x0000002121
>  |   CM = 0, WnR = 0 0
>  | swapper pgtable: 4k pages, 39-bit VAs, pgdp=000000002835200000
>  | [ffffff802a0d8d71] pgd=180000005fbf9003, p4d=180000005fbf9003,
>  | pud=180000005fbf9003, pmd=180000005fbe8003, pte=006800002a0d8707
>  | Internal error: Oops: 96000021 [#1] PREEMPT SMP
>  | Modules linked in:
>  | CPU: 2 PID: 45 Comm: kworker/u8:2 Not tainted
>  |   5.15.78-android13-8-g63561175bbda-dirty #1
>  | ...
>  | pc : kcsan_setup_watchpoint+0x26c/0x6bc
>  | lr : kcsan_setup_watchpoint+0x88/0x6bc
>  | sp : ffffffc00ab4b7f0
>  | x29: ffffffc00ab4b800 x28: ffffff80294fe588 x27: 0000000000000001
>  | x26: 0000000000000019 x25: 0000000000000001 x24: ffffff80294fdb80
>  | x23: 0000000000000000 x22: ffffffc00a70fb68 x21: ffffff802a0d8d71
>  | x20: 0000000000000002 x19: 0000000000000000 x18: ffffffc00a9bd060
>  | x17: 0000000000000001 x16: 0000000000000000 x15: ffffffc00a59f000
>  | x14: 0000000000000001 x13: 0000000000000000 x12: ffffffc00a70faa0
>  | x11: 00000000aaaaaaab x10: 0000000000000054 x9 : ffffffc00839adf8
>  | x8 : ffffffc009b4cf00 x7 : 0000000000000000 x6 : 0000000000000007
>  | x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffffc00a70fb70
>  | x2 : 0005ff802a0d8d71 x1 : 0000000000000000 x0 : 0000000000000000
>  | Call trace:
>  |  kcsan_setup_watchpoint+0x26c/0x6bc
>  |  __tsan_read2+0x1f0/0x234
>  |  inflate_fast+0x498/0x750
>  |  zlib_inflate+0x1304/0x2384
>  |  __gunzip+0x3a0/0x45c
>  |  gunzip+0x20/0x30
>  |  unpack_to_rootfs+0x2a8/0x3fc
>  |  do_populate_rootfs+0xe8/0x11c
>  |  async_run_entry_fn+0x58/0x1bc
>  |  process_one_work+0x3ec/0x738
>  |  worker_thread+0x4c4/0x838
>  |  kthread+0x20c/0x258
>  |  ret_from_fork+0x10/0x20
>  | Code: b8bfc2a8 2a0803f7 14000007 d503249f (78bfc2a8) )
>  | ---[ end trace 613a943cb0a572b6 ]-----
> 
> The reason for this is that on certain arm64 configuration since
> e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when
> CONFIG_LTO=y"), READ_ONCE() may be promoted to a full atomic acquire
> instruction which cannot be used on unaligned addresses.
> 
> Fix it by avoiding READ_ONCE() in read_instrumented_memory(), and simply
> forcing the compiler to do the required access by casting to the
> appropriate volatile type. In terms of generated code this currently
> only affects architectures that do not use the default READ_ONCE()
> implementation.
> 
> The only downside is that we are not guaranteed atomicity of the access
> itself, although on most architectures a plain load up to machine word
> size should still be atomic (a fact the default READ_ONCE() still relies
> on itself).
> 
> Reported-by: Haibo Li <haibo.li@mediatek.com>
> Tested-by: Haibo Li <haibo.li@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.17+
> Signed-off-by: Marco Elver <elver@google.com>

Queued, thank you!

This one looks like it might want to go into v6.4 rather than later.

							Thanx, Paul

> ---
>  kernel/kcsan/core.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
> index 54d077e1a2dc..5a60cc52adc0 100644
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -337,11 +337,20 @@ static void delay_access(int type)
>   */
>  static __always_inline u64 read_instrumented_memory(const volatile void *ptr, size_t size)
>  {
> +	/*
> +	 * In the below we don't necessarily need the read of the location to
> +	 * be atomic, and we don't use READ_ONCE(), since all we need for race
> +	 * detection is to observe 2 different values.
> +	 *
> +	 * Furthermore, on certain architectures (such as arm64), READ_ONCE()
> +	 * may turn into more complex instructions than a plain load that cannot
> +	 * do unaligned accesses.
> +	 */
>  	switch (size) {
> -	case 1:  return READ_ONCE(*(const u8 *)ptr);
> -	case 2:  return READ_ONCE(*(const u16 *)ptr);
> -	case 4:  return READ_ONCE(*(const u32 *)ptr);
> -	case 8:  return READ_ONCE(*(const u64 *)ptr);
> +	case 1:  return *(const volatile u8 *)ptr;
> +	case 2:  return *(const volatile u16 *)ptr;
> +	case 4:  return *(const volatile u32 *)ptr;
> +	case 8:  return *(const volatile u64 *)ptr;
>  	default: return 0; /* Ignore; we do not diff the values. */
>  	}
>  }
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
