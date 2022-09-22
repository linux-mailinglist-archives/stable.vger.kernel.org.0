Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FCE5E69DE
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiIVRsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 13:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiIVRsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 13:48:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B074E9996;
        Thu, 22 Sep 2022 10:48:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM1cBhdCLgDWEhGo33AG0Rk4y+05F8C+G1zL9uWqTqWdyaTSZ1tsMngEhWnmG/lAwSoPoEO8zccEfmKLpczFsnRQRATUXFDOmHBw1nGW6hr0b7yB4NYaS60wIGdilmB+UbJOce0sncosq/Pde88NGTELXKDb9rl2DyPxdg7UE9wQ0XrmUePAPI8vaJN0AxLLCZAlePa5QnJj0GAwFo081WC9LnwfSMfdQOEV7FAhcfv7R6nAEmEqOmY9L6j3WYYYyu2aOpGkYCh2kdTmDFweDrXk6v+UMi3PlIEnH0CUKMuTp9Y2aIQnDS1uF8H/eOlJfkScjtEZXlvjc93PjwzxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8j2zYSCvNWjpyci0pZc8nrth7YYo2Vn+0mJAqtDQkU=;
 b=TnS6zrzJDFLyBBDlt0qyPiMrQJrKgQzlF/9mSCgLzim2HC4q9BvDhXyVdDAFYmuuRjy9eSUK/76hhGHUeqC2eKN4fVstRWAdAKjlPm13zpjVhLIhFmJY3GWWdk5eRMoBwhQRegSyjccJFcemEKX4n5i5Eq5MenPCiQNyK7kFRZdHNhuLT6cHnuL1ak83rR01MR+oW44p2ncptQIQEFz6KoVM/ne/FsR3XouaHDka7StiuKIBnhu10ghj8pF05zXUI1ik98h5hWBtXNHHIXAqUHby8s56gJtVC9JHETR1UC8SkBffTUtCY5Z94BB0MrkadVPdCGfWSQjMEufNV6GeSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8j2zYSCvNWjpyci0pZc8nrth7YYo2Vn+0mJAqtDQkU=;
 b=l/BpMbMSor5FDhrkhIHSrJYY9Vqg1J36iIwSPMSm3Sswe+SSOKYFBw6wxdU9Pe77GaIk143rUFERRsJvVoSzcdOg/p8iXxkpvyZZ1I6XYN4aqjLqyDqW9ZHnq8NpMBAGoLouaaPS5JV3NP1ZQdwW6ytfm3gYtDQdZ9x4b0Dbm/g=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SJ0PR12MB7035.namprd12.prod.outlook.com (2603:10b6:a03:47c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 22 Sep
 2022 17:48:48 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%7]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 17:48:48 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        "Nayak, K Prateek" <KPrateek.Nayak@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andi@lisas.de" <andi@lisas.de>, "puwen@hygon.cn" <puwen@hygon.cn>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Narayan, Ananth" <Ananth.Narayan@amd.com>,
        "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>,
        "Ong, Calvin" <Calvin.Ong@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Thread-Topic: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Thread-Index: AQHYzYSfJnaVyId5REam4NmoMbIuNa3rqjGAgAACsYCAAAITAIAACtxA
