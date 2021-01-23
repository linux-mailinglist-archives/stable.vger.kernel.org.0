Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00C130161B
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbhAWO6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbhAWO57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 09:57:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F095722AAA;
        Sat, 23 Jan 2021 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611413838;
        bh=mJ8Vk7OPDZudag1atvRjpfC0hiXiUkqHVgV0cu7w/68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rJk6k5hZY7Mw5I1Qm8FNA33WQfONgqWi/a5fYFTxYzCUcjcV+sJyNfExbxzv7v2GQ
         8sbSDWw1kH7+kRjsSh8EcRdO5iBBXzTzWeLJ/olkFS+oeWim//q/iAjMxdtOK9oLxy
         D+zEGOEUd2031JuCweuqM5/MkBR2rkXmLvI9MfzE=
Date:   Sat, 23 Jan 2021 15:57:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 5.4 29/33] net, sctp, filter: remap copy_from_user
 failure error
Message-ID: <YAw5S2rysk/PnwRS@kroah.com>
References: <20210122135733.565501039@linuxfoundation.org>
 <20210122135734.750091426@linuxfoundation.org>
 <20210122165545.GJ3863@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122165545.GJ3863@horizon.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 01:55:45PM -0300, Marcelo Ricardo Leitner wrote:
> On Fri, Jan 22, 2021 at 03:12:45PM +0100, Greg Kroah-Hartman wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> > 
> > [ no upstream commit ]
> > 
> > Fix a potential kernel address leakage for the prerequisite where there is
> > a BPF program attached to the cgroup/setsockopt hook. The latter can only
> > be attached under root, however, if the attached program returns 1 to then
> > run the related kernel handler, an unprivileged program could probe for
> > kernel addresses that way. The reason this is possible is that we're under
> > set_fs(KERNEL_DS) when running the kernel setsockopt handler. Aside from
> > old cBPF there is also SCTP's struct sctp_getaddrs_old which contains
> > pointers in the uapi struct that further need copy_from_user() inside the
> > handler. In the normal case this would just return -EFAULT, but under a
> > temporary KERNEL_DS setting the memory would be copied and we'd end up at
> > a different error code, that is, -EINVAL, for both cases given subsequent
> > validations fail, which then allows the app to distinguish and make use of
> > this fact for probing the address space. In case of later kernel versions
> > this issue won't work anymore thanks to Christoph Hellwig's work that got
> > rid of the various temporary set_fs() address space overrides altogether.
> > One potential option for 5.4 as the only affected stable kernel with the
> > least complexity would be to remap those affected -EFAULT copy_from_user()
> > error codes with -EINVAL such that they cannot be probed anymore. Risk of
> > breakage should be rather low for this particular error case.
> > 
> > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > Reported-by: Ryota Shiga (Flatt Security)
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Stanislav Fomichev <sdf@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> For sctp bits,
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks for the review!
