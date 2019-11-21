Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC14104F81
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 10:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKUJnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 04:43:32 -0500
Received: from www62.your-server.de ([213.133.104.62]:52554 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUJnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 04:43:32 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXizp-00076g-Ht; Thu, 21 Nov 2019 10:43:29 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXizp-0004AV-3B; Thu, 21 Nov 2019 10:43:29 +0100
Subject: Re: [PATCH] bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE,
 BPF_JSLT, BPF_JSGE}
To:     Wang YanQing <udknight@gmail.com>, stable@vger.kernel.org
Cc:     stephen@networkplumber.org, ast@kernel.org, songliubraving@fb.com,
        yhs@fb.com, itugrok@yahoo.com, bpf@vger.kernel.org
References: <20191121074336.GA15326@udknight>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <be634e7c-98f4-cd7d-6967-485dc0bd2ebc@iogearbox.net>
Date:   Thu, 21 Nov 2019 10:43:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191121074336.GA15326@udknight>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25639/Wed Nov 20 11:02:53 2019)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/21/19 8:43 AM, Wang YanQing wrote:
> commit 711aef1bbf88212a21f7103e88f397b47a528805 upstream.
> 
> The current method to compare 64-bit numbers for conditional jump is:
> 
> 1) Compare the high 32-bit first.
> 
> 2) If the high 32-bit isn't the same, then goto step 4.
> 
> 3) Compare the low 32-bit.
> 
> 4) Check the desired condition.
> 
> This method is right for unsigned comparison, but it is buggy for signed
> comparison, because it does signed comparison for low 32-bit too.
> 
> There is only one sign bit in 64-bit number, that is the MSB in the 64-bit
> number, it is wrong to treat low 32-bit as signed number and do the signed
> comparison for it.
> 
> This patch fixes the bug.
> 
> Note:
> The original commit adds a testcase in selftests/bpf for such bug, this
> backport patch doesn't include the testcase, because the testcase needs
> another upstream commit.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205469
> Reported-by: Tony Ambardar <itugrok@yahoo.com>
> Cc: Tony Ambardar <itugrok@yahoo.com>
> Cc: stable@vger.kernel.org #v4.19
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Thanks a lot for backporting & testing, Wang, much appreciated! Greg, if you get a
chance, please queue this & the other stable requests from Wang up.

Thanks,
Daniel
