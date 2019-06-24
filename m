Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3C51A08
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbfFXRwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 13:52:18 -0400
Received: from mail-eopbgr1300130.outbound.protection.outlook.com ([40.107.130.130]:56064
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728286AbfFXRwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 13:52:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhWKnmKwVpY0FvrzwxtWVNUZ0CFRg9xuhy64JFks0inn0+qUXPvmx2e6ILizc+L12osUMV8SIHgXuPOT4oAIRpJnfFJBkxkbCrFhwzrhv+i+NpdvGvs+QivWZ+Ip+5KWRXwNAF7HtjtBlek1ilIA9mN8OEDhLvW2LlrxA24iD8kundLmuT+Lne5Y+ALdl6wsMqxWLa5FNr42J8M6BwNmk2SXcTt4TLzsVbQHmZj20X9pgym5DD02ewu24j0r3IZ26lg1Ahq20A6zEsNm1bF9XZ/GC2oK2WEY/euQByhmSwO4n4aonBIzNioPWpf+POEjlXs+MYhA2MbFhAAp6hrkUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLlu1TKIMuUUQe2nJoggeAgwBwBQ17ICazWVVV9w9no=;
 b=SWtRsmGFYmcoxeAtWXTLcGbAq713qTBdwVWAekaMsibZs4KcddL9cYzmWXk+usOaUbXXPat2JtBH2lxJKvcHQZG6//g9urQmv7sInJ6xOpxCpQ0fzl4XIU0/vv/FZ3bb4YdaNzi2GmLS/aaJZsTY52Rdz3iTGfrOlSru6ygVWpehMwKV2+Q7QGMHolByebddBrhi4VG8Y75uMPtrP8MPMVdIhXpuS1YmajFYDnewXVAA35qrzBNQ4HLi1wIxD4uFt0CwxYkV3050Dihc7qUoKZP0VIvLgjo+f9GJ5hIKuSsIJyqBlf+jDpE2oFRYqrN49gZO8vrV0bF8jPPt2IkKUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLlu1TKIMuUUQe2nJoggeAgwBwBQ17ICazWVVV9w9no=;
 b=JcPagnW8/5CgUCbmAovfHCjIgL8gEWmVh0ZVsx+oV7WJ+Zw+uGzGMNZg97YuY8kdA2q5GoWrR2L43wV6mhAUF/7GvX3DfQ0Pxslf+MgpgJKphSA2QCrr8m+FKO/c7hXrcbjQhc/CeIhUjNDBRe7pHybydcg3Klr6/28cllEraNI=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0154.APCP153.PROD.OUTLOOK.COM (10.170.189.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.3; Mon, 24 Jun 2019 17:52:13 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::19b8:f479:a623:509b]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::19b8:f479:a623:509b%5]) with mapi id 15.20.2052.003; Mon, 24 Jun 2019
 17:52:13 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "Lili Deng (Wicresoft North America Ltd)" <v-lide@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()
