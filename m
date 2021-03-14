Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0807133A35D
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 07:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhCNGgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 01:36:33 -0500
Received: from mail-eopbgr1410045.outbound.protection.outlook.com ([40.107.141.45]:65344
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229539AbhCNGgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Mar 2021 01:36:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbsxWTb3bIN5/7xsd+apZ31vaaQ8NNN8T5cgKKxvqTgM3y17ldCUC8I4NB/vdNHmZAkBY7KObXqZhsPvtVj0ndaLJsiGvVEpdORollqOIytA7EQ5wMQI/kHVbilVFTT36ZZg5AXcT2888DtNrXlBcITIKYsTHz4t6r1Araypb6Kn2zx94+r8bNV8lwzF2Rr0jXW5rLhmDUv26U7Kq2dygr61t/JF67webJJYHCushWh27sM+KtvtpwzAmP3eJs37anT7EXfNejqSceuBsFz3leqN0NpNc6uqkSHZi3aSRSMg+Kpq/7bWJ7OghmTqnKxfncut9s6CwGffUnd07MgB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0WAL9fdO8WMPtv1RuL42GvBSznnX7sXoWtTIr2mtKA=;
 b=P9NeBRMhFMtq6+akazz/Y0JmzS1upsSyHJfLaIMzAl4mithPmmCsCvpLggqgFIkDYArcI930PKSLNi/SYUvHiVlNSRdtqC7us8/aYC4U4bbEJX4gW0zK/SKlj4zOMwm0+eZ19eIwZh00v+A9jrF6A3iaOh2BUy+al7po+WbMlDoMj49dZC0gAwHeDySjcYqfy7KJM/d83wvIVsPrmjfa+AJQQwyIOwgN3ApgUR5MeQPnn/vZDSb7rlURkKsSDERYRuDkspscGkJ+8ZNt4jq6UCsFHx8M2iUqiTQ23E7TiSWUMICqfHJHIY0R5HXQrC5chOOKLtOKxKO1ni+rTBNSpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0WAL9fdO8WMPtv1RuL42GvBSznnX7sXoWtTIr2mtKA=;
 b=KiMXwO5Xuidj3t+fe36W1658XDpm3tUwLQJxcYvs1S9J97TG17gGEDHhc/3oGVF4WMn0DNN4z3rDciJLbtNBGKvB/xxkbl8VY8Hn+eMPgoVu5FRO84rnZWkE13YUx+nEwhW7sGHW7HIElvf9OXbBrfxA+mb+t/KBiLHhGfMkHXc=
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com (2603:1096:403:8::12)
 by TYAPR01MB5353.jpnprd01.prod.outlook.com (2603:1096:404:803d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sun, 14 Mar
 2021 06:36:24 +0000
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::1552:1791:e07c:1f72]) by TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::1552:1791:e07c:1f72%7]) with mapi id 15.20.3933.032; Sun, 14 Mar 2021
 06:36:23 +0000
From:   =?iso-2022-jp?B?SE9SSUdVQ0hJIE5BT1lBKBskQktZOH0hIUQ+TGkbKEIp?= 
        <naoya.horiguchi@nec.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 23/29] mm, hwpoison: do not lock page again when
 me_huge_page() successfully recovers
Thread-Topic: [patch 23/29] mm, hwpoison: do not lock page again when
 me_huge_page() successfully recovers
Thread-Index: AQHXF8boTtvsCAYdzEaKTTeWAlx09qqCTTEAgAC4n4A=
Date:   Sun, 14 Mar 2021 06:36:23 +0000
Message-ID: <20210314062427.GA30930@hori.linux.bs1.fc.nec.co.jp>
References: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
 <20210313050820.EoPGLS3gj%akpm@linux-foundation.org>
 <CAHk-=wht_gk_d9k+NZs7eJvBeLOQT4xGcykgaCRHuiQ+LbReRw@mail.gmail.com>
