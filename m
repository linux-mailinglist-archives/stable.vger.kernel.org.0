Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A455A5FA
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 22:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfF1Uht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 16:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbfF1Uht (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 16:37:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C158F2086D;
        Fri, 28 Jun 2019 20:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561754269;
        bh=9EXpoFnBbMdrxcl40ZXbwS9ICKS0sIKQS1CjVCKVsGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XlbQ33nnYGsUm0saOo8jLWnWWADTqkE32DPzbH1LTgBOtTgyFe+oZEw30pJYHeqQS
         2u5jtRZ7wDeFvGkBKBwVfIh5INWkqkwYu7aSFdglzwpVvNhDT4MSd8kfBBiKN4rXDS
         Zr6POXQDahna6siYeguGvdEPDzLmVjqPPlYLQExA=
Date:   Fri, 28 Jun 2019 16:37:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tony Battersby <tonyb@cybernetics.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Regression: cannot compile kernel 4.14 with old gcc
Message-ID: <20190628203747.GH11506@sasha-vm>
References: <54a67814-1c9a-14c9-3a7d-947b08369514@cybernetics.com>
 <CAKwvOdncNyL27A8y0Cq-md1ub9r2RdzBcb7ZrmmmyqLBxKvSfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdncNyL27A8y0Cq-md1ub9r2RdzBcb7ZrmmmyqLBxKvSfQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 09:42:21AM -0700, Nick Desaulniers wrote:
>On Fri, Jun 28, 2019 at 8:53 AM Tony Battersby <tonyb@cybernetics.com> wrote:
>>
>> Old versions of gcc cannot compile 4.14 since 4.14.113:
>>
>> ./include/asm-generic/fixmap.h:37: error: implicit declaration of function ‘__builtin_unreachable’
>>
>> The stable commit that caused the problem is 82017e26e515 ("compiler.h:
>> update definition of unreachable()") (upstream commit fe0640eb30b7).
>> Reverting the commit fixes the problem.
>>
>> Kernel 4.17 dropped support for older versions of gcc in upstream commit
>> cafa0010cd51 ("Raise the minimum required gcc version to 4.6").  This
>> was not backported to 4.14 since that would go against the stable kernel
>> rules.
>>
>> Upstream commit 815f0ddb346c ("include/linux/compiler*.h: make
>> compiler-*.h mutually exclusive") was a fix for cafa0010cd51.  This was
>> not backported to 4.14.
>>
>> Upstream commit fe0640eb30b7 ("compiler.h: update definition of
>> unreachable()") was a fix for 815f0ddb346c.  This is the commit that was
>> backported to 4.14.  But it only fixed a problem introduced in the other
>> commits, and without those commits, it ends up introducing a problem
>> instead of fixing one.  So I recommend reverting that patch in 4.14,
>> which will enable old gcc to compile 4.14 again.  If I understand
>> correctly, I believe that clang will still be able to compile 4.14 with
>> the patch reverted, although I haven't tried to compile with clang.
>>
>> The problematic commit is not present in 4.9.x, 4.4.x, 3.18.x, or 3.16.x.
>
>$ make CC=clang -j71 arch/x86/mm/fault.o
>produces no objtool warning with upstream commit fe0640eb30b7 reverted.
>
>x86 defconfig w/ Clang also have no issue with that reverted on 4.14.y.
>
>Revert away.
>
>Greg, Sasha,
>Do you need a patch file for that, or can you please push a
>$ cd linux-stable
>$ git checkout 4.14.y
>$ git revert 82017e26e51596ee577171a33f357377ec6513b5

You got it.

>-- 
>Thanks,
>~Nick Desaulniers
