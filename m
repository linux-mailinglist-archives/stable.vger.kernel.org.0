Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21A086219
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 14:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732424AbfHHMoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 08:44:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:38983 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732254AbfHHMoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 08:44:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 05:43:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,361,1559545200"; 
   d="asc'?scan'208";a="326298207"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga004.jf.intel.com with ESMTP; 08 Aug 2019 05:43:34 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     John Stultz <john.stultz@linaro.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     "fei.yang\@intel.com" <fei.yang@intel.com>,
        "andrzej.p\@collabora.com" <andrzej.p@collabora.com>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated properly
In-Reply-To: <CALAqxLURCLHf3UJsMWKZUirDE9bWNYEhv-sKb01g7cTfCz5tOg@mail.gmail.com>
References: <1563497183-7114-1-git-send-email-fei.yang@intel.com> <CY4PR1201MB003708ADAD79BF4FD24D3445AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com> <CALAqxLURCLHf3UJsMWKZUirDE9bWNYEhv-sKb01g7cTfCz5tOg@mail.gmail.com>
Date:   Thu, 08 Aug 2019 15:43:30 +0300
Message-ID: <87k1bnn7yl.fsf@gmail.com>
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
> On Thu, Jul 18, 2019 at 6:12 PM Thinh Nguyen <Thinh.Nguyen@synopsys.com> =
wrote:
>> fei.yang@intel.com wrote:
>> > From: Fei Yang <fei.yang@intel.com>
>> >
>> > If scatter-gather operation is allowed, a large USB request is split i=
nto
>> > multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN =
bit
>> > except the last one which has DWC3_TRB_CTRL_IOC bit set instead.
>> > Since only the last TRB has IOC set for the whole USB request, the
>> > dwc3_gadget_ep_reclaim_trb_sg() gets called only once after the last T=
RB
>> > completes and all the TRBs allocated for this request are supposed to =
be
>> > reclaimed. However that is not what the current code does.
>> >
>> > dwc3_gadget_ep_reclaim_trb_sg() is trying to reclaim all the TRBs in t=
he
>> > following for-loop,
>> >       for_each_sg(sg, s, pending, i) {
>> >               trb =3D &dep->trb_pool[dep->trb_dequeue];
>> >
>> >                 if (trb->ctrl & DWC3_TRB_CTRL_HWO)
>> >                         break;
>> >
>> >                 req->sg =3D sg_next(s);
>> >                 req->num_pending_sgs--;
>> >
>> >                 ret =3D dwc3_gadget_ep_reclaim_completed_trb(dep, req,
>> >                                 trb, event, status, chain);
>> >                 if (ret)
>> >                         break;
>> >         }
>> > but since the interrupt comes only after the last TRB completes, the
>> > event->status has DEPEVT_STATUS_IOC bit set, so that the for-loop ends=
 for
>> > the first TRB due to dwc3_gadget_ep_reclaim_completed_trb() returns 1.
>> >       if (event->status & DEPEVT_STATUS_IOC)
>> >               return 1;
>> >
>> > This patch addresses the issue by checking each TRB in function
>> > dwc3_gadget_ep_reclaim_trb_sg() and maing sure the chained ones are pr=
operly
>> > reclaimed. dwc3_gadget_ep_reclaim_completed_trb() will return 1 Only f=
or the
>> > last TRB.
>> >
>> > Signed-off-by: Fei Yang <fei.yang@intel.com>
>> > Cc: stable <stable@vger.kernel.org>
>> > ---
>> > v2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_recla=
im_trb_sg()
>> >     and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb=
().
>> > v3: Checking DWC3_TRB_CTRL_CHN bit for each TRB instead, and making su=
re that
>> >     dwc3_gadget_ep_reclaim_completed_trb() returns 1 only for the last=
 TRB.