Date:   Thu, 22 Sep 2022 17:48:48 +0000
Message-ID: <MN0PR12MB610110D90985366A4B952CCCE24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
In-Reply-To: <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-22T17:41:50Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=80304d87-1672-444d-a353-ef243bd7c13c;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-22T17:48:46Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e00b0cbe-b8c5-4e1e-9c64-695926dcf26a
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SJ0PR12MB7035:EE_
x-ms-office365-filtering-correlation-id: 595c3632-70db-49ef-136a-08da9cc2b3e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Es0M8KNdVBPV3sgzJ51QCxu7edeEp/1G5XgKOxtkSQP2JvtoRGHijl10e3MmJwjNjUmE99/LrlmTlLZFWepnFfrWQ5V8W2O7VG5R3ahRJG8rBFzscRdtWYtRYxkI4AyevCx3dHhnMjTnwlk4uG+EUetrUOtBJOwjHGHAEiITjuGHBxY/sJI1YBUETwfydBqA2OKMPX86WJ1tA3+4uGAFj3syok5aS6+FcCxCIkvd3Hf0/ZkfS7oq/tnfKMvW5NfXSQW/OMxqh9IQljpvBYt/Yy2Tm1dC4hfd8yPdmbywCnAKpQHGrzGNihkco/0pU5IWbatsjshpj011AdWtg+bIRoLbQ4vrlmFs/2y/rB9GYnpBXaAOLLeYskuOC3h9Q3G6+gbVYsrf3EcX1H8lgfKBjykKJXwhDsGoK55Bzdz7Mswd+WnI8m2iOAioeb1hj7RzQxcUIrfkehkoSIlKxN2Tave2uDOnYEKX8bSSNJG8NGNXeGgZc14iihPP7QKSno8ldJV0G1a4hEvanoPc3pzJEb4WG9pzL46tFYZOaWFkdQEjUeAijRN6KHTrJMjdq2UEt1Qkwo5ouLSjv8a2AMwuJW8UQNOLD2qK1AW9asPI0cAjGBuo5vIF0qMoQkevtfOntXdRCyxY1ijkln/N/4V3gDGqG7OLFq4t+mJ5/bB1F0xItzh0dKA5Dl2TwIygKbvynr5XJDLiRjDTGwMmDFnKmbGyvJwJUKcjFyLKD7tLuQqF6Ma6Ffed6r3PdaWKANH1wGUp1W6h2uWLHRTGRW4FXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(8676002)(4326008)(38100700002)(122000001)(316002)(8936002)(86362001)(7416002)(33656002)(66556008)(64756008)(66446008)(66946007)(66476007)(55016003)(52536014)(2906002)(478600001)(76116006)(9686003)(186003)(71200400001)(54906003)(6506007)(26005)(41300700001)(110136005)(53546011)(5660300002)(38070700005)(83380400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDVMRmQyVnRXVkFhcFZNSG1rS3RvM1NIRHpLZm4xckZJcVRSdEY1TElmL1Y3?=
 =?utf-8?B?WHZXTjJTWFBtb2xpTDkzc2QveHJTWkJwQ3ZNUUI2VVdncFU4OGQ5SXBDNk9a?=
 =?utf-8?B?TlBtTHlCdEFSWENzQ1IrY3B5SUZNbFM3MGhlTTV1ZkNHN0w5a00xaTFacFVS?=
 =?utf-8?B?TXRkclhyWHZ6b292bThUSEM2bTJTZ0x4RUdlYmFUemZ0c3p5SDZzb2NGS2RX?=
 =?utf-8?B?Vld2REJncFJ6VHc5ZWNzZHQ1My9Xc2NiNU5ERE9ZWDFzTHUyOXk3OXN0NGFv?=
 =?utf-8?B?cjk1aDhJeWlvM3g2TmUzcUxDK1pGZU53Nnp3ZDc5aWtYUm8zR3FNeUlVQlBN?=
 =?utf-8?B?MHFWWnh6VUp1L3hkcW5rUXUra3ViT0JrZkUyMVpvREJHOWFmZ1VQU214Qk9L?=
 =?utf-8?B?MFgzdUd0Y0hpTkFOUzFDTzVUdThWSU1RcEYzeGJpVHRzUFNzVWxDSEJMazJi?=
 =?utf-8?B?OGt0dzZQcjlucURuOFgwZUYwWWt4aVdoVGtzUkNJTHl5NStvRENzRFRuM0hh?=
 =?utf-8?B?S2ZFOGdNUUpJV1ROMDdBSjNtUnZOemtxQklibkNQR1dQT2lZc3EwWG5xREFi?=
 =?utf-8?B?RUlGaHVSZkFVSWc1bG01OE5UUDN2Tkp5RnpVSG9MUzFuNGt3dmFKZXJJVEtK?=
 =?utf-8?B?dzJpUjc3ak1jSnNvR0tzRVd1eW9GN2tHLzlvR0V4UmdVNnBqM09WT0MvYlM3?=
 =?utf-8?B?RnI5NDh2V2NUeVRVNWlQcnQwSkNIeEdUNS9TaFU1TmVvQ1l6bzQrMmVNL1Ba?=
 =?utf-8?B?eWhENVA3TEdIR0g0VGZxWmw2Q2k4T0lvaUhmdHlpcjVRK1RUTUpVdXdVTnFk?=
 =?utf-8?B?S1hEd1lERTRGaWxrYUhlNk1DS1BONFR1MXVEL3FZL25IazNIYm1NSTBJVTBO?=
 =?utf-8?B?NWpFbFErMVZ5MU5tUFFVYTdEL3lHT1FjSCtoMjQvQTAxek8yRjA0b3FCczJx?=
 =?utf-8?B?bFgvNmJUT3FReHBZekYvUXp6UHNHOXZRQlhlTTZPRFJ4akdKVW9BMVBySzQx?=
 =?utf-8?B?US9FaFhEWk9yc2JDTnJWeEJ0SXlxektzbDNldnFraVFPUWlwTERhTCtNVzBv?=
 =?utf-8?B?eGNOZ3lReTQ2UWxqM0JSYkZrckF3aHd0Zk5lVzkwSmloNFdJcUdIN2JlUU4w?=
 =?utf-8?B?Z29Nc2l0QTdHU1JGc2dWRVM5U2wxQkducTF3dkRINEI2MXBMdTZQVDFOcG9m?=
 =?utf-8?B?MW5UZWJ6MUFhYWxKSzJMWG9xeHZqL2l6TTI5T0graWE4UHNOR3VaZU1pdTBB?=
 =?utf-8?B?MlErSThLN2c1TjJLZWhVNkxHYmEwOC9XaGc1S1hBUnZuWkRKU0RNalBqNzZC?=
 =?utf-8?B?bWVUV09ZNXlFSHB5SGhoNUpBblVQc0NuZVRwM2VMckM2S3l5bWJpZkNoUjlq?=
 =?utf-8?B?VFVHUFFTRnNQMGNJLzl3L1VUaGlHcUFVelluZDZGVTlldVNydnAvZ0R0d0xO?=
 =?utf-8?B?UjVYR1c4NHdWcEE5WkNpSlZsenpaOFhXZVpBTEwyNDlUcnl3QzNodEpjUVZQ?=
 =?utf-8?B?TjVPTFA4MDdvaEp2aFI3SFJiL01JUm1tcGxZMnQ1TmZIKzg5dlJCM3l3TVhy?=
 =?utf-8?B?WUV3ZFR6cFJ6dG5iK3hpRXNUaGZTWU9LWXhrSjd4dzFsRW5ESEFMTGh1MW9N?=
 =?utf-8?B?UTlNTGgraXMxY2NqWVBCaVNpSUt6UGRZcWs4M0pKeHg0ZlB5NndsMXNmdVI1?=
 =?utf-8?B?dTFMWVJLYzBoV1pnbkJaVjRSc09rcUt0TUs5bU1FUStjT2o1bSs0QWozMnZ4?=
 =?utf-8?B?ZXF5eVJNSWRiZU1uTHZHdE5QQ0dNZU0vZDhDcUpTdDJpbC9IaWs4QUJXUmNk?=
 =?utf-8?B?RElPeWlBOVBxVTJUVkRSVzYvRkx0bmQ1U2hJL1d2QmNLcjUzUkR0RHpaaUIz?=
 =?utf-8?B?ZFIrN0pNbDJVUmhzaWZrUERUSXdBSDRHdThVdVZCQ3BCbnR1b1ZQTCsxWmtO?=
 =?utf-8?B?bExkSS9RR2JEdDZtWnBWOEJwZ1NWWERZRWxocEJvSGFGR3BHSnFuK3BSaVda?=
 =?utf-8?B?WUduSkpWeE9RQ1BzM2pLRVFzQlpJOUswM21Fc2QzMmxoWHJ2Y3hVVHNoVk8v?=
 =?utf-8?B?UDFSSE1pOFErbkttYi9PbHpLWHBOOU5xWjROZ3VMZEMvV3NVRzB6YWJpWXQr?=
 =?utf-8?Q?Yllg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595c3632-70db-49ef-136a-08da9cc2b3e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 17:48:48.1641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/vaJRN/oKMulrziJj46nYsA9dnwEM+Lx93cKKP/Ts9CMa9hBSal+pQUhSInFyoTJx9vlmlCRiKMUOaKA1+EMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7035
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2
ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRl
bWJlciAyMiwgMjAyMiAxMjowMg0KPiBUbzogTmF5YWssIEsgUHJhdGVlayA8S1ByYXRlZWsuTmF5
YWtAYW1kLmNvbT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiByYWZh
ZWxAa2VybmVsLm9yZzsgbGVuYkBrZXJuZWwub3JnOyBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9y
ZzsgbGludXgtDQo+IHBtQHZnZXIua2VybmVsLm9yZzsgZGF2ZS5oYW5zZW5AbGludXguaW50ZWwu
Y29tOyBicEBhbGllbjguZGU7DQo+IHRnbHhAbGludXRyb25peC5kZTsgYW5kaUBsaXNhcy5kZTsg
cHV3ZW5AaHlnb24uY247IExpbW9uY2llbGxvLCBNYXJpbw0KPiA8TWFyaW8uTGltb25jaWVsbG9A
YW1kLmNvbT47IHBldGVyekBpbmZyYWRlYWQub3JnOw0KPiBydWkuemhhbmdAaW50ZWwuY29tOyBn
cGljY29saUBpZ2FsaWEuY29tOyBkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnOw0KPiBOYXJheWFu
LCBBbmFudGggPEFuYW50aC5OYXJheWFuQGFtZC5jb20+OyBTaGVub3ksIEdhdXRoYW0gUmFuamFs
DQo+IDxnYXV0aGFtLnNoZW5veUBhbWQuY29tPjsgT25nLCBDYWx2aW4gPENhbHZpbi5PbmdAYW1k
LmNvbT47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IHJlZ3Jlc3Npb25zQGxpc3RzLmxpbnV4
LmRldg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBBQ1BJOiBwcm9jZXNzb3JfaWRsZTogU2tpcCBk
dW1teSB3YWl0IGZvciBwcm9jZXNzb3JzDQo+IGJhc2VkIG9uIHRoZSBaZW4gbWljcm9hcmNoaXRl
Y3R1cmUNCj4gDQo+IE9uIDkvMjIvMjIgMDk6NTQsIEsgUHJhdGVlayBOYXlhayB3cm90ZToNCj4g
Pg0KPiA+IE9uIDkvMjIvMjAyMiAxMDoxNCBQTSwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+ID4+IE9u
IDkvMjAvMjIgMjM6MzYsIEsgUHJhdGVlayBOYXlhayB3cm90ZToNCj4gPj4+IENjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQo+ID4+PiBDYzogcmVncmVzc2lvbnNAbGlzdHMubGludXguZGV2DQo+
ID4+ICpJcyogdGhpcyBhIHJlZ3Jlc3Npb24/DQo+ID4gT24gc2Vjb25kIHRob3VnaHQsIGl0IGlz
IG5vdCBhIHJlZ3Jlc3Npb24uDQo+ID4gV2lsbCByZW1vdmUgdGhlIHRhZyBvbiB2Mi4NCj4gDQo+
IFdoYXQgd2VyZSB5b3UgcGxhbm5pbmcgZm9yIHYyPw0KPiANCj4gUmFmYWVsIHN1Z2dlc3RlZCBz
b21ldGhpbmcgbGlrZSB0aGUgYXR0YWNoZWQgcGF0Y2guICBJdCdzIG5vdCBuZWFybHkgYXMNCj4g
ZnJhZ2lsZSBhcyB0aGUgWmVuIGNoZWNrIHlvdSBwcm9wb3NlZCBlYXJsaWVyLg0KPiANCj4gQW55
IHRlc3Rpbmcgb3IgY29ycmVjdGlvbnMgb24gdGhlIGNvbW1lbnRhcnkgd291bGQgYmUgYXBwcmVj
aWF0ZWQuDQoNClRoaXMgc2VlbXMgcmVhc29uYWJsZSB0byBtZS4gIEFwcHJlY2lhdGUgdGhlIHN1
Z2dlc3Rpb24uDQoNClNvbWUgc21hbGwgbml0czoNCjEpIFlvdSByZWZlcmVuY2UgaW5iKCkgc3Bl
Y2lmaWNhbGx5IGluIHRoZSBjb21taXQgbWVzc2FnZSwgYnV0IHRoZSBjb2RlIHRoYXQgaXMgc2tp
cHBlZCBpcw0KYWN0dWFsbHkgaW5sKCkuDQoNCjIpIFRoZSB0aXRsZSBzYXlzIHRvIGxpbWl0IGl0
IHRvIG9sZCBpbnRlbCBzeXN0ZW1zLCBidXQgbm90aGluZyBhYm91dCB0aGlzIGFjdHVhbGx5IGVu
Zm9yY2VzIHRoYXQuDQpJdCBhY3R1YWxseSBpcyBsaW1pdGVkIHRvIGFsbCBJbnRlbCBzeXN0ZW1z
LCBidXQgZWZmZWN0aXZlbHkgd29uJ3QgYmUgdXNlZCBvbiBhbnl0aGluZyBidXQgbmV3DQpvbmVz
IGJlY2F1c2Ugb2YgaW50ZWxfaWRsZS4NCg0KQXMgYW4gaWRlYSBmb3IgIzIgeW91IGNvdWxkIGNo
ZWNrIGZvciBDT05GSUdfSU5URUxfSURMRSBpbiB0aGUgSW50ZWwgY2FzZSBhbmQNCmlmIGl0J3Mg
bm90IGRlZmluZWQgc2hvdyBhIHByX25vdGljZV9vbmNlKCkgdHlwZSBvZiBtZXNzYWdlIHRyeWlu
ZyB0byB0ZWxsIHBlb3BsZSB0byB1c2UNCkludGVsIElkbGUgaW5zdGVhZCBmb3IgYmV0dGVyIHBl
cmZvcm1hbmNlLg0K
