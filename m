Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6B6E1B3
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 09:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfGSH2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 03:28:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:58150 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfGSH2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 03:28:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 00:28:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="asc'?scan'208";a="187944515"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jul 2019 00:28:01 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     "Yang\, Fei" <fei.yang@intel.com>,
        "john.stultz\@linaro.org" <john.stultz@linaro.org>,
        "andrzej.p\@collabora.com" <andrzej.p@collabora.com>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] usb: dwc3: gadget: trb_dequeue is not updated properly
In-Reply-To: <02E7334B1630744CBDC55DA8586225837F8DD883@ORSMSX102.amr.corp.intel.com>
References: <1563396788-126034-1-git-send-email-fei.yang@intel.com> <87o91riux9.fsf@linux.intel.com> <02E7334B1630744CBDC55DA8586225837F8DD883@ORSMSX102.amr.corp.intel.com>
Date:   Fri, 19 Jul 2019 10:27:57 +0300
Message-ID: <87muhascua.fsf@linux.intel.com>
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

"Yang, Fei" <fei.yang@intel.com> writes:

Hi,

>> Can only be true for last TRB
>>
> | 	if (event->status & DEPEVT_STATUS_IOC)
> | 		return 1;
>
> This is the problem. The whole USB request gets only one interrupt
> when the last TRB completes, so dwc3_gadget_ep_reclaim_trb_sg() gets
> called with event->status =3D 0x6 which has DEPEVT_STATUS_IOC bit
> set. Thus dwc3_gadget_ep_reclaim_completed_trb() returns 1 for the
> first TRB and the for-loop ends without having a chance to iterate
> through the sg list.

IOC is only set for the last TRB, so this will iterate over and over
again until it reaches the last TRB. Please collect tracepoints of the
failure case.

>> If we have a short packet, then we may fall here. Is that the case?
>
> No need for a short packet to make it fail. In my case below, a 16384
> byte request got slipt into 4 TRBs of 4096 bytes. All TRBs were
> completed normally, but the for-loop in
> dwc3_gadget_ep_reclaim_trb_sg() was terminated right after handling
> the first TRB. After that the trb_dequeue is messed up.

I need tracepoints to se what's going on, please collect tracepoints.

> buffer_addr,size,type,ioc,isp_imi,csp,chn,lst,hwo
> 0000000077849000, 4096,normal,0,0,1,1,0,0
> 000000007784a000, 4096,normal,0,0,1,1,0,0
> 000000007784b000, 4096,normal,0,0,1,1,0,0
> 000000007784c000, 4096,normal,1,0,1,0,0,0
> 000000007784d000, 512,normal,1,0,1,0,0,0
>
> My first version of the patch was trying to address the issue in
> dwc3_gadget_ep_reclaim_completed_trb(), but then I thought it's a bad
> idea to touch this function because that is also called from non
> scatter_gather list case, and I was not sure if returning 1 for the
> linear case is correct or not.

That function *must* be called for all cases. We want to reduce the
amount of special cases so code is more straight forward and easier to
maintain. Again, please collect tracepoints of the failure case with the
latest tag from Linus, otherwise you won't be able to convince me we
need your patch.

I also think your version is the wrong way to sort it out.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl0xcP0ACgkQzL64meEa
mQa+BRAApybjl0kw74kvUCbgq5JoZMjTCG8mNVR2WL2+gE9qRwGiJ00aSJakl06A
EH2CUWRGDNzuGyQCajC/GHLl8ZC+yLK5Qu5OSXelZU6k4Ghd9kAfqN57zLbuH6fa
I2nVdhAehADII/57+s1E86s5d3BctlNd4qZi72dK9GvH55IukzeZWotWiIxUH1F7
zO5NxKvFV1EIOa/PezcE2bdnbsrzCs6uCySYGlWYDTP2fEfm9XK7/L5/kQGJYpVJ
0yORd/HLvNPq3bjBPCNOkCkQ3TTv2uc9ybKwlTlPufRET7uTtQD0F8ZRqoGxWZ0j
8OiSwYcEnzOWhA+o4RpX1XfIkMug75hlsV2BKrTsR9z7e/+isNro6tFqAu/xp/k0
pRHIHnmDFmkHX9OmwbUQZbBAZGsxm2WB6yh3sqVW0eWQnzlS4TelUu568Nk9La6y
Jdv6BocpfZ0C3VvvTAxQMncqA4zRiFQZ4ZcFxcJBZzloMn3dBW2bKycpJZkoX1bG
jyaIKvANmbKjdtdYFWmOsgMNaFCYQvTWHHCBwybskX6lI/0lgmgYx5z72GJ0VTQ9
THlw7VRPF6u4HXwWd0cSfQFnL5kPRLOzj6i82mhOXZLRQFEHWIMhz8ayKzcQPqh3
pafP951OscsQdOvOc2tT6lRaItN9j4fIoSuPy7iKlJSOYKWrqyc=
=YdDN
-----END PGP SIGNATURE-----
--=-=-=--
