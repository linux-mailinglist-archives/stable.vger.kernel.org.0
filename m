Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA723576A2
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 23:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhDGVVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 17:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232332AbhDGVVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 17:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61A9661175;
        Wed,  7 Apr 2021 21:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617830482;
        bh=o8qxPnJ+j1q0xf7lkD4ZrFQFOtWVhbzPe6KygNi37aw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R73EQ1qQOJLsA2EYjLE2NnBV7mRwgfgmYv9jf8VkbfbljNVMo8M7kIcQOYj3zla58
         emLwyX0mRrvhc+9fhPY5ef9dLZIH0Ebk1SzJWSUReCV83bft6rQBppZY4QKSBWZzGu
         Bt4YqxsQbWqW0I/T+Gun1l4XHG5ABwpm+VSrk/8k=
Date:   Wed, 7 Apr 2021 14:21:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] gcov: re-fix clang-11+ support
Message-Id: <20210407142121.677e971e9e5dc85643441811@linux-foundation.org>
In-Reply-To: <20210407185456.41943-2-ndesaulniers@google.com>
References: <20210407185456.41943-1-ndesaulniers@google.com>
        <20210407185456.41943-2-ndesaulniers@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed,  7 Apr 2021 11:54:55 -0700 Nick Desaulniers <ndesaulniers@google.com> wrote:

> LLVM changed the expected function signature for
> llvm_gcda_emit_function() in the clang-11 release.  Users of clang-11 or
> newer may have noticed their kernels producing invalid coverage
> information:
> 
> $ llvm-cov gcov -a -c -u -f -b <input>.gcda -- gcno=<input>.gcno
> 1 <func>: checksum mismatch, \
>   (<lineno chksum A>, <cfg chksum B>) != (<lineno chksum A>, <cfg chksum C>)
> 2 Invalid .gcda File!
> ...
> 
> Fix up the function signatures so calling this function interprets its
> parameters correctly and computes the correct cfg checksum. In
> particular, in clang-11, the additional checksum is no longer optional.

Which tree is this against?  I'm seeing quite a lot of rejects against
Linus's current.

