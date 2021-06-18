Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6B13AC004
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 02:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhFRAPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 20:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233160AbhFRAPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 20:15:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22EC613B4;
        Fri, 18 Jun 2021 00:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623975206;
        bh=nM5X1GSDxCk8rh3UgTy/aR3zlWC0sDSSq0YpILKyEOw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OMVzzQM29lbdahlsKSCVkJIHPNqJWdv46bej0dxQNvHfFZ1lx+2X51jV4n/h5APXr
         6FAoQ57E0/MvTDa7+CQeg8RV0KRnQayjeq3MS/wiDkP5F/ydPJSLV1nqrNRFPJ4hYd
         gm2yBgu4zSYV3TAKzdCYZSBu5ih2hOszRhY5uFzyKioNIvL/5w6vnuiWSGgh7teYx5
         mEqwNwWB/Vm+xbTsOZ6Yi5ETW509W13lkrpSvQyoTu8kkiZRI2S6tz0qobJj/Xvy9x
         11CjCqYHnKB3Ubl663ze8hjxIMC8oG9VCEyiswd7jQh1NnrWoH4N3E2801z1EbiLK1
         TzN+n0ZFCOOnw==
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     x86 <x86@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
References: <cover.1623813516.git.luto@kernel.org>
 <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
 <1939350496.10696.1623943014767.JavaMail.zimbra@efficios.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <678def50-eecd-fb0f-eac0-c0ba1a442574@kernel.org>
Date:   Thu, 17 Jun 2021 17:13:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1939350496.10696.1623943014767.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/17/21 8:16 AM, Mathieu Desnoyers wrote:
> ----- On Jun 15, 2021, at 11:21 PM, Andy Lutomirski luto@kernel.org wrote:
> 
> [...]
> 
>> +# An architecture that wants to support
>> +# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE needs to define precisely what it
>> +# is supposed to do and implement membarrier_sync_core_before_usermode() to
>> +# make it do that.  Then it can select ARCH_HAS_MEMBARRIER_SYNC_CORE via
>> +# Kconfig.Unfortunately, MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE is not a
>> +# fantastic API and may not make sense on all architectures.  Once an
>> +# architecture meets these requirements,
> 
> Can we please remove the editorial comment about the quality of the membarrier
> sync-core's API ?

Done
>> +#
>> +# On x86, a program can safely modify code, issue
>> +# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE, and then execute that code, via
>> +# the modified address or an alias, from any thread in the calling process.
>> +#
>> +# On arm64, a program can modify code, flush the icache as needed, and issue
>> +# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE to force a "context synchronizing
>> +# event", aka pipeline flush on all CPUs that might run the calling process.
>> +# Then the program can execute the modified code as long as it is executed
>> +# from an address consistent with the icache flush and the CPU's cache type.
>> +#
>> +# On powerpc, a program can use MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
>> +# similarly to arm64.  It would be nice if the powerpc maintainers could
>> +# add a more clear explanantion.
> 
> We should document the requirements on ARMv7 as well.

Done.

> 
> Thanks,
> 
> Mathieu
> 

