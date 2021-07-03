Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7546F3BA788
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 08:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhGCG2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 02:28:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50148 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhGCG2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 02:28:38 -0400
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625293563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E1w9z+m05U11bCJWPaqIpRI46cJ8XT+ChnLkjheQPUg=;
        b=ZxkhxCaF3SrbJ4mstujFbBh7N0TJiejcfiXENfVhW8zhIvcL48GtXmbFYv7N0NDWD7xu7Y
        /fJiKKg4rgJhQP/6ldJUrvLuw47pKTAHSr/wfSMMIwXIr7DZzOAe/SPef/Mgf9m1HgwSFm
        0GCZiKiXpkqP0XMSHbnHmngC0QyBYGWQPN4Q5xzXhKPN3GcDe0rfTYGcZ1oQVDe2/A2l3W
        XRzIgqr9UqRB5K3I09Sm9V0SnFNCIkEJKLcAogDSb7ci9jUckh0onAu5YyE1+EP4RzhwBr
        9iROrZt494fIdj6PvCibyZi1fNDXyd1gkmP3+JcXtE8f5lbupUvJvWn3UhkMTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625293563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E1w9z+m05U11bCJWPaqIpRI46cJ8XT+ChnLkjheQPUg=;
        b=9TJROphteBASQXzW0cB+SANWL9D7t6yAJzrHdHHUwX2vKH9QuMmIG4ygUL34cbbO1N193d
        SRteFoUBtyiKuuDw==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] printk/console: Check consistent sequence number when handling race in console_unlock()
In-Reply-To: <20210702150657.26760-1-pmladek@suse.com>
References: <20210702150657.26760-1-pmladek@suse.com>
Date:   Sat, 03 Jul 2021 08:32:02 +0206
Message-ID: <87y2an7w1x.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-02, Petr Mladek <pmladek@suse.com> wrote:
> The standard printk() tries to flush the message to the console
> immediately. It tries to take the console lock. If the lock is
> already taken then the current owner is responsible for flushing
> even the new message.
>
> There is a small race window between checking whether a new message is
> available and releasing the console lock. It is solved by re-checking
> the state after releasing the console lock. If the check is positive
> then console_unlock() tries to take the lock again and process the new
> message as well.
>
> The commit 996e966640ddea7b535c ("printk: remove logbuf_lock") causes that
> console_seq is not longer read atomically. As a result, the re-check might
> be done with an inconsistent 64-bit index.
>
> Solve it by using the last sequence number that has been checked under
> the console lock. In the worst case, it will take the lock again only
> to realized that the new message has already been proceed. But it
> was possible even before.
>
> The variable next_seq is marked as __maybe_unused to call down compiler
> warning when CONFIG_PRINTK is not defined.

As Sergey already pointed out, this patch is not fixing a real
problem. An inconsistent value (or an increased consistent value) would
mean that another printer is actively printing, and thus a retry is not
necessary anyway. But this patch will avoid a KASAN message about an
unmarked (although safe) data race.

> Fixes: commit 996e966640ddea7b535c ("printk: remove logbuf_lock")
> Reported-by: kernel test robot <lkp@intel.com>  # unused next_seq warning
> Cc: stable@vger.kernel.org # 5.13
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: John Ogness <john.ogness@linutronix.de>
