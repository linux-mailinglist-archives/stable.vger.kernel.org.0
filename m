Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075CE50E8A2
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiDYSth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 14:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbiDYStf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 14:49:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4CF6E8D6;
        Mon, 25 Apr 2022 11:46:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gR8FcobZH6jXerYf1ug8LOKGXuAieTSknmxmSoM+RydVfIGzGZqEKUb9PNVEWmS/KNl3q/vFnJmWQU9Q+tPK1XPWBaxbS7WrA8sFr69uIQm7BzhPNgt4K2u/Vdds7Q+pv9iI2Ca0hzTIJxaHynA9ypWej4SydOIELTA30lpwQuObNFe0vYWfY1d3X3OiRxVV5l2sjES+/3MrbmkqUEriXmNvD6snDb5aK0jUyA2al90jxYqifWcOF9F8hid9OIGUT9NpLu0++tjWu8mLV01Zi8kxppvGbM8OhQMHgLHs1MEN9mYqvUw2q+eFdLZ1fEcO/wOO4LHG0WQTf21woVx5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rm5L4g8IlCFoBjh6eFOIx5f4WQ5qwvd1qjrUnf0JKII=;
 b=KR7n9oKutCGgkwG2pFfADO/wDCzLIVt2DuUFJnUNGr0WGdGqKEa+UmpDGDUUgsQpwXoAbBt9dboD9RKUqcSAlNDshMwHl8ti8cI/A2GuDRE3cgZJ4584JwG1hLg4G8hbrACZ9tcFMTRN56sbNMrsOkZDqZb9U1UW878rS3ayS240BjadX6ACripK/KksZ+HnI3dDNqBtTKVnZdXFTzTt4ojL6Y3qYbb9vR4LZxx9PkdSbIYcWrFshRnTzmWTbT6ndqylZ1CvqEfs8qLgpckpaICDRs/TmCFsWtUOg54mJf0PXnB9xM26pRI5EaCaD8M9XXtyNd4LlgtPiO6iFKbR5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rm5L4g8IlCFoBjh6eFOIx5f4WQ5qwvd1qjrUnf0JKII=;
 b=aV4O91qviduxJ78QazaZ2M8B4R6Dq18ZR49piPYK3mLVuqGjoTveUOMbhGArN5XeL84rL70Y2R5vZVQ05wbX6VlueAovbuP63hv+NFOHV7qH3pO+4rx1CEmuPJVNs2jawS3EE0HiyeTJ+0TFTYICSTvuJagom3eiI/ni/Sui7Is=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DS7PR12MB5789.namprd12.prod.outlook.com (2603:10b6:8:74::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Mon, 25 Apr
 2022 18:46:28 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%8]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 18:46:28 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        "Gong, Richard" <Richard.Gong@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/1] Fix regression in 5.18 for GPIO
Thread-Topic: [PATCH v2 0/1] Fix regression in 5.18 for GPIO
Thread-Index: AQHYVksJjpZ/G9xTMkeRgcd0PxCHBK0A+34AgAAAYACAAABrMA==
Date:   Mon, 25 Apr 2022 18:46:28 +0000
Message-ID: <BL1PR12MB515731C438920F0228B7FD8BE2F89@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220422131452.20757-1-mario.limonciello@amd.com>
 <CAMRc=Mf7FVN4QeAEdap_JzKmTy6i0A=BbcCZtCCQhzocg4PDfg@mail.gmail.com>
 <CAMRc=MeOvvBVVsAwscq2tsmoS5ze87kneaeuHOXci7k32sDt8g@mail.gmail.com>
