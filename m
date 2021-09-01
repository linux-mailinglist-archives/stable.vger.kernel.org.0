Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F8E3FD70E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243603AbhIAJoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243543AbhIAJoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414E66103A;
        Wed,  1 Sep 2021 09:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630489387;
        bh=9MmuTmdXThqhgMuQWPHxDHl+RzvbgrfYtnbUnuLWQ5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zeU7LxygOE4+fA0WbL9zUOMBAvTK2xG4XN3pxmACJLHkifvXkYRiHzQqWk1wW7KJU
         DUr/xoFhT83YcQ5w1BG3qyGzAp03/sFHkn40538aoclDleGpM0/nfiCkYM5SLEGrxM
         jLu4etdE7YMV7B9FryCTCd5y1WV349OST+u5PkMw=
Date:   Wed, 1 Sep 2021 11:43:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 4.14 0/4] BPF fixes for CVE-2021-3444 and CVE-2021-3600
Message-ID: <YS9LKXbcud7he1X5@kroah.com>
References: <20210830183211.339054-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830183211.339054-1-cascardo@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 03:32:07PM -0300, Thadeu Lima de Souza Cascardo wrote:
> The upstream changes necessary to fix these CVEs rely on the presence of JMP32,
> which is not a small backport and brings its own potential set of necessary
> follow-ups.
> 
> Daniel Borkmann, John Fastabend and Alexei Starovoitov came up with a fix
> involving the use of the AX register.
> 
> This has been tested against the test_verifier in 4.14.y tree and some tests
> specific to the two referred CVEs. The test_bpf module was also tested.
> 
> Daniel Borkmann (4):
>   bpf: Do not use ax register in interpreter on div/mod
>   bpf: fix subprog verifier bypass by div/mod by 0 exception
>   bpf: Fix 32 bit src register truncation on div/mod
>   bpf: Fix truncation handling for mod32 dst reg wrt zero
> 
>  include/linux/filter.h | 24 ++++++++++++++++++++++++
>  kernel/bpf/core.c      | 40 +++++++++++++++-------------------------
>  kernel/bpf/verifier.c  | 39 +++++++++++++++++++++++++++++++--------
>  net/core/filter.c      |  9 ++++++++-
>  4 files changed, 78 insertions(+), 34 deletions(-)
> 
> -- 
> 2.30.2
> 

All now queued up, thanks.

greg k-h
