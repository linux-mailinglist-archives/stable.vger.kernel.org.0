Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D699F154B1C
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 19:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgBFSaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 13:30:00 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35510 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbgBFS37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 13:29:59 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so7188046ljb.2;
        Thu, 06 Feb 2020 10:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=or2FSvYPeGpxysPGJhulUEloNPL1ySrePtQNaWEOLHM=;
        b=J3g5fuCyt6sXRWKtX2a3hdqNHrTLV736jNLnZKxMDrO5eqPsh8KarndNS6mpwmceAv
         fTHTjAY7aPcO4yTI3jD8Cjq8Bvvd3TG2crKkRLaa0zRTsT7JHLrJ/tU8ty0AMyrj+kdV
         V5E/LRnocEb7Jlfowe56H8nduwXxmlBujpjCO1HpYXT4RTAhEbbT0mzPhp8KQ4eGtuCV
         nSPEDWExgUta/Az8JpLaQis64nKk3HPlnCgJw39WWVPJm5qu13obZ7/yk5Glnl6GRqkO
         1sj8QDexRK4uxc3orYpUgAnxEVaGqQjF/PcFxqMtXUuIfQo9n1oz89Qq0Bu/Gk8PQqmN
         IFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=or2FSvYPeGpxysPGJhulUEloNPL1ySrePtQNaWEOLHM=;
        b=VnHHG5pUfKVPU2RM9EVPWwP+cLc0egFHtfCdcyySr4CvQkdTuBbV3jVF4IGfKz//yk
         +T90osRBofsIDMUyoWLHaCUiuygN11g8FcXY2AjJ3So3HJYqps6OyiMw+BcUx5wj/wQz
         gHZncP+mujH9h2Votu3udguigsDwaWRkvryHkzt9xcLBBa4to23f5PS26bodL5On5e7+
         WWDLMJ87m8h+6DuaSnQYgzi2RHrx/17Yi7kP0TPoMt0hQ5aQCR5GmFQNlShAHa51SDlY
         nBXDAHwM7T4XtFIk9ZAVNNn9rORJwCpwLgzXQQ2xsJY0pEymXmO66sJYYaLzIAah8+Wc
         IKXA==
X-Gm-Message-State: APjAAAXLQumjefCj8JBlNhJkHEHzFqP+qsQRoxmG3+xgnYioJxEiikDz
        5zNej+Up5jgRevvMzvh2pUw=
X-Google-Smtp-Source: APXvYqz/mqpJexVqnCeK0umiyTQIZnrjFmK9rmcf5zMcoYbMsz8u/eogRsdCGuiiF/5Af8eO125xzw==
X-Received: by 2002:a2e:9256:: with SMTP id v22mr3021010ljg.45.1581013796642;
        Thu, 06 Feb 2020 10:29:56 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id o19sm68298lji.54.2020.02.06.10.29.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 10:29:55 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>,
        John Stultz <john.stultz@linaro.org>
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
In-Reply-To: <20200206074005.GA28365@infradead.org>
References: <20200122222645.38805-1-john.stultz@linaro.org> <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com> <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com> <87o8uu3wqd.fsf@kernel.org> <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com> <87lfpy3w1g.fsf@kernel.org> <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com> <20200206074005.GA28365@infradead.org>
Date:   Thu, 06 Feb 2020 20:29:45 +0200
Message-ID: <87ftfn602u.fsf@kernel.org>
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

