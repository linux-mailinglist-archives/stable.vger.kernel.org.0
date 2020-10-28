Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50829DABF
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390490AbgJ1X3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:29:14 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36515 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390330AbgJ1X07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:26:59 -0400
Received: by mail-il1-f195.google.com with SMTP id p10so1259506ile.3;
        Wed, 28 Oct 2020 16:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4IyH/K1uoL8Sz48jVC4BVAm2CEzoTJ0RsS+KKnMacQ=;
        b=BLE//ez4GjeFZ6QQVlM/RVLml8HQT8E3yiUvgMc/boq70EepmNi/K7hp85FsIU2Pux
         y4QN5kuTarfGWgtX3qrNv9vB/kRiivitKmyaEEr1pOFNRJlBkhS+AGnjwNj/8HD7cw3J
         3Wh4wumkpVVVOAVqpTehhMxa5JoNsGtxKVFRvvaL6F+xVtlyiUHRBYtUl5SLf1twAKn2
         k1LN5OmxJe9bCKZHWGEctkqfTKSxRobT5FM5doOXbQVavGbGX/OjtXoujXbaj9NuBsNE
         ruhZCB023bv7HXSwN2MIAkBT67ni43XI+2y8HW4fxqok8ZmT85h3WN9J+N8lp3+LxJfG
         U8xg==
X-Gm-Message-State: AOAM531jzmfw4lBbvUV51lX9iatLJ1tpzJ+CD9GfTpI9E+vX0DPmnU3I
        6K4Huq87tXfOF0UtGzW2l65On3lIIJEgLl6z
X-Google-Smtp-Source: ABdhPJxDZmVRDYaofDrlgJS4ZZywf3C3X2WrupX8H8e2FTYfMa40efu8pXkwnyFzdyqj8kF6899xcQ==
X-Received: by 2002:a6b:bbc6:: with SMTP id l189mr4708130iof.145.1603857709465;
        Tue, 27 Oct 2020 21:01:49 -0700 (PDT)
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com. [209.85.166.174])
        by smtp.gmail.com with ESMTPSA id u20sm1869597ilj.5.2020.10.27.21.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 21:01:49 -0700 (PDT)
Received: by mail-il1-f174.google.com with SMTP id x7so2054397ili.5;
        Tue, 27 Oct 2020 21:01:49 -0700 (PDT)
X-Received: by 2002:a92:9e94:: with SMTP id s20mr4756389ilk.102.1603857708890;
 Tue, 27 Oct 2020 21:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <4cc0e162-c607-3fdf-30c9-1b3a77f6cf20@runbox.com>
 <20201022135521.375211-1-m.v.b@runbox.com> <20201022135521.375211-3-m.v.b@runbox.com>
 <c69233ce20acd04fcba780a0483a18031d9a541e.camel@hadess.net>
In-Reply-To: <c69233ce20acd04fcba780a0483a18031d9a541e.camel@hadess.net>
From:   Pany <pany@fedoraproject.org>
Date:   Wed, 28 Oct 2020 04:01:37 +0000
X-Gmail-Original-Message-ID: <CAE3RAxsG5JxV_7hVWxy9TLzfXY3aNKSe_L+V0Fxo-XpDe0wzKg@mail.gmail.com>
Message-ID: <CAE3RAxsG5JxV_7hVWxy9TLzfXY3aNKSe_L+V0Fxo-XpDe0wzKg@mail.gmail.com>
Subject: Re: [PATCH 2/2] USB: apple-mfi-fastcharge: don't probe unhandled devices
To:     Bastien Nocera <hadess@hadess.net>
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 2:03 PM Bastien Nocera <hadess@hadess.net> wrote:
>
> On Thu, 2020-10-22 at 09:55 -0400, M. Vefa Bicakci wrote:
> > From: Bastien Nocera <hadess@hadess.net>
> >
> > From: Bastien Nocera <hadess@hadess.net>
> >
> > Contrary to the comment above the id table, we didn't implement a
> > match
> > function. This meant that every single Apple device that was already
> > plugged in to the computer would have its device driver reprobed
> > when the apple-mfi-fastcharge driver was loaded, eg. the SD card
> > reader
> > could be reprobed when the apple-mfi-fastcharge after pivoting root
> > during boot up and the module became available.
> >
> > Make sure that the driver probe isn't being run for unsupported
> > devices by adding a match function that checks the product ID, in
> > addition to the id_table checking the vendor ID.
> >
> > Fixes: 249fa8217b84 ("USB: Add driver to control USB fast charge for
> > iOS devices")
> > Signed-off-by: Bastien Nocera <hadess@hadess.net>
> > Reported-by: Pany <pany@fedoraproject.org>
> > Link: https://bugzilla.redhat.com/show_bug.cgi?id=1878347
> > Link:
> > https://lore.kernel.org/linux-usb/CAE3RAxt0WhBEz8zkHrVO5RiyEOasayy1QUAjsv-pB0fAbY1GSw@mail.gmail.com/
> > Cc: <stable@vger.kernel.org> # 5.8
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > [m.v.b: Add Link and Reported-by tags to the commit message]
> > Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
>
> And along with the 1/2 patch:
> Tested-by: Bastien Nocera <hadess@hadess.net>
>

This patch works well for me.
Tested-by: Pan (Pany) YUAN <pany@fedoraproject.org>

-- 
Regards,
Pany
pany@fedoraproject.org
