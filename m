Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9AD246DC8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388674AbgHQROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:14:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38446 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389523AbgHQRNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 13:13:46 -0400
Received: from mail-ej1-f71.google.com ([209.85.218.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1k7ihb-0005cr-SU
        for stable@vger.kernel.org; Mon, 17 Aug 2020 17:13:43 +0000
Received: by mail-ej1-f71.google.com with SMTP id lg2so5763564ejb.23
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 10:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ortJXZij7qhe0ZAYBzpiXihdZh9t9k9y3DWPAjhxY9E=;
        b=V5TStlF47jhYaV2uZLguWv6fGtnEwaMwv7VoLtx6MLf2spEAVLWfeFSTac0s0gmg/b
         GsvEAOzMAPNdcOWzVuE2IFnKgEZySWh5uiYESnq5xQzbp4AIQn2yR9+G3favRqoafQJU
         wjV++YMiaBv9t+G8h/81CkjAPvC6ughhvsrRY1vTg7XOCY5x+Yfc5T/CVnhqU8HCerMv
         VzrHNrPBPTmKPJNyMPv0nhSoPlIuhU+qul9oyAofmRwh/6Zhb4zgi9stQ9fYce1QGgIs
         aqU6oX1wuixfumHkJTJP2EJdbi93e4PJfuY7MXUisTkdq17JFEXpK21fQwBZE7ZZoGqX
         8vcA==
X-Gm-Message-State: AOAM533pLauTSsmfzsUVHsDvX23hFz75BUWQrXlIXS52QqSUFS6ICCeR
        FMzmnkcJ7l4xpn2n6+KaiWWiyd5tNfOaFUUEPrX6M2/w5i/le6KE0FtkgfB3bc2MxGKEhqtwgwH
        xiMNU/T8OgY5RS77bpgHKsXQRYMgtw/D7GNFpRB4kbUh7WJ7VEg==
X-Received: by 2002:a17:907:11dd:: with SMTP id va29mr16717390ejb.470.1597684423591;
        Mon, 17 Aug 2020 10:13:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+P7qcj2FO8zBWQkQhYdBN5ckyKddUU2gVpQAdmLowvJ1iTcyzeQlevRPzJ0r4zj5MZRKPlm7o/RxnXFvwmbo=
X-Received: by 2002:a17:907:11dd:: with SMTP id va29mr16717379ejb.470.1597684423396;
 Mon, 17 Aug 2020 10:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
 <20200817162156.GA715236@kroah.com> <a2788632-5690-932b-90de-14bd9cabedec@canonical.com>
 <20200817164924.GA721399@kroah.com> <14968c46-ad8f-fbdf-88d6-0ded954534c9@canonical.com>
 <20200817170522.GA795695@kroah.com>
In-Reply-To: <20200817170522.GA795695@kroah.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Mon, 17 Aug 2020 14:13:07 -0300
Message-ID: <CAHD1Q_zsu=M9TZpNFwEni3zW4HQ0eCvmqPBtJt_oJi+3YNOCvQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 35/47] x86/irq: Seperate unused system vectors from
 spurious entry again
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, jan.kiszka@siemens.com,
        jbeulich@suse.com, LKML <linux-kernel@vger.kernel.org>,
        marc.zyngier@arm.com, stable@vger.kernel.org,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        Pedro Principeza <pedro.principeza@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 2:05 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 17, 2020 at 01:59:00PM -0300, Guilherme G. Piccoli wrote:
> > On 17/08/2020 13:49, Greg KH wrote:
> > > [...]
> > >> I'm sorry, I hoped the subject + thread would suffice heh
> > >
> > > There is no thread here :(
> > >
> >
> > Wow, that's odd. I've sent with In-Reply-To, I'd expect it'd get
> > threaded with the original message. Looking in lore archive [1], it
> > seems my first message wasn't threaded but the others were...apologies
> > for that, not sure what happened...
>
> reply to is fine, but how do you know what my email client has (hint,
> not a copy of 1.5 years of history sitting around in it at the
> moment...)  So there is no "thread" here as far as it is concerned...
>
> Anyway, not a big deal, just properly quote emails in the future, that's
> good to get used to no matter what :)
>
Sure, will do - specially for super old threads like this.


> > >> So, the mainline commit is: f8a8fe61fec8 ("x86/irq: Seperate unused
> > >> system vectors from spurious entry again") [0]. The backport to 4.19
> > >> stable tree has the following id: fc6975ee932b .
> > >
> > > Wow, over 1 1/2 years old, can you remember individual patches that long
> > > ago?
> > >
> > > Anyway, did you try to backport the patch to older kernels to see if it
> > > was possible and could work?
> > >
> > > If so, great, please feel free to submit it to the
> > > stable@vger.kernel.org list and I will be glad to pick it up.
> > >
> >
> > I'm working on it, it is feasible. But I'm seeking here, in this
> > message, what is the reason it wasn't backported for pre-4.19
>
> Try reading the stable mailing list archives, again, you are asking
> about a patch 1.5 years ago.  I can't remember information about patches
> sent _yesterday_ given the quantity we go through...
>
> thanks,
>
> greg k-h

OK, thanks Greg. If Thomas or anybody involved here knows a reason to
not backport it to older kernels, please let me know - I'd really
appreciate that.
Cheers,


Guilherme
