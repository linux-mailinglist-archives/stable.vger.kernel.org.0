Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A5D5E6E79
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 23:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiIVViP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 17:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIVViO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 17:38:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3607F106F65;
        Thu, 22 Sep 2022 14:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iExINK3pm+RGWkSlBp/Q3+KG7zJh9petYqdMQl9fs3RKGmrtuEtl4Orz8o1NP0gLcGsxrA0WY8DvhyZaPHJW9N/kqXq6gtKayK4ba/FQmwcAst4E9d5EB58jH/Y2PhjptbsrMYlKiEZnORHN3OOxBlyOeFQbKiqRaou+Woxjr3fpYD9EZ7eQtkynqqAlrGNN7ne2UFMBHSbySRC0hgkrF0/w1X01JiJcVsa+ymuWaAjoo+PAA5qz5SzN4M9Verzp1SjlL1yODv/DaxX56bLeE7ThvvgFBKLwJC8u+DLxzjxyguvc5MXCGVD6LVgGY21+rxlBix8pemX9ePNCO87KYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER4CUso4uES8Pz8tMfnRLW+sIrM7DfyfXn7Dn6BJxbo=;
 b=E7qBQBJufYiq5o7A/2SySdfNYgRCJMWeg41vF1A5cYfYsfCVOCXUwDrso2QkPG8sTfoLNL/adSMlDJQK0fc/rEa8CTgKZx9/LlrfLAkVCCYgwdSlSMTNDyqNTXl2KOpqp6N2w7nXxg0e2JNrsGQKJHzL5yfKCyh6VzlV5i/D2BrdsbbBuifo5f16C+Y8gv5XoZYmnvblnfsroEcz3pCPsKuRWPsJ/YK77IFUMGPHg/AOAtql2yjD1YkzyMfjZDw5Z5gwpGXJQS9/5jlv/UOKvHP/Z43qMeVgMCoV018+cJVnpSvlPbTf2en3fTuOiB0SGPJ0rE7YqJQltTP7YAQdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER4CUso4uES8Pz8tMfnRLW+sIrM7DfyfXn7Dn6BJxbo=;
 b=OKoCFU0Pc9RlgpXLDZH1MgpjMzP0besrKEyQfirPS0y21gc6hkyzi1kPtEmSycaut389axe0NdA4qLd8U6rBME4NBaHjrC49inxiYwDYFgosfocKa9J1ciwd/SjTaixxJJbfEZA00yGsUw4dTViP/5gfz4ljqzbrwGvDPfjpmMM=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 21:38:11 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%7]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 21:38:11 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>, Andreas Mohr <andi@lisas.de>
CC:     "Nayak, K Prateek" <KPrateek.Nayak@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "puwen@hygon.cn" <puwen@hygon.cn>,
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
Thread-Index: AQHYzYSfJnaVyId5REam4NmoMbIuNa3rqjGAgAACsYCAAAITAIAALNaAgAAH2oCAABPjgIAAA/0Q
Date:   Thu, 22 Sep 2022 21:38:11 +0000
Message-ID: <MN0PR12MB61013DC656891259F5D5FA96E24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de>
 <YyzBLc+OFIN2BMz5@rhlx01.hs-esslingen.de>
 <4d61b9c0-ee00-c5f6-bef1-622b80c79714@intel.com>
