Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568166A766B
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 22:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCAVvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 16:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCAVvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 16:51:44 -0500
Received: from CO1PR02CU001-vft-obe.outbound.protection.outlook.com (mail-westus2azon11011003.outbound.protection.outlook.com [52.101.47.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0B35328A
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 13:51:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlIjhWWApfWXAf7eHuDcpYqipZXzmpVygUBKIRB62SPGKwj2E4nmzVY6hMZOI6H64ZMqX4gv2S1mDr51rw2gpmZjouSsLCbm5ETVW6rdGIIMnyK2qG6lUH+LjCWyBhCjT1l13dvokJFFPBg22H4FBaVHdsgyLwL3XPVYXOTDMp08bzrEv1QUHthxGHE9y3aQ6hAmWD5UA8P1qYVhg3NhvM5i51mnftxyqsUVhazkMH+/HSJVxdwCG9DuVHgc0WunITPG7u68hTlD50++pLB1vz16Khq5IUOv0ObFcMLb7HLNBM7YH6H+mTRdOxt73DLC4JLMUFXYXwOU1Pegezu7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZ7tq8D/sSjDb+qZDIQyaE/lkCkfQ7H/u8v0KM9k7bI=;
 b=EqFavIZiBfQwbELshD2r/1JuqKctd7JbrD1P23gbO6QyCKBwxXEftQo7SLts+m784/5gmyhN24oJzhU1ru9jGULDUt3JHEhqt2iA+k/nNaUlashpXI6IbqOKNdYYNBDNBZLhiBQ4N1Y26JZYtkWoj0Xr0bzAwHRJYu/k2QsN0bF9Cx9O2j2n/OSkmchdfOwPz9sKMtOWg6vkRG0yqzAELq0mS4UwxFMS00SxAkRJB/eRik3BQVEyJUoIa22cV7J/DTGZTFbLKFrcbhlAIJgLFpdGewbvbCkiJ9IWOituydQZqHjrCI5sCs30EoQgO3w2WhJq0noGaZ2+ByF0eov9VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZ7tq8D/sSjDb+qZDIQyaE/lkCkfQ7H/u8v0KM9k7bI=;
 b=ryOL/jwp7itVYeKGt4QxrqcGOPQoT8LXvphb9+t2q/wgtOmkZ6nFwRPEuAfjY8fKNE0GavFPSkhJHpFlPY1THCcst6xKazveLS4qBsqSxGLRQ7M91yrMdvcBnwno38YlGqOP4T9cZwP/aBVP7Th5gUHPTQHL7LRLeAtEzFYsj18=
Received: from CH3PR05MB10206.namprd05.prod.outlook.com
 (2603:10b6:610:155::10) by PH0PR05MB8381.namprd05.prod.outlook.com
 (2603:10b6:510:c4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 21:50:36 +0000
Received: from CH3PR05MB10206.namprd05.prod.outlook.com
 ([fe80::ad2d:cb08:253b:26e7]) by CH3PR05MB10206.namprd05.prod.outlook.com
 ([fe80::ad2d:cb08:253b:26e7%8]) with mapi id 15.20.6134.029; Wed, 1 Mar 2023
 21:50:36 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "daniel@ffwll.ch" <daniel@ffwll.ch>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "airlied@gmail.com" <airlied@gmail.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/vmwgfx: Avoid NULL-ptr dereference in
 vmw_cmd_dx_define_query()
Thread-Topic: [PATCH] drm/vmwgfx: Avoid NULL-ptr dereference in
 vmw_cmd_dx_define_query()
Thread-Index: AQHZTFf7HMiYjLzIakeRza3EfbziCK7mdwSA
Date:   Wed, 1 Mar 2023 21:50:36 +0000
Message-ID: <125951394658e9eea838c925f47dfffb40102a2f.camel@vmware.com>
References: <20230301160748.20775-1-tzimmermann@suse.de>
In-Reply-To: <20230301160748.20775-1-tzimmermann@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR05MB10206:EE_|PH0PR05MB8381:EE_
x-ms-office365-filtering-correlation-id: adc65e3c-42f3-4b81-b185-08db1a9efd63
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bxd3Gkiw0BXx8yOqgAZbUPea9tgWd1VzcPDWZXvnbQ7yJNVA/0QpgL1D+affETZd4/wlGVMAqyZjGiQsFrrYa3C4v+nxpFwHVZgEuU/0xhCk2Hhibkogm78Sk6ISDZ02xPuuCLDXKSbxmdGYLwwcJF/1iPuzjwX1pqPdHM4PLKRfuMlgIAfX1I4KnrCpiS0o9MEuBTr0EQYZzHpU1hHpVYBS6J/TALhl01DGIsQrN4sHOoTYBsvGPs8iVN8uhYuqA+AuX4b1OY8TX7ik+89CQGZVVCmGUokZQqdiI0Sunt1RP8BnKjwDupfMZ5mWNBc49RSCObvlyc6sZi2XEKSDvrXp3wugvSqyKqhKo1fLUYrioFsQBnAtHaef2tHuqGtdC4pwb4rMU/j45+wpUIxeTjlrRwN/Z4Q0yvK6Mbaq1PtdwnldaJyIDWTI8Ica6cqHUnm5RpMBnVCbC0Qcu099giMcwxpzxEYF8fK/SzU2nDlT9n2WA23JhqjRoZlu6QuQhRp9MW2P+s50Tx3Iyjd+wFdC7hjDUHcv7Ivll/yS16YA1UFG+31OcI+/IvQ1QgANybV5jczsM9Phx94lkZ0Q+LLUn+VwvOHQ46MRTgIvw5QWMwfo43e2l3S9u3G3DCueYxPXRf/zIcQT1yUoXSh/1fs19xtzMG2/be9upJduQ0QIQXFBV0oORs1Wjk3vO5cZ4JGPZRB+SWHh62gsHS7yMKC9UNeOfSt1Rsw/4xIB4ixFftaNGiMtiiDJEz+f6xKG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR05MB10206.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(36756003)(86362001)(5660300002)(4326008)(66946007)(66476007)(66446008)(64756008)(41300700001)(66556008)(8676002)(2906002)(38100700002)(38070700005)(8936002)(122000001)(71200400001)(966005)(6486002)(91956017)(316002)(478600001)(54906003)(76116006)(110136005)(186003)(26005)(83380400001)(6512007)(6506007)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU1Ba0JlcDNRVnVVQzlnNmNsOXBkTlI2WFN0TTZQbHlrMzRWR2x2V3kzS2o0?=
 =?utf-8?B?VStZeHE5VS90Y0V1RHVzL3RiallBZ3hzdS9ERVZuTWhOYmpEdXhCRzZKR2lj?=
 =?utf-8?B?UzFoSGd0dFc3YWVBeTUwakU2VHhreGFDcC9tNmtXeUxKVnl4ZmVVeXhwclZ4?=
 =?utf-8?B?bEgwRWVRV2hnQU1IL3RYemFLdWNYWk0xVU1xamlhM0VRcHZpUGRPMTRGOFRP?=
 =?utf-8?B?cDRuV29VclZOK2R2QjBJSnA4OTUvNkhZN3J0aUcrTENSYlhXaHIxS1c2d1JK?=
 =?utf-8?B?Z01wb29aSm1kTFFGMFFzRThUMnpVWmpkZnpoaGlUQUFFdk5jTFM5VDk5bkZR?=
 =?utf-8?B?T2tKcm4reTh1R2FLS0VzYUtOdW9jeTdveDF0cXBHbDl1QlFEZFA2N0xYemVo?=
 =?utf-8?B?Tm1VSUVxSlg1RWxOc3F3cHBrYkR6MVdENFA1eCs4SFBFcVpKQkhOMUhSbnVm?=
 =?utf-8?B?a1JONVgxMU5BOXR3Wng2dXVtOTRzbWh3eU13aTI3YUNOQW9vZFA3REhFd1Fx?=
 =?utf-8?B?K2JCSGExRUdoc1E2ckZkQk93RGt4OWxQY2Q2S1hROS90NlJ6d2t4K1Nzamkr?=
 =?utf-8?B?ajlkOE5zYkV1Y01tZVJXNlVxdmpyYytVUWdHWEYvcGV3TXhqMjYvd29zY2s5?=
 =?utf-8?B?VElyQzhsbWxQSVFsN1ExaGVLMmJiOGZPUnQ5L3A2UjBRKzIyVlBtcnJ6Z2ZT?=
 =?utf-8?B?Z3RkUGJycHllbDYrSWtxbWRqaCtZdndYa3hhQmZRR3Z6N0lWUHJYSzdtWUwr?=
 =?utf-8?B?Kyt3amo2eFROUzFMcTAyOXhlSTQ1TW1GUjVKcnB1TjlSU2VDQ1h6YXBhOGV0?=
 =?utf-8?B?cExJUXVhMndFOWJpd2xKdnpKTTcrVkl1cVhNSTY1OTZHQXBuem1VdWl2OXZI?=
 =?utf-8?B?Vlo1K2hORDlNZEYvZVdBSE9mV1BjcjNtcWEwSTBmYnBIbW5uU2llM3NVMnVQ?=
 =?utf-8?B?WnZVaFI5SnJVUFluU3hlb3NWMWthN21VMHZMOHdWZ2I1K3NGSlMwc2VORFRz?=
 =?utf-8?B?ZFd0K2k0amVKS1lqdVMyRDQ1cFFEb0dCV2R4Rlo1MFpGSU0yWTl2L283OS9S?=
 =?utf-8?B?a1Fublc4NTlBRzBwSXQwTS80dkJjWTZNbG9yTElsbmR3R1R3VDZzK293ZkVx?=
 =?utf-8?B?eTdJaTZLMDVJT3N2WlBDODBmSXZiemI3ZjEvUzdUQ2puVFFZUWJsUGg2TjB5?=
 =?utf-8?B?WTFwZjFQRHJTV3NVdGsvWDNtQXF3VjBXdVlXeW5CNEd6cFM1NmZCL3RablFa?=
 =?utf-8?B?TnVUYzM0UVZObElTWTZ5L21wRkQ0TzVjQ3NLbFcxUFV2bTJnVXVuYU5saTkz?=
 =?utf-8?B?OVdzTEozNEtyL3lkWGZhTzhRWlVWYUg4ME1yUWlQZXdCNTdjUmlxUGN5a0Ew?=
 =?utf-8?B?d3NZcHkyaC81VzRWb204NnpjM3pZd0hrQzg5b3BnUWVDUkx1WlFVQm9IUklh?=
 =?utf-8?B?dzNSUUM4d1BWVGpnWGUrYTRTbDFxSitpSGNvUC93MkdyUGlmZTQ0SG4ydWZZ?=
 =?utf-8?B?ejJMVGk0cW9qY1hvbU5HQi8rWmdIYjJVRG5kbXhtRWZzQ3ZYd05majZhbmVv?=
 =?utf-8?B?NkQ4OHRJaEJyVHNBOVpsWDQ1M1ZGazBTVS9mckovUmY2QUFETFA0NUNpd0JV?=
 =?utf-8?B?Q01YYVRGekhBaUNLdjQrdEZMMkYwSkdyTDVObnEwUytPQk5xWDA0UEVnOGNu?=
 =?utf-8?B?LzgwRVNsMkJSSFJmVnhoa2ZwNUtPbDI5MURPeCtDbDB2L2ZjdGR0bXBHdFVG?=
 =?utf-8?B?VldJZEh4b0srandqVE04cXgza2VZdGpFUTgyVko3QWJValNUbE9MMG9yQjVj?=
 =?utf-8?B?YzEwd3BzYytCMDQvc2grUGFySzVCSHpHM2hldFE1UnpNSW5xamR3SFhkVUFQ?=
 =?utf-8?B?V3d1YnJkZTBydVNZT24zL2NwK214czFPZ2JiOEYwT2NuQzlKVEgrQVBweFVZ?=
 =?utf-8?B?OHBxekpudGRBMmIrU2ZRMjhUN2JHOU5SSXl6MmpGb3MxMENpN2g0YjV1U2xD?=
 =?utf-8?B?bFhTOXUvU0RBc3lnM0R1R0dxb29LQXpUOC9KVmZzUmFsWGJqUzFjZzhQdVpD?=
 =?utf-8?B?NzBOL3dMU3NBU3R4RW9xK1JsVTQ4UFN4VCtoR2c4MVRYYi8zS3poV1pPVFd6?=
 =?utf-8?Q?Bs81jXwEqoLt42isGRyWJlE6+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF353330BC42DA409AC45E40DA997945@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR05MB10206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc65e3c-42f3-4b81-b185-08db1a9efd63
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 21:50:36.0912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7WnNMF2m4IxsaXRPbHoEktiXpq8iwqPIO0YCgf2UzmyU+mtOKLmWZlzSMlFPZBEXkd+FrFPIOFPYuk+INGRlfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB8381
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTAxIGF0IDE3OjA3ICswMTAwLCBUaG9tYXMgWmltbWVybWFubiB3cm90
ZToNCj4gVGhlcmUgaGF2ZSBiZWVuIHJlcG9ydHMgWzFdWzJdIHRoYXQgdm13X2NtZF9keF9kZWZp
bmVfcXVlcnkoKSBjYW4NCj4gYmUgY2FsbGVkIHdpdGggY3R4X25vZGUtPmN0eCBzZXQgdG8gTlVM
TCwgd2hpY2ggcmVzdWx0cyBpbiB1bmRlZmluZWQNCj4gYmVoYXZpb3IgaW4gdm13X2NvbnRleHRf
Y290YWJsZSgpLiBBdm9pZCB0aGlzIGJlIHJldHVybmluZyBhbiBlcnJubw0KPiBjb2RlLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+
DQo+IExpbms6IGh0dHBzOi8vd3d3LmN2ZS5vcmcvQ1ZFUmVjb3JkP2lkPUNWRS0yMDIyLTM4MDk2
wqAjIDENCj4gTGluazogaHR0cHM6Ly9idWd6aWxsYS5vcGVuYW5vbGlzLmNuL3Nob3dfYnVnLmNn
aT9pZD0yMDczwqAjIDINCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+IMKg
ZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5jIHwgMiArLQ0KPiDCoDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2V4ZWNidWYuYw0KPiBiL2RyaXZlcnMv
Z3B1L2RybS92bXdnZngvdm13Z2Z4X2V4ZWNidWYuYw0KPiBpbmRleCA2YjlhYTJiNGVmNTQuLjFl
OTAzNjJhZGQ5NiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhf
ZXhlY2J1Zi5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2V4ZWNidWYu
Yw0KPiBAQCAtMTI1Niw3ICsxMjU2LDcgQEAgc3RhdGljIGludCB2bXdfY21kX2R4X2RlZmluZV9x
dWVyeShzdHJ1Y3Qgdm13X3ByaXZhdGUNCj4gKmRldl9wcml2LA0KPiDCoMKgwqDCoMKgwqDCoMKg
c3RydWN0IHZtd19yZXNvdXJjZSAqY290YWJsZV9yZXM7DQo+IMKgwqDCoMKgwqDCoMKgwqBpbnQg
cmV0Ow0KPiDCoA0KPiAtwqDCoMKgwqDCoMKgwqBpZiAoIWN0eF9ub2RlKQ0KPiArwqDCoMKgwqDC
oMKgwqBpZiAoIWN0eF9ub2RlIHx8ICFjdHhfbm9kZS0+Y3R4KQ0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFMOw0KDQpJJ3ZlIHNlZW4gdGhpcyByZXBvcnQs
IGJ1dCBuZXZlciBhIHBvYyB0aGF0IGNvdWxkIHJlcHJvZHVjZSBpdC4gVGhpcyBzaG91bGQgbmV2
ZXINCmhhcHBlbiwgdGhlIGN0eCBpbiBjdHhfbm9kZSBzaG91bGQgaGF2ZSBiZWVuIGluaXRpYWxp
emVkLiBUbyBiZSBob25lc3QgSSdkIHByZWZlciB0bw0KanVzdCBmaWd1cmUgb3V0IGhvdyBpdCdz
IHVuaW5pdGlhbGlzZWQgaW5zdGVhZCBvZiBqdXN0IGNoZWNraW5nIGZvciBzb21ldGhpbmcgdGhh
dA0Kc2hvdWxkIGJlIGltcG9zc2libGUgYnV0IHdpdGhvdXQgYSByZXByb2R1Y2libGUgdGVzdCB0
aGF0J3MgZGlmZmljdWx0Lg0KDQp6DQo=
