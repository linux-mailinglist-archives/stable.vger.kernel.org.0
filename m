Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCD7D8AA7
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 10:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfJPIQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 04:16:42 -0400
Received: from foss.arm.com ([217.140.110.172]:60200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfJPIQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 04:16:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFD63142F;
        Wed, 16 Oct 2019 01:16:41 -0700 (PDT)
Received: from [10.37.9.204] (unknown [10.37.9.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AE363F68E;
        Wed, 16 Oct 2019 01:16:38 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e4=2e0-?=
 =?UTF-8?Q?rc2-d6c2c23=2ecki_=28stable-next=29?=
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
 <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com>
 <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
 <20191016042933.bemrrurjbghuiw73@willie-the-truck>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <0ea36d3b-1e24-fe15-9fea-2570790eb9b9@arm.com>
Date:   Wed, 16 Oct 2019 09:18:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016042933.bemrrurjbghuiw73@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/19 5:29 AM, Will Deacon wrote:
> From 517d979e84191ae9997c9513a88a5b798af6912f Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Tue, 15 Oct 2019 21:04:18 -0700
> Subject: [PATCH] arm64: tags: Preserve tags for addresses translated via TTBR1
> 
> Sign-extending TTBR1 addresses when converting to an untagged address
> breaks the documented POSIX semantics for mlock() in some obscure error
> cases where we end up returning -EINVAL instead of -ENOMEM as a direct
> result of rewriting the upper address bits.
> 
> Rework the untagged_addr() macro to preserve the upper address bits for
> TTBR1 addresses and only clear the tag bits for user addresses. This
> matches the behaviour of the 'clear_address_tag' assembly macro, so
> rename that and align the implementations at the same time so that they
> use the same instruction sequences for the tag manipulation.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/stable/20191014162651.GF19200@arrakis.emea.arm.com/
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/asm-uaccess.h |  7 +++----
>  arch/arm64/include/asm/memory.h      | 10 ++++++++--
>  arch/arm64/kernel/entry.S            |  4 ++--
>  3 files changed, 13 insertions(+), 8 deletions(-)
> 

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

-- 
Regards,
Vincenzo
