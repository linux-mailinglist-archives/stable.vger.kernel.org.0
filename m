Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457321F7202
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 04:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgFLCDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgFLCDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 22:03:15 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA54C08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 19:03:15 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id g11so3730826qvs.2
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 19:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cantona-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xgcq+HGcr+2E0r2fW1Aksh/0luTigEmDuGP+izUX+VY=;
        b=HmJkGLHP42JUOmNtHkbJ+J0+A7oEgR/tT9d4PEfgn2WB9kHSMwqKuPUXC+T3SU+P6y
         xC2m7H/uB2xsPRnLgPmB+mvwZDRuKCtcfT6B/+kJ4ZlFzOeQXI0x/RSleZTKYhmqdyLw
         TclXEV5nXApZIjLSmxG14A37nE6xBaMRIzqr4X2uEZUmrQYUEXc8kSbFiD0nSShYsWTe
         X3Zk5dUguhoEmMkWluX3klNE9gI9eV+Mdvm4bn777R79pgu1ATVBcCxLxZ4TrQVwvO7c
         lgGCLxhlb34h3cIS/Vr5hchbWsBCl+EQI+bBHyZRg4P2bBCtkq2vTnvRXsirqZ99PnXU
         Ncjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xgcq+HGcr+2E0r2fW1Aksh/0luTigEmDuGP+izUX+VY=;
        b=Qg+Kl9RVu5VleEmrl1Q2FMD0ArM08TecpI4NWk3gnKzK0GNtyOHPxTJPsBJ5p+86fu
         Tl4V6624IaIi6pzMOzn/pi9Vf4VJ/ObEpEHou/7H2R5tV7O/aXaZ2GnSTtyIcJAZX+Nm
         EJS/mh0hoMNz7MqU7dK4+kdPvK9HNF4eq8VjVPNxuBkl0Xq5qNHAggnx9FxOYikHL+Yr
         oanGEdH92FKOi3kXmP0dZPyOT/GGx1LTGcTKD0LB+iTXg93bn0rr6pOfU9jk7QOKBRX+
         dTah/aW5yYrsutJPKUtMeahV+lBYjXk+vU8Q3ryQyqOjoF6swqZtCBhYtL0DtgWBdrTt
         f+SQ==
X-Gm-Message-State: AOAM530rsi/3M5A53SLbq1MiUiCacWIoB62gJ96MA+DLs79JiBHS85tA
        wUQJi9jn62cEaIETYdp64L0+YAC8QAXFbLpfjocu/w==
X-Google-Smtp-Source: ABdhPJx4a+HqrR4sihJ1rHsQYSKxpOqkvQBZ2YnE2nDHXikA4/bX33trbn92WZ7+Sml3eGzP9adfCLCKUnE6CmOFjBQ=
X-Received: by 2002:a05:6214:aaf:: with SMTP id ew15mr10590137qvb.110.1591927394407;
 Thu, 11 Jun 2020 19:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <cantona@cantona.net> <20200611115048.21677-1-cantona@cantona.net> <20200611135727.GA1060798@kroah.com>
In-Reply-To: <20200611135727.GA1060798@kroah.com>
From:   Kang Yin Su <cantona@cantona.net>
Date:   Fri, 12 Jun 2020 10:03:03 +0800
Message-ID: <CABJLtPHqn1ocvdS6n0x-TQWVY8SabrVJtH6sqvqbw4UX6SCH3Q@mail.gmail.com>
Subject: Re: [PATCH V2] crypto: talitos - fix ECB and CBC algs ivsize
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-crypto@vger.kernel.org, christophe.leroy@c-s.fr,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cool, thanks!

yin

On Thu, 11 Jun 2020 at 21:57, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 11, 2020 at 07:50:47PM +0800, Su Kang Yin wrote:
> > commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> > wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
> >
> > This restore the CBC algs original ivsize of removes ECB's ones.
> >
> > Fixes: e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> > Signed-off-by: Su Kang Yin <cantona@cantona.net>
> > ---
> > Patch for 4.9 upstream.
>
> Also seems to be an issue for the 4.14 and 4.19 backport, so I'll queue
> it up there too, thanks!
>
> greg k-h
