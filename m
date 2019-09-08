Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D11ACA8F
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 06:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfIHEEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 00:04:43 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:38605
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726217AbfIHEEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 00:04:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkNrrRea4FJKYLrFHWuxKZSlIyoeZM2j0vFDIsuvwroHtMU46uMac5Em3QqLs8kFKADMMW+xzcjzDV6sGYhGGbP7OsLiDc5CgV22qmsdgue7gd5SpSHPqlNbVhWGOdDOsZ8j51Xw/IjDmn43/88MgUiYDFuRPlMXkZ87VK4LUeCmHYAGpRB67L2v4U9VFyqBVei8Yhd0ntctdPdzbHQQ8VpD+WotApt8jl7cj3WfmXgCbypwSmdVgSsob2Z1gcvWy0aSSL3mbL2Ekq91hcMPaCGiP/UjcdVUvglbOlLT1BGpC+A4pOfQymWcUY+Moc46cBDK/wwAs+t4zxNDnluGzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPkz2sgxjacut4Ek9F/FUjzA5rnOBtK5FYbYM2YP8Ws=;
 b=bhacAonLHJlbftgv42wxoq9s+r7A/nwRpJIQQ5JVRj5JMRVIJ6ixJeSqkhI4EPLktCRDCiS1uPfnwsBI3Ub/KnKKCSDnQfyBuOT6p0c+5linws1dwjJH+WiJSQcKcd8xvcD6tOU908XPL9Fsr2ry9Cm4F6SFIRdz4a44oj8mRbqjSJMaTNMt7TIgQsrQOmWyNWlTFX6b0/fFDHzjK5VU9aO9qYEvQpbN52z+GceD293mI1bmwrQiJb7qg71H75Rcs5uOjxM1VAHdu17DfaMD/Z70hzWW+M6TNZdJ60RN9h9ZZlMix6FJ8VIDVQxIlAARc8qwWum9JaAxRlQ7KoOAoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPkz2sgxjacut4Ek9F/FUjzA5rnOBtK5FYbYM2YP8Ws=;
 b=jzPMYzEGFr20zjI7fezWSLL3TYPSHdKlxmrBXdf6cLZE6qC6aEaXS3g9mhcBiI8QucX3S3BaEOQsFhHalSXACiP3SDfAB6oWInl+nrEl8b1/y9scpGV+Z/UuPA85SMZarfzZ4lLFDcLXru6khKZ5ZPc8PgYCfrFWIlEXqkF4lX0=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4071.namprd05.prod.outlook.com (52.135.201.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.11; Sun, 8 Sep 2019 04:04:39 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b5c9:9c17:bcf1:1310]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b5c9:9c17:bcf1:1310%5]) with mapi id 15.20.2263.005; Sun, 8 Sep 2019
 04:04:39 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Rigault <rigault.francois@gmail.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] VMCI: Release resource if the work is already queued
Thread-Topic: [PATCH] VMCI: Release resource if the work is already queued
Thread-Index: AQHVV9M92cuVvHPAEkm/BdBD/5MxaacgqaqAgACbwAA=
Date:   Sun, 8 Sep 2019 04:04:39 +0000
Message-ID: <00CA348F-5ACC-4A17-A5F6-9B36C92A95E7@vmware.com>
References: <20190820202638.49003-1-namit@vmware.com>
 <20190907184711.GA30206@kroah.com>
In-Reply-To: <20190907184711.GA30206@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [77.137.80.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45e83235-cd86-4420-49a5-08d73411abb0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4071;
x-ms-traffictypediagnostic: BYAPR05MB4071:|BYAPR05MB4071:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB4071A5FD96D0776A5FBF42B4D0B40@BYAPR05MB4071.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0154C61618
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(6116002)(86362001)(71200400001)(71190400001)(486006)(6436002)(14454004)(6486002)(5660300002)(446003)(6916009)(66946007)(66476007)(66556008)(64756008)(66446008)(66066001)(229853002)(11346002)(2616005)(476003)(25786009)(102836004)(26005)(186003)(4326008)(256004)(316002)(54906003)(6506007)(478600001)(7736002)(305945005)(53546011)(8676002)(91956017)(76116006)(81166006)(81156014)(6512007)(53936002)(8936002)(2906002)(33656002)(76176011)(3846002)(99286004)(6246003)(4744005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4071;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AHe8X6PdXn9gXQtzsZuw8E4jE+z4Pfu+4AbUSRBr75q8Dc3xlL+FMzA9D1oUlZB+FPNru1n/Qw3SMUqS2NSbTKjsJeMlWPMO899y7VP9MTVa6kV5aVv24yHFaIHXAd0m8VuaMoxSXccGNNE4PZ3eIGjShykac3v3S594fY4DGZmSdNzQ6ljGiB94p6hWSTsXWRpUHx9Tlz4Hp+WJ7B4/ykaDNW9zve7X80fTAEByP2I1AgLud6Gps8UkYoMeJa8rH9BAynlnPYUREmnMkQXgy6rrbH6+pUaLVTiNI2L31S5hKX//tQYoi/XG+6qhZU06Ohmgf0Ln7e7mQcOMXW9bNGvaTgzALthQy1Vzf54/DGGRfpe0pExHxEn7wMe52jERGRXrsEzERSRMA08FYwWva5MIRfVWosV39ycyr998v+k=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AA2425E2852CDE49BCFAA35837E6127E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e83235-cd86-4420-49a5-08d73411abb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2019 04:04:39.3544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3QYoszYmLdqYcsGVJqh3ZQ+mcEqiZ4gjah2yUTw5aBF8BXPhbx7DbXBPgydpfi005Bkt8katNTPJ2x5GpE4+QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Sep 7, 2019, at 9:47 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.or=
g> wrote:
>=20
> On Tue, Aug 20, 2019 at 01:26:38PM -0700, Nadav Amit wrote:
>> Francois reported that VMware balloon gets stuck after a balloon reset,
>> when the VMCI doorbell is removed. A similar error can occur when the
>> balloon driver is removed with the following splat:
>=20
> <snip>
>=20
> Note, google thinks your email is spam as you are not sending this from
> a valid vmware.com email server.  Please fix this up if you want to make
> sure your patches actually make it through...

I used gmail servers since I get complaints (mainly from Linus) that our
email servers use DMARC, and this causes mailing list postings to be
rejected.

I will check again if our open source people got to a solution, or I
would just send it using my gmail identity, while keeping the vmware
authorship.

