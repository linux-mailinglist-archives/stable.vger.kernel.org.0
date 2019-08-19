Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14979496E
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfHSQHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 12:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSQHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 12:07:14 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CFA720651;
        Mon, 19 Aug 2019 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566230833;
        bh=BYu7fxq6WXVpXxj5OxsggzC/htbiawtCWfU5LVDptKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CX4Rlum9Ej0PHE1YWOOarrxDYzXA+FtwqzBG6DcXOdpxeAtXOW8ZPp1x1dxsgJ4Dk
         Lr2L9R/6HJO7cGC/75TXOzALO84YXM7rxKKc3R7OdGQShQA9AbeV35CfqRrqpO5IJB
         uX+ws0/w/aG3oGYPj2nZqcVn+d7fHUALTirV5Krg=
Date:   Mon, 19 Aug 2019 12:07:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9 03/13] bpf: add bpf_jit_limit knob to restrict unpriv
 allocations
Message-ID: <20190819160712.GB15418@sasha-vm>
References: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
 <20190816230008.GG9843@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190816230008.GG9843@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 12:00:08AM +0100, Ben Hutchings wrote:
>From: Daniel Borkmann <daniel@iogearbox.net>
>
>commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3 upstream.
>
>Rick reported that the BPF JIT could potentially fill the entire module
>space with BPF programs from unprivileged users which would prevent later
>attempts to load normal kernel modules or privileged BPF programs, for
>example. If JIT was enabled but unsuccessful to generate the image, then
>before commit 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
>we would always fall back to the BPF interpreter. Nowadays in the case
>where the CONFIG_BPF_JIT_ALWAYS_ON could be set, then the load will abort
>with a failure since the BPF interpreter was compiled out.
>
>Add a global limit and enforce it for unprivileged users such that in case
>of BPF interpreter compiled out we fail once the limit has been reached
>or we fall back to BPF interpreter earlier w/o using module mem if latter
>was compiled in. In a next step, fair share among unprivileged users can
>be resolved in particular for the case where we would fail hard once limit
>is reached.
>
>Fixes: 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
>Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
>Co-Developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>Acked-by: Alexei Starovoitov <ast@kernel.org>
>Cc: Eric Dumazet <eric.dumazet@gmail.com>
>Cc: Jann Horn <jannh@google.com>
>Cc: Kees Cook <keescook@chromium.org>
>Cc: LKML <linux-kernel@vger.kernel.org>
>Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>[bwh: Backported to 4.9: adjust context]
>Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>

I've also queued up fdadd04931c2d ("bpf: fix bpf_jit_limit knob for
PAGE_SIZE >= 64K") on top.

--
Thanks,
Sasha
