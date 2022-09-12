Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB675B626B
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiILVAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiILVAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:00:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D6715FD5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4K7amkD1q8+kuMNj5VAG3tDov55+hqf0b7vadG+CJI1UonR8XOW32NV17saFGRmVK1emmNbEJMeR2buRkLKHYeMIQj+n5VHc20Qr8z9Kd4oVp+UccKDbiLjHHRFzZqL95LinElppK0Eil+4ZMOzlFKJvUsiF/egdDnYUOw4auMh/5p6LIKRbC6aNpM1dy0tntzqLPTrCfKdoImI1eLB8tkGLXoXDuqdkgYR87lEfiKzhudhtuQQnHsEMXuJKcPoHMIYZPoqErbOFSL64VmPtoogc8d3uQSknUNBpvr1YkPqVZB+Dop664eabQnMFlAQhWJJQQbbuHf6dneRV1s9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3V7UFKFtL5ubLKHOJWXv0581xTaUBZERzzxIDLtsF0=;
 b=e31ziN3+ZI7va22byjnJvbjSuW0dPlFTlEpyljkkQEIHAoRmtwYUrkhcd6RQpyeILttQy0nhcrl5D/P7BPt07vbUgELBnoLnzSO9cI87YO6UQFEJD9oV+AhXUG4VcB2bBq081Xh4MzvqaIOjI/62qBhf9X9LRrt9LICRmqtVZM/cJmYUyDoSmrsZARURhhEAT6v8VBwrcxXulm8mGd9rnijZZ2BvU8z/RZo4aft/997uN2PU66sGtRels+/nPHAy0xkhK8ByZNkJuYdnPvSr9JMr+pNiIqUF5qv+I78VmWC0NxpYgCZsrcUHosuYV/VOr6vcosfBJl3T0gSjIt5brg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3V7UFKFtL5ubLKHOJWXv0581xTaUBZERzzxIDLtsF0=;
 b=ECpLuK/Jyhxk3HrQ4AqCUSnJodp0sUQFU5Jk50aDBi5zUfP56QmbdWDyxXLTnnonfXpCfgLzcM3Cv380p2qPs+5ryr0H7lK9KIjDyFgZ6b00eEgOvdyZ72SGRv/RmaLaYzir7Tu9To+dcPTQrBXApvgYW4JExkJPLnu+8rndxqA=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Mon, 12 Sep
 2022 21:00:27 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3565:585c:3431:216c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3565:585c:3431:216c%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 21:00:27 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Subject: Fix assertion introduced in 5.19
