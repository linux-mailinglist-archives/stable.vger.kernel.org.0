Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F1829DB1D
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389654AbgJ1XnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:43:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39782 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388224AbgJ1Wvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:51:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id e15so685340pfh.6;
        Wed, 28 Oct 2020 15:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=88zJ9ycLYQdcGqRXYja6/gO2C1Ux6yzl679UI8xpjuk=;
        b=mDAT2lviXSntEcMhARnMRFfdYuPdGTfEq+Ks1QELqZO8akz6HkytaYKwHoc8KhyU1e
         uLNprLCtiYJw3sWMc4G9hDPkqnSsHtltWelpEPcOLVAn1hKEuwr6hJhoVCRDZ8zWf97R
         lLxtn5IjHttyeSMgINQjIPSnX5+/oK1ezwrd9ETGw+DOQ9fohq2wdCRgkIXYi9wGRmUU
         4eDk6wZYc9duhuA4Pj0SJb+E7r3bD676uIl4J73bqSHKwrvTOnGizVEvEz9mD7QeBjm8
         r1JbzmusCwqxZN+Iak/DRjHMKftXFaPRiHuFmaD1DKHzKWWo/0pm5TteFwdoxfQ/ZbcC
         FEPQ==
X-Gm-Message-State: AOAM530lw6DG7xMF0tnysyIGOY+xne5s2gQsytlHBAyi8xEmTlk8ihnM
        d94wMPfPCWMnAjbtrJ8Yhkig1Z4TWp0kG2Jx
X-Google-Smtp-Source: ABdhPJx7FiiYGqO8p9vnvQI0SFfAk/Zy/DLS6frwPi9tU1Ev3+i3tWcwRUuf81mHMu9jTgX4SAzVww==
X-Received: by 2002:a92:41cf:: with SMTP id o198mr4361886ila.262.1603857675192;
        Tue, 27 Oct 2020 21:01:15 -0700 (PDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com. [209.85.166.170])
        by smtp.gmail.com with ESMTPSA id v85sm2051225ilk.50.2020.10.27.21.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 21:01:14 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id v18so3513249ilg.1;
        Tue, 27 Oct 2020 21:01:14 -0700 (PDT)
X-Received: by 2002:a92:cb8d:: with SMTP id z13mr4118140ilo.182.1603857669680;
 Tue, 27 Oct 2020 21:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <4cc0e162-c607-3fdf-30c9-1b3a77f6cf20@runbox.com>
 <20201022135521.375211-1-m.v.b@runbox.com> <20201022135521.375211-2-m.v.b@runbox.com>
 <4f367aba2f43b5e3807e0b01a5375e4a024ce765.camel@hadess.net>
In-Reply-To: <4f367aba2f43b5e3807e0b01a5375e4a024ce765.camel@hadess.net>
From:   Pany <pany@fedoraproject.org>
Date:   Wed, 28 Oct 2020 04:00:57 +0000
X-Gmail-Original-Message-ID: <CAE3RAxuUiejhQtByfgeORrjy6v=QAP4gPrv+L-Ez4roNNsQY=g@mail.gmail.com>
Message-ID: <CAE3RAxuUiejhQtByfgeORrjy6v=QAP4gPrv+L-Ez4roNNsQY=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] usbcore: Check both id_table and match() when both available
To:     Bastien Nocera <hadess@hadess.net>
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 6:25 PM Bastien Nocera <hadess@hadess.net> wrote:
>
> On Thu, 2020-10-22 at 09:55 -0400, M. Vefa Bicakci wrote:
> > From: Bastien Nocera <hadess@hadess.net>
> >
> > From: Bastien Nocera <hadess@hadess.net>
> >
> > When a USB device driver has both an id_table and a match() function,
> > make
> > sure to check both to find a match, first matching the id_table, then
> > checking the match() function.
> >
> > This makes it possible to have module autoloading done through the
> > id_table when devices are plugged in, before checking for further
> > device eligibility in the match() function.
> >
> > Signed-off-by: Bastien Nocera <hadess@hadess.net>
> > Cc: <stable@vger.kernel.org> # 5.8
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Co-developed-by: M. Vefa Bicakci <m.v.b@runbox.com>
> > Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
>
> You can also add my:
> Tested-by: Bastien Nocera <hadess@hadess.net>
>

This patch works well for me.
Tested-by: Pan (Pany) YUAN <pany@fedoraproject.org>

-- 
Regards,
Pany
pany@fedoraproject.org
