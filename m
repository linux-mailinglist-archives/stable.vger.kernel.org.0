Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C30747B9A7
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 06:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhLUFqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 00:46:21 -0500
Received: from mail-bn8nam08lp2049.outbound.protection.outlook.com ([104.47.74.49]:6125
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229964AbhLUFqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 00:46:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBTA34aKq7bfJVPXyZeBtK/VHDrxhPN/LA2yjWknjdFqDZuul8YZcdSvv1n6ElPJudy/U8zgNFPUq0+xVG2GyEXLsdV9QZ48pJQjk/HsNgsy5PfHRSCYXcX2lSe3PZgGBZrkvmPkGrseX/KpUxEQvWS54BoMTW0ZxwWLH2VKuU8sZCk2M26HVLFBsiWPpCvPj81g3dsFTvxgvzaaDosUFV3wvR6WqGQLf7P/PZ8wzQu+qpgrMxR/TSIuFw9xWDOF0Lcs0Piy8rTMWuw7UpoBsVMJM+fxvOVt8Cfx+teI5EP2rqiPkxHvHO6RWmptChQ8VR5D8lDMPwoT7De2ur5uFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqFaYVmqXM7syhOW0Lfp9/EnvqZKg7dMIOvPDxrwAz4=;
 b=Qp/hj6Ghvf2Q/19mjfcd1bUfn8CF8FR3LrjBb/n6rr5e2vDiqNkavTBLV1mvOxQK+dgCyzw2Zd4kUk4dM4q230JX+x07d3KB8h5j/6czVCqnvxyrlhhi7zjnjSNSjNEa73VSyURfVb+WJlc2IpEMQADHbYVf5ZwbWrw4xIK9wJ12sDx5wX7Ilfla1lFOAvVoQgV+9z2+Cfe7TBtiSHkNMaZiDVeIlx6ScKmMbCUVEOlqnF5xLz6nDt6BYDydpS/9APDNVWFRf/mmgCKm41ObUlbI+CmT145l7Ahr7jygTx2FMeKbFFlTHDgh7ax6m5NB3bhMmTinsdYsmbujRq3w+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqFaYVmqXM7syhOW0Lfp9/EnvqZKg7dMIOvPDxrwAz4=;
 b=CxsgVa+7o6HBupxps6GP6fXr3+7lO9sqLV0SYVAsEThbFnzRIGbknB7nCHsOd6rdS/ejcU1iUu2mM4RYlT6mQPMpPMsm0luFXL3t/aH+zQQp29gBv4jJgSSEspiIfCwUmqNbTivWFYVemFKEOOrFBKdq+mBO9HNmcmLYVtYOjLk=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by BL0PR05MB4835.namprd05.prod.outlook.com (2603:10b6:208:56::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Tue, 21 Dec
 2021 05:46:17 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%4]) with mapi id 15.20.4823.014; Tue, 21 Dec 2021
 05:46:16 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIABcMIAgAEjF4CAAGztgIAAC/IAgAAHxwCAAAeTgIAAM82AgABcswCAAO2MgIALPnkAgAVLzQA=
Date:   Tue, 21 Dec 2021 05:46:16 +0000
Message-ID: <FD8165E2-E17E-458E-B4EE-8C4DB21BA3B6@vmware.com>
References: <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
 <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
 <YbMZsczMGpChaWz0@dhcp22.suse.cz> <YbyIVPAc2A2sWO8/@dhcp22.suse.cz>
