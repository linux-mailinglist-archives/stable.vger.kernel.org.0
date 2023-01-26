Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B29267D76C
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjAZVLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 16:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjAZVK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 16:10:59 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1D461AC
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 13:10:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/aE4HV2WrHvoo8xTv7AhzYLoU4K6XEFvkAlSDtdHBXj9bk9v/3vk5FT3Dmvw+s3jS7bnCUhpVxJL30Dr3AdZmuoLX4nCzvQ4bav6lFprt0M9+6JcDKkGhkL3AEvpPPOLctwJ5ApSgjv+Zwbk1OKVr3BeqTUMr2XSmdQF5CkxEOqeQoRuwKW34Q0bHAare1rwL9x+tepC8Klvd+gZFk8cctupUPwsN3o7NDyyPGZVPg39/7flQdOcPK0Bpo92CCMiTVQ0geUtqKmj7WZ9+oCvupL67b4sNX5aV/N667HPAgkDSQOESP1YbWpXR7+02Kwq7OuPoJ+haQ7XCTb4qU+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZorM9ZTXt0lTchc7B3UJX34sR9QIs24pgvfvX4EDFE=;
 b=gIoAoU+ZzFkawyZHzVqdLi0sgngQzK/a+TtPgcoMM0JF4Z9sK0F/hrsI49zI95xO1tM+J+1I5NmWUWsEZWGM3r482mXFOJclaREYsc9TetFku3Y7WfTutOOjFI96Mxf7nmtE3ISHLCVfO9gSqfi+F8CSkMu/qiXSbCeI+XfH9FFaaEN4zi1qaZMXuUCXhWP8FMJ/NPRFeZeUto29c9c/gwm/p06GKdCxFQQblCEM1HgwsXVFTXCwZeY4/9hcjwGZuoUtW16AOvgZGb+ulgKkQiAvizAq56EZCLMXqVK1J6MCY98MMx8RkOpcujUC7IuvUBz0rrGfgisHXjNNFCZ1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZorM9ZTXt0lTchc7B3UJX34sR9QIs24pgvfvX4EDFE=;
 b=z4r0k7ZVpbSqoImlNrBTL7RlsBFTcavLAXejFYfnRPY1UJQiUvfqTk6+bZ6e+kbdrmrdk/wUvnfdaxYZ59Il/PRm5Ny/yDWmgy6JivIRfVbmpq10Qk5o1I1RLb+xDdIdgmBls77PLZXJp7r9Ox+DJZ01CnPhaaSiCNOCjurn93Y=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 21:10:56 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%7]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 21:10:56 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: amdgpu suspend improvement
