Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0733B3405
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 18:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhFXQjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 12:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFXQjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 12:39:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 985BB6128D;
        Thu, 24 Jun 2021 16:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624552604;
        bh=SPB+E/15fECt3/pgdDyZ+a7Wj/LA134HlNWj2sLvAXc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=roWTWHanBiMNgpR9NvuHwrHGkMdIjBzS+CauSlxa+fBKD3p3U+rHFx/xAlZg0wROO
         Mn0D08AkQJOLbf/Dt68FIKcr1YWwH9w160bumWnTMopD8QvPFbxqziGqDwDQOsllMp
         QCbsq2FYW6m+5vwyRR+TS4KSPN4+32wdLvnDqRjlcNWWHVar/9uu0F7898iN0kV5PF
         3dZc9hZmKksXlSk6TAK+8qsbYHXkonSZ2islC6kxtUS8G9tvD3ZGkDaCjeUkMbpiX+
         a8xO+0JELvDidNr515JkCVpGgoon1DYdNeqYvKuUyDG7h5dxxDWwkI7Aw+TxnFPnk3
         XjPGuHsQRrsFw==
Subject: Re: [PATCH 4.4 to 4.19] Makefile: Move -Wno-unused-but-set-variable
 out of GCC only block
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
References: <20210623172610.3281050-1-nathan@kernel.org>
 <YNR02aQT3f9Naap/@sashalap>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <d8ebe3e5-0001-1a53-7ec3-f335bb76a415@kernel.org>
Date:   Thu, 24 Jun 2021 09:36:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNR02aQT3f9Naap/@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/24/2021 5:04 AM, Sasha Levin wrote:
> On Wed, Jun 23, 2021 at 10:26:12AM -0700, Nathan Chancellor wrote:
>> commit 885480b084696331bea61a4f7eba10652999a9c1 upstream.
>>
>> Currently, -Wunused-but-set-variable is only supported by GCC so it is
>> disabled unconditionally in a GCC only block (it is enabled with W=1).
>> clang currently has its implementation for this warning in review so
>> preemptively move this statement out of the GCC only block and wrap it
>> with cc-disable-warning so that both compilers function the same.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://reviews.llvm.org/D100581
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>> [nc: Backport, workaround lack of e2079e93f562 in older branches]
> 
> Can we just take the above patch instead?

No because that patch has a prerequisite of commit a035d552a93b 
("Makefile: Globally enable fall-through warning"), which is not 
suitable for stable because there were hundreds of warnings fixed before 
that was enabled.

Cheers,
Nathan