In-Reply-To: <CAMRc=MeOvvBVVsAwscq2tsmoS5ze87kneaeuHOXci7k32sDt8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-25T18:44:05Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=27cacff9-7e83-4cf6-878b-6c1947c6e269;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-25T18:46:26Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: c0ae5a59-bdf5-43ac-8292-d890cc5855f3
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1afaca80-45d4-439e-d1d3-08da26ebe831
x-ms-traffictypediagnostic: DS7PR12MB5789:EE_
x-microsoft-antispam-prvs: <DS7PR12MB5789EE494D282C2783CA434AE2F89@DS7PR12MB5789.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AAUQGYYjGCSY+6PxSy6D8zbYXKcFpd2c9GXJDwd8p5Qk0SGc4jRc9MZH2OvNLtunddwAP2nBwSdDlwPCeIc8qmBNMNH8wo7HQ93M3iuzEZ/c1Rjp6ueauvCjspcwzNwTC5WhKJhlTFsD0MqP+wWGXwgkUKVO/8EYFNWTPUiYa/uFOTNlqPakeOMOvu3OCuvp622iOCMYWasmIICDj0xjwq9Rukl973HdpE1kTFFf5lonF0RcQL/RPj4wezTFUIoRXh/8m5P4UhfuNWRwMIzOmx7LWboirECplTim+z49zkuQMmSvUlRqghoDUK/xEXfzwCXtydrBI8j3Z0bJkcnAOxE9+dUN2BdfLlWRpgr1U+a1/gyWgb2xN2htkPeqwIhbGU5Dg07dwxcBjGI89HJWZkdd9+AJrlltE0mc1K5iYaYBbRwahcJ5QYZ0F/b+UogNmupIV6K81eF7KXh+nZDagcXfuSqlJW+zSSE2G+/OnkgSLwzNYoKOPztUaf9Oi5jTxvLv54wAYYS9Yx/fZECCWJGJZlufIIAZCUp67AHj5jAQ2ykNvhZHIiJhbIebGzjgKRZsPY8lLejAz/p7J7aXRYfN7xv3NQXf7TD7CCzIG8JuK1EQAguTchXAC79caPS/5W0foQ3npFiGxFDaH/iZvbY1U4DQdeUgGgizbKUS8mduiUP5bgdDhk2bUBxi6vGJOwPShtDw8bqn+z9+nPBaAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(186003)(9686003)(38100700002)(66446008)(83380400001)(64756008)(66476007)(7416002)(5660300002)(52536014)(122000001)(8936002)(38070700005)(76116006)(4326008)(2906002)(8676002)(66946007)(66556008)(6506007)(71200400001)(53546011)(33656002)(7696005)(508600001)(6916009)(316002)(54906003)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rno1ZmJUaVY4NnlUWEVoTDMzMWVFZDR6a3BjaTFMWU84YTBPZ2dhNGN1M01G?=
 =?utf-8?B?YjN6M1FvYjIrTVd5TzFRcVhvN0h2YnA4bG5jSmlJbGt2aFJyT1B5a0ZtYXJz?=
 =?utf-8?B?MExBMGtiRkdDVkF0dFlLdzYvdjFkWTN4V0MwZE1adHo2cFhSNnliVU5tamND?=
 =?utf-8?B?cURMMHZNV2RDYW8wVDJZQnFzQjQ4NytOMHJ5ekRrRjBXR0ZucnVoRi90SURs?=
 =?utf-8?B?M3ZyNjViczJ1ZzhhWHBxL3VxYVNqS3VyMDhUN2Jqd3ppdXVsSERkTHJoK2Ey?=
 =?utf-8?B?ODBRTDZmb0FCRDJ4U1ZlenByR0RDQVIycEVVeFBMTlFIMlFOM2Q0VGJjemJV?=
 =?utf-8?B?cGllSkI0bHhxcnlaVjZoZzB3WWgxNzJSSVcremtBY00yYnVVZEVhc1h6UEN0?=
 =?utf-8?B?eEprUGFiMi9TQVk1aHNFZUFZbC9WSU5ydyszc0YyZlNycXNoZHdMMW5QQnNP?=
 =?utf-8?B?UlNYZ3lPQS93a01QTVRIeGppZkdpcHEzTnMraWhoZlltZVZlaWkxbWJLMkMz?=
 =?utf-8?B?S0tGdENxeVNHUGtHUXNVeDJvNk5Idm1GOXhZUkpUQW1SUVp0N3prd2tuaXJi?=
 =?utf-8?B?MG9RSlhvcWxsV2l4ZElpWjlvNlpvN3dkQ2pSZHFvd1pucUlVQXBwaXA5ZW5Q?=
 =?utf-8?B?MmwzZ3hjVzdkNlRXK2FTay85T3ZxVzMzMFg3QmsxRHZkZ3c1dUxTZ082VDZR?=
 =?utf-8?B?d2NObVRvSysrczdSWWU3MGt3UTJpSFBXUW9UTGN6RTdFd0tBR0dZak5paWhw?=
 =?utf-8?B?TW5xY0dLdk5GNCs3cEZ1OFpzTCt4dWFVRXRmampXSFFMSDR1NUtPRVRIS1lK?=
 =?utf-8?B?ZlZuU1Jtd3p6cS81VG5xTDdETmZydGdKUHVSK3h0UWF1c0tXR0xyN3FZUUxV?=
 =?utf-8?B?RURuM2VrN3RnK0FhVmw1di9XRzRwR3VEM0R1S2E4cjZCRnJCdGZGbWUwWEF6?=
 =?utf-8?B?Lzd1dTNudGV6cWNIZEt6aWYxVDNkdjI0YnhhRktwdDNtWERGcW1HZnNUWFlE?=
 =?utf-8?B?Ulh6dWtoMFBob2VkQlgrZWJKUGJLWDFiampwMDhNdE4vKytsRnU4Q3lUM1g1?=
 =?utf-8?B?QkZXZnpuNWI4Z2ZXaWszWm1QbGxWOGZDNm1XL2EzSmhZZjhObytDdWJKbExC?=
 =?utf-8?B?ZktBOUIrNnVvNmhvSXNMc2VlNko1UzdMODNqOXJTRmNaZTlsZVl0OWRpSWpE?=
 =?utf-8?B?NlFZU1R0akF4MU9LMXlNdGxBaDNsNnBCUUlFVVROSXlJU3o3L3hKemQ4ekc3?=
 =?utf-8?B?MWNpWkZvYVNqcFE5ZEY0NkpBc1F3bFVOUkVjQXVFZlYzTm84RnB2SHRHMmlI?=
 =?utf-8?B?UTBGYXpJa2oxZEZNZm9RMWNOc042WUpHUld5ZVRXQ0xxQ3gwY1o1SmNxUGtp?=
 =?utf-8?B?Y2diWW5sU0k1Q0V4a1I0Z0lnVDVucmZDeC9vWS84cG1tblk3Y2tYK0xIdC93?=
 =?utf-8?B?MnROMGhCMitxTXdBMDR0U1NwNmtDTUhDYlRnZFdxNHI5Z0oxZlo3M3FETWRU?=
 =?utf-8?B?dFVxRlZ1bjgzU20vSkxJVXhNaXhZRVRoWENBOS9oNnpOVFMwWUo1UWx1Y0RF?=
 =?utf-8?B?b1N0bnNUMHNZYXdFRnJBblhtQVdLZW5vUUM2SEp4ZGl0REc2bVNIN1ByRGlX?=
 =?utf-8?B?VmQxakN4bjdHMjdWTzc1czlPYlg4ZzRVL1lsTzdWNUFQaEpYaHY1MSt3S1Zm?=
 =?utf-8?B?RmNoeW9qbDlmSnhkelcvRVNoTU9UY2k4RjVabHZNczJKUVdBcjdaWCtPRVJh?=
 =?utf-8?B?cDRnbmw3KzZYNGppd1h1L0R1SERtZ3oxcDhlUVp0TVh0Z2lDVmVUOEZkOXpE?=
 =?utf-8?B?dXdQRm9HYnVTd080NFZpSjlHb0JGZHlCMHVpOWpwalZBOGJsUE56dkFzdlQ3?=
 =?utf-8?B?THNTc2F0MDhzajNUS2lDSHJkQzc3ckxzRmVuS1BEQkpvK2kwZ2pTNndPVito?=
 =?utf-8?B?elZvYzhVSE1wSWZJL1VQR08yZStYMXhZWmJ5bWxHVkpYZm0yNkhRclh6cHAx?=
 =?utf-8?B?S3RGb0dONkUvN2VEYktoQWVRalFyeE5NMEJZOUo2UE5La3lZWWEyemFYR3BM?=
 =?utf-8?B?b01YQzJGeXlodFhaOVo4UzdLdGhKYTU0ZnJlOHVsSmpDTWtldHpVVDdRN1pt?=
 =?utf-8?B?QzdZTFRWWHZUMlF5WnAzK25UeGdweUNib0x3eHJkdGQwR0lUdE9BckZQMG5E?=
 =?utf-8?B?WlkybUwvY2tEQVhFUVlndXNIU2ozQjBod1RtbWRoQzlQQ1lFMTdpc0dyUjBH?=
 =?utf-8?B?L0laOVg5Ymw3SU90dHJMbmVacE1lY3pwVmdWeUFxUW50L0hSK3AxcERaaWVK?=
 =?utf-8?B?YjRBMnJrQ3ZiVFRBS1dlYldIRHVBS3pnM0NzK0lXbGdwb2R4Tit3b3NxL2Y1?=
 =?utf-8?Q?M1D4/ypqUKtXkCBOHyLD0DFmzyRh+rWJQ+v7S?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afaca80-45d4-439e-d1d3-08da26ebe831
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 18:46:28.0939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTbIjJIrA0HS7WDIx9Q52awff2owrPf9S4wHEgjtkt/7KaYkfvSl9JMvaAeTJPoPytI+Db4Qlz+SXQPXbbqkFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFy
dG9zeiBHb2xhc3pld3NraSA8YnJnbEBiZ2Rldi5wbD4NCj4gU2VudDogTW9uZGF5LCBBcHJpbCAy
NSwgMjAyMiAxMzo0Mw0KPiBUbzogTGltb25jaWVsbG8sIE1hcmlvIDxNYXJpby5MaW1vbmNpZWxs
b0BhbWQuY29tPg0KPiBDYzogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRp
b24ub3JnPjsgTmF0aWthciwgQmFzYXZhcmFqDQo+IDxCYXNhdmFyYWouTmF0aWthckBhbWQuY29t
PjsgR29uZywgUmljaGFyZCA8UmljaGFyZC5Hb25nQGFtZC5jb20+Ow0KPiByZWdyZXNzaW9uc0Bs
aXN0cy5saW51eC5kZXY7IFRob3JzdGVuIExlZW1odWlzDQo+IDxyZWdyZXNzaW9uc0BsZWVtaHVp
cy5pbmZvPjsgR3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Ow0KPiBzdGFibGUg
PHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+OyBMaW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQGxp
bmFyby5vcmc+Ow0KPiBTaHJlZXlhIFBhdGVsIDxzaHJlZXlhLnBhdGVsQGNvbGxhYm9yYS5jb20+
OyBBbmR5IFNoZXZjaGVua28NCj4gPGFuZHkuc2hldmNoZW5rb0BnbWFpbC5jb20+OyBvcGVuIGxp
c3Q6R1BJTyBTVUJTWVNURU0gPGxpbnV4LQ0KPiBncGlvQHZnZXIua2VybmVsLm9yZz47IG9wZW4g
bGlzdCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SCB2MiAwLzFdIEZpeCByZWdyZXNzaW9uIGluIDUuMTggZm9yIEdQSU8NCj4gDQo+IE9uIE1vbiwg
QXByIDI1LCAyMDIyIGF0IDg6NDEgUE0gQmFydG9zeiBHb2xhc3pld3NraSA8YnJnbEBiZ2Rldi5w
bD4NCj4gd3JvdGU6DQo+ID4NCj4gPiBPbiBGcmksIEFwciAyMiwgMjAyMiBhdCAzOjE1IFBNIE1h
cmlvIExpbW9uY2llbGxvDQo+ID4gPG1hcmlvLmxpbW9uY2llbGxvQGFtZC5jb20+IHdyb3RlOg0K
PiA+ID4NCj4gPiA+IExpbnVzLA0KPiA+ID4NCj4gPiA+IFRoaXMgcGF0Y2ggaXMgYmVpbmcgc2Vu
dCBkaXJlY3RseSB0byB5b3UgYmVjYXVzZSB0aGVyZSBoYXMgYmVlbg0KPiA+ID4gYSByZWdyZXNz
aW9uIGluIDUuMTggdGhhdCBJIGlkZW50aWZpZWQgYW5kIHNlbnQgYSBmaXggdXAgdGhhdCBoYXMg
YmVlbg0KPiA+ID4gcmV2aWV3ZWQvdGVzdGVkL2Fja2VkIGZvciBuZWFybHkgYSB3ZWVrIGJ1dCB0
aGUgY3VycmVudCBzdWJzeXN0ZW0NCj4gPiA+IG1haW50YWluZXIgKEJhcnRvc3opIGhhc24ndCBw
aWNrZWQgaXQgdXAgdG8gc2VuZCB0byB5b3UuDQo+ID4gPg0KPiA+DQo+ID4gSGkgTWFyaW8hDQo+
ID4NCj4gPiBJIGRvbid0IGhhdmUgYW55IHByZXZpb3VzIHN1Ym1pc3Npb24gaW4gbXkgaW5ib3gu
IEFyZSB5b3Ugc3VyZSB0byBoYXZlDQo+ID4gdXNlZCBteSBjdXJyZW50IGFkZHJlc3MgKGJyZ2xA
YmdkZXYucGwpPw0KPiA+DQo+IA0KPiBOZXZlcm1pbmQsIGZvdW5kIGl0IGluIHNwYW0uIFNvcnJ5
LCB0aGlzIHNvbWV0aW1lcyBoYXBwZW5zIGluIGdtYWlsLg0KDQpPSyBnbGFkIHlvdSBmb3VuZCBp
dC4NCg0KPiANCj4gQW55d2F5IC0gaXQncyBvbmx5ICBiZWVuIDMgZGF5cyBhbmQgSSd2ZSBiZWVu
IHRyYXZlbGxpbmcuIFNvbWV0aW1lcw0KPiByZXZpZXdzIHRha2UgYSBjb3VwbGUgZGF5cy4NCg0K
SWYgaXQgd2FzIGp1c3QgaW4gdGhlIG5vcm1hbCBkZXZlbG9wbWVudCByZWxlYXNlIGluIGFuIFJD
IEknZCBhZ3JlZSB0aGVyZSB3YXNuJ3QNCmEgbG90IG9mIHVyZ2VuY3ksIGJ1dCBzdGFibGUgcGlj
a2VkIGl0IHVwIGFuZCBjYXVzZWQgc2V2ZXJlIHJlZ3Jlc3Npb25zLiAgVGhlcmUNCndhc24ndCBh
biBvYnZpb3VzIHdpbGxpbmduZXNzIHRvIHJldmVydCB0aGUgcHJvYmxlbWF0aWMgY29tbWl0IGlu
IHN0YWJsZSBpcyB3aHkNClRob3JzdGVuIHdhcyBtYWtpbmcgbm9pc2UgYWJvdXQgaXQgYW5kIHN1
Z2dlc3RlZCBtZSB0byBzZW5kIGl0IGRpcmVjdGx5IHRvIExpbnVzLg0KDQpBbnl3YXkgLSBJJ20g
Z2xhZCBpdCdzIHNvcnRlZCBub3cuDQoNCj4gDQo+IEJhcnQNCj4gDQo+ID4gQmFydA0KPiA+DQo+
ID4gPiBJdCdzIGEgc2V2ZXJlIHByb2JsZW07IGFueW9uZSB3aG8gaGl0cyBpdDoNCj4gPiA+IDEp
IFBvd2VyIGJ1dHRvbiBkb2Vzbid0IHdvcmsgYW55bW9yZQ0KPiA+ID4gMikgQ2FuJ3QgcmVzdW1l
IHRoZWlyIGxhcHRvcCBmcm9tIFMzIG9yIHMyaWRsZQ0KPiA+ID4NCj4gPiA+IEJlY2F1c2UgdGhl
IG9yaWdpbmFsIHBhdGNoIHdhcyBjYyBzdGFibGVALCBpdCBsYW5kZWQgaW4gc3RhYmxlIHJlbGVh
c2VzDQo+ID4gPiBhbmQgaGFzIGJlZW4gYnJlYWtpbmcgcGVvcGxlIGxlZnQgYW5kIHJpZ2h0IGFz
IGRpc3Ryb3MgdHJhY2sgdGhlIHN0YWJsZQ0KPiA+ID4gY2hhbm5lbHMuICBUaGUgcGF0Y2ggaXMg
d2VsbCB0ZXN0ZWQuIFdvdWxkIHlvdSBwbGVhc2UgY29uc2lkZXIgdG8gcGljaw0KPiA+ID4gdGhp
cyB1cCBkaXJlY3RseSB0byBmaXggdGhhdCByZWdyZXNzaW9uPw0KPiA+ID4NCj4gPiA+IFRoYW5r
cywNCj4gPiA+DQo+ID4gPiBNYXJpbyBMaW1vbmNpZWxsbyAoMSk6DQo+ID4gPiAgIGdwaW86IFJl
cXVlc3QgaW50ZXJydXB0cyBhZnRlciBJUlEgaXMgaW5pdGlhbGl6ZWQNCj4gPiA+DQo+ID4gPiAg
ZHJpdmVycy9ncGlvL2dwaW9saWIuYyB8IDQgKystLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gLS0NCj4gPiA+IDIu
MzQuMQ0KPiA+ID4NCg==
