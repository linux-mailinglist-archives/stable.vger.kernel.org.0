Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC25FD3A9
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 06:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJMEBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 00:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMEBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 00:01:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACA112572F;
        Wed, 12 Oct 2022 21:01:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8oJBVR7F/9UgKKC0XYNfs5ezRcMrEKADA19Po2IDEYOL99INQt9Gn2O148QHtfrtZMEKDXCpYTgeh4rEy60WnO7UOP1Puv2rO0/b3KOLN1joERi9o3HAgeDHp4tb23pPwYbYWk1QsRmbf1fXtXSlPXU35MyCsgMxY4NIh2ewj1YcjcIOEFhsnz348L34M/y6rzn7lkp1GbN+uGx/LqzGLhZr3asJbchnv4fDngDXly9tZ+aSbyjL/kLjKoNzAfK24wunLaiJvKBuj5QcZORqB3quoBztdF6ddQeATjiNuA5LNoOILycU38riCrIgonsHQtdphVmmdzmp+aHmJLZtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbBcoK6h1bQSCtvjdCz+gldH/sgKb6d/L7lIxnRpf6Y=;
 b=SrijKXIKteTGng1QMsXhPAvENxQ6H1tpOmrr1tDFDRZdQRI7U23XEEu31Bkfd9No07w/pkI30/SfIowoPYdeqVkWvIUNevNiwCfxz0w6JD2X4a7SIPl3hoh4oxW9k1OhzVqp2DOP2TS7M28bzwJ39N6gd4qAtxiwMtcyrrmY8wIb08N5gFiGRGjhPIJB7I7YOXzv9TGOTEBjlrPwjwY+0JToGlA8xuszolq8aMqHEIIgyGbqUJuM6vkwKf01BHYAj+7xRSk0O+Bg8SZH9/G0mVu9lFUwvGYt1+XwLALk+zWkixFJ4AXay+FjagyJrYmORQygKY13iBkjpi/vigKTAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbBcoK6h1bQSCtvjdCz+gldH/sgKb6d/L7lIxnRpf6Y=;
 b=mmJjaKuM+yMKoYwVxCShhGbirhdkdZX8WnKKKHqkcf4oDjA0flD8LnlpDZFjviGr+APfCS0xGASLcfkh1Wkg8LM2hNIMRnLESocZfHNpOBm0kgZulrTQia/3wQ6z2tBWcMveoRqMhCrp7VzCHsy5gGSCDaDLAMyS/u7SBhOiAtI=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Thu, 13 Oct
 2022 04:01:29 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%9]) with mapi id 15.20.5676.030; Thu, 13 Oct 2022
 04:01:29 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Allen, John" <John.Allen@amd.com>
Subject: RE: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Thread-Topic: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Thread-Index: AQHY02p0eBeAgQpQKUasEaFL5KUsXK4Dbg9QgAcmAwD//+F4AIABMWqAgAAjE4A=
Date:   Thu, 13 Oct 2022 04:01:29 +0000
Message-ID: <MN0PR12MB61019C1F5A24EB8163EE04CCE2259@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220928184506.13981-1-mario.limonciello@amd.com>
 <MN0PR12MB61017C926551A7F6D908F6ADE25F9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <Y0aJhAmgF1mpxqNL@gondor.apana.org.au>
 <4e1bfb2e-cd9a-6b41-520e-dbf3746a2af8@amd.com>
 <Y0dwG90y3VrVtc8w@gondor.apana.org.au>
