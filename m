Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADEE52C41F
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242398AbiERUP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 16:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242413AbiERUPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 16:15:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7E135852
        for <stable@vger.kernel.org>; Wed, 18 May 2022 13:15:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6o7u1eqdChDtj675qLRtimN6DkmN+MscDTJMsfQY7mkgoox2nxi5hXqhT5FUUK/r148I/4YJZx5qsp7Vy3vb9O6RTsa8SvrBl3pz4LUHQ/GTfLaM3hyfn11a5WEqxx0AgmAlTn9t1GyS26BBoF5IjQjLi8j8tS+GsismypyBqhfMyq4aTMd6gyihw+aVD+hLBuRsMNIasoTnlmMau2mp/HBP7v+Pa2Pj/8wjpoZV1HxudJplRa8G6P/1TGNIyio1LAuBPUwGpxe/1ctddp+MzLI7sVRuprcTupP6nWLMDr307EgcrZ0gVRtp3XGQo3ZCWsIBEa4r2yMqj+sc3lySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7B4sJR7O7+T9BgIzu12S+Cm7bSVAdVstVjv8GxuCwsA=;
 b=E4jGGvogJLzs2KeYmMMJ/1u7g5t70+ZYPK+1qRmOkxgZK0xyCW6QYx8n6hPSlBoFcLBf1e779Jk0qSrEQ+HUeMZKLuvlgE/jJM9/ZdHvT35bMLWHvWZte3QmVB6hRrbe60NEJAeF1aWiTaomXPtOdrfnpzQymkuNVHO9cZgyfLQWfQ8sa+Q+Iam4LIDJR2LpPE/DkkOQXyQ8oLqXWIzH3dyd4smSu6tMSNlndtmCFL4P865/KhM/sniO+3rJ855A/H+UjLAKHeTWAt1+8vUGo1i0sagCO1TIIogLGNfNST02XOiWI7Hfs5EBDrQ++yxGj1daoUPfAttKaPMYgUKJ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7B4sJR7O7+T9BgIzu12S+Cm7bSVAdVstVjv8GxuCwsA=;
 b=zBQfrazel1I7lnzT1mWEeAgIhAsFtWCr4247WxTXV8rBgP9PZVrP1yvg285cNVWogYeD9ezIMsErb3RkCwMQgKDZzwfyD3iBw2PtJ7Ht9ZICJtzm5gbjzXmkiXm/NUT+wv64S8cmxCbRLrH2/v795KcllxxK0HVNUbk63fTqWQw=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 20:15:17 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 20:15:17 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "casteyde.christian@free.fr" <casteyde.christian@free.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Topic: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Index: AQHYabuPQo7dlCpjq0mwll14F3A0P60jViwAgADNTwCAAACrgIAAC92AgADimcA=
Date:   Wed, 18 May 2022 20:15:16 +0000
Message-ID: <MN0PR12MB6101666E2F0F4206FEDDF334E2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <4c8afdd6-3573-619d-d46c-e13a4fdd9ac7@leemhuis.info>
 <CAAd53p4ddFYE+O6Je8z9XDy54nTiODJsQEn7PncZ95K_PXPtPQ@mail.gmail.com>
 <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
