Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0DC29A920
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 11:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897376AbgJ0KIV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Oct 2020 06:08:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25146 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2897373AbgJ0KIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 06:08:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-10-spQj8nqQMeKdMjcMxMOtJw-1; Tue, 27 Oct 2020 10:08:14 +0000
X-MC-Unique: spQj8nqQMeKdMjcMxMOtJw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 27 Oct 2020 10:08:14 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 27 Oct 2020 10:08:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Chen' <peter.chen@nxp.com>, Felipe Balbi <balbi@kernel.org>
CC:     "pawell@cadence.com" <pawell@cadence.com>,
        "rogerq@ti.com" <rogerq@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jun Li <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Thread-Topic: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Thread-Index: AQHWo6WTaRKfd0hXEU6nD+tea3QI1qmrOMeAgAAMjoCAAARbMA==
Date:   Tue, 27 Oct 2020 10:08:13 +0000
Message-ID: <503122a794a346da84d2554150e8deb3@AcuMS.aculab.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-2-peter.chen@nxp.com> <871rhkdori.fsf@kernel.org>
 <20201027094825.GA5940@b29397-desktop>
In-Reply-To: <20201027094825.GA5940@b29397-desktop>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen
> Sent: 27 October 2020 09:49
> 
> On 20-10-27 11:03:29, Felipe Balbi wrote:
> >
> > Hi,
> >
> > Peter Chen <peter.chen@nxp.com> writes:
> > > For code:
> > > trb->length = cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size)
> > > 	       	| TRB_LEN(length));
> > >
> > > TRB_BURST_LEN(priv_ep->trb_burst_size) may be overflow for int 32 if
> > > priv_ep->trb_burst_size is equal or larger than 0x80;
> > >
> > > Below is the Coverity warning:
> > > sign_extension: Suspicious implicit sign extension: priv_ep->trb_burst_size
> > > with type u8 (8 bits, unsigned) is promoted in priv_ep->trb_burst_size << 24
> > > to type int (32 bits, signed), then sign-extended to type unsigned long
> > > (64 bits, unsigned). If priv_ep->trb_burst_size << 24 is greater than 0x7FFFFFFF,
> > > the upper bits of the result will all be 1.
> >
> > looks like a false positive...
> >
> > > Cc: <stable@vger.kernel.org> #v5.8+
> > > Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> > > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > > ---
> > >  drivers/usb/cdns3/gadget.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/usb/cdns3/gadget.h b/drivers/usb/cdns3/gadget.h
> > > index 1ccecd237530..020936cb9897 100644
> > > --- a/drivers/usb/cdns3/gadget.h
> > > +++ b/drivers/usb/cdns3/gadget.h
> > > @@ -1072,7 +1072,7 @@ struct cdns3_trb {
> > >  #define TRB_TDL_SS_SIZE_GET(p)	(((p) & GENMASK(23, 17)) >> 17)
> > >
> > >  /* transfer_len bitmasks - bits 31:24 */
> > > -#define TRB_BURST_LEN(p)	(((p) << 24) & GENMASK(31, 24))
> > > +#define TRB_BURST_LEN(p)	(unsigned int)(((p) << 24) & GENMASK(31, 24))
> >
> > ... because TRB_BURST_LEN() is used to intialize a __le32 type. Even if
> > it ends up being sign extended, the top 32-bits will be ignored.
> >
> > I'll apply, but it looks like a pointless fix. We shouldn't need it for stable
> >
> At my v2:
> 
> It is:
> #define TRB_BURST_LEN(p)	((unsigned int)((p) << 24) & GENMASK(31, 24))
> 
> It is not related to high 32-bits issue, it is sign extended issue for
> 32 bits. If p is a unsigned char data, the compiler will consider
> (p) << 24 is int, but not unsigned int. So, if the p is larger than
> 0x80, the (p) << 24 will be overflow.
> 
> If you compile the code:
> 
> unsigned int k = 0x80 << 24 + 0x81;
> 
> It will report build warning:
> warning: left shift count >= width of type [-Wshift-count-overflow]

Something like:
#define TRB_BURST_LEN(p)  (((p) + 0u) << 24)
will remove the warning.

The GENMASK() is pretty pointless - the compiler may fail to optimise
it away.
If p is 64bit the high bits should get discarded pretty quickly.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

