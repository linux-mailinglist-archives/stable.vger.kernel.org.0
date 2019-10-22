Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EEDDFBB1
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 04:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfJVCh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 22:37:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34725 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVCh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 22:37:28 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so18564970ion.1;
        Mon, 21 Oct 2019 19:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wD3owoO7Hcsn6F+M0fWwB4WG/OmBuK67PCnu7DWOZmU=;
        b=lMJVRkWFpSmzFUcvFuoEepZWNFPBmatWCsHa1UBAE+glA7VTw3xHUkKkMOLlJr39Ef
         SKqPSo1rr/MEjM6sJtbFTmyEQ9WoL5y8w+aLwTIQQ03G8MLS9B33qDNWSf8TUrt2pmcv
         Aa3z6/GGjoqSsCdA6qPk6M+EMDfcPy6LgthThrEB6BzQomAS9X+c07eX5/KVTQMocDb9
         9xnC2siL4OkvZXXd1Tgj8tRL/AxiNOrULtaWTNenftB0cLy0GQpt6cEGHb6zC2mdAJ0R
         JiXlsutJpPl01KFQgZ+ITc+q2/jHlBB0CIQVRO1dZ+49dCThBPMLMN62VJIGkySANNkY
         Epyg==
X-Gm-Message-State: APjAAAVdJaDUVelkj7TwH+dK5ioUC6p9aVOcYCFymrDDRLFBuEZXiAlu
        1/QxdZWLHQbd254m62I/Tk72arU0rrkvhWEQokA=
X-Google-Smtp-Source: APXvYqzXfIsGMFvjAZ7AUYcylJqFT1rB9WKhtgf2N4eZKTgy1KjKCQwtphZt8HrV8RX4H8uLZpnd8bOs4Pcvj+d0Zv0=
X-Received: by 2002:a02:cc4e:: with SMTP id i14mr1545623jaq.32.1571711847683;
 Mon, 21 Oct 2019 19:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <1571662320-1280-1-git-send-email-chenhc@lemote.com>
 <alpine.DEB.2.21.1910211648200.1904@nanos.tec.linutronix.de> <alpine.DEB.2.21.1910211658040.1904@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1910211658040.1904@nanos.tec.linutronix.de>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Tue, 22 Oct 2019 10:42:55 +0800
Message-ID: <CAAhV-H4PEcCgOBL8ksjc+4LC9VPoCRBMtuGEK6ckmdJYXjdcSg@mail.gmail.com>
Subject: Re: [PATCH 110/110] lib/vdso: Improve do_hres() and update vdso data unconditionally
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Thomas,

If we use (s64)cycles < 0, then how to solve the problem that a 64bit
counter become negative?

Maybe we can change the "invalid" value from U64_MAX to 0?  I think
the performance of "cycles == 0" is better than "cycles == U64_MAX".

Huacai

On Mon, Oct 21, 2019 at 10:58 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, 21 Oct 2019, Thomas Gleixner wrote:
>
> > On Mon, 21 Oct 2019, Huacai Chen wrote:
> > > @@ -50,7 +50,7 @@ static int do_hres(const struct vdso_data *vd, clockid_t clk,
> > >             cycles = __arch_get_hw_counter(vd->clock_mode);
> > >             ns = vdso_ts->nsec;
> > >             last = vd->cycle_last;
> > > -           if (unlikely((s64)cycles < 0))
> > > +           if (unlikely(cycles == U64_MAX))
> > >                     return -1;
> >
> > That used to create worse code than the weird (s64) type cast which has the
> > same effect. Did you double check that there is no change?
>
> It still does for 32bit.
