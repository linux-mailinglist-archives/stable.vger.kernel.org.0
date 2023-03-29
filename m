Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381456CD67A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjC2JcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjC2JcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:32:00 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2106.outbound.protection.outlook.com [40.107.113.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC6A40F8;
        Wed, 29 Mar 2023 02:31:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMRPTQ1NaBKge5CU3+WikIXdQ4Evqm1TqZ0Ng2cAgMV4piZKPfX8oBW7FJimEmgcQAJQ4XWQ40RApSrtEgsFu0NlHa8Wzp4ChTXF9KkJOLUCw6+xsXMy/0piLKegV7cacA/1sqrBrlSlVsJUjfVhjxLgZTwN2AeycKNOyfyh2a6orxbMi2S9343terLUzfEbWLYxoYMMLPWstskRMtncZR2kWhBE7zboH+lsQiXKeBf5sP2xq3YwR8cwamsSccJi3KTIEB2/7b4mJlSuILAjO48hitpWFc/kSQXZod9lUgKSGKPV7woYsJNPEoR+vBut8MvQ+h/7TKbdLqu54y87IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BOcEliGpeNV0OC6JUpl/dtdBKqKm3trU6WXpgz+2+Q=;
 b=MMXV3wgFAKV7m9Uv5jCzmtxKBSOxW2VUzcXewPFI77FKIoRBe0RLuuLNE1ut4bI9Cl4D8tR7dZVaqDueFf5Y8oJJQSqicBS9pFwozxLWNr5ga7jj02nSQgwbZ+RVRcTN2P28KZAF5jJqbzpL3HZc+Dg+2uKBHpJsaVZref4ul7ZbAqboLAL12XMdpCTrLla8e796NT+S2kJeLmdgBarioVEh0ZL1ns4Az2cOVckFFzUrrWgBZOyCrYMjTi+GueVMYyh4AXeCKrOrarMGNVxnx7xwyd8sX1dyJuzIQLkUpGk8zYaYLUkwhGxo8NIkpnFqpj9F1jf6g5/K395qnJ2/aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BOcEliGpeNV0OC6JUpl/dtdBKqKm3trU6WXpgz+2+Q=;
 b=ObT6cF6dp2DL2f9NHPDYl4LltptQtALEdhSv6SXSLpTzhGqANe1HNUTSv6WHwiHAU+647BIDaBqrWguAA3o17W7u7FoIlGH4v8NWqInr9VR1JX+m94P4rjbjf+hZ/lhd9F+RafbXpfW95jbroPHdONnZexKJhkvbUsCYq/iu6EM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYVPR01MB10718.jpnprd01.prod.outlook.com (2603:1096:400:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.34; Wed, 29 Mar
 2023 09:31:53 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6%8]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 09:31:53 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Thread-Topic: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Thread-Index: AQHZW+sFzUMpnEaLa0+ZQjsfAiDzca8OYYWAgAG4MaCAAWiSgIAAAOMggAAESoCAAAA7AA==
Date:   Wed, 29 Mar 2023 09:31:53 +0000
Message-ID: <OS0PR01MB59229C03DC95C34B755C2C2986899@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
 <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
 <OS0PR01MB5922092AD985055F7376611486889@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <ZCP-bdhw585BSKdx@kroah.com>
 <OS0PR01MB5922F0F9BB4D42C3E14F1A7A86899@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <ZCQCxQDwR1N4KT4r@kroah.com>
In-Reply-To: <ZCQCxQDwR1N4KT4r@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYVPR01MB10718:EE_
x-ms-office365-filtering-correlation-id: 6bab90fb-c155-40b8-8018-08db30386ec8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wGWdA+yg0s1DUs4SDG3acnZi7ws9/YoMF1NSr7tvkUR20LIFu5VFPkezfIP66bRJtbeUc3ajrEbYXz0m4jYQc3uT56upT+2x5pJ/AAyAakFpqIKi8dsWrmQugQpNHJ3oewhP8yhaOqfLE6rfDNMJAe0Xm+diqNLSvNkRFvpm6gV9fDeMQRfmMBZzz7nE6GMkT+AAduMgVz/KNcXLy+mLO+nBjIlThbMlF30vL/Z7Ns0L8QcscmAp87e5k0C1jgGM1jvzKA3Ymc7cqrMf8whr/JOFSHriwkSuS/wz94AJWlBtclnmfAcjqToxmFCGF5z+3shgVHP6YdY0wL9SDXeNrwLPpYqXGu1/orgb7FpqgF44FjAFBraCyfE2xBnjRhjfSqNU0u9Plrg065Is40rWTh88RPSV8cYxJNm4Mc26WhILG6bx8/RDW03uTMThyfS4r+sZJiRYRfUpmSeoy2zLsOoDUtZHeNOeXxGDlmaI3/6UTeZQUpSFAKsk/vbzTju59vkIaxgfG/Chhz7NvpKsFrxGYGH09UO9rIRwyQQqc8vmK/HWfvCw+EShBDxPmvaU3PdaR6TbFtmKPKyLQ2BiSVB7JWwC8spnQmNeKBJMnzc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199021)(33656002)(86362001)(55016003)(54906003)(316002)(7696005)(478600001)(71200400001)(8676002)(41300700001)(122000001)(83380400001)(52536014)(9686003)(66946007)(66556008)(4326008)(6506007)(66446008)(64756008)(76116006)(26005)(53546011)(186003)(66476007)(6916009)(966005)(38100700002)(2906002)(8936002)(5660300002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUhWd0VkNVpBV2tDY1NYc3ZDRmVBdGJrMlJYNm5OT2dhczZ5RU1JbTJqNWJx?=
 =?utf-8?B?RXJIYXZnNUJPSEJmK2tlazE0cHY2QWlNMTBGalU1a0dNVVRGZThZdkJwTUph?=
 =?utf-8?B?ZG9NMk00RTJ4ek9CUTFOMlNtT3dWcFcvZmc3RTl0UlQ2WUYzOUxRaktVVGt3?=
 =?utf-8?B?clNabStKOXB4VkhpRm5ybWlmU3dEOU8xWFBDNHpUdWM4UWxqQnl1ZDlTbHcx?=
 =?utf-8?B?cGMzQ2Jpc3AxVXJuNGZnanRGZnc5eHB1NzcwNjZZTXU4TXlvYWdIL2RaZ3ZH?=
 =?utf-8?B?VEp3eVlibFpBNXJzbmxuckJVbFBxejUvRTB3ZXc5NlNuSVJjcVNmdFBPbXpF?=
 =?utf-8?B?Qy93Si93SmlvSEtSYVF2V1JqU0MxeTFrdGM4UkY4VW9BQjNQN1oyTHROdkF1?=
 =?utf-8?B?MC9DMUJlYzdzVHVVM2FxSG1WUEZvTGZCMHJTRWloZVdmUWQxSFhrdzk5dXds?=
 =?utf-8?B?Ym1TWmRlWGxiNkhpZG91WmNuMnJzTDhVN1cwU0VMMi9YM1pySzZtaXBXQUVo?=
 =?utf-8?B?bHFPSE1CMVBFTVBJUy8zUjhBaW00RHZxZXpVUmlZQ3FoejIvWldtcFVlY3Rw?=
 =?utf-8?B?S1RWMUFzcW96NDlUK3JmQXUvQWo4T29VaisrWVVCWk1LR0VSbDdXNVJIMEJ3?=
 =?utf-8?B?SVZFUktJZC9qUkp4RXlmemN2TkNueTNNUnRUK0ppdFdPdkZ5aVVxMVVRRmdN?=
 =?utf-8?B?WlU2UUFzMzFNeVJpMHNmczFFaExnVEU1TVRtaHVmOUhrb0VTL3VHbXVnL0ww?=
 =?utf-8?B?QmtVRUdQczNRbHo4MGtvOENpQVBUQmlVZzRPTUw3NE1tWmVpTTVYakVTaS83?=
 =?utf-8?B?TGlNRjFvMG5Xc1FYczZ5V2lROERWZTYrMldWZEF0SWpnV1pCTnV4QW9hVnpI?=
 =?utf-8?B?VTBxL283MEFOZlEzek9xM1hrU0MwRjJJeXNyR0d3eXM2MmxQWTc3T0lvb1Bk?=
 =?utf-8?B?cXBhWm1leGtEdGM2SDBrbEtTQTBWeW5nSjRuc2dqNk5zOFlPaFVOc0lsMmZB?=
 =?utf-8?B?blB0SkIreHdPaXZTQWd4R1RLWFpLc1hGdjl6M1M1UkFTNWVkQ3ZQNkVWU3hY?=
 =?utf-8?B?SHdoc0ZIYVVwdWNGQjB5a2JWS2MrR0s1UVZrbUtmd0dMMVRod0hVUTlSTjFy?=
 =?utf-8?B?WWxjRlk2MVhKelpzU1k0dTJ6OFFXZmVkSnUxWFNrdDhBbDZhMm1uMEc4TmV1?=
 =?utf-8?B?U0E3MFJiZlZUOGY4UGxCOHVMMlU1ZmVkaFdVTkVYUkNHSFV5NHNHMG9VZ1dk?=
 =?utf-8?B?SWtNSHpFWG9vN2JTZXRyc3E3TVRkSVFqYUdxaDRmbHVNMDhUSE5QZGYvM2Y0?=
 =?utf-8?B?Mk5SYmdlV2UvRisxSnd5d2xSVyswTis3Rm0xcllmZEJGbFJFZEtMUCtNTkpS?=
 =?utf-8?B?Sk9CT3hHcnRwUmgvd2NmcTR3MjhRS0JpSk5WZlQyVFUrWTdWcG12SlYrOTFl?=
 =?utf-8?B?TnU5eFQwdFQyWTZmS0puOXNKc1dmN2MyTk1zcVh6bVR1eEhWenFlTVpweDRy?=
 =?utf-8?B?SDdpd3hHSWtwaGM4dmVPSERyaDRGQ0puVHJpV2NRSnhxdjZBV0o5dEdZK3Zi?=
 =?utf-8?B?azBDZlVMRHRnNHRlOHJKdktGVTllaEFWbXhUR2dBS0pQL1dBaUFVRW41UERJ?=
 =?utf-8?B?ZnZQV0orWFQ5bWpKQ0ZiLzNPOUhHM0dSOGcrQVBRZnh5ZDUybXFuQ2tTNCts?=
 =?utf-8?B?Q3BDdlIrQVVTT0JYSGsrMWRTdFFXT2ZaNEJVN21XcER5VEpFRzhuREdINlR6?=
 =?utf-8?B?MTdHMFN1Y25mWDVKS0F2bWRvS0pNUmhFYVQ3dHdFNmI3Sy9zYnk3cTRSN25o?=
 =?utf-8?B?UUJhN3ZMeGFhVzJuOHJBaTNBbzFPSWRHcFk0Tk5wdVdVVSszNTU5OEtKa01O?=
 =?utf-8?B?cUFTUGdTc3FEWDdwMTI4dkIrZkJkT1l5eHYrL0h6eWl1R1VQbE5lVTRmMGwv?=
 =?utf-8?B?R1VDWmFkc2FWUW93Si9FY01jMnJKaGV4NGYwWWNPS2ZjM2s3bHFmaEpGSXg1?=
 =?utf-8?B?U2c2RUxjRXMwUzJyY1FPTmt4Z3ZpdWJXcTlmbkJ2SUlERW1XTnpwTTFoRkN5?=
 =?utf-8?B?MHBZUnFRelV2bUYwMG9rWiszd1cxT3pkT21LTitFTE15WVhUaDJRbDJNb1lk?=
 =?utf-8?Q?vsYzObyGE0gxubcc9aGI0ZaVP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bab90fb-c155-40b8-8018-08db30386ec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 09:31:53.7848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8cUc3S94Zdb4ifWT3ZU2LJOR0CkWGgV1r2aCMO4O6bwndgF/Fh9zDBpWUO2zJnWfjh0T84Gibk2H96sw98SYa9GU5NSVUr7XdAtkPL0xn5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB10718
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDIvNV0gdHR5OiBzZXJpYWw6IHNo
LXNjaTogRml4IFJ4IG9uIFJaL0cyTCBTQ0kNCj4gDQo+IE9uIFdlZCwgTWFyIDI5LCAyMDIzIGF0
IDA5OjA2OjQzQU0gKzAwMDAsIEJpanUgRGFzIHdyb3RlOg0KPiA+IEhpIEdyZWcsDQo+ID4NCj4g
PiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRD
SCB2NCAyLzVdIHR0eTogc2VyaWFsOiBzaC1zY2k6IEZpeCBSeCBvbiBSWi9HMkwNCj4gPiA+IFND
SQ0KPiA+ID4NCj4gPiA+IE9uIFR1ZSwgTWFyIDI4LCAyMDIzIGF0IDExOjMyOjM4QU0gKzAwMDAs
IEJpanUgRGFzIHdyb3RlOg0KPiA+ID4gPiBIaSBHZWVydCwNCj4gPiA+ID4NCj4gPiA+ID4gVGhh
bmtzIGZvciB0aGUgZmVlZGJhY2suDQo+ID4gPiA+DQo+ID4gPiA+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2NCAyLzVdIHR0eTogc2VyaWFsOiBzaC1zY2k6IEZpeCBSeCBvbg0KPiA+ID4gPiA+IFJa
L0cyTCBTQ0kNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE9uIFR1ZSwgTWFyIDIxLCAyMDIzIGF0IDEy
OjQ44oCvUE0gQmlqdSBEYXMNCj4gPiA+ID4gPiA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+
DQo+ID4gPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4gPiBTQ0kgSVAgb24gUlovRzJMIGFsaWtlIFNv
Q3MgZG8gbm90IG5lZWQgcmVnc2hpZnQgY29tcGFyZWQgdG8NCj4gPiA+ID4gPiA+IG90aGVyIFND
SSBJUHMgb24gdGhlIFNIIHBsYXRmb3JtLiBDdXJyZW50bHksIGl0IGRvZXMgcmVnc2hpZnQNCj4g
PiA+ID4gPiA+IGFuZCBjb25maWd1cmluZyBSeCB3cm9uZ2x5LiBEcm9wIGFkZGluZyByZWdzaGlm
dCBmb3IgUlovRzJMIGFsaWtlDQo+IFNvQ3MuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gRml4
ZXM6IGRmYzgwMzg3YWVmYiAoInNlcmlhbDogc2gtc2NpOiBDb21wdXRlIHRoZSByZWdzaGlmdA0K
PiA+ID4gPiA+ID4gdmFsdWUgZm9yIFNDSSBwb3J0cyIpDQo+ID4gPiA+ID4gPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJp
anUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gPiB2
My0+djQ6DQo+ID4gPiA+ID4gPiAgKiBVcGRhdGVkIHRoZSBmaXhlcyB0YWcNCj4gPiA+ID4gPiA+
ICAqIFJlcGxhY2VkIHNjaV9wb3J0LT5pc19yel9zY2kgd2l0aCBkZXYtPmRldi5vZl9ub2RlIGFz
DQo+ID4gPiA+ID4gPiByZWdzaGlmdCBhcmUgb25seQ0KPiA+ID4gPiA+IG5lZWRlZA0KPiA+ID4g
PiA+ID4gICAgZm9yIHNoNzcweC9zaDc3NTAvc2g3NzYwLCB3aGljaCBkb24ndCB1c2UgRFQgeWV0
Lg0KPiA+ID4gPiA+ID4gICogRHJvcHBlZCBpc19yel9zY2kgdmFyaWFibGUgZnJvbSBzdHJ1Y3Qg
c2NpX3BvcnQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBSZXZpZXdlZC1ieTogR2VlcnQgVXl0dGVy
aG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE9u
ZSBjYW4gd29uZGVyIGhvdyB0aGlzIGV2ZXIgd29ya2VkIG9uIERULWJhc2VkIEg4LzMwMC4uLg0K
PiA+ID4gPg0KPiA+ID4gPiBZZXAsIGl0IGlzIGludGVyZXN0aW5nIHRvIHNlZSB3aGV0aGVyIFND
SSBldmVyIHdvcmtlZCBvbiBEVC1iYXNlZA0KPiA+ID4gPiBIOC8zMDAgQXNzdW1pbmcgaXQgaGFz
IHNhbWUgcmVnaXN0ZXIgbGF5b3V0IGFzIFJaL0cyTCBTb0MuDQo+ID4gPg0KPiA+ID4gVGhpcyBp
cyBhbHJlYWR5IGluIExpbnVzJ3MgdHJlZSBub3csIHJpZ2h0Pw0KPiA+DQo+ID4gQXMgcGVyIHRo
ZSBkaXNjdXNzaW9uIHdpdGggR2VlcnQsIEl0IGlzIGJlZW4gcmVtb3ZlZCBzaW5jZSAyMDIyLiBZ
ZXMsIEl0DQo+IGlzIHByZXNlbnQgaW4gYmFja3BvcnRzLg0KPiA+DQo+ID4gR2VlcnQsIHBsZWFz
ZSBjb3JyZWN0IG1lIElmIEkgYW0gd3JvbmcuDQo+IA0KPiBTZWVtcyB0byBub3QgYXBwbHkgYWdh
aW5zdCA2LjMtcmMzIDooDQoNCk9LLCBPbmx5IEg4LzMwMCBzdXBwb3J0IGlzIHJlbW92ZWQgaW4g
MjAyMi4gQnV0IHdlIGhhdmUgUlovRzJMIGFsaWtlIFNvQ3MgdGhhdA0KbmVlZHMgdGhpcyBmaXgu
IFNDSSBzdXBwb3J0IGZvciBSWi9HMkwgU29DcyBpbiBEVFsxXSBhcmUgcHJlc2VudCBzaW5jZSA1
LjE3ICsuDQoNClsxXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9zdGFibGUvbGludXguZ2l0L3RyZWUvYXJjaC9hcm02NC9ib290L2R0cy9yZW5lc2FzL3I5
YTA3ZzA0NC5kdHNpP2g9bGludXgtNS4xNy55I24zOTMNCg0KQ2hlZXJzLA0KQmlqdQ0KDQo=
