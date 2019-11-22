Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868B41075C2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 17:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKVQ1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 11:27:39 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45265 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfKVQ1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 11:27:38 -0500
Received: by mail-io1-f65.google.com with SMTP id v17so8640165iol.12
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 08:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XlWqqCQ+zgEV72jaObyUbNZTFY8rKw/Sl0dnc6Dl/5A=;
        b=Q3de4ll9e8KMpxI6muGFZLyE6AtK8cNP9PPf7FhGVILpdUDr2/fmfkA6lyoQW2n2TR
         n/d4o06GOFMQKFA/uxZwpohzLAewPAEWEl1D0i3RqNxIxxH3yCaK3+CaFFHK91qnMiPa
         JnHQ+AP3izQjZA8A7uZRODuPBE2ygcvsWnFI25OD4yGrQjWYMpxYHzNoBfGTKyRlkLvS
         lG3ibCe/VgG0y5KwtrkoVOJ5YlJfrK5JwIHTw3ruMuM/D9c50iLAd7Svfuxmw08j9X+n
         DuWPON1UvQXTEWc4VQAk+szrUVfQdjN8OJ0oQAhQyoo1I43xjI01M6nie/C6DSNvvJir
         GZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XlWqqCQ+zgEV72jaObyUbNZTFY8rKw/Sl0dnc6Dl/5A=;
        b=svH4e52BfMDAZgosEp8q84upV3g+k1lPtWpV1qOU2aVksWr4Y/2X2DUa+SToc5rk7Y
         EFAiQCLZ32ZCWrE2Mc9t2tSwXrZiSX6l5o8InpWvEkpe6GOoT9soL2spaaaStUkv4R2h
         idBUESZ8nklSljoKbVQMpSn2smwgdpDaAsqvmAlGV5lSlNv/4Hg0+hUITKphdPUbS6mH
         JtSlSfojezyMV5hC2jKXmAPqEtDtjtozKlU3slKwHmIbC9fjCXsoy4j0dsH5fGVH8pYn
         fxa8wT7uNfC0Y0jlEJKEb3MUbQLyONW+ZzHWDfkM5+rpyUegEjFRRF17jYFOlJ0YfKzz
         XpOA==
X-Gm-Message-State: APjAAAWaFevXLwUPiVtRzJj7r8RzlA5bM/aCmreoJvv3bKtXrq0TAEFr
        IJWml4tuz+FQYWpXjM+7nJCstK1HPdr0NSHVmMU6RKRB
X-Google-Smtp-Source: APXvYqyif/FcVg31H4mCMrqc1tAv9+xfOMC4ku1jEbZz0D4MzKrvW2UuCa7rSztTlQQZp6E44d6wzwy8qjw4Fx0IG+w=
X-Received: by 2002:a6b:c389:: with SMTP id t131mr13745566iof.50.1574440057783;
 Fri, 22 Nov 2019 08:27:37 -0800 (PST)
MIME-Version: 1.0
References: <20191115223356.27675-1-mathieu.poirier@linaro.org> <20191121203555.GC813260@kroah.com>
In-Reply-To: <20191121203555.GC813260@kroah.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Fri, 22 Nov 2019 09:27:26 -0700
Message-ID: <CANLsYkyumUDrP6ic0towr68S6pxL1psZHVP0XTRC+Tf82O4wQQ@mail.gmail.com>
Subject: Re: [stable 4.19+][PATCH 01/20] i2c: stm32f7: fix first byte to send
 in slave mode
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 4 . 7" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Nov 2019 at 13:35, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Nov 15, 2019 at 03:33:37PM -0700, Mathieu Poirier wrote:
> > From: Fabrice Gasnier <fabrice.gasnier@st.com>
> >
> > commit 915da2b794ce4fc98b1acf64d64354f22a5e4931 upstream
>
> That commit is not in Linus's tree :(

:o(  Apologies for that - probably a copy/paste problem.

>
> I'll stop here.  Please check all of these and resend the whole thing.
>
> Also, does this series also apply fully to 5.3.y?

Normally it should have and that is what I assumed.  I just did a
quick test and I'm wrong - as you probably noticed since you're
pointing it out.  Forget the whole thing and I'll send another set (or
two).

>
> thanks,
>
> greg k-h
