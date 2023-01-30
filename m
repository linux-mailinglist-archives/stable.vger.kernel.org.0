Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE985681AE4
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 20:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbjA3TzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 14:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237849AbjA3TzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 14:55:06 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11012007.outbound.protection.outlook.com [52.101.63.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5282546D7C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 11:54:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHWBJpo3zvIXXiUTGC4/3ugkwl+52DHqx1pYRDkEk1odj4K0H3Jk6dzdUzPNhlvzN5Y60tf54MjrFM2IX5Nk65UTJ6VV14l6NoD9d6vaKL9MOJkS/ZXwE+O1wnbd1YHlE9aMJlETeICBZWpvuiAF3aoZpGPcsua/t5wlIMmdbBbCP5hLKDxoVlk5Hs0D49ij3WLW4wlHJmuUcZtfWh9eEYySbeve9khrBWnE5O2D5ge4rHLGBsmKPJ8OkgKUG0qCjYgxyo4XELqfWncwPRMjCG36Uq/BfnIfq0MEw/7dPD4xJpZmbreCg30PI97AscRiCA5QsP/dzS9cK9BBMRIc9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9B9kM/Kc7sqkGryHG6HeJ+wYbIci2Aezk+vX32EH2yk=;
 b=NR31eCSQpqZmuXv7TzOPPKTvvNYaQu0KpuH9zc1hNqG4ZGxlM3b/gXDN+RKSVMRXa8/f5wWQrE4cJYKkYX6iK06hDHZHL/e4HEc94MOKQ8QdHqocorQpoq5RwOudIUqP7eRej9YNDXWiasv00QUpqdv5LkoInrGpYIHkSQ/joeyz67Ly34GtmuXMKAJ42ruRF33jtTxj5ge5FkFqZnlhLhgFGzNt0v4s9Z5NyVMEMyYtADMdfpvK7214HiT2Vo8vjZt581eOTcn3i/3HqljxKXR/h4QS8mugevlyCoto3iNkywuMlOR6X83OTf/VHVsR7/E7gMUWvznGb6vqIUilrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B9kM/Kc7sqkGryHG6HeJ+wYbIci2Aezk+vX32EH2yk=;
 b=k2AUHyDMkXcZ+ic3CCYNPRRzxjAVtuPSsLORY+De6bB4qEHte0HHurR2emFnltiYGhA7UtkMW7yYp8v4b7H+/rFDmIPckyD3QsZ4WY5qVBgVESTlDYJbFAkLOVbIZRb+fHP2td/yOJjQqez3GgdrfD9IyhF1ilnamiJvBakWFUo=
Received: from CH3PR05MB10206.namprd05.prod.outlook.com
 (2603:10b6:610:155::10) by SJ2PR05MB9900.namprd05.prod.outlook.com
 (2603:10b6:a03:500::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 19:54:18 +0000
Received: from CH3PR05MB10206.namprd05.prod.outlook.com
 ([fe80::ad2d:cb08:253b:26e7]) by CH3PR05MB10206.namprd05.prod.outlook.com
 ([fe80::ad2d:cb08:253b:26e7%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 19:54:17 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "taoky99@outlook.com" <taoky99@outlook.com>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "1029602@bugs.debian.org" <1029602@bugs.debian.org>
Subject: Re: Bug report: kernel oops in vmw_fb_dirty_flush()
Thread-Topic: Bug report: kernel oops in vmw_fb_dirty_flush()
Thread-Index: AQHZNMkQLnC810MR80Waul4oP08v2K63X7OA
Date:   Mon, 30 Jan 2023 19:54:17 +0000
Message-ID: <accd0313931a3633a7e1997cb06bc824336f1f8b.camel@vmware.com>
References: <OS0P286MB019398DDFF6011038AD841C0B4D39@OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <OS0P286MB019398DDFF6011038AD841C0B4D39@OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR05MB10206:EE_|SJ2PR05MB9900:EE_
x-ms-office365-filtering-correlation-id: 31280831-e614-4899-4674-08db02fbc58f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pUUu5t+W60C8tN8/nJxWw1C3Z90B2hmP13v0CwNnYDpgqeCRJi6UkYj02/BP/d06YHl8/NWO6CMInG8yG+9JlemWTc08VxtzRVl7XbvKjFkjoALNm/Mw2eHmjZOYvIrUNfNJqHFvc6tpuk6WEC6iZR3pGajPO+EFyRqVSum/Vor50vo3R7AVv41ctwRLNgw8tH+kHeLdgzx04fKITLpAYz2AJEvlSlQoHE60Dr32rfqZweudMjaxGwO8O8tSxbZyxFSt/iPZet8JaLHdnhreV88RZZomUyPryLH2N7axXn302hl9K3tL4pLVTFXzX2DR7GWAIj3kV0tMnu2dNOUFJMxA5+zuzNu8yI/7iqAA/xfJLrp8TncZhTyHRSDpyqkEmnzGXbU0GEUO+OPxHhsVha+0Apz24Mz13tsL56qIEhlNWtSI2nG06cVZOMkzSjxGItOOQhU2S8SiGAyqm0sY6Qon0RKYxQNeHX0aLs38YeU+jzNAiWClGdPmFfEuVrGObyspYlyw+xbg5SDnp2rLULAEElIhiYMDCZWsmensIGFxxojqUEOgVPPhXnQ3YIastueP2ybfHB15mlAyjdOCrkGoFQyczw5c3Lu/C+w+smXQbEXT60NoUgrUeXoEfXzyCZdzlXy86an/Ni7sHpQ1EgxLmxdeLZ8erjmq+P6NAf/atDYmklaRoT3cNpsJUvduDOat85IzD216ptLtajlb0tKXHiazJm3VJAMzvy6Sta7w0afQjBmAtCJrGYSYPLVK7Hozj4RUdhXetTOGufIWNjd7Bqc60g6z+bt9uLjFdyQRXW1dgL+VQcsD2I91mxeX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR05MB10206.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199018)(36756003)(26005)(6512007)(5660300002)(2616005)(186003)(122000001)(38100700002)(2906002)(966005)(71200400001)(38070700005)(45080400002)(478600001)(6486002)(6506007)(6916009)(91956017)(66946007)(76116006)(4326008)(83380400001)(8676002)(86362001)(54906003)(66446008)(64756008)(66556008)(316002)(66476007)(41300700001)(8936002)(14143004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STg5V0pOdlcvcGhPQXllZHRxbjllMUdWdHlxNUNsQzI3SSt1YlA1OW43ajBW?=
 =?utf-8?B?ekJaT3BSdTA3ankzZW5VaVlUTWdwRHNxV3lUZ0FJamlsRklXTlhmUDZiRWVa?=
 =?utf-8?B?ZGJ0K29kMFZaOWxOY2tiZ1dNKy9xVUpRMGtFaWFEeHkwbVBWSG5RaUtWUUw3?=
 =?utf-8?B?OTZZUjdTbGZRdXhBaU5EL3lhZWJmVTZFTFQxQjFXSWFBVm9GT0J4YlcvSXVk?=
 =?utf-8?B?S0ZPWTRWT21CeXd2UGxvZnYzQzgzdiszK0lISENaMWQvdkw2MzhnUlB6RzM1?=
 =?utf-8?B?eWVDSWhiYmg1ZXJIRnY1eEhwZnpzT3MwTkJSUWFiTzlBVUhmS1BUM2E3bUxO?=
 =?utf-8?B?V2hHUnU0ajdlODVCVCtjWHJrdkFTTnlXM2tkcjhReFJVYWZkQk96VU5PS3RM?=
 =?utf-8?B?MVlmbWYwaVdVQTJJYmFEWFpZeE1tbzU5cDNwbjhwc3BJcEhVOHdCZngyTWRu?=
 =?utf-8?B?RmcrSURxMm5WYXM1VUhER2g3ME8vK0ErUk03MnpzYXYrMG9hNG50L085Znk1?=
 =?utf-8?B?eWozbUZzYzRTQnM5MDNOZklUS3RiSFpBa09MWDY2cXptVmtBQmlZWTl5eFpQ?=
 =?utf-8?B?bm5zQVZNMDRHclVITFpCU3pMNlIzTHZOWWdWS2dOcDl6cnNVSzRQQUVLTGM0?=
 =?utf-8?B?clh5TFh4NGdFbi9lL3UxNXhDQmV4TTdDc0R6azhVVXBUbmJNb3hvYmZPR05y?=
 =?utf-8?B?N3BQZ0hvRlpCK1NJMUIwN1JpQTNmWVY3TXp4NE0yVy91TDYrN2U5RG95SW43?=
 =?utf-8?B?R3ZCamFDTlJ3RVNVT2lycXVHcTcxY09MeGR2SjNFRDVEQXpYYnUrMXBEc0s3?=
 =?utf-8?B?dzY3MWtZOFJCMnVoVGdvRE9CME5PU2o0U1RuQ0JOUUZMTXhiN1A5MnZDeEVa?=
 =?utf-8?B?M254VE1PLzNLNHRzak1tOEw2UEU3ZlM3a3o3S1RCb1JYTnFMYVN6T2xSTS9M?=
 =?utf-8?B?TERRV3NZd3lIZjdVbWtGTHVBYVNkWkxWYmtiaVNhTDhGZjhpRndpaS9rdGdm?=
 =?utf-8?B?WUZJS014eWJNUE5EdGJnUEhBSzFFTDF1ck9uWitUTmN6ZWJRZWdSa2NWZWpr?=
 =?utf-8?B?NThiaTVpMGw4MzU3aXpJc3c2VFNIK3dnUjNZTk5EOG8ydlVLbmYxYSs0cDY4?=
 =?utf-8?B?end1d3BqbjNaMno0bkxkVEM2cFhjdTk3S3JZT2ZaTStQZnV4RGFxc0YwZVdF?=
 =?utf-8?B?ODR6L2xrMEhYbFFDaHF1OGliRWNNVUJRcE55SUdCc1dadHNaU29sbW5iM1Ni?=
 =?utf-8?B?OCt4REo2TlczNUFmZUVSUlNGWUUwa0NFdC94RXY2RTdzK09MVnFnNU41VUZv?=
 =?utf-8?B?ZlNJSjROL1VPWHQ1RTZMMHh5blhCcFJVNU1xTmE4Y2tNek1tOEVkZytsWGlu?=
 =?utf-8?B?NDg0TStEWG16UzRIbDhIQnBUSEMvcFJycGZ6enJOQmhDcFRFeDVpQU1HRmpa?=
 =?utf-8?B?NmJXSkNkTDNYK2J2TnRpc3Nad0hXL1BjbHhnNUdIMkJUMHhSSEYrRm1XSTdk?=
 =?utf-8?B?anVMYVFTc1NQMEpNUHhDNlRIeDRBSDVJTFFmc2t6UmsrZlIzY0g2WUE5MENE?=
 =?utf-8?B?WFhJM2VkWENyY1VjNVMrdi9ZN290YU9kMmdCeXhlK0lsdzl4VDI1SW1kMTFC?=
 =?utf-8?B?MU9zZTlFMHMwb0JnaGJxSVBFdTNyVC94ZlJyMUVNY05Ld0doVEV3ZXRnajZa?=
 =?utf-8?B?eEdWWmZEb2NuTEtBUFcyVzM1bHRMdytpYmRLNHFnN0xlSEYvUXk3MFlGUnEy?=
 =?utf-8?B?UVUrSzRxek8wNXg1RGRHTGtId3FFckdrSkNaK3cvV2NTOFAvYWsySXhBb1lT?=
 =?utf-8?B?K1JSL1dTM05Sd0lPWWxzNTgrbnltYk84TTdGdEthUUkvQm9zUmNXenpmR2xl?=
 =?utf-8?B?TnJJc1NpLzZVdy8xelJDaW0zZk5uaUpIRHd3aXRnWUJXbzcwRzEvZ0tYT1Fr?=
 =?utf-8?B?eGV0MmJGSGNiTWp4MGFEUUJhY3VuV3Fmc3pnVTF4Nm14ZmhYVXZlNGRHWnQv?=
 =?utf-8?B?RGh6MkhxbU9iWlJ0aTJsbzRaTm14NThVN0NCWGJDdjFiTSs0Smdab0R3ckNE?=
 =?utf-8?B?cHlyZ1l5Um9uZGM0enRRM1NZZTQrSHFQZGxodWhvakRuWGlscFRmeC92MFhu?=
 =?utf-8?Q?4fro+cRQcculZ10KUhqymdyYJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2410E2C9C8AFCA47940CE5FD20B8F2F0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR05MB10206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31280831-e614-4899-4674-08db02fbc58f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 19:54:17.6980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jr2U2tbN/8Oip1IuT064p0EFjQ0aZDSmEpb4uo0gpk5tmagJUMSS0Sm28FqkvU0VcmQxIClOfWmKr/gk/0ZK6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR05MB9900
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        HTTP_ESCAPED_HOST,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTMxIGF0IDAwOjM2ICswODAwLCBLZXl1IFRhbyB3cm90ZToNCj4gISEg
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IEhpIHZtd2dmeCBtYWludGFpbmVycywNCj4gDQo+IEFuIG91
dC1vZi1ib3VuZCBhY2Nlc3MgaW4gdm13Z2Z4IHNwZWNpZmljIGZyYW1lYnVmZmVyIGltcGxlbWVu
dGF0aW9uIGNhbg0KPiBiZSBlYXNpbHkgdHJpZ2dlcmVkIGJ5IGZidGVybSAoYSBmcmFtZWJ1ZmZl
ciB0ZXJtaW5hbCBlbXVsYXRvcikgd2hlbiBpdA0KPiBpcyBnb2luZyB0byBzY3JvbGwgc2NyZWVu
Lg0KPiANCj4gV2l0aCBzb21lIGRlYnVnZ2luZywgaXQgc2VlbXMgdGhhdCB2bXdfZmJfZGlydHlf
Zmx1c2goKSBjYW5ub3QgaGFuZGxlDQo+IHRoZSB2aW5mby55b2Zmc2V0IGNvcnJlY3RseSBhZnRl
ciBjYWxsaW5nIGBpb2N0bChmYmRldl9mZCwNCj4gRkJJT1BBTl9ESVNQTEFZLCAmdmluZm8pO2As
IGFuZCB0aGVuIHN1YnNlcXVlbnQgYWNjZXNzIHRvIHRoZSBtYXBwZWQNCj4gbWVtb3J5IGFyZWEg
Y2F1c2VzIHRoZSBvb3BzLg0KPiANCj4gQXMgY3VycmVudCBtYWlubGluZSB2bXdnZnggaW1wbGVt
ZW50YXRpb24gKGluIExpbnV4IDYuMi1yYykgaGFzIHJlbW92ZWQNCj4gdGhpcyBmcmFtZWJ1ZmZl
ciBpbXBsZW1lbnRhdGlvbiwgdGhpcyBidWcgY2FuIGJlIHRyaWdnZXJlZCBvbmx5IGluIExpbnV4
DQo+IHN0YWJsZS4gSSBoYXZlIHRlc3RlZCBpdCB3aXRoIHZhbmlsbGEgNi4xLjggYW5kIDUuMTAu
MTY1IGFuZCB0aGV5IGFsbCBvb3BzLg0KPiANCj4gVGhpcyBidWcgaXMgcmVwb3J0ZWQgaW4NCj4g
PA0KPiBodHRwczovL25hbTA0LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9
aHR0cHMlM0ElMkYlMkZidWdzLmRlYmlhbi5vcmclMg0KPiBGY2dpLQ0KPiBiaW4lMkZidWdyZXBv
cnQuY2dpJTNGYnVnJTNEMTAyOTYwMiZkYXRhPTA1JTdDMDElN0N6YWNrciU0MHZtd2FyZS5jb20l
N0M2Mzg2MmU3MzFjDQo+IDNiNGE5Nzc5NjgwOGRiMDJlMDMxNDUlN0NiMzkxMzhjYTNjZWU0YjRh
YTRkNmNkODNkOWRkNjJmMCU3QzAlN0MxJTdDNjM4MTA2OTM0MTU1OTINCj4gMjc2OSU3Q1Vua25v
d24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pC
VGlJNklrMWhhV3dpTA0KPiBDSlhWQ0k2TW4wJTNEJTdDMjAwMCU3QyU3QyU3QyZzZGF0YT11Vk90
REJBeW4lMkJEeDV3OHIxdHd1S080WGQwTG1hNnpDcjJpZTNsUSUyQlJSDQo+IEUlM0QmcmVzZXJ2
ZWQ9MD4gZmlyc3QsIGFuZA0KPiB0aGUgbWFpbnRhaW5lciB0aGVyZSBzdWdnZXN0cyBtZSB0byBy
ZXBvcnQgdGhpcyBpc3N1ZSB0byB1cHN0cmVhbSA6KQ0KPiANCj4gUmVsZXZhbnQgaW5mb3JtYXRp
b24gKGZvciBzZWxmLWNvbXBpbGVkIExpbnV4IDYuMS44KToNCj4gDQo+IC0gL3Byb2MvdmVyc2lv
bjogTGludXggdmVyc2lvbiA2LjEuOCAodGFvQG1pcmEpIChnY2MgKERlYmlhbiAxMC4yLjEtNikN
Cj4gMTAuMi4xIDIwMjEwMTEwLCBHTlUgbGQgKEdOVSBCaW51dGlscyBmb3IgRGViaWFuKSAyLjM1
LjIpICM3IFNNUA0KPiBQUkVFTVBUX0RZTkFNSUMgTW9uIEphbiAzMCAyMTowOTowMiBDU1QgMjAy
Mw0KPiANCj4gLSBMaW51eCBkaXN0cmlidXRpb246IERlYmlhbiBHTlUvTGludXggMTEgKGJ1bGxz
ZXllKQ0KPiANCj4gLSBBcmNoaXRlY3R1cmUgKHVuYW1lIC1taSk6IHg4Nl82NCB1bmtub3duDQo+
IA0KPiAtIFZpcnR1YWxpemF0aW9uIHNvZnR3YXJlOiBWTXdhcmUgRnVzaW9uIDEzIFBsYXllcg0K
PiANCj4gLSBIb3cgdG8gcmVwcm9kdWNlOg0KPiDCoMKgIDEuIEluc3RhbGwgKG9yIGNvbXBpbGUp
IGZidGVybQ0KPiDCoMKgIDIuIFJ1biBmYnRlcm0gdW5kZXIgYSB0dHkgKGJ5IGEgdXNlciB3aXRo
IHJlYWQgJiB3cml0ZSBwZXJtaXNzaW9uIHRvDQo+IC9kZXYvZmIwLCB1c3VhbGx5IHVzZXJzIGlu
IHZpZGVvIGdyb3VwKSwgYW5kIHRyeSB0byBtYWtlIGl0IHNjcm9sbCAoZm9yDQo+IGV4YW1wbGUg
YnkgcHJlc3NpbmcgRW50ZXIgZm9yIGEgZmV3IHNlY29uZHMpDQo+IMKgwqAgMy4gVGhlIGdyYXBo
aWNzIGhhbmcgYW5kIGl0IG9vcHMuDQo+IA0KDQpUaGFua3MgYSBsb3QgZm9yIHRoZSBkZXRhaWxl
ZCByZXBvcnQuIElzIHRoZXJlIGFueSBjaGFuY2UgdGhhdCB5b3UgY291bGQgdHJ5IGFueSBvZg0K
dGhlIDYuMiByYyByZWxlYXNlcyB0byBzZWUgaWYgeW91IGNhbiByZXByb2R1Y2U/IFdlIHJlbW92
ZWQgYWxsIG9mIHRoZSBoYW5kIHJvbGxlZA0KZmIgY29kZSBhbmQgcG9ydGVkIGl0IHRvIGRybSBo
ZWxwZXJzIGluIGNoYW5nZToNCmRmNDI1MjNjMTJmOCAoImRybS92bXdnZng6IFBvcnQgdGhlIGZy
YW1lYnVmZmVyIGNvZGUgdG8gZHJtIGZiIGhlbHBlcnMiKQ0Kd2hpY2ggZm9yIHRoZSBmaXJzdCB0
aW1lIGdvdCBpbnRvIHRoZSBvZmZpY2lhbCBrZXJuZWwgaW4gdjYuMi1yYzEgLiBTbyBhbnkga2Vy
bmVsDQphZnRlciB0aGF0IHNob3VsZG4ndCBjcmFzaCB3aXRoIGZidGVybSwgaWYgYW55b25lIGNv
dWxkIHZlcmlmeSB0aGF0J2QgYmUgbXVjaA0KYXBwcmVjaWF0ZWQuDQoNCnoNCg==
