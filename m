Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3900512178F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbfLPShD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:37:03 -0500
Received: from mail-eopbgr760040.outbound.protection.outlook.com ([40.107.76.40]:4206
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729681AbfLPShB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:37:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lntMCfjLtXvq0ejZUrkXC/dwBHrPdO/qqRZ124UeXhEMHj93+XzpYd4Q9EnVqboOQSTy1FK4RsVOVTuE19ahk9EtIoYTGASpZ2Ikfoz15ZrcDyQHx7Bj9JW3+IIGRj933vPYRLrwZPb8SvbfMxwLseC05KpqOpug8HjVp3jxnEE0ihTdqbm+Ivfn+xAYix/NKp6WgxUG1QHnw/eUAklDkip1d5kFij/DemPSBYpj8M82+wJJ5h4i7gHaPuD68AsUv2SgXtiGVZrQm/hkJGua1VJf90ShzFGfa3ncOA/iUuIrMIC13eb36of7iYaGb3yy1ocucsmUjT1KOcf35tuTJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS4T7C4tapTc1UzKsGi+HmJb6iJSeUeTn0bOjNOC1eA=;
 b=Hd/TEd8+va0kmp0rUaOhUI8IvmZYe2C6hTS2BhpJnzPynaUV6Tv9pVjM8RGPBu4nsB+ta0/DnJNkmEWf2041F22HcCatqiuZ/BmFzoUk4UKKxJKr8KY5+ArOjV6PtUvXmwe1UQN9enr7U6zKKR4ESTclmelFUA8Jf+7YjcvlV26icV3mtvbQKS8vREbHa5GrvU9nGRIpFFtoFQ8jQdsvnR10q8+XHJbJREHU3vzV4Y9uceNEhTnMsR1b326oE5qQgBqnzn0OwtZPb2981WWbHy8RLsoQ8AeCYcHA/kFjgUKkyxD/xs03C8PSTxXAvE8Aafef5SfEDmzYPi0jcfN14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS4T7C4tapTc1UzKsGi+HmJb6iJSeUeTn0bOjNOC1eA=;
 b=FiE3oPPkfccj48p7ayoPXUFEd9hzjhwtwof7V9yIP8VrS6UskZKQpgasE9mazxPMk15Is67Dc0fedJX9b+S7Q/DFJgRmsCBY/ot5FEPa8vOPipyX+ZWWCMtKlezYWBDn8+yyfGGNFET9OIvvI6mRDsAdPa7WAvev9EYASR5kXqU=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6607.namprd05.prod.outlook.com (20.178.246.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.11; Mon, 16 Dec 2019 18:36:58 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::611e:6a6b:9109:5aa8]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::611e:6a6b:9109:5aa8%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 18:36:58 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 139/140] mm/memory.c: fix a huge pud insertion race
 during faulting
Thread-Topic: [PATCH 4.19 139/140] mm/memory.c: fix a huge pud insertion race
 during faulting
Thread-Index: AQHVtDulXh+YP6/bhEC7+ZhBemA23Q==
Date:   Mon, 16 Dec 2019 18:36:57 +0000
Message-ID: <MN2PR05MB6141D3283B5D4365CBA0A497A1510@MN2PR05MB6141.namprd05.prod.outlook.com>
References: <20191216174747.111154704@linuxfoundation.org>
 <20191216174829.761116794@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62a9d415-d3ee-44cd-2f74-08d78256eec2
x-ms-traffictypediagnostic: MN2PR05MB6607:
x-microsoft-antispam-prvs: <MN2PR05MB6607BA75C1E141206171DD00A1510@MN2PR05MB6607.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(199004)(189003)(53546011)(2906002)(4744005)(6506007)(66946007)(66476007)(86362001)(91956017)(76116006)(186003)(478600001)(66446008)(71200400001)(52536014)(55016002)(33656002)(9686003)(5660300002)(110136005)(26005)(81166006)(81156014)(4326008)(7696005)(64756008)(66556008)(8676002)(8936002)(316002)(54906003)(14583001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6607;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hhkVerr9q8G5BlxRj2knnnA8cX2zsBxlUPkHvRMG95+XLS6sGFzIepBhMZJ9JzEu8lYVbPvMctZO+m9Wes0P7gNBWce9jX8YvyDnw3ddT6AXaOWTnJH6Hrtb83o5I1TM8x9ZPP02IHFPRl7k/yPaPoPur6K3n3iT870k45lXaWsjA/L6+vGTRujMoDRrmBB0bAN1h0vvsReXG/Tg1l9pldUZasnNCc/tL1WttrT6aD3FnpbdhkJArn7BbAtoogrXJgBzgeXCX+lkHJiRMbqpc1iM5gYnXJ4WwNFIVpDPWRMr99IIkDetVHHrWkgGccWIwXok90S5t7aP+CFT9/F2lr5uwPIeLX65Hm8dF9eJPSAK9FDxImwg0g56mnRgryaRBgWJtPB0OIiaK7CMFZ6RgyOrVg6bAaZ66xhNAN8eXV/BsUsMQZwdufxbwjkDx18ZKuWiGkOXJbzhCNzXn+D2Yvok/eI4ghBYXsLsKPpRptU869/AfhipTgsO9WKJYhJO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a9d415-d3ee-44cd-2f74-08d78256eec2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 18:36:57.8967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nPm4snmQZcUSqdl3udPL9DWkpUCCQ/xP59WFR4wiqRkybuX5T6K0q9ruKQi0q5JWz50qKBfISL/Noe0SyjxLaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6607
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg, Sasha=0A=
=0A=
On 12/16/19 7:07 PM, Greg Kroah-Hartman wrote:=0A=
> From: Thomas Hellstrom <thellstrom@vmware.com>=0A=
>=0A=
> [ Upstream commit 625110b5e9dae9074d8a7e67dd07f821a053eed7 ]=0A=
>=0A=
=0A=
Just repeating to make sure it's dropped, since it re-appeared again.=0A=
=0A=
Could we please drop this patch from -stable for now. I'll re-nominate=0A=
for stable with the correct dependencies when it's seen some more=0A=
testing. It's depending on another patch and it's touching a code path=0A=
we definitely don't want to break with unforeseen corner-cases.=0A=
=0A=
Thanks,=0A=
Thomas=0A=
=0A=
=0A=
