Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04E03B798E
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 22:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhF2U43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 16:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhF2U42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 16:56:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C008DC061760;
        Tue, 29 Jun 2021 13:54:00 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625000038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GqlxU8XySJCXFH9gDOPH/tYpiIieaer1dHtr2ONK5dE=;
        b=qWCkhIU/ju0ofl5v0gJPFpVjdWh0ed849JnFxGcNxjBTceXbHt7E9rEaVrjqm+rqSDABj9
        W7iEj8PS8HTWAdi1VGmt+abqjjT6WB738OttiqV2AkwzT7xtPhEq5kORTW7iSf/uy0pMCD
        tutm8g1HPP3B5EVAt+S93XX2fEmJZPcCUBfPztqgr4OvwDKZoZ0gpubaZlHqiMpI0MfAEV
        +QavJTcEtCUyY3TRDvo0/EGKRkdCw5qB9l1NdzYK0u3fcaM+UapMYlylTs1F9B2M5DHme4
        89GH7VSEA6zWMTwnIdcwoHVorno9iaQ+mLqb+5L3sigv8/R9t9As1+YeInngRA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625000038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GqlxU8XySJCXFH9gDOPH/tYpiIieaer1dHtr2ONK5dE=;
        b=hX14aWLjX9ql4+EAl2VLGZf5u/WazoiVF2l7OeAYKiOmuD6pw4P18WPcePWYnLC0u4+Db8
        p2ZO3y903eZNSuCw==
To:     kernel test robot <lkp@intel.com>, Petr Mladek <pmladek@suse.com>
Cc:     kbuild-all@lists.01.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] printk/console: Check consistent sequence number when handling race in console_unlock()
In-Reply-To: <202106300338.57cbEezZ-lkp@intel.com>
References: <20210629143341.19284-1-pmladek@suse.com> <202106300338.57cbEezZ-lkp@intel.com>
Date:   Tue, 29 Jun 2021 22:59:57 +0206
Message-ID: <87zgv8bdei.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-06-30, kernel test robot <lkp@intel.com> wrote:
>>> kernel/printk/printk.c:2548:6: warning: variable 'next_seq' set but not used [-Wunused-but-set-variable]

I suppose the correct fix for this warning would be to change the NOP
macros. Currently they are:

#define prb_read_valid(rb, seq, r)      false
#define prb_first_valid_seq(rb)         0

They should probably be something like (untested):

#define prb_read_valid(rb, seq, r)     \
({                                     \
        (void)(rb);                    \
        (void)(seq);                   \
        (void)(r);                     \
        false;                         \
})

#define prb_first_valid_seq(rb)        \
({                                     \
        (void)(rb);                    \
        0;                             \
})

John Ogness
