Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE415DCE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 09:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfEGHEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 03:04:23 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53150 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726253AbfEGHEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 03:04:22 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9E1BAC01EB;
        Tue,  7 May 2019 07:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557212656; bh=EgwbqrIDlOKeOpANBxfoAqWMx9vfzjNf1QWR72jjXzg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=b2JJ0uEZpxwV/ZjimVefsw3vtZg+1oHCx6CFwFOjKCqnX0hLIBj4+P1+e1jcvrI2D
         VHmYbSe+CfQIsHuolJC7IArw9+mBIEACwZN1oM7h2Io/0ZnKGiWYkIVjfxYb/I/Qgm
         4txVHCjqylH3NA7+w/8ZAQ7+piyWJnp+BjJYJO9o9BlY9FOJfcVNooPhOSXi0sk9xi
         lik5E1IunEivBu8O8haYnFuL9mJZ5zYfpWV5q/azWx/wWdb/gqSzKGSqn3KP/uIoCQ
         2aJWBxLlubPiDY8i/eEz0aucBqlopgc1V/7L6RRg3M5lMCtIPe2iVzz6IoPvh1ZOKs
         eppF4ZH5vDICA==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 77429A005D;
        Tue,  7 May 2019 07:04:18 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 May 2019 00:04:18 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 May 2019 00:04:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coMxPQlhqRphxm2/E3dz+12hZDp8AK8mRhYjpV2DRM8=;
 b=qG5cIp18MbjoTMhIBvWXfOqjdtiNIUvOUM5I+M6k+orJZFhDvSQirz4PNYjANH51oE0EliEfMkbT2aMViL6CXg/PZDPQS+9RJSEXoXr562cyXVTtI3VDA6r3U2sdd4MRmFZViWQBEmgvrBQM87B/4ljd4emexaBK7VAniJbLoPU=
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com (10.172.78.14) by
 CY4PR1201MB0071.namprd12.prod.outlook.com (10.172.79.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Tue, 7 May 2019 07:04:14 +0000
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::ac77:1c39:d9eb:ee9a]) by CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::ac77:1c39:d9eb:ee9a%4]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 07:04:14 +0000
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Laight <David.Laight@aculab.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: RE: [PATCH AUTOSEL 4.14 72/95] devres: Align data[] to
 ARCH_KMALLOC_MINALIGN
Thread-Topic: [PATCH AUTOSEL 4.14 72/95] devres: Align data[] to
 ARCH_KMALLOC_MINALIGN
Thread-Index: AQHVBJd3onwrWwkS2UueAl57c5ZJEaZfKNsAgAATBJA=
Date:   Tue, 7 May 2019 07:04:13 +0000
Message-ID: <CY4PR1201MB01200B5B52E39A88D8D3FDDDA1310@CY4PR1201MB0120.namprd12.prod.outlook.com>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-72-sashal@kernel.org>
 <20190507055214.GA17986@kroah.com>
