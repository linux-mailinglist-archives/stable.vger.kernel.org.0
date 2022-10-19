Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C150603A0A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 08:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJSGrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 02:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJSGrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 02:47:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E642D5FF43
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 23:47:04 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ol2qo-0007bV-U5; Wed, 19 Oct 2022 08:46:50 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ol2qm-0006qh-Pw; Wed, 19 Oct 2022 08:46:48 +0200
Date:   Wed, 19 Oct 2022 08:46:48 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Dan Vacura <w36195@motorola.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Message-ID: <20221019064648.GC9097@pengutronix.de>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-3-w36195@motorola.com>
 <20221017213031.tqb575hdzli7jlbh@synopsys.com>
 <Y04K/HoUigF5FYBA@p1g3>
 <20221018184535.3g3sm35picdeuajs@synopsys.com>
 <20221018191318.GB9097@pengutronix.de>
 <20221018224506.g7qv632fznfbprhz@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <20221018224506.g7qv632fznfbprhz@synopsys.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thinh,

On Tue, Oct 18, 2022 at 10:45:16PM +0000, Thinh Nguyen wrote:
>On Tue, Oct 18, 2022, Michael Grzeschik wrote:
>> On Tue, Oct 18, 2022 at 06:45:40PM +0000, Thinh Nguyen wrote:
>> > On Mon, Oct 17, 2022, Dan Vacura wrote:
>> > > On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:
>> > > > On Mon, Oct 17, 2022, Dan Vacura wrote:
>> > > > > From: Jeff Vanhoof <qjv001@motorola.com>
>> > > > >
>> > > > > arm-smmu related crashes seen after a Missed ISOC interrupt when
>> > > > > no_interrupt=3D1 is used. This can happen if the hardware is sti=
ll using
>> > > > > the data associated with a TRB after the usb_request's ->complet=
e call
>> > > > > has been made.  Instead of immediately releasing a request when =
a Missed
>> > > > > ISOC interrupt has occurred, this change will add logic to cance=
l the
>> > > > > request instead where it will eventually be released when the
>> > > > > END_TRANSFER command has completed. This logic is similar to som=
e of the
>> > > > > cleanup done in dwc3_gadget_ep_dequeue.
>> > > >
>> > > > This doesn't sound right. How did you determine that the hardware =
is
>> > > > still using the data associated with the TRB? Did you check the TR=
B's
>> > > > HWO bit?
>> > >
>> > > The problem we're seeing was mentioned in the summary of this patch
>> > > series, issue #1. Basically, with the following patch
>> > > https://urldefense.com/v3/__https://patchwork.kernel.org/project/lin=
ux-usb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/__;!!A4F2R9G=
_pg!aSNZ-IjMcPgL47A4NR5qp9qhVlP91UGTuCxej5NRTv8-FmTrMkKK7CjNToQQVEgtpqbKzLU=
2HXET9O226AEN$
>> > > integrated a smmu panic is occurring on our Android device with the =
5.15
>> > > kernel which is:
>> > >
>> > >     <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled=
 arm-smmu context fault from a600000.dwc3!
>> > >
>> > > The uvc gadget driver appears to be the first (and only) gadget that
>> > > uses the no_interrupt=3D1 logic, so this seems to be a new condition=
 for
>> > > the dwc3 driver. In our configuration, we have up to 64 requests and=
 the
