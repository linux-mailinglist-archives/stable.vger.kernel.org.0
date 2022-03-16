Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D14DB5BB
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346266AbiCPQPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350101AbiCPQPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:15:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3957AB868;
        Wed, 16 Mar 2022 09:14:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nr4zTBtDWSmh2hTG4lNsG4odU06eg8DJ0FB9xZIu3wu9T7+pGy+RjDXDLCl1T9cAyzsNblIkJfZT9AOsmvTw9hOEquUhm5vJX3dmGikNu4fshmnsAGgTDfuasopLuyMlXidou3tzstn9/DXVQFI+3dUWEiUHrTK5AoMJUwABssuBWZn2HENeukhDtp1fTFiBaUpiAAEoTR6r81ogCwmdC6TBw0GiqBpsGiP2POy6psTDgQlBvq+5v7yKgbfK4EQ8WoaFiY5mogA4u0V+ptxT+E5zFABt2bNrj/3oYLtovxRZlbxlmxaDdqiH82dcsWVm1vW8iD7sFciJehZZoKuwVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BMMBafFlbJtE2gE/A3EUrJuxyu0wtVKyjYBLk9bzRWA=;
 b=e4HtnGSgdicUEzeF5Xhg9ONplY98jDz8mq+epJzWFY2CjwTE4Mozw+kxBZwIvTVtwNPFIT7rt9/eHLl32EinM6hpNwbNSbGXEbWrpyqbHwsk2QLl89BO4jOTPHvUtDtwrj6l9AfjQVJgxC7ge5SM46n7G//CbO8OGUN8xHeQf2DWIYy3mdWD/zucj5jJQCkyHPWxsAwA7JdHd5VGGHiNTUUiemuRXyuHG8fq7XGf0kxxpiTsjnW6oq/f053aVjg8CrqktE3PLlcDmPNHpTfghm+OXLLXmA27s78IBS4aL2bUw9fuUGuQmG2WoqAzJhNtoteZ2rF2IXmEmSdGyZllZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMMBafFlbJtE2gE/A3EUrJuxyu0wtVKyjYBLk9bzRWA=;
 b=XNQg6hEmgXPiOJZy703kW15lq0fo1fY0c1Zm4VFKxKtkCPbHQ5IIEulQe0rHvLy3tyla2l9iYM6Rq/zlLOGS9lPNf+E6Wnt8aYcvQkJwyq8pPGen5vMLFNPjQYVCHHqetskRRofJbK6dfvFi7PDOy6GxrZjJts90kBIF58sSB1Q=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BYAPR12MB3254.namprd12.prod.outlook.com (2603:10b6:a03:137::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 16:14:19 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08%5]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 16:14:19 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: RE: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Thread-Topic: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Thread-Index: AQHYN7EE9MG5JHJAY0ujFaTCu2p8pKzB/M0AgAAFFgCAACymAIAAAURg
Date:   Wed, 16 Mar 2022 16:14:19 +0000
Message-ID: <BL1PR12MB5157D1E7EBB32F66C284DE0FE2119@BL1PR12MB5157.namprd12.prod.outlook.com>
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
 <b559b406-006e-05e6-6378-4665ff721666@redhat.com>
