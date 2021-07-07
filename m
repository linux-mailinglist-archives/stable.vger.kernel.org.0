Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8BA3BE7CE
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhGGM3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:29:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56384 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhGGM3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 08:29:05 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5A9A72006D;
        Wed,  7 Jul 2021 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625660763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jgnqj0+8UKRsZtDlmcBjPUy3F7SUpZUYosx9GjEV1bU=;
        b=beFId9vaUhdgR3xaTcGy4Qvdne1c6T/HzU2WBn08AIzvgKLMG2hwQ81lGHW8LyX23gVJGs
        dUj4ggAwZkn0ko7GRu8ETc+J5lvKKmtxtg7rimsNZE+tZ4K7rG5es71k/8zvnzynigULCv
        7AmoCDb2s2yBCuSUOo5A49tlHCmE1nQ=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id D45C025CCD;
        Wed,  7 Jul 2021 12:26:02 +0000 (UTC)
Date:   Wed, 7 Jul 2021 14:26:02 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] printk/console: Check consistent sequence number when
 handling race in console_unlock()
Message-ID: <YOWdWs8foEWKbgXy@alley>
References: <20210702150657.26760-1-pmladek@suse.com>
 <87y2an7w1x.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2an7w1x.fsf@jogness.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 2021-07-03 08:32:02, John Ogness wrote:
> On 2021-07-02, Petr Mladek <pmladek@suse.com> wrote:
> > The standard printk() tries to flush the message to the console
> > immediately. It tries to take the console lock. If the lock is
> > already taken then the current owner is responsible for flushing
> > even the new message.
> >
> > There is a small race window between checking whether a new message is
> > available and releasing the console lock. It is solved by re-checking
> > the state after releasing the console lock. If the check is positive
> > then console_unlock() tries to take the lock again and process the new
> > message as well.
> >
> > The commit 996e966640ddea7b535c ("printk: remove logbuf_lock") causes that
> > console_seq is not longer read atomically. As a result, the re-check might
> > be done with an inconsistent 64-bit index.
> >
> > Solve it by using the last sequence number that has been checked under
> > the console lock. In the worst case, it will take the lock again only
> > to realized that the new message has already been proceed. But it
> > was possible even before.
> >
> > The variable next_seq is marked as __maybe_unused to call down compiler
> > warning when CONFIG_PRINTK is not defined.
> 
> As Sergey already pointed out, this patch is not fixing a real
> problem. An inconsistent value (or an increased consistent value) would
> mean that another printer is actively printing, and thus a retry is not
> necessary anyway.

Ah, I misunderstood that part. You are right. CPU_X might see wrong
console_seq only when CPU_Y incremented console_seq. If CPU_X does not do
retry because of racy console_seq. Then CPU_Y would do retry when
yet another CPU added yet another new message in the meantime.

> But this patch will avoid a KASAN message about an unmarked
> (although safe) data race.

Yup.

OK, I am going to queue the patch for-5.15. There is no need to
rush it for-4.14.

Best Regards,
Petr