Thread-Topic: Fix assertion introduced in 5.19
Thread-Index: AdjG6kVD1pbG+jDgTJ6cbBUkYcz+sg==
Date:   Mon, 12 Sep 2022 21:00:27 +0000
Message-ID: <MN0PR12MB61011D906F85A56264007346E2449@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-12T20:59:59Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=a8eca09a-e529-4840-a586-37745bde6ca0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-12T21:00:26Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 8bf47250-0ba2-424b-b809-14356c57f761
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SA0PR12MB4415:EE_
x-ms-office365-filtering-correlation-id: 97721137-7da1-4ea3-8042-08da9501d1d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xfZuL9gvoli6cLWZ3ktvCBofa5AZrWeL/Kbm5HH68phV4eAaUDFBtTPyIqaM8oVbjaRRJAVQHI6x5n1U8ydfUvMAzFMbr3sev6nvWFXfTBEwr3nhlUAVZQt1jJ0GND9HHz0GSEveKpznHrIYxweAGc4apT7ulURhW4hZUnGYPDsf8gOo6HVi1ZyGSsODoqL+nciZG6tgQRMRvtNWL/BjiMo594AYLhOOQDfAhKJVFwDwqX68cuqHpVaih+PC+H5gAVJBTVM7uvG4FWjko17CWKOIipnZdbwhzYzImwRCtwLCOL4ukYOEB7tUfO20CTYLWUv6WIRfB7I84Hpuebj27+jFR8WhDIvUzRLQUD2awKTDoBx8f56vu/6VZhM1kwrpkRQVRt4aKF/kYvlj0A9RdoNqwjCz0nYQ2yerCM8D7lSMJ6RKsVPBvUMwHqhIueS+/y8ZEj0YIjYqL4fA3qd3CR4Phcn62zkjAUN5/z9oDEVUYULEb1JyAiHHuy44gu7xg694bg8ltt1pP9ax0N343ZzyTEA1RL8jwuB6ICFPCrqNeZLBirCn8IwJ5ZexLR/p00ds/B89VZvlFkjf9RSagSAgFiFyr1p5YzbLLvvgKZGzfaD0HrncgCtqMpUMxmeh6JXDF/UB6NQ0aYyl4+oq1ZgBXOSF9d/OAl+OepmnmF7RmG8Q5qOfnn8xTEmCA+Q6JsqFNJ2obykMZh9iaQI15w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199015)(6506007)(38070700005)(8676002)(55016003)(2906002)(33656002)(186003)(86362001)(76116006)(8936002)(83380400001)(122000001)(7696005)(5660300002)(38100700002)(4744005)(316002)(6916009)(66556008)(64756008)(66446008)(52536014)(4326008)(66476007)(66946007)(71200400001)(9686003)(26005)(41300700001)(478600001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7EJsZmxX/Dys45NMsq2QmYohwHsPBLBxsLqcwVwJnLJ4ClQVOVQANFx1xXr/?=
 =?us-ascii?Q?H+bBpM4CDrT2buhbyw/7Rv/qzY7I3kvurM4iNKrbDaVfG2whLJwWQtryU9vF?=
 =?us-ascii?Q?Yvbexoa0rvMI4NlNjxAdrMBO2svXzO6O7bsbAvVcGVosjon6ReE2MX6dumRF?=
 =?us-ascii?Q?4lAeK6IC3pxRV+1s0UIPjvEtBVexCmLTpJOcEYDhASXKvrfpGQ4pCqcMAtbi?=
 =?us-ascii?Q?/L8KrlIUxGq7eIWaVDExrylcoEZ1/sf6Odagez3yh5qvBKRX4s6a0LIJly2V?=
 =?us-ascii?Q?J6aAL3QKdlqjjTDeif0LjXyjvmDaJzShxrA6yjJIN0p1CjrvgXaf+tHQGl65?=
 =?us-ascii?Q?P+V/nuYqpZ8CELfAdOUrmG4of1jYR+hBkuTQHtyviza83GTPJaQPZXGxUAXk?=
 =?us-ascii?Q?Dc3nOORuvPAHg7Lbt9d+qQFp2H9f39ymPqaHGbIlPb0IQ2lT6bUOVyf243gC?=
 =?us-ascii?Q?NfchR5HmTPT12R20rMsqvDMt/2kcjpfZo3e2vph+WDu0IGQwM30zYb8HiR5E?=
 =?us-ascii?Q?Kv2gaafRoNCp2fO8HW09YWlNeid3a3fmVU3mf9xwda46Ho2jRRCPNQY6ElmT?=
 =?us-ascii?Q?REn5AWblEN/9MD4B0GCWuwEpWfcgBgtZTVbPuIWuQqPzgpXyd5gnJf5IL/wN?=
 =?us-ascii?Q?X82iGMn7WPOT07PV6Uo8PKXbzLxsywf+wHhcWVRSnaugMuYPAI+I+0C2hWfF?=
 =?us-ascii?Q?r7zcQE5m6L07bZj+sNuwVvcB5G0RfyP5i0RYLC9B0oyzaKBDbJAkxRTit4bW?=
 =?us-ascii?Q?zJ/LtkvlOFE1ucmWd1guydMA2XwZdfBKx0YZLnKLNc5Wd1RwmvdikembzrAB?=
 =?us-ascii?Q?2TI02LQgt53ch39Tb7qatq810M0t0mwptEs6NvHXnTRfVgg8+LY/j/JG6rrB?=
 =?us-ascii?Q?/OJf8zPKiG0VcS2kCpy6IXNkQJZcnAYy7aGQA1bP42T3MFDVmMMq5QMawriS?=
 =?us-ascii?Q?4PrEyegQvWACPx2DpZ/MNdXwODZoYiH6RCU96AVvWoZHbNT+U3ZzlnZ4psas?=
 =?us-ascii?Q?hfWPMr5Royt5DL+jVxE79/wWgPQmPPiR6ttPwEXAcvJovLiIgc4AF4kIDP3X?=
 =?us-ascii?Q?TvNoxTYdYnzlkXepnS9Q887fp5CVTmFdnMFsnsWrvU9UafbjCLkgGA36edj8?=
 =?us-ascii?Q?qK2Mc/C6HwpzoXlLPx/hqJRDrai5CcpO6medmocN6p44w7AxvEFTbH4nCr9m?=
 =?us-ascii?Q?KhFnpkcQzhhQ8VOVLnga+Q3+8sdmF9GxDl5AuhqzhDSI8R+etYEnrQue1lqe?=
 =?us-ascii?Q?6xIfq74xJFzqX2kXgmMNVF1U8VGZtz/rySpRrytjCtB+Hf4iHMji5P+Bb5+X?=
 =?us-ascii?Q?jbWF+eLHZeBcJEuo6/L1AVyaBMMcyIoEzDfeS2xC7Hfbbn3acOVgnZphcxgI?=
 =?us-ascii?Q?Mqc+RDJIlg92EvD9VR97+Zzbe8iikqPXNx/N153gKubLAxq58sGyIl4WtZlU?=
 =?us-ascii?Q?SgtW+Xy5XFOjz9UG2HjTCSrz02GZ7AdQ8EKjPzhCxmuyw/ICib+5LM2yfzXc?=
 =?us-ascii?Q?JnqHoM1YYyKaWPyIKgj/MRbj6zqZP8bDbZybkKPWv2pmrKaVBEtfI57VzXZY?=
 =?us-ascii?Q?8skt5tAj1gJQXACdhM4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97721137-7da1-4ea3-8042-08da9501d1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 21:00:27.4166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7IGco13arEUFVFx7Gk7D6yIU1xip5Re9bMZjpDLbF/uGdMj2+0RKYoITUsrHho4QnvI6ZiRL8OUZY62Ofv0SMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

There is a report on AMDGPU bug tracker [1] that a new kernel warning was i=
ntroduced from 5.19rc-1 via c1b972a18d05.
This is fixed in 6.0-rc1, and it had a Fixes tag but it didn't cleanly back=
port.  Please backport these two commits to 5.19.y to fix it.

4b33b5ffcf68 ("drm/amd/display: Add SMU logging code")
149f6d1a6035 ("drm/amd/display: Removing assert statements for Linux")

[1] https://gitlab.freedesktop.org/drm/amd/-/issues/2110

Thanks,
