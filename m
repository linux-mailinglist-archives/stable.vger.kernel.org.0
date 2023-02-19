Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30CC69BF41
	for <lists+stable@lfdr.de>; Sun, 19 Feb 2023 10:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBSJDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Feb 2023 04:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBSJDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Feb 2023 04:03:03 -0500
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0ED8113F4;
        Sun, 19 Feb 2023 01:03:01 -0800 (PST)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1pTfaz-0000LC-00; Sun, 19 Feb 2023 10:02:57 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 3A797C28CC; Sun, 19 Feb 2023 09:30:22 +0100 (CET)
Date:   Sun, 19 Feb 2023 09:30:22 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Elvira Khabirova <lineprinter0@gmail.com>
Cc:     "Dmitry V. Levin" <ldv@strace.io>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Andreas Henriksson <ah@debian.org>
Subject: Re: [PATCH] mips: fix syscall_get_nr
Message-ID: <20230219083022.GA2924@alpha.franken.de>
References: <20230218233212.1fed456b@akathisia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218233212.1fed456b@akathisia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 18, 2023 at 11:43:59PM +0100, Elvira Khabirova wrote:
> The implementation of syscall_get_nr on mips used to ignore the task
> argument and return the syscall number of the calling thread instead of
> the target thread.
> 
> The bug was exposed to user space by commit 201766a20e30f ("ptrace: add
> PTRACE_GET_SYSCALL_INFO request") and detected by strace test suite.
> 
> Link: https://github.com/strace/strace/issues/235
> Fixes: c2d9f1775731 ("MIPS: Fix syscall_get_nr for the syscall exit tracing.")
> Cc: <stable@vger.kernel.org> # v3.19+
> Co-developed-by: Dmitry V. Levin <ldv@strace.io>
> Signed-off-by: Dmitry V. Levin <ldv@strace.io>
> Signed-off-by: Elvira Khabirova <lineprinter0@gmail.com>
> ---
>  arch/mips/include/asm/syscall.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
> index 25fa651c937d..ebdf4d910af2 100644
> --- a/arch/mips/include/asm/syscall.h
> +++ b/arch/mips/include/asm/syscall.h
> @@ -38,7 +38,7 @@ static inline bool mips_syscall_is_indirect(struct task_struct *task,
>  static inline long syscall_get_nr(struct task_struct *task,
>  				  struct pt_regs *regs)
>  {
> -	return current_thread_info()->syscall;
> +	return task_thread_info(task)->syscall;
>  }
>  
>  static inline void mips_syscall_update_nr(struct task_struct *task,
> -- 

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
