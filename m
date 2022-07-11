Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED89570018
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 13:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiGKLT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 07:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiGKLTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 07:19:19 -0400
X-Greylist: delayed 13743 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jul 2022 03:43:29 PDT
Received: from mx0a-0039f301.pphosted.com (mx0a-0039f301.pphosted.com [148.163.133.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935F532446
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 03:43:29 -0700 (PDT)
Received: from pps.filterd (m0174678.ppops.net [127.0.0.1])
        by mx0a-0039f301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B6hKCk029828;
        Mon, 11 Jul 2022 06:54:09 GMT
Received: from eur05-am6-obe.outbound.protection.outlook.com (mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105])
        by mx0a-0039f301.pphosted.com (PPS) with ESMTPS id 3h71ttuecu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 06:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neYO65rKganpB2LJc6WzVe/dOa9wKDZFOdO5TxJmQXaf1EihuYioBoYqG466NHDE+F6QLyuZnfVgKuyarq2jwLoM/wjxCEOhhZsH5+lYVAi5N08h4KgmryvzOtHun/FBgeuv2FKc0LjJZXCySbVtnZmtOtf1BO9zlfliZv58BE+kHY3YP6W7yJBSbGduYrh+zTwnJdl94XVcXLr9B7Gv3NpyXSifo4d3KIic4lDfErFR3pqlRFn+Z8lU5GtOB8EANZLkugowvgczkPXnqDtK/s96yfOPCRQHrhUoXCCiOQiy/7TYnBtDL1FS0HruznjwJAX1+iUf4sCMB/32PkdwOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXNildLuXdb8Lep+GhPI+Ajed3Aqd60JVCApvAu7LTU=;
 b=mXcWWVuCUPcO+lL1LrgT3nTQIH+wwl9leH0o5RJIGDhcdHc/IskNIdIPj0AjZbpxxwJWD+kcv/cqHE5pZAIq6mE36D6ojtgYuSwKVXwlSa+rd5XWjLc/baP9eatwFbtomqNZnn18wBsa9vfCXySfqVadGuuunCaBOqab8AKLIH/oNymFX95FFRjuDyxv2xOHDp5gEiDXfwD+2Ngubs7unj/XlYrmRwtHlGXPoviQGJ6fMYvoNpztwOOKXg+kF7fNMyOkirzdXBQEfvcc8BVEh6aFq8kg0bM0TJz38Sf0I3sL3gqDjeu22UlmpC4P+/98dEczT0QbEwP+IKxCqcxsyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXNildLuXdb8Lep+GhPI+Ajed3Aqd60JVCApvAu7LTU=;
 b=YGIrAK21DF9Hz4lklHUx8jkUsdDLEhBEVYM+VDOBy5vkB4vodwhvScXbTiQyEhBIEhy/jUptAGgAfWmeafag4yTB98l6GqyAYcHNrh5nJr/OGHY3VkwKwOxYA5LRbaIm7ESA3SZ9PLpqGNG7A0NkSUHdiJ7z/3Vltx387nN/jAfDX9YgvOTJkN0yjClyU8zznyeo9sQnXUWNqgxc3tWJNoLKv/PFsUta1/4keHwfopULlIH+VFr5oLIoGF+LoWv+gv9TUOLVO0MvuIeS36xiVzttDr2FmA1FALdyS5ci6G4PC2jzho5pjQjmmQMWvxjX4p3I6vh6Pt3ZIYiyQ691MA==
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com (2603:10a6:10:ed::15)
 by PR2PR03MB5306.eurprd03.prod.outlook.com (2603:10a6:101:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 06:54:05 +0000
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::d87f:d45e:b2c6:c21]) by DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::d87f:d45e:b2c6:c21%6]) with mapi id 15.20.5417.025; Mon, 11 Jul 2022
 06:54:05 +0000
From:   Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
CC:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v3] xen/gntdev: Ignore failure to unmap
 INVALID_GRANT_HANDLE
Thread-Topic: [PATCH v3] xen/gntdev: Ignore failure to unmap
 INVALID_GRANT_HANDLE
