Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450BD5A83DD
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiHaQ7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiHaQ6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:58:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FB0DDB41;
        Wed, 31 Aug 2022 09:58:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDlpbBJIgKhU33z/z1w21k2Sdm8Q+wFzjxia9gw0hOk7mAYpt4cN2G4f1qTpw4mZfCKMSLlbrfTx3krA+h3BU5VW/lwYV7ppZUKyhMtdLfbFxXIcusk6q9Wmm6pK/gT2y+oLp/LG2riNGLEaY2ySq3eKVZia/cmB2DQQCxXGroEKDbs+hPUP6yJZB+Vm+grYqE97DOyGBZTpxF1o0EVSO4Fl5qjpAgP7Cqpzs8y9jdcbKGU+MVfWsLv6S4pTF7kEJ/NPgEzNyVs8Ox65JWTiW1ATqjbN/7o0vfpOlc8tZ0yaYndvXAP5srKl38rb2V429X3CriIii9dsl2V1nUHHCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NxUwri2i4bBDuGP16lHt396R/bFTiwewZFeKEjOVkY=;
 b=ihDMI7zOHbJbpqscNP8t3Lz5X1iXziJM797uD4YnCCvrEELweXZqPuHWIt2KQYWAustef5FXgl55nOsOMkW1UF4obCjuWVPorzOapmwVTAR1ovdka9MeiCTyDLR7M5Mx317HSIEgaqSeI46aAtIXuN1o3Ro3SD1GgChhqAhFRz+B4SzDumeNDY18laawuoRsFH1zOrsKIgPhzWB3Rhgcy4oUBGVpK5nFX0ME5e/girAvP4zyIXfaQk1cuva3YWulcT+AKi0NOziKj/oiBTLyE72FeEDfaTdKdhIs8t2tpOJfd3sgbAWVoS4ZBlc/FLLyetK6hBP2sQILUjehSaUFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NxUwri2i4bBDuGP16lHt396R/bFTiwewZFeKEjOVkY=;
 b=cSgFs/xIhx/b/t/RQL+S4/6HvA88k1v5mH4hVHR/KeS/RZkjHpazbSo7TcawRGq2nEzpDrSgO9i7F0jopFcAw/zhXkKv/k4+G6yYNuWiiTi4Y/ZCUXQLMZP0JV+Tw/HEQWpP/wkosZoxxh69OVHrTXEneNvQ9sFsxD/QazQykWSazjrkFt25PCs8pxPKpwTFlpjvvgDTRxsN6dNZkxsBC0yqZGLmI3lqJHTyz1FWSYFDZQzuRYIUDMm3LKJ0dDCTtfwy51bNp4+f87BYg11MK170tLKXZ3kEMUFkTQXtdFqYoirY4hwkcFPoaotSHFxtlE6e3k9j0n22iczkxi71GA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 16:58:00 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c04:1bde:6484:efd2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c04:1bde:6484:efd2%4]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 16:58:00 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "guanjun@linux.alibaba.com" <guanjun@linux.alibaba.com>,
        Parav Pandit <parav@nvidia.com>,
        "gautam.dawar@xilinx.com" <gautam.dawar@xilinx.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] vduse: prevent uninitialized memory accesses
