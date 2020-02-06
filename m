Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0C3153EAB
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 07:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgBFGX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 01:23:59 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40148 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgBFGX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 01:23:59 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18so4828900ljo.7;
        Wed, 05 Feb 2020 22:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Yx2+hnaLQdidmqzt6DrV4NNr+ovAAcq0GOKwZwfTWIs=;
        b=vGwWqtE1T4L4576/daYl3oSBj9J0ccf8zDKmDxcTyx7MneQmp3/uNqVfPfZEIb3WXp
         0oIsDc5jtLE1bUHuFfZa7pR6JaHFfsyu9EkBG0cM5/4WWkptscXimifduYzWd/NZ0Qkf
         GK2nqiCpaFKtk6Anjjml5X7SN6VWTmnKttuJ1K6nJpoYfrMGlzR97QpIQbf0FbwFAU5l
         Wcl70ULq1hyM3WdHBQv68yuTdpXdWeHjU/2p3UgcO3X2NWLyqepb4Svlgc3CoeTdkvqK
         ESOo9lXEzKP+lPeDwNDoIX6fLmIgM3Art2OcFpwGjtjYJZLn7H5ku7DUg6IhJYkxtcsr
         MJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=Yx2+hnaLQdidmqzt6DrV4NNr+ovAAcq0GOKwZwfTWIs=;
        b=QjyO8w1mPr6DJ8xeTqMojsGPehQBo0SU4EWqp0OAciQd4dpJjlHLdGYw/dFL+oHHgx
         YPp27myjPLcCzpZ9YGtq+WTiLYAktQNl7xdJsrIdT1Sr6KstYz7h7ez9Ybul7mwJDVHs
         CqxqV9rKIIoSceVf2iaWG/4myeA9Gv7eQhKlnDCowGmAzTj2zRRewXyAPagJ4vNTG6m8
         GAOH1MwR7BLXtHMMwrDEQbbJVfg/M3xBgZ1mLhc4E4xxF7xOgBXn2v/u4bFv6iIjrFl2
         zYs2GGv1zXcpUW47htRxICanM9KBGBIAL8VaxJkWE4eQz34qAdNv3Oy8F6PKk1YakBhe
         A4xw==
X-Gm-Message-State: APjAAAXiR1xL87NghlCGIeQBAKhrRx3mUABLm770S3SSeziupyvjcL0B
        klyxM/7FIuHR8FhQe2oSfPE=
X-Google-Smtp-Source: APXvYqwond6D+JUZYrVP7G89aKMFe6tsKnMUUz32fMoz0x2DylA6CzDsFoHrXPaWYAab0n0yvS3+Sw==
X-Received: by 2002:a2e:8702:: with SMTP id m2mr1026959lji.278.1580970236194;
        Wed, 05 Feb 2020 22:23:56 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id p15sm703640lfo.88.2020.02.05.22.23.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Feb 2020 22:23:55 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     "Yang\, Fei" <fei.yang@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using adb over f_fs
In-Reply-To: <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com>
References: <20200122222645.38805-1-john.stultz@linaro.org> <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com> <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com> <87o8uu3wqd.fsf@kernel.org> <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com> <87lfpy3w1g.fsf@kernel.org> <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com>
Date:   Thu, 06 Feb 2020 08:23:48 +0200
Message-ID: <87lfpg5j4b.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

John Stultz <john.stultz@linaro.org> writes:
> On Thu, Jan 23, 2020 at 9:46 AM Felipe Balbi <balbi@kernel.org> wrote:
>> >>>>>
>> >>>>> Since ~4.20, when the functionfs gadget enabled scatter-gather
>> >>>>> support, we have seen problems with adb connections stalling and
>> >>>>> stopping to function on hardware with dwc3 usb controllers.
>> >>>>> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.
> ...
>> >>
>> >> I'm pretty sure this should be solved at the DMA API level, just want=
 to confirm.
