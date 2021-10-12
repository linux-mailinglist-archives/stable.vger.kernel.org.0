Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069C742AF1E
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbhJLVpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:45:11 -0400
Received: from mail-oln040093003012.outbound.protection.outlook.com ([40.93.3.12]:1757
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233650AbhJLVpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 17:45:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hl+dEH2T6oDXffxD/f6pJ94lXGEAtM/uM9++GKa5dKQyfKOIAjAkacbcDwp1oxUMgcXSN2ma0LPcEmZ7+3tSUfStc0UdYW/kvWUAwj3bEJgB/hDA3Gp2CLAyxxlputFB8dkZvmGiw3XMobUtVtCWAcUkKjl9e6ueeh0bjbBWg+58S5xi53qmK4cXm2zG96Brh5ArBOWi9X1XMlIzkwH1yre2VOb0fGnz4TS3AfsbmAkRTr7DnTRg5AAci8pChyT5jQD9U86wjaH709zu+EziTA6s/s1c3P5jzpvzlNPhOl8JI6WkMG4OL8WZY1Hd+kVbDsJ1SQJl7UOh8hDNSK+wVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eosFYZGt6mQ3K0CQ8mh21xZ83AU+ARFQHNHqFOFNnEo=;
 b=j8TzacB8wsYl+o4Mhv650QjaLayORBwrMQ4UDk/7d8EOFHCHUq+aIfllRzq5sZfRxAAxsbP3f07kqyARDuyyt6LRlD5wK2XDpmgrJxPCIqXK1e4VCIFAKg1V5+Rz/IA1o+VUQH+JIlYpxgJDnCV+fdH8fxEBrfd4zN9bkTmPlu8zF/HTG9m7U+2mCloPJRfjwE7J25VDa4O8/DHtPguYNbnTTScXAOptZ8h/7eC2xoazski2OIYb6pBlB1RRebd3VoP00R7bhM7ruecyKsABIWITN5g77Thay+9RFxfDCepaIVac3upMmPJ0wnVUgstPPvnxR1VesdG9+QyVysWDsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eosFYZGt6mQ3K0CQ8mh21xZ83AU+ARFQHNHqFOFNnEo=;
 b=QExuFLUigpOs1GE/G7+VdrqTLI8DIO4lHn+ZWmHlPC2yeVgmekidFi4V0ZNU2FhNdVeFmAcBw4BOMqFXGR0i5+pZYOcwHSXDuZAbF1ibxAoc62iKxjoFGx6IvizEX3H4MyWZXy/rE7gkiBn5IQq1JUL9PD1pmfB8JoR/tvb/GfU=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1311.namprd21.prod.outlook.com (2603:10b6:a03:3fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.4; Tue, 12 Oct
 2021 21:43:05 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9ee:ca13:3fae:4faa]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9ee:ca13:3fae:4faa%6]) with mapi id 15.20.4628.007; Tue, 12 Oct 2021
 21:43:05 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Thread-Topic: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Thread-Index: AQHXv4gYaXXuoTkdsESnUMEs4EqppKvPpJjggAA8aECAAANbwA==
Date:   Tue, 12 Oct 2021 21:43:04 +0000
Message-ID: <BYAPR21MB1270BFDFD061E04E90404D19BFB69@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211008043546.6006-1-decui@microsoft.com>
        <yq1pmsaqjrk.fsf@ca-mkp.ca.oracle.com>
        <BYAPR21MB1270CD89180A7979F34682EABFB69@BYAPR21MB1270.namprd21.prod.outlook.com>
 <yq135p6q8k3.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq135p6q8k3.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b9f3926d-7393-4061-a935-e05c65b92a01;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-12T21:40:01Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d01496bc-ed38-4ae0-2755-08d98dc945f9