Thread-Index: AQHYlLGV8Y7Nvsnbgky2zNBgiFu4I614vKAA
Date:   Mon, 11 Jul 2022 06:54:05 +0000
Message-ID: <b4f411d4-f3b9-4e44-a80a-86b067324a97@epam.com>
References: <20220710230522.1563-1-demi@invisiblethingslab.com>
In-Reply-To: <20220710230522.1563-1-demi@invisiblethingslab.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b41df076-94e1-48de-133e-08da630a258b
x-ms-traffictypediagnostic: PR2PR03MB5306:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S0B8tpeAYw/YW5fX2oqo+tPARFB15r++koy2sM4/6cv0pjK6gNmJhBBePVm/SsJNtG9LM4kZEBV68rKD2W2XwJfDCmBvpf97JaC2EmDGmYspIKHpKCz29EdPtBgs86GbTGudV0PXRFcOy3Qb140VMVfTx6eDerdwEfL62ShRG5bGmWdatIrJVCMv3RVJp13xxA2xW0+k/9p2WrmP+RGPAXFhTYJfeU5aAY/d1dNtAGXOcD8KlgO1lf+bkEjjWHv3enb55LNYOW9dyf4il9TloihusqL14dI0alfROw3XcGzgxv9d9p3PJunhkgqzASXZnOdUxxr71gp58Negzb5zTOwYmOg6r9YJRxByHaTaKQIGd1CcWYSJ1qsTNaUcFD9gfXWo9Q9+dsTJDgvgjfKfMKmS5CnCaoFalBVhkUOd0mFVr3i3s2Z0tZqWNOMvGioXhFnOV3dAbTcqFmPN1xXfcIHFVcVHtY8AH3I9rvym7UNpT4eCl+xE/iDAkD1XXNhoMHvRKq72Pg/ooDPdkrQR/XF3RFC5yDxmM3T5T6aAjPWJAqOFe3kI1MUqqc+Hx7aH5TsoUUSkWjsXUS0e4z0pQaXil7Ob296Xudvh8yG6SOeiadD08xAswZmR39uHyQiIHO1x4VBtEmiFNaMZBsd5jVvoLNXWVj/O8wtw5Q3Zle390HecrTqqfJHC7w397ZYoXXcwwO+7yPh20CqoOcDj2BVNq6+OiyF6NtrNN/HneSuGcPTu3FfHzf/rejM/yGnUDKEN+Fnu33NPNL3ALz0wSgdkVoULmmjKyBrEcJMNpSmnTnAaazKDHsvaY6aIBj13zW7NiHYItAvIiJ0I05B8EPVHU7eVuE5puo2oNYpRm/k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR03MB6108.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(71200400001)(4326008)(54906003)(64756008)(6916009)(316002)(8676002)(36756003)(66946007)(91956017)(66446008)(5660300002)(8936002)(41300700001)(66556008)(478600001)(66476007)(76116006)(6486002)(31686004)(83380400001)(2616005)(6506007)(2906002)(53546011)(186003)(26005)(55236004)(122000001)(38070700005)(31696002)(86362001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUJ3Sm45eUQwbi9sUmhtQWZVV2djNWtaT1FkWjRMajNCS2dNRmV4VFE2M0lD?=
 =?utf-8?B?VmVVYi9OUERvSEs3UWFadFkzWHhod3JPTmhBd0t5Lzg5WEx3V1BibXRaUHBW?=
 =?utf-8?B?Vy9KR0N3SmlvbEt6Ykt0WXBoNzZyZWZDci9tSldlUmg0Qml4Q1FGd3I0R2Rr?=
 =?utf-8?B?NXBMdUpxM0h4NTV3VkVLSzZCUWdpV1VybzRybjk0Z0pCZ01IRWpuaUtza2pN?=
 =?utf-8?B?YU5uOGtUQVJya1kvZEVSZHo1VXVvbDdhR09QSlpiVng0cWFRU2R2VjBlb1Ju?=
 =?utf-8?B?VVpPcDNZQVZDcjZjUk1pdmNaZUxtV3p3cnZkR0ZpWWp0M1VaVkR5RWxFWjg3?=
 =?utf-8?B?RU85VWx4b1Yra3hBMmRiZkNkMWtnVFZtU1RkMUMwQmN1UTFXYVViSTMwNmpn?=
 =?utf-8?B?bzBhRVJ5SzA2dVdpeDVaODBnMzlMZWpzaEZvWCtRNFNxSjh4aUZzMW9IMXVY?=
 =?utf-8?B?VktaeFk4TXR3ekExOVlQalFDOGloS0hhM2lpZFM2Skw0TzB1TnBjMUR0U2Zw?=
 =?utf-8?B?S3UwTHZYdTMyaTVKQkFDRFV4eUNaRlhldFg1c3A2Q3VoL0ZBazlEMXBpeWtG?=
 =?utf-8?B?UERCdlNteEpyNElyeGEvREgzUkQ3SUJzbi8rRGFiQk96b29ocEVTR3NUMnND?=
 =?utf-8?B?SFZkVW9yUmZjd2ZKeFNMUGdsM1g2cis3YzJkcmdrSXZBamhMVnRMbnBiSkEy?=
 =?utf-8?B?UUVETUpoZjhUVUJGajg2clc4Y2tYK1hSTlVZQi9PMkxtYWxRaVJwKzQvZFZ0?=
 =?utf-8?B?OUsyMkN5R1dVVUx2aEtaZXNtWGJxaWN1Yy9HZHlwS0w0OFkvc2J1SlQyVnM3?=
 =?utf-8?B?Wm5lNXZHUTZSTlB1ZkdTd3lRNS9ybFJxWUxydy9Mc20wK0d2NEo0TFh6a3FO?=
 =?utf-8?B?bVY0ZGM2RU54QjVUL2cya3N3N2VnZkJhbzEvakdDdzVycTFzV1h1aHYwZ2RP?=
 =?utf-8?B?ZW9QbUlQcWNUNWZmRUlUWUxYbFFhd2xPT2RjV1dJbDhOUTlvZ25NSGg4WHhi?=
 =?utf-8?B?b1liTFFuRE04aWdTSTIrdkVvajJwYTA0Vm9RSlJVc216dGZkdG15akJHa244?=
 =?utf-8?B?NGhFbWowVFdRb3NkTmxSYlRYc01LaW1PNjExbnpETUJINGp6NHQ5ZXlscmI3?=
 =?utf-8?B?SVRpeFFQY3NnNzdVRThwb0EzbFo5OWRFUnVSajA1Tmo3WURXWTgxeE16Q2Vk?=
 =?utf-8?B?Z24xZmxnRWJzT0tUSEtJTXpYL2VLVm1JS2xEdGtTS3MvZ25QNmZmWnd4U2FR?=
 =?utf-8?B?cThyRG5DNUMyVWVhOW5LVmc1RkgxYkY1MGxxMjNoSzQrc3dKZ1J4V1VmNDJw?=
 =?utf-8?B?SnFMN0RkUDhIUjdCTzY3Tkd4ZmR4WkFoMzgwSUtUcUlyaVI2R0hsOEJtbFJ4?=
 =?utf-8?B?TTErTk8zNnRvaDJZQ3U5bmZjalFJdlRsa0hNdldWSTh1aWxoZjdsRmp3QVhs?=
 =?utf-8?B?TDExRnRlSFdqZEM5Z3BabGFGZ0xDZGxOT1c2U2RKOFBxT1lmV0F4a1ZQc0c0?=
 =?utf-8?B?d05kenVnUHViQUJyeDlVVmxOU0dZbXRVZ1pnYnE5YmpQNlRMMG5BSTJMbDRV?=
 =?utf-8?B?ZnJwdmdIYktGdCtiU2wyUFNiUmF4RlYxMy8yRlUxdENDTXN1cURBOFVxR0Fh?=
 =?utf-8?B?RjBiYkxlc0dxUWNSMy9nQUJHK0tiQW9INlgwUnh1NklldmRGRSt3bE5zbHly?=
 =?utf-8?B?UHlwQkZXVG9MQUxMZlM5Y1h6emVvN2ZwUHVOWmdhVFBWMFZ1ZHdJRDBwMVk1?=
 =?utf-8?B?aGJicVZRZElOT2V4WmU5Q3Q5Tld4dEVDS29iaGpZcU9JTUM5dUc1M25jbnFY?=
 =?utf-8?B?dUdHb2RPV1NoSksrcTl5YjJhS0NRV3daMnJvS2NFeW1BQWR5NjhHSmlFY1FR?=
 =?utf-8?B?MDg5WnRlSEJqWlR2VmtBdXZFNnZRWVZadEZMRG9oSFA5ZVJzNWRTMGhRSjZE?=
 =?utf-8?B?M01tQndFNjJGSmJIeGg1ajVLRFBXazlWRHRwZC9Tc0puUTVKUFhRY0JaMkQ3?=
 =?utf-8?B?VDg3MkFObThtYm5VV3BFMFJBUUxqaHJjZ2lYTUowTzdIdlBveU5IaUJOSitO?=
 =?utf-8?B?ckVIRUhCNEY1anZGQ1JXNkJXWEtVaXJrZys1TUZwMnRYNnoxVlc0RHB2R3c1?=
 =?utf-8?B?SXpLaVNCdSszYlc1MTdCemFFS3B0ZzFncmVLK2QrdllFVE1NZ0QvUjF5ak5a?=
 =?utf-8?Q?jrNadq61XzYba9Xzt6AUEYM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2B71C53AA656646989942DC0099014B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR03MB6108.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41df076-94e1-48de-133e-08da630a258b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 06:54:05.6571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2M/d6CqEX3YvRI4TFf+L6yGFTG97EXtbejKdXzW7rl7EPIPh4kprkptAt6GdqjfGtCIN7rmG8NNg4zow8bd3YepohW7Lyjegk4q+MZrTLNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR03MB5306
X-Proofpoint-GUID: fscVwrjyn69Ck4mtTOlBkJVYUyqDfB_0
X-Proofpoint-ORIG-GUID: fscVwrjyn69Ck4mtTOlBkJVYUyqDfB_0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-10_18,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=0 spamscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=375 lowpriorityscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207110028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAxMS4wNy4yMiAwMjowNSwgRGVtaSBNYXJpZSBPYmVub3VyIHdyb3RlOg0KDQpIZWxsbyBE
ZW1pIE1hcmllDQoNCj4gVGhlIGVycm9yIHBhdGhzIG9mIGdudGRldl9tbWFwKCkgY2FuIGNhbGwg
dW5tYXBfZ3JhbnRfcGFnZXMoKSBldmVuDQo+IHRob3VnaCBub3QgYWxsIG9mIHRoZSBwYWdlcyBo
YXZlIGJlZW4gc3VjY2Vzc2Z1bGx5IG1hcHBlZC4gIFRoaXMgd2lsbA0KPiB0cmlnZ2VyIHRoZSBX
QVJOX09OKClzIGluIF9fdW5tYXBfZ3JhbnRfcGFnZXNfZG9uZSgpLiAgVGhlIG51bWJlciBvZg0K
PiB3YXJuaW5ncyBjYW4gYmUgdmVyeSBsYXJnZTsgSSBoYXZlIG9ic2VydmVkIHRob3VzYW5kcyBv
ZiBsaW5lcyBvZg0KPiB3YXJuaW5ncyBpbiB0aGUgc3lzdGVtZCBqb3VybmFsLg0KPg0KPiBBdm9p
ZCB0aGlzIHByb2JsZW0gYnkgb25seSB3YXJuaW5nIG9uIHVubWFwcGluZyBmYWlsdXJlIGlmIHRo
ZSBoYW5kbGUNCj4gYmVpbmcgdW5tYXBwZWQgaXMgbm90IElOVkFMSURfR1JBTlRfSEFORExFLiAg
VGhlIGhhbmRsZSBmaWVsZCBvZiBhbnkNCj4gcGFnZSB0aGF0IHdhcyBub3Qgc3VjY2Vzc2Z1bGx5
IG1hcHBlZCB3aWxsIGJlIElOVkFMSURfR1JBTlRfSEFORExFLCBzbw0KPiB0aGlzIGNhdGNoZXMg
YWxsIGNhc2VzIHdoZXJlIHVubWFwcGluZyBjYW4gbGVnaXRpbWF0ZWx5IGZhaWwuDQo+DQo+IFN1
Z2dlc3RlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBEZW1pIE1hcmllIE9iZW5vdXIgPGRl
bWlAaW52aXNpYmxldGhpbmdzbGFiLmNvbT4NCj4gRml4ZXM6IGRiZTk3Y2ZmN2RkOSAoInhlbi9n
bnRkZXY6IEF2b2lkIGJsb2NraW5nIGluIHVubWFwX2dyYW50X3BhZ2VzKCkiKQ0KDQpSZXZpZXdl
ZC1ieTogT2xla3NhbmRyIFR5c2hjaGVua28gPG9sZWtzYW5kcl90eXNoY2hlbmtvQGVwYW0uY29t
Pg0KDQoNCj4gLS0tDQo+ICAgZHJpdmVycy94ZW4vZ250ZGV2LmMgfCA2ICsrKystLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IENoYW5n
ZXMgc2luY2UgdjI6DQo+DQo+IC0gVXNlIHVubWFwX29wcyBpbnN0ZWFkIG9mIGt1bm1hcF9vcHMg
aW4gdGhlIGZpcnN0IFdBUk5fT04NCj4NCj4gQ2hhbmdlcyBzaW5jZSB2MToNCj4NCj4gLSBFeHBs
aWNpdGx5IGNoZWNrIGZvciBhIHN0YXR1cyBvdGhlciB0aGFuIEdOVFNUX29rYXkgaW5zdGVhZCBv
Zg0KPiAgICBpbXBsaWNpdGx5IGNoZWNraW5nIHRoYXQgaXQgaXMgbm9uemVyby4NCj4gLSBBdm9p
ZCB3cmFwcGluZyBhIGxpbmUgYXMgd2l0aGluIGEgY29tcGFyaXNvbiwgYXMgdGhpcyBtYWtlcyB0
aGUgY29kZQ0KPiAgICBoYXJkIHRvIHJlYWQuDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3hl
bi9nbnRkZXYuYyBiL2RyaXZlcnMveGVuL2dudGRldi5jDQo+IGluZGV4IDRiNTZjMzlmNzY2ZDRk
YTY4NTcwZDA4ZDk2M2Y2ZWY0MGM4ZDljMzcuLjg0YjE0M2VlZjM5NWIxNTg1ZjNhOGMwZmRjYjMw
MWNlOWZiYzUyZWMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMveGVuL2dudGRldi5jDQo+ICsrKyBi
L2RyaXZlcnMveGVuL2dudGRldi5jDQo+IEBAIC0zOTYsMTMgKzM5NiwxNSBAQCBzdGF0aWMgdm9p
ZCBfX3VubWFwX2dyYW50X3BhZ2VzX2RvbmUoaW50IHJlc3VsdCwNCj4gICAJdW5zaWduZWQgaW50
IG9mZnNldCA9IGRhdGEtPnVubWFwX29wcyAtIG1hcC0+dW5tYXBfb3BzOw0KPiAgIA0KPiAgIAlm
b3IgKGkgPSAwOyBpIDwgZGF0YS0+Y291bnQ7IGkrKykgew0KPiAtCQlXQVJOX09OKG1hcC0+dW5t
YXBfb3BzW29mZnNldCtpXS5zdGF0dXMpOw0KPiArCQlXQVJOX09OKG1hcC0+dW5tYXBfb3BzW29m
ZnNldCArIGldLnN0YXR1cyAhPSBHTlRTVF9va2F5ICYmDQo+ICsJCQltYXAtPnVubWFwX29wc1tv
ZmZzZXQgKyBpXS5oYW5kbGUgIT0gSU5WQUxJRF9HUkFOVF9IQU5ETEUpOw0KPiAgIAkJcHJfZGVi
dWcoInVubWFwIGhhbmRsZT0lZCBzdD0lZFxuIiwNCj4gICAJCQltYXAtPnVubWFwX29wc1tvZmZz
ZXQraV0uaGFuZGxlLA0KPiAgIAkJCW1hcC0+dW5tYXBfb3BzW29mZnNldCtpXS5zdGF0dXMpOw0K
PiAgIAkJbWFwLT51bm1hcF9vcHNbb2Zmc2V0K2ldLmhhbmRsZSA9IElOVkFMSURfR1JBTlRfSEFO
RExFOw0KPiAgIAkJaWYgKHVzZV9wdGVtb2QpIHsNCj4gLQkJCVdBUk5fT04obWFwLT5rdW5tYXBf
b3BzW29mZnNldCtpXS5zdGF0dXMpOw0KPiArCQkJV0FSTl9PTihtYXAtPmt1bm1hcF9vcHNbb2Zm
c2V0ICsgaV0uc3RhdHVzICE9IEdOVFNUX29rYXkgJiYNCj4gKwkJCQltYXAtPmt1bm1hcF9vcHNb
b2Zmc2V0ICsgaV0uaGFuZGxlICE9IElOVkFMSURfR1JBTlRfSEFORExFKTsNCj4gICAJCQlwcl9k
ZWJ1Zygia3VubWFwIGhhbmRsZT0ldSBzdD0lZFxuIiwNCj4gICAJCQkJIG1hcC0+a3VubWFwX29w
c1tvZmZzZXQraV0uaGFuZGxlLA0KPiAgIAkJCQkgbWFwLT5rdW5tYXBfb3BzW29mZnNldCtpXS5z
dGF0dXMpOw0KDQotLSANClJlZ2FyZHMsDQoNCk9sZWtzYW5kciBUeXNoY2hlbmtvDQo=