In-Reply-To: <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-18T20:15:15Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=34d524a7-662f-484c-b3db-6ffe32f2f1c7;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-05-18T20:15:15Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: fce97397-ca8f-4e47-8e1f-74df89d82bfa
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad15e50f-44e6-4fe4-ecd6-08da390b1ff3
x-ms-traffictypediagnostic: BL3PR12MB6617:EE_
x-microsoft-antispam-prvs: <BL3PR12MB6617937D356B35E670180FE8E2D19@BL3PR12MB6617.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DLPsqLUGO8/9Ev4sZh7Eb+JXKdhNIbDQzh9jdwTTYi3ZnWj6Gq387mFiJePUGeuaXRz+bkQPRRDLcAR+tQJjEe8jnpmvjZdF5Ew3GMyvj/zBvYqEsV1AeLE6gIK4fgtWmWCPcCu6rWXjVtQMB6b9erCWKZgFGt6IafuWGmExP/39EhRH5QcMDCtyuO5VO6NoCstpn7J8DYGfDixq8n7289xjh/1O6DIOWaWHvc6IR6GMUoueNj770q6MmItdgjkgWx8Lw4UEezXuPbtgnJVje9/c4tyrrGh2//K65xvSj/hyywir9YDmxvcZAE0OjMOX7PWq+OpTEkfTQVvPqn1eY6Y9Djh9mXSwCKQtOf6RDsR7VcuHjSzCNSjpgNsWI44d2tSnn2t/4bWpyOSTt2XUUmurGoBIl+fl1/8wtsm/ODZ0g7hCM4iiPp8q0fx0ruZStj48X7ieamxK17yMVLxcbUNBzMhE7jY9RiIdBQ/e6GTD6G9Qfrcvl5lBHBpYGQTZ1DckG3HU1s43vgqJFiQxGO9oLTjsz/xAIPgak10FV0Dlxs92qY6gS9e1EceAkbiN5YIayynASn1J9zqXyblVfy0bQjTblqk+JVOngfdut9QR2UtIg/b0+DByH698uTMYDrWXmFNPkyw6rWr8J4Gp6ao3BewyhYu97zqIkO2+l6jDVZJ6UaLvHIvoAbIzrIXVltdL6vQTfJcSDjZZqGDyS6wPSH18cKTC7h7B9ZLQkArR0u81ARS+pbbbNgJLVuXbIu4ZkbYraEMrgPiDVdgTwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38070700005)(122000001)(38100700002)(53546011)(83380400001)(6506007)(7696005)(186003)(9686003)(316002)(5660300002)(52536014)(508600001)(54906003)(71200400001)(33656002)(66946007)(66556008)(76116006)(66476007)(66446008)(4326008)(64756008)(8936002)(2906002)(110136005)(55016003)(8676002)(15866825006)(41080700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTB1TmNBMG9jS0tuOFhRVlhhaXhVbE0vcUhtS09jK0FmMDduVUtZaW1IeUpj?=
 =?utf-8?B?UEJMcHBIbGYxNUdSVHhFR1ZjcjJjTSs4b0l1S3hqWVFqajkrZ0owc29oTjlG?=
 =?utf-8?B?b1QxcE5CMWNpNHFGdUt4ZWlZVU9Qbko1cFEwRTFWelkrUUNvSVdhS2k5S21m?=
 =?utf-8?B?ajk5TEZrdEwvbStPdDhrNXhzdWJpZmN6WUsyVWJDb1ZMcy9BdWJPZnNFNlJy?=
 =?utf-8?B?Z3I1RWtqU1JJU0l3OVJiS29hdS9TcEExMXZUNkVHSU9kOGJrWTVsaXc2dFNz?=
 =?utf-8?B?c0JTSmg4d1kveHZsT1RrZjY2VHlBdjN5TTFOTXBQMHBxcFJ5UEQvNUxDSEwv?=
 =?utf-8?B?dDdvTG82NGtmN0cvMmpTLy81WVZXa01pUDRaNXRibGpJbGRyZFl0VFBZemZ4?=
 =?utf-8?B?L2R5YlkxbTFobkFBaGFhaEh5SjVRSHQwQThLSEtLYVcrQU1VTWl3aHBRM0dE?=
 =?utf-8?B?RTVpQWZKWk10TFBZbE9KanZaVDU3eElCQVo5SzJhSVh6UFJFMWs5RkFHYUtv?=
 =?utf-8?B?eCtucG5UMGFMYWVkSzl5NGc0bDhtdXkraEVJZDRuRW9EQWNmUS9NeTgremN2?=
 =?utf-8?B?eDJmb1duL1dhMW40d3JBNXVTZWRYMzJSeHRROEMyd3NjMllDcTkxY0x4WDhn?=
 =?utf-8?B?QjVITzBzcmg0MlQxNXk3TkxuM1lvOWQvQmF1bHpySWZtdWRsWnkzRUZqWi9I?=
 =?utf-8?B?NktpbzZXaFBnSnpyVVBVTG1YVGg2NWxyVTNYd0RFL0lYSU1xRHJpQnRUaEc5?=
 =?utf-8?B?bGFrcElrRUhVSzl2NjFBZ1pYbU5xNkpsdk9FT1pwbnhKSmY0eTVoKzZCRDlj?=
 =?utf-8?B?S21SRWIzQ3hDeWdPK2lmbXBxSklURGFSOHAxNU9KaEpzR2dLNno3d2kvRytv?=
 =?utf-8?B?MzlMa1l2OFdJVUtsRUJiblFnVnUvaW1sbnNpQ250UlJVTjB0aUpWYjRCRDRK?=
 =?utf-8?B?MGgyR1VMTGxzSHZHZGE3cTNDQStkeFRtbnVobm4vdFVTWWxIcU51KzNqM0dm?=
 =?utf-8?B?dCtVaThqWmdDRi9QSHV4TENpNzdJTEFjeFVtNlAwT016WFArd2J6QWlSUVlk?=
 =?utf-8?B?YXpaR1hFUDVULzRTdkl4RzEwK0IzSVVwR2hHendFa2NQQ3A4VHFUK0RzY2Ur?=
 =?utf-8?B?dkVoMS9PMnY2R0VhaXNqQ0kwWWFualVleFh6NU5aWWlQVzZPeHZwcFpCaEJC?=
 =?utf-8?B?b0NGM2sydWxLdC9YZzVkMmJoRFhzVE4xTytmNTlMbmlleURGWXR1NUVObm9P?=
 =?utf-8?B?bjRzcVFoSEhrUDZhU0JUQTRMQ1dZZHU5NEpJNi8xK0VqenkxZzZFVTk3cHhW?=
 =?utf-8?B?bk1kMXB2V2lzMFd6aldpM1dNSkY3Wkp2NE54UVV3WTZYb0xDK3J4RDNkT3Rr?=
 =?utf-8?B?U3Npbk0wakI1cVNnZitlWUpMNXZCeHg0MG9tT2RzZjBXSy9NSjdKTDFhMDdR?=
 =?utf-8?B?a1RRQzZZTFRMdUlnSjNTakc2ZFpJcVowZlM3MEo2WmRVaElHNmd5engvb2VX?=
 =?utf-8?B?RE5qc3NrNXRTeWxGQmxKYUhtK0MwczZkU1BqR0paS1E1d2VPUnZkRnhKSGFV?=
 =?utf-8?B?RmowWGpHYUV1d1g5WU5LUHhMb1FmVUU2UForMWFEL2RHSWYzMlQ4SHZoaVN2?=
 =?utf-8?B?NldKTzBLN0NYSEhrdit6VnBLWDRGQWdWdnFOaisyYnRLMkQzWmhZZmFBSmMx?=
 =?utf-8?B?NVRUK1BWVEFYMk5WaWkvZjVDZmR6M1NqMjdpaHI1OFhBWVJEdUc0VnZQV014?=
 =?utf-8?B?UDZ0OWpDdERaUi9ma1lkTjIzZnhqSkw1Mm40WXBZYnB2Yk16NE5XenZhVmxP?=
 =?utf-8?B?dThmZVZnQUNTZ0pYSnZCMXdMdkpjWE9LM01hZHdkQmxXWm5pYThVTVA5ejlx?=
 =?utf-8?B?NEZ3NGJiSk9BRUsyYVhzUzg1eVdhWUFUNDVGbmlBZ2NHdTZVTlh3STJRd2o3?=
 =?utf-8?B?OGNYWWhNaTFYR09GZGtDUC9UK2JCSG5ZMVc5bnRUK2lsU1hkSm9XK1hUMnJp?=
 =?utf-8?B?YUgxdnUvU3BYbmhLSi9GZW5zOFN5aWxSS1hxSG1EWmdYQThHVHlXekVNd0VP?=
 =?utf-8?B?cHYrMlBIelJDVmRTeWJmckpTS3BqTE9sWVdBVEdGamdPeW0xYmlyN0gyMTlY?=
 =?utf-8?B?NVZCeHNNTjNDQzl4aUw0Z29nMEV4Z0ZPYk45YXRuczNaMjlTT3krNldTV3JH?=
 =?utf-8?B?eFd2UFlqUi9mMmwza2VLV2lFLzRNMXdBZ1JwYUpibTVKMXpVeU1pUGo4dVIr?=
 =?utf-8?B?REphRytML2hzUDgyUjg4dzRjbnBlQVdMTHpIWStQUmc5d2l1ak4wRkI4dkVo?=
 =?utf-8?B?K0ZZdzFjV0o4N2ZGcmU3eDNIdW8yS2dVLzRjUXpmeUV6VzB0TW1ESExFQStu?=
 =?utf-8?Q?bz+7Ci1uej/GHS510cDtz9QiOXjU8RL/vZuntOnFzfIIf?=
