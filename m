Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3C25AD78
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 23:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfF2VLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 17:11:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33095 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfF2VLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jun 2019 17:11:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so9775299wru.0
        for <stable@vger.kernel.org>; Sat, 29 Jun 2019 14:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gq3YVmC2TIiCnj2Weedub1HeweEOERFwQbA6h+63XlA=;
        b=HW0CgsE7PlJ8bVT+4EIZbdVmPK/K63FAWJu4DH125qo3G0ECnBLbW4fMFjgepYwhn2
         xMIXv6PTBYkH917YkAfxlZmsNJx84RwB3W2pfGpLBjRoWyXl3I7o4OqWs4fGUzeVJjJV
         Hlr63SOfWvZHvp/CIbG0IAGaxvgC5khyVsLX/F6kFMlmaOeIsNk3+rTRpiIqaycx88U5
         Ww5T8LKE/yorYeP+lAHcz+grZ8O4+26TsJC+FC5kqnvPC0L/z6XJgaUwTvf14oB70gJO
         cL16NO0oOgF8Djt/5KGZuIoX50VMADxp7jQrrgo+HK5EyTRFvnGkqtHVppTjQlPdKMZe
         5vYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gq3YVmC2TIiCnj2Weedub1HeweEOERFwQbA6h+63XlA=;
        b=sphP/Qri30w2VHi+c4q38lFlLawZAAOE+qRyPKPh/pPDoUMyicKjx+xqyyDYM4iUo9
         25IXoNRDQkbkj6cwd5lYkmEKoEG1qQ0Ccj4DS6SYYtNj54jjhIAUkXT8iwkxSF+x9aXr
         SMd5YyYauneflpEMKmcq/vWqyZtRt7cHPuai+SiRqd5ICRPSrfgFFPf+wrIl8S8FQ4Zx
         ZXYsiUSbonTp94GCbcXfK20eU0Fhzpvzu+uE9g85d6sZJRblnOMjGxmL/Vsf8WRyBwih
         HtEXBenDZFoBx2B2NNdqNJ+TAQUVoV8KKG3lZqRRq+ADG7TCGcCPPa58zrehGMFuW/VI
         L7Sw==
X-Gm-Message-State: APjAAAWPztHeupUI1Ex9ZeLeKXLpxEejyEqulfPbuC43UG3qPIDZPTal
        eterTKoa2j3f49cUR0pzByn6czg5HrmJGgPAJkbOng==
X-Google-Smtp-Source: APXvYqzQvg9UtatnGyaBFiJAKimifaSi58mH0sVyFP7vYy0DX6OV4ViELw32T8Z3uQRjZ5MLFCxgI1N1HZHIhSLAOrM=
X-Received: by 2002:adf:e40f:: with SMTP id g15mr12017467wrm.174.1561842673707;
 Sat, 29 Jun 2019 14:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
 <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
 <20190629065721.GA365@kroah.com> <CAKv+Gu-_senkX5Asy1ZL+0cbAJBGib7Ys1WnMgdS36YO2LOU4Q@mail.gmail.com>
 <20190629091059.GA4198@kroah.com>
In-Reply-To: <20190629091059.GA4198@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 29 Jun 2019 23:11:02 +0200
Message-ID: <CAKv+Gu9AJ0Xt=Aec4VLnn5F-fHAYKGAYgxeJFAZE+G+3tGFG5Q@mail.gmail.com>
Subject: Re: [4.19.y PATCH 1/3] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        stable <stable@vger.kernel.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 29 Jun 2019 at 11:11, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jun 29, 2019 at 10:47:00AM +0200, Ard Biesheuvel wrote:
> > On Sat, 29 Jun 2019 at 08:57, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Jun 28, 2019 at 11:42:13AM -0700, Srivatsa S. Bhat wrote:
> > > > From: Gen Zhang <blackgod016574@gmail.com>
> > > >
> > > > commit 4e78921ba4dd0aca1cc89168f45039add4183f8e upstream.
> > > >
> > > > The old_memmap flow in efi_call_phys_prolog() performs numerous memory
> > > > allocations, and either does not check for failure at all, or it does
> > > > but fails to propagate it back to the caller, which may end up calling
> > > > into the firmware with an incomplete 1:1 mapping.
> > > >
> > > > So let's fix this by returning NULL from efi_call_phys_prolog() on
> > > > memory allocation failures only, and by handling this condition in the
> > > > caller. Also, clean up any half baked sets of page tables that we may
> > > > have created before returning with a NULL return value.
> > > >
> > > > Note that any failure at this level will trigger a panic() two levels
> > > > up, so none of this makes a huge difference, but it is a nice cleanup
> > > > nonetheless.
> > >
> > > With a description like this, why is this needed in a stable kernel if
> > > it does not really fix anything useful?
> > >
> >
> > Because it fixes a 'CVE', remember? :-)
>
> No, I don't remember that at all.
>
> Remember, I get 1000+ emails a day to do something with, and hence, have
> the short-term memory of prior emails of a squirrel.
>
> Also, CVEs mean nothing, anyone can get one and they are impossible to
> revoke, so don't treat them like they are "authoritative" at all.
>

To refresh your memory: I already nacked this backport once before, on
the grounds that the CVE is completely bogus.
