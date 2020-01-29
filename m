Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A616714C6C4
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 08:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgA2HQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 02:16:28 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36759 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgA2HQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 02:16:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so17314000ljg.3;
        Tue, 28 Jan 2020 23:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WTrvUywgLybex9L6ZKI1z8jPJJzgLHgy5xUyFCFo4v0=;
        b=FIagldBiZ7DVkWn2XxCrx5Yey7VkwX/s2CcK/kPAzP3gtRMRnI9SRnoc/pN+BZ9jCC
         2qcOm3AVLHHcPGLzxbdlHGKxdMypgN2n2U30eCGiceV5/M4lFDNiGc2+FqIfls4eXd5K
         ThmkQAdsZS20AlmP69V0fiEz/xuMAnUys2mKCaVKO7thotGR6cJcQqb82Gfksh37mumj
         uollaJVujhBCjdKDx2DwGVbUoBW0LDhrHKr4tOlJYSthQb4qSXcomIARiyklcLrLtFM7
         2aGAcJUu+Vd5TKSJbOxcaR/2nZuPOj0IHeItWJ8kF1b94cueQM9ZWDdD3H8SDOmzDV1Q
         FOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=WTrvUywgLybex9L6ZKI1z8jPJJzgLHgy5xUyFCFo4v0=;
        b=rdYPujy2ToMmei3r4anLBMrYio1LaNDo/d/RUsp1Y+nb1V9QrOTU/Yo5C5R5/ipSh1
         B1EwHClRF32OIaRuXatEVXzybjeT+jaf8cMjRssbWvNElCr43a/7TSjJYYyQ/4cShLVA
         04IE+araScYdLt6BTuEJPc0adjF4x/YyReBLpYYg+Jk2dfwAtjlYGIXi1NLAl5+ov4dm
         w/35DPgSrsBXoLeIXxW/oAJbkrPqoyLP62EXBafg7S7bm9UmQqLS1pn9EYfR2us8LKTU
         gfWM87coEqR471Fdlb79irpyLRF/Y/Ps9RVO//6MaHLmIHWIS/MoN5lCMwB28rXrw3bv
         nlbQ==
X-Gm-Message-State: APjAAAUR/6dgMm0QxRpqjBP6vUrSPUyPt6TT08fZmOkv3yzs22riNtke
        QNEbcMdZgqYi39LGxuthJpP6hDU9RmQ=
X-Google-Smtp-Source: APXvYqz8u+5IPK8o1YF9bnGSAiL9ELYLUH+C++B8xEbZgk8kLXm9OMh5ToAT2/3wQqPvW/DeRw3png==
X-Received: by 2002:a2e:86c4:: with SMTP id n4mr15472909ljj.97.1580282184942;
        Tue, 28 Jan 2020 23:16:24 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id l16sm568440lfh.74.2020.01.28.23.16.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 23:16:23 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields
