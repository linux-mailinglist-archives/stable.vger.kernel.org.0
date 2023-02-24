Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E629C6A2062
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjBXRR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjBXRR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:17:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B436D31A
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:17:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVXuNYdEtgCQkNrJt/4+muJcEWhaibDSun8Fbt01gj2pcOEproLjZydKQtZ2kxWRtVet60UTxHH5/ZRP9QwGBPb/6wMOUxPhKJPULdPs/2tCuySxnqBea5T1zvJ6ZQFKSo3PQlN5gL+f06uhMKz6NTxuzLzRDB0KsHhurR7Qva5H1nTSyp/VQ7rWQKURqft/8q4695amzAWuCDyExR6aI2erpBOgDBFEEHi7cJnl3Vsl9ITJTr6C0wxtCFBUr649C79baPhGjf2RWhJprXi+8SDHj9jg8/OT1u1aoyEncs8+9GluBzzvuddnakrz1TvV1V7aeLF2ran+5ylnad0KLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs9S1ri45UiKAeIkvUMInERdJ9QSFLe8b3GhyQbs+Eo=;
 b=S2XezIkomILQdiCx35oNOOAfyF1f7q2u6/jXdM45bWayhANFTaWdFZk9OgB26XOABx1r878ih9yFmaJRyfDPbcgTzRwcTblQVpiVaz9VX1aSJsJ0VwX0rK5kGA4Sgjb4baW34VFl9AQChCpEy8UPbYnqoy3IOpdVNAVV62Q/xC5vduPjdq9ac8R8/rZUvHx9zMKERjNXEqL4gaCSXsGnJjHPaKVLGdQHmj679BVuDTjaESj+2sminNWFoZcu+JZsShU4RcUN99UOLaxsaNA5IEVeqUFqutrXqsxvZje6zxrP+UMIGlb+6W3E18H1sYl9cB3WSCHq2R6y/YW309+kOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rs9S1ri45UiKAeIkvUMInERdJ9QSFLe8b3GhyQbs+Eo=;
 b=lzMDP5yWfT7SAzxYkxdM9rlRroPIcEpsB9Ci/G3sYobyJKWTIzkZsm/eMzC6M/u5GB7cfKy4HmD2kV2fxwecZob3Ik0G+XDDzDs8nRR5FKs1azcGfhkcDmswa0IplzKz7vNbvHBwMbAYE6ycg02QQ9Ird5IslrMsJlvJnU2P1fU=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM6PR12MB4386.namprd12.prod.outlook.com (2603:10b6:5:28f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 17:17:52 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 17:17:52 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>,
        "Mahapatra, Rajib" <Rajib.Mahapatra@amd.com>
Subject: S2idle fix for DCN314
Thread-Topic: S2idle fix for DCN314
Thread-Index: AdlIc4X/GTKwtdN2ROKifDHf0v3sXw==
Date:   Fri, 24 Feb 2023 17:17:52 +0000
Message-ID: <MN0PR12MB610166BFA2B07767C2BF7499E2A89@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-24T17:17:50Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=91a58ce2-6d41-49e6-9ea8-cee1f7653603;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-02-24T17:17:50Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: a5176498-8197-4c44-a3dd-3985e2837c98
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM6PR12MB4386:EE_
x-ms-office365-filtering-correlation-id: 9ea54636-8906-482d-c9bc-08db168b0fa0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Alds9BI4sHSO+c32dcBwnmKegD343f7TGh+mst+zxSMlOiGJ6WSLk6s3NG8wnXmTb9beAVXq7w9h/IY2lrRSIxqnNBRGLi0UWB0H+mHhC8atSWZMv4ugxPGrnSBmcrGaTAibG5FlnVutlSEtm3r37U+t92rWZ1acw55Q20cB5sxIu6fjH/u5b1LKIWpXf879F5vjpVGFWxGCefD0QextobFu/H2jpGcD+VYRrVDd7gyz1dLFxk0ax30bIyxeiUwR9FFfklv1eV5eMXkoO/xMiHF/odYoThCqMKP2rD7pDYg4i0k7FSOeVkmrMPiN7wo8EBitQQYSz61yBF6LfaIE1Apcn64uTHVzF+K6xe5rCZ/3TGi5OxfBnm1iwIaxHuhhM6U44LPemf+55Ln9J087phqdRlHTJpyfmGgUvdpHTCOad4wokPbbWreZByb6uw3IJPM0y/v/11oPkePSitIsodjYZKvlZr385dCgIc0REmYOhjwoQUegGxP7B59uyAINFI6kGyYiJhJ9rigHWc2bDS8SJUKD7FhTrkluOHNwCMzawMClu7YVISuAaxCQXKXs6SONHZLuUKY0/i4Lc0VRT7I6A6CJfFmt/EooC3k0DzQEIHB+Ddgq2jg4fJ8+krPWTuyt+bf3rKLXhyTXuBEDVchRI3IXEJylC6Zd1tEIG48FRwMfpWb6Xg+nv8MyT2C2yHg2RNBmZG2esyQoiypzqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199018)(76116006)(64756008)(66476007)(66556008)(6916009)(66446008)(66946007)(8676002)(86362001)(9686003)(55016003)(38100700002)(38070700005)(122000001)(54906003)(186003)(478600001)(4326008)(316002)(33656002)(6506007)(71200400001)(7696005)(26005)(5660300002)(4744005)(2906002)(52536014)(41300700001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?llrdgPwQKSZSkzB9AobQoosUimdkJ2wHB5V8U6GKaC0KQABUiMQX0Wt6E3Zm?=
 =?us-ascii?Q?HH7fJ85jClrQrRudpUPNnD8Qd8vAOj2Ev61OtifUjesL9Do95en3Nlbld5/l?=
 =?us-ascii?Q?lbBNoLs3+hkdbJQzeIYAoW9qKFDd20rRMrHD5+KxIUhSHuRehnYJCWfLMiuL?=
 =?us-ascii?Q?+IXWqsFz3HTIbfAm3XwQ1jbOwntijBYaEV56YMMyeVsId3BgRLYfXUdL7iyb?=
 =?us-ascii?Q?YPtQdKO4pJaCoYPesm8sdxJOLya+cT7zb0b1E89GDQjS/ng/sN+LhrDv5jjk?=
 =?us-ascii?Q?At2g3B/QDV0qs7EITggTammlyce5CKKoBP3YoTWO0iwZRPt75nXLQmsJxMQs?=
 =?us-ascii?Q?qe288hIIKLIcpYJAueBJGUHyoeVEKU2qlMYH4Pcy2JOIyGxlDeN8tpedaSWh?=
 =?us-ascii?Q?zPm1EXUfPXnce3He4Z4JPkySbhC81YDQejFR7htAgVXib6naermGmshNhfIb?=
 =?us-ascii?Q?oAWAtqB3R/npMYNM4PaAdR4BeBTXjZ9U12ZkfhereSgMNhdKX/edPBBMy99B?=
 =?us-ascii?Q?x16+HGHeXdfJgr39n95Yzue97cjlvnIIkXy1UA7iQI6fnncFpHtuzcnHyiVD?=
 =?us-ascii?Q?77Dfxv2GKeQb1O27LmRozHU1IJa64u7+Yg4y94dbaWP6xHQ98xbn4BhxfLCR?=
 =?us-ascii?Q?CrdiLiTlJ3JKVIkJHL1jYfSoljd2YNL3cYKeT8VOCLJEy+8aBdifrnfdP4Vw?=
 =?us-ascii?Q?wuuNhenLuSCrW+4cLWDYJUsfyrmToovL+xnYs7sF9xoKLqOOWeM7enTi+FES?=
 =?us-ascii?Q?9KKb9eFwZZhwItvdyGoR1tsIUb/klfI3kuN0YCXsmKxGdtzH4GCT78/dRk12?=
 =?us-ascii?Q?ez1uI1bJewN5Mh76eSX1nAfiIM2kF6KiPwbAuA4xLQqft9Z6SbdMl/G+tgBn?=
 =?us-ascii?Q?tNarax7p5NxavWFLvw1SCH8Pj7JxCfudrhf49l08q1i7RNH5tz0cTqTu45Vz?=
 =?us-ascii?Q?8AHbFsq8alHj4gj40tAA26NfpNeJEjVJg8+SCSc/GXtKY8Cj42RvLM462pXw?=
 =?us-ascii?Q?HfqeVbxII46kChG6yyr6fDevkf5Z+DilZEtBwODoEsHEWnACn7mUb0GZtkw8?=
 =?us-ascii?Q?oiHFcwtfFDFYWYmqSTUFMhwybiVzOfIM9Q5yo5kwXIYXcZkdGhtQYG5055h2?=
 =?us-ascii?Q?AwImIGXkYpsdlRfANdBwj2UH6N7jXDVtVLW0nd7h2S2VDZyNurML/J0t+gtY?=
 =?us-ascii?Q?2oM5liyy66ZEC7GPkKsdkpjEFKVywpHAa6Re+NeVT0AMVZyRXTOJBSsIsFqS?=
 =?us-ascii?Q?RbFR7V7KNxusma70LKcgEPRQbO9hdyTXlwo6xHjXZ7fHDSLfOxlUcHPaOcWB?=
 =?us-ascii?Q?wLVaNsU6Cxm+W3rlDncax/6q4meM0WrQHnUaRSLbgLcD0NI7ZVzLBLv6PIdv?=
 =?us-ascii?Q?6hBwbPG+vvAycjlzPMXAZSyU3vWqWdF0qwAQRFm2nORKRm4LUj5XMOiE+p9p?=
 =?us-ascii?Q?uxbVk8XIDFMbd3RRzOYMXO61cdzzTydPIYq1dvs9+SbTOKQ0PU2wsR/LzmQc?=
 =?us-ascii?Q?7UarPQTszGahE2ODD4BBgShea/S7ZCkNYSBBVPG+eLZUFnUbMC5UXjK1Fwu8?=
 =?us-ascii?Q?jRSPtiP8V6Xpbr1f9pc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea54636-8906-482d-c9bc-08db168b0fa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 17:17:52.0893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQNZrdaOkudjZ3l2d8MmnWrYZqCXACRVyL03XSDVMKvvlIp05apDEFRUzLxL4XqNvogSQZ4hlnZestqyPAqHhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4386
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

Newer GPU microcode binaries for products with DCN 314 cause the display to=
 fail to resume from s2idle.
The following fix went into 6.3 that makes it work with both newer and olde=
r GPU microcode binaries.

Please take this to 6.1.y.

e383b12709e32 ("drm/amd/display: Move DCN314 DOMAIN power control to DMCUB"=
)

Thanks,=
