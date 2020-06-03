Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846801ECC43
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 11:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgFCJNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 05:13:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34243 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgFCJNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 05:13:51 -0400
Received: by mail-lj1-f195.google.com with SMTP id b6so1803883ljj.1;
        Wed, 03 Jun 2020 02:13:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aKmu2lju87/NQsXeppMhpEVDk/Ce6ci7zuwO5vzV0Bg=;
        b=lT47t44r96qzrfPvrwR5RjwbIogaFCEgNzvAWo/H4Mn87VlHd9acUhKUgl1rkPE4hF
         Mlo0FTbT54a2mJ2SAkjuvqUobUERUP9gDIYqjBlR5iWfZ7gQ7hWKjatxaOxsJjOdgq4t
         6VX7bd+McRAcLVGCgfj4Tqg1v36E2W7XOIbWrIKWuvxv/YGIiPaKSbQuwcVxQCnSxn4h
         22fjUFK4nlxNKKAlFE6v/uLQkCdLB9FqN8HLd80pSakBdCwuEP4F5nUXn9Wt39izyTfO
         K1oyyjAvgR2v+S0eQATqz3Cx/zGDWVH6xrbkdYhElAdsnBLF6jswPt5hCBIFA6aeQYtH
         Ifew==
X-Gm-Message-State: AOAM532iqkmPAqZmNrxhes+iaxLGinxVF5RuGToiM2wJ78BUpQiubG98
        lb+RiADfCaXakKcorx8qciI=
X-Google-Smtp-Source: ABdhPJxxdspmCu2TjJoCX66VstB4xhHw4DnspYcf2pBQTVK3SqXdhtLAHR7XZphFuIZvVeHjg134mg==
X-Received: by 2002:a05:651c:1195:: with SMTP id w21mr1765216ljo.464.1591175628744;
        Wed, 03 Jun 2020 02:13:48 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id v28sm316693ljv.40.2020.06.03.02.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:13:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jgPSs-0002O0-JY; Wed, 03 Jun 2020 11:13:38 +0200
Date:   Wed, 3 Jun 2020 11:13:38 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/4] serial: core: fix broken sysrq port unlock
Message-ID: <20200603091338.GK19480@localhost>
References: <20200602140058.3656-1-johan@kernel.org>
 <20200602140058.3656-3-johan@kernel.org>
 <CAHp75VeXYn46wQ5EXkk_MOQ49ybtyTeoQS6BS1X9DkC6hbeF-w@mail.gmail.com>
 <b016ad68-124a-5c98-f49b-f7286d995223@gmail.com>
 <20200603084051.GJ19480@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603084051.GJ19480@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 10:40:51AM +0200, Johan Hovold wrote:
> On Tue, Jun 02, 2020 at 04:34:16PM +0100, Dmitry Safonov wrote:
> > On 6/2/20 3:48 PM, Andy Shevchenko wrote:
> > > On Tue, Jun 2, 2020 at 5:03 PM Johan Hovold <johan@kernel.org> wrote:
> > >>
> > >> Commit d6e1935819db ("serial: core: Allow processing sysrq at port
> > >> unlock time") worked around a circular locking dependency by adding
> > >> helpers used to defer sysrq processing to when the port lock was
> > >> released.
> > >>
> > >> A later commit unfortunately converted these inline helpers to exported
> > >> functions despite the fact that the unlock helper was restoring irq
> > >> flags, something which needs to be done in the same function that saved
> > >> them (e.g. on SPARC).
> > > 
> > > I'm not familiar with sparc, can you elaborate a bit what is ABI /
> > > architecture lock implementation background?
> > 
> > I remember that was a limitation a while ago to save/restore flags from
> > the same function. Though, I vaguely remember the reason.
> > I don't see this limitation in Documentation/*
> 
> It's described in both LDD3 and LKD, which is possibly where I first
> picked it up too (admittedly a long time ago).
> 
> > Google suggests that it's related to storage location:
> > https://stackoverflow.com/a/34279032
> 
> No, that was never the issue.
> 
> SPARC includes the current register window in those flags, which at
> least had to be restored in the same stack frame.
> 
> > Looking into arch/sparc I also can't catch if it's still a limitation.
> 
> Yeah, looking closer at the current implementation it seems this is no
> longer an issue on SPARC.
> 
> > Also, looking around, xa_unlock_irqrestore() is called not from the same
> > function. Maybe this issue is in history?
> 
> xa_unlock_irqrestore() is just a macro for spin_unlock_irqsave() it
> seems, so not a counter example.
>
> > Also, some comments would be nice near functions in the header.
> 
> Agreed. Let me respin this and either merge this with the next patch or
> at least amend the commit message.

I stand corrected; this appears to longer be an issue (on any arch)
as we these days have other common code passing the flags argument
around like this.

I'll respin.

Johan
