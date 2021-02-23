Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBB9322765
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhBWJD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:03:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:53216 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhBWJDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 04:03:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614070935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5koVez20mNgf7BKjuFfJWAK0N/ZrPb1QkrYfLF638OI=;
        b=idECt/f50Pzp1dJg3qe1CDyJcsxiP34a4MxtFMt91nk8m1JoRj50h+t6DkF5xWuzQZ3Uo3
        wk9DmvgVLgDxH+Tl6wCFaGTo4Jn4fBHOp5zHZ7YWXlv8mhY9Dnk/qYwhIEvX5n1bDpHjIx
        /hDr/2CoCxxZCigEu6Fo+2QiSxyWXtk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83408AC6E;
        Tue, 23 Feb 2021 09:02:15 +0000 (UTC)
Date:   Tue, 23 Feb 2021 10:02:14 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     stable@vger.kernel.org
Cc:     John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "J. Avila" <elavila@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] printk: avoid prb_first_valid_seq() where possible
Message-ID: <YDTEls/iLBQEtTTn@alley>
References: <20210211173152.1629-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211173152.1629-1-john.ogness@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 2021-02-11 18:37:52, John Ogness wrote:
> If message sizes average larger than expected (more than 32
> characters), the data_ring will wrap before the desc_ring. Once the
> data_ring wraps, it will start invalidating descriptors. These
> invalid descriptors hang around until they are eventually recycled
> when the desc_ring wraps. Readers do not care about invalid
> descriptors, but they still need to iterate past them. If the
> average message size is much larger than 32 characters, then there
> will be many invalid descriptors preceding the valid descriptors.
> 
> The function prb_first_valid_seq() always begins at the oldest
> descriptor and searches for the first valid descriptor. This can
> be rather expensive for the above scenario. And, in fact, because
> of its heavy usage in /dev/kmsg, there have been reports of long
> delays and even RCU stalls.
> 
> For code that does not need to search from the oldest record,
> replace prb_first_valid_seq() usage with prb_read_valid_*()
> functions, which provide a start sequence number to search from.
> 
> Fixes: 896fbe20b4e2333fb55 ("printk: use the lockless ringbuffer")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Reported-by: J. Avila <elavila@google.com>
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Could you please push this fix into the stable releases
based on 5.10 and 5.11, please?

The patch fixes a visible performance regression. It has
landed in the mainline as the commit
13791c80b0cdf54d92fc542 ("printk: avoid prb_first_valid_seq() where
possible").

It should apply cleanly.

Best Regards,
Petr
