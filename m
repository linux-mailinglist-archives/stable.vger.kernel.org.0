Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37C1EEDBA
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 00:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgFDWbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 18:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgFDWbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 18:31:44 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED78C08C5C0;
        Thu,  4 Jun 2020 15:31:43 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id q10so2624093uaj.13;
        Thu, 04 Jun 2020 15:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PfEYd36uNS5qZ/DmqxgTWEQjvkvDJRLoeb63Roelzwk=;
        b=Tj6LbMn6UyG3JUPUV/sMlJ8usV/UM3I4ztQC0b0Mu0ilDXAH+9P1GlkIrPVFeVGLct
         0t983yThVyG6apg9+KRWO2QK61Iz4bR88SPWv08fRAVjQwx/4sZLFHHmtIAZq00tHUq7
         BZad9OndhJ+smFsF8JVmPXuDkldZ9RIR/ZegWtBVhq4iyx4Y9MJRooHHpFqtbHiphyxd
         7zIYB6tHZrFMmHek8AmzE3Vc2uX6qMGOnyhSWNiLb7Wikglg3PZL6S23S18iMo9YSGvW
         Dhldh+cv7LMWa7PwSxDAsbN0M1FexyEeC9hNjCgpVOxnIWbaBHyVJ+W3hyjKLFJEBcs6
         QZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PfEYd36uNS5qZ/DmqxgTWEQjvkvDJRLoeb63Roelzwk=;
        b=BtMOe8+nFl0mgEOfTf9rG1orTo+3hBwQdE7J3uB0d3ucuQat5o78T1aY0bZ7BpMHFn
         ZtNgtGt4hZbSm5KYdgnbC3ryezibjEZUCF0n6wuvu8nDHaU6l8TE0yDGyeSaIlWPB0nI
         Udb8kwefqEmqy8wnW/uNdxUa0aYIF+N+vjn0H+7DONmjHm4n0vttUhahSGbTNuBdiRIr
         vyHLtn1bw6KHDV41Vt63FkyFIb+6QkUrelAh7q3Ybfp9IBNR+3cFDe4Lsi41CehgyO2+
         /8fYjy9IF62zN5OYbdfXLeSrsUb0kZpONB3JA1UkIkL3HHIO+nDrXf7A4U5VbuJXsAJ6
         8n+w==
X-Gm-Message-State: AOAM531qG7wzl20+zzPW8dQMK+zQ/TXlYnR+5bVhRmw7kBzrl7HNwFjN
        ITMEV5mn9lVNmWF1NaPscoQRT+4JurENfa542es6fQU9mV9hUA==
X-Google-Smtp-Source: ABdhPJxVvTM0lkxS+yAx50VUv48ZUUiznz8nPSRSMxuFnPwxmXdagoX2HbK2MZtP465LnHOR6MbYzcPifjNmdeORFGo=
X-Received: by 2002:a9f:2823:: with SMTP id c32mr5537785uac.99.1591309902922;
 Thu, 04 Jun 2020 15:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200518173450.097837707@linuxfoundation.org> <20200518173452.813559136@linuxfoundation.org>
 <CAPJ9Yc8YOeqeO4mo80iVMf3ay+CkdMvYzJY1BqXMNPcKzL6_zg@mail.gmail.com> <20200604201712.GB1308830@kroah.com>
In-Reply-To: <20200604201712.GB1308830@kroah.com>
From:   =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9@gmail.com>
Date:   Fri, 5 Jun 2020 00:31:31 +0200
Message-ID: <CAPJ9Yc-0jocU2WJP_27hQa43XFwGWJJx0LBNXShoryZE1K54sQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 12/80] pppoe: only process PADT targeted at local interfaces
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Jun 2020 at 22:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 04, 2020 at 08:39:00PM +0200, David Bala=C5=BEic wrote:
> > Hi!
> >
> > Is there a good reason this did not land in 4.14 branch?
> >
> > Openwrt is using that and so it missed this patch.
> >
> > Any chance it goes in in next round?
>
> Does it apply and build cleanly?
>
> I don't know why I didn't backport it further, something must have
> broke...

The patch from the above applies to linux-4.14.183

If I apply it manually (open pppoe.c in editor and add the two lines
from the patch) then it builds.
Until LD      vmlinux.o when I run out of disk space...
I applied it by editor because the first time something went wrong
when copying the patch from the email and it did not apply.

So it looks OK, but someone else should try it too.
My build system is not exactly great.. (it is a VM I created for
openwrt builds and it is after midnight and I don't feel like
extending the virtual disk.. sorry, maybe tomorrow).

Regards,
David