>> > ---
>> >  drivers/usb/dwc3/gadget.c | 11 ++++++++---
>> >  1 file changed, 8 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> > index 173f532..88eed49 100644
>> > --- a/drivers/usb/dwc3/gadget.c
>> > +++ b/drivers/usb/dwc3/gadget.c
>> > @@ -2394,7 +2394,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(=
struct dwc3_ep *dep,
>> >       if (event->status & DEPEVT_STATUS_SHORT && !chain)
>> >               return 1;
>> >
>> > -     if (event->status & DEPEVT_STATUS_IOC)
>> > +     if (event->status & DEPEVT_STATUS_IOC && !chain)
>> >               return 1;
>> >
>> >       return 0;
>> > @@ -2404,11 +2404,12 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struc=
t dwc3_ep *dep,
>> >               struct dwc3_request *req, const struct dwc3_event_depevt=
 *event,
>> >               int status)
>> >  {
>> > -     struct dwc3_trb *trb =3D &dep->trb_pool[dep->trb_dequeue];
>> > +     struct dwc3_trb *trb;
>> >       struct scatterlist *sg =3D req->sg;
>> >       struct scatterlist *s;
>> >       unsigned int pending =3D req->num_pending_sgs;
>> >       unsigned int i;
>> > +     int chain =3D false;
>> >       int ret =3D 0;
>> >
>> >       for_each_sg(sg, s, pending, i) {
>> > @@ -2419,9 +2420,13 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct=
 dwc3_ep *dep,
>> >
>> >               req->sg =3D sg_next(s);
>> >               req->num_pending_sgs--;
>> > +             if (trb->ctrl & DWC3_TRB_CTRL_CHN)
>> > +                     chain =3D true;
>> > +             else
>> > +                     chain =3D false;
>> >
>> >               ret =3D dwc3_gadget_ep_reclaim_completed_trb(dep, req,
>> > -                             trb, event, status, true);
>> > +                             trb, event, status, chain);
>> >               if (ret)
>> >                       break;
>> >       }
>>
>> There was already a fix a long time ago by Anurag. But it never made it
>> to the kernel mainline. You can check this out:
>> https://patchwork.kernel.org/patch/10640137/
>
> So, back from a vacation last week, and just validated that both Fei's
> patch and a forward ported version of this patch Thinh pointed out
> both seem to resolve the usb stalls I've been seeing sinice 4.20 w/
> dwc3 hardware on both hikey960 and dragonboard 845c.
>
> Felipe: Does Anurag's patch above make more sense as a proper fix?

I think it's enough to check only the TRB. We won't get events for bits
we didn't enable on the TRB. The only problem here is when we get IOC
event for multiple TRBs where only the last one has IOC.

So, instead of checking:

	if (event->status & IOC && trb->ctrl & IOC)

It's probably enough to check:

	if (tbc->ctrl & IOC)

Could you check that?

Cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1MGPIACgkQzL64meEa
mQY12w//SoBl8a0P9l1wQvjbp66d9nq+DfniJ1P0ZR+OZ49AjsagOTTlGxTOUifR
TGtVC346hs1OjMMElsrOIKkfyE8J3yzLxbYzLemDdDw6eY5b0rZjqiAfF5S/zZzq
DyrEH1o+kwKyhCzNvjZIOP3Y/Ugy2XO1J/bDlBcNBtphX8TDpC9p1Dxg6swhRNvp
vX0FQW/MsE+R6wIftW6XG63bYB5aAM+kqQH4j0MR64b2nFGYAWx7WXJsViMCeK58
TnKYLEOtkMe4qXbpYFWwiIsIDTY/w4k9jNvVKreFfyTB/cmE4kL9PtgIg+LhUfK/
phudV1NTCQ6qKeCrgK/zSoT3FLGs5ZxuB60bPL4NFa2PgHeAccC6iwmS+AoMyVK3
FIWaU2HHqoJSV6M11dDHlXtgzvz/IRD5Uk6M1vdXEDMnG4PAD4IqOfinaWSd+s0y
H4Bm+jJfH5y/QmbZhLj64ciybsu9VDGNTvgWWu1vr1dZIn2lvNKWl6jBoG9/1KWq
RFtDWuCgp8cJSZlVHnnTf9q2fVO2DrNYi3WnGhUqp678bhyQjwqwTTQT0kwzrkHc
m0rgfy5R+pTfJmfy8KIF+HdUMFMVeaKEl/GiVJK7JhUqTHyonv6JEssG1m5u2C8L
uJn+WRM9wYpSy6Rjqc6PqlzabRppIPwXqWnoBFMbneUhtVt3YfI=
=SP19
-----END PGP SIGNATURE-----
--=-=-=--
