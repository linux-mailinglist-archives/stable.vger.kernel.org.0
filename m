Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E631A0C38
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDGKp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:45:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:36154 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgDGKp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 06:45:26 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLljQ-0004ag-4r; Tue, 07 Apr 2020 12:45:24 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLljP-000Qbm-RI; Tue, 07 Apr 2020 12:45:23 +0200
Subject: Re: [PATCH 5.4 10/36] bpf: Fix tnum constraints for 32-bit
 comparisons
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bpf@vger.kernel.org
References: <20200407101454.281052964@linuxfoundation.org>
 <20200407101455.655552813@linuxfoundation.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <26e2a116-bc4c-59b2-7c54-6ebbfb140ea5@iogearbox.net>
Date:   Tue, 7 Apr 2020 12:45:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200407101455.655552813@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25774/Mon Apr  6 14:53:25 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Sasha, hey Greg,

On 4/7/20 12:21 PM, Greg Kroah-Hartman wrote:
> From: Jann Horn <jannh@google.com>
> 
> [ Upstream commit 604dca5e3af1db98bd123b7bfc02b017af99e3a0 ]
> 
> The BPF verifier tried to track values based on 32-bit comparisons by
> (ab)using the tnum state via 581738a681b6 ("bpf: Provide better register
> bounds after jmp32 instructions"). The idea is that after a check like
> this:
> 
>      if ((u32)r0 > 3)
>        exit
> 
> We can't meaningfully constrain the arithmetic-range-based tracking, but
> we can update the tnum state to (value=0,mask=0xffff'ffff'0000'0003).
> However, the implementation from 581738a681b6 didn't compute the tnum
> constraint based on the fixed operand, but instead derives it from the
> arithmetic-range-based tracking. This means that after the following
> sequence of operations:
> 
>      if (r0 >= 0x1'0000'0001)
>        exit
>      if ((u32)r0 > 7)
>        exit
> 
> The verifier assumed that the lower half of r0 is in the range (0, 0)
> and apply the tnum constraint (value=0,mask=0xffff'ffff'0000'0000) thus
> causing the overall tnum to be (value=0,mask=0x1'0000'0000), which was
> incorrect. Provide a fixed implementation.
> 
> Fixes: 581738a681b6 ("bpf: Provide better register bounds after jmp32 instructions")
> Signed-off-by: Jann Horn <jannh@google.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20200330160324.15259-3-daniel@iogearbox.net
> Signed-off-by: Sasha Levin <sashal@kernel.org>

We've already addressed this issue (CVE-2020-8835) on 5.4/5.5/5.6 kernels through
the following backports:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=8d62a8c7489a68b5738390b008134a644aa9b383
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.5.y&id=0ebc01466d98d016eb6a3780ec8edb0c86fa48bc
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.6.y&id=6797143df51c8ae259aa4bfe4e99c832b20bde8a

Given the severity of the issue, we concluded that revert-only is the best and
most straight forward way to address it for stable.

Was this selected via Sasha's ML mechanism? Should there be a commit tag to opt-out
for some commits being selected? E.g. this one 581738a681b6 ("bpf: Provide better
register bounds after jmp32 instructions") already fell through our radar and wrongly
made its way into 5.4 where it should have never landed. :/

Thanks,
Daniel