In-Reply-To: <dfb83e3d-7e78-9568-6bed-f4ee67f90c69@synopsys.com>
References: <20200127193046.110258-1-john.stultz@linaro.org> <87sgjz90lt.fsf@kernel.org> <dfb83e3d-7e78-9568-6bed-f4ee67f90c69@synopsys.com>
Date:   Wed, 29 Jan 2020 09:16:19 +0200
Message-ID: <87pnf291h8.fsf@kernel.org>
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

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>> John Stultz <john.stultz@linaro.org> writes:
>>
>>> From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>>>
>>> The current code in dwc3_gadget_ep_reclaim_completed_trb() will
>>> check for IOC/LST bit in the event->status and returns if
>>> IOC/LST bit is set. This logic doesn't work if multiple TRBs
>>> are queued per request and the IOC/LST bit is set on the last
>>> TRB of that request.
>>>
>>> Consider an example where a queued request has multiple queued
>>> TRBs and IOC/LST bit is set only for the last TRB. In this case,
>>> the core generates XferComplete/XferInProgress events only for
>>> the last TRB (since IOC/LST are set only for the last TRB). As
>>> per the logic in dwc3_gadget_ep_reclaim_completed_trb()
>>> event->status is checked for IOC/LST bit and returns on the
>>> first TRB. This leaves the remaining TRBs left unhandled.
>>>
>>> Similarly, if the gadget function enqueues an unaligned request
>>> with sglist already in it, it should fail the same way, since we
>>> will append another TRB to something that already uses more than
>>> one TRB.
>>>
>>> To aviod this, this patch changes the code to check for IOC/LST
>>> bits in TRB->ctrl instead.
>>>
>>> At a practical level, this patch resolves USB transfer stalls seen
>>> with adb on dwc3 based HiKey960 after functionfs gadget added
>>> scatter-gather support around v4.20.
>>>
>>> Cc: Felipe Balbi <balbi@kernel.org>
>>> Cc: Yang Fei <fei.yang@intel.com>
>>> Cc: Thinh Nguyen <thinhn@synopsys.com>
>>> Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
>>> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>>> Cc: Jack Pham <jackp@codeaurora.org>
>>> Cc: Todd Kjos <tkjos@google.com>
>>> Cc: Greg KH <gregkh@linuxfoundation.org>
>>> Cc: Linux USB List <linux-usb@vger.kernel.org>
>>> Cc: stable <stable@vger.kernel.org>
>>> Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
>>> Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
>>> Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>>> [jstultz: forward ported to mainline, reworded commit log, reworked
>>>   to only check trb->ctrl as suggested by Felipe]
>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>> ---
>>> v2:
>>> * Rework to only check trb->ctrl as suggested by Felipe
>>> * Reword the commit message to include more of Felipe's assessment
>>> ---
>>>   drivers/usb/dwc3/gadget.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>>> index 154f3f3e8cff..9a085eee1ae3 100644
>>> --- a/drivers/usb/dwc3/gadget.c
>>> +++ b/drivers/usb/dwc3/gadget.c
>>> @@ -2420,7 +2420,8 @@ static int dwc3_gadget_ep_reclaim_completed_trb(s=
truct dwc3_ep *dep,
>>>   	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>>>   		return 1;
>>>=20=20=20
>>> -	if (event->status & DEPEVT_STATUS_IOC)
>>> +	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
>>> +	    (trb->ctrl & DWC3_TRB_CTRL_LST))
>> why the LST bit here? It wasn't there before. In fact, we never set LST
>> in dwc3 anymore :-)
>
> Just a note: right now, it may be fine for non-stream endpoints to not=20
> set the LST bit in the TRBs. For streams, we need to set this bit so the=
=20
> controller know to allocate resource for different transfers of=20
> different streams. It may be fine now if you think that it should be=20
> added later when more fixes for streams are added, but I think it=20
> doesn't hurt checking it now either.

Indeed. Let's keep this version as is if we will need LST for Streams
anyway. Sorry for the noise.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4xMUMACgkQzL64meEa
mQbhSRAAzi4QoZAoRbTkaS3NxcozlZU32espqxd1R5TzPgRdpf1y6scYYelnAcEh
Atw+YNklKaM0zzska86g3NTeV0XEHJ0hZx1Is4j8Ze7Oad1azuNMjjLUAYBYqT1S
UfwVxTJGcbHGg+TDBDWucop/vzKNLv2gvRLv0f3z9ski0h/QC+/V9aCJt/Ke4N6Y
U719p3Ob7PcrLPU7lyOaG4LcyXrzYlqiFVx5wAAWC+wdZIqSp/XdsfZY59IHUajs
000vjcGg+ps+mCYYfUu/1SiFzO6bLqNuJXCeCjWoet1CV1SdSVDNt8NJW/N3df/N
GGyl0HTjhYB9+4o1cehc5c2PaYKpshavAXWzZeotqtzewFz17ojVHb0/bU55FYi9
fEqXMgB3ft4lsWY/QYeTZINVwRXN8FYJWj/+BhU1Si5ptjVKhLizuWxH0Pi9Xhwt
V23qFHAt69kWPnOBii7svXYFEY2vr8ORmeFIjAzOqPUl1WtArR0NvN49H+z7qgyG
l2s+ixpg+uHmExVPaCwXSJKgbTO4iK4xhTjKxLY+9yZRy6DMoi7CiY1DxjEy3+jW
7xCTjMYDOfVunOI7+8Awi32B/I10I139f5rO2TVdt9ZQHjErOEMVYPjm5OGXIkbp
XUvwGONBRPRDVKpzvvT8iF+kQp9FHp1T//JrgqBqvFKCe7egdNo=
=3kxu
-----END PGP SIGNATURE-----
--=-=-=--
