Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A52603320
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 21:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJRTNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 15:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJRTNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 15:13:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E549F28724
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 12:13:33 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1oks1g-0008Oh-7d; Tue, 18 Oct 2022 21:13:20 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1oks1e-0001MU-LA; Tue, 18 Oct 2022 21:13:18 +0200
Date:   Tue, 18 Oct 2022 21:13:18 +0200
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
Message-ID: <20221018191318.GB9097@pengutronix.de>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-3-w36195@motorola.com>
 <20221017213031.tqb575hdzli7jlbh@synopsys.com>
 <Y04K/HoUigF5FYBA@p1g3>
 <20221018184535.3g3sm35picdeuajs@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <20221018184535.3g3sm35picdeuajs@synopsys.com>
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


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thinh,

On Tue, Oct 18, 2022 at 06:45:40PM +0000, Thinh Nguyen wrote:
>On Mon, Oct 17, 2022, Dan Vacura wrote:
>> On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:
>> > On Mon, Oct 17, 2022, Dan Vacura wrote:
>> > > From: Jeff Vanhoof <qjv001@motorola.com>
>> > >
>> > > arm-smmu related crashes seen after a Missed ISOC interrupt when
>> > > no_interrupt=3D1 is used. This can happen if the hardware is still u=
sing
>> > > the data associated with a TRB after the usb_request's ->complete ca=
ll
>> > > has been made.  Instead of immediately releasing a request when a Mi=
ssed
>> > > ISOC interrupt has occurred, this change will add logic to cancel the
>> > > request instead where it will eventually be released when the
>> > > END_TRANSFER command has completed. This logic is similar to some of=
 the
>> > > cleanup done in dwc3_gadget_ep_dequeue.
>> >
>> > This doesn't sound right. How did you determine that the hardware is
>> > still using the data associated with the TRB? Did you check the TRB's
>> > HWO bit?
>>
>> The problem we're seeing was mentioned in the summary of this patch
>> series, issue #1. Basically, with the following patch
>> https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-u=
sb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/__;!!A4F2R9G_pg!=
aSNZ-IjMcPgL47A4NR5qp9qhVlP91UGTuCxej5NRTv8-FmTrMkKK7CjNToQQVEgtpqbKzLU2HXE=
T9O226AEN$
>> integrated a smmu panic is occurring on our Android device with the 5.15
>> kernel which is:
>>
>>     <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled arm=
-smmu context fault from a600000.dwc3!
>>
>> The uvc gadget driver appears to be the first (and only) gadget that
>> uses the no_interrupt=3D1 logic, so this seems to be a new condition for
>> the dwc3 driver. In our configuration, we have up to 64 requests and the
>> no_interrupt=3D1 for up to 15 requests. The list size of dep->started_li=
st
>> would get up to that amount when looping through to cleanup the
>> completed requests. From testing and debugging the smmu panic occurs
>> when a -EXDEV status shows up and right after
>> dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusion
>> we had was the requests were getting returned to the gadget too early.
>
>As I mentioned, if the status is updated to missed isoc, that means that
>the controller returned ownership of the TRB to the driver. At least for
>the particular request with -EXDEV, its TRBs are completed. I'm not
>clear on your conclusion.
>
>Do we know where did the crash occur? Is it from dwc3 driver or from uvc
>driver, and at what line? It'd great if we can see the driver log.
>
>>
>> >
>> > The dwc3 driver would only give back the requests if the TRBs of the
>> > associated requests are completed or when the device is disconnected.
>> > If the TRB indicated missed isoc, that means that the TRB is completed
>> > and its status was updated.
>>
>> Interesting, the device is not disconnected as we don't get the
>> -ESHUTDOWN status back and with this patch in place things continue
>> after a -EXDEV status is received.
>>
>
>Actually, minor correction here: a recent change
>b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")
>changed -ESHUTDOWN request status to -ECONNRESET when disable endpoint.
>This doesn't look right.
>
>While disabling endpoint may also apply for other cases such as
>switching alternate interface in addition to disconnect, -ESHUTDOWN
>seems more fitting there.
>
>Hi Michael,
>
>Can you help clarify for the change above? This changed the usage of
>requests. Now requests returned by disconnection won't be returned as
>-ESHUTDOWN.

When writing the patch, I was looking into
Documentation/driver-api/usb/error-codes.rst.

After looking into it today, I see that ESHUTDOWN should be send on
ep_disable (device disable) and ECONNRESET on stop_active_transfer.
So I probably just mixed them up, while writing the patch. :/

The followup patch would then just be to swap the status results of
__dwc3_gadget_ep_disable and dwc3_stop_active_transfers on the
dwc3_remove_requests call.

Michael

>> >
>> > There's a special case which dwc3 may give back requests early is the
>> > case of the device disconnecting. The requests should be returned with
>> > -ESHUTDOWN, and the gadget driver shouldn't be re-using the requests on
>> > de-initialization anyway.
>> >
>> > We should not issue End Transfer command just because of missed isoc. =
We
>> > may want issue End Transfer if the gadget driver is too slow and unable
>> > to feed requests in time (causing underrun and missed isoc) to resync
>> > with the host, but we already handle that.
>>
>> Hmm, isn't that what happens when we get into this
>> condition in dwc3_gadget_endpoint_trbs_complete():
>>
>> 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
>> 		list_empty(&dep->started_list) &&
>> 		(list_empty(&dep->pending_list) || status =3D=3D -EXDEV))
>> 		dwc3_stop_active_transfer(dep, true, true);
>>
>
>Yes, it's being handled there.
>
>> >
>> > I'm still not clear what's the problem you're seeing. Do you have the
>> > crash log? Tracepoints?
>> >
>>
>> Appreciate the support!
>>
>
>Thanks,
>Thinh

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAmNO+swACgkQC+njFXoe
LGRUPA//VdRHN0Y5t4IiSNNGbrT5CuZ98TI8jKfvSy3kwRBw/dRp9DMlC4GKZZNE
vMCVXuNJT/uO3bsHaH3aYO/0QMNiQV1tloAbiXx/BPyI60+G5ywC+hwxpwS1k2uD
FUxvYBznY8ZDmHYy6G/gR7EbUNzispDvFzyZTyjrYT50VUv/JZBJd/x/Y/5jpP5/
Xy7Cbq8I6s88Y1I3ZfzZMPNOtYYLHcPel72j1Wb/zT/azVDgJjgMpUNxCpIutm+1
3WhKa9PHd2uIIwbSX+tiOpxMrWo31Dut24mTXz/+9fcPgFCLSFHF25c+9nJcZCK+
xnuPINxRYKDkPkrPqAZAUZa26c7GR8usxeitTZ7nLLfYZfJNRKZ8A4ToVGlldAEs
v+uJ22LJ0fx8A+G3QGzDlC2uleZRLhYOm0916ZLk4UGkct+3GQqymI0MrAwfT0oq
D9ByAXyJ8MCIJamwt31oZ/rN53NGT7QMCLOYoojQUiMwJg9vaxk7yiO+HCdApYUx
tKeCshYSIsELdQNMRFDpAoIzZZ4LwHnP57nlgIC1CoIgCG1d0K/cPmKskNP6jbtk
s4sa8SfYNW6gFnC09hE2IxI0moaR6+0tQc2LxH2QMDcEfkswuahTj+OXijPZu0Nk
olG1QdBlLaJAnYlZXcC/k0Vsd4m2T29Rrv/S3hNs4HsHy/0XTGA=
=PxEq
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
