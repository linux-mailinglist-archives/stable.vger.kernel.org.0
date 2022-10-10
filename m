Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399665F979F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 07:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiJJFMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 01:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJJFMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 01:12:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABD44C606
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 22:12:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFSc1zuZLn0Rt7YGMxgdwDNWdrg0xuXiNFvNLYGF3Z9UvZGcdq8Lbknrr0TOkF2CcFvWtldMCw4DS6s4XUddtDRCNVyIs6zsf/tRMtfHv+sRv9mkeUXi+MT+eYi1mcuETDl6DgMiZo/DRiaHGK56xSEgANl/pC6SpYlu80tqyRVKbyQWC40y0JVuI/7WIts3K3xGMZ4SALGjS/cLKXZxxLj/tytjssV2xLtSEADoKYLSCX53aOz/EYlISOth0q+IvChwfxZJxqZlQ0TgOrWsa1vKuvMobriuGuUyMZ0VtFIpmiFeDszHEYYt8pj3E2df7hS4Fr4PnoDBXSdWEb/KMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjW4yaX3XLJRjeJUbbMAaIfGkadRHjnBKFzRKag03yg=;
 b=TY1d87Rn9NO5QNkXdDNeNlL340QFZig8a+GcMXHGUxiCgh17lirbnCEcyx1WkF5CbSQaGfp1aAWc1vG8s221BZ+JxO54JtGz9/bQvZa1zhnDu1msSbcDKzwwJmX8UQa+//9vveWeV47ELxcYFFpozitZHd0lWuqG1Qo6yElZ8MnxCPNWpaW7hbVdDRq2WBHFV3Zd5Rijcd5o7QzZC7JUiAezKpnbMi6E+P4ftIer7EHJDwUYwofvmRjn2CUztxz4xLMPskbTpB+SRYYIp9ciW/EaEvNoFNMsj71MDCVuLr510ihQnCghCcJyVydiMYfUBkt9DxuJbKnSo+rj967b9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjW4yaX3XLJRjeJUbbMAaIfGkadRHjnBKFzRKag03yg=;
 b=s9DAeNf52paUwOmnmcDxanUf1abUWMiUOGP+OQvYy/SzMcUmNtvVSjWG5plopW8xaK//X8ib2dstwRAVXMCi0c2T9xTnnZ9kh3yaReM7wsWnBDcmaQ5yLzZg3+yV4UlNHDlsjMjtwl3F+vfwxIkfpWePenCgRi1cjOlxYPm5aJY=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 10 Oct
 2022 05:12:20 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%9]) with mapi id 15.20.5676.030; Mon, 10 Oct 2022
 05:12:20 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fix IRQ storm on ASUS UM325UAZ
