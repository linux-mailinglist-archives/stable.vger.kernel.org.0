Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDFC4759AF
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbhLONbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:31:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56352 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbhLONbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:31:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FC5B618C9
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E737C34605;
        Wed, 15 Dec 2021 13:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639575107;
        bh=KjUF9tOOQH59vmbaHHaUq4lz1wVSGMiZa/YgjKBdFhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fA0kAHymDAKWEIZ0CYctng2y/tnTJwa7HmT0ycPU9drwmDKcPWvxSlxwfRg2HVsLg
         HAxNiN5wsRESdv84k6AUDKuVfwrTbFoCskfJKfKmY7wTJrkb+vmBdrvqcIhqVUKM8C
         KVUMDnG9LAlF4F/t+h3SEOJN2NNfsPQe95jY0TTg=
Date:   Wed, 15 Dec 2021 14:31:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vijay Balakrishna <vijayb@linux.microsoft.com>
Cc:     stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH 5.4] selinux: fix race condition when computing ocontext
 SIDs
Message-ID: <YbnuQZWwnnDwF93G@kroah.com>
References: <1639468611-9753-1-git-send-email-vijayb@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639468611-9753-1-git-send-email-vijayb@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 11:56:51PM -0800, Vijay Balakrishna wrote:
> From: Ondrej Mosnacek <omosnace@redhat.com>
> 
> commit cbfcd13be5cb2a07868afe67520ed181956579a7 upstream.
> 
> Current code contains a lot of racy patterns when converting an
> ocontext's context structure to an SID. This is being done in a "lazy"
> fashion, such that the SID is looked up in the SID table only when it's
> first needed and then cached in the "sid" field of the ocontext
> structure. However, this is done without any locking or memory barriers
> and is thus unsafe.
> 
> Between commits 24ed7fdae669 ("selinux: use separate table for initial
> SID lookup") and 66f8e2f03c02 ("selinux: sidtab reverse lookup hash
> table"), this race condition lead to an actual observable bug, because a
> pointer to the shared sid field was passed directly to
> sidtab_context_to_sid(), which was using this location to also store an
> intermediate value, which could have been read by other threads and
> interpreted as an SID. In practice this caused e.g. new mounts to get a
> wrong (seemingly random) filesystem context, leading to strange denials.
> This bug has been spotted in the wild at least twice, see [1] and [2].
> 
> Fix the race condition by making all the racy functions use a common
> helper that ensures the ocontext::sid accesses are made safely using the
> appropriate SMP constructs.
> 
> Note that security_netif_sid() was populating the sid field of both
> contexts stored in the ocontext, but only the first one was actually
> used. The SELinux wiki's documentation on the "netifcon" policy
> statement [3] suggests that using only the first context is intentional.
> I kept only the handling of the first context here, as there is really
> no point in doing the SID lookup for the unused one.
> 
> I wasn't able to reproduce the bug mentioned above on any kernel that
> includes commit 66f8e2f03c02, even though it has been reported that the
> issue occurs with that commit, too, just less frequently. Thus, I wasn't
> able to verify that this patch fixes the issue, but it makes sense to
> avoid the race condition regardless.
> 
> [1] https://github.com/containers/container-selinux/issues/89
> [2] https://lists.fedoraproject.org/archives/list/selinux@lists.fedoraproject.org/thread/6DMTAMHIOAOEMUAVTULJD45JZU7IBAFM/
> [3] https://selinuxproject.org/page/NetworkStatements#netifcon
> 
> Cc: stable@vger.kernel.org
> Cc: Xinjie Zheng <xinjie@google.com>
> Reported-by: Sujithra Periasamy <sujithra@google.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> (cherry picked from commit cbfcd13be5cb2a07868afe67520ed181956579a7)
> [vijayb: Backport contextual differences are due to v5.10 RCU related
>  changes are not in 5.4]
> Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
> ---
> 
> We have kernel crashes with stack traces related to selinux security
> context to sid in 5.4 --
> https://lore.kernel.org/all/af058f59-ce8a-7648-25e8-f8b8a2dbb0ba@linux.microsoft.com/#t
> Unfortunately we don't have a on-demand repro.  We are hoping this
> patch would help in addressing a possible race in 5.4.

Now queued up.

greg k-h