In-Reply-To: <CAHk-=wht_gk_d9k+NZs7eJvBeLOQT4xGcykgaCRHuiQ+LbReRw@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=nec.com;
x-originating-ip: [165.225.110.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e152ccdf-33ba-433f-5cb8-08d8e6b37cbc
x-ms-traffictypediagnostic: TYAPR01MB5353:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB53535313F17E69D53514D427E76D9@TYAPR01MB5353.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fR05BEE7lqYSALb0uY/DHRmaQnMxpSLwQirCSJ4lLNjfP3d4VQIjAOUIIR8jvB+m2YQ0cmIIHNsRnJUjoY/BgOZGnvQ+T0x2lrnqHr23x6GZOuMgvJSmsPBq7/Zyms8psNojp2n4YMOOQj8e0dPDZBmny7kt58SHs/jHHlmTVDYm4R3F1RqhTIKO/IIDHsb2DzZbjleq33oz83y8cliChR6MeR/9GShGLpf9Y6Qty/EL6L4bfm4Jt8IP70+cXe+7KwnS5AASnOq8LqQborkr/YXGYaR10SHn9cAaS7v4emErZ3t/zc1sK6akh6bvGyRpufIU0bQKbm+i/aNukqJrHhhbcRY7yaCp5+Omeo86PwEGvsZ7fP2KGoBiXwTg3vC6WVD9tn7Pc3tPD5RyIKUA2Et9GYgQO28cFfIf72M48HX9e7Ws/ai/E8m+cD+zEmTbrBLwDFnN6xT8QpkK6189RaV/TzZF4meUOXUL3Er2dlfnzCl70sIlcaRfB+vG3sbq0TWzurAjtYHwkYCyKmSZKPERUlftK+FsC9IfOh58RPVln/ETI48WTB1lEEuHWMsC+8Z6fCNhkiTYEumKPoF+AKL0YSyiXpAv+sjp0undIbw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1852.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(5660300002)(9686003)(66446008)(54906003)(6916009)(6512007)(8676002)(76116006)(8936002)(64756008)(26005)(66946007)(66476007)(66556008)(86362001)(53546011)(186003)(55236004)(1076003)(478600001)(2906002)(316002)(33656002)(83380400001)(4326008)(71200400001)(6486002)(6506007)(85182001)(14583001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?aUw1ajZ5R1AzYkZpWlFuUGMyTm9Xb0hYS3NRZno0OXo5SktzVE5BdGcz?=
 =?iso-2022-jp?B?N0RNem1XM2JPd0lLVGQrWi9PZWxGdDNYbDFhL0EyYzJ2VWJMT2JtbGt4?=
 =?iso-2022-jp?B?VlpyUUFwemFHTlVkOUoyWlhpYUlyempLaEhmaVMwRFdsY2tPTnhkZ09O?=
 =?iso-2022-jp?B?MDhjdXEvL2hBS3dwaE5Bc3lMRlI5ZGEzSjJseHBWeE8rRU4velphU3NS?=
 =?iso-2022-jp?B?dmRpWHZSZ3hmU1RBVWxwV1A2a0RROWMxVlVzVDE4b2xTTit3Y3pGT3Zs?=
 =?iso-2022-jp?B?YzFQWFZidnc5R0h0d1M3SDl6VFVidGN4Slp0aTEzSTJXSUNnTTBUVnFG?=
 =?iso-2022-jp?B?VndET1BGaHRBMXdRTFcwOVg1aXpyNUcxT1ZRV2NoazErOFhwSXEvcVJx?=
 =?iso-2022-jp?B?TTNtRFVnbk5XM3AvelFTOWtJVjJBcVh5SklqU2QrbUZDMnR6dGh4QXha?=
 =?iso-2022-jp?B?VVhJQzJVVlk2cE84d0sxczM1bzMzSFJwV3ljaEpYdXNqZFFOeDl6WWo4?=
 =?iso-2022-jp?B?NiswS2xrVkFlN21VLzlIRi9kN3FCL0tLdTR1UDdLNWJLZVBQY0VOd0Q1?=
 =?iso-2022-jp?B?VDMwSWpMdW1reTB0bnNMZGhPNU1QK3NWUy9haS8xSnAraG1ScFJBSVNO?=
 =?iso-2022-jp?B?TjFYVWlhZCtTS21QQmczOXM4cVpYZ1lnRnJ4cXlMWFdpNzVOWlRETTdj?=
 =?iso-2022-jp?B?amQrOXBRdDlBTjR0c2lGR3Q4TlZXWEljNWY5VFVTbmZMdXZrdzdxZnlB?=
 =?iso-2022-jp?B?SHJVa0psVjFqTlRPU1hRbHc3cjlqQWJzTThkUDZ1TGd0RGFVRGpiWGdw?=
 =?iso-2022-jp?B?elZuOGhPV21WYTdpY2xRR3NaeUduQlFlWmRDWjF0RURaVlNBeFZ2enFD?=
 =?iso-2022-jp?B?RVE0TG5wU2o5cHEwZXRSL0V3N2dWSWwyYTNBeGR4U3JuM1d6YkZYVWxt?=
 =?iso-2022-jp?B?MzI1Z1M3QVZoQkNFOW5KNlN6T21aVlpZWFNqU3NNWUdJUkQ0dCtXbGRT?=
 =?iso-2022-jp?B?VGsvZjdzaEtvV0FTekR0OHRNOEo2YmRnL2paYm5oSTVtYVFLU3RDUWg2?=
 =?iso-2022-jp?B?T3pJalowMFM1OUY1UnRoVk1MTllxZjNJMlVxRFVZZDlHeFoyRyszY2Ja?=
 =?iso-2022-jp?B?VmhrYWl1QnpLY2hKazBIM2xJSGg0cER1cGREYkpXWkFZQ3o2OEpkK2l5?=
 =?iso-2022-jp?B?OVQ0MnJHZjFZNkdaVTlVNGl5dUwyKzRKTG1NdktmMFdsdmdWdlhpNlZN?=
 =?iso-2022-jp?B?aFBmYWJ2ZUdZZzd2eXVNQ2ExTVZZM2JsdlJEZXNTWVpmYXFYWXphejhI?=
 =?iso-2022-jp?B?UmNzNnZOclZSMW44THBKNlBSYUJTdHhxTnhWVlJXcFVqOGJBN0s4WVA0?=
 =?iso-2022-jp?B?UmpaMUdGN01nbnVPeUJlWi95aFMzbGlubVVUSkVaNDZaQ0VTQmlSSUN2?=
 =?iso-2022-jp?B?N2w3RlY2OE1LZlFNRnVRYk5LNEpUenhId2h0NXk1YzBadXhiSU1UVlY3?=
 =?iso-2022-jp?B?RkhQZ1ZjTFVGVmlpamh2eU1raVM4RVJtM25DaWRwVXIyaCtTK2wyTGpC?=
 =?iso-2022-jp?B?VUUzSCtZbDdnKzJrS3I0OWw3Q0o0UEdtbCtNWG5jL2oxaWFLclRpOU9q?=
 =?iso-2022-jp?B?UzBIUExsM1dsU2trQzBzTU1Sb1lnaU9wR1YzMVZOaTRuWTJXaVNWKzgy?=
 =?iso-2022-jp?B?VUFWSzVxdkx4ZUpDN3lBTWVtVlRLK0F6QUw1SU9VVWVabTRWNm93aUtM?=
 =?iso-2022-jp?B?MmpUeVpSMHNENXl3M1Rtd0h2TSsyT3hRL1NwOUhOS25iNGdLdHVFd0s2?=
 =?iso-2022-jp?B?TUYvWFVrTlV4NzZZenVtWGd2WjBGSnNTRXFab0g2Ym9xK09iK3RBSDZU?=
 =?iso-2022-jp?B?MWVjQmg5R1VxdEdubkJzOVY2eTBpU3poaksweXFaVjRnNkVOMHN2TXVD?=
 =?iso-2022-jp?B?MUsrVkpPem5CeWlkM1pIbE1PUm9WUT09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <6CDF636B184DFD41B2152CE2C94CD6CC@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1852.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e152ccdf-33ba-433f-5cb8-08d8e6b37cbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2021 06:36:23.8039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rhursvxs62gvb/R02L9Uh8gdJsjOaC5MeEbn8unqzWflB/3Nz8h5E+XuYM/i+iKyQOn96Gvf/A8hV5rUVcFJJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5353
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 11:23:40AM -0800, Linus Torvalds wrote:
> On Fri, Mar 12, 2021 at 9:08 PM Andrew Morton <akpm@linux-foundation.org>=
 wrote:
> >
> > From: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > Subject: mm, hwpoison: do not lock page again when me_huge_page() succe=
ssfully recovers
>=20
> This patch can not possibly be correct, and is dangerous and very very wr=
ong.
>=20
> >  out:
> > -       unlock_page(head);
> > +       if (PageLocked(head))
> > +               unlock_page(head);
>=20
> You absolutely CANNOT do things like this. It is fundamentally insane.
>=20
> You have two situations:
>=20
>  (a) you know you locked the page.
>=20
>      In this case an unconditional "unlock_page()" is the only correct
> thing to do.
>=20
>  (b) you don't know whether you maybe unlocked it again.
>=20
>      In this case SOMEBODY ELSE might have locked the page, and you
> doing "if it's locked, then unlock it" is pure and utter drivel, and
> fundamentally and seriously wrong. You're unlocking SOMEBODY ELSES
> lock, after having already unlocked your own once.
>=20
> Now, it is possible that this kind of pattern could be ok if you
> absolutely 100% know - and it is obvious from the code - that you are
> the only thread that can possibly access the page. But if that is the
> case, then the page should never have been locked in the first place,
> because that would be an insane and pointless operation, since the
> whole - and only - point of locking is to enforce some kind of
> exclusivity - and if exclusivity is explicit in the code-path, then
> locking the page is pointless.
>=20
> And yes, in this case I can see a remote theoretical model: "all good
> cases keep the page locked, and the only trhing that unlocks the page
> also guarantees nothing else can possiblly see it".
>=20
> But no. I don't actually believe this is fuaranteed to the case here,
> and even if it were, I don't think this is a code sequence we can or
> should accept.
>=20
> End result: there is no possible situation that I can think of where the =
above
>=20
>        if (PageLocked(head))
>                unlock_page(head);
>=20
> kind of sequence can EVER possibly be correct, and it shows a complete
> disregard of everything that locking is all about.
>=20
> Now, the memory error handling may be so special that this effectively
> "works" in practice, but there is no way I can apply such a
> fundamentally broken patch.

OK, I'll update the patch with the second approach you mentioned below.

>=20
> I see two options:
>=20
>  - make the result of identify_page_state() *tell* you whether the
> page was already unlocked (and then make the unlock conditional on
> *that*)
>=20
>    This is valid, because now you removed that whole "somebody else
> might have transferred the lock" issue: you know you already unlocked
> the page based on the return value, so you don't unlock it again.
> That's perfectly valid.
>=20
>  - probably better: make identify_page_state() itself always unlock
> the page, and turn the two different code sequences that currently do
>=20
>         res =3D identify_page_state(pfn, p, page_flags);
>   out:
>         unlock_page(head);
>         return res;
>=20
> into just doing
>=20
>         return identify_page_state(pfn, p, page_flags);
>   out:
>         unlock_page(head);
>         return -EBUSY;
>=20
> instead, and move that now pointless "res" variable into the only
> if-statement that actually uses it (for other things entirely! It
> should be a "enum mf_result" there!)
>=20
> And yes, that second (and imho better) rule means that now
> {page_action()" itself needs to be the thing that unlocks the page,
> and that in turn might be done a few different ways:
>=20
>  (a) either add a separate "MF_UNLOCKED" state bit to the possible
> return codes and make that me_huge_page() that unlocks the page set
> that bit (NOTE! It still needs to also return either MF_FAILED or
> MF_RECOVERED, so this "MF_UNLOCKED" bit really should be a separate
> bitmask entirely from the other MF_xyz bits)
>=20
>  (b) make the rule be that *all* the ->action() functions need to just
> unlock the page.
>=20
> ( suspect (b) is the better model to aim for, because honestly, static
> code rules for locking are basically almost always superior to dynamic
> "based on this flag" locking rules. You can in theory actually have
> static tooling check that the locking nests correctly with the
> unlocking that way (and it's just conceptually simpler to have a hard
> rule about "this function always unlocks the page").

I'll try (b). Thank you for the detailed advices.

- Naoya Horiguchi

>=20
> But that existing patch is *so* fundamentally wrong that I cannot
> possibly apply it, and I feel bad about the fact that it has made it
> all the way to me with sign-offs and reviewed-by's and everything.
>=20
>                   Linus
> =
