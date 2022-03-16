Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3044DB1DE
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbiCPNvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiCPNvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:51:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0C660CD1;
        Wed, 16 Mar 2022 06:50:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCIw84l+PRmOHpyatLCF/TyTIesWgpQUeqoe6xEbbR6KhkkIB8Pv1l1OPYjQOsS6vMVkW3yX+H5uD2SMYYrKauXlfuTYpEXl42o91dfUVu3cIdwQFYmes09+T3afsFEyiPUNzWsRfxf4mQAtA9w3BI0DC8b1fjn/tZcE08EvRmes+wpIvgbCbWuPgPgHARaTaFuP7yut2CscfKOd4hwzQTv/oPgd93BIqT8PzRdNBfjy+vS89m9OaHfWyFjf6Llg0OiGLtE+j9e7b8u5BNbK0eCn8EAYshahjCiyWdqOBrknXnKvBm9xpVw9s3UDqTEsuBTppboD88H51P6tV+itUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6U/VITMc7+f+qWy9cBnB172HMYdf8Svw3nAEk2+oHU=;
 b=B7/VxbGe/gO6OFwifKipDzMWfhhcRt7DWgqkuGVig+6i/IJY7zy3CQpSQSwJnRU0/3NWcDqiLZRZ6tLm/YLEQLZf2GN4DpqCnUQAzZpYnRXIHbnQwFaI4BIjOEsT1eXDFhmORsqzqbFfLSxhw32YfRV2j6TrTXXmrL9lWfFvKuu+fznYpdSfGLvdeGqpAfLCHLyKjCnKBdhL3ov7q9Kl2/OoEJbR0vrfuGi05fOqlvYwFraICjq7+u4eC+XOjvHBZHk+fWk0EA29KlVASjFcUHw7mT0jueTLTfyuqnXXosOCnkh5fidf+e/t5Ixam/1rQ6bIICrqKNA7RDHLpkMYIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6U/VITMc7+f+qWy9cBnB172HMYdf8Svw3nAEk2+oHU=;
 b=uFbZHr0oBqcqtDbx23pkdTIF4nMNVwHK9nA9nJDn07iXXknOEtWIXXkesN10YDCdxuvoMlU1XLJmnQ1dMD1HK4bhWCHg01yb1/vyYQSpK/vh4Th5e2tCdH83T1gXggeg5ID2NH+q2q1hsExaA2WsFjtMXwjgufPF9NO9HDkbs7M=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 13:50:25 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08%5]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 13:50:25 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Hans de Goede <hdegoede@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: RE: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Thread-Topic: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Thread-Index: AQHYN7EE9MG5JHJAY0ujFaTCu2p8pKzB/M0AgAAFFgCAAAckgIAAANfA
