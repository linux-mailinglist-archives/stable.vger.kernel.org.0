Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BDF3618C
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfFEQoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:44:07 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44008 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:44:07 -0400
Received: by mail-lf1-f67.google.com with SMTP id j29so5700929lfk.10
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krMpKlKKoYqpKupzmqMHmFmdtnKDvJHxVTUUjBLDMQo=;
        b=v/el4+zZrak6DiRufKzU1TLlUIaV4eE4JiYe1RSOqlJyyFbW2N19kfFwmqxUoNLkQT
         xWZ9UhnsZz297yQs7ZKrWVfqGcXpZgWhj9cjY4eQpopGlLavAdvXVZS7jsI98vGBtRiT
         JD951bwStPjVCuE4EgojqL5zJzNCGbykeiGy1F9HyveHIy7FbLrd72FthGvbjzTTx11p
         QIxMLE9zjkmhZZ+FaPNVx6zaaDrAdS5rFRVRdsO4sbAt2qDGBvul74xVpD/03epFuDVQ
         KecoCVaoI6N8J9Xwqfh2JE15Slt/vN6iFNgQPuzuhNjWLGydYEVyB8uAoTf/bJYcSxzd
         24Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krMpKlKKoYqpKupzmqMHmFmdtnKDvJHxVTUUjBLDMQo=;
        b=LTEgEAwYK3irRBS3wRb3VZQhxZ0QGepuhc0AousHXuSMo8m/6D4nWF4WOzGUjSUndb
         sfA6XzOnWS3um1FHnV4WCBmpLslMjnPBTrkk8sTuGo4W5MTeeigR+l647s9Wq22pp4Fb
         CJWODKJgTkLdmWrmNKdHgwQpXFdmNKRhBsr3kf0LfSgHdrW8t6fKB5JJEeEqnJvtIWir
         7FVH/71LSt/PRk9SdTaL7zUO49mFwvsNdmxzGjTIw0c/AMESunyiim+Oek66mTW0ArU5
         JP8Hf11eiMghrSH+i5r1RNXgC9JPDV7Y04Y7qPSOZ3qzragUcvj4o6vXWhtIUDnquJKG
         k04w==
X-Gm-Message-State: APjAAAVjwVcLDR5yyc4KuZaReF26r5YdKCQYCHWDtgvSY4eZFZo1kHui
        w0Tq7pGuje5sCR2aCcOzyQAB48QozERoHQ4ckvfM5g==
X-Google-Smtp-Source: APXvYqw8dAsBJ1S81dS8c24GqXUhUW6XmHjR3RyR4eWGFUhc29Y3St6LYLN1M8eBrC0eygFrPssaqk9Ql+iqDEYXsF8=
X-Received: by 2002:ac2:53b7:: with SMTP id j23mr7216657lfh.85.1559753044883;
 Wed, 05 Jun 2019 09:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <1558991372.2631.10.camel@codethink.co.uk> <20190528065131.GA2623@kroah.com>
 <CAHRSSEzopAbeAv4ap9xTrC1nCbpw1ZPrEYEMZOc5W_EcLZaktQ@mail.gmail.com>
 <CAHRSSEw=z4hyHMZV=WYAs_hy6Wp2qRk2mWGRSiXUO49d1SDVfQ@mail.gmail.com> <20190604145037.GB5824@kroah.com>
In-Reply-To: <20190604145037.GB5824@kroah.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Wed, 5 Jun 2019 09:43:53 -0700
Message-ID: <CAHRSSEwxB0YRZd5+JAMUew3w2MKEDcf-t4ReRq-b=zTFEYgW1A@mail.gmail.com>
Subject: Re: [stable] binder: fix race between munmap() and direct reclaim
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Todd Kjos <tkjos@android.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 7:50 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, May 31, 2019 at 01:09:53PM -0700, Todd Kjos wrote:
> > Greg,
> >
> > I'm really confused. [1] was my submittal to stable for "binder: fix
> > race between munmap() and direct reclaim" which I think looks correct.
> >
> > For "binder: fix handling of misaligned binder object", I only
> > submitted to LKML [2]. But then I see [3] for 4.14 (that looks
> > incorrect as Ben pointed out).
> >
> > So the result is that fix is present in the LTS trees where it is
> > needed, but it has the wrong commit message and headline.
> >
> > I agree with Ben that the cleanest approach is to revert and apply the
> > correct version (to 4.14, 4.19, 5.0). I think the correct version is
> > the one I sent [1], but please let me know if you see something I
> > screwed up or if you need me to do something.
> >
> > [1] https://www.spinics.net/lists/stable/msg299033.html
> > [2] https://lkml.org/lkml/2019/2/14/1235
> > [3] https://lkml.org/lkml/2019/4/30/650
>
> Can you send me a patch series that fixes things up properly?  I really
> don't know exactly what to do here, sorry.

Sent. 2 patches for each of 4.14, 4.19, 5.0 (1/2=revert of bad patch,
2/2 apply good patch). Code ends up the same.

-Todd
