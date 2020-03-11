Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84054181140
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 07:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgCKG5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 02:57:19 -0400
Received: from mail-eopbgr130049.outbound.protection.outlook.com ([40.107.13.49]:59366
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728146AbgCKG5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 02:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IErk57yBk8oCl9lxM65xUUVN01Nd6PgL3BeCOvpOwpuLJcj1yIC7SMDUurmyBEpaiSTF4oDOVKfy4JOpktAYkjat1FamgftBSpOOzBiSOKKnUCAE8jAJkfvRdwhGPrBUdW8v1n37Az2YaRglI55fcoJQnC8eHLNvVDwZJwPSPWI/60w0tiS3NyTQZg0dl0bWQFaN+ToTNqMmIZEcq6T9m9Ed3uIpR28iUVkxtjZcw6rw1clSGV6ueQYbZX711uEiyYgkpPtDbr7K7/q54K0SEI0DKsObckufelzunx2ct3hkzVfm9peAuS1zq/Vu4E5VtyohF8G/uPcN6HMsGtqdDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7n5biIAWBoEeWqRqmtEx+gvqjul77DmHlkUBorcj88=;
 b=gPJ1Szk6ALDBgt6zIfccTZc0wtKq+BMNhxZUWb2GSUMMjKYZZ6gfHJGN7BhCB0hJbCsI4sRxDWdDz5JKUIJZGibnvtfqmRhRQQGRjv7xZw5PM2rU5bunfqGM+Q0H0+W6SulLwhfAZnbeN+KQ1cwTKHa548b2M9qwg0t+HDYqFUDKogI9Sx0hPC8JCCFaLqAPv6zq2NB6wYOq4KFr4wxSNtXmhMDO/VgUR2SFrLCjm71LLCQbZ8t1YFDrYbDguTHT8EYrR0R0hR5ASyNZuRQKwJoxsipFgS1sQ5auODf65PS0TsmmRuDi0e0qUgExG0y5TzDat/mpZoZ6yKIQdwGiaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7n5biIAWBoEeWqRqmtEx+gvqjul77DmHlkUBorcj88=;
 b=Zp/3LKiKBX2TnyPUiPcpNqJMT60ayLwnWboDxMjf+Wz/l269bL8czzYRrEjceR+ENkpHbe3G9kaP04NJvy9BiQQ0dFb4s+4C6sxqNJGBh/J3QLXr3UAEOLykqiRmzACucHvOd1j57PZ97uXoZKCkEjv+Xmcxnp/4Ku5bA5jF0gk=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.51.23) by
 VI1PR04MB4126.eurprd04.prod.outlook.com (52.133.15.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 06:57:14 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::9547:9dfa:76b8:71b1]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::9547:9dfa:76b8:71b1%7]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 06:57:13 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Peter Chen <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: chipidea: udc: fix sleeping function called from
 invalid context
Thread-Topic: [PATCH 1/1] usb: chipidea: udc: fix sleeping function called
 from invalid context
Thread-Index: AQHV9ql8rcHRmNGQB02024Fh/roZ36hB2jYAgAEdEAA=
Date:   Wed, 11 Mar 2020 06:57:13 +0000
Message-ID: <20200311065716.GC14625@b29397-desktop>
References: <20200310065926.17746-2-peter.chen@kernel.org>
 <Pine.LNX.4.44L0.2003100952060.1651-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.2003100952060.1651-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc8c65c1-9c3f-4788-c44f-08d7c5896dcd
