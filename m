Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E5D4DD970
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiCRMNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiCRMNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 08:13:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 170521FAA18;
        Fri, 18 Mar 2022 05:12:05 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C34171424;
        Fri, 18 Mar 2022 05:12:04 -0700 (PDT)
Received: from [10.57.88.118] (unknown [10.57.88.118])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1CC63F7F5;
        Fri, 18 Mar 2022 05:12:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 18/43] arm64: entry: Add macro for reading symbol
 addresses from the trampoline
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220317124527.672236844@linuxfoundation.org>
 <20220317124528.180267687@linuxfoundation.org>
 <113e7675-4263-2a20-81d0-9634f03511d2@gmail.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <bc35996d-ec18-1923-38f4-81d16ed98b7a@arm.com>
Date:   Fri, 18 Mar 2022 12:11:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <113e7675-4263-2a20-81d0-9634f03511d2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Florian,

On 3/17/22 8:48 PM, Florian Fainelli wrote:
> On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> commit b28a8eebe81c186fdb1a0078263b30576c8e1f42 upstream.
>>
>> The trampoline code needs to use the address of symbols in the wider
>> kernel, e.g. vectors. PC-relative addressing wouldn't work as the
>> trampoline code doesn't run at the address the linker expected.
>>
>> tramp_ventry uses a literal pool, unless CONFIG_RANDOMIZE_BASE is
>> set, in which case it uses the data page as a literal pool because
>> the data page can be unmapped when running in user-space, which is
>> required for CPUs vulnerable to meltdown.
>>
>> Pull this logic out as a macro, instead of adding a third copy
>> of it.
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This commit causes a linking failure with CONFIG_ARM_SDE_INTERFACE=y
> enabled in the kernel:
> 
>    LD      .tmp_vmlinux.kallsyms1
> /local/users/fainelli/buildroot/output/arm64/host/bin/aarch64-linux-ld:
> arch/arm64/kernel/entry.o: in function `__sdei_asm_exit_trampoline':
> /local/users/fainelli/buildroot/output/arm64/build/linux-custom/arch/arm64/kernel/entry.S:1352:
> undefined reference to `__sdei_asm_trampoline_next_handler'
> make[2]: *** [Makefile:1100: vmlinux] Error 1
> make[1]: *** [package/pkg-generic.mk:295:
> /local/users/fainelli/buildroot/output/arm64/build/linux-custom/.stamp_built]
> Error 2
> make: *** [Makefile:27: _all] Error 2

... and with CONFIG_RANDOMIZE_BASE turned off, which is why allyesconfig didn't catch it.
This is because I kept the next_handler bit of the label when it conflicted, which isn't needed
because the __entry_tramp bit added by the macro serves the same purpose.

The below diff fixes it:
----------%<----------
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e4b5a15c2e2e..cfc0bb6c49f7 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1190,7 +1190,7 @@ __entry_tramp_data_start:
  __entry_tramp_data_vectors:
         .quad   vectors
  #ifdef CONFIG_ARM_SDE_INTERFACE
-__entry_tramp_data___sdei_asm_trampoline_next_handler:
+__entry_tramp_data___sdei_asm_handler:
         .quad   __sdei_asm_handler
  #endif /* CONFIG_ARM_SDE_INTERFACE */
         .popsection                             // .rodata
@@ -1319,7 +1319,7 @@ ENTRY(__sdei_asm_entry_trampoline)
          */
  1:     str     x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
  
-       tramp_data_read_var     x4, __sdei_asm_trampoline_next_handler
+       tramp_data_read_var     x4, __sdei_asm_handler
         br      x4
  ENDPROC(__sdei_asm_entry_trampoline)
  NOKPROBE(__sdei_asm_entry_trampoline)
----------%<----------

Good news - this didn't happen with v5.10.

I don't see this in v5.4.185 yet.

Greg/Sasha, what is least work for you?:
A new version of this patch,
A fixup on top of the series,
Reposting the series with this fixed.


Thanks for catching this!

James
