Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B320957A7F1
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 22:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiGSUFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 16:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbiGSUFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 16:05:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BD4E01B;
        Tue, 19 Jul 2022 13:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 383156193B;
        Tue, 19 Jul 2022 20:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EB1C341CA;
        Tue, 19 Jul 2022 20:05:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ev2ETShm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658261145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l0hL+PyFNeKSe4luq67gzyDU4wdDPnl5fCp/w8bGKzw=;
        b=ev2ETShmFfWGO1bN0x20sLsw+xSJW/wA6TBQRwPvkcYcSa2HjlB0mdp2TW57/9uefaG6ZV
        DwYZybPmyMRWiGAxMFoOKB6xbVj2Wt4tmfuTUcCxFYiiZLViCIxKqgEuZPXUStFYsOI64D
        S2M2HoVMvRGks+6ZDc9uRva5KK6lv/s=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bf8fd4ed (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 19 Jul 2022 20:05:44 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id l11so11969268qvu.13;
        Tue, 19 Jul 2022 13:05:43 -0700 (PDT)
X-Gm-Message-State: AJIora8LVBbC6bzQoq38uLNsOi2PkOdaNQhrdL/gxqCgLtiJ5JkLD2lc
        kdXIZFBY4QsMdAh61zZ9XbcgQnLBNoAA2xZwdVU=
X-Google-Smtp-Source: AGRyM1sSpH9B7LpwbHGXDEvI6e8loIojDattmivj6smIEhs9NE7jEwuOTR/QkXg6zeeE75GldXEe2LvSjEaI2AZc8i8=
X-Received: by 2002:a05:6214:29e7:b0:473:4433:1337 with SMTP id
 jv7-20020a05621429e700b0047344331337mr26493321qvb.76.1658261142861; Tue, 19
 Jul 2022 13:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <YtboFNL+YsHxTHrN@zx2c4.com> <20220719173354.232365-1-Jason@zx2c4.com>
 <878rooucp9.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <878rooucp9.fsf@email.froward.int.ebiederm.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 19 Jul 2022 22:05:31 +0200
X-Gmail-Original-Message-ID: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
Message-ID: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
Subject: Re: [PATCH v9] ath9k: let sleep be interrupted when unregistering hwrng
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>,
        stable <stable@vger.kernel.org>,
        Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On Tue, Jul 19, 2022 at 9:26 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
> > There are two deadlock scenarios that need addressing, which cause
> > problems when the computer goes to sleep, the interface is set down, and
> > hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
> > for tens of seconds, causing it to fail. These scenarios are:
> >
> > 1) The hwrng kthread can't be stopped while it's sleeping, because it
> >    uses msleep_interruptible() instead of schedule_timeout_interruptible().
> >    The fix is a simple moving to the correct function. At the same time,
> >    we should cleanup a common and useless dmesg splat in the same area.
> >
> > 2) A normal user thread can't be interrupted by hwrng_unregister() while
> >    it's sleeping, because hwrng_unregister() is called from elsewhere.
> >    The solution here is to keep track of which thread is currently
> >    reading, and asleep, and signal that thread when it's time to
> >    unregister. There's a bit of book keeping required to prevent
> >    lifetime issues on current.
>
> Is there any chance you can name the new function
> wake_up_task_interruptible instead of wake_up_process_interruptible.
>
> The name wake_up_process is wrong now, it does not wake up all threads
> of a process.  The name dates back to before linux supported multiple
> threads in a process, so it is grandfathered in until someone gets
> changes it.  But please let's not have a new function with a incorrect
> and confusing name.

No problem. v+1 incoming.

Jason
