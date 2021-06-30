Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303353B7F75
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 10:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhF3JAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:00:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36422 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhF3JAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 05:00:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9C6CF2258E;
        Wed, 30 Jun 2021 08:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625043466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k3LWsPEMkW74ELhpcy2lCJwxaP1hRY80ZI874/hdG3s=;
        b=b6dzuYNSBuTBl8Fvo8LI6O114tlulXQNfK/zd0cjKpOQXI05NtPi/w30/4i/G299bFMMge
        nh4nI/axYpkBWRkJ7FRt8rz1nAzG5xBCX0LBSn1NWusnnOo2cul+tPC2kNs2mToBgE0KIh
        MTvycDtAZ5WJrQknFni7xWGqjwT0gZM=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4B2E9A3B8A;
        Wed, 30 Jun 2021 08:57:46 +0000 (UTC)
Date:   Wed, 30 Jun 2021 10:57:46 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] printk/console: Check consistent sequence number when
 handling race in console_unlock()
Message-ID: <YNwyCqtpcFVlK+FP@alley>
References: <20210629143341.19284-1-pmladek@suse.com>
 <202106300338.57cbEezZ-lkp@intel.com>
 <87zgv8bdei.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgv8bdei.fsf@jogness.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2021-06-29 22:59:57, John Ogness wrote:
> On 2021-06-30, kernel test robot <lkp@intel.com> wrote:
> >>> kernel/printk/printk.c:2548:6: warning: variable 'next_seq' set but not used [-Wunused-but-set-variable]
> 
> I suppose the correct fix for this warning would be to change the NOP
> macros. Currently they are:
> 
> #define prb_read_valid(rb, seq, r)      false
> #define prb_first_valid_seq(rb)         0
> 
> They should probably be something like (untested):
> 
> #define prb_read_valid(rb, seq, r)     \
> ({                                     \
>         (void)(rb);                    \
>         (void)(seq);                   \
>         (void)(r);                     \
>         false;                         \
> })

This did not work:

kernel/printk/printk.c: In function ‘console_unlock’:
kernel/printk/printk.c:2600:23: error: ‘prb’ undeclared (first use in this function)
   if (!prb_read_valid(prb, console_seq, &r))
                       ^
kernel/printk/printk.c:2230:16: note: in definition of macro ‘prb_read_valid’
         (void)(rb);                    \
                ^~
kernel/printk/printk.c:2600:23: note: each undeclared identifier is reported only once for each function it appears in
   if (!prb_read_valid(prb, console_seq, &r))
                       ^
kernel/printk/printk.c:2230:16: note: in definition of macro ‘prb_read_valid’
         (void)(rb);                    \
                ^~


Instead, it might be solved by declaring next_seq as:

	u64 __maybe_unused next_seq;

Any better idea is welcome. Well, it is not worth any big complexity.

Best Regards,
Petr
