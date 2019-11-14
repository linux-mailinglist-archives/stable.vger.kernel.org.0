Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5EFC82B
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 14:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfKNNyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 08:54:44 -0500
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:61207
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfKNNyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 08:54:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxOY6Rg84cp2mNyNYe5DgQMD7fBqeYSMFUelR+377EZPBaGRy2lWoLvRTjBk1b+7O8xGNJNlSLCXPlMBI1XPmYISGxrgMCoiSYP6TV/O2fBm+SK9gjy5DLVvkyBtiSgT4Z8NAeOdSsm2nF0neVQCN3IC4ttECGfoqqUjfNcInRHvKwqJuToTvTVt5XPqc0MC+Gx/aBH39tlTAW1yWAkepOL4flLW+EqX/dKIQD7UluFrEabaVdGVWR8HSWAeXbLKqOPTVUqdMlX3LJ7zpko00Y00I1U+UiR79ToqxzvN3ExRwE8Q181nFIR/W99Pl32DOeFNf6i4DhpbVBfD4PKB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NrOv0znuVIkF41QXRr6d4ayL/TTTNPze19Cw70Rr+g=;
 b=XCqxFI6dTINBKss+3tPLPMcjdirLG8cxY232uYTaiYOxVVwAAVutXC4UgUqUu8HIIM8UxUNBs/EacWOpXLOf1KBT+TElWe3tz89EKO0j0UXfY9JuvdO727LtNbM/snH6ThXIMFL0/8PaGF6UCNAPxKP5L86nmh/8hz4o1NCpfI6aYfbgW+k4/eATs5TTon/dQ1rbX9IsZe4EBRUvxc5Gtdb05PTyxa9QcdB60R790cQrJrnT4CNeDQya0N70/q2zEPFZqoGyDXFCFgs5MHgZk6Kt/i5HjQW7v6UxN6A1fNVrL8QHRz6YLAPWG8Ro1ZD5kQ3riV5rE8aLZ/gQS4bzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NrOv0znuVIkF41QXRr6d4ayL/TTTNPze19Cw70Rr+g=;
 b=f2w2YgBGe9pVLOeKHZ98dV2WqFaw4t1SK3jucIpnsbXJ6mNuTcGnK/cPzL8PETvhc/jJH3dkB0vMxrCYD4P284Cc2x1AwrWtIOrhn3CoRyE2oYovZYtUHzqyZ3P1+AYrdzb7JxEr21mI2VfdUntJLRofAWOX9QeJVt78+0bFPBI=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB6202.eurprd05.prod.outlook.com (20.178.106.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 14 Nov 2019 13:54:41 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::3c5a:1339:33db:2df3]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::3c5a:1339:33db:2df3%5]) with mapi id 15.20.2430.027; Thu, 14 Nov 2019
 13:54:41 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Lukasz Luba <lukasz.luba@arm.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        "wvw@google.com" <wvw@google.com>
Subject: Re: [PATCH 5.3 113/148] thermal: Fix use-after-free when
 unregistering thermal zone device
Thread-Topic: [PATCH 5.3 113/148] thermal: Fix use-after-free when
 unregistering thermal zone device
Thread-Index: AQHVf0aszjDzBkRVak64VD2aSjHdS6eK/tOA///ovIA=
Date:   Thu, 14 Nov 2019 13:54:41 +0000
Message-ID: <20191114135439.GA3448@splinter>
References: <20191010083609.660878383@linuxfoundation.org>
 <20191010083617.967244655@linuxfoundation.org>
 <905e26d4-76c7-555f-3b33-51fa3cf7a470@arm.com>
In-Reply-To: <905e26d4-76c7-555f-3b33-51fa3cf7a470@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::24) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e7b9cab-74db-45ae-cf37-08d7690a3272
x-ms-traffictypediagnostic: DB7PR05MB6202:|DB7PR05MB6202:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB620252D52D378EC35E82585BBF710@DB7PR05MB6202.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(189003)(199004)(76176011)(11346002)(66946007)(6506007)(99286004)(66556008)(64756008)(102836004)(66476007)(66446008)(1076003)(6306002)(4326008)(386003)(9686003)(6512007)(54906003)(316002)(26005)(6916009)(4744005)(186003)(256004)(3846002)(5660300002)(6116002)(6246003)(6436002)(71200400001)(71190400001)(478600001)(966005)(7736002)(25786009)(14454004)(6486002)(66066001)(2906002)(305945005)(33656002)(476003)(8936002)(52116002)(446003)(81156014)(8676002)(229853002)(81166006)(33716001)(86362001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB6202;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VYvAxJUd8vwQ0D5H1nt5lMcD77dSHVNuaGz/D7p42XctqdZdE99KG2G2UGu+hRCDpOSfLo02b23XOilud2x5mqFq0vKcIBbbDyjxRNFS3O+Rj2hfQuvCknKbRCX48coQttyZOhjYuQzfRbYJ5EZBphEkaiUqn6spdkswwoiuKz2QrAKfLS3j2dX5HFZSM90hBH/ftM1j4O8uPPFLlHBVs94BURWc4mc+xDnsM8j0sUgMjxbWavQzEpQQ3dA+o/UhAjDCf9f2lJ3TKeqD6Za6sNfHxQTc7NNosFuMWDny1XASsdNJOe5b980y6HAKEH6VneUYCisbTIl297Xebs2WTDVHbdt+jFx5gbzdJd9ZPmUlHB+q8U8HCLPTOSXTScy1+XwT2HmObl8JcZvMK71z9uQFWUI8xW6nGxMldUZYFDwn26GQ+aTa0Eg5DqhSZD31yCOM5com3Qn8+SGtEoTIy/8mJ6bgj93qXfdw4Sdvx4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E6AC4D9A779084F837631E6E7FFFC4D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7b9cab-74db-45ae-cf37-08d7690a3272
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 13:54:41.4408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1iiTAFnCEu4R5of2m5zYoOgw14On8ViWT9b0A1M8nOUiM9XwqES91fGMFPFALl+XMK/HuAjMGT8JpY26ranaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB6202
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 01:17:55PM +0000, Lukasz Luba wrote:
> Hi Greg,
>=20
> This patch causes a deadlock, the thermal framework stops. Please check
> this fix (I found it before posting exactly the same solution):
> https://lkml.org/lkml/2019/11/12/1075

Sorry about that.

> I have verified it on OdroidXU4 and it works. It needs some cleaning in
> the commit message, though.
> I have added to CC the author: Wei Wang
>=20
> I don't know in how many stable trees it was applied, but should be fix
> there also.

I checked my mailbox and it seems it was backported to: 4.4, 4.9, 4.14,
4.19, 5.2 (EOL) and 5.3

Thanks
