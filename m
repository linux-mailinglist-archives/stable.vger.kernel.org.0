Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6716BAF887
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfIKJJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbfIKJJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:09:07 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678312168B;
        Wed, 11 Sep 2019 09:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568192946;
        bh=d+l/mw3mTFAOji86pmDXKjEg4BFZMOOajiF3/9w9cRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ou/+/vTDRZtCgqP5PDqW5aKgVLbUDdPheqg/ujYEJxB8oOr1oOX9PpPFfOtNJfiP5
         ZoCHjwhVJ9Cfsh0QgWH1oU+LdlaaxEsm5wYQETDJtfnWaLxsWbWsbjRIcaE+NSJISk
         HFVTRqdS0QoiV53dxnjqiIRooNfgz15n1uZ1TVL0=
Date:   Wed, 11 Sep 2019 10:09:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Neuling <mikey@neuling.org>
Cc:     gromero@linux.ibm.com, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] powerpc/tm: Fix restoring FP/VMX facility
 incorrectly on interrupts
Message-ID: <20190911090903.GA30714@kroah.com>
References: <15681148654568@kroah.com>
 <07d47bd664b13cf5cdc0361a59b26f9e448e2079.camel@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07d47bd664b13cf5cdc0361a59b26f9e448e2079.camel@neuling.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 10:13:27AM +1000, Michael Neuling wrote:
> When in userspace and MSR FP=0 the hardware FP state is unrelated to
> the current process. This is extended for transactions where if tbegin
> is run with FP=0, the hardware checkpoint FP state will also be
> unrelated to the current process. Due to this, we need to ensure this
> hardware checkpoint is updated with the correct state before we enable
> FP for this process.
> 
> Unfortunately we get this wrong when returning to a process from a
> hardware interrupt. A process that starts a transaction with FP=0 can
> take an interrupt. When the kernel returns back to that process, we
> change to FP=1 but with hardware checkpoint FP state not updated. If
> this transaction is then rolled back, the FP registers now contain the
> wrong state.
> 
> The process looks like this:
>    Userspace:                      Kernel
> 
>                Start userspace
>                 with MSR FP=0 TM=1
>                   < -----
>    ...
>    tbegin
>    bne
>                Hardware interrupt
>                    ---- >
>                                     <do_IRQ...>
>                                     ....
>                                     ret_from_except
>                                       restore_math()
> 				        /* sees FP=0 */
>                                         restore_fp()
>                                           tm_active_with_fp()
> 					    /* sees FP=1 (Incorrect) */
>                                           load_fp_state()
>                                         FP = 0 -> 1
>                   < -----
>                Return to userspace
>                  with MSR TM=1 FP=1
>                  with junk in the FP TM checkpoint
>    TM rollback
>    reads FP junk
> 
> When returning from the hardware exception, tm_active_with_fp() is
> incorrectly making restore_fp() call load_fp_state() which is setting
> FP=1.
> 
> The fix is to remove tm_active_with_fp().
> 
> tm_active_with_fp() is attempting to handle the case where FP state
> has been changed inside a transaction. In this case the checkpointed
> and transactional FP state is different and hence we must restore the
> FP state (ie. we can't do lazy FP restore inside a transaction that's
> used FP). It's safe to remove tm_active_with_fp() as this case is
> handled by restore_tm_state(). restore_tm_state() detects if FP has
> been using inside a transaction and will set load_fp and call
> restore_math() to ensure the FP state (checkpoint and transaction) is
> restored.
> 
> This is a data integrity problem for the current process as the FP
> registers are corrupted. It's also a security problem as the FP
> registers from one process may be leaked to another.
> 
> Similarly for VMX.
> 
> A simple testcase to replicate this will be posted to
> tools/testing/selftests/powerpc/tm/tm-poison.c
> 
> This fixes CVE-2019-15031.
> 
> Fixes: a7771176b439 ("powerpc: Don't enable FP/Altivec if not checkpointed")
> Cc: stable@vger.kernel.org # 4.15+
> Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20190904045529.23002-2-gromero@linux.vnet.ibm.com
> ---
> Greg, This is a backport for v4.19 only since the original patch didn't
> apply.
> 
> Commit a8318c13e79badb92bc6640704a64cc022a6eb97 upstream.

Now queued up, thanks.

greg k-h