x-ms-traffictypediagnostic: SJ0PR21MB1311:
x-microsoft-antispam-prvs: <SJ0PR21MB1311F2AACA19A1B069C11ECBBFB69@SJ0PR21MB1311.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pNZ1bygN7mVr57e3q1DIKawaji3uGRnBvlOaiIHEEzvjsJ4pFzHfViiVL6hJaB2XmXdsiwOt+E5RLKlntPsX5Ga9+Czo6wnB2cePNj+YFfTcpeDnEoQYCOhQ2AnHVvREGDK8jjkzaJH7uIqsX3r0C2j+/sBQu8MG5/Y5omDzJe34RfiszohfOa10l8eNL4H1/P7gvaOfiLgB+aC26r72/7Vu+I/MaSdveSJib8XBl1P107R0BmTxMd2cJ1LDOhe41lkAKlJ691XQIKWQEnn+07/fBkFV4CWXNaB6NvB8BjPXFyASG/DVpFkSXKweL7pPwrs8ZV8XY0xHD6Df5gnVixIWhIsLMnqNPlGnhPTo1gkTlZkuQrc/vdVEik7gvtZ5kMADHW2PJ1HtZ89WuM3k+1+0wcdRGKM+pcomrqDl1VZv4X7zGas6BYlft8heAicTy3DIMUp6HYyAjFYmZLRtEeC2zQipPJbCHnKg3R2knqDfaqoJTfNGLouprG+hf2KzY7ENNPw7BVwaJdOwDKzA4a6GUL04gp+sFrA2t4FfEr0kJ8+J4D7FQ+alcd5dI5ufnp0mrsy9O+aXaEcWpf03tVEoutzYg9cH7oDF2cRXuGLwGmfZvq/WL6zA+ei2dmNyrCiSOB+8k26sTYJbYFmCQF4vJvAKx8f6zkc3bMjsBjDOBHv8f+pMvUu3vhnJMuLGXXdRvkXBzHKmUSpT9EroDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(9686003)(66476007)(82950400001)(66556008)(71200400001)(122000001)(7416002)(82960400001)(66946007)(8676002)(54906003)(66446008)(10290500003)(38100700002)(64756008)(86362001)(186003)(26005)(7696005)(52536014)(6916009)(316002)(4326008)(33656002)(76116006)(5660300002)(8990500004)(2906002)(53546011)(6506007)(83380400001)(38070700005)(508600001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4O50zpILPlHAURRSXDf3pO+Tjxb3k7aXNNygKA0TTj1iYQWIK191OBOiFEeD?=
 =?us-ascii?Q?ZDRCSt/m2UZKfX0ek0tQXUSBscoCtKcMzttQUVLsEaAHeZN2Jr8qk8mREVQ7?=
 =?us-ascii?Q?SDkVpv1x7iVLdWjKOHcIe1YQQ8Y62xu8e+p71Q3t0amT9Jw1uCAKgTz3mhBQ?=
 =?us-ascii?Q?mXpM+G0ATNZZP4oxsaL45NvojUmmv2N8FLwifmzfJ3+onZ/I1w1Vi3s3RKN0?=
 =?us-ascii?Q?lwrPPjc68Jh00NacwldOvfmo2dx2wvEfX5/jlsjbLgNuuuqjUef2oXMK6HAL?=
 =?us-ascii?Q?CkRUy8Ic2Qj/wWr6APHSaQHWM5jluO447RbjrqMAA15BhKzGU5QI3ms1ltfw?=
 =?us-ascii?Q?IZHxQaLgY+SRmZ/OK+NmgwTxvwzSxE0VOLiox7IBKVE0f+UqzvBsE0qSK4Uj?=
 =?us-ascii?Q?VZ4IydZMw9u4RKRBVl1z1z5q6iRHZlqTnMCzjPm799BYnJQNfCIRocCFosQ2?=
 =?us-ascii?Q?GiNKezNVczKU23xY9wHGzOzkyQpUk4qKJsQlh4SZ09dtVFHmiB32UQspX942?=
 =?us-ascii?Q?CJq46UGumfgVeQtMIru6onCUEbNVdqqvQvqcVVloMStM1HWQ6nTI/YYtcViT?=
 =?us-ascii?Q?dxlq9xEgIoAX+rqs34yxzI6ISy5l8JqOvXcTrxcGEp9Tl1M5IBk1+p+mToy2?=
 =?us-ascii?Q?CybBAJyj7CUga9FoRMmbmVt6QL44h5IAENu99CnMg0hUHhgAeh/VuvNzbuOg?=
 =?us-ascii?Q?sWnqBJthhXNAo0ZRuacf0fAUMx24SIGCZStZS6EwBdwbxY1Dm7RziBVBL8g4?=
 =?us-ascii?Q?YYGs17ety2BGLUFTF28T9hPH0ZzgXKt/zzSBlatE3obQNwOqUNLIPzvCfr7n?=
 =?us-ascii?Q?+B4j7GXa1NjvXTo73ARTrSex15Dn4v4EIO1pXZSC0MkT+UW5SNB4fdMbcwuk?=
 =?us-ascii?Q?51pHORMA7xpQ7CuGlTcO+VYq5r2QhCqm41M6i29TdKu6Upnf6L88CJrd77oz?=
 =?us-ascii?Q?/6ODtrpk2Ta/keK4g9QgltT3w6QdbuxNlFcFk7OlAqVkOdxgj7K+11NOC0hK?=
 =?us-ascii?Q?Lb5g76eLv2R8X4B2BDuiSlgERXbAzXp9aNcvR5YjQIAEuTFfaxaQ9lyPcMy3?=
 =?us-ascii?Q?ylZTibQZfaAE2WadUP5yQghAtKiAJh3TbckaJtUpLJue69Ac0b4rqvJbMZh+?=
 =?us-ascii?Q?C1JCAUdKzKsOltvp1IMTDj98gPNt48Xtdnr9lROJZkNsXVEJjz4iTWktemE6?=
 =?us-ascii?Q?XcGH0J8lHU32zWlOpI8+C8GOBIrjoc+4PSC/dAku7Ps2pAaDJrY2Huo4Yimu?=
 =?us-ascii?Q?O9LXHza4mcg2Agj/Dznhe8gIN5U2eHpsf/PPVIMHPX3VHE8YXfGB5OMetyju?=
 =?us-ascii?Q?z6M68Y1OJC+2Kv9Tba7NVkGu82/CZeMJULRo+nk5geo0M5Yhl92J4FDrF2Mg?=
 =?us-ascii?Q?1/5ogNZ9z9ccETdVQSC0J2fLaZ+weMCJeQ9WGIqkmykBiX6SuWkWZvi+kae3?=
 =?us-ascii?Q?ZBEJgsYT66B9mnVjIRwDF2RHDV9Wrld9NPFbMxpvq4jYsXw7kCrWBkf555S0?=
 =?us-ascii?Q?Srl+8sozKbJgxc59bRXi3im3yhSQRRrtcPmPhg2Unq+SG11on/cnm3u8DAEf?=
 =?us-ascii?Q?e8f4wnimkW5l9702T54YIA3vjS8qRbCqtteCZbymAsaj4oNbC/ui6+tbJxpK?=
 =?us-ascii?Q?C2qJFPj2yHmT89YMlK5MW6M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01496bc-ed38-4ae0-2755-08d98dc945f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 21:43:04.9336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ouTy9vnFdPRl2Sc4dhKuyZGCGLlLWJAwzh6TgVOML09jcKWWroFYWn0i4JqCON76/NqR2Zq3NqPAR1As6AlJDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1311
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Tuesday, October 12, 2021 2:28 PM
> To: Dexuan Cui <decui@microsoft.com>
>=20
> > Regarding this patch, I'm not sure if it's a "workaround": if it's
> > incorrect to set a bigger-than-SHRT_MAX scsi_driver.can_queue value,
> > probably we should change scsi_driver.can_queue from "int" to "u16"?
>=20
> > BTW, I guess the "cmd_per_lun" should also be "u16" rather than
> > "short"?
>=20
> I agree that it would be nice to get all this cleaned up. Several,
> somewhat peculiar, 25-year old design choices.
>=20
> cmd_per_lun has traditionally been in the ballpark of low hundreds,
> can_queue typically in the low thousands. And the block layer currently
> caps at ~10K. Happy to take patches fixing this up, although I am a bit
> worried about how much churn it will generate.

Thanks for the explanation!
=20
> That said, I do think that cleaning this up is somewhat orthogonal to
> the issue with storvsc. I suspect that allowing a huge amount of
> concurrent outstanding commands is going to be detrimental to
> performance for most workloads. And from that perspective I think that
> the short->int fix, while valid given the type discrepancy, is just
> treating the symptom.

Agreed.
=20
> Therefore I consider the short->int fix a workaround. And the proper fix
> involves looking closely at things are scaled in the storvsc case. Which
> I have noted that Michael is working on.

Agreed. My v1 actually tried to work around the storvsc driver instread. :-=
)
