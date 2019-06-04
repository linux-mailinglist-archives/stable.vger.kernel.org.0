Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7859B3490E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfFDNja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 09:39:30 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33400 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfFDNja (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 09:39:30 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so17364965iop.0
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 06:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UcCALpChZ5Wfb4RozUv9u5bA717nmWpb5m62577l+FQ=;
        b=KKfgGLUf3esZ7x3gf7oMNlkaK1beUh8eg8qZ2tUmpOEuY1y4K7eAxNsGei3xew+IUF
         LeNWsEc/kYFXnuh+qkpnDo0N3UjRRAtmBVXidB+fYNDoY5pSwdExfecTRD2dpWPgFQhv
         NpNE+qlFACSX6ida97oSi+jL3P1OFf2WYlgYObcUD7zytJaxLwlhvMUk3Z2KCDce4n2/
         QLgv1DVgbjdjqpHYgE9VDriGNoi2EU+c9MKXJCYZf1prqOfwXBofwOqpTvuJLZJmz9MQ
         E3YnP8RQNmSRjaAMQ+QBuN6nDaL8hc4CY9GVB3h04AHLnwOm69XF74rdqYJ1eBFRp4He
         nIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UcCALpChZ5Wfb4RozUv9u5bA717nmWpb5m62577l+FQ=;
        b=m4jxoWQY+gyQocEjYe467aK8k8X5KYsDk53CZ6jE1CKC8UhehTNATQ/abAHSKvCVyo
         Ypjhb1DtWdYu23/HS8fEGWoKX2x2veL1HO5gxk9ot2kSKtlUzO3gARn5LPfA7z7QCTfz
         eshrM0Q05VHDWLTF4SndiZnTcGqC40SdZAK04zjDhdkPuSRkb1swe1j78+K/ztub7RF6
         bm8wDGAmukRadzK/q6fQOsFH0GPyhaE1309jgDC5HGZs+lO0uGJ7XbeHgl7PODMz2NT/
         HQDql4YPaM117mOKLcICs476F5Xhe29si/k32ffnf1wjndwcS9xW989DAIIgH4o2J43+
         Mn6A==
X-Gm-Message-State: APjAAAWaf7ESh6SJflDImcFRK4MG89fjBWHH9uIHWva7fOmVwC+XiFGt
        O8QuxMUi8p2tRLXeDxL0LkfmypDv5Iy0q+SIHVwQPw==
X-Google-Smtp-Source: APXvYqxtGmW29N8ILziwVrNQM5Tms/+zVSR75A3xvMqPOnqSXVePd5NZSM2kuf0xnhn1Xfw1KlxyjqwHspkoRjveNro=
X-Received: by 2002:a5d:9402:: with SMTP id v2mr3955290ion.128.1559655569459;
 Tue, 04 Jun 2019 06:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190603223851.GA162395@google.com> <20190604123432.GA19996@kroah.com>
In-Reply-To: <20190604123432.GA19996@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 4 Jun 2019 15:39:15 +0200
Message-ID: <CAKv+Gu8a77xObE8UPhDZeqzXdm48vxHOqC4resfvRJLFPavgLQ@mail.gmail.com>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Zubin Mithra <zsm@chromium.org>, stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Jun 2019 at 14:34, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 03, 2019 at 03:38:52PM -0700, Zubin Mithra wrote:
> > Hello,
> >
> > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> >
> > Could the patch be applied in order to v4.19.y?
>
> Now queued up, thanks.
>

Given the discussion leading up to this, I'm slightly surprised.

As I alluded to in my questions to Zubin, I am concerned that the
testing carried out on this patch has too little coverage, given that
a) Chrome OS apparently does not boot in EFI mode
b) therefore, Chrome OS there does not use efi=old_map
c) Chrome OS hardware does not implement 5 level paging

I have done all the testing I could before merging the patch, but I
would prefer to defer from backporting it until it hits a release. I
know some people argue that this still does not provide sufficient
coverage, but those are usually not the same people getting emails
when their EFI systems no longer boot without any output whatsoever
after upgrading from one stable kernel version to the next.