In-Reply-To: <Y0dwG90y3VrVtc8w@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-10-13T04:01:13Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8a658a34-a16e-4adb-9aba-ddd8188f4b0c;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-10-13T04:01:27Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 21888c6b-8293-4533-8841-76fd8663f140
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL1PR12MB5270:EE_
x-ms-office365-filtering-correlation-id: 087a8acb-2277-4ebb-8390-08daaccf9b62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7I/rOrtNa0JcBRO79V8ONIaKw2likuRrsGGAyghT9CFA22szyT7ug+rPJCXKscwkq5iFghXV5dDiJ6uERiXIeeFOVXPbWLQ4x7MLQKICSCJ+sJoeN7QCM8BfGansmOgdae+x2eo7iy+QF+AhXIx6qmDg27JwRhxbwrK8UuEC2twlLjob1PRUId8NWJpCd7Il5s2kLZD+vek57ISeblIKiljJ4Uh8X4+s1D0BA67f3BFuMmoJplV1I5lrQvnvhbP5dFELJ1XT71HB0tKhOeEaDF+UsUIeoBr2P86+CTxT1PbNRG+FZrCkMqfoA59f0b1Zx5677ybD7OcBkAzvQIvvm7qDSS7RY0abbQ7g9vgLXMXNq+0ETkm7gLzb0NXNSm/SuBV8wa5JZ71CuNPRz/g6Vjj6QYQqWJQqSaKMVoWCy8Z+FIt55CwM3Co1tPUI6+Jp9EvlTkiHu79+Oh/tf+gPgGiYxLi2jS3BL2iwEowdAX/nr/4WI7WJIQ0fPbjo7zVLeanZv2dlO3aBDm9etb6rD/GPsk0lmtDW+MxZvpbvRj9eq7fRV99pvLEowQnZfzsvWQYc/6kc/mMSwqZkVww1uPRust5/NCowLVr4O040p1OCQFgzY+0kWCcEwiBCw5/s+ZnNK9GWz3FtgZ0Cd0Ug9xnuuoKk4FYDLG9K8ts094MIIJU7ibT4Cv72acUKUhFnEetcm7GKGPJ/ZCUQp1JahRuWcY0VkaHeWFY7g2RYMNKCoSpr3kx30Oj2YJEr5rtnQCoX8tqD/XIaXutxOuSpcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199015)(54906003)(66946007)(76116006)(71200400001)(38070700005)(38100700002)(4744005)(2906002)(5660300002)(8936002)(66476007)(64756008)(41300700001)(122000001)(66556008)(66446008)(8676002)(4326008)(52536014)(26005)(9686003)(186003)(6506007)(478600001)(53546011)(7696005)(316002)(83380400001)(6916009)(33656002)(55016003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7w6iUSUXMLoijz9xNPglBKk0uo3ilAo8WnaiPM7pNaZxJeYkIwHwp26JxFsn?=
 =?us-ascii?Q?SokNpB6SbuvfIVg1VkcXlIK+ZhbYZeD1GtrNdiLqq5H4ECTGw7liew3MaFfo?=
 =?us-ascii?Q?OS5jwx+i0vg7ud03hIw/5obKqhcSZ8xBm66uWbIv70uEs2bUeUm4oMedG5ay?=
 =?us-ascii?Q?I8OJJRGW6yNyLtKs2urvQby9JdQp2/ZWZYWU7EO3cuplG2T5n2pUa7id3Kvu?=
 =?us-ascii?Q?RS+uV958i62tIArypi47xWmN45rTqN+/FL6v/UgPyRoG2y0yQaGpQp1OGz0I?=
 =?us-ascii?Q?0/T3cCRNg+avTcnghw8Sm3anXsqGmsEXKluV/4ZOev7Jd027YHpsih+GdPZy?=
 =?us-ascii?Q?Ubvr27WEAVfcDb46nv4vb12R8bnXGvcU4r8cI2uw6xC54QxP5Gzkor5FnVGE?=
 =?us-ascii?Q?ZbTE+SUg+OHjxndxzsLa/uA01SLqqi4s5ElnlxlwKRcQE5wr86U9Q0XLb72n?=
 =?us-ascii?Q?rNcW/roytUf55eIGvZrcr+M9v36qU3meZ2FBXrQxXPaXEmp9dbAdp5j0XNDU?=
 =?us-ascii?Q?pBRilc5Jzvr3v3WYvreehNyzAGvyyNBpcSC5uicGqjUMVw16cDxh13fhQ1+a?=
 =?us-ascii?Q?wFWsjhkj0k0VXI+DBWhf8OPO912OFglp4b+I+/JtDuz68E33DQ7BJkBbkapH?=
 =?us-ascii?Q?bHoHksTUHhTFkGEpeBVD6LxL0dbMAQNIJhx9G39M3B4hjOhC1o9OKYZmzrr/?=
 =?us-ascii?Q?JghmXj3xIlwME9AUCengMZiKQNAwsr0+0my3kyKxwEUIBmdFauVYU6vXXYzi?=
 =?us-ascii?Q?OLs/ekX/+PrdUVQOIUHpziDDGQqw7aRfQ6/aUygh02uaj21IOKW48jpHH49n?=
 =?us-ascii?Q?fWbJdCS/TIPxQM5d3wwJlkGlsmK1wgcHorhrPSGXbYIUUXIt7Km91luK7z7m?=
 =?us-ascii?Q?GYa8yojo+sKsjLRdI8ijs2F/MDGRy8KYyuCJ68ABwV5i//85c3lZ+uR4ZCPf?=
 =?us-ascii?Q?9DrouUbJ1Np5n2ofKvILvq4TsgjJEg5/CUhGoJP0Zln0iStAvwLKUvkWTrC0?=
 =?us-ascii?Q?qhggY+3mxKfqvDx/3KwVNzsLPc+JD/mXkXgdYGFh5nGmElCGxGWIPxjPOLgW?=
 =?us-ascii?Q?y90Cz+kapSRUR30JC2TRHGF7hAk0nlrKzL5lH2bpjv8WgS0pM6AQ2yFmQpI2?=
 =?us-ascii?Q?ILpQzRaAOHetXi3OqQiv/ob8MwOWLNT6KxMiAW7o7yJ52MUTgmLhP6cfPvf9?=
 =?us-ascii?Q?NdEpnzt61JsxWCLKNgaEja0/SxwHV4Hi97gPTeENxydN1PeOfhSPEuSAoI4V?=
 =?us-ascii?Q?VxIQ6sYehTFneRKsEsNc4rUPxp5fOpxXTWxOeUgTeTsJYKS7fAoqSumps86s?=
 =?us-ascii?Q?TOY3a419vEevgYfgS/gWMzs41jQYKnO3fJ9GVmYapHq5iOPZgWTmTT2ov/K4?=
 =?us-ascii?Q?sPfvGScFfwKmN5EEsqMSPttv7q0tUBT1GJ5rrVcPjG3bSR9olKIvvX3FAXiI?=
 =?us-ascii?Q?UXnyERsVCJxguJyes0mdKZQuGgDo+1TQHXTRh37Qc9P22NjG/ShzzOGLut5t?=
 =?us-ascii?Q?rLooe5SPdHvriLtUypKEYF0intttg53/+SQX1iJDUPOoc7ylM/1JCWaIljh2?=
 =?us-ascii?Q?XQkPSTl9KQ49Gg/k3MM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087a8acb-2277-4ebb-8390-08daaccf9b62
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 04:01:29.1009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FJoT0T70HGLfTGvF9nrA5+om8RkCUalA6hLWbjbwijLgkhoLoJgcdBwVNW/bAzhpSOMQfZLSDA6WTFWQMh2HuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Wednesday, October 12, 2022 20:56
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org; Thomas, Rijo-john <Rijo-
> john.Thomas@amd.com>; David S. Miller <davem@davemloft.net>; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Lendacky, Thomas
> <Thomas.Lendacky@amd.com>; Allen, John <John.Allen@amd.com>
> Subject: Re: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
>=20
> On Wed, Oct 12, 2022 at 07:42:32AM -0500, Mario Limonciello wrote:
> >
> > Some other maintainers take new IDs as fixes.  Particularly when they'r=
e
> > good candidates for cc stable.
> >
> > The main reason I wanted to see it sooner is so that it has more time t=
o
> > percolate to the various downstream distros so that errors stemming fro=
m
> the
> > lack of this ID declaration aren't prevalent when using this SOC.
>=20
> Sorry but this is not persuasive enough for me.  If you want a patch
> to make a particular merge window, make sure that you get it in early
> enough.

OK thanks!

