Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02A5952F0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiHPGsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHPGs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:48:28 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 18:53:31 PDT
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1515.securemx.jp [210.130.202.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3FC162C63;
        Mon, 15 Aug 2022 18:53:31 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1515) id 27G1hY7K003329; Tue, 16 Aug 2022 10:43:34 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 27G1hFPM018195; Tue, 16 Aug 2022 10:43:15 +0900
X-Iguazu-Qid: 34tMJNUJFc1V8qcX97
X-Iguazu-QSIG: v=2; s=0; t=1660614195; q=34tMJNUJFc1V8qcX97; m=ZrPPafFHTQ4+HDTrkmzvh74dBBIC2wD7OsLTZnqgspA=
Received: from imx12-a.toshiba.co.jp ([38.106.60.135])
        by relay.securemx.jp (mx-mr1510) id 27G1hDbk002631
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 16 Aug 2022 10:43:13 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SS/IuFJQGsqvt4wOZP3NBFoDpqSS9DGR0bONS4QUPDRtXZRMNnEc8w5FhWkE/1YEttZ4QNOfegOQwjLVAJvQzBVYa+ouBdXPlP24riqPVqyVNrhyAutUWsjE53LURNJl57x8umDQTSHFcNzkEi3O8C9vIfuzAZQv0Oe1C1QghR6/5GEIusP8lyHhXMSWfbdu1MYgiB6r0MHXcz0PdnAZ6HBjIZXfE+RsRtde4EuaAMMemIqDaoWKrlDKTEIQOd1yaAJjtSAX2t2xpjSwwCr9FmIXhxbDokNKacIiu74AlRxHmvSD1c0E9AB0VXdxOpGPHlnnefmS8wNaSxA4YgS1PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Qv29wRAkCddaQE9gZF+WxPVAAbPfEQmwbk5ygRs5Ys=;
 b=C1XCUqHEL6T6IiLQsOsVDQtjorKXFEnuIasJRbuJg3q3BnfADKiri87aJrurTEH+mOJpIT/6xi7NwKOw2i+3Lvv5pNE3kSoKoPrlM1Hz+fo4V6h87Y096IpsLykmLCJosSczUKtnOLHZ4qVI/gAWpIvMxDDdAF56uD+g/IOE9was62Vtz3zaTrWdTEc8JHOFweAButL/U6M0I2+7L5vrL9jul0oHaYK0XMwIU9Il+RcCnB2KGSPwhEUzCYKLihheLPFJ4GcBshqBOj+4AEJZhGcR2Zlho4GFSQRFdCl87gBfJPPp0/Z0ekxfQ5QjhMSbFUWTgiB5MeVXii8j9Fy66g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <stern@rowland.harvard.edu>,
        <syzbot+b0de012ceb1e2a97891b@syzkaller.appspotmail.com>
Subject: RE: [PATCH 5.15 103/779] USB: gadget: Fix use-after-free Read in
 usb_udc_uevent()
Thread-Topic: [PATCH 5.15 103/779] USB: gadget: Fix use-after-free Read in
 usb_udc_uevent()
