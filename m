Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BFB6CBDCE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjC1Lco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjC1Lcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:43 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2105.outbound.protection.outlook.com [40.107.114.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF432AB;
        Tue, 28 Mar 2023 04:32:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDIl1Kfok0E3v0Ym+BKMHgrR+lMtNMZW1ML6beiONzjWAevll/vu/khwBkJwVvo3okGhXbj/sTv+bkENtc2/QcNKtwt/e/QCJ/Kr30G7u8LidpSQ3l1IwP4mmGaxaoGYmXAHYJr5sjoiLJTSUBzlazOTHqH/QQ5pqMCnb89VQLlIS0UUy9sNFtP5MHYchu2Ljqrdhy/4VF5ZrgO6f/L/JZEbpNxOctpb4XONUf1Vd8hz081IsHUpaPRalTKHmKMb8GuLfJwG3kRyOIFZ3ktRHHew9ShSc1J6ZwZtKyvDHiPfCswbaAaYXWEJdvhtlKI444ofcIJ/fjxeRKHBtWUxdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHPr21weu2nxLSmTrviAM7T/k5wdoHeXUlRk1zt/HNU=;
 b=jBvpxePod98T7b6L1atTcdPux3TVEZmc0pRkm72p4a+VRy73yVf8cna1rCnlbZBbBwVQJ94Ec59Vd0BRs9UjjFtbUN11y6hRkGc7uzFjoCfIx/hPo6m8Hvbx8jQczNTlgE6yKOMWJilTtPMzzEV5mNoqmop8GNcQ6j+Rj/5EU4uaApu6EC4YSLWIDlsr/enLB104Iq8tbHmh8MKO5Kk093NVqaPGplWTo3F2VJFKzXaWyQn8nWgcUdDhKify2FIQLJlGf1r8wo6nwr4xtF4S5og1xsym7y77c0aPA7+5F7tMmddQBXtrzByKO+0N+qQ7rUaKbT973Vp346qIn+LSwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHPr21weu2nxLSmTrviAM7T/k5wdoHeXUlRk1zt/HNU=;
 b=Ml26ZryDOt+lT35a5MA5TlXp42ltQInVP3XJZR5DJ+fSVPbbuJIz+X8Ubivc6RAS8WxdbwrqwOw29ADfLIy1NRMpmtwj7hlUA9CLuZliJQfGsDfDP0Jh+jedGzfes06h9LJlHXnh4tAPnoc7XpT4vQA1HVHH9/goQMkkkEbq+Z8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB8018.jpnprd01.prod.outlook.com (2603:1096:604:163::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 11:32:38 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6%8]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 11:32:38 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Thread-Topic: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Thread-Index: AQHZW+sFzUMpnEaLa0+ZQjsfAiDzca8OYYWAgAG4MaA=
Date:   Tue, 28 Mar 2023 11:32:38 +0000
Message-ID: <OS0PR01MB5922092AD985055F7376611486889@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
 <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
In-Reply-To: <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB8018:EE_
x-ms-office365-filtering-correlation-id: 31fe42f6-557a-40c4-6ac7-08db2f802286
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQCGOwHZCo+P9bsy1vMER49E0I9hoZ5vYA9p8GYLXy0wVU/bb3B8q2jKL+00NJCzjmTfrEUeucXknK8b1fZCD8oPCPgMn8OmwdQ2EQIk00n4TBvUUG+hM7jfaxYDRNrl205SeiTqYN5uOamWnPXOSgEGNWP6UZdyH7cn0bhFYqOVVboQm7LgerAjF9dC0CKKnzLO+dqLaAMr/ExFhzLZA7LhVXT799npiOOicWDaghuKPNkc6arqSwT+gyEQotbpgcqw7pGwE2wCxlKymI+dGCZCtJeSGLNkhI+DRxWOdrB4ANKmIUi3hjvoJ4rEfIBzBj1oh6wdBbUewAr5MDHYuJkRxxy59VRzBp9h9Q8pC6SV+JfaDeebbYyyldIJJZxSDtwfxT5htq+Q0VSFe7XWS3BrVUXg0TfUTUJXnTrlyXM6/CDca/rZexF5g1ve/84ZUOqzbUsbTJpBrWMnCKmpvVA2opmiQK18LgXbgEq8fNAT4uFeHTKvRn535MnbVZlKtCtEy5xMXb0DKnwS6c1RJTYKN5HNxhcRWm5NCAt5X0DpyjxJzP9QFAQBv2sBC/SC6qJYaCQjwg1YoDyw/5CBgzcp+HqRYmE0mBDjb8I04kqA228Eu7SM7PLefYPSgi2l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(55016003)(71200400001)(66946007)(64756008)(316002)(66556008)(66446008)(66476007)(4326008)(76116006)(6916009)(8676002)(8936002)(4744005)(5660300002)(54906003)(41300700001)(53546011)(9686003)(83380400001)(186003)(38100700002)(52536014)(122000001)(478600001)(7696005)(6506007)(26005)(38070700005)(2906002)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDdkOCtjc3U4K05RYm5FdG91WkF0elFjM0l5U0E0MXkrU2p4V1R1ZGU3WTlM?=
 =?utf-8?B?ZkFBS3hFczB3OEwwVmtsTlVDdVhvdUF4Sjl5cE1qLzJMNml4bmtDbU1pRm9K?=
 =?utf-8?B?TGhtbkNYdG9RYUJmYXByb284UXAwK2hucGU4SDlVaWVBMUtZckJUSzJVOVY4?=
 =?utf-8?B?dmdqSS9LczI5b0dZK3p2UkR2b2VmRm5OZ2d4YzJtUUE1eCs3REVkN2JLQ1Bq?=
 =?utf-8?B?MmZXQ0gyNlA5ZUZsLzlhUC9BNHp3V0NZYXhRZnlINXNnVGZqUXhmUzIrek5o?=
 =?utf-8?B?UHNIUzdCVVdXdndwYXVlWGJPMmZhVjQrT1lEVGFIQkdURWZ4Qm1tUGtCZDZM?=
 =?utf-8?B?UmVyK3hjQVBTQm0vdlZtSjM5cXNPN2lJa2VhcmNWblNNVjlzbDJmNlFlRzQ1?=
 =?utf-8?B?eU52SE5CY0pmejdtTnFVSFQ3MCtSQVowMEZBTlE0enp3WTJLR0xtRG9jR3ZP?=
 =?utf-8?B?NWRoYWF1VkVXR1RJa2tnVlNueWRuZzFSR25uN01YU3dFamVabHBNai9RWVFG?=
 =?utf-8?B?QkZ4K25hNzBEQ0RvZHpxNExKT0FvU3RoOFBwTEh2QlBwbC9HbUI1Q3NVZ2dC?=
 =?utf-8?B?eE1QclM2cWllTnR5R1JFV2lha0I5dllHN1lqaGFTdk5MS3p4dGZvSzRkU0VH?=
 =?utf-8?B?Rk5GNUpDMTlwNHdtWVhKb3FKUnorcVQxZENudzgzSTZZWW0zQWsrUzVFU0M0?=
 =?utf-8?B?VFNtdjN5anJNemN1bEVTWGNUaDhkYXR4bkdYbXZLWTc0amFZdndWblZVV1h0?=
 =?utf-8?B?b0lwQjZoUERvRnp6ajJPejMzcEd1djVuT0lKRW5NVWhpNXd3QkE5aUM3ay92?=
 =?utf-8?B?VXB0SE9HT0dSb0xqSFpOZFp5OEV4SC9GYUVIK3dkUnZ1MytGQjUyQ3JsT0RL?=
 =?utf-8?B?ZENhTXl0SlZxSnRtZDRZMElLalJBTjJTb0lMblE3M0RyNFovRzAzNGN6QXcz?=
 =?utf-8?B?UHowOE5rSVdIK1I5TmxXQ3lqVFFaSHBUUnZzbk5pWXk2YzNVY2ZJTEd3ZWRj?=
 =?utf-8?B?QTQ3WG95VFlJNnhhMjFuRVZYNXpDaU9YYld3T09LMkNXR1VSaXpmNkZNSC9K?=
 =?utf-8?B?RnFDanQvV3lJc0tITzU2V2o0WmozQWtNY0o3NkNnQTBjcnM1aTFlQitjMW1U?=
 =?utf-8?B?dHVRajFjUElDdUoxMG8zaWx0cTR4UDVQdjNGZk1jZGFjeWpQZ3Vtb2tnY1dV?=
 =?utf-8?B?K3VlVDExQllUbVd2RHdXQy9NbGV4OFE1a3pXUTBFWStvWjJTbmZoWXkyaFBF?=
 =?utf-8?B?d0NtditIdWJkR0ZJeTdBUGM3cjBObk9IK2VhcXltVWhlcE5nSHFxLzhiV3oy?=
 =?utf-8?B?UFd3eVlXbjVBZVovWXNxUFp4ZGpGYzYwQklHaWxzMUVsdHIycFhBZWsyd21H?=
 =?utf-8?B?c1J6QXRRWFNDTGVrRXhneDFrcjduaE1IRzl0bkJUWXpHUHJlTHFZSnlVMjFM?=
 =?utf-8?B?emZEUHFHUkwrUWl0ck9oNFZQaTRzM3VPbGdMOExldXNFK255c0l3dHMxWkVu?=
 =?utf-8?B?bkFCeW90YlpwaWM1aEdaSWNvL05hTldrTlVDQTcxWGQvbWpEdFFMU0E5YTY4?=
 =?utf-8?B?cHIyb0JQMjB4Q2JKeGkzWEw1dGVDaDNVT1o2dHdZQ2RsejZrNVBXWHUveUJm?=
 =?utf-8?B?akJNWCs4d2tZSC9wUktQVS95bUJlR3lQTUF2YmJWcXhmK3hjNEc3T0o0enUz?=
 =?utf-8?B?MWYwQ05qY3pyVkhCVXdXVTFDY09GUnI5UUlQcjdRQU1qSFVwcHgydzBQRHA2?=
 =?utf-8?B?WUh5RjJhYno1RWlTK08xUEpuUExldFEyUThQSERxSis4VXNHTUxrZlJ6Mlhm?=
 =?utf-8?B?MEJCaDBKZlJFTVN0OGE5dWxtQTF5dzZwbHlDS2Zab3piVU5KVGdLZHYyclZn?=
 =?utf-8?B?QXZrZWNuTWlUWFFkWWFrZ1dPcFpYZjA2TVhaV2JkMWVoaWJWOGVqc0JOMy9y?=
 =?utf-8?B?akVlQWJINElsWTN0ZlN6Rlo4R2c5THk1VEx2YWh5bGg2TWZRZHZHVW5kOS9h?=
 =?utf-8?B?S1lwQ0NLclVDZmhxSXUvSjRubVJyT2toVkNyc3psQzNOUSs0MWJVZTd1eHg3?=
 =?utf-8?B?a21HQTBFcmtNV1NUTm84Y3RzRGh3cFVVeS84QTl6eXZmdHNIOTF1V1lqSTFp?=
 =?utf-8?Q?3FjOKW5HF0XxNyG10MsWiV+WC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31fe42f6-557a-40c4-6ac7-08db2f802286
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 11:32:38.4531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRUtwFbm+gRLPpT6hC0yVMvPSYCrs1itAwWRtEepfJhFamQcvM4JMelt6HzOJEpYT0IXGJ6VIFL+CNN11+LlhaJg8MdWvpKnTItWCzuLw9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8018
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjQgMi81XSB0dHk6IHNlcmlhbDogc2gtc2NpOiBGaXggUnggb24gUlovRzJMIFNDSQ0K
PiANCj4gT24gVHVlLCBNYXIgMjEsIDIwMjMgYXQgMTI6NDjigK9QTSBCaWp1IERhcyA8YmlqdS5k
YXMuanpAYnAucmVuZXNhcy5jb20+DQo+IHdyb3RlOg0KPiA+IFNDSSBJUCBvbiBSWi9HMkwgYWxp
a2UgU29DcyBkbyBub3QgbmVlZCByZWdzaGlmdCBjb21wYXJlZCB0byBvdGhlciBTQ0kNCj4gPiBJ
UHMgb24gdGhlIFNIIHBsYXRmb3JtLiBDdXJyZW50bHksIGl0IGRvZXMgcmVnc2hpZnQgYW5kIGNv
bmZpZ3VyaW5nIFJ4DQo+ID4gd3JvbmdseS4gRHJvcCBhZGRpbmcgcmVnc2hpZnQgZm9yIFJaL0cy
TCBhbGlrZSBTb0NzLg0KPiA+DQo+ID4gRml4ZXM6IGRmYzgwMzg3YWVmYiAoInNlcmlhbDogc2gt
c2NpOiBDb21wdXRlIHRoZSByZWdzaGlmdCB2YWx1ZSBmb3INCj4gPiBTQ0kgcG9ydHMiKQ0KPiA+
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMg
PGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+IHYzLT52NDoNCj4gPiAg
KiBVcGRhdGVkIHRoZSBmaXhlcyB0YWcNCj4gPiAgKiBSZXBsYWNlZCBzY2lfcG9ydC0+aXNfcnpf
c2NpIHdpdGggZGV2LT5kZXYub2Zfbm9kZSBhcyByZWdzaGlmdCBhcmUgb25seQ0KPiBuZWVkZWQN
Cj4gPiAgICBmb3Igc2g3NzB4L3NoNzc1MC9zaDc3NjAsIHdoaWNoIGRvbid0IHVzZSBEVCB5ZXQu
DQo+ID4gICogRHJvcHBlZCBpc19yel9zY2kgdmFyaWFibGUgZnJvbSBzdHJ1Y3Qgc2NpX3BvcnQu
DQo+IA0KPiBSZXZpZXdlZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGds
aWRlci5iZT4NCj4gDQo+IE9uZSBjYW4gd29uZGVyIGhvdyB0aGlzIGV2ZXIgd29ya2VkIG9uIERU
LWJhc2VkIEg4LzMwMC4uLg0KDQpZZXAsIGl0IGlzIGludGVyZXN0aW5nIHRvIHNlZSB3aGV0aGVy
IFNDSSBldmVyIHdvcmtlZCBvbiBEVC1iYXNlZCBIOC8zMDANCkFzc3VtaW5nIGl0IGhhcyBzYW1l
IHJlZ2lzdGVyIGxheW91dCBhcyBSWi9HMkwgU29DLg0KDQpDaGVlcnMsDQpCaWp1DQo=
