Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC7A6CD5F3
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjC2JHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjC2JGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:06:49 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2138.outbound.protection.outlook.com [40.107.114.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F8A49C6;
        Wed, 29 Mar 2023 02:06:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uokd5vAW+hvpF4T+yekQGfVQW6yetQQ8MCwhvpFZF6A3kggHdYsYGV1uNtLuxVTaJ5TQwM1OccbU/iQbn3nF3jYGkj5rg9O0brZVDHr8r3Meo5NzTqYO4hivwHVQg9kYjpIwlTzyr9V55fQfVAAwmrXYi0Y0OWCJkv8JxZuoEDNG4Y/hH6qv8KXo3XGTfHuFmlZhGi2c6Yo7ZAkkFEpv4P2fVbh2CnAXx75yG20tY8aavXN+XxydO7zKWDA91Y82VLS3uwmD3CNHBS7k8Kt0lE1rBu+mfqomq5SG58s3/9gDbHCgAzw0zcwdX8WpPLXBCu3GqvlMVTaMKmfhfpcMTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6s2fcv8zLu9mEc/UsG0/QF0s61YAOoyQ3dSrA9M+gE=;
 b=MajzIzMolFuZtu8I04sz4e0ExiiBV/VH0KJwUkBU1w+rJVffoY31s4WwtbPwxDGDHs8gCO2oK6GpRnjFWOfgdZytLx5Tyu5SyjhpuFCZ+yXGc4Wludc6icy5KtUtE7iBB9GXYkN3z3/QZc9kpAQvLBXEZHG86roLylP0hNG6S0SJRFtTqNtFm4x/bbv9KUzzJR47aRMsSIkb/zVKyahi99nuqwkwsE0uPFrn3Zop9QCOHDVMV7sf5q75nRPeThtDvL8g8GdE4AtPqWPUdyaCKmKg2pIgadFrx/FGmOOm+B7CcDM9wbdp+wVf74en1eqt6UtpZw/mf7qnNiiOsqAo8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6s2fcv8zLu9mEc/UsG0/QF0s61YAOoyQ3dSrA9M+gE=;
 b=faPLnSKEftgbIHRomwtvCYmgD/pPZze/69HG1GcE2VudYIOP8qlG1SfZWyOpLGbyMFFm9QHk+Qbx7yv9pO/wSuDo7D8CMg7PBl6FqBGecfjtbqAhg+IDhilCLwEvhJOnqB+updCpvzXNXhu81Dla6Xp6spO0JqEVuBQBTU5L9zM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5943.jpnprd01.prod.outlook.com (2603:1096:604:c4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.34; Wed, 29 Mar
 2023 09:06:44 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e521:994c:bb0e:9bf6%8]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 09:06:43 +0000
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
Thread-Index: AQHZW+sFzUMpnEaLa0+ZQjsfAiDzca8OYYWAgAG4MaCAAWiSgIAAAOMg
Date:   Wed, 29 Mar 2023 09:06:43 +0000
Message-ID: <OS0PR01MB5922F0F9BB4D42C3E14F1A7A86899@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
 <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
 <OS0PR01MB5922092AD985055F7376611486889@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <ZCP-bdhw585BSKdx@kroah.com>
In-Reply-To: <ZCP-bdhw585BSKdx@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB5943:EE_
x-ms-office365-filtering-correlation-id: 525df118-91f6-40d6-9fec-08db3034ead4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: URukM8Zw1oK98vvKMVLFJQ7OR4ndtVePtfS3nHOfihrDCDJCFe4W+nnJEO6qxpGNZEA1y5cGoZA3yEjnZi+icQDYiNbOL8K2s54fHcmSuL3+AX80e9LHirdTofgu0ZEfnV+0vswhCu4yFHv5ZGHZxGI8XCU2SqujTt7S0gYyKQNXMoO/rd210HOugzJWFxTOFiDkI+22/UvFS/EUXPH/2Y4LJ3GUZn9Qvo78X73DR8ckEiN/1w08RnH8+uGcxw4ATOrvfkPwBJB0/7FIMC86IZ2GQsivxqtIc1hVWTxExnl5ecXPGtyy2cRRee37k30m35r97s25stUVwbPVdh9NObbDmkSTd+rgPu45MCwBK287VBRAltc1UFmt/BWzyoqMWsjXaixJwg9Abs2hq7ujl+4e9ezBj8Uo2hf+YX0BEM08gpidDElUoxjVXOf6lHZ9JNZiKPSrK6607IzpIrCRW8amhzSUs0NmwZfx2dT7WchCOiIw9P6Tw3n3XBYMo+a6gdorGF4OMablYZzYqIQ+gmrN8rXbWmTwLHU4IppDpz8HEwrSYjTGUZBmwg2Ex+xE1UhJ6FM26ekBHSGDgR3fOYWahbH4HL53sYV4XTiz7u+I8jyOMn1IBBILvsK8e3KT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199021)(33656002)(86362001)(55016003)(54906003)(316002)(478600001)(7696005)(71200400001)(6916009)(122000001)(83380400001)(41300700001)(52536014)(66446008)(66476007)(4326008)(9686003)(66556008)(26005)(6506007)(76116006)(64756008)(53546011)(66946007)(186003)(8676002)(2906002)(38100700002)(8936002)(5660300002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emdkVS9PMEVFWmlIT3R2NjNaMmFiVk9HMW1OZkVzSERKNU5iTmxpOEdyS1lw?=
 =?utf-8?B?a3laNzFlK2Y5MDlOV05ieFJ4d2V0UE93RFU1dUMwQUJWSTJ0MmFLTzc0ekFm?=
 =?utf-8?B?WXlGZmNDaWFyRzh0RXRtaDI3WWRtY1dCN04wY1IvY3hrbU1hcGdxNUJ4ZGJW?=
 =?utf-8?B?Z0RBMkRlYUxRaVhRMlg2V3RETGs0MEV6bzc1aDdROVdGc09lTmxWZi9MbE9J?=
 =?utf-8?B?VTlocDVqNmc2aGpoVkxCOUxLZE1MUjZxNFo0eGdKQ2Y0bkhJSklvSVpQL0du?=
 =?utf-8?B?NlE1V0dkZEEvS1BvREp6Y2o2eGNXUWdjWGlYTkdhKzVEYVBkRTU3bytiRXNW?=
 =?utf-8?B?d1BzcnpIRjJBdUsvaFVTNytUVDg3VTk1LzMxbjNIc1d0V3VFYm56UFU4U3p4?=
 =?utf-8?B?alV2VTlvL1VpUk0ya1JzSG1Yb3Z3MmFuL1JYbXh2UXB6R2VDVzRscnY5amFv?=
 =?utf-8?B?WjZIY1ZDa3V2RVloOFJKTGNxVEoxa0swNGMvQWdNSUM1dVVYTnJxejBXdzg5?=
 =?utf-8?B?dGxicUV4Zk9lNTU2Vm9SYUIvMEE2cUE5d3JMNkRlNk9rS3VzZUNCNkFCZjRu?=
 =?utf-8?B?OUFIbWtGeC9JODA1UHl0QlQycytCc3lxUnU4OVYrb2IwRWNkNWFKVHg2dHc0?=
 =?utf-8?B?Y3ozYlAyNUt6c2NhdVZNbWNtUTk5WnQrVFFYVXBvVWtia21OTDVwY2ZHSEdE?=
 =?utf-8?B?Wk9raEtNL3BZbDA1U3Z0Umc3VFZ1eGwxQlpWeVNtVjlEZE4yUE0xa29tNEE3?=
 =?utf-8?B?dlpBS3AxdmxPN0hqcCtBRUU4NmxZdEU2MzJtV2lCVk5IS3VtNXRsUjlrUGhi?=
 =?utf-8?B?UEZQN1I3cTR3bzJKSTB3TE9xdjhXc1NLaWRuUjFjbFh5dHJCOU1uODgyZk44?=
 =?utf-8?B?Y3VZZUMwNVk2R2czQWhoMjBZd284TGtCN0VGNjlsQTF6NURKNzVHRXA5Wmpq?=
 =?utf-8?B?alVtZ0dYN2p3OE5TTk5ubHdPSFhnbDA4UVBCV05HZ1dIM3BlT3ppQmlXTSt4?=
 =?utf-8?B?Q3J3QTNlWGhqanViVWowMzB2dGxSWjJxYUQ3SnRMUHJnRnByQzEzMjlFS2FF?=
 =?utf-8?B?bERqYTllZk9OUWVCRzNUTy9iM0RCcmJtaUNnZTNhZGd4NFUzbEo5NkU3K3Jw?=
 =?utf-8?B?K2ZoVnJWeVBPL291NXNuK0c4b2ZHY2tjTUk2dFZyUU1GeTlic0F2cHIyL1BY?=
 =?utf-8?B?R08wWVZ1cDBlY3owektPSERxWFFYazdtNXlNblozMUhZNyt1bXRFVkloTHNO?=
 =?utf-8?B?dG1IWTRnUTVNMWxxSTdPVllSRVAwZGdkWGpRRU9aYWVmWDQ3OENmbG1BdEdj?=
 =?utf-8?B?clhVYllBajhPVms0bWFCNXFISXpNSVlnYWJNUll5VVRhS25TOXZZWWZuQXN0?=
 =?utf-8?B?WVJLUElFRWU2dGRyQk1jbnJiUERMUFNqOFZBM0diZW9BQXNJZTBpc2phWlZr?=
 =?utf-8?B?bVZ2OVl1cXVGdmZ2VkVqQ3RkNEVSOGZsQStHdTQweUZPdzhqdlJOUUN3cHFt?=
 =?utf-8?B?VHdrUEtYVkdKTEVaTlAyd0taNmZhRlVKMUNPL216Mm93aVppMmNOa2cxOHYy?=
 =?utf-8?B?eDArc2hoOFlCbEZHcjJLUUh6TDZzcEVhdXdRM1VEakc2aGRuYy96c0xXajlV?=
 =?utf-8?B?NEFGODBONUVkZ2xlWmdNaC96WW1McVFuY0JVMzAxV0w0RE1hSHhhMVdHRjdy?=
 =?utf-8?B?NlhzUnBFdFlBMTM0L0p0WFFqRm84UlNJeDJwZU5XODdlc0dqcEFrQnFZWTJ5?=
 =?utf-8?B?YjRYN2Jlc0J4NXJCUlA3QU1xZmZjUkRwZnNaeWtwTHNveVdqSW5LRnNIdjBD?=
 =?utf-8?B?cDhsbWZFT1dnODlGLzVwNkkwNm92UUluVmgzd1dxb2ttenJJZ1BHZlFpUTkw?=
 =?utf-8?B?WldRRCtTOG0zYkFCSGJYREpZak5sRkhoUGpYL0tOQ3NHOHFQR2FnQ3hJSkcz?=
 =?utf-8?B?MVhRSVZ0Ulp2ejhCRzBWWk5WRlpEdUFLdmtxUUJpampGZDBicFNkME9yUGN2?=
 =?utf-8?B?NUUyajNDYUgrU2RJYi9BTHZJR3pvcFd6ZnltVGh2a0w4RkV0Z1cvYUZQRm85?=
 =?utf-8?B?NUVwUy96Nng2WmZockpieHNwSkhDcFFRR09GTTc0SXJKeDYxSVdZRjJpUE80?=
 =?utf-8?Q?xTJpuiArcrv4yjti8myHRe859?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525df118-91f6-40d6-9fec-08db3034ead4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 09:06:43.8816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iW/o+CcPDCx2aVYY3QZePG2wmP1+xI/HM/CT68zerCBjcDIqfm5P6jFnni3u85jVl+CdagUWYxXeQxZN1K4wDd5LasBNWF2Volc3167/kzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5943
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2NCAyLzVdIHR0eTogc2VyaWFsOiBzaC1zY2k6IEZpeCBSeCBvbiBSWi9HMkwgU0NJDQo+
IA0KPiBPbiBUdWUsIE1hciAyOCwgMjAyMyBhdCAxMTozMjozOEFNICswMDAwLCBCaWp1IERhcyB3
cm90ZToNCj4gPiBIaSBHZWVydCwNCj4gPg0KPiA+IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0K
PiA+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDIvNV0gdHR5OiBzZXJpYWw6IHNoLXNj
aTogRml4IFJ4IG9uIFJaL0cyTA0KPiA+ID4gU0NJDQo+ID4gPg0KPiA+ID4gT24gVHVlLCBNYXIg
MjEsIDIwMjMgYXQgMTI6NDjigK9QTSBCaWp1IERhcw0KPiA+ID4gPGJpanUuZGFzLmp6QGJwLnJl
bmVzYXMuY29tPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+IFNDSSBJUCBvbiBSWi9HMkwgYWxpa2Ug
U29DcyBkbyBub3QgbmVlZCByZWdzaGlmdCBjb21wYXJlZCB0byBvdGhlcg0KPiA+ID4gPiBTQ0kg
SVBzIG9uIHRoZSBTSCBwbGF0Zm9ybS4gQ3VycmVudGx5LCBpdCBkb2VzIHJlZ3NoaWZ0IGFuZA0K
PiA+ID4gPiBjb25maWd1cmluZyBSeCB3cm9uZ2x5LiBEcm9wIGFkZGluZyByZWdzaGlmdCBmb3Ig
UlovRzJMIGFsaWtlIFNvQ3MuDQo+ID4gPiA+DQo+ID4gPiA+IEZpeGVzOiBkZmM4MDM4N2FlZmIg
KCJzZXJpYWw6IHNoLXNjaTogQ29tcHV0ZSB0aGUgcmVnc2hpZnQgdmFsdWUNCj4gPiA+ID4gZm9y
IFNDSSBwb3J0cyIpDQo+ID4gPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gPiA+
IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4g
PiA+ID4gLS0tDQo+ID4gPiA+IHYzLT52NDoNCj4gPiA+ID4gICogVXBkYXRlZCB0aGUgZml4ZXMg
dGFnDQo+ID4gPiA+ICAqIFJlcGxhY2VkIHNjaV9wb3J0LT5pc19yel9zY2kgd2l0aCBkZXYtPmRl
di5vZl9ub2RlIGFzIHJlZ3NoaWZ0DQo+ID4gPiA+IGFyZSBvbmx5DQo+ID4gPiBuZWVkZWQNCj4g
PiA+ID4gICAgZm9yIHNoNzcweC9zaDc3NTAvc2g3NzYwLCB3aGljaCBkb24ndCB1c2UgRFQgeWV0
Lg0KPiA+ID4gPiAgKiBEcm9wcGVkIGlzX3J6X3NjaSB2YXJpYWJsZSBmcm9tIHN0cnVjdCBzY2lf
cG9ydC4NCj4gPiA+DQo+ID4gPiBSZXZpZXdlZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVy
dCtyZW5lc2FzQGdsaWRlci5iZT4NCj4gPiA+DQo+ID4gPiBPbmUgY2FuIHdvbmRlciBob3cgdGhp
cyBldmVyIHdvcmtlZCBvbiBEVC1iYXNlZCBIOC8zMDAuLi4NCj4gPg0KPiA+IFllcCwgaXQgaXMg
aW50ZXJlc3RpbmcgdG8gc2VlIHdoZXRoZXIgU0NJIGV2ZXIgd29ya2VkIG9uIERULWJhc2VkDQo+
ID4gSDgvMzAwIEFzc3VtaW5nIGl0IGhhcyBzYW1lIHJlZ2lzdGVyIGxheW91dCBhcyBSWi9HMkwg
U29DLg0KPiANCj4gVGhpcyBpcyBhbHJlYWR5IGluIExpbnVzJ3MgdHJlZSBub3csIHJpZ2h0Pw0K
DQpBcyBwZXIgdGhlIGRpc2N1c3Npb24gd2l0aCBHZWVydCwgSXQgaXMgYmVlbiByZW1vdmVkIHNp
bmNlIDIwMjIuIFllcywgSXQgaXMgcHJlc2VudCBpbiBiYWNrcG9ydHMuDQoNCkdlZXJ0LCBwbGVh
c2UgY29ycmVjdCBtZSBJZiBJIGFtIHdyb25nLg0KDQpDaGVlcnMsDQpCaWp1DQo=