In-Reply-To: <YbyIVPAc2A2sWO8/@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.55.21111400
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 358aadce-fcfc-4942-ac69-08d9c44534e5
x-ms-traffictypediagnostic: BL0PR05MB4835:EE_
x-microsoft-antispam-prvs: <BL0PR05MB4835E6D585FBD980A541EE15D57C9@BL0PR05MB4835.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rSiGe/JxSN0cwTr8dvA2/R1FiO7HxUjECBGrrIpckahNlny59QTWG828aWtxupwLRPOwOi0doi09lDzVCY9bakf4p9UCqSS2Z2R6AVVxN/+f2K30TUUxiDsXnBiLxtUDkW2txDo+todzUPZyKtIgT026EtioYhHKVMg7oKbNKCcYoM33rGEOBtIJz81l40FbecSbAhpw3bUyIoBSad8ccV4S7IEVNKKCbAR4ACl5dUMFANOdnad1LXgano6TMSjJkw8ol+R8Z/5yplH7g0ND6Ju0e+P70rkgBQRkb7fpZzoDL3TqM63RdBSD6DgN80cP8Vx7EWgEWb3j7Wu4WchvHps3ktgZ6qFZJTBXH/cX5zFg/w/dRv5Et3K0TA7rlqKCyqCG9mJQs3gIUjVck2/5NK3vZkhICE9uiXDzSIFU4npV57MDD6t/wCzuw+RZbnmLv0YMXOTwV5Ezv9boLitNIIirVZbin5pGFK3KQEFFHGirX+U1/7qG34/IighIzO4ZOxlFP7/SbLn3d1Rs5z43GPYPLEFPRm7Fa7LMN5YgnTSLlLg8z2dQcOZ2wSoM2CmAVL2OIf5m3gjvl4Ng2iSpCSM62Uj7/5cxBxfbO3g5Vy29l8O6o79x0+V0q7eSoQwsCLSArOblHbOrE/6j+aS61cR93MW6yAACRBuhuGFO+OA//51iz+pYV7dKUjbqSwBBNp1JJSB94fatr0UjCHslErJlc2baYlWg7rF7aHtUdn0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(2616005)(36756003)(38100700002)(122000001)(2906002)(6512007)(33656002)(7416002)(4744005)(5660300002)(8676002)(66446008)(64756008)(86362001)(4326008)(66476007)(38070700005)(6486002)(71200400001)(6506007)(66556008)(66946007)(91956017)(76116006)(316002)(508600001)(54906003)(8936002)(6916009)(45980500001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VitGeHN4UklhWnIzc3BsLzEzakxPMjdLZmZlOTdUQThnc21TOFV1QUljczdw?=
 =?utf-8?B?N25VQUthR2N6Zzg3R1d5clFtK3NhWDhIZ2NhQjllOW9FTElpVDl2Wm4rd0J0?=
 =?utf-8?B?UjZrWUx0aURDa21ockFUQ2wvNkMraXcrZU9BemN2YmdIY21XZjFFYXF0b3lr?=
 =?utf-8?B?U3ExN0U0QUxORFYrd3dxT1I5RVFQQ2FQTVZNVUNGYldDZlJzNU1HcEYvd3ov?=
 =?utf-8?B?eU00TjZsNThkRGhwVjNiVE5nWllVb3RyQ0xiSU91WGx5RVVwQndSbmRrNE1i?=
 =?utf-8?B?TnlvUitFR0JRSjBJZ2hycWJ0ZmxqS3pjYUVCZXU1cmwvckUwU2oya3AwR0JV?=
 =?utf-8?B?SlpRNEhwdUxRVXZLVEFEeFozSjVscG1WeThtaW9LcEZ2aE05RTY3T2lUNENQ?=
 =?utf-8?B?Q25ZVWN6aUIwMVk3UytJL2ZudFEwM2RXb2lWMmxaeDBwSzhhbDhDN2tpdERC?=
 =?utf-8?B?RlZwak0rMVJhWkZIZG9GUmJVL1VaVlJydzZRNkxJWnZLT0tBWkJ3bzhrTldi?=
 =?utf-8?B?Zm1mV1ZYZFNsZDdkUXZRNmRMaHJ5c1dhT2l6TDg1OFhCcE9CdDlBNzIxNTFo?=
 =?utf-8?B?cjIvMVlwZjlPZHFtNVpZM2xEd0t4NFlYZzNmNnlDK1FLdEFiTUcxNk1ZRDhD?=
 =?utf-8?B?ak9tYUFyeCtKNkF0bU5DeHg3MmxNN0RYR3NnNGVpTHlrNFlRUHVKS1dydHdY?=
 =?utf-8?B?WnkzNkQ0S0lreEIzMWZVRnJObDBKV2hpdmUxZzdXZXVJd1hYdURmcndBd3ZB?=
 =?utf-8?B?WFMzdmFGQmQyd1lDRU9KS1ZDMG85R0ZxWkxOOFJxZkwxUnZOajdzRzcxUHZI?=
 =?utf-8?B?eldXWWVXRXB2azR6ZDlDSHlscFQ5Nk4xbURoY2l2MFZYMG5iMUF1UUcyZDE3?=
 =?utf-8?B?NktuRmUvNWNUMkZyUWY3M0VDME9ETTA3VnlWejJVZ2xjaHVkMkhTcUJDMktD?=
 =?utf-8?B?VXVHWllzWW1lQmJHR2Z3Q0VTNXRiZzBqazhPOEd4eVgzTDE0ZFNncDJGSDVL?=
 =?utf-8?B?ZCtiTW0yU3I4L2s1WHdPZzJOSXRFanVybGZuVDF4ZDFzN2Rkc2x1VzU2cWdD?=
 =?utf-8?B?TzZXVmJRRktWV3E4UExUbmJaY1J6L0lWajkvYU1CTDh4anpITSsxV0lMRzJt?=
 =?utf-8?B?WVZqRzJJZDU1WFpwNUlsTnJxSDZlL2VlOUhQc3BiYXc1Y3F0a1ZMMmp0bEdE?=
 =?utf-8?B?elFVN0RpZjd6VXFjbWppcGxJUE02Y2s3clkzQkV3ZEVGOTUraWswRlF4N2gy?=
 =?utf-8?B?UDZ0eG9uMjdNMVJMdzRoTENvWUZ5Qy93TDBZaHZFZjVwMTFpa2RtSDdXbjR0?=
 =?utf-8?B?NzRMQ1l5MmFydmY3TldOZ2daWm9QQTBQcTBYdlJZbjdzOXhxQVZGNjNlVnJi?=
 =?utf-8?B?T1Q0MVhLM25Wb3ZkUGZvaUdLSEZUZUJxWlk5Y2htd2EyOTZDbUR0VlFseHFG?=
 =?utf-8?B?eENCeDhNS1JZaiswdStGOTJMaFd1TG01cUI1dUp3bzI1YkFLSHRXZFJjY1Zy?=
 =?utf-8?B?VzA1K2tMUjVQZ0I5NWNHL0VVNlBvcGdQdklvZjBRYU55VVFBZElmRGRKZkVP?=
 =?utf-8?B?YkljNFBtZThSSGVUeHJ6ME9JRmxsMFQvUXM4SlltRytrYW5TTjM3NTIzdDFL?=
 =?utf-8?B?a2lJY3NTSnByOGdZUWdqUXRUdWRsdnRTZHVjTWJKTnlUY09WazUyWDBHUWlk?=
 =?utf-8?B?Z29UM0ZMU0cwbGF4NWJPME9HeVlnR2tKdE5aN0xQcThUNWFoWnF1cTU1UTBS?=
 =?utf-8?B?QkRvaTRyYmF2WURKK3BzVldsS3ZBTXE5NmdQSC84OWxQVWxXYWN0ei9aZzly?=
 =?utf-8?B?TkhDbFRmSlJVVndnOXJBNGRGZ0ZwL010elFremp0dkd1Qk9UNUFWbUtVMVhy?=
 =?utf-8?B?V0FHdW41UGlnUG9rY3pWQ1ljcjB1TE5xN2RNYWI1QlBHckViUW9Qa0tIZ3h1?=
 =?utf-8?B?LzFRZ2FhT0FGL1JJREt1cUdCTjZ3S291NFdDWGJ6akV5VnZ5NkxXK3hEby9k?=
 =?utf-8?B?ZlZCUGdEMXlCZDkveUFRenJRaFo0a2NXOHNGbXkxT2NWT1p4R2dMQ0grY2gz?=
 =?utf-8?B?NTIxenBPY1dsSTF2MTJOSVJsa3MvaGppSEw1TWRGL0dJZHFmK2JoejdYODR2?=
 =?utf-8?B?S0RjK3NnbkRQYWFNTE51bFp5NUdJV1BSS29KUlJadEtMRjhtQmJTS0xuQ1I5?=
 =?utf-8?Q?6uibcjSVCA1ND24botlO/Expz8enqlQVQEfBdJhMxLNP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CF73094123CA34EA7CCFAC57E14EE4F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 358aadce-fcfc-4942-ac69-08d9c44534e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 05:46:16.7796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8C/8CthGI1C6NDgHnUoTlF5KKv6Yqztn+N/k1PzLWWhE/opQOtJ3+s91s134bcNzmvnqDkzuuunX0dlEVGyZ8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4835
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWljaGFsLA0KDQpUaGUgcGF0Y2hzZXQgbG9va3MgZ29vZCB0byBtZS4gSSBkaWRu4oCZdCBm
aW5kIGFueSBpc3N1ZXMgZHVyaW5nIHRoZSB0ZXN0aW5nLg0KSSBoYXZlIG9uZSBjb25jZXJuIHJl
Z2FyZGluZyBkbWVzZyBvdXRwdXQuIERvIHlvdSB0aGluayB0aGlzIG1lc3NhZ2luZyBpcw0KdmFs
aWQgaWYgcG9zc2libGUgbm9kZSBpcyBub3QgeWV0IHByZXNlbnQ/DQpPciBpcyBpdCBvbmx5IHRo
ZSBpc3N1ZSBmb3IgdmlydHVhbCBtYWNoaW5lcz8NCg0KICBOb2RlIFhYIHVuaW5pdGlhbGl6ZWQg
YnkgdGhlIHBsYXRmb3JtLiBQbGVhc2UgcmVwb3J0IHdpdGggYm9vdCBkbWVzZy4NCiAgSW5pdG1l
bSBzZXR1cCBub2RlIFhYIFttZW0gMHgwMDAwMDAwMDAwMDAwMDAwLTB4MDAwMDAwMDAwMDAwMDAw
MF0NCg0KVGhhbmtzLA0K4oCUQWxleGV5DQoNCg0K