Christoph Hellwig <hch@infradead.org> writes:
> On Wed, Feb 05, 2020 at 01:03:51PM -0800, John Stultz wrote:
>> On Thu, Jan 23, 2020 at 9:46 AM Felipe Balbi <balbi@kernel.org> wrote:
>> > >> I'm pretty sure this should be solved at the DMA API level, just wa=
nt to confirm.
>> > >
>> > > I have sent you the tracepoints long time ago. Also my analysis of t=
he
>> > > problem (BTW, I don't think the tracepoints helped much). It's
>> > > basically a logic problem in function dwc3_gadget_ep_reclaim_trb_sg(=
).
>> >
>> > AFAICT, this is caused by DMA API merging pages together when map an
>> > sglist for DMA. While doing that, it does *not* move the SG_END flag
>> > which sg_is_last() checks.
>> >
>> > I consider that an overlook on the DMA API, wouldn't you? Why should D=
MA
>> > API users care if pages were merged or not while mapping the sglist? We
>> > have for_each_sg() and sg_is_last() for a reason.
>> >
>>=20
>> >From an initial look, I agree this is pretty confusing.   dma_map_sg()
>> can coalesce entries in the sg list, modifying the sg entires
>> themselves, however, in doing so it doesn't modify the number of
>> entries in the sglist (nor the end state bit).  That's pretty subtle!
>
> dma_map_sg only coalesces the dma address.  The page, offset and len
> members are immutable.

ok

> The problem is really the design of the scatterlist structure - it
> combines immutable input parameters (page, offset, len) and output
> parameters (dma_addr, dma_len) in one data structure, and then needs
> different accessors depending on which information you care about.
> The end marker only works for the "CPU" view.

right

> The right fix is top stop using struct scatterlist, but that is going to
> be larger and painful change.  At least for block layer stuff I plan to
> incrementally do that, though.

I don't think that would be necessary though.

>> So I'm not sure that sg_is_last() is really valid for iterating on
>> mapped sg lists.
>>=20
>> Should it be? Probably (at least with my unfamiliar eyes), but
>> sg_is_last() has been around for almost as long coexisting with this
>> behavioral quirk, so I'm also not sure this is the best hill for the
>> dwc3 driver to die on. :)
>
> No, it shoudn't.  dma_map_sg returns the number of mapped segments,
> and the callers need to remember that.

We _do_ remember that:

	unsigned int remaining =3D req->request.num_mapped_sgs
		- req->num_queued_sgs;

	for_each_sg(sg, s, remaining, i) {
		unsigned int length =3D req->request.length;
		unsigned int maxp =3D usb_endpoint_maxp(dep->endpoint.desc);
		unsigned int rem =3D length % maxp;
		unsigned chain =3D true;

		if (sg_is_last(s))
			chain =3D false;

		if (rem && usb_endpoint_dir_out(dep->endpoint.desc) && !chain) {

that req->request.num_mapped_sgs is the returned value. So you're saying
we should test for i =3D=3D num_mapped_sgs, instead of using
sg_is_last(). Is that it?

Fair enough. Just out of curiosity, then, when *should* we use
sg_is_last()?

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl48WxwACgkQzL64meEa
mQbQmw//W/0XJp51YHkuN5pjimB9efpoMl4VuIUWDCCIlJ85izbUccIkZ8SVzO0y
gKzPEl24X+sGx/6Lw2zDskgU5H7PTP/st6Q71RgDSK9kI/YNY7yM0OEfLEg3O+FB
dfYmz05hTe261rv6PVzzpMgZP08I+TPO/xxINM60uMjZ6apG2EiZ+sswCVwlhK33
Y7/KOLkAcMkAlq3mNJO1g73TkpJUnXmF+sXyxXU+9X/iP34rFoUbaSozVBygjcht
rtPFPa7Wr0vfNm3uEQTQi+27iTyMbyXYRjSQSqN+MlpEgBFAxWTv/iuvkJ4k6/Fk
bkAi+9yCG2V9XUx3aOuq4dPUFHHyX0xEjUaR09fnDwAiqvRyo/Ib3a4H8Pl/IYf8
pZLlyR7uvmoGZvuQhyELnA+L52mNO4tGm2FUmRdnzShyilpOA1vLjjHEdGx7V1G4
oPh5iG+sB/O0Hchctg0gZtYSQVdpF6J1sbtLqqrsZuC13saZGkHX++MyoDpF03Zr
33SdJ6JMVxarO+ncFE730zrooMFoKfA1P6fIuAKYZEJ9bnf60p80A7oAmFSfcwDP
6smxj5nWzpluKikLnlblDAPJmdpjjd6jovJoVtd8zfbuidhhUr7qkDVqL1zrIzMG
EG4HYDE0r9gTMGqBxcNuRNLDHaAuewAZBfDybrJKrT1WNFbqZC8=
=CcPI
-----END PGP SIGNATURE-----
--=-=-=--
