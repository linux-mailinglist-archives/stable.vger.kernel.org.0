Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E12F89D5A
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 13:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfHLLw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 07:52:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34928 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbfHLLw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 07:52:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so11508814wmg.0
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 04:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JQc8MsYNi4B/FOCBvJsS2RlJj0CEn21Q6IfYpjwCByI=;
        b=cQbuABGzre6z66mKEgHBD96wCUZXMJC4mpPHT0efXWmmjm9LFEbu8bCipYfzUQi0SI
         ZSRWEHmHyx2h+IXRZuJ9vBM/yt9QBDMhgL00fYPO11GrJ7Xkufs/GaVL/Vkykqz2PBQv
         0AXOp7Q0qbjD8nar9v7vS0Pc1OGwrS8JPsOb6O0ETj086uVIJ2vn6abQBmF8MTdaud4G
         bQ8kGU1+/VI25AXVwFAe2LUenrmbU9/6iYJRKU0ExsG298YaWKU5k91+lDv3RlRSiFgl
         l2qvee23tylBqhyv+VRsN3TU7GXwy4G8M0+a+X6nfbvXUKW2WLwPqkNHg96FNjdtOjQ8
         UTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQc8MsYNi4B/FOCBvJsS2RlJj0CEn21Q6IfYpjwCByI=;
        b=pYDLHGZ8Vwgfcwdwkr0LLJnJ6nfTE9AzFPGaDvSyateSVvKx4cf99aL/gZQ6x8F3LX
         GYctn4vWx3i8Z2kJAVt5CZuQCqoNinG/YVl5L473NpeSazQYCk8/BDPML4K9BiYSMDAh
         SD5tjdUWPUxbcBretHDszv69bJaKq4F43AmAy4Ri/0Kjc7ihRy9raq1wSes34wznh+7/
         UnYE6kYGRQ9u70my1oyTANKsgYpJsTYMzsMw4R8ooemp5TutOwkbFF0ukuF/IjmwrFbC
         GEtKVbQXUGrgOd1gzS+R/3DY3AzENjyiIVM3Qih6d8IEtmEBSolffecxTEL2NPmx6/qR
         MweA==
X-Gm-Message-State: APjAAAVOwK3TfBjA6MSEQ2x6ZlTVxqqqX0RXc8/SPw7nl7egjeXTZlaK
        j5bR5dyCce89ZVIsNQttEfZO1cyA0ddLkw==
X-Google-Smtp-Source: APXvYqwWWWi+XtR+N8wWk9JxW+7GVf46hQYfqdReJTujMWv4l41Mno0JVhc/WRt2g3J2tVVJ/i9WYA==
X-Received: by 2002:a7b:c04f:: with SMTP id u15mr27138326wmc.106.1565610776729;
        Mon, 12 Aug 2019 04:52:56 -0700 (PDT)
Received: from fat-tyre.localnet ([2001:858:107:1:7139:36a7:c14f:e911])
        by smtp.gmail.com with ESMTPSA id f17sm8185963wmj.27.2019.08.12.04.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2019 04:52:55 -0700 (PDT)
From:   Philipp Reisner <philipp.reisner@linbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     David Laight <David.Laight@aculab.com>,
        'Christoph =?ISO-8859-1?Q?B=F6hmwalder=27?= 
        <christoph.boehmwalder@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] drbd: do not ignore signals in threads
Date:   Mon, 12 Aug 2019 13:52:52 +0200
Message-ID: <1761552.9xIroHqhk7@fat-tyre>
In-Reply-To: <6f8c0d1e51c242a288fbf9b32240e4c1@AcuMS.aculab.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com> <ad16d006-4382-3f77-8968-6f840e58b8df@linbit.com> <6f8c0d1e51c242a288fbf9b32240e4c1@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

Please have a look.

With fee109901f392 Eric W. Biederman changed drbd to use send_sig()=20
instead of force_sig(). That was part of a series that did this change
in multiple call sites tree wide. Which, by accident broke drbd, since=20
the signals are _not_ allowed by default. That got released with v5.2.

On July 29 Christoph 	B=F6hmwalder sent a patch that adds two=20
allow_signal()s to fix drbd.

Then David Laight points out that he has code that can not deal
with the send_sig() instead of force_sig() because allowed signals
can be sent from user-space as well.
I assume that David is referring to out of tree code, so I fear it
is up to him to fix that to work with upstream, or initiate a=20
revert of Eric's change.

Jens, please consider sending Christoph's path to Linus for merge in=20
this cycle, or let us know how you think we should proceed.

best regards,
 Phil

Am Montag, 5. August 2019, 11:41:06 CEST schrieb David Laight:
> From: Christoph B=F6hmwalder
>=20
> > Sent: 05 August 2019 10:33
> >=20
> > On 29.07.19 10:50, David Laight wrote:
> >=20
> > > Doesn't unmasking the signals and using send_sig() instead  of
> > > force_sig()
> > > have the (probably unwanted) side effect of allowing userspace to send
> > > the signal?
> >=20
> >=20
> > I have ran some tests, and it does look like it is now possible to send
> > signals to the DRBD kthread from userspace. However, ...
> >=20
> >=20
> > > I've certainly got some driver code that uses force_sig() on a kthread
> > > that it doesn't (ever) want userspace to signal.
> >=20
> >=20
> > ... we don't feel that it is absolutely necessary for userspace to be
> > unable to send a signal to our kthreads. This is because the DRBD thread
> > independently checks its own state, and (for example) only exits as a
> > result of a signal if its thread state was already "EXITING" to begin
> > with.
>=20
>=20
> In must 'clear' the signal - otherwise it won't block again.
>=20
> I've also got this horrid code fragment:
>=20
>     init_waitqueue_entry(&w, current);
>=20
>     /* Tell scheduler we are going to sleep... */
>     if (signal_pending(current) && !interruptible)
>         /* We don't want waking immediately (again) */
>         sleep_state =3D TASK_UNINTERRUPTIBLE;
>     else
>         sleep_state =3D TASK_INTERRUPTIBLE;
>     set_current_state(sleep_state);
>=20
>     /* Connect to condition variable ... */
>     add_wait_queue(cvp, &w);
>     mutex_unlock(mtxp); /* Release mutex */
>=20
> where we want to sleep TASK_UNINTERRUPTIBLE but that f*cks up the 'load
> average',
 so sleep TASK_INTERRUPTIBLE unless there is a signal pending
> that we want to ignore.
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1
> 1PT, UK
 Registration No: 1397386 (Wales)


=2D-=20
LINBIT | Keeping The Digital World Running

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT, Austria.



