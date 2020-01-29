Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3914C978
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 12:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgA2LTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 06:19:18 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36579 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2LTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 06:19:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so18030321ljg.3;
        Wed, 29 Jan 2020 03:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=4dqWHdv0qrHd3fdZPTf0f4D+2/ihtxoiaJ94Krc3ahg=;
        b=vIWZLKSm+3y/+75p3blXXHBratQSdjYwo+jOHbtfxIEeB6TbDkZsZ1LtkcP0+JOjG1
         w/cYuxSpedrPYSQ7EqeRv0RqhI9qhuJNT7E8zLzT1Knv3NA1D22d3Rg1RTKLreGeDkQ+
         M3iqvNEBJ9K7xHNjVgSaJ7rQ69YWrq3sQgkrrTtPKWXYXP+laxHyQImchiQCkcJWb+Xf
         NSE1JXharu3320/8KMn2xsNXDKn+J4lR0psOymKP4gSaUey7uWIoPYcD/cFf/FeWNyMr
         iUjiRvk/Kqu/92h0pScLp5gDtmcwqPpsRRo9tTmDBNt7jJXANc2LfavzTu5WoGOHfD8Q
         L1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=4dqWHdv0qrHd3fdZPTf0f4D+2/ihtxoiaJ94Krc3ahg=;
        b=qpIy0qTpkvw5tSJ51B3DlvfdNTZY6b8F78eIRwVHpZFRaEbh/XHyxPYC2TbL8PxKZm
         VCaCIo0Z16gixFQiX6jL6co/8HCXSLf4B1NqhJz8nEWXJ0rU66iePEU5RiUgRHg1gS44
         UtpU91cbdIBNJL5fB+5KGRNi1YnPcxkZAfmaxMZY5ZCNlh4LTklzcRyjxmuiUSjeDf1u
         Qz4MQcbMPYmePURBQlj//QKB48xnlbH5LcXp4dA/NA8PYYVKAjotCjhX+LLRU5LIxvSx
         YMB20SlXrGI0qEO9ZTHwvwAJdh/y5ykEC7DWlSbXRGYRUBV4huIy0MpM404GF+pQCRmk
         NyOA==
X-Gm-Message-State: APjAAAXHG18qiiYIyiCVgWAoUU7hudZ8C7uhYc1MI45zE7G6M4kzGZgI
        IA6paII1/4eA3A2gTg37zw5X6fxaHPA=
X-Google-Smtp-Source: APXvYqwd5YyySgaiM29kXaQ6GJaqSjqqDHoiA2AZNwIkeE/Bfpk5Ey/ifB3mdOyBnHer/QMlFTlhzA==
X-Received: by 2002:a2e:b4f6:: with SMTP id s22mr15183473ljm.218.1580296754412;
        Wed, 29 Jan 2020 03:19:14 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id f16sm768170ljn.17.2020.01.29.03.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jan 2020 03:19:13 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields
