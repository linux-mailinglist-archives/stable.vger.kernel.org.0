Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5711ECBAD
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 10:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgFCIlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 04:41:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38363 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgFCIlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 04:41:05 -0400
Received: by mail-lf1-f66.google.com with SMTP id 202so789914lfe.5;
        Wed, 03 Jun 2020 01:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3+NZ002fR5cwFINbc/o3dpUhIJL9xPazQ2yRYvAcPI=;
        b=hCKGaV93HEyfanQW2nAnEjNxbwDsgSYdkTODol6+PNwAyo+kuNPDUKiMhE80mpiu9o
         zubbOA8qpI5QX647m0BK2AAWL2lLBQm7rYvJmni8wTFJcbW/j6/1sAT4blQrmczyWa21
         PkFK/71ER6yi7IGo/HTGm+WmsJ9hVxb2jo4JUWEfKWbEmTqsb1ydZB/F5t96HyhSFqER
         QoFFj2ZwrQbFgNU3p4BAFtONiYu36xAAAerV4jGEKj6ZMWvp209JFnOkw368Of8RLXku
         WIXRMe7s/7BCS8M+TwOQUYOerldFaRTirFNp8LhCOdFqd2+oO6al5lxUaKw6hRKBvqH6
         4jhw==
X-Gm-Message-State: AOAM532MKL7xWBuCjQZLzHVIGx2++6Fs35TJgQGSNcVTihnQuXFP0jbB
        aJ2N+y6DsKs3nMgmICIQOfI=
X-Google-Smtp-Source: ABdhPJzoycNz0b42LjEGhqRPhb5Q3Xac6OiJOYqR8aXp9vwMshAsFIyQ9VYMEqnoKBUzsU0ot5PTsA==
X-Received: by 2002:a19:434e:: with SMTP id m14mr1905473lfj.40.1591173662210;
        Wed, 03 Jun 2020 01:41:02 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id w20sm298508lji.7.2020.06.03.01.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 01:41:01 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jgOx9-0002Ai-OO; Wed, 03 Jun 2020 10:40:51 +0200
Date:   Wed, 3 Jun 2020 10:40:51 +0200
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
Message-ID: <20200603084051.GJ19480@localhost>
References: <20200602140058.3656-1-johan@kernel.org>
 <20200602140058.3656-3-johan@kernel.org>
 <CAHp75VeXYn46wQ5EXkk_MOQ49ybtyTeoQS6BS1X9DkC6hbeF-w@mail.gmail.com>
 <b016ad68-124a-5c98-f49b-f7286d995223@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b016ad68-124a-5c98-f49b-f7286d995223@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 04:34:16PM +0100, Dmitry Safonov wrote:
> On 6/2/20 3:48 PM, Andy Shevchenko wrote:
> > On Tue, Jun 2, 2020 at 5:03 PM Johan Hovold <johan@kernel.org> wrote:
> >>
> >> Commit d6e1935819db ("serial: core: Allow processing sysrq at port
> >> unlock time") worked around a circular locking dependency by adding
> >> helpers used to defer sysrq processing to when the port lock was
> >> released.
> >>
> >> A later commit unfortunately converted these inline helpers to exported
> >> functions despite the fact that the unlock helper was restoring irq
> >> flags, something which needs to be done in the same function that saved
> >> them (e.g. on SPARC).
> > 
> > I'm not familiar with sparc, can you elaborate a bit what is ABI /
> > architecture lock implementation background?
> 
> I remember that was a limitation a while ago to save/restore flags from
> the same function. Though, I vaguely remember the reason.
> I don't see this limitation in Documentation/*

It's described in both LDD3 and LKD, which is possibly where I first
picked it up too (admittedly a long time ago).

> Google suggests that it's related to storage location:
> https://stackoverflow.com/a/34279032

No, that was never the issue.

SPARC includes the current register window in those flags, which at
least had to be restored in the same stack frame.

> Looking into arch/sparc I also can't catch if it's still a limitation.

Yeah, looking closer at the current implementation it seems this is no
longer an issue on SPARC.

> Also, looking around, xa_unlock_irqrestore() is called not from the same
> function. Maybe this issue is in history?

xa_unlock_irqrestore() is just a macro for spin_unlock_irqsave() it
seems, so not a counter example.

> Also, some comments would be nice near functions in the header.

Agreed. Let me respin this and either merge this with the next patch or
at least amend the commit message.

Johan