Thread-Topic: [PATCH v3] vduse: prevent uninitialized memory accesses
Thread-Index: AQHYvVFN2JZtfr6++kSU8TZ8vD51QK3JOwOA
Date:   Wed, 31 Aug 2022 16:57:59 +0000
Message-ID: <fc475f95-3523-6c03-2508-23617eb26422@nvidia.com>
References: <20220831154923.97809-1-maxime.coquelin@redhat.com>
In-Reply-To: <20220831154923.97809-1-maxime.coquelin@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdba2545-5837-43e6-7200-08da8b71f5f3
x-ms-traffictypediagnostic: SJ1PR12MB6243:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MQ8SAn1rTKQeuVMYN8gA5DipFt6IH1qSiuywHcU/tsk4bRyzm2LyaAGFtGqU+T3qoNLxpGdxiIb7IpsLedYWE2lRaHmshaMPvlP3+cCsjlsgLTB7NGeldmDRv+af19prGVE6V0chzoMEMxsfAi6SUg1N3G93i3MzB5CDhPj8V+ahjtWcpTvj1emPac0d4eHl4+82oP6I7gMaXXNWBdMWYC/E+hFpSDa/tIuCPiohqp2bVGK/OP7OWx+GrtzNYwfq8+Dbe+/gxVceT82z4jOr5k+U7bnvdnKZcZU6yfsB+AIqEjoytHx+wwqAaomF/eJsgwDBfGcAHP+fvA+PjCfwEroabB/niABcWnHqMUvtbOdkZFcsLzmM4P9qHkY7UxKRJnEZSDntjXzM5f8aKydke1uM7YLy7BYAiu3U++rLMbApax0EG41SPZbC9q2zy63SbOzjNAoTmXr4iJUgl898AjcpMapi4iCH53htVZrGGLFHJx72dhq1klaMyUCsAYPBh30k7i2QEBYQYUnrrdlZAsXBCU54WHtubC3TK80HDnsabqAxHIZUVDLoDeQHBMgBRLpgNkIaE9NLcnBjz2s7gVLiJCKAIiVVsa1ArLEXOcoY/SW+axu0BPEUvau1r18J64Qc/DJSX4RH00SPIUckud9EcNdkrVVWeBfh0Ny7jGEU1H8pLhsV662nTjS7lPmumNdbH+nCoJYd/efk7OGbFQMN5D0bGPo1cRi/trguKTMEpRB+fl8zjcR3acF3txldfqCnJR1/njoSHBDuewfkgur0vtt/td7WMcqher7n2uuSHKZgGwCyyq662Hf5dZxRHnyL9vvUIH1ovDI85/5k1kXEMnU9UTlc/LdqB+KvvE4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(2906002)(921005)(31686004)(36756003)(4744005)(5660300002)(8936002)(7416002)(186003)(2616005)(38070700005)(8676002)(64756008)(66476007)(76116006)(66556008)(4326008)(91956017)(66446008)(66946007)(110136005)(54906003)(6486002)(41300700001)(316002)(53546011)(6512007)(6506007)(122000001)(38100700002)(71200400001)(31696002)(478600001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0toK1doUElqOUlBZ1lHc2tHam5Sc0FmcmtwcGhkODl1cm91ZEtrUjdySjlj?=
 =?utf-8?B?NllvZVczWTEzUzJjbHhuMnFOampFdTdaeWhmM1BhM040SW9PeU9uRkk5R1hS?=
 =?utf-8?B?NXFRUkloeTY5S0ltZDdQTlQvRDFxaCtyQ01iRGVEVzR5ZmpNdUxYNG5CdzRB?=
 =?utf-8?B?WjcyR01EcGdCL2t1WENJT1QySzBLc1VYcWN6dExEalNGOGhqNEkwaC8xdTgz?=
 =?utf-8?B?WXdzaW9ZcFExcDJUZFQ4andPQ25wdDF1OGFHUUtDYll6dDdnbmtubHdwL3hI?=
 =?utf-8?B?eFZGUnhLVXZPcGZsSkxnTHhRUmtqdkJYRjhyUDJpVVpmV2l5N1RUOXdmTTlj?=
 =?utf-8?B?OXZhazJNRXRyK1pOMEpGcGd3dnFlakQxbm5rc083LzVYVTRjQS9GdDFrZ0NQ?=
 =?utf-8?B?VytMdkJoMy8vZEp5WFp4a0R1OVl4YWw5dWVLeDhiRHZWTXJZRkszNXhSaW9B?=
 =?utf-8?B?WTRQRUJaQk5zSmpNL3R2OEZBTzlkUHJ6R1Z1YnAxek82d0ppMGFqSExjbEJj?=
 =?utf-8?B?cC9QQythNUs2VnQzY3dyYXVYNXk1OGxVRUs1NUpINmVKaE1UdHBGQjFSMGlt?=
 =?utf-8?B?RHpSN2xvb2JpcG5ZaUxKN1d6TFhGWnI4MmFkQlJKRUFrbXYzZGViUmdRWi9X?=
 =?utf-8?B?c3lGQ1V6bG93QzJWNnJhc3VVeFMwWWo5MXBqbVU4VU84RUJxRmNlMm1FcFd3?=
 =?utf-8?B?RHliVEF5bXVZa2ZwZ1A3V1ZqY2xxcWRBa3J4OTNZMjdYYnZucmhxMStMdGtJ?=
 =?utf-8?B?djB5dHhmNUFWQlZ2K3N6VVMxcFMvSjk4M2hOemFPaVlGcjhCc3EyRTkvNXE3?=
 =?utf-8?B?dnd4dkhXMm1sMU1tWjdLcitSU3cwa0N1YktBNmF0bmpVa3RaVWJVc3REL050?=
 =?utf-8?B?di84MmNSY2hqWUpqVTVFVmpmVlJzWkRSa3BoVTh4RmRWOW5iZ01yY1dING5y?=
 =?utf-8?B?SGd1UTlWd3NucjlPcnVEZVRnVnJzcENPeDhCQWdMQVNiUjM3RDE1RlZxbmFU?=
 =?utf-8?B?Vlh4U1ZRcDFkZm16bW9ZeFdBYyt4ckhRQ0F3NW9XMDkwR0FIdUI4bWFEMkdZ?=
 =?utf-8?B?OTFTaUhMTHRPQVB5Nlc3Z1ZUR3dIenZnZHhZdGdLY2VlRmYwVitGQ3pmMG9Y?=
 =?utf-8?B?NVFaQlhPYWtFNml1KzdYRVJYVEl4eG4rdmowVVp4V2dHai85QmhiRzVuRVJv?=
 =?utf-8?B?dVIzMHc3OXh3Uy93RE12Umt1R05BVHJhemRvbk5PTWhKYUg1UExKS2J6VzRJ?=
 =?utf-8?B?emRFblZ0eWdwNURkOGdwajd4YVk5Rm9SWmdOUGdWdXVTdGNEeTdLTklNdU5B?=
 =?utf-8?B?UjBPY2pMSWVKT2Yxd2FvaHhVc0czekdwT2V5NTA0VVFFVzBYc2dXd1BsbVZO?=
 =?utf-8?B?Z3ZOMGQyRVNudENKN1VubGRVdTNnUmRWOTNRbDhyYkpQbmcvVVdENDdkZzBL?=
 =?utf-8?B?MkY0WFVTS2wza0gvbTRjbFFQZDNyYStPTTFDTXFNVklyUm1UYXl2TWlJQ3Y1?=
 =?utf-8?B?Y2lCQnVRNnMrdUxYeGJjeHlkdEFnaWgyRktPVHlQbmdQTGFDNXZiM3cwVnlY?=
 =?utf-8?B?MHl2aHdTQjgyVnpYZy9IOTVqVUxzZFlya2dzS2RSNk1WU3FaZ1NENlJoOWkr?=
 =?utf-8?B?ZVdhVkd1Q2RXOVVJajBWdlcxR0Z2S09HVnFtQURNNE5aZVV5M1ZGSmJKSFFR?=
 =?utf-8?B?TnZCTW95Y01COGFrWFpUZDRwNTlKZmNjUXRaSFArNzFBSjNpa0xtclVMSW9i?=
 =?utf-8?B?QW9qRjdSUHBiRGFXMkF5VVJjR2lCUjJlbzhNS3FkS2M4Vmt5ZTRPTzZldnM1?=
 =?utf-8?B?SDdUNnJQVVlmU290d29mUm5FZ0pJRVpVcHlNNGN3QWhQZXBTcVVBSTBRZEtr?=
 =?utf-8?B?RHFBZjg3QzhIckM3N0U0YzRxWjlydlhpVUc3OUZZZG9CU1hmLzJnNHRZbDNR?=
 =?utf-8?B?MWFGcXh3Z3h3Q2V3ZXBjUXZ1Nzl6QzloekdXK0dQbWF2b1F0WENXZ1I2NE1n?=
 =?utf-8?B?aU0xcTZOSWt2VXFnejBpRXQ4ck1YbmdTUGlnVVdNb0g3dnJ3VHR4UWsxbSs0?=
 =?utf-8?B?UGZGUW4zUnhyYUhTcGVqTHhydU9iZ05INVlYUmpva0RZWFI4RVFGUkZMMlZD?=
 =?utf-8?B?WnJ6Wk1kK21meCt0Tm15WHFGYVJOYUozWjlhNVdoWFdUZ0QzTVJPREY4SHAw?=
 =?utf-8?B?MUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE11E11D5034684589AFE2F55248E47D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdba2545-5837-43e6-7200-08da8b71f5f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 16:57:59.9659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pm1PWUHRPJYk7p3yIZvz8qXMlcMclJGG9LihcgiXD6s86UDRnQKvLp9OoF708tENtwUys979KGSDmQsPOudCRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gOC8zMS8yMiAwODo0OSwgTWF4aW1lIENvcXVlbGluIHdyb3RlOg0KPiBJZiB0aGUgVkRVU0Ug
YXBwbGljYXRpb24gcHJvdmlkZXMgYSBzbWFsbGVyIGNvbmZpZyBzcGFjZQ0KPiB0aGFuIHRoZSBk
cml2ZXIgZXhwZWN0cywgdGhlIGRyaXZlciBtYXkgdXNlIHVuaW5pdGlhbGl6ZWQNCj4gbWVtb3J5
IGZyb20gdGhlIHN0YWNrLg0KPiANCj4gVGhpcyBwYXRjaCBwcmV2ZW50cyBpdCBieSBpbml0aWFs
aXppbmcgdGhlIGJ1ZmZlciBwYXNzZWQgYnkNCj4gdGhlIGRyaXZlciB0byBzdG9yZSB0aGUgY29u
ZmlnIHZhbHVlLg0KPiANCj4gVGhpcyBmaXggYWRkcmVzc2VzIENWRS0yMDIyLTIzMDguDQo+IA0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY1LjE1Kw0KPiBGaXhlczogYzhhNjE1M2I2
YzU5ICgidmR1c2U6IEludHJvZHVjZSBWRFVTRSAtIHZEUEEgRGV2aWNlIGluIFVzZXJzcGFjZSIp
DQo+IFJldmlld2VkLWJ5OiBYaWUgWW9uZ2ppIDx4aWV5b25namlAYnl0ZWRhbmNlLmNvbT4NCj4g
QWNrZWQtYnk6IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IE1heGltZSBDb3F1ZWxpbiA8bWF4aW1lLmNvcXVlbGluQHJlZGhhdC5jb20+DQo+IC0tLQ0K
DQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZp
ZGlhLmNvbT4NCg==