In-Reply-To: <CALAqxLUNg_Oww17U=BW9XTzZAdkCoCWCg=92Js17SexhT8gy6g@mail.gmail.com>
References: <20200127193046.110258-1-john.stultz@linaro.org> <87lfpq915x.fsf@kernel.org> <CALAqxLUNg_Oww17U=BW9XTzZAdkCoCWCg=92Js17SexhT8gy6g@mail.gmail.com>
Date:   Wed, 29 Jan 2020 13:19:03 +0200
Message-ID: <87imku8q8o.fsf@kernel.org>
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
> On Tue, Jan 28, 2020 at 11:23 PM Felipe Balbi <balbi@kernel.org> wrote:
>> John Stultz <john.stultz@linaro.org> writes:
>> > From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>> >
>> > The current code in dwc3_gadget_ep_reclaim_completed_trb() will
>> > check for IOC/LST bit in the event->status and returns if
>> > IOC/LST bit is set. This logic doesn't work if multiple TRBs
>> > are queued per request and the IOC/LST bit is set on the last
>> > TRB of that request.
>> >
>> > Consider an example where a queued request has multiple queued
>> > TRBs and IOC/LST bit is set only for the last TRB. In this case,
>> > the core generates XferComplete/XferInProgress events only for
>> > the last TRB (since IOC/LST are set only for the last TRB). As
>> > per the logic in dwc3_gadget_ep_reclaim_completed_trb()
>> > event->status is checked for IOC/LST bit and returns on the
>> > first TRB. This leaves the remaining TRBs left unhandled.
>> >
>> > Similarly, if the gadget function enqueues an unaligned request
>> > with sglist already in it, it should fail the same way, since we
>> > will append another TRB to something that already uses more than
>> > one TRB.
>> >
>> > To aviod this, this patch changes the code to check for IOC/LST
>> > bits in TRB->ctrl instead.
>> >
>> > At a practical level, this patch resolves USB transfer stalls seen
>> > with adb on dwc3 based HiKey960 after functionfs gadget added
>> > scatter-gather support around v4.20.
>> >
>> > Cc: Felipe Balbi <balbi@kernel.org>
>> > Cc: Yang Fei <fei.yang@intel.com>
>> > Cc: Thinh Nguyen <thinhn@synopsys.com>
>> > Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
>> > Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>> > Cc: Jack Pham <jackp@codeaurora.org>
>> > Cc: Todd Kjos <tkjos@google.com>
>> > Cc: Greg KH <gregkh@linuxfoundation.org>
>> > Cc: Linux USB List <linux-usb@vger.kernel.org>
>> > Cc: stable <stable@vger.kernel.org>
>> > Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
>> > Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
>> > Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>> > [jstultz: forward ported to mainline, reworded commit log, reworked
>> >  to only check trb->ctrl as suggested by Felipe]
>> > Signed-off-by: John Stultz <john.stultz@linaro.org>
>>
>> since v5.5 is already merged, I'll send this to Greg once -rc1 is
>> tagged. It's already in my testing/fixes branch waiting for a pull
>> request.
>
> Great, thanks so much for queueing this! I'll be digging on the db845c

no worries, it was way past the time :-)

> side wrt the dma-api issue to hopefully get that one sorted as well.

Thanks, that would, indeed, be great :-)

> Thanks again for the help and analysis!

no worries. If you find anything odd, just collect traces and I can help
have a look.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4xaikACgkQzL64meEa
mQbN3w//V3sy7UdebQ1Xo0antHtl+NK72TPw4TMUjIAsj+oup5UBBmN9zVHByNOU
K1UjaWzFeH2IwAqmaIKoPbp/LNd1tKeEGASPQgN97Rjp8L5i6IS58th043gympLQ
1yig3rvofyMaRlJlkt0EwXO1zfFLSVAj7Kd8nONMF7e86+yR9lNw4Sc/xT3vDZu4
nDHw4YooT7vO5WiUpO1+rHv85lmv5fD7e5O7TYVAsk3wtdubBMX+Hv0MgtIjXeAD
yRPCZEFDXAd1lgw5jwcluowH3GKIJp4aW0+WtF6uaUo5A9DtN7qOt88MNkrLXTjA
Uzg7wOvBInUsDOW3OkrZsEYKNdAbo1SlVcfjAl9gIGRbxFju/xjTrYBP/rt6KITf
k0B88PnD8amQiDl2ks3MRfIFeQa4lC/IzRFAuKVeCGnaOM+9Vhhbbt8WjsHw6qZr
lhVopqA7jWP+yQs/bv1RK7+8uGoFZIVaAs1F8tP078+dd6v5bCKjWemSKojOVoWG
/VHLugyWZLCiXg5ltUoHQlXgOnTXZboaD+zWbz9lLd+NYJJg0bqRbYmYUZyYr1yx
+/RrSCJWgPqUHxMjPoQFqgbLxoBUPyU6fZxFBQPdPvpBFiB4FQ77uaja6/LjKiU1
cm3Lro5pdwtO+MuY7QiXP4MyJGf+mzZPGJIzyd0eqM+SpHa0c3I=
=98RO
-----END PGP SIGNATURE-----
--=-=-=--
