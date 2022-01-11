Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6899048B997
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 22:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiAKV1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 16:27:12 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54946 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiAKV1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 16:27:12 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 09DFB1F385;
        Tue, 11 Jan 2022 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641936431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jd14sYm+G5V8tcpmUQUHGWfD7jSoNBYlBfxBDcoFxAA=;
        b=Vz0mw3ZER3HWd+8ipxD02cMlE8Ti+u5ha52syuVBj51kEt7TTYxYuLHfpXnhmET+6Z+kyw
        ynhdfLaUtrSjtnn4C2Ibps0qxJqMFSe3jS1w1PPoJT0Qud+KiUXu5a36FetFLwf7dksv1J
        wRK26FnL1PKKPQDMapR32CyxG7bpSYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641936431;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jd14sYm+G5V8tcpmUQUHGWfD7jSoNBYlBfxBDcoFxAA=;
        b=iwCbmLsumRRDvvWvyFZqdi8BvCun7Nzy7a1gUGLZaJHbhTkAmqkJOJ1jEwUmoWXD+9veqt
        l3XGPgp4ujog9QAw==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D932BA3B83;
        Tue, 11 Jan 2022 21:27:10 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 86717A059C; Tue, 11 Jan 2022 22:27:10 +0100 (CET)
Date:   Tue, 11 Jan 2022 22:27:10 +0100
From:   Jan Kara <jack@suse.cz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] select: Fix indefinitely sleeping task in
 poll_schedule_timeout()
Message-ID: <20220111212710.5atbl7zmg7w72a3h@quack3.lan>
References: <20220110181923.5340-1-jack@suse.cz>
 <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 11-01-22 09:12:08, Linus Torvalds wrote:
> On Mon, Jan 10, 2022 at 10:19 AM Jan Kara <jack@suse.cz> wrote:
> >
> > A task can end up indefinitely sleeping in do_select() ->
> > poll_schedule_timeout() when the following race happens:
> > {...]
> 
> Ok, I decided to just take this as-is right now, and get it in early
> in the merge window, and see if anybody hollers.
> 
> I don't think the stable people will try to apply it until after the
> merge window closes anyway, but it's worth pointing out that this
> change (commit 68514dacf271: "select: Fix indefinitely sleeping task
> in poll_schedule_timeout()" in my tree now) is very much a change of
> behavior, and we may have to revert it if it causes any issues.
> 
> The most likely issue it would cause is that some program uses
> select() with an fd mask with extra garbage in it, and stale fd bits
> that pointed to closed file descriptors used to just be ignored. Now
> they'll cause select() to return immediately with those bits set.

That's not quite true. max_select_fd() called from do_select() will bail
with -EBADF if any set contains a bit that is not in
current->files->open_fds. So what you describe will already end with -EBADF
from select(2) regardless of my patch. But yes, if fd becomes invalid while
select(2) is already running, then the patch changes behavior. OTOH
applications messing with file table from another thread while select is
running should be much rarer.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