Thread-Topic: amdgpu suspend improvement
Thread-Index: Adkxyq2yaGZRCwwlRh6IF3Crkl7A8g==
Date:   Thu, 26 Jan 2023 21:10:56 +0000
Message-ID: <MN0PR12MB61019A97F740FBF9780C0874E2CF9@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-26T21:10:55Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=a0992870-1b1b-452c-8e5a-c391476bffd7;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-26T21:10:55Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 693c1ba9-2e9b-4cb4-925d-690d191a60e0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB5889:EE_
x-ms-office365-filtering-correlation-id: 1c9ce903-8bf7-4e7e-b221-08daffe1d105
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xmd7g7dqDGZrqNVlJX1dnlL/JfT+MrvWsU6sM0Ob4WBzTDkYV45iNoEYjbgeWVstoLJHuFEEucAL9HBtmWuvKRSx4DTO6Jlud43GQVZ7JW/zJQT2R79AxsehDAPaffYuc+9gHAfp+IYDvbACEphalaLzgMzNk1+yDi1ZXj3wvKCCRm1Vcd0UFczmC5a8ZLaAF5pGlQKV5IEpZad2J0V8/1YjTT7uob6bsktXeDX74kTkBOxxO1Jzlf60WtPvWJrrdfPU6eoU5UhnfRws4DkQLx12QbbirTxUcNcbCWGDA4zIfr+KuUeHgweXHDRLMowQJ6199sWxClC5gLYYSmBVAuXdbtZ/8yFv6D1kb4Apgnb6F7EcjWTnvLPhN+1pVctJUTz2AyS+0n1cya8BT+5Y00IZfyrZwBzz8CsFwoTUEJf3o+zacYRejLdeJ2pyZGBtZYi5fYNe5dHRpwUeBlmc0Eglb6CboNuzXuddIdAz1ckVXxIuiZ0AqW+gTQy5pRomZj+kagLo2VusTUBb5C+FkcVR6neWxakuGfhoGaPcuYGKYDWXmQdMcG/p7BOQLnO4lMz7WkjQUBthAeLZPAUPaOQUwGlX3xG94Sz+40xNFgyVXvOjLOnQxboZ097GP6sE5KNcUn4NN3kq6ZlzIFZHNYD17nsvIN7i4jTKNW3lT9PjoZsSmL8lpr9h/aa2j7C4plSwuxfnKSOhAg286ob0sL5m7DgSO7EZWbUQNrkvc6Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(38100700002)(83380400001)(3480700007)(558084003)(33656002)(26005)(478600001)(66446008)(71200400001)(6916009)(66476007)(8676002)(66556008)(64756008)(9686003)(76116006)(122000001)(66946007)(38070700005)(41300700001)(7696005)(2906002)(86362001)(55016003)(7116003)(6506007)(15650500001)(5660300002)(52536014)(186003)(316002)(8936002)(133083001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DiMZzhbBzPGI8vCR8Fc+NPvBVeunqgoIezEW8i8wEF+B6A1DUHCAGXSLFN/N?=
 =?us-ascii?Q?BziGNaI/CYAIi63F6XtU1K27jPKzIIcV6woNYCCaviu28tvc6DNM6DhYdL32?=
 =?us-ascii?Q?g2i13+K8YdMKqpaFDHoM2qnHIrDGN3d9RYEKynUL3A2EwLd+sQ/2EfioULZa?=
 =?us-ascii?Q?aRPDaQYSmehmHkcqzBRStMToN5aerlrPIjxWoKt8nl2BTD8X2RfQRgpsELUx?=
 =?us-ascii?Q?eY8dAyQrjCQZvSZxqCm9y0OQ8I/Z2CqcgNvgN6me8NFLhEQV3OoTA+vAQNb0?=
 =?us-ascii?Q?JELhkWrDyk04s1BMKGlgS+ec0AnxWE7MgeDc79cwz3uGdh7yWj2tpkxacSha?=
 =?us-ascii?Q?r0Sct1fZB9UPAFsmSlsgieiiAWjtejSfGI2bKzOtzBDAcmY96sMuhY4za8pg?=
 =?us-ascii?Q?ImJOCDNYi4UdNiWpEIxevyqa06PCKregQSXldKJFbYoHdH7HpmkbqB+94Ek4?=
 =?us-ascii?Q?bUmCV2V0es/3+1CZwmHB8XKsC0EDyVqZS2WTIyFJPh5afLaAeTHc1p4i8YpP?=
 =?us-ascii?Q?G5ASsItaUdSkfRIQwDKNtHy262noZH4dXjTf/YOnt3kUIeXkMrzhaKxnJp03?=
 =?us-ascii?Q?zK7x026ty7+9K7yszgh5pC1CRdzxmC9aX4i+Q4YaGZZfikHPOaYUtpP7FtlT?=
 =?us-ascii?Q?fPmZgbsNbVL9EGdz42b+w0d9i1+jyDs31ex0fcwZUK1ff5i+o/MjEY6JxA17?=
 =?us-ascii?Q?ejqRVpgyeiLjemVxQlwFmew2Bv5WV/khlq/ViJmTEj9H0vGsmKL3XtBP1pMZ?=
 =?us-ascii?Q?tgnWF2ANaH2Cf21TcxaAzwBaYlk3PFVp4J/3A7g6sUdpWGRkG6TVszRPOPxm?=
 =?us-ascii?Q?NM8YwjxKqgC6fN+82iZ3TxD7k5HK/jVZ/TZKeETiUTQe1028r3dbjfPql/1/?=
 =?us-ascii?Q?FQIzSrEnc+5GvkGddyHDjP3CoSXdbM3+3skrtaBlNKggTslQHZnW9s/coyFj?=
 =?us-ascii?Q?U3/vbMVsV3euZbWow/1amezVjIX2P36qFDuHq4PalC91SonvJdB3ZcttSd5d?=
 =?us-ascii?Q?kfCccycouM77VfbXwqIAsalTWl4IRa5qzQfmBSAvT2ivBpd6ZyIri9g5QrD0?=
 =?us-ascii?Q?2j7yb9/QDIFx1vXLj6C4ftW/3+by46F7dEtn+XVd4ru4qf5re+tszAfe7Ok0?=
 =?us-ascii?Q?M0NXy9fLrlAkkYECxPn0hXHothcOLFGZpZddnWP0MiDwAwBIJhrEbYdFhDOS?=
 =?us-ascii?Q?3hPWEQU5jLsm2lQY8JHOxYOsKG/E99mkBIT4r1LpXfI4z2mAx5JRmKNsJ8AG?=
 =?us-ascii?Q?nxiOqJ9IPAfFnRslxiaipnICg4IQIVwHlmLpUa01PexVQIbKYsZ7fquBwlui?=
 =?us-ascii?Q?0a29lZvvVd4KocRfHIvV1YTaPrOlcv27jICYDPuZiWZfyDwXzCQO90FEM+SJ?=
 =?us-ascii?Q?Fxq3TiCBByaGWdc1MOmWOgNiy6SBt32dCO7ktZ8k1rr/Eiu7WJB5u6u4TmMH?=
 =?us-ascii?Q?ESTEDFyU6zxieo0GcpU+el1hOJao7oqRQNCDmazr1qHHZ6T0rAVVyGonhYvw?=
 =?us-ascii?Q?Di+44wcnE0di5+Sg8XuAGXlIhM1mmRxRufVeLzCHdhiSkzs8NScH4kD9j1+Z?=
 =?us-ascii?Q?o8g1M/bNq/Fp47PxRe8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9ce903-8bf7-4e7e-b221-08daffe1d105
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 21:10:56.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w14WM5q4UPjmynhtmxdmp7GbKUzll5Zgy3zi6s1tO4jOXnfv95maCHm2WndUY8USdWelsWbcbVj9UIRsFjq8sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889
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

This commit that went into 6.2 has been shown to help timing corner cases w=
ith suspend problems.

4b31b92b143f ("drm/amdgpu: complete gfxoff allow signal during suspend with=
out delay")

Can you please take it to 6.1.y and 5.15.y?

Thanks,=
