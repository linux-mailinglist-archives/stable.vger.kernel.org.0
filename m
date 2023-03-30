Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14CC6D0B49
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjC3Qa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 12:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjC3QaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 12:30:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02188E18C
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Klp1TWqBgbypimYj0YuU/fYCyyfXXLdXKn3apgQE7Pg8zqLDyOwy8QfQvt87rw2SrO4pmYSv3EgWbhB7g6x5uhJI3yaat9AFKe9JFN2dQHyaGIuaa/vaWYMWBk/Wr1hUIrKeoi2m9UppGvs/4LBq2BTWtBzG4Vgzz2ZTSxfaWsbdeiTkTP1T7gpO4jfJwfA1D4fY1pJyY9BSEbkC8xAbEOAr/Qmv99wk7E5eLKxdEMgKQ/HCPmfJP5Bk8HrrGdNaryG9vd7lCVkRGMhSKEvTDFoOeBsgA+e6IZSg68aqvWsdIRwSszQezLnl1ouZcKTLE5I1fxx/4BYHkEXXDbU03w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b07K3EfxJwVwW0vPY4I8OnYvofUv9AoUZ/kbB8Qt/PY=;
 b=Kzcj+d3+K8/i2WLXMGVctXAe5EhV04DXV7dQhcRQosro1nDm6ROhXq2njJF9UsvLF+pt1L4mVdFggShETLUOTBrTcTF4uovWOeZTGmkZIO3sxBbGHXhIXNKmA71I5bM/n/K14+8U6lFFSbTA1hWoVcs5qgbe6AG9+9zbIE1X4LGbG09s1zNAMbZC8JA3p6qWjOjECS4oy5eqZvbJgywC1a7KXXQkrFV5hz3hBUEyGjmIvDEAUUZhqnxZDC8PupCK+orW49de7emm4NJwC1fEb/4CxHc5nuwr2s353tqQ885o6jsqe79HxQEAmIG9/1TtvIJArwpqCtdt7BCrmLNUbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b07K3EfxJwVwW0vPY4I8OnYvofUv9AoUZ/kbB8Qt/PY=;
 b=NawplJPMMiyM2ZnG6341zIkTua2OjyH/mARNtZuy6xeYnvnMRk7+F5qfdxX14wZfJGOR9KCT5yLW5yt5GKxSTd87RqTKr0rcFT4ODI3tgni8CaiEhBfuPvZiUNGvWIZR4corLzuHqO5d2ZDn60NJ+zwTnqckRtFZ3cLED0Qdqb2bH8kOO9pXKOcVthkr+39meCcsiK6V75uX24EPUR6tWRLTgmc5Jm5EjkpY8YgXcJonTXBKhWRHQNixk9LXRIPBo2qLf8+cPQzRD/+1edG3XJ5gHzfFy7fHbIWGalJnNAzXcHWIFS9bFbnjnYD+wysWjYw3ffVi0N7QxEEKL4dGBw==
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by CY5PR10MB6096.namprd10.prod.outlook.com (2603:10b6:930:37::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 16:28:57 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::75fa:a159:8722:b9f9]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::75fa:a159:8722:b9f9%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 16:28:56 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH] usb: ucsi: Fix ucsi->connector race
Thread-Topic: [PATCH] usb: ucsi: Fix ucsi->connector race
Thread-Index: AQHZYhUSSy0vq+6/xUW8LEI121mCh68ThUaA
Date:   Thu, 30 Mar 2023 16:28:56 +0000
Message-ID: <9e01760d96a5e235631f9e6d73a4dcb21aaeaf41.camel@infinera.com>
References: <16800048817970@kroah.com>
         <20230329080358.29193-1-joakim.tjernlund@infinera.com>
