Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19F6A8C0D
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCBWnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 17:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjCBWnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 17:43:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88591FF33
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 14:43:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBLzioG49EKLo5u7tMDLVY1Cx2EjJc6TjapNoGpwzMShhzRXNHvSb/w+DVAp0lFuqtghrI2WLuJ1opFKTcbHl5Vcagc8sAMYNYNKefn9S3T3rVuW8VLlSFp5e0Gtrx+aGnhq0BnI8lNc27xo0+XRyVUDYQJTngE570GCUAQp1ZmNNRZMtiuAWl2KiJPSdqvdgAcnvLne+OOuX5fRMMa5MX98mxE6tUJTroCXUGSkD6aid1hauEblMNxlW8JfY4ppDo+Lr1SH6zEvvfZ0hweBYoADyD2S3Td5KU1qUMqdo/eYgTIv5gSLuxVD/RjwI7EkAymngDBp+OTjUyb9YTwiJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVdm8XQXEQu3UldcWzpQiftvrNQ4f242r70B6l1N+TE=;
 b=QcrAsevPxIxJDoLU8XK4StdI3tkLMxX9v4jbkO4OTUrbZXEWHMWmIZwB+QjouEIyyD64+4nLewWD8rscbH29SPmWnOY8f9hrV4YRcf3kXlP7OpXhvp0F88nie24m3syyFTWYYjT25QtguOvnsiPzriqRihSNbWt/PkNryOu+hit7HA5DhWId2tBypTWrT5WEHZCVCclXMfY9Kfj/9oxu2RLMcNFVsr1adwwb/G++3pxBL42bRIalnJQS97ScjhPIypTVAfLi/pUqtE7IxIGDhiyn3J4L1vKmtqQmyOF9izTcURaCCU/24yGBK+hA2p2sc3TcoukQy0aCyOnj3eRmhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVdm8XQXEQu3UldcWzpQiftvrNQ4f242r70B6l1N+TE=;
 b=T8dNNMYpJQQ6cUYVJuSvaTNaTzlAGvZfv1er7PfYuGLAFxSip0H0v30wUbyeR4+OGBOZxEH68C+CGPjLXVBbhBNlZy51iUk+1gxQOUVJ32WJHSz1e3AQ+ZuLLB+glj0mlyYfzpI0V7TokIslu3yY5VtqP/3X3lUT5MbPuuSIi1A=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB8124.namprd12.prod.outlook.com (2603:10b6:510:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 22:43:03 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614%7]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 22:43:03 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "matt.fagnani@bell.net" <matt.fagnani@bell.net>
