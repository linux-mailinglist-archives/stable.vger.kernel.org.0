Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5155213CE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241043AbiEJLfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241027AbiEJLfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:35:34 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90084.outbound.protection.outlook.com [40.107.9.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE9747387;
        Tue, 10 May 2022 04:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCy1oh3C157W7I6vo4NGneTaOljuLfloqwQ1yO5B3xR6/6aB7ZFJKW6Huq890+TIPtC+Ff2RL1C6pAEdM71ypQYY1yHXJjN4G7jwDz3HF4WpwqG/iGLDvcQwk7f2ZelfeJ9zybG9XTptGCq6aa0Usz5IiqRaJATcOOhXXPu+MFuJaN2ZDPghM+v2D8wwm+a97yZLB72MR95EK1jGd32n1GBQ5/L/AUHVdJqmRkuoo+d74KXARLjQ4wyST7BBKIMJauzeoUNRxR7drQ+S2NLh9Zd3JPEvTmyLmS87pHkYTFTC5zPx9QYQUqqsGybPZ3R6/7SPjT6GK0IMPbtPe0A5Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhrUcK4mUoXBTeQlojK5LSu+Z4GydkzeoeBL7EQfn0E=;
 b=eJsQ8hlcH6WtCGkNKd6nOc9CY9lAcT7l1rzmJu65y66olhx+LG9cnE7V9WYIfaPzKajm7MAKGdWjN/RrgglRlbCdsjT+Df1XfMbSSnecLf0+mgO0v7O9cBcNB3qsvqH6lQpDcZWseosBk+gQ13X7/WEkFmDiBUKyTNHA+FHj8VwVbmyo+jM0U+89jPKsUMgPshjAad2wVGZnDYoZArFqRCmx+yAmUN4xFBzu/Rbh4uIoWa5BeIATkeYf9PjyZATQUQvUxlkY8F66LkowuJrmyKz5aZ5gXJEQg/XoMGOAd/uXE1rVYjbP/ew1bSYGZVo6oOxAHBlWXa03BiPFQ5ktYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB2150.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:17::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Tue, 10 May
 2022 11:31:30 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 11:31:30 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Alexander Graf <graf@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Matt Evans <matt@ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: PPC: Book3S PR: Enable MSR_DR for
 switch_mmu_context()
Thread-Topic: [PATCH v2] KVM: PPC: Book3S PR: Enable MSR_DR for
 switch_mmu_context()
Thread-Index: AQHYZF+wfVOkdZfptkqZrThe3HO9wq0X+juA
Date:   Tue, 10 May 2022 11:31:30 +0000
Message-ID: <f7416897-2ca5-6b2f-cfd3-30d9bcc557cd@csgroup.eu>
References: <20220510111809.15987-1-graf@amazon.com>
In-Reply-To: <20220510111809.15987-1-graf@amazon.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80e47f34-e3a1-45e2-8db4-08da3278a116
x-ms-traffictypediagnostic: MRZP264MB2150:EE_
x-microsoft-antispam-prvs: <MRZP264MB215061678F22ABBA6F9DA3E4EDC99@MRZP264MB2150.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WLx2232fBReH6yDojvuZYC2Ds9P2O5VktgvEgs4RVgmrK1kwR2O51OazQ3rpPLk7aJYWceJeyuX1BpCaFeL6HWksmkhqYvehEpAFyr4sohNg2X4ofRudBe1MRCan6cwLYmIjUzRmdYiBMZ4/VVGR7qddx9x9NrKZ7OAUON/82IpP3MsKJrce1wxDLztzcjxQM74jgPk3IoZhThmi2o7UmQ44e0z/pnzwIgJrlrLh5/oJ3XqbMpsPEdlEvK3f/I9nieWDdaA+rnYYIYveIDOfbh5HOVDoZSQgqE1V7UIiQrU7bi4cB8BX6tFClh2yiitGPbmBSm9un6AOWpMoA0cG+/w4yr9/StOjwG2odqJG55yCfdPmTkvROq3+ZSoJ7wxlJU/ya9ykfhzardrbwR062uDM78kxpe2n7o7iR+8ztDvM868mcuVnYxIg4En7IH71vH7zCtN2tuxlJgKlqe/ogUN2psn+UvwgyYSAFcKWcribpBmwhpBp+qaB/raQnforZK99Bro2Lc0q1A0i3sleHpjSmAuJ3p8GtQBpMWdyzG/s6mNt/frNoatHl1zj+h3jK4cBTmy0Q+z6VTF9erfZYQm6A28XDCXbJCJ1Nh+gl1FjbhdonlLVCXPywYWTI5kMHnn+9Fpns7w3Snj7fjKCTAOnwswzbZ5T1S+mmGTYN1y36Fg6hQ70S5KnszZc0vzznC/bmbsaS/Vx6YuRthsOx6jSSyqs8i0Qp7OaAKEl6Xs1HXcJeUUCq+sM21IbF+WOqaRCrLQqrkFtmyW76D1i+CZYk6R8LV7unZ3iUxm/ybc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(8676002)(71200400001)(4326008)(6512007)(31696002)(26005)(2616005)(44832011)(6506007)(122000001)(2906002)(6486002)(83380400001)(316002)(5660300002)(8936002)(38100700002)(38070700005)(508600001)(186003)(31686004)(36756003)(66946007)(76116006)(66476007)(91956017)(66574015)(110136005)(64756008)(66556008)(66446008)(54906003)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmVFVTl2WlZVZFpXdkl4cCtsRlljcWd5MlFnUC9meDd5b2pqTEhoNWVPVndG?=
 =?utf-8?B?RVRZb09DYWdjbDg2SWdJdkFzQjFaV3ZaMnUxMkJKMnU5dWxpVDM2ZkkzLzFI?=
 =?utf-8?B?eHJ4eVNLTzRpR3JPZFh2dml4YTRLNXRHLzdxUE5XK1F6WDNJVmY0dCtrOWI3?=
 =?utf-8?B?Y0dKdUxmUUxLWDZBRTd4d1FOTU53OHBBaS9kdWtQU1BiK0VoZUdwYzJZUm4y?=
 =?utf-8?B?TkJwUjFtY2VWSkpsUUwyUU5WaHdHMFY5dkhydlB4Rk1oNVh0MEpOWncxSUxh?=
 =?utf-8?B?Zy9YMjNQR0hrT1B3Z0V1anN3cDZmWU11WE1zRkFTYWdwWTNLcjJBNk9kQXhD?=
 =?utf-8?B?WlF4YXlPREppZTNkMUhrU0tnSjB2OENONDd3OFYwc2NsRGtPTjFXY3VidEx5?=
 =?utf-8?B?VG1wbE44WVVOQ1Nkbm82dHpaSTBySDlKcjVXZURrMElUZXVZWWRwMnhVazRj?=
 =?utf-8?B?Y01zemdDK0JFQXV5cXFlcjdMc3dxM3BuV0h1UUpJZCtBWVI3K2drc2UxRzFY?=
 =?utf-8?B?dkdxNUJjSThsd3NIOUFWc0Ywa296aGU1bzlnclFFblkybkQwdFpJRDl1d09Q?=
 =?utf-8?B?SllWUE4vN25KdytNbGs3TkxJSTRFU25GSHIydS8zeGhCbmlhT3FYaERENG5U?=
 =?utf-8?B?NzRuZmVNU1Z0c1F3VmFhRXozVHJLckp2Vk10Q1ZJdDh5VzRmdDJXbVNMWXVr?=
 =?utf-8?B?dFl4VTUycFAyM0s2N1pGQjExK014dytzbnRrRVpCYVUvV2R3c1NWNENGeDN1?=
 =?utf-8?B?Zjk2dGdtOVFoY0swR0hzT3BSMzlRSlBPamcwSk9ibHpyYmlMNnZ0VmJWdXFH?=
 =?utf-8?B?UzA1RFpnaysxakcveStpV1pISDZWZ1lRZ0lja2g4bzNnZnVTUkNJMkY3bFNB?=
 =?utf-8?B?bnBuYmIrYXl0di9jdW45UkNFamc0VXcxYWliaHArN1liaXhSRDBmaGxhTWZx?=
 =?utf-8?B?Y1RuUkpFNWNiakpqLzE0MmZjZVkvcnA0c3JwOVV6ZWxOYnY4SUxBV2U0Z3ZH?=
 =?utf-8?B?dk84NjBpdFppRUZlcWozR0tPK1RTNWkvdi81N1EyRm1Qc1QrdlJRQkg2OXRS?=
 =?utf-8?B?ZFVyNXFQclFhUmt0cG5aUFNUSElCU1l5bDRvZmVMNEFKSEFOUmJtSWZEejhv?=
 =?utf-8?B?ZTlWMDdBMXBDRFAwVG14S2t3V1Q1bFpGS2toaVk0d3oyNkFsWDNiQ0c1VFJR?=
 =?utf-8?B?RWU5Sm1ISjVOVlBXS2JnaGs3bDNET1h6WXZZMTNEMTZNdVFKWjVxL29NeFpu?=
 =?utf-8?B?T3NZdjBXSmZlQ1ZLeUQ5YTkwbkh3eXB2WXNEUFhHYnVhcklaWElDV3lHc1Av?=
 =?utf-8?B?RzFvUW1ORThCanhhbU0yZXdrTXFVdE9JY29ZL0dxZm5jY2dqZ1Y5WkRNZG1s?=
 =?utf-8?B?TDNHUE1UQ25Pd3U3YktvdmltSEk5TVgydU5MbEloWUE2d3pwcW1oQnpLWk5a?=
 =?utf-8?B?ZDE4VXN4cTVkWFNCSWJMNmIrRVR3Qml6a1pMSDNZZHRiUldiU0FSdXZkek1p?=
 =?utf-8?B?RDg2RHZHREttaUphcms2WkRJQ2NEU2wvbk9YU3pNN3JaUk5OUU91d2lQQisz?=
 =?utf-8?B?c0kyblN5eVNYM3JlVGI4YXNCU1lsVlJDNEtWbHdncFlQLzlFck5QY0xXVDFs?=
 =?utf-8?B?UC91aVUwc1NZS1BhTnEyTkdTYmdRcVFlSzUzYWd4K2xyWVpGOHdFeXVtRG9l?=
 =?utf-8?B?TkszSFVibFFSUGM1NzhSTkJldUtMeGxJS2M2dXhBRDBUVnpBd2J0SG4vR01q?=
 =?utf-8?B?ZkFxTEFVZkl4QnVVTnBPbVNZYXpSeWk3Vml6ckc3NlpGc09vaVhZUitHRUFU?=
 =?utf-8?B?QVR5a20xRlFCZlpqOWhWQS91Ui9LK2hhQ1VvUkRYODA2YUJIdi9Zd0hmOUtQ?=
 =?utf-8?B?dytXamlONXUzcHAwUkZ1Tm1aR2VONXRqY3JXMUpjeE1xbEhraUJEVUx5dWoz?=
 =?utf-8?B?b21sdFlXcGVyQ1laeERHNWlmUHhOWUJ4Nll4elVsSHMvbCtiWjRZWldTci9J?=
 =?utf-8?B?OWF1WitqTHhzTjhmRDVxR3FaM3M1Vy9yNTBJMUpFUWYzcXl6SC9wRXZ4M25o?=
 =?utf-8?B?SWpQQ2VlNmRkZWdNekVjSDVEM3ZlQ2F4WFNXL1FUcFRQQmFzM2ZLaDVmWkcx?=
 =?utf-8?B?a0Z2VnFYK1JhOU1pNkVDQVNmNnZJb3NCSm1qc2phenlyL1l6R0NFMVRsMDFN?=
 =?utf-8?B?WW94YUtobWRXazFZdCtBcnBMZm1pc3BuRkJhcHBuTlZJaURTWEFaYnhxZGpu?=
 =?utf-8?B?OEQycHAvM3Y0TTZueVBuSWp3ZGNCMVpWTGxDU09aMy8xNmk2dEFLeEN0cmgw?=
 =?utf-8?B?WmRDblZHNEgxV3V6dmp0RW5hL2ZoNkhtZUVtTE5RNm9mR1RGNXEyZEUwdk1Z?=
 =?utf-8?Q?Gu9P1U11Xf57ShnHBjzfIe2KtBN8zdh5D0xR6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4893DF9D0C8D84A9A2793DF70BF611D@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e47f34-e3a1-45e2-8db4-08da3278a116
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 11:31:30.6264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cqiphpwh3lvWhbRRXbECJPsYZiz4MnZ1bggijp3tjTG8lasR3iCVdNg1c1w6AOeKfyGkX3R7dlWJg/kZ8TOJvHGTBo7VaF5IkoAJZsfElwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2150
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDEwLzA1LzIwMjIgw6AgMTM6MTgsIEFsZXhhbmRlciBHcmFmIGEgw6ljcml0wqA6DQo+
IENvbW1pdCA4NjM3NzFhMjhlMjcgKCJwb3dlcnBjLzMyczogQ29udmVydCBzd2l0Y2hfbW11X2Nv
bnRleHQoKSB0byBDIikNCj4gbW92ZWQgdGhlIHN3aXRjaF9tbXVfY29udGV4dCgpIHRvIEMuIFdo
aWxlIGluIHByaW5jaXBsZSBhIGdvb2QgaWRlYSwgaXQNCj4gbWVhbnQgdGhhdCB0aGUgZnVuY3Rp
b24gbm93IHVzZXMgdGhlIHN0YWNrLiBUaGUgc3RhY2sgaXMgbm90IGFjY2Vzc2libGUNCj4gZnJv
bSByZWFsIG1vZGUgdGhvdWdoLg0KPiANCj4gU28gdG8ga2VlcCBjYWxsaW5nIHRoZSBmdW5jdGlv
biwgbGV0J3MgdHVybiBvbiBNU1JfRFIgd2hpbGUgd2UgY2FsbCBpdC4NCj4gVGhhdCB3YXksIGFs
bCBwb2ludGVyIHJlZmVyZW5jZXMgdG8gdGhlIHN0YWNrIGFyZSBoYW5kbGVkIHZpcnR1YWxseS4N
Cg0KSXMgdGhlIHN5c3RlbSByZWFkeSB0byBoYW5kbGUgYSBEU0kgaW4gY2FzZSB0aGUgc3RhY2sg
aXMgbm90IG1hcHBlZCA/DQoNCj4gDQo+IEluIGFkZGl0aW9uLCBtYWtlIHN1cmUgdG8gc2F2ZS9y
ZXN0b3JlIHIxMiBpbiBhbiBTUFJHLCBhcyBpdCBtYXkgZ2V0DQo+IGNsb2JiZXJlZCBieSB0aGUg
QyBmdW5jdGlvbi4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBNYXR0IEV2YW5zIDxtYXR0QG96bGFicy5v
cmc+DQo+IEZpeGVzOiA4NjM3NzFhMjhlMjcgKCJwb3dlcnBjLzMyczogQ29udmVydCBzd2l0Y2hf
bW11X2NvbnRleHQoKSB0byBDIikNCg0KT29wcywgc29ycnkgZm9yIHRoYXQuIEkgZGlkbid0IHJl
YWxpc2UgdGhhdCB0aGVyZSB3YXMgb3RoZXIgY2FsbGVycyB0byANCnN3aXRjaF9tbXVfY29udGV4
dCgpIHRoYW4gc3dpdGNoX21tX2lycXNfb2ZmKCkuDQoNCkNocmlzdG9waGUNCg0KPiBTaWduZWQt
b2ZmLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPg0KPiBDYzogc3RhYmxlQHZn
ZXIua2VybmVsLm9yZyAjIHY1LjE0Kw0KPiANCj4gLS0tDQo+IA0KPiB2MSAtPiB2MjoNCj4gDQo+
ICAgIC0gU2F2ZSBhbmQgcmVzdG9yZSBSMTIsIHNvIHRoYXQgd2UgZG9uJ3QgdG91Y2ggdm9sYXRp
bGUgcmVnaXN0ZXJzDQo+ICAgICAgd2hpbGUgY2FsbGluZyBpbnRvIEMuDQo+IC0tLQ0KPiAgIGFy
Y2gvcG93ZXJwYy9rdm0vYm9vazNzXzMyX3NyLlMgfCAyNiArKysrKysrKysrKysrKysrKysrKyst
LS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rdm0vYm9vazNzXzMyX3NyLlMgYi9h
cmNoL3Bvd2VycGMva3ZtL2Jvb2szc18zMl9zci5TDQo+IGluZGV4IGUzYWI5ZGY2Y2YxOS4uMWNl
MTNlM2FiMDcyIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szc18zMl9zci5T
DQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9rdm0vYm9vazNzXzMyX3NyLlMNCj4gQEAgLTEyMiwxMSAr
MTIyLDI3IEBADQo+ICAgDQo+ICAgCS8qIDB4MCAtIDB4YiAqLw0KPiAgIA0KPiAtCS8qICdjdXJy
ZW50LT5tbScgbmVlZHMgdG8gYmUgaW4gcjQgKi8NCj4gLQl0b3BoeXMocjQsIHIyKQ0KPiAtCWx3
eglyNCwgTU0ocjQpDQo+IC0JdG9waHlzKHI0LCByNCkNCj4gLQkvKiBUaGlzIG9ubHkgY2xvYmJl
cnMgcjAsIHIzLCByNCBhbmQgcjUgKi8NCj4gKwkvKiBzd2l0Y2hfbW11X2NvbnRleHQoKSBjbG9i
YmVycyByMTIsIHJlc2N1ZSBpdCAqLw0KPiArCVNFVF9TQ1JBVENIMChyMTIpDQo+ICsNCj4gKwkv
KiBzd2l0Y2hfbW11X2NvbnRleHQoKSBuZWVkcyBwYWdpbmcsIGxldCdzIGVuYWJsZSBpdCAqLw0K
PiArCW1mbXNyICAgcjkNCj4gKwlvcmkgICAgIHIxMSwgcjksIE1TUl9EUg0KPiArCW10bXNyICAg
cjExDQo+ICsJc3luYw0KPiArDQo+ICsJLyogQ2FsbGluZyBzd2l0Y2hfbW11X2NvbnRleHQoPGlu
dj4sIGN1cnJlbnQtPm1tLCA8aW52Pik7ICovDQo+ICsJbHd6CXI0LCBNTShyMikNCj4gICAJYmwJ
c3dpdGNoX21tdV9jb250ZXh0DQo+ICAgDQo+ICsJLyogRGlzYWJsZSBwYWdpbmcgYWdhaW4gKi8N
Cj4gKwltZm1zciAgIHI5DQo+ICsJbGkgICAgICByNiwgTVNSX0RSDQo+ICsJYW5kYyAgICByOSwg
cjksIHI2DQo+ICsJbXRtc3IJcjkNCj4gKwlzeW5jDQo+ICsNCj4gKwkvKiByZXN0b3JlIHIxMiAq
Lw0KPiArCUdFVF9TQ1JBVENIMChyMTIpDQo+ICsNCj4gICAuZW5kbQ==