Thread-Topic: [PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()
Thread-Index: AdUoYqahDsLeDiTlTqKiO6h8RAkcdgAw5aaAAGOy+qA=
Date:   Mon, 24 Jun 2019 17:52:13 +0000
Message-ID: <PU1P153MB01698325A26B409C9DB0C282BFE00@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01691036654142C7972F3ACDBFE70@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190622181350.B40632070B@mail.kernel.org>
In-Reply-To: <20190622181350.B40632070B@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-24T17:52:11.0674671Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6fabc8ec-84a1-4984-8934-b16d0d65da77;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:9:8a08:5088:5963:511d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da38d634-5b4a-4deb-f033-08d6f8ccb05e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0154;
x-ms-traffictypediagnostic: PU1P153MB0154:
x-microsoft-antispam-prvs: <PU1P153MB015427013E054A0CA2C5D72BBFE00@PU1P153MB0154.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(39860400002)(366004)(136003)(199004)(189003)(86362001)(81166006)(4326008)(305945005)(5660300002)(53546011)(6506007)(14454004)(10090500001)(81156014)(486006)(66476007)(74316002)(10290500003)(53936002)(7736002)(71200400001)(71190400001)(76116006)(2501003)(66556008)(64756008)(66446008)(8676002)(478600001)(8936002)(73956011)(66946007)(229853002)(9686003)(8990500004)(6246003)(256004)(7696005)(6436002)(25786009)(99286004)(76176011)(46003)(52536014)(102836004)(186003)(2906002)(6116002)(22452003)(68736007)(110136005)(316002)(11346002)(14444005)(446003)(54906003)(55016002)(33656002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0154;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lDZckHdc3/HgtBYdqGwV/5hF3E3t7k6l1TXXr9GQTDVyKmcavjPOnSWa2vTvId55GZku0yTdHiQavZCDRtZLFaOIJoFRNFZEZBI9KoFLtE7ddAq2vpxfq5sAW3ldHqDQq7DvoPA2wLYIFvblHB/+LIDNYITfXvmfg3NkW41LqG2EI4xW9n/o7aHOD5KO/6JdoFwE++Pw5pFAwfj2qVNbCvJj2yzFRpQ+9TqrpQxbznP+aKLyWYat3hEGN6HyYPYBGpz3SpVW2VYTxKCtozGOBUvSO9z97DYpVoc6QsDqiN2qa2nJViTumNQNmO4h/zR5b10op2uFUrIpy6g+sfdCJj01/GuSuM51tX55kK31A/4NgRrnD0XzwB1P3EI3eRlwQBZMErhg4VjSzlzIS6FNncc6vaO/4QaoIEzwJm/+bIo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da38d634-5b4a-4deb-f033-08d6f8ccb05e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 17:52:13.2024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Sasha Levin <sashal@kernel.org>
> Sent: Saturday, June 22, 2019 11:14 AM
> To: Sasha Levin <sashal@kernel.org>; Dexuan Cui <decui@microsoft.com>;
> linux-pci@vger.kernel.org
> Cc: Lili Deng (Wicresoft North America Ltd) <v-lide@microsoft.com>;
> stable@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device=
_work()
>=20
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 05f151a73ec2 PCI: hv: Fix a memory leak in
> hv_eject_device_work().
>=20
> The bot has tested the following trees: v5.1.12, v4.19.53, v4.14.128, v4.=
9.182.
>=20
> v5.1.12: Build OK!
> v4.19.53: Build OK!
> v4.14.128: Failed to apply! Possible dependencies:
>     8c99e120ffca ("PCI: hv: Remove unused reason for refcount handler")
>=20
> v4.9.182: Failed to apply! Possible dependencies:
>     02c3764c776c ("PCI: hv: Temporary own CPU-number-to-vCPU-number
> infra")
>     0de8ce3ee8e3 ("PCI: hv: Allocate physically contiguous hypercall para=
ms
> buffer")
>     24196f0c7d4b ("PCI: hv: Convert hv_pci_dev.refs from atomic_t to
> refcount_t")
>     6ab42a66d2cc ("Drivers: hv: vmbus: Move Hypercall invocation code out
> of common code")
>     76d36ab79820 ("hv: switch to cpuhp state machine for synic
> init/cleanup")
>     7dcf90e9e032 ("PCI: hv: Use vPCI protocol version 1.2")
>     8730046c1498 ("Drivers: hv vmbus: Move Hypercall page setup out of
> common code")
>     8c99e120ffca ("PCI: hv: Remove unused reason for refcount handler")
>     b1db7e7e1d70 ("PCI: hv: Add vPCI version protocol negotiation")
>     d058fa7e98ff ("Drivers: hv: vmbus: Move the crash notification functi=
on")
>=20
>=20
> How should we proceed with this patch?
>=20
> --
> Thanks,
> Sasha

The patch has not gone into any upstream trees yet. So we can not do anythi=
ng
at this point. I'll try to backport the patch for the old kernels once it's=
 in.

Thanks,
-- Dexuan