Subject: Fix for AMD IOMMU issue in 6.2-rc1
Thread-Topic: Fix for AMD IOMMU issue in 6.2-rc1
Thread-Index: AdlNV6zn1VTVPnnxQtyko7wk9C07pA==
Date:   Thu, 2 Mar 2023 22:43:03 +0000
Message-ID: <MN0PR12MB610172C57B91DC97C5D7D6F8E2B29@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-03-02T22:43:02Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=207411f4-1854-487e-9952-deb3588fd9bc;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-03-02T22:43:02Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 148604fd-dac3-4524-ad81-44c404ac5611
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|PH7PR12MB8124:EE_
x-ms-office365-filtering-correlation-id: 18f52f00-c1f9-4a35-fbdc-08db1b6f7bf5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ryZpxfnye2uE4oS+mI3OI7OdCnqYb24DrvOBbQleFQRi91Qx46S34gkiEqfIq6LuCyGwKiUh5VkJ5eYnW8WBh41s9UTLPRK8bFmaAHsSsnQgXxYm6336mCKGxNd+WNKM9n4qOH221+E4FvY1xCOXvglEfw424J70rnDsRy+ZkbbrOv1L3J2Sg7jH4MwCp6U51KotLhENleBKSp637r64qEn3Wr4TQ0+2p1m2uMkxkQ4SoBaaQFJsJFLsZx3c16VO2slnDDjW01wNJCBJj8rOQMXOqJ4s9TqQbhgeeB+J5QyXAlwUt6z2fBe+b3kUDEeom84sdNQkgAmlMcxJIFzQi0yHp2+WlLvVg03rIsqurUH9DpimiTpVHUvhEIwE3owI/epnmh/yjRhiuYIPSdcdSd7dFul3oHnQJsirqqVDqa9gwM0K6WXFBxKFIdvUiE1jHyEId55lfl2a5uJxUFmt57iOaLG12YbVb1XuCQ8gvn3agV9LyIVR/inAPqRJpn8f059UPqhAp5v3Ok7o01HbhBW6CzQSTjvkaR5yWydFA+kcbPMiG+xD9omRO51specifPfrH92pLbliT2CzcsXH58/KJzaeQDF4trh8423oMxuTFO9fC6RZnUigV2fIXHW6mRZIJdZKX6U/SPCAYvjQ2vJ3ZhkTM47OHdp9AlVkTjxD8lYSQ6Q29Oalz+JlutnS+NFMeM7608WLErXCdTDSCznLBSyVA3nrtGK2Js+ySwE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199018)(66476007)(33656002)(55016003)(71200400001)(38100700002)(122000001)(5660300002)(52536014)(478600001)(8936002)(66446008)(86362001)(38070700005)(966005)(9686003)(186003)(76116006)(6506007)(26005)(8676002)(66946007)(2906002)(66556008)(7696005)(4326008)(4744005)(64756008)(6916009)(316002)(54906003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wtz6vsDghycfUKVtGRUZmIDK7Cz5nTAtAmEr1frWgIjkZnIsghfQqNerO6g4?=
 =?us-ascii?Q?ioHniISte9FxqxqCqRvYNpRRDIa+w6tsfnXkkW5G8LitMwUq/5Zo53HNI0hM?=
 =?us-ascii?Q?3ey0wTYskI86hD75IT8b87lwlODr6MQzu+OWOXlpFLydJNTPq1Q1TpIBYXBQ?=
 =?us-ascii?Q?CUrONT1Lppg4gd3UJlRUXP7XR+IjISJ++ANrO5Sl+WBas0LyLAol8bcFlgVV?=
 =?us-ascii?Q?BLrZWgEb2EHGoi5pv1lobBDqCkJU8R/0teZtCS/BIORQN9n1b3FYdmDwgFQh?=
 =?us-ascii?Q?dtUePz+WNaMLmD3Bgo8LWGVRRCBzQ9VnuECI0lyg+SK/UxlTa9nQsfbpFxQ0?=
 =?us-ascii?Q?S9eN/7863Y6BLT6O3UyrBppAGq5LW5cSckN8LdNgSTFpfXYIa7iKoVC5qdhc?=
 =?us-ascii?Q?FaPWUdVRIKscnNmmXM5yYLrTN12I25rfQSeKjomkTFLo894ubtcC7kubpi6v?=
 =?us-ascii?Q?xENmBYd14Veyiat6CdSG6MnrZP1IFa+kvuwLHrXf9Ov0rbxyDaWFlr81Dats?=
 =?us-ascii?Q?svpjyEjHtdi5P4jNmmamhoyAsU8wKE0E5Hm8F86d7l5xXrVeZfLy4PtXwGwN?=
 =?us-ascii?Q?XKwVOeGy7vltUVYYhfWgJ2BXhKrkSS7Ga2uPDY7MvHLL/DWjJIWUcPkxUZcX?=
 =?us-ascii?Q?Xv/C9RppuGqmD8EOQRuyQ6HGPvFkTKVLWirJ8QcUr29AWMuz0E/p5rmLSkkh?=
 =?us-ascii?Q?aMeH7QlL4bEIIlVaH5Mt3sidJEIc85PdGZsd5tOSzUwnGnoDh2pBTVnvnCYn?=
 =?us-ascii?Q?3ViclKFSYqXctrou45+STkMO7Tt3U4rji6HJg04N1fEIOd/Je6rsbklpSHtN?=
 =?us-ascii?Q?ScbpyqUPHV9DAehLuvtzsOZFu8WO5Dmpvf2+97sU1giBlCs1SigS1vAevYzK?=
 =?us-ascii?Q?oOkyZe5b/oTXK3ziQSbiCEEgaKX9QzQYa0zvsFz531bEqBYOOg2wWJ3+h5vj?=
 =?us-ascii?Q?GU3RvbL0m0849+qD87ORSmyxvID09Iv/oKDbhgujxWMaMuQimFfBbMeJsGiM?=
 =?us-ascii?Q?INaXJ/T9AisJkT2BWi9Ie8V/WvURTrvK470o3B4RQtaeNimJw0Jj8ufZ21Ef?=
 =?us-ascii?Q?XKH5Se+TeuGNIaScaktGzd6MiDn/ZjZBGckovjPC1NsX597DGOlt+xvb++TC?=
 =?us-ascii?Q?qPf16kzy2EkCuKEGNgom1datIRzrs1UP1V3IsISuB2Y9UoI+2wYV1DwWWQcI?=
 =?us-ascii?Q?XFCnHRb139EezP7qmgIPtvdt8FhTaoVfrQXQMGZQ/rXdtpiITVt3Ztl+t2DP?=
 =?us-ascii?Q?AsnwblWSpNWhQynwQ6vnhpL/F0sHsKjMV36N0J9cNtItnqcue0aNrviWv+A8?=
 =?us-ascii?Q?0GBj/0UahC2jRu6UUtWtaIlprftbU/nt4WnjtsHlbsvEDbg6ro6opt9l7Obn?=
 =?us-ascii?Q?02c/BL6zz//2+eyFdfceGcaVQk50/bZ9tpaIm6uUtUaBJxzi/dani17ESqpQ?=
 =?us-ascii?Q?SmAuazF4gOVTA3vweeau76UrnfVW8DXOBYF2XVJ4cswir7FRKmCtfJDUa9wC?=
 =?us-ascii?Q?wo/t3U4/oSsfJ+VYyUpzGA6ZW7qQQA7HPl9jevARgo9KKHvMcB6F0RS6IbpG?=
 =?us-ascii?Q?30bPzfv6WqgM7QNL7KM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f52f00-c1f9-4a35-fbdc-08db1b6f7bf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 22:43:03.7626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6c2/VOPRqw68DbixcF5yjwNe4d4+T6qyJoql7l1hTMEFXMpt3Z2uaOck8zzqDYx4A9MGeV1iotqVR+TrFYfMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8124
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

There was a regression in 6.2-rc1 that caused amdgpu to not be able to load=
 when IOMMU domain isn't set up properly
It was fixed by these four patches in 6.3.

080920e52148 ("iommu/amd: Fix error handling for pdev_pri_ats_enable()")
f451c7a5a3b8 ("iommu/amd: Skip attach device domain is same as new domain")
996d120b4de2 ("iommu/amd: Improve page fault error reporting")
2cc73c5712f9 ("iommu: Attach device group to old domain in error path")

Can you please bring them to 6.2.y?

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216865
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2319
Link: https://bugzilla.redhat.com/show_bug.cgi?id=3D2156691

Thanks,=
