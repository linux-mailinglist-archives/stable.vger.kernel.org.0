Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1219F9BCD
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 22:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKLVO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 16:14:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30703 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727419AbfKLVO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 16:14:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573593267;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KhaSq6F0boqwPJebWHU+vS4X8WSartUyEjWwqUHsPz4=;
        b=BAaOFLc1TJKBdf7dJ1oce3nTXUsLtrjbBtRUCaCTtpZ6vRiNg4nSoA1Jt4sejkZaLkkv1+
        7R5pjvRgjJzgAGcxUbugDQEoWU1M6Ezir/Y5mQHRJd7StQfoVv8pGNThDAwhIC/Wik5qh2
        PqMZOgZK5I1z0pW66GEbdVay1hRS0w8=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-34ZBrC86PFigkIDTdf3u3A-1; Tue, 12 Nov 2019 16:14:26 -0500
Received: by mail-yb1-f198.google.com with SMTP id f4so84019yba.22
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 13:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=jB1CQxHZY09v+dVO/IW1sLsxw+s5h/wXvYhyMUh4nd4=;
        b=cYFCnkR8Tkj7PSAGHLr0ISikgoYo9oBlkYaazhDvY8fZfSiul04oAvd/l+SuXV+fc3
         lMDjM6wowkuVbm6XFtkU8ZACt0vg3+RSJ+bHNyUNCP8Zd3b34wu6U8t+MUNKSc6TE25B
         3/WxJp44/QbEYRDCcA0vu4pMPuW99uA0YckSBTryGAyVpIlTiOx3qWPaEDScJYt8iKrn
         66/weqTst3hkbJ1hHkVXAKrhET7OGEhJklJeQuQVt2/pP1H55KDqB1FR/WsLjGDpz2Nf
         JWrRWBCDBXxoMAWB3muU5VaBrccqGQaz3MiE+9FDsIMLkfoE+1umGc1Yo0UMejESpGCd
         cNKQ==
X-Gm-Message-State: APjAAAX7qpJR/TebMuJ4R4AkCDxhED7eLf+IqGzss08VBLG5tEQnYv1G
        U0zuODOJ/+L9zQwvHvkARjni27Hy/uudhfi1y3d3crST+l3fm+Y7uAudNOXRpXc/lsqEc4lsQIF
        fKQ33JjpxFGuw4m1w
X-Received: by 2002:a81:10d4:: with SMTP id 203mr49036ywq.390.1573593265499;
        Tue, 12 Nov 2019 13:14:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEcKNvBFCa/Pi9LABko8hxEtyRnZOUme9kRE5c2iBVZmTkmYukiWzYoyB8ZRofsuIDcutGWg==
X-Received: by 2002:a81:10d4:: with SMTP id 203mr49020ywq.390.1573593265161;
        Tue, 12 Nov 2019 13:14:25 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id v5sm128965ywi.95.2019.11.12.13.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:14:24 -0800 (PST)
Date:   Tue, 12 Nov 2019 14:14:23 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Christian Bundy <christianbundy@fraction.io>
Subject: Re: [PATCH] tpm_tis: turn on TPM before calling tpm_get_timeouts
Message-ID: <20191112211423.vgtervfk52txgfmm@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jason Gunthorpe <jgg@ziepe.ca>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Christian Bundy <christianbundy@fraction.io>
References: <20191111233418.17676-1-jsnitsel@redhat.com>
 <20191112200328.GA11213@linux.intel.com>
 <CALzcddtMiSzhgZv5R6xqb1Amyk7cdY4mJdYDS86KRxH4wR_EGA@mail.gmail.com>
 <20191112202623.GB5584@ziepe.ca>
 <CALzcddtse-4bKWaA0+ns-gVKGyQzMrYWS4n1rFpbbhKLb83z7g@mail.gmail.com>
 <CALzcddv2aLQ1krYFeNtWNOxyF3aSD0-p3j_p3CgS2Vx-__sQPA@mail.gmail.com>
 <20191112204623.GG5584@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191112204623.GG5584@ziepe.ca>
X-MC-Unique: 34ZBrC86PFigkIDTdf3u3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue Nov 12 19, Jason Gunthorpe wrote:
>On Tue, Nov 12, 2019 at 01:31:09PM -0700, Jerry Snitselaar wrote:
>> On Tue, Nov 12, 2019 at 1:28 PM Jerry Snitselaar <jsnitsel@redhat.com> w=
rote:
>> >
>> > On Tue, Nov 12, 2019 at 1:26 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>> > >
>> > > On Tue, Nov 12, 2019 at 01:23:33PM -0700, Jerry Snitselaar wrote:
>> > > > On Tue, Nov 12, 2019 at 1:03 PM Jarkko Sakkinen
>> > > > <jarkko.sakkinen@linux.intel.com> wrote:
>> > > > >
>> > > > > On Mon, Nov 11, 2019 at 04:34:18PM -0700, Jerry Snitselaar wrote=
:
>> > > > > > With power gating moved out of the tpm_transmit code we need
>> > > > > > to power on the TPM prior to calling tpm_get_timeouts.
>> > > > > >
>> > > > > > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> > > > > > Cc: Peter Huewe <peterhuewe@gmx.de>
>> > > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> > > > > > Cc: linux-kernel@vger.kernel.org
>> > > > > > Cc: linux-stable@vger.kernel.org
>> > > > > > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of t=
pm_transmit()")
>> > > > > > Reported-by: Christian Bundy <christianbundy@fraction.io>
>> > > > > > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>> > > > > >  drivers/char/tpm/tpm_tis_core.c | 3 ++-
>> > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > > > > >
>> > > > > > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tp=
m/tpm_tis_core.c
>> > > > > > index 270f43acbb77..cb101cec8f8b 100644
>> > > > > > +++ b/drivers/char/tpm/tpm_tis_core.c
>> > > > > > @@ -974,13 +974,14 @@ int tpm_tis_core_init(struct device *dev=
, struct tpm_tis_data *priv, int irq,
>> > > > > >                * to make sure it works. May as well use that c=
ommand to set the
>> > > > > >                * proper timeouts for the driver.
>> > > > > >                */
>> > > > > > +             tpm_chip_start(chip);
>> > > > > >               if (tpm_get_timeouts(chip)) {
>> > > > > >                       dev_err(dev, "Could not get TPM timeouts=
 and durations\n");
>> > > > > >                       rc =3D -ENODEV;
>> > > > > > +                     tpm_stop_chip(chip);
>> > > > > >                       goto out_err;
>> > > > > >               }
>> > > > >
>> > > > > Couldn't this call just be removed?
>> > > > >
>> > > > > /Jarkko
>> > > > >
>> > > >
>> > > > Probably. It will eventually get called when tpm_chip_register
>> > > > happens. I don't know what the reason was for trying it prior to t=
he
>> > > > irq probe.
>> > >
>> > > At least tis once needed the timeouts before registration because it
>> > > was issuing TPM commands to complete its setup.
>> > >
>> > > If timeouts have not been set then no TPM command should be executed=
.
>> >
>> > Would it function with the timeout values set at the beginning of
>> > tpm_tis_core_init (max values)?
>>
>> I guess that doesn't set the duration values though
>
>There is no reason to use anything but the correct timeouts, as read
>from the device.
>
>Jason
>

Should there be a check in tpm1_get_timeouts and tpm2_get_timeouts:

=09if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
=09=09return 0;

to skip going through it again in the auto startup code if it was
already called and set?