x-ms-traffictypediagnostic: VI1PR04MB4126:
x-microsoft-antispam-prvs: <VI1PR04MB41263201FF0BB8F92949E1028BFC0@VI1PR04MB4126.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(366004)(136003)(346002)(39860400002)(376002)(396003)(199004)(81156014)(6916009)(86362001)(8676002)(81166006)(8936002)(54906003)(33656002)(64756008)(66476007)(316002)(5660300002)(478600001)(66446008)(66556008)(91956017)(76116006)(66946007)(1076003)(33716001)(2906002)(26005)(6486002)(186003)(44832011)(6512007)(9686003)(6506007)(53546011)(4326008)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4126;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUUHRTh/iLjN8yN9y0SoyWX+juJxJa+Ajo45nyjYkWwBOLzMUpAbrzCW93hFU/PCccncJOHvqrMdDRIf/Y8GSFpHjeewz/0JFWtW4fzCpVEq7jyrI1Pq4lo8zP/smtiuYc3Y5FXaj2nGelI5wQUxPyVAlC31+461Sm0eBvYO8j3Bl9XADD/DU29ofXOavHmLXfmHRyZyDbbVrx7NvIdb0jpJu9KNhlHNzI/DGFHYvAKjyYgz7iOBDvnL9NVXn9Yzjo5+1k/dnRfTaPmXBGC4VQHXxckHtrbevKIUEkza7f8ocEN8bbn4y+cd5kQ6DVOTX01Khq1RICKxYJAzWbCsgPa5l41bn0G9v/yKY70sbA8LmILIw5Db478yCWJqD5RNVwi9cuE4dhQbNrUa9Vb4wUvF3pVCZrn8RVZKcNqRxq/OmZqKz6WjPR8TjnExWHaA
x-ms-exchange-antispam-messagedata: 4e8TxAqSo9EF5ZEczx0i3pfELNX6mCCgKDWLvm0FE8VQdChKiIH39o/PF7DPTszw+azlcL6O+o9ieOJhuWvzvS2kTf1rMInFvxOofuhCAi/tv65jRo07fFEMiSC/9MN+ei7Zjl8Q6T6fTjr1uBmMgg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5944D057279ABB46BA11D5968E75C684@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8c65c1-9c3f-4788-c44f-08d7c5896dcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 06:57:13.8888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BqUmIbBR4BAVCL+GjCjA3kS+dZj+YbCdJBk7SJgj5qI3kt8JJwZ6WPAN5zLUd5JuwZnpYJ7k+ui1bqFqvt7ohA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4126
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-03-10 09:57:00, Alan Stern wrote:
> On Tue, 10 Mar 2020, Peter Chen wrote:
>=20
> > From: Peter Chen <peter.chen@nxp.com>
> >=20
> > The code calls pm_runtime_get_sync with irq disabled, it causes below
> > warning:
> >=20
> > BUG: sleeping function called from invalid context at
> > wer/runtime.c:1075
> > in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid:
> > er/u8:1
>=20
> ...
>=20
> > Tested-by: Dmitry Osipenko <digetx@gmail.com>
> > Cc: <stable@vger.kernel.org> #v5.5
> > Fixes: 72dc8df7920f ("usb: chipidea: udc: protect usb interrupt enable"=
)
> > Reported-by: Dmitry Osipenko <digetx@gmail.com>
> > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > ---
> >  drivers/usb/chipidea/udc.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> > index ffaf46f5d062..1fa587ec52fc 100644
> > --- a/drivers/usb/chipidea/udc.c
> > +++ b/drivers/usb/chipidea/udc.c
> > @@ -1539,9 +1539,11 @@ static void ci_hdrc_gadget_connect(struct usb_ga=
dget *_gadget, int is_active)
> >  		if (ci->driver) {
> >  			hw_device_state(ci, ci->ep0out->qh.dma);
> >  			usb_gadget_set_state(_gadget, USB_STATE_POWERED);
> > +			spin_unlock_irqrestore(&ci->lock, flags);
> >  			usb_udc_vbus_handler(_gadget, true);
> > +		} else {
> > +			spin_unlock_irqrestore(&ci->lock, flags);
> >  		}
> > -		spin_unlock_irqrestore(&ci->lock, flags);
>=20
> There's something strange about this patch.
>=20
> Do you really know that interrupts will be enabled following the=20
> spin_unlock_irqrestore()?  In other words, do you know that interrupts=20
> were enabled upon entry to this routine?
>=20
> If they were, then why use spin_lock_irqsave/spin_unlock_irqrestore? =20
> Why not use spin_lock_irq and spin_unlock_irq?
>=20

This function is called at process context, so the interrupt is
enabled, I will use spin_lock_irq, thanks, Alan.

--=20

Thanks,
Peter Chen=