>> > > no_interrupt=3D1 for up to 15 requests. The list size of dep->starte=
d_list
>> > > would get up to that amount when looping through to cleanup the
>> > > completed requests. From testing and debugging the smmu panic occurs
>> > > when a -EXDEV status shows up and right after
>> > > dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusi=
on
>> > > we had was the requests were getting returned to the gadget too earl=
y.
>> >
>> > As I mentioned, if the status is updated to missed isoc, that means th=
at
>> > the controller returned ownership of the TRB to the driver. At least f=
or
>> > the particular request with -EXDEV, its TRBs are completed. I'm not
>> > clear on your conclusion.
>> >
>> > Do we know where did the crash occur? Is it from dwc3 driver or from u=
vc
>> > driver, and at what line? It'd great if we can see the driver log.
>> >
>> > >
>> > > >
>> > > > The dwc3 driver would only give back the requests if the TRBs of t=
he
>> > > > associated requests are completed or when the device is disconnect=
ed.
>> > > > If the TRB indicated missed isoc, that means that the TRB is compl=
eted
>> > > > and its status was updated.
>> > >
>> > > Interesting, the device is not disconnected as we don't get the
>> > > -ESHUTDOWN status back and with this patch in place things continue
>> > > after a -EXDEV status is received.
>> > >
>> >
>> > Actually, minor correction here: a recent change
>> > b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")
>> > changed -ESHUTDOWN request status to -ECONNRESET when disable endpoint.
>> > This doesn't look right.
>> >
>> > While disabling endpoint may also apply for other cases such as
>> > switching alternate interface in addition to disconnect, -ESHUTDOWN
>> > seems more fitting there.
>> >
>> > Hi Michael,
>> >
>> > Can you help clarify for the change above? This changed the usage of
>> > requests. Now requests returned by disconnection won't be returned as
>> > -ESHUTDOWN.
>>
>> When writing the patch, I was looking into
>> Documentation/driver-api/usb/error-codes.rst.
>>
>> After looking into it today, I see that ESHUTDOWN should be send on
>> ep_disable (device disable) and ECONNRESET on stop_active_transfer.
>> So I probably just mixed them up, while writing the patch. :/
>>
>
>I think you mean ECONNRESET for ep_dequeue()?
>dwc3_stop_active_transfer() is called for both scenarios.

No, I meant dwc3_stop_active_transfer*s*.
On ep_dequeue the request status is already ECONNRESET.

>> The followup patch would then just be to swap the status results of
>> __dwc3_gadget_ep_disable and dwc3_stop_active_transfers on the
>> dwc3_remove_requests call.
>>
>> Michael
>
>Can you help make a fix?

Sure, I will write a patch.

Thanks,
Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAmNPnVUACgkQC+njFXoe
LGQkqRAAu2iyKbF8RymKARg3wnUIl8Ow90HwXa7iCjwDRDG17qrO0We7kgao/OMH
ujPosvtWywssQhmiyfYEhQuT1A1pDSu5xLPLw7wDFrBXCL8DlJx5R+x6vHBhXzuT
F99vnjgcYYDHKclu5sGAbKI5K25/+pxaqTN6qrN6DIdEoUKQ+cJBtOZdi2TD80jT
1gVTpWG9pmk22ecqy+b19HQs01ZwQ/gD0L1U/+7rEMeyJDYvK8SrfkYvljz0a8lr
q/9MpbhgkaofpdDfMO+1m2T682FbZGLHTDuLbgVZuq3fARhh1xDLWzeRDVD8+EjQ
Nnl9Y+BSS9VofukR0JNYPVWAY7wjR3kuVGGaj5L/Kxw8n1unkBzu19Wu/DkrOL7b
WIuPaJ78/B7+K8GHnx3vnpX2vbqJ9Z/Nn7/SideEYIjqf6gOp/gdVtvTgRP4FkK6
FcF5lxri08hcR374b5vf4d52fVPoC695xz5pdo1C8CT6gtXn4+zOA4RWLtifqQw3
aXLq3MMGWt0A5Gol8HINuKq+R5CaNlkoeZOF0FS+zzfhOE8uBzfQkzApu+hNZg1j
0QRqaGZBUPiTuSl26a76nenpgpPZXSHdLXSXpOXNfIexxyPVKM+W7Cf89hck1Sf2
6LPVgQesVcJh7An+8Z9U9YNvtnFg0Mm1sEWFTMdzrhRhF1NYsyQ=
=4NAm
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