In-Reply-To: <b559b406-006e-05e6-6378-4665ff721666@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-03-16T16:14:00Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=9c452a5d-6cbd-4a4c-abe4-f8dff5b5888e;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-03-16T16:14:17Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 435ce4a8-17bc-4535-a23e-3facbf5cab8c
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17d83f5d-579f-4822-f7cd-08da0768069d
x-ms-traffictypediagnostic: BYAPR12MB3254:EE_
x-microsoft-antispam-prvs: <BYAPR12MB3254150EE2AF10F2F8C91BC5E2119@BYAPR12MB3254.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SHb+0dXS3FYf8/AZnDT/kesi/+ddcQjyT/7AwBSjlpmAocqj3kBFl+PpwAuZOmc2u9w+9hXRNICpGArIb58q6FyjGgepjW22858VFPxs6i+48p1Njyxv1bBZSA2Y/Y1PSrdhq3XPlPOhflVrfDejVmZBzMK7c2fMVaghLjx94waKnmmk6vVpKYf+dUug2SVi+Rh45qxGaab/34x48sr4a7vsVVZCgh+xq/QhYwHT1cPsj+Ck7Sb4mJ0ifZIaZu4jhYAXa2+1bct3Eh+uOS9zrXzVi7i3hV74Zj/EXtWucpxLjzQss9itxyU0VUUjdw18IScrsDIGZkORAK5f8HS/geMg/C5/vsatklsXAI055J4dkGt6+YDwnhQHlgMb5dHE4I/y1VvQ7nCmDsoF0+oJauvQbUBKksF2vSZPKNIWYuWwSpuF+glrgbMCTDFUBsRTnBIgg8L2sYmeqfVzxfRJ6TqsR4VgL/I9tSLoHjefmsS+c03MMzlK/X428HUDxrdIaeRkzoRV60ybrh/dk6Q0o/DaGJ4g8l2YgTlIYbv8u6FXOIm9pZRGjYJOVqTUqzV5oUtcZfEfRFMsHwyVZnj1Z+JAleMMXNHS3JYIvt+8JtG9kq5Duj0UUJA9cIA9g4kbpJWWhSZ1gHETE2bsQnNsQFd6+TxfBIYc8DSF7s+qi3zQR2M/qQ1lAobYo1vzv2bf5ERBRrz3RdZ/ACXXYY33sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(110136005)(8936002)(54906003)(2906002)(8676002)(4326008)(38070700005)(186003)(52536014)(86362001)(71200400001)(316002)(122000001)(38100700002)(64756008)(76116006)(66556008)(5660300002)(66446008)(66946007)(66476007)(33656002)(9686003)(508600001)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0hZTklNZzZEK2VWOTZwTFMxWW9RdkU5YjhQNllMczFQT2RxMFErN3JzbmZZ?=
 =?utf-8?B?UmcxTzlHTzdxZ0kyMU1nL0RveENBQ0pzWHc4R05mRGdaTy9tTjVFbWlFVjNn?=
 =?utf-8?B?MlB5bkhvRU1IT2p1Z29haDB6QnFLc2FHdFFIODdYQmZVYnVWTHhQSDVLRTFT?=
 =?utf-8?B?RGZiTFpvdGMxWEJiZTZLNUhWRWROWjh4RjV2SnBhNTkzTkk4NW1RcXJtVkJS?=
 =?utf-8?B?UHBUQzNLT3Bya0RyUDVFNndXWitvY1Fwc050cDc0aEFCQUE2bTExdEFNZ2FS?=
 =?utf-8?B?dVVYeDJBUjJaSmJyR2ppSzFzUGQ3S0xsSHh5NWdWcmtMcGhqZEwxSUVvSXpN?=
 =?utf-8?B?ZGxONnlGbVB4QkRoZmx2MDBZMTRVWDNjaDBHK0lQczg0K0t3YmZjRG9wQmw4?=
 =?utf-8?B?RzA5UzdRNzcxcmgyRERLYXZFZWFYaTBKRHp3cjFQQXYzRndRd0tRTkl0SVds?=
 =?utf-8?B?aEpNYzBSTGM2UTV2bXBEa0dlSTh1MGlyVzcyTHRjaUg4M2MrcjBiVld3THQ2?=
 =?utf-8?B?QmpmemFqTnh5MXZSMzhRQW5QQWhmblUwUlYvTEUyN1NDdUNwR0orVXE3ZHB6?=
 =?utf-8?B?Q1hsT3AvOXVNTGttTzZNRzdxU1BnWHNLRHVCNXE3VTBXQ0FBY29ITGp5dmxV?=
 =?utf-8?B?ejNLRHZack9GaXF6RndqNTJnMVlWQmhOR3FGQ09CZ1dITHJKQnRMeHFvTVBP?=
 =?utf-8?B?eWQrNkdXcFhNVGVCOTFkaUxzckVYRm02RXI5SUM4QTkxZ3A4WjBWbVprQ281?=
 =?utf-8?B?YkVDMVNnbXg5alcyY0hWUkphcTBFTG5PNmZvdVN5dWtLSmNNRnNDYlBSYjlZ?=
 =?utf-8?B?bGYxVUxjTGRhd0JSRzhXYmJHUW9wSWVxem5ZSEd1Ymo5ZWhUQ0lOZ3B2NkdJ?=
 =?utf-8?B?ZVBCQngvNEFZMWw1RFpJWmZuVmhIdVJhc3hlYlM0Vzc4Yk9FVVNRK3p0QkNS?=
 =?utf-8?B?TGYvM3JPdjBFbVJwaTFDeU5YM29xdXhlSzRCaTEvS0E4WVo0Y2E3NlRLS3JG?=
 =?utf-8?B?Q3UwWllyNm1qQjgweTBCWTNRVW9VV1JZeEVpa1pkQUtCSVFVR3Q5Nit0UUJn?=
 =?utf-8?B?ZmJFWlUwR003N1Q3NnpZWWkwNTlBeEpRcXdDZVFiL2EzRHlQTXVEbVNMLzFN?=
 =?utf-8?B?cXRqWWMxYnpsZ3VUb0tBMGFiYXBaNlY4cXdHT2tETktmS0VISWpCTmZ5QjU2?=
 =?utf-8?B?R1JkeGtCZWU1VW1tZlZyek5wSm9KUXpDL2lmUFRhT1ZEWW1TR1Q4VGI0Sllj?=
 =?utf-8?B?akd4UFY2a0lXMGJzSTdJZzBhZFZhejhnQzllaXJiQ3hBcFBUaTJ2QWV5U0ZS?=
 =?utf-8?B?enhrVm1tNE1SdVFEWUtrYjExbVZBUnFJYkdSSHVuUk9wdlhmQ0UzRFJjZHZR?=
 =?utf-8?B?UjJIUFZwMk9nQ2RFUkJzbW1tcWxvS0RoZGh6aGp6aVk2REpMK3pISStOUlpR?=
 =?utf-8?B?STV5Q2p1ejEyUlFjOGoxS0lzY2Z0cHBhM1EvR3kzV3V3Y3RMM3FHeEh6ZDVp?=
 =?utf-8?B?Sk8wNThZYm9NWTRralhuQWNvQkxMSStMTVlYY1E2aFdUWE5SN25vWnFPMjVt?=
 =?utf-8?B?d1h5bVIrTTd3dnJRdERYcm5nVVJZK01wNlZoaTVkSUN3QUluL1FpNkNIZDNJ?=
 =?utf-8?B?ditIRElrQ2gwUGxQK2JpSzQxa2dxZlIxN0V3M2l4WDBkSFA3QVE3dURjdk8y?=
 =?utf-8?B?ckJaWGlPMWlpZnF6ZS8zaENWaEJZSzQwK0F6Z0pmUGFNSDZPSEVHNlhLS3Bi?=
 =?utf-8?B?cFdmdGl6Yi9LUnFNRHRIVHlvTUp1RmdCMXRUcGRMdDkrNFVhOUp3OHovV1lU?=
 =?utf-8?B?eVl6SWVHZHQyMlNlNnRIYVJFaUw0U0Z0eFl6ZFJPU2RIS1c5Mm5ZTzB5SHll?=
 =?utf-8?B?bDB5ZmhqZVRGU2V4TkoxZkdDU2Q0SGdKeTFRbGFQU1J2bFEyVzl1a0xzUXpQ?=
 =?utf-8?B?N2FzNEJvMy84enF3ZUVGSGNHKzB0SzZnY2tnVkNzSG85c0tneFMzTllxWkxV?=
 =?utf-8?B?T2E0T05vdnRaamFGTHZBRzI4a2ExNXdPcHR1VkJ4QS9yR25qOXZsdk5mRXlC?=
 =?utf-8?Q?T7fKBC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d83f5d-579f-4822-f7cd-08da0768069d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 16:14:19.3949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WrkRNtxklfKBG5B31UfGwUidTD8KQMgnW9wzKv5juyO3ZClNXvi6KVdawIlIuXZUN6O4PP/c1HtRpBAwmClfRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQo+ID4gSGFucywNCj4gPg0KPiA+IERvIHlvdSB0aGluayB5b3UgY291bGQg