In-Reply-To: <20230329080358.29193-1-joakim.tjernlund@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB4615:EE_|CY5PR10MB6096:EE_
x-ms-office365-filtering-correlation-id: a6bcc60a-cbfc-45b5-4c74-08db313bdc01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W2w4WV0mmjIgfcWcrYn5Xm/KQaAC9fm9yjk1BXauJFNSMM3mO9mFD4ssH4+7HnGVZUIGUoBObd6SDvOCSBc2WDE2bSsZd6jxCfPP66QGfdMo6eOcmIJm4OewwxXAQUjCONuzk6tZWsyTOVbqYaa/Ejj0z5UiW/1u+AyskG/sCpy9UYOY5DvHIuxW4t25gBeY5LKQDnZ1UTl2B+aQZym6YSuyNTFMxiAZpeGwgbmJ9LbIVKFNqGgZSMuXytDLtLFuHPJ+Ta2US3OENf6pvoAl0YJbqmaO80B9MVUpyuknromLcssSOB5CC4qxp5xqnCKjjb0PFiDCH0zL0KCBPH8rO/+vGhWHsKUkWJnfB1f6PaPHCqq7DPxlpQXBEk4pOmtZrXmMsDZdgm+xF+CUKLx0CSiHR69GdZfOssYILK8aTCnGcybAHu1zwTjJFTnn9fNSNZtEM2a/vg2HkkVNp9bR1W0dyu3cDL/dEsaf+jtQ4sYYdWX2cnkf/CIMNtbplfcaig3zqOwMZs0B8tdMBUUs3vFcPBTczKQimNnNWaJibghiE+8YiINs9XdkC0mnhh1xFK6OueB9pN0Of6CE8PziSCDN9pHap5h2m3yk3t/TOi8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199021)(38100700002)(38070700005)(2906002)(41300700001)(122000001)(8936002)(5660300002)(4326008)(86362001)(36756003)(316002)(6916009)(478600001)(54906003)(71200400001)(966005)(6506007)(6486002)(6512007)(66556008)(64756008)(83380400001)(2616005)(66946007)(186003)(66476007)(8676002)(66446008)(91956017)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXYvRTBBN3UvWmxEcE44NzFYQ045SkIvRmtVTldaTjhPcmlicXltWFJVM1Vj?=
 =?utf-8?B?L2oyZVQvMEloWkNKM1B1MVp2QjRMb1RMRDVHSklmenN6QmpiaUFWcU1pZXpX?=
 =?utf-8?B?K0pveEZsSVdQM29jcFh5RHVmbDQ1ZUdsTG9qYkNKR0pPRDdXd2VFbXg0bGkw?=
 =?utf-8?B?Qk91TW9xWHFWZUFFRXFxYkM0R1JnZWRFc3hTS3diUUxHSllxejVLbnpOYzk1?=
 =?utf-8?B?ZmgvQ3JQYjdSWi9WMlp2MUV6RXZLL1p0bk1CWmxBajMySmMzVzVDS1FxckNq?=
 =?utf-8?B?cXJYaHZHejJQbFlDRC9SbGVabXBXZFlEQ20wOEpuWm5vWUtKNHp0WVVOaUEy?=
 =?utf-8?B?aitaVjFzanBmUWM0b2l4WHI4NFNmTEFUeTg2blNtTFpDR2JOcyt0UUh1QVNB?=
 =?utf-8?B?a1pkb0hSMkUzSzBxYlZxUWpSVXNzeWM1VW5UeEtkZ1hNa0JpUzBmVVo2c0py?=
 =?utf-8?B?Snd2YTlUa0VkbDdDbWNLZDFTQ3NkQ2lLMC94WnV3TjV5NW5jemZIbUFuQVEr?=
 =?utf-8?B?cy9SUDZSUjlxOWg5RlRIaGhjdGMxU25qeGVScWtucmtsMnpVeFVJcjNETVFn?=
 =?utf-8?B?Ymwyc2xWRXIzcEI0MUFsTmg2UjFxY1BXTTVvbmkwWGRFNURiMmFVeTZCbjBh?=
 =?utf-8?B?WTNHdWszZVQ0UndSUWdqMGVRNG50aXRvY3N5OHlXbzBaekZhbCs5T3NGeU5z?=
 =?utf-8?B?TmZ3OXFTVnZFTmV4UUNHU1U1TDdtVnNDUDY3M1RmRTJERnJ2NjVtWTAydG5x?=
 =?utf-8?B?Vm1OTjJUdzJGRWpHTGh4MU5RNlBWS0RFUFhIRWUyTkphVXFrUElLL0s5aVRy?=
 =?utf-8?B?b21vTGhrWTEwcFVoV3lrcVJTQXpyaDVyWEQzaGQ3SCszRDd4d1RHWkRrcnRt?=
 =?utf-8?B?WFBZOEJMdGZTSWlHMjFoNUdIblFCZTFYVkhCTHdFcEVvZWRhRitmUjBOTkpR?=
 =?utf-8?B?YUVTNncrN3pNL0QxbjdLMGZtRU5wK1d2ZStUODlDcVk4bTRoN3dUWlBQQlJP?=
 =?utf-8?B?WjY1R2s0N3dMRTc4N0NVOXdmL2x5cEgxdTk5VDBhNHJrR0NCdHhSWVhTRXBG?=
 =?utf-8?B?OVVZQm1xajVtZWhqaFo0aGx0VVhWK3FjYmVTWkpBczhiUi9uUkJhZkdRN3Z3?=
 =?utf-8?B?THU5aUg2SERFRmYvY3RqNnljZThJK1dsczJUdmc1enhPcWFmcW5tNzVla1kv?=
 =?utf-8?B?bWc4ZmxCVTFXWFFuTW5lb3BmMXVzNGtBQ1hNdU5yd3FKL0lueEJKdVFZQXR1?=
 =?utf-8?B?UlN3OTJsdERWVU1wNlIwS28vNElaMU1kMzc1MC9HZ1QzUmdmTGo2N2d5U1pH?=
 =?utf-8?B?RVB3cEFPclJqNEUrbm9CdXNTSWR4ZmU5VHYxUEliVnFCc2QwcjBGZktYYXRO?=
 =?utf-8?B?NlI1cDI2ZXBoSWlPS015TjRjT3ZPRVRubXVJUm41QzEwWHhKWWdIbnJFbjJx?=
 =?utf-8?B?K2liaE1CSTA0a2ZEc24yaTZwbGE2VnFQcjVMMS9BKzgzR1o5dG5QUU5IWXQr?=
 =?utf-8?B?dlM2K1hnKzdYS21GbitXZlZTTE94eHlidkxlZnA1SVNONmdvME5iR3dPdEhF?=
 =?utf-8?B?Zmx0TklLeWVEekV3YlRqY2N1U3ZKTVZJYjF4ZG5vQnpwazBGT1dWSGRGVkdE?=
 =?utf-8?B?QUQ4c2tLTDlKcWQrNk85TjNDU1laNHh5amNvWUxnRnVPcmhvZ3NLc0xkK0Mr?=
 =?utf-8?B?M2dlTVdkNjVwWFBPdUtPbnUyZ3ZkdTJrRVJMandvendLOEkrRjZUSUZVdUwv?=
 =?utf-8?B?TGpldklFbGRZSmNrcUZxdjBEMUFsYTFXcWdKRllnWFlyc2w2bW80TndsMzFl?=
 =?utf-8?B?RXBPUmNETU9rbmhLajgxdnV1YVhJeG1uQTg3ZHdHZUhJc2dWSTgwbnk2SzlL?=
 =?utf-8?B?TzJCM2xscGVTMXowaXQrU2N0RmdmNC9rQWlaSVREdC9HTWhTSy9VWVdaN0JN?=
 =?utf-8?B?aEJ4K2dsc3NuTjllVG1MTXZPTWFabW5hL0llV0dvQzVSY3duZU9YOW5lZWR0?=
 =?utf-8?B?SDZoalF4TDJ6TE5CNUtsR2R3NnA1MEpHQ1FPT2Y2R0NvQUV4NnRLcElUajFP?=
 =?utf-8?B?aFpuMld5QXRFTWRma3VlQ3h0RmNBVno0UWxxZnlla2tXMklwTHdndFRaVUR2?=
 =?utf-8?B?OG1WdXV5QUZqNnBxa1pmSExHaWp3cDNjaVYrUzlzRkM3WkFrRHhwQ240aEsw?=
 =?utf-8?Q?afmNbSPUYzZOS5695sVLQSebpQMcwHavdhJBB4Zw4nqt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36FF768CF5C907448565FFEB1193630F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bcc60a-cbfc-45b5-4c74-08db313bdc01
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 16:28:56.6795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WC4skQRprZVPe/uED5SvAont1V/guWid0d6QeHsjAeF3DlKv7eCFZuXSpFSgsYZSV6JHckIXrN0XuepUxTDqIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6096
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTI5IGF0IDEwOjAzICswMjAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
Og0KPiBGcm9tOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQuY29tPg0KPiANCj4gdWNz
aV9pbml0KCkgd2hpY2ggcnVucyBmcm9tIGEgd29ya3F1ZXVlIHNldHMgdWNzaS0+Y29ubmVjdG9y
IGFuZA0KPiBvbiBhbiBlcnJvciB3aWxsIGNsZWFyIGl0IGFnYWluLg0KPiANCj4gdWNzaS0+Y29u
bmVjdG9yIGdldHMgZGVyZWZlcmVuY2VkIGJ5IHVjc2lfcmVzdW1lKCksIHRoaXMgY2hlY2tzIGZv
cg0KPiB1Y3NpLT5jb25uZWN0b3IgYmVpbmcgTlVMTCBpbiBjYXNlIHVjc2lfaW5pdCgpIGhhcyBu
b3QgZmluaXNoZWQgeWV0Ow0KPiBvciBpbiBjYXNlIHVjc2lfaW5pdCgpIGhhcyBmYWlsZWQuDQo+
IA0KPiB1Y3NpX2luaXQoKSBzZXR0aW5nIHVjc2ktPmNvbm5lY3RvciBhbmQgdGhlbiBjbGVhcmlu
ZyBpdCBhZ2FpbiBvbg0KPiBhbiBlcnJvciBjcmVhdGVzIGEgcmFjZSB3aGVyZSB0aGUgY2hlY2sg
aW4gdWNzaV9yZXN1bWUoKSBtYXkgcGFzcywNCj4gb25seSB0byBoYXZlIHVjc2ktPmNvbm5lY3Rv
ciBmcmVlLWVkIHVuZGVybmVhdGggaXQgd2hlbiB1Y3NpX2luaXQoKQ0KPiBoaXRzIGFuIGVycm9y
Lg0KPiANCj4gRml4IHRoaXMgcmFjZSBieSBtYWtpbmcgdWNzaV9pbml0KCkgc3RvcmUgdGhlIGNv
bm5lY3RvciBhcnJheSBpbg0KPiBhIGxvY2FsIHZhcmlhYmxlIGFuZCBvbmx5IGFzc2lnbiBpdCB0
byB1Y3NpLT5jb25uZWN0b3Igb24gc3VjY2Vzcy4NCj4gDQo+IEZpeGVzOiBiZGM2MmYyYmFlOGYg
KCJ1c2I6IHR5cGVjOiB1Y3NpOiBTaW1wbGlmaWVkIHJlZ2lzdHJhdGlvbiBhbmQgSS9PIEFQSSIp
DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFJldmlld2VkLWJ5OiBIZWlra2kgS3Jv
Z2VydXMgPGhlaWtraS5rcm9nZXJ1c0BsaW51eC5pbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEhhbnMgZGUgR29lZGUgPGhkZWdvZWRlQHJlZGhhdC5jb20+DQo+IExpbms6IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL3IvMjAyMzAzMDgxNTQyNDQuNzIyMzM3LTMtaGRlZ29lZGVAcmVkaGF0LmNv
bQ0KPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPg0KPiAoY2hlcnJ5IHBpY2tlZCBmcm9tIGNvbW1pdCAwNDgyYzM0ZWM2Zjg1NTdl
MDZjZDBmOGUyZDBlMjBlOGVkZTZhMjJjKQ0KPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gVGplcm5s
dW5kIDxqb2FraW0udGplcm5sdW5kQGluZmluZXJhLmNvbT4NCj4gLS0tDQo+IA0KPiAgLSBUaGlz
IGlzIGEgZHJ5IHBvcnQgdG8gNi4xLngsIHdpbGwgYmUgc29tZSB0aW1lIGJlZm9yZSBpdCB3aWxs
IGJlIHRlc3RlZC4NCg0KVGVzdGVkIE9LIG5vdyBvbiA2LjEuMjINCsKgDQogICAgICAgIEpvY2tl
DQoNCj4gDQo+ICBkcml2ZXJzL3VzYi90eXBlYy91Y3NpL3Vjc2kuYyB8IDIyICsrKysrKysrKy0t
LS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEzIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3R5cGVjL3Vjc2kvdWNzaS5j
IGIvZHJpdmVycy91c2IvdHlwZWMvdWNzaS91Y3NpLmMNCj4gaW5kZXggOGNiYmIwMDJmZWZlLi4w
ODZiNTA5Njg5ODMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdXNiL3R5cGVjL3Vjc2kvdWNzaS5j
DQo+ICsrKyBiL2RyaXZlcnMvdXNiL3R5cGVjL3Vjc2kvdWNzaS5jDQo+IEBAIC0xMDM5LDkgKzEw
MzksOCBAQCBzdGF0aWMgc3RydWN0IGZ3bm9kZV9oYW5kbGUgKnVjc2lfZmluZF9md25vZGUoc3Ry
dWN0IHVjc2lfY29ubmVjdG9yICpjb24pDQo+ICAJcmV0dXJuIE5VTEw7DQo+ICB9DQo+ICANCj4g
LXN0YXRpYyBpbnQgdWNzaV9yZWdpc3Rlcl9wb3J0KHN0cnVjdCB1Y3NpICp1Y3NpLCBpbnQgaW5k
ZXgpDQo+ICtzdGF0aWMgaW50IHVjc2lfcmVnaXN0ZXJfcG9ydChzdHJ1Y3QgdWNzaSAqdWNzaSwg
c3RydWN0IHVjc2lfY29ubmVjdG9yICpjb24pDQo+ICB7DQo+IC0Jc3RydWN0IHVjc2lfY29ubmVj
dG9yICpjb24gPSAmdWNzaS0+Y29ubmVjdG9yW2luZGV4XTsNCj4gIAlzdHJ1Y3QgdHlwZWNfY2Fw
YWJpbGl0eSAqY2FwID0gJmNvbi0+dHlwZWNfY2FwOw0KPiAgCWVudW0gdHlwZWNfYWNjZXNzb3J5
ICphY2Nlc3NvcnkgPSBjYXAtPmFjY2Vzc29yeTsNCj4gIAllbnVtIHVzYl9yb2xlIHVfcm9sZSA9
IFVTQl9ST0xFX05PTkU7DQo+IEBAIC0xMDYyLDcgKzEwNjEsNiBAQCBzdGF0aWMgaW50IHVjc2lf
cmVnaXN0ZXJfcG9ydChzdHJ1Y3QgdWNzaSAqdWNzaSwgaW50IGluZGV4KQ0KPiAgCWluaXRfY29t
cGxldGlvbigmY29uLT5jb21wbGV0ZSk7DQo+ICAJbXV0ZXhfaW5pdCgmY29uLT5sb2NrKTsNCj4g
IAlJTklUX0xJU1RfSEVBRCgmY29uLT5wYXJ0bmVyX3Rhc2tzKTsNCj4gLQljb24tPm51bSA9IGlu
ZGV4ICsgMTsNCj4gIAljb24tPnVjc2kgPSB1Y3NpOw0KPiAgDQo+ICAJY2FwLT5md25vZGUgPSB1
Y3NpX2ZpbmRfZndub2RlKGNvbik7DQo+IEBAIC0xMjA0LDcgKzEyMDIsNyBAQCBzdGF0aWMgaW50
IHVjc2lfcmVnaXN0ZXJfcG9ydChzdHJ1Y3QgdWNzaSAqdWNzaSwgaW50IGluZGV4KQ0KPiAgICov
DQo+ICBzdGF0aWMgaW50IHVjc2lfaW5pdChzdHJ1Y3QgdWNzaSAqdWNzaSkNCj4gIHsNCj4gLQlz
dHJ1Y3QgdWNzaV9jb25uZWN0b3IgKmNvbjsNCj4gKwlzdHJ1Y3QgdWNzaV9jb25uZWN0b3IgKmNv
biwgKmNvbm5lY3RvcjsNCj4gIAl1NjQgY29tbWFuZCwgbnRmeTsNCj4gIAlpbnQgcmV0Ow0KPiAg
CWludCBpOw0KPiBAQCAtMTIzNSwxNiArMTIzMywxNiBAQCBzdGF0aWMgaW50IHVjc2lfaW5pdChz
dHJ1Y3QgdWNzaSAqdWNzaSkNCj4gIAl9DQo+ICANCj4gIAkvKiBBbGxvY2F0ZSB0aGUgY29ubmVj
dG9ycy4gUmVsZWFzZWQgaW4gdWNzaV91bnJlZ2lzdGVyKCkgKi8NCj4gLQl1Y3NpLT5jb25uZWN0
b3IgPSBrY2FsbG9jKHVjc2ktPmNhcC5udW1fY29ubmVjdG9ycyArIDEsDQo+IC0JCQkJICBzaXpl
b2YoKnVjc2ktPmNvbm5lY3RvciksIEdGUF9LRVJORUwpOw0KPiAtCWlmICghdWNzaS0+Y29ubmVj
dG9yKSB7DQo+ICsJY29ubmVjdG9yID0ga2NhbGxvYyh1Y3NpLT5jYXAubnVtX2Nvbm5lY3RvcnMg
KyAxLCBzaXplb2YoKmNvbm5lY3RvciksIEdGUF9LRVJORUwpOw0KPiArCWlmICghY29ubmVjdG9y
KSB7DQo+ICAJCXJldCA9IC1FTk9NRU07DQo+ICAJCWdvdG8gZXJyX3Jlc2V0Ow0KPiAgCX0NCj4g
IA0KPiAgCS8qIFJlZ2lzdGVyIGFsbCBjb25uZWN0b3JzICovDQo+ICAJZm9yIChpID0gMDsgaSA8
IHVjc2ktPmNhcC5udW1fY29ubmVjdG9yczsgaSsrKSB7DQo+IC0JCXJldCA9IHVjc2lfcmVnaXN0
ZXJfcG9ydCh1Y3NpLCBpKTsNCj4gKwkJY29ubmVjdG9yW2ldLm51bSA9IGkgKyAxOw0KPiArCQly
ZXQgPSB1Y3NpX3JlZ2lzdGVyX3BvcnQodWNzaSwgJmNvbm5lY3RvcltpXSk7DQo+ICAJCWlmIChy
ZXQpDQo+ICAJCQlnb3RvIGVycl91bnJlZ2lzdGVyOw0KPiAgCX0NCj4gQEAgLTEyNTYsMTEgKzEy
NTQsMTIgQEAgc3RhdGljIGludCB1Y3NpX2luaXQoc3RydWN0IHVjc2kgKnVjc2kpDQo+ICAJaWYg
KHJldCA8IDApDQo+ICAJCWdvdG8gZXJyX3VucmVnaXN0ZXI7DQo+ICANCj4gKwl1Y3NpLT5jb25u
ZWN0b3IgPSBjb25uZWN0b3I7DQo+ICAJdWNzaS0+bnRmeSA9IG50Znk7DQo+ICAJcmV0dXJuIDA7
DQo+ICANCj4gIGVycl91bnJlZ2lzdGVyOg0KPiAtCWZvciAoY29uID0gdWNzaS0+Y29ubmVjdG9y
OyBjb24tPnBvcnQ7IGNvbisrKSB7DQo+ICsJZm9yIChjb24gPSBjb25uZWN0b3I7IGNvbi0+cG9y
dDsgY29uKyspIHsNCj4gIAkJdWNzaV91bnJlZ2lzdGVyX3BhcnRuZXIoY29uKTsNCj4gIAkJdWNz
aV91bnJlZ2lzdGVyX2FsdG1vZGVzKGNvbiwgVUNTSV9SRUNJUElFTlRfQ09OKTsNCj4gIAkJdWNz
aV91bnJlZ2lzdGVyX3BvcnRfcHN5KGNvbik7DQo+IEBAIC0xMjY5LDEwICsxMjY4LDcgQEAgc3Rh
dGljIGludCB1Y3NpX2luaXQoc3RydWN0IHVjc2kgKnVjc2kpDQo+ICAJCXR5cGVjX3VucmVnaXN0
ZXJfcG9ydChjb24tPnBvcnQpOw0KPiAgCQljb24tPnBvcnQgPSBOVUxMOw0KPiAgCX0NCj4gLQ0K
PiAtCWtmcmVlKHVjc2ktPmNvbm5lY3Rvcik7DQo+IC0JdWNzaS0+Y29ubmVjdG9yID0gTlVMTDsN
Cj4gLQ0KPiArCWtmcmVlKGNvbm5lY3Rvcik7DQo+ICBlcnJfcmVzZXQ6DQo+ICAJbWVtc2V0KCZ1
Y3NpLT5jYXAsIDAsIHNpemVvZih1Y3NpLT5jYXApKTsNCj4gIAl1Y3NpX3Jlc2V0X3BwbSh1Y3Np
KTsNCg0K
