Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7839AF8D2
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfIKJXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfIKJXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:23:34 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2F9D2089F;
        Wed, 11 Sep 2019 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568193813;
        bh=wqsC4eQMaI6W5IauLZxIsmiwgmOCoou6usBCuc3yDHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCKY7C7Jav+0vy+A7kEDyCrB5VdHEanrieqZZFZogLWn5Oc5o7JhWP2vnFIWuTmoE
         CDBa1r9XDc1Jr9B01KtFXmylSz3lizQv4Vievg0wgaRec4ndIX1A1IW6Y+GIofEC/b
         Qzk6WoAR6iSfQtkund2p+TPn/4+wCIdlT/76yaoM=
Date:   Wed, 11 Sep 2019 05:23:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Michael Neuling <mikey@neuling.org>, gromero@linux.ibm.com,
        mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] powerpc/tm: Fix restoring FP/VMX facility
 incorrectly on interrupts
Message-ID: <20190911092330.GJ2012@sasha-vm>
References: <15681148654568@kroah.com>
 <07d47bd664b13cf5cdc0361a59b26f9e448e2079.camel@neuling.org>
 <20190911090903.GA30714@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190911090903.GA30714@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 10:09:03AM +0100, Greg KH wrote:
>On Wed, Sep 11, 2019 at 10:13:27AM +1000, Michael Neuling wrote:
>> When in userspace and MSR FP=0 the hardware FP state is unrelated to
>> the current process. This is extended for transactions where if tbegin
>> is run with FP=0, the hardware checkpoint FP state will also be
>> unrelated to the current process. Due to this, we need to ensure this
>> hardware checkpoint is updated with the correct state before we enable
>> FP for this process.
>>
>> Unfortunately we get this wrong when returning to a process from a
>> hardware interrupt. A process that starts a transaction with FP=0 can
>> take an interrupt. When the kernel returns back to that process, we
>> change to FP=1 but with hardware checkpoint FP state not updated. If
>> this transaction is then rolled back, the FP registers now contain the
>> wrong state.
>>
>> The process looks like this:
>>    Userspace:                      Kernel
>>
>>                Start userspace
>>                 with MSR FP=0 TM=1
>>                   < -----
>>    ...
>>    tbegin
>>    bne
>>                Hardware interrupt
>>                    ---- >
>>                                     <do_IRQ...>
>>                                     ....
>>                                     ret_from_except
>>                                       restore_math()
>> 				        /* sees FP=0 */
>>                                         restore_fp()
>>                                           tm_active_with_fp()
>> 					    /* sees FP=1 (Incorrect) */
>>                                           load_fp_state()
>>                                         FP = 0 -> 1
>>                   < -----
>>                Return to userspace
>>                  with MSR TM=1 FP=1
>>                  with junk in the FP TM checkpoint
>>    TM rollback
>>    reads FP junk
>>
>> When returning from the hardware exception, tm_active_with_fp() is
>> incorrectly making restore_fp() call load_fp_state() which is setting
>> FP=1.
>>
>> The fix is to remove tm_active_with_fp().
>>
>> tm_active_with_fp() is attempting to handle the case where FP state
>> has been changed inside a transaction. In this case the checkpointed
>> and transactional FP state is different and hence we must restore the
>> FP state (ie. we can't do lazy FP restore inside a transaction that's
>> used FP). It's safe to remove tm_active_with_fp() as this case is
>> handled by restore_tm_state(). restore_tm_state() detects if FP has
>> been using inside a transaction and will set load_fp and call
>> restore_math() to ensure the FP state (checkpoint and transaction) is
>> restored.
>>
>> This is a data integrity problem for the current process as the FP
>> registers are corrupted. It's also a security problem as the FP
>> registers from one process may be leaked to another.
>>
>> Similarly for VMX.
>>
>> A simple testcase to replicate this will be posted to
>> tools/testing/selftests/powerpc/tm/tm-poison.c
>>
>> This fixes CVE-2019-15031.
>>
>> Fixes: a7771176b439 ("powerpc: Don't enable FP/Altivec if not checkpointed")
>> Cc: stable@vger.kernel.org # 4.15+
>> Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
>> Signed-off-by: Michael Neuling <mikey@neuling.org>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Link: https://lore.kernel.org/r/20190904045529.23002-2-gromero@linux.vnet.ibm.com
>> ---
>> Greg, This is a backport for v4.19 only since the original patch didn't
>> apply.
>>
>> Commit a8318c13e79badb92bc6640704a64cc022a6eb97 upstream.
>
>Now queued up, thanks.

Michael,

Thank you for the backport. Would you have an objection if instead I'd
just take 5c784c8414fba ("powerpc/tm: Remove msr_tm_active()") as well?

--
Thanks,
Sasha