>> >
>> > I have sent you the tracepoints long time ago. Also my analysis of the
>> > problem (BTW, I don't think the tracepoints helped much). It's
>> > basically a logic problem in function dwc3_gadget_ep_reclaim_trb_sg().
>>
>> AFAICT, this is caused by DMA API merging pages together when map an
>> sglist for DMA. While doing that, it does *not* move the SG_END flag
>> which sg_is_last() checks.
>>
>> I consider that an overlook on the DMA API, wouldn't you? Why should DMA
>> API users care if pages were merged or not while mapping the sglist? We
>> have for_each_sg() and sg_is_last() for a reason.
>>
>
> From an initial look, I agree this is pretty confusing.   dma_map_sg()
> can coalesce entries in the sg list, modifying the sg entires
> themselves, however, in doing so it doesn't modify the number of
> entries in the sglist (nor the end state bit).  That's pretty subtle!
>
> My initial naive attempt to fix the dma-iommu path to set the end bit
> at the tail of __finalize_sg() which does the sg entry modifications,
> only caused trouble elsewhere, as there's plenty of logic that expects
> the number of entries to not change, so having sg_next() return NULL
> before that point results in lots of null pointer traversals.
>
> Further, looking at the history, while apparently quirky, this has
> been the documented behavior in DMA-API.txt for over almost 14 years
> (at least).  It clearly states that that dma_map_api can return fewer
> mapped entries then sg entries, and one should loop only that many
> times (for_each_sg() having a max number of entries to iterate over
> seems specifically for this purpose).  Additionally, it says one must
> preserve the original number of entries (not # mapped entries) for
> dma_unmap_sg().
>
> So I'm not sure that sg_is_last() is really valid for iterating on
> mapped sg lists.
>
> Should it be? Probably (at least with my unfamiliar eyes), but
> sg_is_last() has been around for almost as long coexisting with this
> behavioral quirk, so I'm also not sure this is the best hill for the
> dwc3 driver to die on. :)
>
> The fix here:
>   https://lore.kernel.org/lkml/20200122222645.38805-3-john.stultz@linaro.=
org/
> Or maybe the slightly cleaner varient here:
>   https://git.linaro.org/people/john.stultz/android-dev.git/commit/?h=3Dd=
ev/db845c-mainline-WIP&id=3D61a5816aa71ec719e77df9f2260dbbf6bcec7c99

in that case, we don't need to use sg_is_last() at all, since i will
always encode the last entry in the list.

> seems like it would correctly address things following the
> documentation and avoid the failures we're seeing.
>
> As to if dma_map_sg() should fixup the state bits or properly shrink
> the sg list when it coalesces entries, that seems like it would be a
> much more intrusive change across quite a bit of the kernel that was
> written to follow the documented method. So my confidence that such a
> change would make it upstream in a reasonable amount of time isn't
> very high, and it seems like a bad idea to block the driver from
> working properly in the meantime.
>
> Pulling in Christoph and Jens as I suspect they have more context on
> this, and maybe can explain thats its not so quirky with the right
> perspective?
>
> Thoughts? Maybe there is an easier way to make it less quirky then
> what I imagine?

it just seems very counter-intuitive to me that DMA api can coalesce
entries but they're actually still there and drivers have to cope with
this behavior.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl47sPQACgkQzL64meEa
mQYiLxAAhxe76gzIpf9TKKrL9PiIYADvgN7PP8dQVB0FC8oLmhCKUQLMNoi6BsB3
sVxskmoy/8HZV0VBn+58rz1rVyOcowp0qPYF7kWP83xYD6WHQwfgFw5wKfcNELZB
UwFYnspozEe0OIiFLFX4b2qlqeeNTlsd4VDzrSCvzchGRTGt0MHZLxz7SNFrtjeF
QVO1A4y+KQVnv8yyQmy+TDBD49XlxM8R4Vgo5z8s/p3qQn9RL6q7XMLMztr2wMre
PHClYBTYDsvtusLYf48WNflARU0q2KXV0LYT8h4iYg+MUIiwnWkpkgHprTMZVZS1
jZXeb+RmABYHCn9iPLSzKKV4d/vjR6Gwzr1h4fQJiihteM5JYmjqaC3MAO9NXIVD
35ECZyvWHbct6yKLGJZzxqOLDsjoPIcXQ7OPU1N/GtBl3lDfnX567V4Ux8NlI6+B
Enp/LjLrRI3+7cqlnUhl4lQM+m5c5vsg3Qrg2GlrsKBHuzOQvV5lBrhQ3RjCJTPG
E+NTk94RrgwdyEsQJrLWOaVsP9b3bhwDk5IosNWIuoo1sZ1s+4I5IuzFAEx+DnR0
m0TL9mV4htgBW6l/BM5R3ixqgiGcPfte2lH8Ul4aB5ZH/HXaRCdbjs3XQ7xC+95y
DAXEKdR+oCogx+4/9TqlKwfmyrQSRZhjjgYs0p191mOM7CVQyxw=
=RzGZ
-----END PGP SIGNATURE-----
--=-=-=--