x-ms-exchange-antispam-messagedata-1: TYH7RkKA8vBUzw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad15e50f-44e6-4fe4-ecd6-08da390b1ff3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 20:15:16.9693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: spelP5XD4DatW7Fc/wQSltyzuLOybOBd3pUr3U4SlZcpqqCD9hE8k9whK3Go3Atoc8BaBmdPFG7dIgNWlc9abg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCg0KDQo+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+IEZyb206IFRob3JzdGVuIExlZW1odWlzIDxyZWdyZXNzaW9uc0BsZWVt
aHVpcy5pbmZvPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxOCwgMjAyMiAwMTozNw0KPiBUbzog
S2FpLUhlbmcgRmVuZyA8a2FpLmhlbmcuZmVuZ0BjYW5vbmljYWwuY29tPg0KPiBDYzogY2FzdGV5
ZGUuY2hyaXN0aWFuQGZyZWUuZnI7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHJlZ3Jlc3Np
b25zQGxpc3RzLmxpbnV4LmRldjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5kZXIuRGV1
Y2hlckBhbWQuY29tPjsgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IExpbW9uY2llbGxvLA0K
PiBNYXJpbyA8TWFyaW8uTGltb25jaWVsbG9AYW1kLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRUdS
RVNTSU9OXSBMYXB0b3Agd2l0aCBSeXplbiA0NjAwSCBmYWlscyB0byByZXN1bWUgdmlkZW8NCj4g
c2luY2UgNS4xNy40ICh3b3JrcyA1LjE3LjMpDQo+IA0KPiBPbiAxOC4wNS4yMiAwNzo1NCwgS2Fp
LUhlbmcgRmVuZyB3cm90ZToNCj4gPiBPbiBXZWQsIE1heSAxOCwgMjAyMiBhdCAxOjUyIFBNIFRo
b3JzdGVuIExlZW1odWlzDQo+ID4gPHJlZ3Jlc3Npb25zQGxlZW1odWlzLmluZm8+IHdyb3RlOg0K
PiA+Pg0KPiA+PiBPbiAxNy4wNS4yMiAxOTozNywgY2FzdGV5ZGUuY2hyaXN0aWFuQGZyZWUuZnIg
d3JvdGU6DQo+ID4+DQo+ID4+PiBJJ3ZlIHRyeWllZCB0byByZXZlcnQgdGhlIG9mZmVuZGluZyBj
b21taXQgb24gNS4xOC1yYzcgKDg4N2Y3NWNmZDBkYQ0KPiA+Pj4gKCJkcm0vYW1kZ3B1OiBFbnN1
cmUgSERBIGZ1bmN0aW9uIGlzIHN1c3BlbmRlZCBiZWZvcmUgQVNJQyByZXNldCIpLA0KPiBhbmQN
Cj4gPj4+IHRoZSBwcm9ibGVtIGRpc2FwcGVhcnMgc28gaXQncyByZWFsbHkgdGhpcyBjb21taXQg
dGhhdCBicmVha3MuDQo+ID4+DQo+ID4+IEluIHRoYXQgY2FzZSBJJ2xsIHVwZGF0ZSB0aGUgcmVn
emJvdCBzdGF0dXMgdG8gbWFrZSBzdXJlIGl0J3MgdmlzaWJsZSBhcw0KPiA+PiByZWdyZXNzaW9u
IGludHJvZHVjZWQgaW4gdGhlIDUuMTggY3ljbGU6DQo+ID4+DQo+ID4+ICNyZWd6Ym90IGludHJv
ZHVjZWQ6IDg4N2Y3NWNmZDBkYQ0KPiA+Pg0KPiA+PiBCVFc6IG9idmlvdXNseSB3b3VsZCBiZSBu
aWNlIHRvIGdldCB0aGlzIGZpeGVkIGJlZm9yZSA1LjE4IGlzIHJlbGVhc2VkDQo+ID4+ICh3aGlj
aCBtaWdodCBhbHJlYWR5IGhhcHBlbiBvbiBTdW5kYXkpLCBlc3BlY2lhbGx5IGFzIHRoZSBjdWxw
cml0DQo+ID4+IGFwcGFyZW50bHkgd2FzIGFscmVhZHkgYmFja3BvcnRlZCB0byBzdGFibGUsIGJ1
dCBJIGd1ZXNzIHRoYXQgd29uJ3QgYmUNCj4gPj4gZWFzeS4uLg0KPiA+Pg0KPiA+PiBXaGljaCBt
YWRlIG1lIHdvbmRlcmluZzogaXMgcmV2ZXJ0aW5nIHRoZSBjdWxwcml0IHRlbXBvcmFyaWx5IGlu
DQo+ID4+IG1haW5saW5lIChhbmQgcmVhcHBseWluZyBpdCBsYXRlciB3aXRoIGEgZml4KSBhIG9w
dGlvbiBoZXJlPw0KPiA+DQo+ID4gSXQncyB0b28gc29vbiB0byBjYWxsIGl0J3MgdGhlIGN1bHBy
aXQuDQo+IA0KPiBXZWxsLCBzdXJlLCB0aGUgcm9vdC1jYXVzZSBtaWdodCBiZSBzb21ld2hlcmUg
ZWxzZS4gQnV0IGZyb20gdGhlIHBvaW50DQo+IG9mIGtlcm5lbCByZWdyZXNzaW9ucyAoYW5kIHRy
YWNraW5nIHRoZW0pIGl0J3MgdGhlIGN1bHByaXQsIGFzIHRoYXQncw0KPiB0aGUgY2hhbmdlIHRo
YXQgdHJpZ2dlcnMgdGhlIG1pc2JlaGF2aW9yLiBBbmQgdGhhdCdzIGhvdyBMaW51cw0KPiBhcHBy
b2FjaGVzIHRoZXNlIHRoaW5ncyBhcyB3ZWxsIHdoZW4gaXQgY29tZXMgdG8gcmV2ZXJ0aW5nIHRv
IGZpeA0KPiByZWdyZXNzaW9ucyAtLSBhbmQgaGUgZXZlbiBtaWdodC4uLg0KPiANCj4gPiBUaGUg
c3VzcGVuZCBvbiB0aGUgc3lzdGVtDQo+ID4gZG9lc24ndCB3b3JrIHByb3Blcmx5IGF0IHRoZSBm
aXJzdCBwbGFjZS4NCj4gDQo+IC4uLmlnbm9yZSB0aGluZ3MgbGlrZSB0aGlzLCBhcyBsb25nIGFz
IGEgcmV2ZXJ0IGlzIHVubGlrZWx5IHRvIGNhdXNlDQo+IG1vcmUgZGFtYWdlIHRoYW4gZ29vZC4N
Cg0KSSB0aGluayB0aGUgcmlnaHQgd2F5IHRvIGZvY3VzIG9uIHRoaXMgaXMgdG8gZml4IHRoZSBv
cmlnaW5hbCBzdXNwZW5kIGlzc3VlLg0KVGhlIGZhY3QgdGhhdCB0aGUgZmlyc3Qgc3VzcGVuZCBp
cyBmYWlsaW5nIHdpdGggczMgc2hvdWxkIGJlIGEgcmVkIGZsYWcgdGhhdA0KdGhlIHN5c3RlbSBp
cyBpbiBhIHByZXR0eSBiYWQgc3RhdGUuDQoNCk1heWJlIGNhbiB3ZSBnZXQgL3N5cy9wb3dlci9w
bV9kZWJ1Z19tZXNzYWdlcyB0dXJuZWQgb24gYXMgd2VsbA0KYXMgIC9zeXMvcG93ZXIvcG1fcHJp
bnRfdGltZXMuICBUaGVuIHdlIHNob3VsZCBoYXZlIGEgYmV0dGVyIGlkZWEgb24NCndoYXQgaXMg
Z29pbmcgb24gdGhhdCB0cmlnZ2VycyB0aGF0IGZpcnN0IGZhaWx1cmUuDQoNCkFnYWluLCBpdCB3
b3VsZCBiZSBtdWNoIGJldHRlciB0byBwdXQgYWxsIHRoaXMgaW4gYSBidWcgcmVwb3J0IHNvbWV3
aGVyZS4NCkl0J3MgcmVhbGx5IGhhcmQgdG8gYXNzb2NpYXRlIGRtZXNncyBpbiBhIHRocmVhZGVk
IGVtYWlsIHdpdGggd2hhdCdzIGdvaW5nDQpvbi4gIEtlcm5lbCBCdWd6aWxsYSwgQU1EJ3MgR2l0
bGFiLCBpdCBkb2Vzbid0IG1hdHRlciB3aGVyZSByZWFsbHkuICBBbnl3aGVyZQ0KaXMgYmV0dGVy
IHRoYW4gZW1haWwgdGhyZWFkcyBJTU8uDQoNCkluIHRoaXMgY2FzZSB0aGUgcmV2ZXJ0IHdvdWxk
IGNhdXNlcyBwcm9ibGVtcyBmb3IgdGhlIHJlc3VtZSBvZiBhbnkgZEdQVS4NClNvIGl0J3MgYSB0
cmFkZW9mZiBvZiBtYW55IGRHUFUgcmVzdW1lIGZhaWx1cmVzIHZzIG9uZSBBUFUgcmVzdW1lIGZh
aWx1cmUNCmluIHMyaWRsZSBhZnRlciBhIGZhaWxlZCBzdXNwZW5kIGluIHMzLg0KDQpCVFcgLSBJ
J20gbm90IHJlYWxseSBzdXJlIHdoeSB0aGUgc3lzdGVtIGlzIHBpY2tpbmcgczJpZGxlIGZvciAi
dGhlIHNlY29uZCB0cnkiLg0KSXMgdGhhdCB0aGUga2VybmVsIGRvaW5nIHRoaXMsIG9yIGlzIHRo
aXMgdXNlcnNwYWNlIGNhdXNpbmcgaXQ/ICBXZSByZWFsbHkgc2hvdWxkbid0DQpiZSBzZWVpbmcg
ZGlmZmVyZW50IHN1c3BlbmQgbW9kZXMgYWNyb3NzIGF0dGVtcHRzIHdpdGhvdXQgYSB1c2VyIGNv
bnNjaW91c2x5DQpzZWxlY3Rpbmcgb25lLg0KDQo+IA0KPiBDaWFvLiBUaG9yc3Rlbg0KPiANCj4g
DQo+ID4+IENpYW8sIFRob3JzdGVuICh3ZWFyaW5nIGhpcyAndGhlIExpbnV4IGtlcm5lbCdzIHJl
Z3Jlc3Npb24gdHJhY2tlcicgaGF0KQ0KPiA+Pg0KPiA+PiBQLlMuOiBBcyB0aGUgTGludXgga2Vy
bmVsJ3MgcmVncmVzc2lvbiB0cmFja2VyIEkgZGVhbCB3aXRoIGEgbG90IG9mDQo+ID4+IHJlcG9y
dHMgYW5kIHNvbWV0aW1lcyBtaXNzIHNvbWV0aGluZyBpbXBvcnRhbnQgd2hlbiB3cml0aW5nIG1h
aWxzIGxpa2UNCj4gPj4gdGhpcy4gSWYgdGhhdCdzIHRoZSBjYXNlIGhlcmUsIGRvbid0IGhlc2l0
YXRlIHRvIHRlbGwgbWUgaW4gYSBwdWJsaWMNCj4gPj4gcmVwbHksIGl0J3MgaW4gZXZlcnlvbmUn
cyBpbnRlcmVzdCB0byBzZXQgdGhlIHB1YmxpYyByZWNvcmQgc3RyYWlnaHQuDQo+ID4NCg==