Z2V0IG9uZSBvZiB0aGUgZm9sa3Mgd2hvIHJlcG9ydGVkIHRoaXMgcmVncmVzc2lvbiB0bw0KPiBk
bw0KPiA+IGEgYmlzZWN0IHRvIHNlZSB3aGljaCBvbmUgImZpeGVkIiBpdD8NCj4gDQo+IFdlIGFs
cmVhZHkga25vdyB3aGljaCBjb21taXQgaXMgY2F1c2luZyB0aGUgcmVncmVzc2lvbi4gQXMgUmFm
YWVsIGFscmVhZHkNCj4gc2FpZCB0aGUgcXVlc3Rpb24gaXMgd2h5IHRoaW5ncyBhcmUgbm90IGJy
b2tlbiBpbiA1LjE3IGFuZCB0aGF0IGlzIG5vdA0KPiBhIHN0cmFpZ2h0IGZvcndhcmQgYmlzZWN0
LiBTbyBmaWd1cmluZyB0aGlzIG91dCBpcyBnb2luZyB0byBiZSBhIGxvdA0KPiBvZiB3b3JrIGFu
ZCBJJ20gbm90IHN1cmUgb2YgdGhhdCBpdCBpcyB3b3J0aCBpdC4gSSBjZXJ0YWlubHkgZG9uJ3QN
Cj4gaGF2ZSB0aW1lIHRvIGhlbHAgdXNlcnMgd2l0aCBkZWJ1Z2dpbmcgdGhpcy4NCj4gDQo+ID4g
SWYgd2UgZ2V0IGx1Y2t5IHdlIGNhbiBjb21lIGRvd24gdG8NCj4gPiBzb21lIHNtYWxsZXIgaHVu
a3Mgb2YgY29kZSB0aGF0IGNhbiBjb21lIGJhY2sgdG8gc3RhYmxlIGluc3RlYWQgb2YNCj4gcmV2
ZXJ0aW5nLg0KPiANCj4gNS4xNyBpcyBhbG1vc3QgZG9uZSBhbmQgaW4gYSBjb3VwbGUgb2Ygd2Vl
a3MgRmVkb3JhIChhbmQgQXJjaCBhbmQgb3RoZXINCj4gZGlzdHJvcyB0cmFja2luZyB0aGUgbWFp
bmxpbmUga2VybmVsKSB3aWxsIG1vdmUgdG8gNS4xNyByZXNvbHZpbmcgdGhlDQo+IHdha2V1cCBi
eSBrZXlib2FyZCBpc3N1ZSBub3Qgd29ya2luZyB0aGVyZS4NCj4gDQo+IDUuMTYgaXMgbm90IGEg
TFRTIGtlcm5lbCwgc28gZm9yIG90aGVyIGRpc3Ryb3Mgd2Ugd291bGQgYXQgYSBtaW5pbXVtDQo+
IGZpZ3VyZSBvdXQgd2hhdCBuZWVkcyB0byBiZSBiYWNrcG9ydGVkIHRvIG1ha2UgdGhpbmdzIHdv
cmsgd2l0aCA1LjE1DQo+IG1ha2luZyB0aGUgZGVsdGEgLyBzZXQgb2YgcG9zc2libGUgcGF0Y2hl
cyB3ZSBuZWVkIGV2ZW4gYmlnZ2VyLg0KPiBTbyBhcyBhbHJlYWR5IHNhaWQgSU1ITyB0aGlzIGlz
IG5vdCB3b3J0aCBpdCwgYXQgbGVhc3QgYXNzdW1pbmcgdGhhdA0KPiBub3RoaW5nIGJhZCBoYXBw
ZW5zIHdoZW4gYXR0ZW1wdGluZyB3YWtldXAgYnkga2V5Ym9hcmQsIGlvdyBpdA0KPiBqdXN0IGRv
ZXMgbm90IHdvcmsgYW5kIGRvZXMgbm90IHB1dCB0aGUgbGFwdG9wIGluIHNvbWUgYmFkIHN0YXRl
Pw0KPiANCj4gUmVnYXJkcywNCj4gDQo+IEhhbnMNCg0KWW91J3JlIHJpZ2h0LCBubyBiYWQgc3Rh
dGUgYXMgYSByZXN1bHQgYW5kIHByb2JhYmx5IG5vdCB3b3J0aCB0aGUgdHJhZGVvZmYgZm9yIGEg
YmlzZWN0IGVmZm9ydC4NCk9LLCB0aGFua3MuDQo=
