Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF3B25B297
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 19:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgIBRCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 13:02:03 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:11893
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgIBQ6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 12:58:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/1HVMMSb3342qizsJmnDsV220chwTLlE7+M0QHACwL/83nCIErInsxGYwa+9PkjT8QlE+CYvB7LPMRL1QUo/vCE02HremS1H5mUFOyKepz2vDWCRQk6fnE8zCTtvKvoNKIXG6rvc2maEMyJZUIZQF1QhZ2uC+BKBt1fUZgIWdGCURPzeN+b7nAXNEJpSpkQZ/4arnvi1IqItNVKpLWevIrSrJNqusIbFC899JOO2gJZoFMb8DWfUnsNp736B4Uo6igLJeTgJok/J+AN/9ENjU2vVMhre5YrM3Wct0/W78CR9M9BkQGhwdVqwLrr0jwmagKnrEn3kzwJJ4K2LhkTmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSlXYCsry2CVxm8M1GpGYo7MbziIJcFay8NwyKA0UrU=;
 b=OdzZw9hoFoOcg198utGHJgWjmRf5HIb7kyo/pXE6BdDkSGCuNqOoAPx90kQhvHd2OOP/+dcs879Bg57JVuvXOt/TtQuNRKGLcgvqmj8NUs4NZG833PHdAdNCbW37HRzhPrYwaHGD8wJLKFF85l5PnGvHgv5nitHDYGXONFvpx+ItkN1iGiBMAbjRyhe38KEZyJsw/njWeSP1dOIbsGu+LMIihsAsGcNDyBwcM561w3rfMvdGN8wBQsBL6tPU/n01EGOMki+yS9pvbK/H9CE4OxNQei7I0Tz8QudEwHC4zlNfSsZhkefxjxJn+dCedUujA9vwivnlH3T/zrFa0a4HYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSlXYCsry2CVxm8M1GpGYo7MbziIJcFay8NwyKA0UrU=;
 b=Katv3Er1eb8Of2KlJjsMSe2rhzj3DnwrD2PSK2uPiF5psgwKMlKbxhzIdGpmkcoj46MKuar4fHdOp7JPS6Wv3YDJ1Q4hDAP8iLqw5Tvd4kapDzrFwPqVJ0o5bCn3t6aU40P8RC4cKOOkU1WCgjoaD3JlUpI33YVOKUn2XA45y70=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB4070.namprd05.prod.outlook.com (2603:10b6:a02:88::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.5; Wed, 2 Sep
 2020 16:58:16 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::9cef:3341:6ae9:a2c5]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::9cef:3341:6ae9:a2c5%7]) with mapi id 15.20.3348.014; Wed, 2 Sep 2020
 16:58:16 +0000
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
Thread-Index: AQHWgSgoL1dmFxhMRECqVhfYnO9uuKlVeiqAgAAXogCAAABjgA==
Date:   Wed, 2 Sep 2020 16:58:16 +0000
Message-ID: <1678A071-A4D7-4BE6-A768-0985E3F10444@vmware.com>
References: <20200901161857.566142-1-namit@vmware.com>
 <20200902125402.GG1362448@hirez.programming.kicks-ass.net>
 <1E3FD845-E71A-4518-A0BF-FAD31CBC3E28@vmware.com>
 <20200902165652.GO1362448@hirez.programming.kicks-ass.net>
In-Reply-To: <20200902165652.GO1362448@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:4945:3524:19f7:23e9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1cea981-c015-4d08-e34c-08d84f6162d7
x-ms-traffictypediagnostic: BYAPR05MB4070:
x-microsoft-antispam-prvs: <BYAPR05MB407082A07D3BE2E56AA9B532D02F0@BYAPR05MB4070.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uwbClMklO+ofyL1egIfhB9esJfsvrODcm236RFsFRtbb6s8LC7GiKMRGuQ6bCctY2BZbJR421hw3T1yLswXxcL/gw/xOQbDLRTWHA4cXARZQbzZ3JcdPczlxB170Iu8HHwxbBq3G2tFR/nwmt3w/3t/EvxU3deFvnh1j6HATxAiI6Yc+RwgLlmyduZUGNVC/vC2cYCzfFc5tI8NOA+tl2IAjsyCREUVUZxUaagTcNjXOiNcaSBF2EHzhqECFsZ+u1sRiwCv05Q0aGEaaLiJyszh+x+vxHyJjiv/OjNz5lYfS/fR8KxK61yyvSXClLA325pqm1kAGirckwfQabT6ISw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(6486002)(83380400001)(76116006)(316002)(2906002)(86362001)(6506007)(66946007)(478600001)(33656002)(66556008)(6512007)(54906003)(36756003)(64756008)(2616005)(6916009)(66476007)(66446008)(186003)(7416002)(4326008)(8936002)(4744005)(5660300002)(71200400001)(8676002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: V+PcX61a3nCIowl0PI0DT61ZQbKO9AUSor+KIxrto/Yf00faLcW2zpTBTfiYgVocGdF4E+rs39fryalTXUvSPgIB4gru8g1DZwd8/ANGmLTHgrrLnj1/xl2J6EyHABrpSViPLs5F5VyCV0P/utz/4YY/jJcBY/xbCzFSslFfNYtggKiQm9dTUI4s3Oe/srBCf7EUkM6MuNrjh3nW+PDKoRiRFaBMi5vpilayJkBhPXi7ItdefvLqHZtqhSAPnYTf7k04rw2CA7Wbgw+yrWE2+HoLxy13Y7fvqSnx7BxFb0rq1JOKFBDfkKkYISeQGivzTIf1B7pYfb1Atx9MZU/9qbyKsgKGap1SVEMZyFYAzH6jjANbvEUMqDB4gVIxRTSL0JLCnfTfFYnW/gu9pvZQJQdU6bwUiXO6B1KxnT/yncSzTb6rH4JLZTV+yUCdV078s2XvpGg1TMGH9zIZqeLaLRhMqP9PB26AT+bIz1XGTBNCdG+JI5TkMz35iXEUv2NngxjTzVFHAw9GdPqB7qJzPvTxjvsgvg5GBY3gtr9m/8aTHK5vXz7eKyuLwsNomYjOKw5wIrHJRDQmz/IXsC4VXAwGtt6PD0sAI86d0/bV3jdDJpxpLavsYLlhndyyP5kRvkrvCXa5Ru83wjLEPMe+5qKXrkMrW4Srhq4sQjrqYma8aRdX+DlVpEpU6hxmFsUiDvB+MCcjBxV66JStjpMNCA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EDF969D98B8F3147811B860589CA9521@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1cea981-c015-4d08-e34c-08d84f6162d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 16:58:16.0313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1oUNrkGvpL7mTDDi4mxD6RHyKOQ98gGE/qGByz53QlDbt7LqpJ61tLl0+oEIX40BeoxIv2alM6/HCKRG6XC8Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4070
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Sep 2, 2020, at 9:56 AM, peterz@infradead.org wrote:
>=20
> On Wed, Sep 02, 2020 at 03:32:18PM +0000, Nadav Amit wrote:
>=20
>> Thanks for pointer. I did not see the discussion, and embarrassingly, I =
have
>> also never figured out how to reply on lkml emails without registering t=
o
>> lkml.
>=20
> The lore.kernel.org thing I pointed you to allows you to download an
> mbox with the email in (see the very bottom of the page). Use your
> favorite MUA to open it and reply :-)

Thanks!=
