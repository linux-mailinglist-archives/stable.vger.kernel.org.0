Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243DF6C2BC1
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCUHzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCUHza (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:55:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2137.outbound.protection.outlook.com [40.107.113.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A709318AA2;
        Tue, 21 Mar 2023 00:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m101gYSe0vkkxSpf3f3jzazrYZC4SQJ5t3Y7IX3WtvTFYZe7SJq+afL+/aWlmVy9XeSNz4+EH7ZNtLV+i+gzuu9rCLtgoy+QGNdasncBW5Rmes644Yb8Cu6tZZLh+p5Q3LekHQdoZKLRH2l7Z4/xumv0HJIo3S07wu7p/orBFpSoiCNcHG2NOlGgNdqpoL8KAO3fa9PiVgb+udoh19canZKeCn6DRhx4vrjicRndAgR3VJDWjfli+KsMiZ6stKmIBfad3n6lCiFS9cCjhgQMxDnoq9cO7wZw1O6aj1hudCCnRPSpPUBwkcrdY/hFIrCRmy6qBNgJ95q26szdhkC3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckE2XQ1VtRwN4uVI0+4pAtlQcamGh/dOIXGoJtAX3Lg=;
 b=g3XqJz1GPZfa6M+w9plrm0lQaiD7ff7EHnF0R74dKe2hAL13ptx34kgw67Db97wyq6kIesIOArIUswmqG0MUGrfFau/FcbWkW/JOuo0Z7x1R/j47PN6AUvPOt72fWQ7i66yHY26+FJyrR6uogF/JNxLlClD9tOqMIm6SR3/H7kLteZxVWNNQvdwfTESJ+kt3AjufTL8J4TgQid4yXSm90EGWPLh0FtIlhbHvWgYhDSEe0RrX/rZZNcUWL3hMNtgFOhERgtnvf74KgGIUrbp0X+NpXRaRSqajQohlDvqeTxqDtHcVr1R8/zztu8QHKWt5J4E0MAAiHkjcmkKfJK/8wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckE2XQ1VtRwN4uVI0+4pAtlQcamGh/dOIXGoJtAX3Lg=;
 b=przA/Xc+5QdoAA+MvIju9mtjPVNdvf2+SnMitLDShPQvcGUPohs8I78YJ4dvhkhHQ61R3v8DzgTKys83VWNQFMsv+VVw5UGSsMEK09zeJLZA5Fm+kOqgzyPG1BEOO5amy60GwDFaTP5W0mf9rQoErZ+aiFv2t6gPFffziipTUHs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB9926.jpnprd01.prod.outlook.com (2603:1096:400:209::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 07:55:20 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::f54c:4b2:9c7d:f207]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::f54c:4b2:9c7d:f207%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 07:55:19 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Thread-Topic: [PATCH v3 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Thread-Index: AQHZWxpDkUU3/k0+20OJXXaes+p9Qa8ECWiAgADU8OA=
Date:   Tue, 21 Mar 2023 07:55:19 +0000
Message-ID: <OS0PR01MB59221DBD7E1AD48C336D4AF686819@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230320105339.236279-1-biju.das.jz@bp.renesas.com>
 <20230320105339.236279-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdW2gxDzYbP_0Z90o8mHdUm_BV6e+gMHpELJx_g=ezAbdw@mail.gmail.com>
In-Reply-To: <CAMuHMdW2gxDzYbP_0Z90o8mHdUm_BV6e+gMHpELJx_g=ezAbdw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB9926:EE_
x-ms-office365-filtering-correlation-id: b59697a0-aa14-40a6-b219-08db29e19dc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DKc/8ANjdoGTAxlgMRueUksb3Cyc3v4e52sNs8cJ3g3zVH/gD2MjNaLWrQWSA7TWs2dnamlF2W4CrfMeB9THpTpnVJdyUtrVcUm5UD0wVwaKmj4O9Jm9y2KA/AG6LiJ6LA2OoqZ0jBtRemJ/KK07hYWq7ZP5r3hiln0qKA3hfkxyfNO9avP95uvnYaVmd58w3YLzZt0xTLbr3TvHU004B/72BpeFn9zT3Ps3CprGQu8Vyt/LP8aBZlXysIXNPpdSGcUw44cEjBT4SpuBZ23/Ea8wah0cjl9oAMX9VibzTdt/wQO+QPRy9uTo8j1OLrBZQuKKBeSn0wJMj+28funUhht3fk9lFyYNggjCVKt05rB5Bxj07VLVFITxVB/Cu6fSDoii/H8CyZjX63ifoQJIgdDffwmjewbYjgL55V1YhNjMFPoO1HQhF8wmsI2uw7Rv0xQsvqfqbmnt4/y3Gt4gR83V6xjkXasLLrQH5JsjTmmcSFPz2rffITQXZldfm1LPzfbCyLNulsqpE3tEqHUwPSR3l/Aqbe5ic11NPhOUv6HTDSnsYAcJtr77io4kmFnfntYG3vk/WYBUYTgWHznn4dJrfTFSoffsRbE/m5A7Ugp2GXNPCFHn8akP3hovBngoNWBvte2l7t1EP2MNNZoMltrfoCFTDf16ATQisL5O67uPkqxMICGxYs1FVwdedMNAXIF5oAo7nkPQzGEzoCMLqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199018)(33656002)(54906003)(9686003)(66946007)(66446008)(64756008)(66476007)(478600001)(76116006)(52536014)(5660300002)(8936002)(4326008)(41300700001)(66556008)(8676002)(316002)(86362001)(38070700005)(6916009)(7696005)(6506007)(186003)(55016003)(122000001)(26005)(53546011)(2906002)(38100700002)(71200400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3RUdE1Vc3ZkYlEwcDN4M1lTbUo4TkVXTHE4bkpYTmgwNFZiN3ZUSjhmRHlo?=
 =?utf-8?B?SXNtOXloeEdTNmJ4b0U5aTVodjdWWktzZWF0RnBHMEtMdXZFQU1JcUt5OS84?=
 =?utf-8?B?NkdrK2NpbkorZit1SE9sdjcyd2FnK0JCUEdobXVRYUxML2JNNGlDT043WEpN?=
 =?utf-8?B?RVlVbTZ2S29HKyswS3lnZmVPTnB2N3RQanVrKytPbDNiU3ZoYnFRK1l4aHVS?=
 =?utf-8?B?dmszSkxQOWY2RTdidjQ0SzIvdFp1RngvbnlNYmlBYTBBYi9oa1ZtYXNjN3Fn?=
 =?utf-8?B?a3VaZmU4N3h2NzdHVDRJa25Dc2ZSbXVjSU54Y3p5WFB1WG5DSlVoZEhrRElM?=
 =?utf-8?B?NGRVdmNVMTdJcFZ3YmVwN2x1eWlqVFhXdWFmVEEwaVB4b2s4YjNBU2IrNE92?=
 =?utf-8?B?NE9udytTMUZiclFhZ244aTZwdERjZVN5WncvckMwckRoU1VYbVJtYVRQbTZH?=
 =?utf-8?B?R2xtNXY4ZStrdTlpbEpRNytvdEFPVmlld2g1K1ZNeitKV1hpVCtUaWQ3ek1v?=
 =?utf-8?B?a3Z5QzBpUXlFenNncEprR0hraUh1SFRMMGxqQUlhNng3NnJKTktYWXgveU1N?=
 =?utf-8?B?R1N6UlRMSW1YYTMwdXJveXR3NFR3RllKMVZQSXYwUlhBdi9VKzhuZm84RmNr?=
 =?utf-8?B?NitJMUZlOFFMckpFRUtlemZwN2xEZ0g0Yy9qQUhYdHR0c3ZUQlJxZUE5NzVZ?=
 =?utf-8?B?UnlaMGw2a0RtNXgzK3RNenJraDRpMDRXRUd4ei9TUEJKak0vNmNVRHVtRWZv?=
 =?utf-8?B?bURXVm5aVHRhdU9YWWg5QmlORUQrRHJSaUtlc0c0WlA3c05hSzFwQTBzbGNi?=
 =?utf-8?B?bm1paCtDU0w0TVlrM29PWkZvZFMrblZGYmh6TG1OSUFjcVlwVzlUVDlYbitP?=
 =?utf-8?B?Nzh2MVROc0d1UFRXdks1c01ZaWc2MlFFZzRsY2RSNGFRbkUrZHlHOXVGdlYr?=
 =?utf-8?B?T0RONmhEUkh2Y243a1RrZlpOcW1zNkkxMUdDVEdXKzBVdFFOMmNSZm8zeUNn?=
 =?utf-8?B?WUtxQnE2RWhmdlJoamFvbDR4cDBXWEFXSWgvVkgzWDFpaDRwUkQxakM0R2Fu?=
 =?utf-8?B?cllZcGJZc1VyanlkSUxMMG9oYzJrUjFPRnp3bWoxUUpkMnNlWjF1UC8xNDVD?=
 =?utf-8?B?bEp0TDdTMnJWRGxkUDZsazljWmJ2Nk9BTTRRajBFSVNrZFdya2I4OGluWlJF?=
 =?utf-8?B?YlRkWHJoL3RYNVNYUXN6NWMxVStMMUloYjh1NDh6SGZOeVdGRk1FWWVYbGFp?=
 =?utf-8?B?NEZDdk9GZmlSemVxSUJYMzVKa2NxbG9zUSszK2VWUldTUEwxa1VFL01KQkJI?=
 =?utf-8?B?NDM3bHN4L1I1bmdKSWZwUzZOWExTWitUdVFCOU96L0hNLzNSSmZLbmtBdkt6?=
 =?utf-8?B?aWF5UEk0clZTb0VtbzN5K2kvYmE2aW56YkwxNzk0NkZ5VVQvT2h4MjV3ay8x?=
 =?utf-8?B?Vnhkb1hqeXRlVUEydzJxS1NDOC9vYUtkK0JVWURraCtOdi9weFZaRkhZdXM3?=
 =?utf-8?B?MHNmcFJ4M1VlemxJNVJtSmVndGZNY000ZDM1TFIyOXhXV0UvSnpibjY0Y2FR?=
 =?utf-8?B?K2orTHFXUnpoYnJaeTUzTnpxQnQvOUhtazVRcTNQdWVXT1BmNHhvdENHbWF5?=
 =?utf-8?B?V05pSlVJdHZ0a3VSaFdhT3FYN1RRbjcraWx1WlI1eEY4b092Mk0vZlJ0Si91?=
 =?utf-8?B?OFhuSlBTM2ZHRCt4c1hMZ21hRnIvL2ZYNXBmNkhBZU5oeXpFVlk0cFhZWnZs?=
 =?utf-8?B?L1ZLclU5MDBrK3hGUFZNRlFGdDBiVUtFS1ZvUDNzOVZrWHAzTXBkZkZyREZy?=
 =?utf-8?B?cTZ2V1hGTUxlKzFhVFV5elhlb3JRVlZkYmYvWTNRMWk5SlFwZVFlV2tmOEQ0?=
 =?utf-8?B?NDAyUGxOcnJadWhwZ1d3UGROVE05Yk42dEtncFFIMFp2QVZRL2Z4bWYycU4v?=
 =?utf-8?B?OElNWGxtQTA1MDhleFpBWnZwVGFxRWlmUGxZek14cVBMTmllcXI5elQyQlN3?=
 =?utf-8?B?OXpZYzFnMDJmckhqL1V0VkVtSW5Idi9uMjBMZUhua1p4d1Vmd2hNWVo1K0Q2?=
 =?utf-8?B?Q3FpY0Rva0VVWEMveFhUUGZ5dHZzNzZsYVc5SXVtUkRHemdnamJJd2t1bU5y?=
 =?utf-8?Q?HjjJtI6Q5vxFc+w3mSgtKe0XT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59697a0-aa14-40a6-b219-08db29e19dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 07:55:19.4325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/+GkDdP7SsrzjqmlV6i9QlLB0UkrXVhByHrYsK+0ONTHgZWuXrB0QVc1OqBAz/6WSltOAIjTdc0MlpqLjVKCqWc6ty6sZzQwoQLfT/Ooqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9926
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4
ay5vcmc+DQo+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMjAsIDIwMjMgNzoxMiBQTQ0KPiBUbzogQmlq
dSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiBDYzogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IEppcmkgU2xhYnkNCj4gPGppcmlzbGFi
eUBrZXJuZWwub3JnPjsgR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5i
ZT47DQo+IFlvc2hpbm9yaSBTYXRvIDx5c2F0b0B1c2Vycy5zb3VyY2Vmb3JnZS5qcD47IGxpbnV4
LXNlcmlhbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IFByYWJoYWthciBNYWhhZGV2IExhZCA8cHJhYmhh
a2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPjsgbGludXgtDQo+IHJlbmVzYXMtc29j
QHZnZXIua2VybmVsLm9yZzsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIHYzIDIvNV0gdHR5OiBzZXJpYWw6IHNoLXNjaTogRml4IFJ4IG9uIFJaL0cyTCBTQ0kN
Cj4gDQo+IEhpIEJpanUsDQo+IA0KPiBPbiBNb24sIE1hciAyMCwgMjAyMyBhdCAxMTo1M+KAr0FN
IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gd3JvdGU6DQo+ID4gU0NJ
IElQIG9uIFJaL0cyTCBhbGlrZSBTb0NzIGRvIG5vdCBuZWVkIHJlZ3NoaWZ0IGNvbXBhcmVkIHRv
IG90aGVyIFNDSQ0KPiA+IElQcyBvbiB0aGUgU0ggcGxhdGZvcm0uIEN1cnJlbnRseSwgaXQgZG9l
cyByZWdzaGlmdCBhbmQgY29uZmlndXJpbmcgUngNCj4gPiB3cm9uZ2x5LiBEcm9wIGFkZGluZyBy
ZWdzaGlmdCBmb3IgUlovRzJMIGFsaWtlIFNvQ3MuDQo+ID4NCj4gPiBGaXhlczogZjlhMmFkY2M5
ZTkwICgiYXJtNjQ6IGR0czogcmVuZXNhczogcjlhMDdnMDQ0OiBBZGQgU0NJWzAtMV0NCj4gPiBu
b2RlcyIpDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTaWduZWQtb2ZmLWJ5
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gdjM6
DQo+ID4gICogTmV3IHBhdGNoLg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiANCj4g
PiAtLS0gYS9kcml2ZXJzL3R0eS9zZXJpYWwvc2gtc2NpLmMNCj4gPiArKysgYi9kcml2ZXJzL3R0
eS9zZXJpYWwvc2gtc2NpLmMNCj4gPiBAQCAtMTU4LDYgKzE1OCw3IEBAIHN0cnVjdCBzY2lfcG9y
dCB7DQo+ID4NCj4gPiAgICAgICAgIGJvb2wgaGFzX3J0c2N0czsNCj4gPiAgICAgICAgIGJvb2wg
YXV0b3J0czsNCj4gPiArICAgICAgIGJvb2wgaXNfcnpfc2NpOw0KPiA+ICB9Ow0KPiA+DQo+ID4g
ICNkZWZpbmUgU0NJX05QT1JUUyBDT05GSUdfU0VSSUFMX1NIX1NDSV9OUl9VQVJUUyBAQCAtMjkz
Nyw3ICsyOTM4LDcNCj4gPiBAQCBzdGF0aWMgaW50IHNjaV9pbml0X3NpbmdsZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpkZXYsDQo+ID4gICAgICAgICBwb3J0LT5mbGFncyAgICAgICAgICAgICA9
IFVQRl9GSVhFRF9QT1JUIHwgVVBGX0JPT1RfQVVUT0NPTkYgfCBwLQ0KPiA+ZmxhZ3M7DQo+ID4g
ICAgICAgICBwb3J0LT5maWZvc2l6ZSAgICAgICAgICA9IHNjaV9wb3J0LT5wYXJhbXMtPmZpZm9z
aXplOw0KPiA+DQo+ID4gLSAgICAgICBpZiAocG9ydC0+dHlwZSA9PSBQT1JUX1NDSSkgew0KPiA+
ICsgICAgICAgaWYgKHBvcnQtPnR5cGUgPT0gUE9SVF9TQ0kgJiYgIXNjaV9wb3J0LT5pc19yel9z
Y2kpIHsNCj4gDQo+IFBlcmhhcHMgY2hlY2sgZm9yICFkZXYtPmRldi5vZl9ub2RlIGluc3RlYWQ/
IFZhbHVlcyBvZiAxIG9yIDIgZm9yIHJlZ3NoaWZ0DQo+IGFyZSBvbmx5IG5lZWRlZCBmb3Igc2g3
NzB4L3NoNzc1MC9zaDc3NjAsIHdoaWNoIGRvbid0IHVzZSBEVCB5ZXQuICBXaGVuIHRoZXkNCj4g
YXJlIGNvbnZlcnRlZCB0byBEVCwgd2UgY2FuIGV4dGVuZCB0aGUgZHJpdmVyIHRvIHN1cHBvcnQg
dGhlIG1vcmUtb3ItbGVzcw0KPiBzdGFuZGFyZCAicmVnLXNoaWZ0IiBEVCBwcm9wZXJ0eS4NCg0K
QWdyZWVkLg0KDQo+IA0KPiA+ICAgICAgICAgICAgICAgICBpZiAoc2NpX3BvcnQtPnJlZ19zaXpl
ID49IDB4MjApDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcG9ydC0+cmVnc2hpZnQgPSAy
Ow0KPiA+ICAgICAgICAgICAgICAgICBlbHNlDQo+ID4gQEAgLTMzNTMsNiArMzM1NCwxMSBAQCBz
dGF0aWMgaW50IHNjaV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpkZXYpDQo+ID4gICAg
ICAgICBzcCA9ICZzY2lfcG9ydHNbZGV2X2lkXTsNCj4gPiAgICAgICAgIHBsYXRmb3JtX3NldF9k
cnZkYXRhKGRldiwgc3ApOw0KPiA+DQo+ID4gKyAgICAgICBpZiAob2ZfZGV2aWNlX2lzX2NvbXBh
dGlibGUoZGV2LT5kZXYub2Zfbm9kZSwgInJlbmVzYXMscjlhMDdnMDQzLQ0KPiBzY2kiKSB8fA0K
PiA+ICsgICAgICAgICAgIG9mX2RldmljZV9pc19jb21wYXRpYmxlKGRldi0+ZGV2Lm9mX25vZGUs
ICJyZW5lc2FzLHI5YTA3ZzA0NC0NCj4gc2NpIikgfHwNCj4gPiArICAgICAgICAgICBvZl9kZXZp
Y2VfaXNfY29tcGF0aWJsZShkZXYtPmRldi5vZl9ub2RlLA0KPiA+ICsgInJlbmVzYXMscjlhMDdn
MDU0LXNjaSIpKQ0KPiANCj4gUGxlYXNlLCBubyBvZl9kZXZpY2VfaXNfY29tcGF0aWJsZSgpIGNo
ZWNrcyBpbiBhIGRyaXZlciB0aGF0IHVzZXMgcHJvcGVyIERUDQo+IG1hdGNoaW5nLg0KDQpPSywg
d2lsbCBkcm9wIHRoaXMuDQoNCkNoZWVycywNCkJpanUNCg0KPiANCj4gPiArICAgICAgICAgICAg
ICAgc3AtPmlzX3J6X3NjaSA9IDE7DQo+ID4gKw0KPiA+ICAgICAgICAgcmV0ID0gc2NpX3Byb2Jl
X3NpbmdsZShkZXYsIGRldl9pZCwgcCwgc3ApOw0KPiA+ICAgICAgICAgaWYgKHJldCkNCj4gPiAg
ICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiAN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgR2VlcnQNCj4gDQo+IC0tDQo+IEdlZXJ0IFV5dHRl
cmhvZXZlbiAtLSBUaGVyZSdzIGxvdHMgb2YgTGludXggYmV5b25kIGlhMzIgLS0gZ2VlcnRAbGlu
dXgtDQo+IG02OGsub3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVj
aG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0DQo+IHdoZW4gSSdtIHRh
bGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5n
IGxpa2UNCj4gdGhhdC4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51
cyBUb3J2YWxkcw0K
