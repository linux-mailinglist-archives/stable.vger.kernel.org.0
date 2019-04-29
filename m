Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD4F4E2D0
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfD2Mhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728194AbfD2Mhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 08:37:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 285A020675;
        Mon, 29 Apr 2019 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556541455;
        bh=zy5DcZvNpkhWunWftUFAmrPiMqUjkJ7lUUOa9JMgu4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gbys5Ltlb1UxTBfI9/YRs3SrKmCHG//qx1rZc1+v8deVihIGGz5GBcSHV1QR+XTJA
         +Ce54ArG4BF6YLoHNfhlBRLjNnD4JSae5qcCP6s8doMv+hB2uFvG1/MTF/7R8L69P0
         mybbWD5OrsXva53SxqGt0qfuaqDuEHHhyfdgBWKw=
Date:   Mon, 29 Apr 2019 14:37:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, daniel@iogearbox.net,
        ast@kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4.4.y] bpf: reject wrong sized filters earlier
Message-ID: <20190429123733.GA31371@kroah.com>
References: <20190424180018.15793-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424180018.15793-1-zsm@chromium.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 24, 2019 at 11:00:18AM -0700, Zubin Mithra wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> commit f7bd9e36ee4a4ce38e1cddd7effe6c0d9943285b upstream
> 
> Add a bpf_check_basics_ok() and reject filters that are of invalid
> size much earlier, so we don't do any useless work such as invoking
> bpf_prog_alloc(). Currently, rejection happens in bpf_check_classic()
> only, but it's really unnecessarily late and they should be rejected
> at earliest point. While at it, also clean up one bpf_prog_size() to
> make it consistent with the remaining invocations.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> Notes:
> * Syzkaller reported a kernel BUG related to a kernel paging request in
>   bpf_prog_create with the following stacktrace when fuzzing a 4.4 kernel.
> Call Trace:
>  [<ffffffff822ac1c8>] bpf_prog_create+0xc8/0x210 net/core/filter.c:1067
>  [<ffffffff82454699>] bpf_mt_check+0xb9/0x120 net/netfilter/xt_bpf.c:31
>  [<ffffffff82437db8>] xt_check_match+0x238/0x730 net/netfilter/x_tables.c:409
>  [<ffffffff82940254>] ebt_check_match net/bridge/netfilter/ebtables.c:380 [inline]
>  [<ffffffff82940254>] ebt_check_entry+0x844/0x1740 net/bridge/netfilter/ebtables.c:709
>  [<ffffffff82946842>] translate_table+0xcb2/0x1e80 net/bridge/netfilter/ebtables.c:946
>  [<ffffffff8294a918>] do_replace_finish+0x6e8/0x1fd0 net/bridge/netfilter/ebtables.c:1002
>  [<ffffffff8294c419>] do_replace+0x219/0x370 net/bridge/netfilter/ebtables.c:1145
>  [<ffffffff8294c649>] do_ebt_set_ctl+0xd9/0x110 net/bridge/netfilter/ebtables.c:1492
>  [<ffffffff8239a87c>] nf_sockopt net/netfilter/nf_sockopt.c:105 [inline]
>  [<ffffffff8239a87c>] nf_setsockopt+0x6c/0xc0 net/netfilter/nf_sockopt.c:114
>  [<ffffffff825ddeb6>] ip_setsockopt+0xa6/0xc0 net/ipv4/ip_sockglue.c:1226
>  [<ffffffff825fd3c7>] tcp_setsockopt+0x87/0xd0 net/ipv4/tcp.c:2701
>  [<ffffffff8220343a>] sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:2690
>  [<ffffffff822006ed>] SYSC_setsockopt net/socket.c:1767 [inline]
>  [<ffffffff822006ed>] SyS_setsockopt+0x15d/0x240 net/socket.c:1746
>  [<ffffffff82a16f9b>] entry_SYSCALL_64_fastpath+0x18/0x94
> 
> * This patch resolves the following conflicts when applying to v4.4.y:
> - __get_filter does not exist in v4.4. Instead the checks are moved into
>   __sk_attach_filter.
> 
> * This patch is present in v4.9.y.
> 
> * Tests run: Chrome OS tryjobs, Syzkaller reproducer

Now queued up, thanks.

greg k-h
