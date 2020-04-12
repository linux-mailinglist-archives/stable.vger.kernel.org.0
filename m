Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F12C1A5C4A
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 05:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgDLDdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 23:33:47 -0400
Received: from mail-co1nam11on2128.outbound.protection.outlook.com ([40.107.220.128]:35840
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726988AbgDLDdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 23:33:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkYNP4tatB3mgCNi8JYPQoju2MMn+T/JhpJR5rvOZQARSo8PzWpOlsMITxt/BVUQSp3K1AsPuLOdX1tY4VsJGQxyFuvz0kLPsFkjHVy8anTUSWDodHkw4k1ni7KPZnm33hJjugcfLR5geBPXUU/LC6LMNb57AAf/Pryu/03hChwg+zk8npH71L4CfThw9ttPL724moC5QXIyPCAZiOjGzg9xulAyb5zJ43nZn8gstJF3VOAVZc2Goo7NLPBWHEYrM4Dzs/FOYXPoV8U4o2toPm1wnI84xpdmGQYHbyT4eTRMCBJBrimSQpeKEyHT50+32/8acKC2dJrV82cxa5sATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8fUzuhEsdF03jqWbFNHNuCfFgQ1vFkkJUzMaRHusR4=;
 b=N29qIMregILTBI+w552CXVoEJW6sTmpiAaSaLMkpOdkqJpK7kLuzX224Go9+ySPZDsom3CDOBFlma8wnVTedAc/Co846ILVUrPgJN7rdatmY4HhUAfzVtv+/q6zAfCtZzVy5M5CCVotYKl3jdaqyh2KbEDUS2kHhmeqrWe0dTIb+GVldCRQlNl6GP/eoIOhjF7Nle9CjXxuNFFEgAhI4P8U+p7ed0C9ljTvKj5sKr5xAmvDl7oIKeFY+Nuw9fuRPsnbrn1AYIbUt2FEVvZ2YyH8bdRD+EHi0DOr6lZU+3i5TzbSqEHns+LBl/a3GSDjPG/stDeoyGuFTk+XDU0ov4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8fUzuhEsdF03jqWbFNHNuCfFgQ1vFkkJUzMaRHusR4=;
 b=Y9/LE4GkN4WiuBiya5k/66Up6ET/SzEYa8pTssB+Cp76XSht4WDnV+j7KfXpm90gU1kRa/vFkXiiN0+n79Rc2TMWlOAtSg4PsIkgwvTbcuLoISjmkzVq2LEGR6vmXE2EnORe4uWX9pi9X4Cvdhb89vSsv+inSo1YM/Y7o3CjnmY=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0987.namprd21.prod.outlook.com (2603:10b6:302:4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.0; Sun, 12 Apr
 2020 03:33:43 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%9]) with mapi id 15.20.2937.000; Sun, 12 Apr 2020
 03:33:43 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] Drivers: hv: vmbus: Fix Suspend-to-Idle for
 Generation-2 VM
Thread-Topic: [PATCH v2] Drivers: hv: vmbus: Fix Suspend-to-Idle for
 Generation-2 VM
Thread-Index: AQHWD79fbnxkR6YcIUGt9U2cZJm+Yqh01nUQ
Date:   Sun, 12 Apr 2020 03:33:43 +0000
Message-ID: <MW2PR2101MB1052F0C6473FA6A433EDFC45D7DC0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <1586581684-113131-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1586581684-113131-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-12T03:33:41.1453932Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a05b3300-4f4b-4034-a624-4972b3d1db10;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66171226-b9ec-4da4-3b44-08d7de924d08
x-ms-traffictypediagnostic: MW2PR2101MB0987:|MW2PR2101MB0987:|MW2PR2101MB0987:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB0987CF7C73639E6A07AE6BFCD7DC0@MW2PR2101MB0987.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(2906002)(186003)(110136005)(6506007)(8990500004)(15650500001)(7696005)(26005)(5660300002)(66476007)(66946007)(316002)(4326008)(66446008)(76116006)(66556008)(64756008)(8936002)(81156014)(52536014)(8676002)(82950400001)(82960400001)(33656002)(55016002)(9686003)(478600001)(10290500003)(86362001)(71200400001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yP2ayyKEpw2oHPi0FvoTAo9+q7j/PNPcQhYdMnu7TnlujUH+r9fdfRKCAJ3mcJpyQBs3Fy8HBHFjD6fH9ctBXXoyeCUA800YjYybsn6amCwAEe3KLYcAm4Yp6QRefPr0wczy/ZMmJEJXXwGPYjwUlBJbD2TMncqLL26kQQ5joxskRlBKjSqvPzXcq1U5P+tzJWQ+rqOprilB2AtmgC2AUAfoUy95dCZeRHILHDXIDzDfPxHbkJdMeKcVL6an5iHq8dzKDIatPrc/yxMXyTPg9h/fMJcG+1dtSDGzUHnsLgMULtvU4Zvyo2OoN1tkE7GVyiLcY0GK10yhfWyf+edPk99xxuWAtgu1WOMfgyQyGaQmcSC/iPJ+E9mt8JUCuZlrLdOPCzQ/Gdtp/o7EPv/Cc3m8KqaZbMAseBlo3IRRALNBPRgwC5o9ZZ49yxG8pyPu
x-ms-exchange-antispam-messagedata: PrfkCnK7BdPBMnvl3mxAH7zGWyBPePtMTeNUWg5yoLt00ZXtJ9WUJZM8+ziXMR6LlSWGh5D5372f6S+FmSNL327noiPfAMKjSAUdKqBGGBUBmdKGuP0bGVAkGFjP4+c0eFACddP6n4Yk9cSJOgn0Rw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66171226-b9ec-4da4-3b44-08d7de924d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2020 03:33:43.3841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BAvcVVCyJFpnZ/GsdLR+DjUt4JDDQRp/ac/3Dhk3WrsklYqxPtx1hzrzTkB3oKXdPJBzdrKTPaf7DJPKAC3jSzZAiI+pcyQ7xU5CmltTVNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0987
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com> Sent: Friday, April 10, 2020 10:08 P=
M
>=20
> Before the hibernation patchset (e.g. f53335e3289f), in a Generation-2
> Linux VM on Hyper-V, the user can run "echo freeze > /sys/power/state" to
> freeze the system, i.e. Suspend-to-Idle. The user can press the keyboard
> or move the mouse to wake up the VM.
>=20
> With the hibernation patchset, Linux VM on Hyper-V can hibernate to disk,
> but Suspend-to-Idle is broken: when the synthetic keyboard/mouse are
> suspended, there is no way to wake up the VM.
>=20
> Fix the issue by not suspending and resuming the vmbus devices upon
> Suspend-to-Idle.
>=20
> Fixes: f53335e3289f ("Drivers: hv: vmbus: Suspend/resume the vmbus itself=
 for
> hibernation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>=20
> Changes in v2:
>     Added "#define vmbus_suspend NULL", etc. for the case where
> CONFIG_PM_SLEEP is not defined.
>     Many thanks to kbuild test robot <lkp@intel.com> for this!
>=20
>  drivers/hv/vmbus_drv.c | 43 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 34 insertions(+), 9 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
