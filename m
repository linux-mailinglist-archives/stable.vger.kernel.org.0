Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C5A5E6B04
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 20:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiIVScH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 14:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIVSbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 14:31:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDB210BB3A;
        Thu, 22 Sep 2022 11:28:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElX/Boa6ZCj+rq8Q+Udq9awW7SaiypypDTxRRC9cYJ3BmK1m+0HXsMoVWkzUOF8rw14ubleOuxvJb712rmVLEQ26zCpo3HUkj4LKEQEy7oyr4cU50gzRHFETRHPH4SOOEvvbon3y8g5DWHCCd4OExfs/rBB7B8yVFLccY9c7Kd+/oG0G6UpMzfs8tMjQG+KcyVW258S0DHcAiGNWQHmqlI0ieXeHFZ2lF546KnPB+/H6/tH5hT8Dr3c/J4eMqeXzqEVDIY/hz2qQvvreehn1WMDBU5eEyYl8NUURBj2Q8KhN3Fp1ulGoYw64Mv7YPcb2jyNL/a9qaR/S99BX3qW+vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DScZeIXzc8B68zCX9dXyhS8SohM9vesdvsjInlklyP0=;
 b=c1Z3Br+gXLeMl8dFM5ISx49FY5yJE805vbzcScU5/ReJWrT3TwkZMKYCt05zy0uvQtVryqcI55Wc7jU8kZwjTMq5tPKaf0PCZvY45eYOMfT42hDrE/rlGxOaof6bFqaH+BJIw2WEyW3m9nlLosYnGQF4Om7e3gGP0s+XBqmLh5Qimx/BcAKwQMqVFoXirct9HN0l/xwal03PhDB5puNg1Aw9poJ+S/tApJIvyfVIsLzXLrnZukcJD91+eYOb2r+kqdWNPRLF8oH2yBFsQfPe83gsfcLVft1vW2tdRlHjrxjJHK/ASPvTwOs4B5JC5JHrO9RZ6UcXYdDL2rISGkfE6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DScZeIXzc8B68zCX9dXyhS8SohM9vesdvsjInlklyP0=;
 b=117THGyM1bqK9WCQXG+ijQGgaI7GoFU2I4HwVOVZzEEJLhZlZzDdH0jFBJ2e8c0kNWBVC6aRBh6uqXjwKDYK7A3wAyZFDIGNRoyNCI9Kd/pwG40fDKGvdIB90gA9umn0M4taO3kcxNriQh35UPke1cybn6XBn7mfAdxS/H+zP3I=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY5PR12MB6083.namprd12.prod.outlook.com (2603:10b6:930:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 18:28:48 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%7]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 18:28:48 +0000
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
Thread-Index: AQHYzYSfJnaVyId5REam4NmoMbIuNa3rqjGAgAACsYCAAAITAIAACtxAgAAKaICAAADq4A==
Date:   Thu, 22 Sep 2022 18:28:48 +0000
Message-ID: <MN0PR12MB6101D3B6F6FF4C5BC2208FB2E24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <MN0PR12MB610110D90985366A4B952CCCE24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <9d3d3424-a6d4-4076-87ff-a1c216de79c6@intel.com>
In-Reply-To: <9d3d3424-a6d4-4076-87ff-a1c216de79c6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-22T18:21:11Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=308b76b7-57c7-4545-ace9-a8fa0d4aa709;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-22T18:28:47Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 90f561a8-cf19-4439-a59b-9684169713e3
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|CY5PR12MB6083:EE_
x-ms-office365-filtering-correlation-id: 8cd30fcc-30d0-4daa-5867-08da9cc84a95
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nKsSsB9x787nTu6ODVjoV2FrrCzeFkdJSz0543zdL0KTDlW7OUPnBnRaHn0vvzjX34FM4QoThHQDM03O22feL9ev64JPaFhjCTptDECnSj7Ak/iHVqWLD8alQKZF3IZu/bixgwIu6CQgx7tea4frB1/VZWm1jQYfRG0OZhdvje98PdzXLnsHxAR3gnT5aCNV3FzVO4E9Uxk6yhZVjpRPYh+7Luu8+UXNWY7nsYwOdO/ShXQvHQZXEO4gfWLXDBChDK5eRJ/N5lQuCx4vemtX1pgqh5SNr22XjV6uyBSiBgO2ba+g2uiTLnw2WJuXUekEGeqZEjWrChVM7RV+uUb7RvUpIQD9Tl7ZSI5mHdXfBbqbUjHs9HjVubOz0kvs8uE1KswcbxpT8SOoVqS/tsVfpM3ivDf3nAhFy9ld5CvqWeuePXd0ns8gH4HquJITNKyEcuCotXyypHucFbbm6ibFg3Y5HIZD9J0Me7WEDixIvRCFcbf2h+XJN1TVdfzNMd2DUOzqXB3H6zkTCzwBHCKdHLQVGOOU4jKl6gqzyfgCxPCEiXJGzri8BBUHYbAcbZCqDPLYeUhScCCK+Ts/KvaLGr1bxUGkq3RIUKE0dN7xyNuVbDtsW0x1zZWi90xfeXDKX29rE2DSRq2WIACqk77/R81c89VfN+aZYxxkqhILS1m5NiKiv9EgL+G0CnW4vBPpWvubqCT1BzNKdH4oDJoZklh5MO2RbJRNgQlV7b6DZja8RzwZMHnpjZppmpvlqDUOOVo+lzXl0q0hIVFzt16jjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(26005)(55016003)(53546011)(41300700001)(6506007)(38070700005)(9686003)(7696005)(86362001)(33656002)(316002)(54906003)(4326008)(8676002)(71200400001)(64756008)(66446008)(66946007)(66556008)(66476007)(110136005)(478600001)(76116006)(122000001)(83380400001)(52536014)(8936002)(186003)(2906002)(5660300002)(7416002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlZVTDZUTTk0aGw4ZkphUUhvU3JOYmpISmR5WVRRZm9RWkpUK09jWkwvNURs?=
 =?utf-8?B?aVdNM1BkWTJpcm0veXF6WW1RcGc3QStXZzIwZ2R5eVJhcCtmblh2Nk5tYXJG?=
 =?utf-8?B?MHVXZ1kzUUFadnozRW1xUk9EelJtaGt6eVFWbDNZL25ja1FGZGRYN3d1dklL?=
 =?utf-8?B?SndxckVFU3MwS1VyVlorSWVvL1RBMHBIMmFRaXBZRzFXR2ZaRFF3c1ZFVWhD?=
 =?utf-8?B?L1JvNnA1MWhVVmJDVkRMTlN5elp4OHUzUGR5VGkwem8ycllZZ2pEb20vWHVn?=
 =?utf-8?B?RXd3MlFZUnRIbFl6TVBZdzFMaU5TdnR6c2tPeGJlbStIYUdXWEpBRi9lVHV5?=
 =?utf-8?B?MUx3VGVFYThkWVc0ZXpBMGFmNVlNdTJmNndVWUdlU1FucWFraTNiS09iNWU0?=
 =?utf-8?B?Nk1rUlpMNjg5NG5IQklLZHpqdkV6bFRHdU9wUzhiNHg1V2dsSmp2cU9jOSsz?=
 =?utf-8?B?NzI2OUJud3ltR0M0L1o2RkpqZEpxYjJ5NFZRd3pIblRyZmtpRVp4M1RZcHdK?=
 =?utf-8?B?dUhHQTVUMFFFRk83UU1WN3BPNWtSQTI1eUdhdE5QQjZVWEFSbVNvalVSbkVl?=
 =?utf-8?B?cFlNUDRHM0N4ZGYrM2lRSlZlb0tWN3JCck1OekI4ODVEdy9YUXQwd1RIZk9m?=
 =?utf-8?B?cVo4ekxpS3ZCY2tud0JsR1dSVzI1cFIySUM4Y1ZCK2hPc3RTcytTTHZCMHNL?=
 =?utf-8?B?bHRUMWJWb0doVXc2a0x2bTRMejM2M09QN0F3a2tDZS83TEx0WXFDaWF1a0Rn?=
 =?utf-8?B?S0JsM2F4RjZSMEUvZVZVWWZjbEtLWXVDSERsUFFleDlZUVFmN1gxeGl3UU5r?=
 =?utf-8?B?aGI1d2hWcStMdEduUHpqMU1tSytVcmRWcS9PV2FFYUl6OC9FY1h1ZjNnZDhY?=
 =?utf-8?B?c1h4L2FiNWxXaVFSb1RrdXkzVTRJdXgrc3poaU0zWWJSbXVPNGZucHl2d1l3?=
 =?utf-8?B?dlRpYmIxdklEQnhsYXhMa1FxNENUMWtWYUErYmxSZWNtR2J5M0ZyRGJDQVFq?=
 =?utf-8?B?K1lKcW40RUhsNzMrZXFpMXNZbC8zeVVFdjdnYTQvenQzMzZYK2txa3lya3VY?=
 =?utf-8?B?c0hXTHFIaTBSZzNQZXBid1YvdE1IbFM4c0sxUDBoM1U0MWVia0tuMVdrOWcr?=
 =?utf-8?B?dE1COGRPVDRqRE9CWG9YcmMrTXFwK1oxZVNJWHV5a2U1dDJMUURRU3RueFJP?=
 =?utf-8?B?MnkzTDZCbVVSNU1CUnRaQXRvWmNBaTRObDRWcC82dUFCeis0ZnhndnpGUVVU?=
 =?utf-8?B?VEVjdkFsS3VPbTNtM1g2bDBHYXZSbVhNZXNQOWc5VUhsRC8vMEpPWXpNcGpk?=
 =?utf-8?B?NUQ4VHR5a2IvMHlJRzlQTWFQbmxJOFBxNzhDQVlLdi9XSnBmY0ZPem1JdDds?=
 =?utf-8?B?M0VjTWVVeXRFUDRJYjBudldoT2ZpTXpjaTM2WmI5MEY1YkNHV2NQK1YzVUFn?=
 =?utf-8?B?WWx4MExBN0ZMNHBNSWpvTHdBaWF6RXJRZXErY1MwbDBjVFNwYm81MG1yTDB5?=
 =?utf-8?B?TUUrZkFyUHpEMk9hRFdxamVwZ0wwYzVSNjR2c0N4czk1eU81V2dEU044TjJ3?=
 =?utf-8?B?ZWxseXFKMXFyUFlYUUQ1Mm40bHVqakVXYjRqeFJOVUpZZ28zYktaK2pZMUo1?=
 =?utf-8?B?TWw5TWNiLy9LaW94aWxReGFKUzRyc013M0lsZlB6akc2S0ZqZThNM21CWW0r?=
 =?utf-8?B?d3l2S21aemJ0MVRmM1FCZEowRjFnVkppZUk0SEdRMUxybnVWQ0thNTdKZUxV?=
 =?utf-8?B?NFBnMlZCMU9wTVNaUFltYkkrakpjQXRuM3RTL2J0TnZKY3p6OUk3Syt6UU0x?=
 =?utf-8?B?UmFEdnQwUzlPMEV4SXlhT2lLNHZJNHhpZ1VLd1YrdEJ0cXRQVnQzeDZhMitw?=
 =?utf-8?B?OGtCbFhaV1M0UzJUU29LWTcwWVpzYk1maUs0RnZFTzFFUDdIenVvRjhlV1I4?=
 =?utf-8?B?ZDBIUXBJbm5HbzZSUVM2alpkZElhRzZCOUkveW9RWHhvZDBqVWprNndUQUNr?=
 =?utf-8?B?azhQMG4za2NlTlM0QnhZWlRTYjNGcjBSUFlPdkdwNWcvSTd5ZEtLVTU2bG1j?=
 =?utf-8?B?ZUtqL0FrNDRRdGQxZHlRT09GRmhac25uNzdUWnl6d0RYTlJPdHp6NU1BcGNX?=
 =?utf-8?Q?JYkc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd30fcc-30d0-4daa-5867-08da9cc84a95
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 18:28:48.4691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XREqY2WvYLD5smTHdbHtWpAyz1x2MUNOOYkgt+FPaCCan43ddtVQHPiER1RBuFLHjbw3BXcIhRH3+6zt6N3fdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6083
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZlIEhh
bnNlbiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgU2VwdGVtYmVy
IDIyLCAyMDIyIDEzOjE4DQo+IFRvOiBMaW1vbmNpZWxsbywgTWFyaW8gPE1hcmlvLkxpbW9uY2ll
bGxvQGFtZC5jb20+OyBOYXlhaywgSyBQcmF0ZWVrDQo+IDxLUHJhdGVlay5OYXlha0BhbWQuY29t
PjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBDYzogcmFmYWVsQGtlcm5lbC5vcmc7
IGxlbmJAa2VybmVsLm9yZzsgbGludXgtYWNwaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBw
bUB2Z2VyLmtlcm5lbC5vcmc7IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbTsgYnBAYWxpZW44
LmRlOw0KPiB0Z2x4QGxpbnV0cm9uaXguZGU7IGFuZGlAbGlzYXMuZGU7IHB1d2VuQGh5Z29uLmNu
OyBwZXRlcnpAaW5mcmFkZWFkLm9yZzsNCj4gcnVpLnpoYW5nQGludGVsLmNvbTsgZ3BpY2NvbGlA
aWdhbGlhLmNvbTsgZGFuaWVsLmxlemNhbm9AbGluYXJvLm9yZzsNCj4gTmFyYXlhbiwgQW5hbnRo
IDxBbmFudGguTmFyYXlhbkBhbWQuY29tPjsgU2hlbm95LCBHYXV0aGFtIFJhbmphbA0KPiA8Z2F1
dGhhbS5zaGVub3lAYW1kLmNvbT47IE9uZywgQ2FsdmluIDxDYWx2aW4uT25nQGFtZC5jb20+Ow0K
PiBzdGFibGVAdmdlci5rZXJuZWwub3JnOyByZWdyZXNzaW9uc0BsaXN0cy5saW51eC5kZXYNCj4g
U3ViamVjdDogUmU6IFtQQVRDSF0gQUNQSTogcHJvY2Vzc29yX2lkbGU6IFNraXAgZHVtbXkgd2Fp
dCBmb3IgcHJvY2Vzc29ycw0KPiBiYXNlZCBvbiB0aGUgWmVuIG1pY3JvYXJjaGl0ZWN0dXJlDQo+
IA0KPiBPbiA5LzIyLzIyIDEwOjQ4LCBMaW1vbmNpZWxsbywgTWFyaW8gd3JvdGU6DQo+ID4NCj4g
PiAyKSBUaGUgdGl0bGUgc2F5cyB0byBsaW1pdCBpdCB0byBvbGQgaW50ZWwgc3lzdGVtcywgYnV0
IG5vdGhpbmcgYWJvdXQgdGhpcw0KPiBhY3R1YWxseSBlbmZvcmNlcyB0aGF0Lg0KPiA+IEl0IGFj
dHVhbGx5IGlzIGxpbWl0ZWQgdG8gYWxsIEludGVsIHN5c3RlbXMsIGJ1dCBlZmZlY3RpdmVseSB3
b24ndCBiZSB1c2VkIG9uDQo+IGFueXRoaW5nIGJ1dCBuZXcNCj4gPiBvbmVzIGJlY2F1c2Ugb2Yg
aW50ZWxfaWRsZS4NCj4gPg0KPiA+IEFzIGFuIGlkZWEgZm9yICMyIHlvdSBjb3VsZCBjaGVjayBm
b3IgQ09ORklHX0lOVEVMX0lETEUgaW4gdGhlIEludGVsIGNhc2UNCj4gYW5kDQo+ID4gaWYgaXQn
cyBub3QgZGVmaW5lZCBzaG93IGEgcHJfbm90aWNlX29uY2UoKSB0eXBlIG9mIG1lc3NhZ2UgdHJ5
aW5nIHRvIHRlbGwNCj4gcGVvcGxlIHRvIHVzZQ0KPiA+IEludGVsIElkbGUgaW5zdGVhZCBmb3Ig
YmV0dGVyIHBlcmZvcm1hbmNlLg0KPiANCj4gV2hhdCBkb2VzIHRoYXQgaGF2ZSB0byBkbyB3aXRo
ICp0aGlzKiBwYXRjaCwgdGhvdWdoPw0KDQpJdCB3YXMganVzdCBhIHRob3VnaHQgdHJpZ2dlcmVk
IGJ5IHlvdXIgY29tbWl0IG1lc3NhZ2UgdGl0bGUuDQoNCj4gDQo+IElmIHlvdSd2ZSBnb3QgQ09O
RklHX0lOVEVMX0lETEUgZGlzYWJsZWQsIHlvdSdsbCBiZSBzbG93IGJlZm9yZSB0aGlzDQo+IHBh
dGNoLiAgWW91J2xsIGFsc28gYmUgc2xvdyBhZnRlciB0aGlzIHBhdGNoLiAgSXQncyBlbnRpcmVs
eSBvcnRob2dvbmFsLg0KPiANCg0KWWVhaCBpdCdzIG9ydGhvZ29uYWwsIGJ1dCB3aXRoIHRoaXMg
ZGlzY3Vzc2lvbiBoYXBwZW5pbmcgYW5kIHRoZSBjb2RlIGlzDQpjaGFuZ2luZyAvYW55d2F5LyB0
aGVuIGEgcHJfbm90aWNlX29uY2UoKSBzZWVtZWQgbGlrZSBhIG5pY2Ugd2F5IHRvDQpndWlkZSBw
ZW9wbGUgdG93YXJkcyBpbnRlbF9pZGxlIGF0IHRoZSBzYW1lIHRpbWUgc28gdGhleSBkaWRuJ3Qg
dHJpcCBpbnRvDQp0aGUgc2FtZSBwcm9ibGVtIEFNRCBzeXN0ZW1zIGRvIHRvZGF5Lg0KDQo+IEkg
Y2FuIGFkZCBhICJQcmFjdGljYWxseSIgdG8gdGhlIHN1YmplY3Qgc28gZm9sa3MgZG9uJ3QgY29u
ZnVzZSBpdCB3aXRoDQo+IHNvbWUgaGFyZCBsaW1pdCB0aGF0IGlzIGJlaW5nIGVuZm9yY2VkOg0K
PiANCj4gCUFDUEk6IHByb2Nlc3NvciBpZGxlOiBQcmFjdGljYWxseSBsaW1pdCAiRHVtbXkgd2Fp
dCIgd29ya2Fyb3VuZCB0bw0KPiBvbGQNCj4gSW50ZWwgc3lzdGVtcw0KDQpUaGF0IHdvcmtzLg0K
DQo+IA0KPiBCVFcsIGlzIHRoZXJlIHNlcmlvdXNseSBhIHN0cm9uZyB0ZWNobmljYWwgcmVhc29u
IHRoYXQgQU1EIHN5c3RlbXMgYXJlDQo+IHN0aWxsIHVzaW5nIHRoaXMgY29kZT8gIE9yIGlzIGl0
IHB1cmUgaW5lcnRpYT8NCg0KTWF5YmUgYSBiZXR0ZXIgcXVlc3Rpb24gZm9yIEFuYW50aCBhbmQg
UHJhdGVlayB0byBjb21tZW50IG9uLg0K
