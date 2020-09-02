Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C361125AF1A
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgIBPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:33:57 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:51681
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727866AbgIBPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 11:32:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTHsNYct2oJhVdL/Va2ZFcNZSJPf883cJDLBZkD5kmQnm7Bte7VhJRlkwUIO6q4Do0GHOBA8s1cqstsKd14ZNMyRa9upOxRDg6KodLjKqePlyfSnb5rpc5z74nrkr8thTdV1UxuGEi1WWDNYpg8Kvao2C4wxifYphrplp3IFoYHNxxuO4inqNqutlcaNb/rtxfs55fYSZstdmZ23fv0YXT20tg5tiJBY5NvclD98BFcBkLsM8cDdwpR9jQy3eeBXd934O+o3tsmKtgl1aACZx21KhvBUvJpLz9fhdg8ApnWry1B1c/QmkCp54JmOJfJTgQDnPNqK6gelaohVGsD81A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xx8xFzZCXrr0sIX4WOxybu8mmPEpK6ptGa3uMn4cTkQ=;
 b=GNDrJMQtw59lYAQgoQnZsZ5KyS+h0L1VT8d4RLZ3P7PC6cmkjgPU7X3dM17awi/nMuxHIQcraPhyM7gEPviu8hgTfcrfB5c4gJiPpF/HfngICEwnr6zVr8uLa7XbliS9xuhoogMiapfQJGyOfkrb9mBy6mpg+0Lp2HPWBKMOoAE6mv3yDyPrO0Q7ALwTevAJLmle5tnKSyPsMGFDBAxGPTJSrVn+SvGi07eKyzxXz784/BL5TKhhT+dayX7vZsnE3PTpV+BQuvWDQeVGArw3MeXKYoDrwnQKbwJaC37OoVRyW8IqXuIq3JhhtH4InBzIXQFE8dxWrc0wAcjr4TBBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xx8xFzZCXrr0sIX4WOxybu8mmPEpK6ptGa3uMn4cTkQ=;
 b=0noPyYcSmaETfD3H1zGvwPsHm+IzHG+o+c3OV21TQI4PRCOT26D1+WoK4wo6fyRiOmoyJztRfMSgxPHViqv7et3Sch/p7S1OaciEf4iP95cS4E8N1HX2b+U0n5dgmjQ9sYWjG3eZW/+eB5IaDxBKhmIOO4e/yQEJ94uPZ0sy3ek=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB6037.namprd05.prod.outlook.com (2603:10b6:a03:d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.7; Wed, 2 Sep
 2020 15:32:18 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::9cef:3341:6ae9:a2c5]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::9cef:3341:6ae9:a2c5%7]) with mapi id 15.20.3348.014; Wed, 2 Sep 2020
 15:32:18 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/special_insn: reverse __force_order logic
Thread-Topic: [PATCH] x86/special_insn: reverse __force_order logic
Thread-Index: AQHWgSgoL1dmFxhMRECqVhfYnO9uuKlVeiqA
Date:   Wed, 2 Sep 2020 15:32:18 +0000
Message-ID: <1E3FD845-E71A-4518-A0BF-FAD31CBC3E28@vmware.com>
References: <20200901161857.566142-1-namit@vmware.com>
 <20200902125402.GG1362448@hirez.programming.kicks-ass.net>
