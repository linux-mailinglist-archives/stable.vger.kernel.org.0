Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC13AC000
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 02:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhFRAOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 20:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhFRAOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 20:14:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AD2F610CA;
        Fri, 18 Jun 2021 00:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623975136;
        bh=NIkBnZc2GHohfpXgF10FM3cZz9pBdstBWE9sKMqAMu8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oSpSYvWFKgBFEmjj8o4qaE7vn+cDY9bhzewS9dKRZoiijkKB/+Yqur25dKFc91Vis
         ZIPJrkANH3XOikALMkUnqGw2NMPt+2syBcTxRTm5Ev0FPDGtcWXmgcUpH0vvkHEkHG
         eUQLxuoMVV4FDkRNZtCVHL97C/k/qdnN3cp8bPWJY+iKrsdKwIYHjOzT4a9IqX+lyj
         i1+y1Xo6wBY0AAm1bUVFS8enJ0mzJMsXotkTh2iJ+ORWNNUbZnA4HZP4xG4dZqoay8
         o8Bg5Bxd9kWW/TTPnGN7ihP827CtnDc1xghkjSy+TcwjGKxWA/F7/Q+8IdiRR0jt77
         rJUiaJF3kPs9g==
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
 <827549827.10547.1623941277868.JavaMail.zimbra@efficios.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <26196903-4aee-33c4-bed8-8bf8c7b46793@kernel.org>
Date:   Thu, 17 Jun 2021 17:12:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <827549827.10547.1623941277868.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/17/21 7:47 AM, Mathieu Desnoyers wrote:

> Please change back this #ifndef / #else / #endif within function for
> 
> if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE)) {
>   ...
> } else {
>   ...
> }
> 
> I don't think mixing up preprocessor and code logic makes it more readable.

I agree, but I don't know how to make the result work well.
membarrier_sync_core_before_usermode() isn't defined in the !IS_ENABLED
case, so either I need to fake up a definition or use #ifdef.

If I faked up a definition, I would want to assert, at build time, that
it isn't called.  I don't think we can do:

static void membarrier_sync_core_before_usermode()
{
    BUILD_BUG_IF_REACHABLE();
}