In-Reply-To: <4d61b9c0-ee00-c5f6-bef1-622b80c79714@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-22T21:38:08Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=26849dd7-4295-4372-a3a3-5014165fb241;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-22T21:38:09Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: cd066a01-a7e9-4170-8f34-2e6f5f79f4a5
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BN9PR12MB5242:EE_
x-ms-office365-filtering-correlation-id: 5c283f3c-10f8-42b1-5466-08da9ce2bf49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P5Mua972G0R2QAeV/OPgp3fZFMXfvcLpStlAPoroR5346to5c6frImhFPsSI0wwD3KRJN2b/BP2Baa+WZ8MvovTQJwFJuoLT9r2/typXjw00rOl8q7WIdb2WKk4UoA1mdkT3v52XmAztWFTE6g9mcouVssF/+/r4q0klw1sMQeXDc9SNfWLIP3K9hPkAanJlr0dcxs21gT0mhJ0JzuZVzomEw2RBk4lcCGUOExjVxJpfCGCU9hxtfrJ2V6OroHBnGaK0Bjdo93dtapBT1Yd/1JiIDzlTn2Agpf8p7J3oZUxV9E/8U2GolHUCmFtK/HTwTEWIP2K9SP/8Jlqs4ldq1lSoGfj3OAmHKCbFKGCvSRgSBx9GtH8AqAkDtoP+0V5YWwMxrNue/X8kKTM3EKeWTF/VVcaKydkKgkVdMDcv20HMuxk3BYhFwPquPcd1JVHz8gmobOuf/LQsoTSrjkQH3ElEQGLq1clGLqfVTOu4fSPD1b7EIR6DaiVTlhWqVj6wlUpLeTBQ4u8uyqzFjJLa13jqW1VGr920C8NPeo8ktFMttnrB1LFfcgAfRchSovnWidvKLUeSwZh7/w5e4Mh+RC4iG4scqt9+Xn0+bJ4hX+GqGNB4fVHkpiMCd+fh8tm0Ar9AJIiB+OYE8tdJXuE438uPh8pftUdIkegNNDJmxhfgfzmF6Q78hXdDXLSB6CaFEnCXTRMteBxz1J03yn+EeElpRKh5rJeIRrNlCxDkll3ZiEe9oUe8qtpMLzubYge21wIuFT9LutOROYWQSviIiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(76116006)(122000001)(83380400001)(2906002)(186003)(38100700002)(7416002)(5660300002)(52536014)(8936002)(9686003)(55016003)(53546011)(26005)(7696005)(38070700005)(41300700001)(66899012)(4326008)(478600001)(8676002)(110136005)(71200400001)(66946007)(66446008)(66556008)(66476007)(64756008)(54906003)(6506007)(33656002)(86362001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDNMeFY2ZlBTUHhrZFkvQlRvVU41WHhtS29wN213c3lNNFVPa3BGQkxFamRJ?=
 =?utf-8?B?d0hFaHVJKzhJdHNWVmVpN25wM3VaUW5ZUnFEdGlnWDhPS1prekJWZkF1Wko3?=
 =?utf-8?B?M3l0SnlRY29EODllN3RCRFNvZ0VjcWo4Vlh1cnU2Y0x5b1B0eWtnWE1pVklz?=
 =?utf-8?B?d05CTENkNHA5dEtxMHFEYWZPVTJrREFRMGJKWGlmWXVkSlVRZ0d1RTNxbExB?=
 =?utf-8?B?d0VhZFdDNEgrMHd3UUNkNjU4alhXeHdqUVFPQXh5SGdZMHJvaTIyVU5WUU9k?=
 =?utf-8?B?dFVldXVLRjBTTThsUmIwUTREOUZ0RWtTUG9hcXYwMXlsVzNpZytibTNHL3Vj?=
 =?utf-8?B?dkhlMGFsZ0pva0tDc1p4U1BZdVBLdDdwVUhsVnFzTzFMdXJmT1BSMVhVbXJq?=
 =?utf-8?B?N000OGcxZzd4azdyNXpVRW5QQlo1cVl1UkMvZnZLNFFmblRWbEtTeldBZWhO?=
 =?utf-8?B?WW5aNXRxR1pGNm4wTEtXcGRtSjUxSVc3SmlGYk9xTk8yR3BwSVlXeWkzbWtT?=
 =?utf-8?B?MVN0VjczK0pudmUvTzlXV04zKytJOEI2VUEzQlpkcDAxOXF4SFNidFV4ME14?=
 =?utf-8?B?NWdBUHd1eng2cTJjTURSYnlPcEduOWVzMFpvQmhOVWdvZC8xYWNTQjBhN2pI?=
 =?utf-8?B?TkZUZ1JUb1VIMzFVb216UWVnYUxTcTBBS05SRFJQVXYxeUhJc3o3STl1L2N5?=
 =?utf-8?B?TGIyYk9kTEZiSlk2U2ZvT2FQR1RVL1phUk16d1BnbTFPblk4U0pQTjBNVmxz?=
 =?utf-8?B?cGpScUlua3hlaGVBVEFMdG1ETVR4ZVl6SGhKQmlzNDZMMDBMQThCOTBDWGdB?=
 =?utf-8?B?SVdaNXpKdFVzaWYrajZJSmhZU0Y0UkNjcVd1ZUg2M0xEWEJqcUNOeldCOVpn?=
 =?utf-8?B?T0M5RUlZZUYvc0dOUWJMTjlHVEcyR1ZoS2pTbitBbDJRcnJtZTM3ZnBWTVRG?=
 =?utf-8?B?UDhweHBoNkZBdXByUE5FL2ErQXkxY2pNWHRueVRHRTlIL0kvWXNlUzNLUEVK?=
 =?utf-8?B?QitLTkpiVjBSdDFPVEg1MFlQbC9TdDZnbjl1QWNUZWlRNlM4ZDUyNUJmK1JX?=
 =?utf-8?B?QTNsNGNuZUxoRzZYOHozbExCNzc0aklybms2RE42MEhGRE9DY1FUWi9wa2FW?=
 =?utf-8?B?ckVSUE5aYzlYeCtHRkdYaUlzNWo1OU5MTlRUMU1iOXlOa0xKTjMvQVhmWmRv?=
 =?utf-8?B?MEQ3Zjltc1E2aGY3UUw4dmQ0M0RDYlhDQnJ0bkg5OS95MWhsTUdic2NQMEZy?=
 =?utf-8?B?andoU2l2WHIxaEthdGpmanF6VDREcUp2aFZpWis5aksxMmhKOVViZDhIMDJk?=
 =?utf-8?B?L2xFMGEvbTBkZE5WTFhwVm1LcXlRSzMyV1Rlbm1Zc2RyenQ2YktiMlFHT3Fr?=
 =?utf-8?B?cDV2OUhCVEFDTkRBMkpNRTVTeWt1U1VxcjVBL1I0ODFSb0RONDQ2YUVDY2dB?=
 =?utf-8?B?Y01RSUdtbnlkRFV5V0dyTzQ0WUxPSnN0cGJYaFZzb2FMUklxNVpDeTRqZnIv?=
 =?utf-8?B?eDhMYU9tMC9XY0ltT3AwajQwNWdMQzVRdDhBZWdNTFZNbjJLT05WZk81bWRN?=
 =?utf-8?B?bTVGTGRpL3h2Mmlzai9VeHRLNWowZ2lTZzNqLzFUaUVTeEpSVHhoVDZVaDBI?=
 =?utf-8?B?cGNGTFpaVDdWaU1pMFJaMitpRDZOUUxubXZYeXZURmF2WWszVjhabDB3SEtI?=
 =?utf-8?B?YWVuaFZtTzdGODJNVU1xVUliRkxNVEFMNUJaTlZVQnBoYmFWSjIrWDF4UWU5?=
 =?utf-8?B?ZHNpTXQrMXNlaGQzMUVkL3JndVo3MWJJeWtmRXlpYktuRG9xNEUyVndUTXM2?=
 =?utf-8?B?NkQrRHJvQ1BVWU01clVvOW5PbGNRMFV6Y3BqWUt5QWdXam1Cb0xYYzhvS1R4?=
 =?utf-8?B?dlhtUTF3alQ5Y3ZqeDFIdFEzcXcyRnJzMzdadEoxRkNndUFKRHRXM1JXaXh6?=
 =?utf-8?B?VG5CNTlTMnpxdGgzQk1sbERJZWI4MEwrRXQrdHptb3YwT2g0SGdvSHN3b3Y3?=
 =?utf-8?B?QXhHczI2WmptcFRqVmtjc0xvdTBjb3JQZTlpZE5YMDkweG81b1dZTThUVDVP?=
 =?utf-8?B?ZmxBbnVrOEd5R2J0NXVPZWZsdlRGd2NEVlY3TmdyR3RuN01hei9vL3I3QW0r?=
 =?utf-8?Q?z70g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c283f3c-10f8-42b1-5466-08da9ce2bf49
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 21:38:11.1673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iJTNq7BEoOX2xfx1GROAtzPIfgIypgCoa7ibE5g4HXHEToHQtL0UBepHjBzkNYdDV4bYyiFAUwXASd9EPkEiDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
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
bWJlciAyMiwgMjAyMiAxNjoyMg0KPiBUbzogQW5kcmVhcyBNb2hyIDxhbmRpQGxpc2FzLmRlPg0K
PiBDYzogTmF5YWssIEsgUHJhdGVlayA8S1ByYXRlZWsuTmF5YWtAYW1kLmNvbT47IGxpbnV4LQ0K
PiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyByYWZhZWxAa2VybmVsLm9yZzsgbGVuYkBrZXJuZWwu
b3JnOyBsaW51eC0NCj4gYWNwaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXBtQHZnZXIua2VybmVs
Lm9yZzsNCj4gZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyBicEBhbGllbjguZGU7IHRnbHhA
bGludXRyb25peC5kZTsNCj4gcHV3ZW5AaHlnb24uY247IExpbW9uY2llbGxvLCBNYXJpbyA8TWFy
aW8uTGltb25jaWVsbG9AYW1kLmNvbT47DQo+IHBldGVyekBpbmZyYWRlYWQub3JnOyBydWkuemhh
bmdAaW50ZWwuY29tOyBncGljY29saUBpZ2FsaWEuY29tOw0KPiBkYW5pZWwubGV6Y2Fub0BsaW5h
cm8ub3JnOyBOYXJheWFuLCBBbmFudGggPEFuYW50aC5OYXJheWFuQGFtZC5jb20+Ow0KPiBTaGVu
b3ksIEdhdXRoYW0gUmFuamFsIDxnYXV0aGFtLnNoZW5veUBhbWQuY29tPjsgT25nLCBDYWx2aW4N
Cj4gPENhbHZpbi5PbmdAYW1kLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHJlZ3Jl
c3Npb25zQGxpc3RzLmxpbnV4LmRldg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBBQ1BJOiBwcm9j
ZXNzb3JfaWRsZTogU2tpcCBkdW1teSB3YWl0IGZvciBwcm9jZXNzb3JzDQo+IGJhc2VkIG9uIHRo
ZSBaZW4gbWljcm9hcmNoaXRlY3R1cmUNCj4gDQo+IE9uIDkvMjIvMjIgMTM6MTAsIEFuZHJlYXMg
TW9ociB3cm90ZToNCj4gPiAgICgtIGJ1dCB0aGVuIHdoYXQgYWJvdXQgb3RoZXIgbW9yZSBtb2Rl
cm4gY2hpcHNldHM/KQ0KPiA+DQo+ID4gLS0+IHdlIG5lZWQgdG8gYWNoaWV2ZSAoaG9wZWZ1bGx5
IHN1ZmZpY2llbnRseSBwcmVjaXNlbHkpIGEgc29sdXRpb24gd2hpY2gNCj4gPiB0YWtlcyBpbnRv
IGFjY291bnQgWmVuMyBTVFBDTEsjIGltcHJvdmVtZW50cyB3aGlsZQ0KPiA+IHByZXNlcnZpbmcg
ImFjY2VwdGVkIiBiZWhhdmlvdXIvcmVxdWlyZW1lbnRzIG9uICphbGwqIFNUUENMSyMtDQo+IGhh
bXBlcmVkIGNoaXBzZXRzDQo+ID4gKCJTVFBDTEsjIEkvTyB3YWl0IGlzIGRlZmF1bHQvdHJhZGl0
aW9uYWwgaGFuZGxpbmciPykuDQo+IA0KPiBJZGVhbGx5LCBzdXJlLiAgQnV0LCB3ZSdyZSB0YWxr
aW5nIGFib3V0IHRoZW9yZXRpY2FsbHkgcmVncmVzc2luZyB0aGUNCj4gaWRsZSBiZWhhdmlvciBv
ZiBzb21lIGluZGV0ZXJtaW5hdGUgc2V0IG9mIG9sZCBzeXN0ZW1zLCB0aGUgbWFqb3JpdHkgb2YN
Cj4gd2hpY2ggYXJlIHNpdHRpbmcgaW4gYSBwdWRkbGUgb2YgY2FwYWNpdG9yIGdvbyBhdCB0aGUg
Ym90dG9tIG9mIGENCj4gbGFuZGZpbGwgcmlnaHQgbm93LiAgVGhpcyBpcyBmYXIgZnJvbSBhbiBp
ZGVhbCBzaXR1YXRpb24uDQo+IA0KPiBGV0lXLCBJJ2QgbXVjaCByYXRoZXIgZG8gc29tZXRoaW5n
IGxpa2UNCj4gDQo+IAlpZiAoKGJvb3RfY3B1X2RhdGEueDg2X3ZlbmRvciA9PSBYODZfVkVORE9S
X0FNRCkgJiYNCj4gCSAgICAoYm9vdF9jcHVfZGF0YS54ODZfbW9kZWwgPj0gMHhGKSkNCj4gCQly
ZXR1cm47DQo+IA0KPiAJaW5sKHNsb3dfd2hhdGV2ZXIpOw0KPiANCj4gdGhhbiBhIFplbiBjaGVj
ay4gIEFNRCBoYXMsIGFzIGZhciBhcyBJIGtub3csIGJlZW4gYSBsb3QgbW9yZSBzZXF1ZW50aWFs
DQo+IGFuZCBzYW5lIGFib3V0IG1vZGVsIG51bWJlcnMgdGhhbiBJbnRlbCwgYW5kIHRoZXJlIGFy
ZSBzb21lIEFNRCBtb2RlbA0KPiBudW1iZXIgcmFuZ2UgY2hlY2tzIGluIHRoZSBjb2RlYmFzZSB0
b2RheS4NCj4gDQo+IEEgY2hlY2sgbGlrZSB0aGlzIHdvdWxkIGFsc28gYmUgX3JlbGF0aXZlbHlf
IGZ1dHVyZS1wcm9vZiBpbiB0aGUgY2FzZQ0KPiB0aGF0IFg4Nl9GRUFUVVJFX1pFTiBzdG9wcyBn
ZXR0aW5nIHNldCBvbiBmdXR1cmUgQU1EIENQVXMuICBUaGF0J3MgYSBsb3QNCj4gbW9yZSBsaWtl
bHkgdGhhbiBBTUQgZ29pbmcgYW5kIHJldXNpbmcgYSA8MHhGIG1vZGVsLg0KDQpJZiB5b3UncmUg
Z29pbmcgdG8gdXNlIGEgZmFtaWx5IGNoZWNrIGluc3RlYWQgaXQgc2hvdWxkIGJlIDB4MTcgb3Ig
bmV3ZXIuDQooYy0+eDg2ID49IDB4MTcpDQoNClRoYXQgZG9lcyBtYXRjaCB3aGF0J3MgdXNlZCB0
byBzZXQgWDg2X0ZFQVRVUkVfWkVOIGF0IGxlYXN0IHRoZW4gcmlnaHQgbm93IHRvby4NCg==
