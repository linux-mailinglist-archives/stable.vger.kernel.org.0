Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2353D593
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 20:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391791AbfFKSgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 14:36:15 -0400
Received: from mail-eopbgr680111.outbound.protection.outlook.com ([40.107.68.111]:54947
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388207AbfFKSgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 14:36:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=J7nbEttadHTm4ma/j+KuoYq9umE0Z4DAtEYo3tgjGoJfQ4VG2cjPO4wXf1x6I3yzSvay7moLeb1PVbuXj/L7+LE4XN1jeGCV2GODNXOSrUc7xYMP6oFiy0PLD9iosc4JhEzOjOeds84mPPUuJNTn+U0ikDZkYIPKHW50RKPdf4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wlqhkqq0jZD3+JaoDH8D68E1QIBI3F/Zx9Z7+2re7c=;
 b=AGcLKG/ilkXDulNIwHbMQk1G2OOH+Qxlp5+zrz9UY1cWEOmZEhz8cHrGE3HP4ZxvY6GrJJPXCG8rhB3ad6a92+MZnuehOJGAg1QyU8V+qjAsY/IHoD3O/DaiIPfXwFp9AXqilNNg5o3CvhtLz/VET4gNb7pGQI2YCUI2D+5Yxkc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wlqhkqq0jZD3+JaoDH8D68E1QIBI3F/Zx9Z7+2re7c=;
 b=Od5hsTWRZeBDyRNtaBgNYKvAH8XuQssp3m9bipP8EXEXNBKtRUdNCHaDUhaABkw9HqypqUBpSasJI1GUbPSpr9ZSevbDGFpeT2NHcawGQmK2k+EELQi7pI/1j2j6Vrk+j0sy+F9TsuI2mQWFuGRHFAquLPADROnnPCOdvLCGlaI=
Received: from BYAPR21MB1303.namprd21.prod.outlook.com (2603:10b6:a03:10b::21)
 by BYAPR21MB1254.namprd21.prod.outlook.com (2603:10b6:a03:108::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.1; Tue, 11 Jun
 2019 18:35:31 +0000
Received: from BYAPR21MB1303.namprd21.prod.outlook.com
 ([fe80::d98:b97a:40fb:767b]) by BYAPR21MB1303.namprd21.prod.outlook.com
 ([fe80::d98:b97a:40fb:767b%8]) with mapi id 15.20.2008.002; Tue, 11 Jun 2019
 18:35:31 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoph Probst <kernel@probst.it>,
        Steven French <Steven.French@microsoft.com>
Subject: RE: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduce
 raciness in smb21_set_oplock_level()
Thread-Topic: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduce
 raciness in smb21_set_oplock_level()
Thread-Index: AQHVHuRr/qIHTPIzFki/7touvMYvRaaVQkzQgADMHwCAALvpwA==
Date:   Tue, 11 Jun 2019 18:35:31 +0000
Message-ID: <BYAPR21MB1303F7B6A672A491068A9D38B6ED0@BYAPR21MB1303.namprd21.prod.outlook.com>
References: <20190609164147.729157653@linuxfoundation.org>
 <20190609164148.958546130@linuxfoundation.org>
 <BYAPR21MB130347F749FFEC7025DA5710B6130@BYAPR21MB1303.namprd21.prod.outlook.com>
 <20190611072010.GA10581@kroah.com>
In-Reply-To: <20190611072010.GA10581@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-11T18:35:29.6162688Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8eeab497-ca9c-4ea4-9827-a4c6868db0cc;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:f059:bdc7:91b3:3685]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b884640e-34ff-4a21-13d7-08d6ee9b959f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR21MB1254;
x-ms-traffictypediagnostic: BYAPR21MB1254:
x-microsoft-antispam-prvs: <BYAPR21MB1254351D0E35693A30BCB69BB6ED0@BYAPR21MB1254.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:390;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(136003)(346002)(39860400002)(376002)(366004)(396003)(199004)(189003)(13464003)(54906003)(52396003)(6506007)(102836004)(6916009)(99286004)(7696005)(74316002)(10090500001)(53546011)(76176011)(5660300002)(8936002)(81166006)(81156014)(8676002)(71200400001)(71190400001)(66946007)(76116006)(64756008)(66446008)(66556008)(73956011)(66476007)(6436002)(9686003)(305945005)(8990500004)(7736002)(55016002)(46003)(68736007)(186003)(33656002)(229853002)(316002)(478600001)(86362001)(446003)(14454004)(476003)(2906002)(6246003)(107886003)(11346002)(22452003)(52536014)(486006)(10290500003)(25786009)(256004)(6116002)(4326008)(53936002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR21MB1254;H:BYAPR21MB1303.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2VsSBJ6D9I5EKG4brGvDLxeCgYBlNHCCunWCRPAs76kWYSQRwhPAouGFW2cepe/70wzzWC7lqEzH/z6smDUmjr4EZ6sjqFIGbXHo2rOAkA1fnqDOjBHEl8yykhstmawfKNwLtwqigLiMKIkpUUNxa+3xggcSztS4UEBAiVVCLmRcIDjM2S2gPqciRvNL3s52UUgnJ6IBDH4icJ59bjYwMNbnxgsj2IN304ut89g4NXmJeZd8tk3D6rsOx+sWOANFxemfZq3cqfYm8+erUnYzA4yX1gFABGHzE0nYCSD77cpP9bPadGJc+HR6apNJ3i3ZT1yPo5g7uUaC4RiLVMXeC6VgeFQVKaWh0JnGybKHgYktI5QaFdDK48P/QnbJ08iWG+mbPKM7+HiGLSO0VklzYzCJr3v6E/iSJMIhoEwXSmo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b884640e-34ff-4a21-13d7-08d6ee9b959f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 18:35:31.5197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pshilov@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1254
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----Original Message-----
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
Sent: Tuesday, June 11, 2019 12:20 AM
To: Pavel Shilovskiy <pshilov@microsoft.com>
Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Christoph Probst =
<kernel@probst.it>; Steven French <Steven.French@microsoft.com>
Subject: Re: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduc=
e raciness in smb21_set_oplock_level()

On Mon, Jun 10, 2019 at 07:13:24PM +0000, Pavel Shilovskiy wrote:
>=20
> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Sunday, June 9, 2019 9:40 AM
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;=20
> stable@vger.kernel.org; Christoph Probst <kernel@probst.it>; Pavel=20
> Shilovskiy <pshilov@microsoft.com>; Steven French=20
> <Steven.French@microsoft.com>
> Subject: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and=20
> reduce raciness in smb21_set_oplock_level()
>=20
> From: Christoph Probst <kernel@probst.it>
>=20
> commit 6a54b2e002c9d00b398d35724c79f9fe0d9b38fb upstream.
>=20
> Change strcat to strncpy in the "None" case to fix a buffer overflow when=
 cinode->oplock is reset to 0 by another thread accessing the same cinode. =
It is never valid to append "None" to any other message.
>=20
> Consolidate multiple writes to cinode->oplock to reduce raciness.
>=20
> Signed-off-by: Christoph Probst <kernel@probst.it>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> --------------------------------
>=20
> Hi Greg,
>=20
> This patch has been queued for 4.4.y and has already been merged into=20
> 5.1.y (5.1.5). Are you going to apply it to other stable kernels: 4.9,=20
> 4.14, 4.19?

It is already in the 4.9.179, 4.14.122, 4.19.46, 5.0.19, and 5.1.5 released=
 kernels.  So I don't think I can merge it into them again :)

thanks,

greg k-h
---------------------------------

You are right, I missed it somehow. Thanks for clarifying!

Best regards,
Pavel Shilovsky
