Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA30F1C0ACE
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 01:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgD3XDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 19:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbgD3XDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 19:03:34 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34A412064A;
        Thu, 30 Apr 2020 23:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588287814;
        bh=dz6J+lq5gWSCa7qqarNHY00n3Y0BnxGGrvPgIhnxUIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ShfZc2/qQElixZKtsadHR+GOX+WC52paXb/6cBw8/ElqFPP4+j+0k63e+GtZszi01
         6JGI7oUNd5qA/oObh1x7tCAqwwlkapUdFztd+e2CsiK8N+HlumZ9F4RUzp+3RbZu5s
         CgqV14o0L8xS9nFu6E4GpQbbefMIkwKnMizKNgro=
Date:   Thu, 30 Apr 2020 19:03:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lukenels@cs.washington.edu, ast@kernel.org, luke.r.nels@gmail.com,
        xi.wang@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf, x86: Fix encoding for lower 8-bit
 registers in BPF_STX" failed to apply to 5.4-stable tree
Message-ID: <20200430230333.GZ13035@sasha-vm>
References: <1588259178201116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1588259178201116@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 05:06:18PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From aee194b14dd2b2bde6252b3acf57d36dccfc743a Mon Sep 17 00:00:00 2001
>From: Luke Nelson <lukenels@cs.washington.edu>
>Date: Sat, 18 Apr 2020 16:26:53 -0700
>Subject: [PATCH] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX
> BPF_B
>
>This patch fixes an encoding bug in emit_stx for BPF_B when the source
>register is BPF_REG_FP.
>
>The current implementation for BPF_STX BPF_B in emit_stx saves one REX
>byte when the operands can be encoded using Mod-R/M alone. The lower 8
>bits of registers %rax, %rbx, %rcx, and %rdx can be accessed without using
>a REX prefix via %al, %bl, %cl, and %dl, respectively. Other registers,
>(e.g., %rsi, %rdi, %rbp, %rsp) require a REX prefix to use their 8-bit
>equivalents (%sil, %dil, %bpl, %spl).
>
>The current code checks if the source for BPF_STX BPF_B is BPF_REG_1
>or BPF_REG_2 (which map to %rdi and %rsi), in which case it emits the
>required REX prefix. However, it misses the case when the source is
>BPF_REG_FP (mapped to %rbp).
>
>The result is that BPF_STX BPF_B with BPF_REG_FP as the source operand
>will read from register %ch instead of the correct %bpl. This patch fixes
>the problem by fixing and refactoring the check on which registers need
>the extra REX byte. Since no BPF registers map to %rsp, there is no need
>to handle %spl.
>
>Fixes: 622582786c9e0 ("net: filter: x86: internal BPF JIT")
>Signed-off-by: Xi Wang <xi.wang@gmail.com>
>Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
>Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>Link: https://lore.kernel.org/bpf/20200418232655.23870-1-luke.r.nels@gmail.com

The code got shuffled around in 3b2744e66520 ("bpf: Refactor x86 JIT
into helpers"). I've fixed it and queued for all branches.

-- 
Thanks,
Sasha