Date:   Wed, 16 Mar 2022 13:50:24 +0000
Message-ID: <BL1PR12MB5157FFFEE1D9D13BAEF42CB5E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
 <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
 <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com>
 <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
 <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com>
 <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
 <CAJZ5v0irKgmSQ7YegP=US1ACUfqVMCNitu2azMbMAqm2f+cXTg@mail.gmail.com>
 <BL1PR12MB51572AA41E116C59FE0D5698E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
 <CAJZ5v0g5YcieFtPxPYgdPzEPKQU_V9g_e7qMYGsrLORE5qevqQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0g5YcieFtPxPYgdPzEPKQU_V9g_e7qMYGsrLORE5qevqQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-03-16T13:50:07Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=77795998-6607-4e6b-a3b1-8526d632d566;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-03-16T13:50:23Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 380d4ca2-5f37-4ba1-8d71-64c374c26490
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7b481cb-3597-4e8c-fcc1-08da0753ec18
x-ms-traffictypediagnostic: BL1PR12MB5825:EE_
x-microsoft-antispam-prvs: <BL1PR12MB5825F65B260F242FFBE59CB8E2119@BL1PR12MB5825.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kNcmf6mlsLoSRmrDv2ZS4xQsLrlSf7LdCFtOrkZ2ZcMryGVkmWz1KUVCfEbMtJUnxqQXkSbB2N/aEa6lwms6xAaSZ+6cctyxjSTsTs6bBMSL4IjGxtljZ0pfHgsz/tV+5ceO5jXigDx9WsQKMs7paSvWXYijjksIu996Dc6yz84E8l0e//kIsuVS6wgS4IqvXLELgCNQ2JhQEttdS1a0ls/ZYMxY3D1D6cmPt1+HpfENtW3HqhtfjPsBHiZWs18shZJWpZIdyvetojgmj4/H77FrP+qqiREq+M7gouBI7gIp5CBgoJazA1IR1GlEyDB6qpO9yKN0DhNjzbofW3T8Ts9r3neJwfW5VapzoWb1Gy3HzpNmeUej3iEK5oXwpEkQV7VtI2UoqUoxAlUtg/ehhS5Lld2+PXq6ftS2DVli91SeuJGUYi5EQ8ADzWbjEPQbDJtnD8l6COqv8c/gpzzpjuR645+8/HJHVmmmfF7jTXS6MeJjJXwMXtoSmv6jVWWjSirtHouk9wm38cULwbJiDJSMSfGtcykvWiMTwIHFR/7frcKWvw9xPWCOxR9SehAlbTyaEQ9zGe4B1sDHVtnyKwI8ntg3RNkkqqfOvO+/wGY/18402bXGULhHy3a7/sM50I+Cx8u3ZCoJ6PGkeF6/Een087a6oPSwKt1St2J3ilImlYHtBdWtI+6A3gollBWxBlUN1Fv2siPNj4Q7WIqagA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38070700005)(83380400001)(38100700002)(33656002)(5660300002)(6916009)(316002)(54906003)(71200400001)(8676002)(52536014)(4326008)(55016003)(2906002)(64756008)(66476007)(7696005)(53546011)(86362001)(6506007)(66556008)(66946007)(8936002)(66446008)(76116006)(122000001)(15650500001)(9686003)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGlYcm94RTk5dzQ0RkIvNmwvM0puK1dqYzkvY0NOV1FDTlhldjRWSVFOTjha?=
 =?utf-8?B?ZjkyR2FKS2N3NXIxUHlDdkFoSUlOTnF3MXhVWmRxQUpUQzVKRlIvdjV0VGhR?=
 =?utf-8?B?RkVIYm9qTFZPRnNaVy9iTXhkcGVsUmVrcDhFbUtMWjRpeVRjWWZFZXhaSE1N?=
 =?utf-8?B?dUwwb1FTQ2dkcDNzWGU2bmg5RGNGYWcrZXpSVERvTWU3Nk5xREMvSzgzWHBl?=
 =?utf-8?B?MElyTE5VL09HVDlQdE9ENjlCK3VXcERRa3Q4dUp3clM1dWNXYXNVaStZQ0k5?=
 =?utf-8?B?UHdCTVN1RmRRV2tDcEFKWTNQUzY0UmJ5Rm13eGVVZW1JRjhoaDRFc0tjVlM3?=
 =?utf-8?B?cmdodlZvb2Y3NG9qcmx2WFpYZW55QW1VUUFZOUE5dnNzTURaZjdkay96ekx2?=
 =?utf-8?B?WE5XcnRVWU1sSnZhTEgzRy92ejVvY3lYT01ucGRlTk8rQlE1Mjg2ZDkwaEQ2?=
 =?utf-8?B?d25ncjJYN0twOURsRnJ3TUNibmtsSWpmeVI4TkpKcXFLYVNFYmRVcWJmdjF0?=
 =?utf-8?B?QkZHY3ZrcnY3NkpTL3lYdXVRV0V5NlJWNjd6QmJBSzIvclc4QzRER1liTndR?=
 =?utf-8?B?Nk9JM1NaWjgveWZYdDZZa25lT1pRVjNnajhrNjA5RFlWRkRqMDZxR21Ub2VR?=
 =?utf-8?B?d1dCanM0aFNjR3ZaNXg4TWZicGhrcCtCckZuZGU4RVVCTno4UWpjUXJYcjU5?=
 =?utf-8?B?L0U0aExqSEpRekZPT2YxYWI3M2p1bTlsN0ZGaXRzUVJGTUtKdGlGWnhJTEVr?=
 =?utf-8?B?RlA2VWp3MEFIampCVkJvSGVIaU80M05IRWFnRWV2K2lpbDErZFVUVTZORE1D?=
 =?utf-8?B?Sm5uVzRGVGoyazRiSmFHbUhTb0gwclZ1enhyaWxSaForZG1NRm5hNm1saGNN?=
 =?utf-8?B?T2dBY0d0ZHRpaXJWWWl5eE44enpmRFBXM2dtczFSS2Y3ZXJyRFViNTZ1Sks0?=
 =?utf-8?B?ZGtncmhOMEZCTkVJaFY2U0o0Yi9PZWRHWHV0cncrTVE3SkViWkt2amN0dlRI?=
 =?utf-8?B?N2ZDeUs0aVIvcGVxck0yckJaR2JmRkdkdjZ4M3FnVW5yLzRVb2FBWjFtTUF4?=
 =?utf-8?B?T2NrSlNnUTBDeFNPYiszK3R3c2QxeTJWcDFpbkhPWERzbmdoVkZEZktyZ0Rj?=
 =?utf-8?B?V05vNW9qWGxuNWV3N2E3aEdIM0ducmJsQ3dPZkxLT2dKb1ZSVjdhN2RWWmhY?=
 =?utf-8?B?blNRRDBHeGswTUNudG4vVFZHQlB1K0VpckdCKzZQbkhMZ3JPZFcwYmFGakFn?=
 =?utf-8?B?eWVSa0ZuTUJVcThjV05XSWtpdjlleXhPWGNROWJkZk8rWU9Sc0p0Mmk0UEtp?=
 =?utf-8?B?ZGtDbVp2TFRZYWU1VEtxbm1ES1BjK2tFaXBpVSt0ei9IMXFrVnlLb0FYKyty?=
 =?utf-8?B?Sjd1anc2WmxMcGlnN2NjZjV4RU8zWTBWMm9aSWVSRy91L0tRdm5DeTNPQ2ZF?=
 =?utf-8?B?V1pZaXJoWFRleDBwZGllbUI3V3lZaTFNcy84TjNCZmpYN2Z4alBsRmNSalow?=
 =?utf-8?B?ZVlTNnZyT0FjR2pydlU0YjVCK1kyaE9QNWRxUHp4NlpTQlJmVmpZc2wxd1Zt?=
 =?utf-8?B?clJLQmR4R0N5UlAxQVNhQlEyWVVqcDN0KytKeXNoUVAwRUNMc0grQmNyaDhE?=
 =?utf-8?B?enVVaVJPa2MxY1N4N0hUb1NMQjk0TzFRYXJLd2g2bmh2b0s2dFgzb1B3M29Q?=
 =?utf-8?B?NVh1YUVwWkFqdVY3LzBTTEZVNlNlbUIvK2prRVM3TmlvU0tHbmpOckIvSkli?=
 =?utf-8?B?ZlhTR1BYQkZwYVg0NUgrTENlYmhWbzVjb2hOQStBaStHUldOQTFIU0xtMVox?=
 =?utf-8?B?N2FGTmZaRWxqRTY1eVpwc3JRVTh1cTlNZ0tDSGRRM2kvK2hvR3prTVVuc1Uy?=
 =?utf-8?B?R1dVdjVGMUE2WU83OThEbFNHTmhIMGNWS0VFUkV3NzhTZ25yNE82TDBneXB3?=
 =?utf-8?B?aEJJV2FJbmh4TVJwMHZqSVc3OUZqN09XSGVzRlNSdmk2eEI4R1plbVdnMjBY?=
 =?utf-8?B?c1M5NlA2bllhSUo5WFcyZTBPQi9HNG9IdVVjNWdNMDNyL1IyOHFUTFNmYk5Z?=
 =?utf-8?Q?ez5L6z?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b481cb-3597-4e8c-fcc1-08da0753ec18
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 13:50:25.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +M9AmU2E7YqSihn5b8duyPrTvfKKPigTXpyI2+sr1kQj9KNq1DMxOvhj1ValEWIbkswB8OI85rUyC1Fx3W5B5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmFm
YWVsIEouIFd5c29ja2kgPHJhZmFlbEBrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIE1h
cmNoIDE2LCAyMDIyIDA4OjQ2DQo+IFRvOiBMaW1vbmNpZWxsbywgTWFyaW8gPE1hcmlvLkxpbW9u
Y2llbGxvQGFtZC5jb20+DQo+IENjOiBSYWZhZWwgSi4gV3lzb2NraSA8cmFmYWVsQGtlcm5lbC5v
cmc+OyBIYW5zIGRlIEdvZWRlDQo+IDxoZGVnb2VkZUByZWRoYXQuY29tPjsgTGludXggUE0gPGxp
bnV4LXBtQHZnZXIua2VybmVsLm9yZz47IFN0YWJsZQ0KPiA8c3RhYmxlQHZnZXIua2VybmVsLm9y
Zz47IEp1c3RpbiBGb3JiZXMgPGptZm9yYmVzQGxpbnV4dHgub3JnPjsgTWFyaw0KPiBQZWFyc29u
IDxtYXJrcGVhcnNvbkBsZW5vdm8uY29tPjsgQUNQSSBEZXZlbCBNYWxpbmcgTGlzdCA8bGludXgt
DQo+IGFjcGlAdmdlci5rZXJuZWwub3JnPjsgS2FpLUhlbmcgRmVuZyA8a2FpLmhlbmcuZmVuZ0Bj
YW5vbmljYWwuY29tPg0KPiBTdWJqZWN0OiBSZTogTWFueSByZXBvcnRzIG9mIGxhcHRvcHMgZ2V0
dGluZyBob3Qgd2hpbGUgc3VzcGVuZGVkIHdpdGgNCj4ga2VybmVscyA+PSA1LjE2LjEwIHx8ID49
IDUuMTctcmMxDQo+IA0KPiBPbiBXZWQsIE1hciAxNiwgMjAyMiBhdCAyOjM4IFBNIExpbW9uY2ll
bGxvLCBNYXJpbw0KPiA8TWFyaW8uTGltb25jaWVsbG9AYW1kLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiBbUHVibGljXQ0KPiA+DQo+ID4gPiA+IEp1c3QgRldJVyB0aGlzIGZpeCB0aGF0IHdhcyBiYWNr
cG9ydGVkIHRvIHN0YWJsZSBhbHNvIGZpeGVkIGtleWJvYXJkDQo+ID4gPiA+IHdha2V1cCBmcm9t
IHMyaWRsZSBvbiBhIG51bWJlciBvZiBIUCBsYXB0b3BzIHRvby4gIEkga25vdyBmb3Igc3VyZQ0K
PiB0aGF0DQo+ID4gPiA+IGl0IGZpeGVkIGl0IG9uIHRoZSBBTUQgdmVyc2lvbnMgb2YgdGhlbSwg
YW5kIEthaSBIZW5nIEZlbmcgc3VzcGVjdGVkIGl0DQo+ID4gPiA+IHdpbGwgYWxzbyBmaXggaXQg
Zm9yIHRoZSBJbnRlbCB2ZXJzaW9ucy4gIFNvIGlmIHRoZXJlIGlzIGFub3RoZXIgY29tbWl0DQo+
ID4gPiA+IHRoYXQgY2FuIGJlIGJhY2twb3J0ZWQgZnJvbSA1LjE3IHRvIG1ha2UgaXQgc2FmZXIg
Zm9yIHRoZSBvdGhlcg0KPiBzeXN0ZW1zLA0KPiA+ID4gPiBJIHRoaW5rIHdlIHNob3VsZCBjb25z
aWRlciBkb2luZyB0aGF0IHRvIHNvbHZlIGl0IHRvby4NCj4gPiA+DQo+ID4gPiBUaGVyZSBpcyBh
IHNlcmllcyBvZiBBQ1BJIEVDIGRyaXZlciBjb21taXRzIHRoYXQgYXJlIHByZXNlbnQgaW4NCj4g
PiA+IDUuMTctcmMsIGJ1dCBoYXZlIG5vdCBiZWVuIGluY2x1ZGVkIGluIGFueSAic3RhYmxlIiBz
ZXJpZXM6DQo+ID4gPg0KPiA+ID4gYmVmZDliNWIwYzYyIEFDUEk6IEVDOiBSZWxvY2F0ZSBhY3Bp
X2VjX2NyZWF0ZV9xdWVyeSgpIGFuZCBkcm9wDQo+ID4gPiBhY3BpX2VjX2RlbGV0ZV9xdWVyeSgp
DQo+ID4gPiBjMzM2NzZhYTQ4MjQgQUNQSTogRUM6IE1ha2UgdGhlIGV2ZW50IHdvcmsgc3RhdGUg
bWFjaGluZSB2aXNpYmxlDQo+ID4gPiBjNzkzNTcwZDg3MjUgQUNQSTogRUM6IEF2b2lkIHF1ZXVp
bmcgdW5uZWNlc3Nhcnkgd29yayBpbg0KPiA+ID4gYWNwaV9lY19zdWJtaXRfZXZlbnQoKQ0KPiA+
ID4gZWFmZTc1MDlhYjhjIEFDUEk6IEVDOiBSZW5hbWUgdGhyZWUgZnVuY3Rpb25zDQo+ID4gPiBh
MTA1YWNkN2UzODQgQUNQSTogRUM6IFNpbXBsaWZ5IGxvY2tpbmcgaW4gYWNwaV9lY19ldmVudF9o
YW5kbGVyKCkNCj4gPiA+IDM4OGZiNzdkY2Y5NyBBQ1BJOiBFQzogUmVhcnJhbmdlIHRoZSBsb29w
IGluIGFjcGlfZWNfZXZlbnRfaGFuZGxlcigpDQo+ID4gPiA5OGQzNjQ1MDlkNzcgQUNQSTogRUM6
IEZvbGQgYWNwaV9lY19jaGVja19ldmVudCgpIGludG8NCj4gPiA+IGFjcGlfZWNfZXZlbnRfaGFu
ZGxlcigpDQo+ID4gPiAxZjIzNTA0NDNkZDIgQUNQSTogRUM6IFBhc3Mgb25lIGFyZ3VtZW50IHRv
IGFjcGlfZWNfcXVlcnkoKQ0KPiA+ID4gY2E4MjgzZGNkOTMzIEFDUEk6IEVDOiBDYWxsIGFkdmFu
Y2VfdHJhbnNhY3Rpb24oKSBmcm9tDQo+ID4gPiBhY3BpX2VjX2Rpc3BhdGNoX2dwZSgpDQo+ID4g
Pg0KPiA+ID4gSXQgaXMgbGlrZWx5IHRoYXQgdGhleSBwcmV2ZW50IHRoZSBwcm9ibGVtIGV4cG9z
ZWQgYnkgdGhlIHByb2JsZW1hdGljDQo+ID4gPiBjb21taXQgZnJvbSBvY2N1cnJpbmcsIGJ1dCBJ
J20gbm90IHN1cmUgd2hpY2ggb25lcyBkbyB0aGF0LiAgU29tZSBvZg0KPiA+ID4gdGhlbSBhcmUg
Y2xlYXJseSBjb3NtZXRpYywgYnV0IHRoZSBvcmRlcmluZyBtYXR0ZXJzLg0KPiA+DQo+ID4gSGFu
cywNCj4gPg0KPiA+IERvIHlvdSB0aGluayB5b3UgY291bGQgZ2V0IG9uZSBvZiB0aGUgZm9sa3Mg
d2hvIHJlcG9ydGVkIHRoaXMgcmVncmVzc2lvbiB0bw0KPiBkbw0KPiA+IGEgYmlzZWN0IHRvIHNl
ZSB3aGljaCBvbmUgImZpeGVkIiBpdD8gIElmIHdlIGdldCBsdWNreSB3ZSBjYW4gY29tZSBkb3du
IHRvDQo+ID4gc29tZSBzbWFsbGVyIGh1bmtzIG9mIGNvZGUgdGhhdCBjYW4gY29tZSBiYWNrIHRv
IHN0YWJsZSBpbnN0ZWFkIG9mDQo+IHJldmVydGluZy4NCj4gDQo+IEl0J3MgYmVlbiByZXZlcnRl
ZCBhbHJlYWR5Lg0KPiANCj4gV2hhdCB3ZSBjYW4gZG8gaXMgdG8gcmVxdWVzdCBhZGRpbmcgaXQg
YmFjayBhbG9uZyB3aXRoIG90aGVyIGNvbW1pdHMNCj4gbmVlZGVkIGZvciBpdCB0byB3b3JrIGFz
IGV4cGVjdGVkLg0KDQpPSyB0aGFua3MsIG1ha2VzIHNlbnNlLg0KDQo+IA0KPiBBbHNvLCBJIHRo
aW5rIHdlJ2xsIG5lZWQgYWxsIG9mIHRoZSBjb21taXRzIGxpc3RlZCB1cCB0byBhbmQgaW5jbHVk
aW5nDQo+IGM3OTM1NzBkODcyNSAoIkFDUEk6IEVDOiBBdm9pZCBxdWV1aW5nIHVubmVjZXNzYXJ5
IHdvcmsgaW4NCj4gYWNwaV9lY19zdWJtaXRfZXZlbnQoKSIpIGF0IGxlYXN0LCBidXQgdGhhdCdz
IGp1c3QgYSBndWVzcy4NCg0KWWVhaCBzbyB3ZSdsbCBmb3Igc3VyZSBuZWVkIGEgYmlzZWN0IHRv
IGNvbmZpcm0gYW5kIGNvbWUgdXAgd2l0aCB0aGF0IGxpc3QuDQo=