Thread-Topic: Fix IRQ storm on ASUS UM325UAZ
Thread-Index: AdjcZeDzDJMAM5NQQzq4hNuiUB5kcw==
Date:   Mon, 10 Oct 2022 05:12:20 +0000
Message-ID: <MN0PR12MB610115BC9826AB2E3449D064E2209@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-10T05:04:27Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=96f9f72e-777d-448d-8b60-4d8a1ec68ddb;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-10-10T05:12:19Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 13eadb56-c644-433f-b077-a9d13bbfce0f
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL1PR12MB5222:EE_
x-ms-office365-filtering-correlation-id: a01cbcc1-3731-4e48-7cd3-08daaa7e01f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TyTSJ8HaP5D7OUhlBjzJR3RkH86chRNc34yhlzmxOUyprXcwP85kkDld5iJgkU+qUeC09g5RZ4AXpdZrIWmLpz1PsXYC4l78GmfOQfE2FzQpf5DsagFpYcg4nq80YDq4Cb+flL2rQIy4Fo6KDwgbu0rm2Dk/gKg0MQ5AEh3e7EFihZ8lBiSIdeNqiaLlelBslILt2U4dqgQmjcgGProSnkOBOMwesrV4N+uegN6cwLLyutCokYH5TtBz5E1x1oCaQN3PF0u2mSxElKts8WkEV982Cc1H1pY9Y/zDLOpOQpJZZ8d6umwAz3GaA5nLuqKqEWcQmgMmtoDP7VmW6KgQfWgcHuacHKXpzd4bszvl3h9v6B+L5O3JC2KF3uVc61Ybox8A4DED+dkL/WZXQtth93qbHT92G9b0bDqfscpT7qEWPInC/liLP/TXYAwhPO5uw6/lDjF3/iqdT4n+x3Mt6wOkOGb49/AxnGGpSHmvRkWW13xu4NbeWMvQKESATg/Zk2aPa3f9gJ0B3Ms1yWTlYrVB+z8gYen37RKVIFjT+c1glXZ0crV5vxVYK3L/YMcbuj7vfHF+3RpKFkiKfh6P3+C67aQ5awKOgcwh+MsdHnbtgS+fuWU5BplOI4JnMFzRTXlVwxppbRh/KhPhSpQGC6bxL2g9nJacWGk43Ci8E4vC71yixqtznYwPAXePWVYso56/PPT2Qxo0ND9TfkafSmDSAjx/AwLbby4hUS/p054u2xynigyOMHLDXQ4UwTV5LhSHtfMVPCWq+Lwhf8usgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(64756008)(66476007)(6916009)(66556008)(316002)(66946007)(76116006)(66446008)(8676002)(8936002)(38100700002)(122000001)(6506007)(7696005)(2906002)(33656002)(26005)(71200400001)(83380400001)(86362001)(478600001)(38070700005)(5660300002)(9686003)(55016003)(52536014)(4744005)(41300700001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tFgY8tMtsaxqGUC16Y+pnqhWq4/2aES7Z8cHRdMfpLg9XdtifNruh5NR2lOT?=
 =?us-ascii?Q?5ABLa+8oWAMgPt1WCwgQ10j/pMUlJ3joTcyU9uc2n1Lu7AJd0JVVYHMvgiic?=
 =?us-ascii?Q?gBZpAxShRjnBNwqJ7eS4FIO2or55R3rNgR/DjUckmffRuXwGG9FMLTTHBhdj?=
 =?us-ascii?Q?2bxEtSTE/jRFS48YVm1Y+sPOlD/swsELXR4zTZP/azD2Uj/cZQPAp0nqt4V4?=
 =?us-ascii?Q?9l7cGVFDLPNWWUkeH1iR6WYJdnxwJqkagVFka8T4fOPKl/B981+wRwy0Ug9S?=
 =?us-ascii?Q?fYQnUaUAZlO3QUE9gCU5MofzWVLF+ln2gP8iWlMKuiiZGiONgurkEQFz3Yko?=
 =?us-ascii?Q?m65Dy2OldP+Sm6Ba2fUYu8+KCSb4dLJru+0Svvfu0t3T96C0zj8MZGljTuiW?=
 =?us-ascii?Q?f9mzhqo8nClFRVp/dBEit8kizDJZmubeAENs+/7JLw6c1AQwOaJu3iKZ3490?=
 =?us-ascii?Q?d2BU584JedZp+JE7gFuWNNDZqX7diXy36vvBSESIrmDzSBC1DSk8q4pjHwkH?=
 =?us-ascii?Q?DTpEleazItBKTyv3VhchlhLn7X5HgEp7ii2aSInh/e9LPQGMtNIi3B+Zul/Q?=
 =?us-ascii?Q?E2sANMqJpZayNuMxls3mij1WoPJ6rR6Xk6ZMtoYT37eHTcRMH2nEkOkKGNv/?=
 =?us-ascii?Q?AUgT+6YRGD7DxdkFARA5Z+zjGSztUcpr/NDMyOJD/boNz0ib9O8OByaTL+hN?=
 =?us-ascii?Q?oOeWxHE93E+op6DULrstnsrD94vmjwaOBmRIXiaDUbbYWc02aPr9K7kKEuXl?=
 =?us-ascii?Q?1DzAp5aZI+qxi1SbZOz3JK5k/WVtjApTVKaJiRilI/OVYXUsVnScpOX1CMcI?=
 =?us-ascii?Q?IFvXMixEOhzFv+DL3IwItzTRVaFTKp91urShQb+fD6wP8TdRLR9Ll2XnGdOE?=
 =?us-ascii?Q?T3SmgTEoLzMp2TOHQkaDin9WFxKeMMzcbU40j6fwbMIEi54iZwROs7lkUIrU?=
 =?us-ascii?Q?zDEVip18SmOiGbWRLW/Uz2HRHt/ftLB2uNSqZ8I4R3nBJxPUhHpEKFfHerpA?=
 =?us-ascii?Q?0gdC+MyT996GYgNpBFclFPgsCbM3NknE2Z0rC2mAdBcWTM3x7LWAf0xIcdRZ?=
 =?us-ascii?Q?b3wfqCTKJ6e4nIgvmLpmBUyl8E9HXofLUqs4KdawknrsiIO3RqAC2TgH6CIG?=
 =?us-ascii?Q?8j4RJEKWheTImzfjDXrcLKVnRy5Cih73I0v8Ss2QulCI9NXhUHur3AJRXGEU?=
 =?us-ascii?Q?W5wLqU++i5VlrNw2h+eB4byIpgRYN35PXTgJ5PSrmIFggsXPRF9tuHLNtq7p?=
 =?us-ascii?Q?iEXmM+7NiOXLyCOqHs5GrGs28KAhcyAeCxkzaVLJxuDw9xuJp6pf1wgMw5A4?=
 =?us-ascii?Q?UtMeMDxlAdRopwApqU5I/NBTlm/FsdQlkXRvEMbEnQP/twKwSWcBqqSjiyIK?=
 =?us-ascii?Q?sU/FW174qviIeG1JCsWi+te5Y6I1sZRuoFV+DXM9sKdQDRqJbZsXmfx3pT/4?=
 =?us-ascii?Q?6zSgx8ESoBJEEgm1uW5jy/dgGu78hN8P6/Ll3aRRl82bEFmZvwZXax+TNsdW?=
 =?us-ascii?Q?GEee0QhNseSk1Cbf2aJk+Tai49xxHSvh0xYNKCLSWTsdG32quzobiLvQmjwY?=
 =?us-ascii?Q?TVQRvnu0QB2djFNidVY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01cbcc1-3731-4e48-7cd3-08daaa7e01f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 05:12:20.1082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jpMygUNSBh5OTODe53CHaBWB2msn26yG9ygzVaRHlCouy7CKej+fGuTKhRWCb/jhtLT5v+fXYdhIwAVPbBebKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - General]

Hi,

ASUS UM325UAZ encounters an IRQ storm at runtime due to a BIOS error by the=
 vendor that they programmed a floating pin as an interrupt source. It's av=
oided by a workaround to gpiolib-acpi to detect this situation.

Can you please backport these commits to 5.19.y and 6.0.y:

6b6af7bd5718 ("gpiolib: acpi: Add support to ignore programming an interrup=
t")
0ea76c401f92 ("gpiolib: acpi: Add a quirk for Asus UM325UAZ")

Thanks,