Thread-Index: AQHYsNS2gv/bCXu+Y0CMY29DkjiNR62wv3cw
Date:   Tue, 16 Aug 2022 01:43:11 +0000
X-TSB-HOP2: ON
Message-ID: <TYWPR01MB94203CD9FB4E48250368E1D7926B9@TYWPR01MB9420.jpnprd01.prod.outlook.com>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180341.711918032@linuxfoundation.org>
In-Reply-To: <20220815180341.711918032@linuxfoundation.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toshiba.co.jp;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d46e2e2a-d2f4-48d2-c073-08da7f28aded
x-ms-traffictypediagnostic: TYAPR01MB6171:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mZOcDq8bssn3K5AqgQfgPvEE+Ove2S5U80zNvKGIYFjgJ5xgXz3xdjsuSB1tjJ6od264hf8zLecRp07AscINODs/4dcWR1AXY0VCB2Uc67BqKPxoUuI/f+v9CHrAtSvOCYoR9+4rBEncxc90BpFNiaEI1+2wCjrpUuxtrr0LYHRp8/hCPYpeymXhJapUvz577DN8F/k4Odn8BVTtPI+a4Y9XrEpTUdMs9PkKhnn5dppaZOQNjwrklYDnS3ksrS/S9KYvqC7NJcOa/m8ij+Q2ndZDoWuhiLUFDm0KLzFbxSQvl2NpQJ7FSIKI7o80RXBWR5ur+rJ0q+kTQS3P7Pl+AoJ/QYC8/HjiRjdjgC05DHLPblQsn+APqdrGR1kWSfpLo3DoDTNt8n0czA6wU279wn94Du5fOPQk1Lya45WJcE3s6MoYgCXWzHjLf2sT31iFYzagWkQ1+kYTcnH4wPgpyLSq7KQqPwERtpthZaj+GPGI+IUT0X0LZeVkcJa4dbERS61q7OGzUuf93eyC8fAINpulYErDXf08jWMqfgHBOTzxG3yYzyWwESQvlMqpWPMWq3xnABtrpeVyJFYgmgjajdToxmHsEU94vsB01zkMasCJyjryV2gLM8iH7w60WgOeyDxwWpaUCVjNMBtJR6K6WlfRIdDZqOV3rKuHGTXmJzXvylV/7lqFshu2zbGO45HINYzyVSGHBfcHEjU9InOfjGy3i+Ibqgqu2N8eTqLa9cF83D2yLd1Cu9bFY0tcz4lHEWUH2aZAb0DsQsvjM+1mPkzCRv6fIMO6/6yPtL9V6pKfm3Zzs4Jh97R4GKF7hfJ82coNsspZo81dEwK6oAQoyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB9420.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(2906002)(52536014)(8936002)(66946007)(66476007)(76116006)(66556008)(33656002)(66446008)(4326008)(5660300002)(8676002)(64756008)(55016003)(86362001)(122000001)(83380400001)(38100700002)(38070700005)(966005)(478600001)(316002)(54906003)(110136005)(186003)(71200400001)(26005)(9686003)(6506007)(7696005)(55236004)(53546011)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEtCSW5hYzdqWThUclAyd3Z4VWk1dHpxWVd3Z216NjNtZ0RmdXFUQk1CZTJn?=
 =?utf-8?B?dzNHT0xqdlF3NHd3YkV0VVM4SXZCQ1lnSFFGMDcrWDl0MlhqZ3I1ZUk5NUVB?=
 =?utf-8?B?eWNDNUJjSEpnT2d1eTBtSG0wQlpCbndqZlRQNlFRRUEvOU9NVThtbXI0QjM1?=
 =?utf-8?B?T0VHVkhLL0R6VEdkbTRSMW1aMHdiWmM1L1YwdjZWRUx4VjJWTGtTRWJzM21E?=
 =?utf-8?B?OEJoTTJtbXNrLzkzS0g5eHpOb3JoMXJrSUhQaDNBS0FJRGNLSGVob1RDYkQz?=
 =?utf-8?B?RGVkM1lmSjdzdWJBc054azFnMTN5NWVIbW82SGhGNkpRYUxDTVBxVXQ0OXlY?=
 =?utf-8?B?UndoZ0g2aDl2WDMrd25qOGIzVUJEYnpEQjlHbVpFRDJJNGw3c1kvTUJ2NDBp?=
 =?utf-8?B?YjRuWTJSVHNQWStUUVJlbG9PL0ZBY3B5U1AwZnhDWEg2eG9GWEdUS3dFUnBX?=
 =?utf-8?B?U1RCQ1hxNEsxeDhNN1FtK3N1TmZWSEVXZGRDT2lOYzdKQXJUQytYQXlwaVll?=
 =?utf-8?B?VmtWUjQxU0NtQ3k5clJGVk4rTEwvemNpenU0azVOcFJCdzNDUlZib3JOVXcy?=
 =?utf-8?B?SUlWeUtMVGl4T1Nxa2pJYzV3TGU2YmZvMkg5b3JHUzhtL1NOenl2QktVOW9p?=
 =?utf-8?B?aXR2WHVwSlV2dGZGN0M2NFptN3kyeFpqNGNucDdzOGh1WHJEa3VpU3dDR0xq?=
 =?utf-8?B?emQwbFdZbHY2RlZwcWpZek1rNjVTWnBxaWI4Ynp4SEFieFFNUldtTEh4OVRN?=
 =?utf-8?B?aXJKYUdhWG1heThQdUdKUVZ6T1JBSkFlbWJvTXR5SDIxRWJhV1lxYXFRRWpV?=
 =?utf-8?B?QWxBQkpnZGhvd1JWcmh0cFByOHRFWUNRa1VCajNmaFkzaE9kVm1mQ3ZtclNW?=
 =?utf-8?B?c2Y0MDBxa3JkUm1PMUJsc1Y5SUI4Ny8yNzRZL1R1Q0hXSTdVYm1VdU0xOXhY?=
 =?utf-8?B?YmFRN0N6U09neDBMSW1BRjdEeHZlRnkrNnlUdEh6OXRqTzNGK2NTVStXdkFJ?=
 =?utf-8?B?LzdqNGNmN2JRRkxKcWZTV1NEVFlHUHNUcFFzbC9laUdBbTJNeUZ4UmU2TktE?=
 =?utf-8?B?MHVkV2s2SzBFaU5XZjdTbTY4V0g2TktlTU1CeEtzRk81Rjl3eGhqWG5HSkl6?=
 =?utf-8?B?YmpLMCtDZDhoMGdmUEpSKzVPcU1QR1daQXd3QlJ3NldUWDNGRWJlRUZhUzd0?=
 =?utf-8?B?dlpKT0NaWTBPc1ZFRk9kRUgwRDFVT1kyWmRReERRUW1zR1pCczVKeFY5cEVK?=
 =?utf-8?B?d1dLNk9lQm1NaTRxaWhmbzRHUDlkNHdudFh1N00wbjZWaE1RdnFhVkFiOVh2?=
 =?utf-8?B?WjF0VjY1QSt5NWdObDBTdWF3OVJVOFp1SU1KZnJCRW1YcEhEQkw5dEJBZGx6?=
 =?utf-8?B?Tjhpc3FDcFM3UU9UV0VocE5lY2NOdy9rcUpNMVhhMDJUYUxXUnIweFo3ZmFY?=
 =?utf-8?B?QnplbGxUUGtKZjZDb0xPNVR4NFNnUFo2YmdkVmp3ZWQ0bVRqMk4wdjdXTjdo?=
 =?utf-8?B?eFVQSFk1ZDBlREZ0L3M3YVNJcndmMStmRjVFRUtDcFRGNXo1Z013NlN0R05Y?=
 =?utf-8?B?MFpVRWhGRjZlQnJVNzNDdkQ4cmtvb0t1Yk5JYlpzR0FLU0EvZFhLQnpXcW1K?=
 =?utf-8?B?cWxXaHBwRTdvcDJQQjAwRkp2RkRYVkR2Q05tYzBOVHA3eFBtNGNKbWhpeEhq?=
 =?utf-8?B?d0U2RDZiWUNKZUZBckYxSlN6NUE4elU4TjUwY3JkZjRxRkJNTVY1QVU4UE9v?=
 =?utf-8?B?Z1lVQXh3WVhMNXFrNm1SQ3ZaRWgvUlM5MkdYOW8za3lNWDQ3T3hST1VvU2Qr?=
 =?utf-8?B?eDBZWmFLOFloSnZLenF5SEVORG0ybUtuejVBS0hnN0RJNXloMlZCYktvc1dq?=
 =?utf-8?B?a1Btd2RoVFVYZUF1SENKVXNuSU5veTBLU3F0L2Rlc09Ic09OeUpjTUJKMVZn?=
 =?utf-8?B?bnY3cWttMDQ3TXFCNU5pNUVFbHJ4cExjM3oyRUw3REpTemhrd2QzRmd1L2U5?=
 =?utf-8?B?dDJGUmRBUW41enlVVU9qbDJxVmZDb0V2bjZkZ1hrbUdHRTR6bjNIQWh6QW5D?=
 =?utf-8?B?bENWeGJKbjRyNnBPdGN6cXFWaHBBejZseUZmdjA0SzNvTTl2RVJoelJ1SVJz?=
 =?utf-8?B?TDBFNGRWYXc5Y054dDA3SHhka0FzL3ZCWDZRVlgxbkE5VEFqRFAyZUJIZ0hY?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB9420.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46e2e2a-d2f4-48d2-c073-08da7f28aded
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 01:43:11.9492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d6mxN+SjiqMTHuNXY0ffZy1sNsM7WRlfWyDYCQqZ7CDPJMaolOjq/j+oAF7/0g6wJ7Ca+6PFa5ArnrkiMQAr3IDdBsnRpGjXgShmxqhjD5IKncxy0bhfy00ZlbIVzo2b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6171
X-OriginatorOrg: toshiba.co.jp
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNClRoaXMgcGF0Y2ggaXMgcmVsYXRlZCB0byAiZmMyNzRjMWU5OTczICJVU0I6IGdhZGdl
dDogQWRkIGEgbmV3IGJ1cyBmb3IgZ2FkZ2V0cyIuDQo1LjE1LnksIDUuMTAueSwgNS41LnkgYW5k
IDQuMTkueSB0cmVlIGRvZXNuJ3QgaW5jbHVkZSBpdCwgc28gaXQncyB1bm5lY2Vzc2FyeS4gUGxl
YXNlIGRyb3AgZWFjaCB0cmVlLg0KDQpCZXN0IHJlZ2FyZHMsDQogIE5vYnVoaXJvDQoNCj4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDE2LCAyMDIy
IDI6NTYgQU0NCj4gVG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEdyZWcg
S3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Ow0KPiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnOyBBbGFuIFN0ZXJuIDxzdGVybkByb3dsYW5kLmhhcnZhcmQuZWR1PjsNCj4g
c3l6Ym90K2IwZGUwMTJjZWIxZTJhOTc4OTFiQHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4g
U3ViamVjdDogW1BBVENIIDUuMTUgMTAzLzc3OV0gVVNCOiBnYWRnZXQ6IEZpeCB1c2UtYWZ0ZXIt
ZnJlZSBSZWFkIGluDQo+IHVzYl91ZGNfdWV2ZW50KCkNCj4gDQo+IEZyb206IEFsYW4gU3Rlcm4g
PHN0ZXJuQHJvd2xhbmQuaGFydmFyZC5lZHU+DQo+IA0KPiBjb21taXQgMjE5MWMwMDg1NWIwM2Fh
NTljMjBlNjk4YmU3MTNkOTUyZDUxZmMxOCB1cHN0cmVhbS4NCj4gDQo+IFRoZSBzeXpib3QgZnV6
emVyIGZvdW5kIGEgcmFjZSBiZXR3ZWVuIHVldmVudCBjYWxsYmFja3MgYW5kIGdhZGdldCBkcml2
ZXINCj4gdW5yZWdpc3RyYXRpb24gdGhhdCBjYW4gY2F1c2UgYSB1c2UtYWZ0ZXItZnJlZSBidWc6
DQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gQlVHOiBLQVNBTjogdXNlLWFmdGVyLWZyZWUgaW4gdXNiX3VkY191
ZXZlbnQrMHgxMWYvMHgxMzANCj4gZHJpdmVycy91c2IvZ2FkZ2V0L3VkYy9jb3JlLmM6MTczMg0K
PiBSZWFkIG9mIHNpemUgOCBhdCBhZGRyIGZmZmY4ODgwNzhjZTIwNTAgYnkgdGFzayB1ZGV2ZC8y
OTY4DQo+IA0KPiBDUFU6IDEgUElEOiAyOTY4IENvbW06IHVkZXZkIE5vdCB0YWludGVkIDUuMTku
MC1yYzQtbmV4dC0yMDIyMDYyOC1zeXprYWxsZXINCj4gIzAgSGFyZHdhcmUgbmFtZTogR29vZ2xl
IEdvb2dsZSBDb21wdXRlIEVuZ2luZS9Hb29nbGUgQ29tcHV0ZSBFbmdpbmUsDQo+IEJJT1MgR29v
Z2xlDQo+IDA2LzI5LzIwMjINCj4gQ2FsbCBUcmFjZToNCj4gIDxUQVNLPg0KPiAgX19kdW1wX3N0
YWNrIGxpYi9kdW1wX3N0YWNrLmM6ODggW2lubGluZV0NCj4gIGR1bXBfc3RhY2tfbHZsKzB4Y2Qv
MHgxMzQgbGliL2R1bXBfc3RhY2suYzoxMDYNCj4gcHJpbnRfYWRkcmVzc19kZXNjcmlwdGlvbiBt
bS9rYXNhbi9yZXBvcnQuYzozMTcgW2lubGluZV0NCj4gIHByaW50X3JlcG9ydC5jb2xkKzB4MmJh
LzB4NzE5IG1tL2thc2FuL3JlcG9ydC5jOjQzMw0KPiAga2FzYW5fcmVwb3J0KzB4YmUvMHgxZjAg
bW0va2FzYW4vcmVwb3J0LmM6NDk1DQo+ICB1c2JfdWRjX3VldmVudCsweDExZi8weDEzMCBkcml2
ZXJzL3VzYi9nYWRnZXQvdWRjL2NvcmUuYzoxNzMyDQo+ICBkZXZfdWV2ZW50KzB4MjkwLzB4Nzcw
IGRyaXZlcnMvYmFzZS9jb3JlLmM6MjQyNA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IFRoZSBidWcgb2NjdXJz
IGJlY2F1c2UgdXNiX3VkY191ZXZlbnQoKSBkZXJlZmVyZW5jZXMgdWRjLT5kcml2ZXIgYnV0DQo+
IGRvZXMgc28gd2l0aG91dCBhY3F1aXJpbmcgdGhlIHVkY19sb2NrIG11dGV4LCB3aGljaCBwcm90
ZWN0cyB0aGlzIGZpZWxkLiAgSWYgdGhlDQo+IGdhZGdldCBkcml2ZXIgaXMgdW5ib3VuZCBmcm9t
IHRoZSB1ZGMgY29uY3VycmVudGx5IHdpdGggdWV2ZW50IHByb2Nlc3NpbmcsDQo+IHRoZSBkcml2
ZXIgc3RydWN0dXJlIG1heSBiZSBhY2Nlc3NlZCBhZnRlciBpdCBoYXMgYmVlbiBkZWFsbG9jYXRl
ZC4NCj4gDQo+IFRvIHByZXZlbnQgdGhlIHJhY2UsIHdlIG1ha2Ugc3VyZSB0aGF0IHRoZSByb3V0
aW5lIGhvbGRzIHRoZSBtdXRleCBhcm91bmQgdGhlDQo+IHJhY2luZyBhY2Nlc3Nlcy4NCj4gDQo+
IExpbms6DQo+IDxodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMDAwMDAwMDAwMDAwNGRlOTA0
MDVhNzE5Yzk1MUBnb29nbGUuY29tPg0KPiBDQzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIGZj
Mjc0YzFlOTk3Mw0KPiBSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5Og0KPiBzeXpib3QrYjBkZTAxMmNl
YjFlMmE5Nzg5MWJAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBB
bGFuIFN0ZXJuIDxzdGVybkByb3dsYW5kLmhhcnZhcmQuZWR1Pg0KPiBMaW5rOiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9yL1l0bHJuaEh5ckhzU2t5OW1Acm93bGFuZC5oYXJ2YXJkLmVkdQ0KPiBT
aWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24u
b3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdXNiL2dhZGdldC91ZGMvY29yZS5jIHwgICAxMSArKysr
KystLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkNCj4gDQo+IC0tLSBhL2RyaXZlcnMvdXNiL2dhZGdldC91ZGMvY29yZS5jDQo+ICsrKyBiL2Ry
aXZlcnMvdXNiL2dhZGdldC91ZGMvY29yZS5jDQo+IEBAIC0xNzM5LDEzICsxNzM5LDE0IEBAIHN0
YXRpYyBpbnQgdXNiX3VkY191ZXZlbnQoc3RydWN0IGRldmljZQ0KPiAgCQlyZXR1cm4gcmV0Ow0K
PiAgCX0NCj4gDQo+IC0JaWYgKHVkYy0+ZHJpdmVyKSB7DQo+ICsJbXV0ZXhfbG9jaygmdWRjX2xv
Y2spOw0KPiArCWlmICh1ZGMtPmRyaXZlcikNCj4gIAkJcmV0ID0gYWRkX3VldmVudF92YXIoZW52
LCAiVVNCX1VEQ19EUklWRVI9JXMiLA0KPiAgCQkJCXVkYy0+ZHJpdmVyLT5mdW5jdGlvbik7DQo+
IC0JCWlmIChyZXQpIHsNCj4gLQkJCWRldl9lcnIoZGV2LCAiZmFpbGVkIHRvIGFkZCB1ZXZlbnQN
Cj4gVVNCX1VEQ19EUklWRVJcbiIpOw0KPiAtCQkJcmV0dXJuIHJldDsNCj4gLQkJfQ0KPiArCW11
dGV4X3VubG9jaygmdWRjX2xvY2spOw0KPiArCWlmIChyZXQpIHsNCj4gKwkJZGV2X2VycihkZXYs
ICJmYWlsZWQgdG8gYWRkIHVldmVudCBVU0JfVURDX0RSSVZFUlxuIik7DQo+ICsJCXJldHVybiBy
ZXQ7DQo+ICAJfQ0KPiANCj4gIAlyZXR1cm4gMDsNCg0K