In-Reply-To: <20190507055214.GA17986@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abrodkin@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d4e5240-4851-49f8-6bb1-08d6d2ba369d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:CY4PR1201MB0071;
x-ms-traffictypediagnostic: CY4PR1201MB0071:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CY4PR1201MB0071D44CC32E9AE1A23DD977A1310@CY4PR1201MB0071.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(39850400004)(346002)(136003)(396003)(13464003)(189003)(199004)(6306002)(6436002)(76176011)(66556008)(66476007)(66446008)(66946007)(14454004)(53936002)(256004)(102836004)(64756008)(26005)(229853002)(66066001)(14444005)(4326008)(561944003)(6246003)(9686003)(33656002)(55016002)(53546011)(186003)(7736002)(74316002)(305945005)(6506007)(7696005)(86362001)(446003)(7416002)(73956011)(3846002)(76116006)(6116002)(71190400001)(2906002)(8676002)(81156014)(8936002)(81166006)(54906003)(68736007)(316002)(110136005)(25786009)(966005)(478600001)(476003)(99286004)(11346002)(71200400001)(52536014)(486006)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0071;H:CY4PR1201MB0120.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CJgi+3NK0BxPX1lgwrovb2wieQILsxdeB+q4gDn49HWQuGlIputy7eaHmpiwnPClHWTm2q67wxDbAB+CcWhFdurxV9e2HOGjEmoEoEjfc/mvmkx3OtnPt00A2LsVpw/NEBdb9aSzAVHBcUqfIy7pmzCU10QjH/95cXTDj0DL/W1y7vapMguLuRyyI6NV5E1+l+gG1Gs5MhsBYPjsexq3hgP3hUmIpqgtrwaDjrJZG1dvDF7qKFStoWn+UKI3rH0/BU10hlmtyXVdKGm8BRJ29FWBXAUhoTINoeUOkCR88/zEmUOubZMK1r7ZC9sEDh2q1pkjbjtnaPMrv5IEc55Ij6AB/s08sHX4TtEdM0AGHJSPCb9u86bRB5nBtfU1iXHzts0CjSF0xds9RBknl0SBYA0HDhcDGqN0nYOL6Bem8JY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4e5240-4851-49f8-6bb1-08d6d2ba369d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 07:04:14.0039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0071
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, May 7, 2019 8:52 AM
> To: Sasha Levin <sashal@kernel.org>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Alexey Brodkin =
<abrodkin@synopsys.com>;
> Alexey Brodkin <abrodkin@synopsys.com>; Geert Uytterhoeven <geert@linux-m=
68k.org>; David Laight
> <David.Laight@aculab.com>; Peter Zijlstra <peterz@infradead.org>; Thomas =
Gleixner
> <tglx@linutronix.de>; Vineet Gupta <vgupta@synopsys.com>; Will Deacon <wi=
ll.deacon@arm.com>; Sasha
> Levin <alexander.levin@microsoft.com>
> Subject: Re: [PATCH AUTOSEL 4.14 72/95] devres: Align data[] to ARCH_KMAL=
LOC_MINALIGN
>=20
> On Tue, May 07, 2019 at 01:38:01AM -0400, Sasha Levin wrote:
> > From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> >
> > [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> >
> > Initially we bumped into problem with 32-bit aligned atomic64_t
> > on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> > mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> > If allocation is done by plain kmalloc() obtained buffer will be
> > ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> > devm_kmalloc() should have any other alignment?
> >
> > This way we at least get the same behavior for both types of
> > allocation.
> >
> > [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__lists.infrade=
ad.org_pipermail_linux-2Dsnps-
> 2Darc_2018-
> 2DJuly_004009.html&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3DlqdeeSSEes0G=
FDDl656eViXO7breS55ytWkhpk5R81I&m=3DA
> YtkWKU38pzVfJMBuK0lUwxRyKT6dDfHoD3yO6OIB5k&s=3De7e2sXKcjHDQdGSrKWM0jmpSOf=
he0MFk4-nMZJe9En8&e=3D
> > [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__lists.infrade=
ad.org_pipermail_linux-2Dsnps-
> 2Darc_2018-
> 2DJuly_004036.html&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3DlqdeeSSEes0G=
FDDl656eViXO7breS55ytWkhpk5R81I&m=3DA
> YtkWKU38pzVfJMBuK0lUwxRyKT6dDfHoD3yO6OIB5k&s=3DL23zrl8rf2MmReUI8rT3FQpMiZ=
U9H3Xjh9uVxJQe8dw&e=3D
> >
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Vineet Gupta <vgupta@synopsys.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: <stable@vger.kernel.org> # 4.8+
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> > ---
> >  drivers/base/devres.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> > index 71d577025285..e43a04a495a3 100644
> > --- a/drivers/base/devres.c
> > +++ b/drivers/base/devres.c
> > @@ -25,8 +25,14 @@ struct devres_node {
> >
> >  struct devres {
> >  	struct devres_node		node;
> > -	/* -- 3 pointers */
> > -	unsigned long long		data[];	/* guarantee ull alignment */
> > +	/*
> > +	 * Some archs want to perform DMA into kmalloc caches
> > +	 * and need a guaranteed alignment larger than
> > +	 * the alignment of a 64-bit integer.
> > +	 * Thus we use ARCH_KMALLOC_MINALIGN here and get exactly the same
> > +	 * buffer alignment as if it was allocated by plain kmalloc().
> > +	 */
> > +	u8 __aligned(ARCH_KMALLOC_MINALIGN) data[];
> >  };
> >
> >  struct devres_group {
>=20
> This is not needed in any of the older kernels, despite what the stable@
> line said, as it ends up taking a lot of memory up for all other arches.
> That's why I only applied it to the one kernel version.  I'm betting
> that it will be eventually reverted when people notice it as well :)

That very well might become the case but then we're back to the initial pro=
blem,
right? So maybe some other more future-proof solution should be implemented=
?

See initially we discussed simple explicit 8-byte alignment which won't cha=
nge
data layout for most of arches while fixing our issue on ARC but for some r=
eason
people were not happy with that proposal and that's how we ended-up with wh=
at we
discuss here now.

-Alexey
