Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3D4A8A8F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbiBCRrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiBCRrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:47:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9FC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 09:47:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95522617AD
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 17:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDB4C340E8;
        Thu,  3 Feb 2022 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643910420;
        bh=ZqkOb4Ka3HkX4KSmisRDBUcDLUs2E5UhTCrmDdt7bWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gI5yazzhFXmyJN/J/J9EY6i9Otw9HgAB6fidffi8nk2jUwRBWwAmkjpScen66SbCz
         wmYzTTqUZFf7ghOEKBElbiSywO/TOJnzTH325xFqrUfdmD1v2bvw7ONGoPD7vgbQzn
         GFcnI6ueD2jEcRjtVCMt6RJoXMHQJQH6IF52l1lY=
Date:   Thu, 3 Feb 2022 18:46:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     ebiggers@google.com, ebiggers@kernel.org, hannes@cmpxchg.org,
        peterz@infradead.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Subject: Re: [PATCH for-v5.10.x 1/1] psi: Fix uaf issue when psi trigger is
 destroyed while being polled
Message-ID: <YfwVEJlmXJlkTWib@kroah.com>
References: <20220201030616.2778754-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201030616.2778754-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 07:06:16PM -0800, Suren Baghdasaryan wrote:
> commit a06247c6804f1a7c86a2e5398a4c1f1db1471848 upstream.
> 
> With write operation on psi files replacing old trigger with a new one,
> the lifetime of its waitqueue is totally arbitrary. Overwriting an
> existing trigger causes its waitqueue to be freed and pending poll()
> will stumble on trigger->event_wait which was destroyed.
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.
> Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> flag can be flipped after the trigger is created, leading to a memory
> leak.
> 
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220111232309.1786347-1-surenb@google.com
> [surenb: backported to 5.10 kernel]
> CC: stable@vger.kernel.org # 5.10
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  Documentation/accounting/psi.rst |  3 +-
>  include/linux/psi.h              |  2 +-
>  include/linux/psi_types.h        |  3 --
>  kernel/cgroup/cgroup.c           | 11 ++++--
>  kernel/sched/psi.c               | 66 ++++++++++++++------------------
>  5 files changed, 40 insertions(+), 45 deletions(-)

Both backports now queued up, thanks.

greg k-h