In-Reply-To: <20200902125402.GG1362448@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:4945:3524:19f7:23e9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0172435-1b0f-444e-924c-08d84f556068
x-ms-traffictypediagnostic: BYAPR05MB6037:
x-microsoft-antispam-prvs: <BYAPR05MB6037134E5FF80994510554C9D02F0@BYAPR05MB6037.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yRcrxjzyUdM2GrDU12LhGDcZFLgNqhTrk+HcoQyEP5weeB/nER9GHGKMPeQE+V6WTLhASJodxw/jwnsEUrY6VYludDPjxQd4ka/n4JIYAVGgqoHlVAEajHXupLnRhT6IDeasoVbc/79tF+DNlMDyrJeuoAiW5lXO1WuL9NVFYpvNBdX9vOqBLY/oGiJ6cvopWrYBkHpHDI29gdO9S5K/Qj75sETPtDVkx/dMfZdSgIe5soatZCx2X1aTVi/X5eJ9D0TPAEfct2GaxmJNb7ns+fXHhE7x0n/+2LuMN1OxFzuDt8QAHpbAtx+vLFDEIgbYnKuQzKXkhyGO/bMPOhHcCsI3QVjyomjVjMhnTvF6Pg9EVIlI//Bo92EvT+3he13DbVIrVI04h8ugeMUjmPmluQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(45080400002)(83380400001)(8676002)(316002)(478600001)(36756003)(71200400001)(64756008)(54906003)(8936002)(186003)(66556008)(86362001)(66946007)(66476007)(66446008)(6486002)(76116006)(2906002)(5660300002)(53546011)(6506007)(4326008)(33656002)(6512007)(2616005)(966005)(7416002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Oy7G0rTgQDjVOLIHY1axlCtDgIhj0ZIUFnEUZGNZlQif3zXdGinITUhu99MOduxE4L48FGxO87xnq9VoUGNjtV0tygb4rsIfBolsPKmrEXiZwsX5AxjLYLz/BsBDp7nFWJGUDOAbUy2RPGK3iJ4L3Ur+AUVFLGfh56vTwLTbKLxmZo7l/P3t0aEqy0rzMWsCLA2LFCsdFcciGHK7aNaAoYqK4BcT8vN6i5FVyphmKN/eLUg4P8a3NTxWiMSbdaXTDlOpniy7++pcZbHKGhPv3EWvlI3xV03DoMtMEah45AmyGs4jxrCFqySXdDlmyZ7cIPu1c4snrHnofMe9Q7N/jJT+6lBoYeOWPsEqaXkU3URQ+68EcjP4r30owrGRoddyEMN2t1hmHFBd/1IjTMuPH9Ud+aU2l214203Y36Dqfoc/3X0At2AD7P8gyjjMImSXGn2W5nGS/p/8GINkwT/jPasHR1gj+Vs8Lg/+znnmmRBM7bGkXbU3Sx3CVTa+4otZ9T8glGXROYUGc5V3qrL8cDZ3SqSAhJ1Xhh0qMtKEMVx82/necsWKFDd3PCjP7VTcqZnd71AAQowQ3WsfadIQvJ1bxr28E5wVdJ0cdQeSA/KOmtStB/H5AC0w028LlO9lxJOjC8L29BkR10xWXm/YLgGJCyy1rGm3btMylIJ1LS3czhKYrFcsghNt9UMp48LMv6EUmoE+N/dPnn1oSrsI2Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B86B4DB3C2D38C40A447546E77C04369@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0172435-1b0f-444e-924c-08d84f556068
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 15:32:18.0266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rtd0IMv/5LcI4hgmJjzFT68lCGolWthg5Wp8Wxl1pn2zADtnZJ6d5S4fHqCJw9OXgA2itWAPCoMI8UO4HoFGgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6037
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Sep 2, 2020, at 5:54 AM, peterz@infradead.org wrote:
>=20
> On Tue, Sep 01, 2020 at 09:18:57AM -0700, Nadav Amit wrote:
>=20
>> Unless I misunderstand the logic, __force_order should also be used by
>> rdpkru() and wrpkru() which do not have dependency on __force_order. I
>> also did not understand why native_write_cr0() has R/W dependency on
>> __force_order, and why native_write_cr4() no longer has any dependency
>> on __force_order.
>=20
> There was a fairly large thread about this thing here:
>=20
>  https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flkml=
.kernel.org%2Fr%2F20200527135329.1172644-1-arnd%40arndb.de&amp;data=3D02%7C=
01%7Cnamit%40vmware.com%7C387b68745a984454d50708d84f3f499c%7Cb39138ca3cee4b=
4aa4d6cd83d9dd62f0%7C0%7C0%7C637346480527901622&amp;sdata=3DPR%2BCUy%2FYNKz=
a6he78coaDR3x1G7BYuzFfS9SGfWZ9p8%3D&amp;reserved=3D0
>=20
> I didn't keep up, but I think the general concensus was that it's
> indeed a bit naf.

Thanks for pointer. I did not see the discussion, and embarrassingly, I hav=
e
also never figured out how to reply on lkml emails without registering to
lkml.

Anyhow, indeed, the patch that Arvind provided seems to address this issue.

