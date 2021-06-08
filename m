Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFCD39F95D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhFHOmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233443AbhFHOms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 10:42:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D6E46100B;
        Tue,  8 Jun 2021 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623163246;
        bh=RaorXEEojtajaLPoe5vmTvN9O0fajFU0dyO1RqzIaT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sAsAnM03+qsDwG5NFGip6Gwl7Y2IJ9hRQ1JxYOz7C6PutmylJyZf0kI9R5m3dDc2R
         cX1v9JOPxtO53Zm7lI8rdFh5D+A+Wvhh6UeZS3ztIoyHONeYCFe14BgBS9kBrVXxeu
         vT7gTYYJS7gQOHFqJr0mChrZytOQ+Q0PUsAwEMlM=
Date:   Tue, 8 Jun 2021 16:40:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 4.19 0/9] bpf: fix verifier selftests on inefficient
 unaligned access architectures
Message-ID: <YL+BbHMdl8Fv5e+F@kroah.com>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
 <70c92574-ab22-1a04-067e-4c933ef75a9a@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70c92574-ab22-1a04-067e-4c933ef75a9a@loongson.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 05, 2021 at 03:16:44PM +0800, Tiezhu Yang wrote:
> On 06/02/2021 11:27 AM, Tiezhu Yang wrote:
> > With the following patch series, all verifier selftests pass on the archs which
> > select HAVE_EFFICIENT_UNALIGNED_ACCESS.
> > 
> > [v2,4.19,00/19] bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210528103810.22025-1-ovidiu.panait@windriver.com/
> > 
> > But on inefficient unaligned access architectures, there still exist many failures,
> > so some patches about F_NEEDS_EFFICIENT_UNALIGNED_ACCESS are also needed, backport
> > to 4.19 with a minor context difference.
> > 
> > This patch series is based on the series (all now queued up by greg k-h):
> > "bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes".
> > 
> > Björn Töpel (2):
> >    selftests/bpf: add "any alignment" annotation for some tests
> >    selftests/bpf: Avoid running unprivileged tests with alignment
> >      requirements
> > 
> > Daniel Borkmann (2):
> >    bpf: fix test suite to enable all unpriv program types
> >    bpf: test make sure to run unpriv test cases in test_verifier
> > 
> > David S. Miller (4):
> >    bpf: Add BPF_F_ANY_ALIGNMENT.
> >    bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in
> >      test_verifier.c
> >    bpf: Make more use of 'any' alignment in test_verifier.c
> >    bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test
> >      cases.
> > 
> > Joe Stringer (1):
> >    selftests/bpf: Generalize dummy program types
> > 
> >   include/uapi/linux/bpf.h                    |  14 ++
> >   kernel/bpf/syscall.c                        |   7 +-
> >   kernel/bpf/verifier.c                       |   3 +
> >   tools/include/uapi/linux/bpf.h              |  14 ++
> >   tools/lib/bpf/bpf.c                         |   8 +-
> >   tools/lib/bpf/bpf.h                         |   2 +-
> >   tools/testing/selftests/bpf/test_align.c    |   4 +-
> >   tools/testing/selftests/bpf/test_verifier.c | 224 ++++++++++++++++++++--------
> >   8 files changed, 206 insertions(+), 70 deletions(-)
> > 
> 
> Hi Greg and Sasha,
> 
> Could you please apply this series to 4.19?

Please relax and give us longer than just 2 days to respond :)

I'll go review this now...

greg k-h
