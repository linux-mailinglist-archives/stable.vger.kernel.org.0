Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5708752F5A7
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 00:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347855AbiETWYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 18:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiETWYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 18:24:39 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2098.outbound.protection.outlook.com [40.107.95.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031CB9346F;
        Fri, 20 May 2022 15:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOTSGC/UnDaCZmUYCb2w2Q7yzatcWUuHLc/wcWUjvnoIDImI4Ues85t+/8AGU+T26WbMxruET9q/stZsPF5jwuPT66iG2kA1O2cHKuRtuTXoSiahur6YPnVyYl6IfwmdvntoHFlXroJf/gLjCpeEel7RVYv7yiI7rXCkh+dEvoOadBs5ocPU3CavfGrf3wL/dMa8cWQN3gu3ArCnI//z3MQQWWvxEGfwtaq7JxQ54ZN4/c2vyvp85gaCCjS+wwhKFjsdkKylKfw20SiPIfGTbT3lYnYkuM37b6ZADMUmXO6Hh9y53pgltyJHkvoGDsl1UgES9DBhvot7DrTa2dxMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XF5CfGObZ2ucFTkBVWH9Xzo5ChbRB7/G25hgJwzEFGs=;
 b=HlTabaStBaQQSM8QS57QEL5zzqZhNpk4fEsHR0T+ysALvlxyFbs6JT3a+IznamSQm4Yv+YbbvmuVdL3ADRiIG6kH2/RVUotC6DkUkEiNFvmrBM/zqBGghfcr/Kv0gmaml42oON2EYImwfTc53suVCDPT1hqVleldQLqc21vwZRGg6MgMifCVcyBk8oIHJQr7IDvQv0IpIbJXGCtWSlmNkkJO2+rOo7Kb/WcUYqvWF+gZAaorLqxdu/UpBaxA7he5p23fyUmW0ME3+TcomEmOfm1jByC1AmJ2ryAQDtErpkrwv/hdncI5c6n/55mNxVlpKAUejZRbhQf3CRdA23e4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XF5CfGObZ2ucFTkBVWH9Xzo5ChbRB7/G25hgJwzEFGs=;
 b=BNPopTyDAcqeCHjZn6zW+YEmkViq26mSof7WVKLBc3+5LLP+Y4WpptD74Sy2uuMco6Ukd552i8YyzPfh0cfLrBKabR6GAKaauGRAkp/953MCTMOThgJCrl6zKeLiaUn2pjmL6pTOjGc9gjbck0mpxM5G+hcDd79QSfIg9F8sK8M=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BL0PR13MB4548.namprd13.prod.outlook.com (2603:10b6:208:1cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Fri, 20 May
 2022 22:24:34 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5%6]) with mapi id 15.20.5293.008; Fri, 20 May 2022
 22:24:34 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux@stwm.de" <linux@stwm.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR858YHu5BjXv06IiZjQIhNS6q0Zna2AgAAbcoCAAAIRgIAAA5uAgA41xoCAABHLAIAAVxQAgAAJEgA=
Date:   Fri, 20 May 2022 22:24:34 +0000
Message-ID: <1a38a01debc727a1e11243fd6207d915ac90c251.camel@hammerspace.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
         <YnuuLZe6h80KCNhd@kroah.com>
         <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
         <YnvG71v4Ay560D+X@kroah.com>
         <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
         <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
         <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
         <3FE1F779-A2EC-4E23-BBCC-28C5E8AFCBB1@oracle.com>
In-Reply-To: <3FE1F779-A2EC-4E23-BBCC-28C5E8AFCBB1@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ced12d53-4a76-4197-ae43-08da3aaf84a3
x-ms-traffictypediagnostic: BL0PR13MB4548:EE_
x-microsoft-antispam-prvs: <BL0PR13MB45486D534C0C8B49973C909BB8D39@BL0PR13MB4548.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pr8z1HUwm2/aUuEGdVxKRX/j81EVqcoGEr+Fw0HbnyQTSY/+u3Ujn5Kl+0Yy6EfxnM9t2NCppgrLt+O8clFCkxWwTg5yYP+fNhulbK87ySPv+tEXk4LUk0P0WOAqpmwGEFBK4fSZctDMUWFoIlLdvRGBucZZEdAQuCB3NpcOmBAHojqKDiqhAyu141/xKjbeeDoOphFjyUmeRPl+aEusd4iiOcNKnIoClrh8VppM0dwqhc8QZSJrz2AVtYiA1DTggYRv5rUBdJfitsDCVuZcS2ECHagpAAfyvV9WPN9qtRZKTUberIEjjcDPUdYpDbvydLBVp1y5KhMRPmbIF2hmrHi7361OhgbWxTu7T2DhRmwKNunoip/zwNi4ZgTzCuIQpx2AqG1fMmUSQj55q65ein/rRGGbqd5HIeO2ObajAFb8LkHQ5t7xdPmEt5JBMGVY2CgfCUJf2TDJueaZ7Pm7l0qiOeyxtcQc/Wg429CTi+M0861Ae0GLJ70dbBZt9URW/LVp4HfyNIUfdFVNufzc62wXbh3IR0iZGWi0BtgSKP1hJ9Fu2ZIe7SxGIBzQwD1zlloVZ/DrBLutLVjBkRpFLmmYBR6xDBgKUuBoHzttfTXlET2qb4GaEDgXGDf/okQpwzMAU7J5j94qRKF+9/l5HI2o3JvWwWAcVQrxvuitVxkofAHodHWcxGLutcutAeb6zarUSlUafkFH2IEWhbaXvpIRutAa1NAQo4Q0oUGWIyQK3atSeB7aUdMc9DECNVc17USWZcmfhBaNqKiN81gbME7TMUtO/oWYZDvYwJbC6VmiZKU5LlFG6YtYN1Vw/oSyLMqDcHR6BxnS2IK/4ZXEZOO9/pA3Wm6WcAcPW3N4nDI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(396003)(376002)(39840400004)(366004)(36756003)(966005)(41300700001)(2616005)(508600001)(2906002)(54906003)(6916009)(8936002)(316002)(6486002)(186003)(5660300002)(76116006)(38100700002)(38070700005)(6512007)(122000001)(26005)(64756008)(6506007)(66556008)(71200400001)(53546011)(66946007)(8676002)(83380400001)(4326008)(66446008)(66476007)(86362001)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXNMaUg4N0wvSHRtcXRZZ3lQUVI2YXEzNlpsMzB1QndWZjk0VUY4cTRId1Ew?=
 =?utf-8?B?bTdjcnplaCt1MVJrZ0U5Z3A3N05XM05WeDNqUk9hMTlTSmNYL3JiVDl0dkxZ?=
 =?utf-8?B?ak5NbGw5cCtZelk1NnU5V28rWmtMNm5MVWlEWG1QcjFkeUZsRk5UYzFHZmpN?=
 =?utf-8?B?V2ZMbU9rYnpnRkhLZlBVUEczTjR0aHhqUEZWQzAxOXNDTHdVUDlkM1lxZWZ5?=
 =?utf-8?B?K0lDMUJ4ZUVNWFdYbTB1RGdWeElVYUg4RVZiZStNaGhROXlmRmRlYWVoUjAw?=
 =?utf-8?B?a2x2U25CTTlJYmZ1dExoVzhKQzZmdlNXZ1FaeFV6NXMvNDBpQXdTdWF3QXBl?=
 =?utf-8?B?eDBjbGdZSGt3TXFnWVY0eTNSMm5oK2VHTXhFQnZUeFlYcWxkMm9wV05uY1R6?=
 =?utf-8?B?c0l3a1pWcWNDSXhOSTc3Q0w4Y3ZZQTFScEVFZjdEM0pwQnZBUEJmS0QyMC91?=
 =?utf-8?B?eitydTBSR3ZYanZJa3BGT0lCWTVtOVE1cFZaOVVUSlRRMVh6V2hkRUhrSkpM?=
 =?utf-8?B?cVlxNzFEM1Z2dE9UYzFsTm0raGxpM1NXL2F5L09lRHhpYmZCNWFnVDYvSVJl?=
 =?utf-8?B?QWpsMXRjQmhzRVRNZWV4bFJRbGNqRTR0ZmtKeEFMeTU4SUhEZFZVa1VnZG1a?=
 =?utf-8?B?Sk5EcUF5emh3d1NSTUhzYkpId3RKUm9MeEw2c2JlSStuVU1lc21WalhVKzA4?=
 =?utf-8?B?RmJzbi9VK3YrM3RsdnI2UU5IcjlmMHBmS284eHpLQkpjSDF1aTJQdUYzTXR0?=
 =?utf-8?B?eHRSNXBVcko4Nmp5Rm9WOWkycThPMGZ3WUNIOTZPU0lCaFUrbWNDUUZrL1N6?=
 =?utf-8?B?dnVYeHNlWnlaL3NJUWoxZTR5VDR6aDNDVE1KcnViWW0vcDQzZmdYbEN0SVR4?=
 =?utf-8?B?Rm12UTloUlNDa0E5ajE3bXg4bFk0WDlQdUVITEhqQzNlbko5Q254WTFhYUZn?=
 =?utf-8?B?T01haGhtWExHWW9CWmtPd2dpVjRaazhTbDBlM1NkUFBEc2hoUGM5aXdXTkdn?=
 =?utf-8?B?a25EcjRoM1JIdXBRQVR5bDZyOVRrZTJMV0ZXWG9TWUpTVjlWUGJZdUw5RTRT?=
 =?utf-8?B?S3dzeHIrMzI0Y3NCa2RlTlZIOGthZ3QvNTNKZ01iRGYzWWl3K0ZxUGNFZTBX?=
 =?utf-8?B?NERKekNEWStzb3ZXN0w3czhvZ3FFWFYrSC9NVmJLYk4yekZkMXZlbmNKcWl2?=
 =?utf-8?B?YSt6c1BtR3pZYS9aMGpYT3haK0MwcmpLZ2hlZVlOQ0xPcWFuZXZ1dFozNEVN?=
 =?utf-8?B?V1JCN2JNU2hVQlhSekFHcmpNSzVVVjlUV0VXTVNjN1lxVEhFbEtDK2RDREZU?=
 =?utf-8?B?UnJ2cEdaVUZ3bUZmOGVGSWphSXBtS1VGS3UzNHEybmlPNlZBQjNqeEhHcTU1?=
 =?utf-8?B?c1R5UGhaUEpYK1l4UnlqZUJsSHFkMFN3TDFicnF4d3VCTmg3aTFVVUZLcy84?=
 =?utf-8?B?cDNmRUE3T3RZb2V0RDdqWEppVDlIakFYZ1NSTGlFcU5lalROZWUvTmlFUktL?=
 =?utf-8?B?a01nMktOeE8za3luc2U4ek5JbE9YTFdubGZOcml3RHVmU1JVRHZiSEluSDdH?=
 =?utf-8?B?MjR1ZVpSbitOQlVBN0VuYnFZZjZkaFBySXUyMnRxYURleEl6a2FnMjhzck4v?=
 =?utf-8?B?Y3B4b1l1TDNRMlVQNzljK1hPOUgrSy9nbjZaU2J5a2ZMOHJzQ0lXak12czE4?=
 =?utf-8?B?RGxGK3dkNUhFR0tVSGluTlFLa2FaZU9VakRNdFBjMzJKSTA0djRWQzJrV3pZ?=
 =?utf-8?B?cVJCWVNBMFVpa2V1ZEZqVGZFS1kvOEtjRmdwbzNiNlhhT2I1c1BuRHIxYnYw?=
 =?utf-8?B?eURrZDRocWVIUUhhNjgvbXBxdzRJVEYxTllUNy9xZTQ0c21YMHJkVG1nMWxC?=
 =?utf-8?B?MVdsTjRMTE5SUXpKRlFNLzkrZ3ArMkRoTld6REVsNVJUQWQzNmR6blI5N3VN?=
 =?utf-8?B?WlFnS3dPWmgvUmMxM2UwbkdaOStmUStBbTdXSEFsUklVRmIyM1FCQllyZzRm?=
 =?utf-8?B?MXdHcFozL2VheGR3TldadVJHV08yQWRRVmxnUlA3bUM5bUJIRlBvb1NodERu?=
 =?utf-8?B?TFFIbjhLVDhFdThjQXV5M1BKaGtJeUIyYmxISmQvUVBwV3RMN0cwTksydDFS?=
 =?utf-8?B?ZXlLYU9DRlVSL3BsSW5lZG5zMERBc0hqVzF3YStwRWNNZEpCN29ZTVdHTDdp?=
 =?utf-8?B?eG04QVgrdzB1VlFyVzVBM0s2VmZtUzdZekRqY3lhT3ozazBlOVpwZmlKa1A4?=
 =?utf-8?B?QzNvMXhjOXlJSEZNUjNGTU9PdUJod0x0aFBRdE82VHhLTFVlRXhYMFZ3bU1R?=
 =?utf-8?B?VHZWSnBGQ0Y5SExzZ29iNGk5cVNLK3NsSndFTDFkdXpRUUUrTnB6QVZpWE54?=
 =?utf-8?Q?M9HsfE1Z5ZyTGpnU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2625F00D5D115C4D9D9FD469B15AC1D6@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ced12d53-4a76-4197-ae43-08da3aaf84a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 22:24:34.4885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4n46EM83RoJpHag3sc3xSNltCW54pcIJ12H/eCAJLLCgLpqOhgLsyOpcYFr2oo46HVMDbzbcnpzuL99juu00Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4548
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIyLTA1LTIwIGF0IDIxOjUyICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6
DQo+IA0KPiANCj4gPiBPbiBNYXkgMjAsIDIwMjIsIGF0IDEyOjQwIFBNLCBUcm9uZCBNeWtsZWJ1
c3QNCj4gPiA8dHJvbmRteUBoYW1tZXJzcGFjZS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIEZy
aSwgMjAyMi0wNS0yMCBhdCAxNTozNiArMDAwMCwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPiA+
ID4gDQo+ID4gPiANCj4gPiA+ID4gT24gTWF5IDExLCAyMDIyLCBhdCAxMDozNiBBTSwgQ2h1Y2sg
TGV2ZXIgSUlJDQo+ID4gPiA+IDxjaHVjay5sZXZlckBvcmFjbGUuY29tPiB3cm90ZToNCj4gPiA+
ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gPiBPbiBNYXkgMTEsIDIwMjIsIGF0IDEw
OjIzIEFNLCBHcmVnIEtIDQo+ID4gPiA+ID4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPiB3
cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBPbiBXZWQsIE1heSAxMSwgMjAyMiBhdCAwMjox
NjoxOVBNICswMDAwLCBDaHVjayBMZXZlciBJSUkNCj4gPiA+ID4gPiB3cm90ZToNCj4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IE9uIE1heSAxMSwgMjAyMiwgYXQgODoz
OCBBTSwgR3JlZyBLSA0KPiA+ID4gPiA+ID4gPiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+
IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gT24gV2VkLCBNYXkgMTEsIDIw
MjIgYXQgMTI6MDM6MTNQTSArMDIwMCwgV29sZmdhbmcgV2FsdGVyDQo+ID4gPiA+ID4gPiA+IHdy
b3RlOg0KPiA+ID4gPiA+ID4gPiA+IEhpLA0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4g
PiA+IHN0YXJ0aW5nIHdpdGggNS40LjE4OCB3aWUgc2VlIGEgbWFzc2l2ZSBwZXJmb3JtYW5jZQ0K
PiA+ID4gPiA+ID4gPiA+IHJlZ3Jlc3Npb24gb24gb3VyDQo+ID4gPiA+ID4gPiA+ID4gbmZzLXNl
cnZlci4gSXQgYmFzaWNhbGx5IGlzIHNlcnZpbmcgcmVxdWVzdHMgdmVyeSB2ZXJ5DQo+ID4gPiA+
ID4gPiA+ID4gc2xvd2x5IHdpdGggY3B1DQo+ID4gPiA+ID4gPiA+ID4gdXRpbGl6YXRpb24gb2Yg
MTAwJSAod2l0aCA1LjQuMTg3IGFuZCBlYXJsaWVyIGl0IGlzDQo+ID4gPiA+ID4gPiA+ID4gMTAl
KSBzbw0KPiA+ID4gPiA+ID4gPiA+IHRoYXQgaXQgaXMNCj4gPiA+ID4gPiA+ID4gPiB1bnVzYWJs
ZSBhcyBhIGZpbGVzZXJ2ZXIuDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gVGhl
IGN1bHByaXQgYXJlIGNvbW1pdHMgKG9yIG9uZSBvZiBpdCk6DQo+ID4gPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiA+ID4gYzMyZjEwNDEzODJhODhiMTdkYTU3MzY4ODZkYTRhNDkyMzUzYTFiYiAi
bmZzZDogY2xlYW51cA0KPiA+ID4gPiA+ID4gPiA+IG5mc2RfZmlsZV9scnVfZGlzcG9zZSgpIg0K
PiA+ID4gPiA+ID4gPiA+IDYyOGFkZmEyMTgxNWY3NGMwNDcyNGFiYzg1ODQ3ZjI0YjVkZDE2NDUg
Im5mc2Q6DQo+ID4gPiA+ID4gPiA+ID4gQ29udGFpbmVyaXNlIGZpbGVjYWNoZQ0KPiA+ID4gPiA+
ID4gPiA+IGxhdW5kcmV0dGUiDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gKHVw
c3RyZWFtIDM2ZWJiZGI5NmI2OTRkZDljNmIyNWFkOThmMmJiZDI2M2QwMjJiNjMgYW5kDQo+ID4g
PiA+ID4gPiA+ID4gOTU0MmU2YTY0M2ZjNjlkNTI4ZGZiMzMwM2YxNDU3MTljNjFkMzA1MCkNCj4g
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBJZiBJIHJldmVydCB0aGVtIGluIHY1LjQu
MTkyIHRoZSBrZXJuZWwgd29ya3MgYXMgYmVmb3JlDQo+ID4gPiA+ID4gPiA+ID4gYW5kDQo+ID4g
PiA+ID4gPiA+ID4gcGVyZm9ybWFuY2UgaXMNCj4gPiA+ID4gPiA+ID4gPiBvayBhZ2Fpbi4NCj4g
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBJIGRpZCBub3QgdHJ5IHRvIHJldmVydCB0
aGVtIG9uZSBieSBvbmUgYXMgYW55DQo+ID4gPiA+ID4gPiA+ID4gZGlzcnVwdGlvbg0KPiA+ID4g
PiA+ID4gPiA+IG9mIG91ciBuZnMtc2VydmVyDQo+ID4gPiA+ID4gPiA+ID4gaXMgYSBzZXZlcmUg
cHJvYmxlbSBmb3IgdXMgYW5kIEknbSBub3Qgc3VyZSBpZiB0aGV5IGFyZQ0KPiA+ID4gPiA+ID4g
PiA+IHJlbGF0ZWQuDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gNS4xMCBhbmQg
NS4xNSBib3RoIGFsd2F5cyBwZXJmb3JtZWQgdmVyeSBiYWRseSBvbiBvdXINCj4gPiA+ID4gPiA+
ID4gPiBuZnMtDQo+ID4gPiA+ID4gPiA+ID4gc2VydmVyIGluIGENCj4gPiA+ID4gPiA+ID4gPiBz
aW1pbGFyIHdheSBzbyB3ZSB3ZXJlIHN0dWNrIHdpdGggNS40Lg0KPiA+ID4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gPiA+IEkgbm93IHRoaW5rIHRoaXMgaXMgYmVjYXVzZSBvZg0KPiA+ID4gPiA+
ID4gPiA+IDM2ZWJiZGI5NmI2OTRkZDljNmIyNWFkOThmMmJiZDI2M2QwMjJiNjMNCj4gPiA+ID4g
PiA+ID4gPiBhbmQvb3IgOTU0MmU2YTY0M2ZjNjlkNTI4ZGZiMzMwM2YxNDU3MTljNjFkMzA1MCB0
aG91Z2gNCj4gPiA+ID4gPiA+ID4gPiBJDQo+ID4gPiA+ID4gPiA+ID4gZGlkbid0IHRyaWVkIHRv
DQo+ID4gPiA+ID4gPiA+ID4gcmV2ZXJ0IHRoZW0gaW4gNS4xNSB5ZXQuDQo+ID4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gPiBPZGRzIGFyZSA1LjE4LXJjNiBpcyBhbHNvIGEgcHJvYmxlbT8NCj4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gV2UgYmVsaWV2ZSB0aGF0DQo+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+IDZiOGE5NDMzMmVlNCAoIm5mc2Q6IEZpeCBhIHdyaXRlIHBlcmZvcm1hbmNlIHJl
Z3Jlc3Npb24iKQ0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBhZGRyZXNzZXMgdGhlIHBlcmZv
cm1hbmNlIHJlZ3Jlc3Npb24uIEl0IHdhcyBtZXJnZWQgaW50bw0KPiA+ID4gPiA+ID4gNS4xOC0N
Cj4gPiA+ID4gPiA+IHJjLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEFuZCBpbnRvIDUuMTcuNCBp
ZiBzb21lb25lIHdhbnRzIHRvIHRyeSB0aGF0IHJlbGVhc2UuDQo+ID4gPiA+IA0KPiA+ID4gPiBJ
IGRvbid0IGhhdmUgYSBsb3Qgb2YgdGltZSB0byBiYWNrcG9ydCB0aGlzIG9uZSBteXNlbGYsIHNv
DQo+ID4gPiA+IEkgd2VsY29tZSBhbnlvbmUgd2hvIHdhbnRzIHRvIGFwcGx5IHRoYXQgY29tbWl0
IHRvIHRoZWlyDQo+ID4gPiA+IGZhdm9yaXRlIExUUyBrZXJuZWwgYW5kIHRlc3QgaXQgZm9yIHVz
Lg0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IElmIHNvLCBJJ2xsIGp1c3Qgd2Fp
dCBmb3IgdGhlIGZpeCB0byBnZXQgaW50byBMaW51cydzDQo+ID4gPiA+ID4gPiA+IHRyZWUgYXMN
Cj4gPiA+ID4gPiA+ID4gdGhpcyBkb2VzDQo+ID4gPiA+ID4gPiA+IG5vdCBzZWVtIHRvIGJlIGEg
c3RhYmxlLXRyZWUtb25seSBpc3N1ZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gVW5mb3J0
dW5hdGVseSBJJ3ZlIHJlY2VpdmVkIGEgcmVjZW50IHJlcG9ydCB0aGF0IHRoZSBmaXgNCj4gPiA+
ID4gPiA+IGludHJvZHVjZXMNCj4gPiA+ID4gPiA+IGEgInNsZWVwIHdoaWxlIHNwaW5sb2NrIGlz
IGhlbGQiIGZvciBORlN2NC4wIGluIHJhcmUgY2FzZXMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
SWNrLCBub3QgZ29vZCwgYW55IHBvdGVudGlhbCBmaXhlcyBmb3IgdGhhdD8NCj4gPiA+ID4gDQo+
ID4gPiA+IE5vdCB5ZXQuIEkgd2FzIGF0IExTRiBsYXN0IHdlZWssIHNvIEkndmUganVzdCBzdGFy
dGVkIGRpZ2dpbmcNCj4gPiA+ID4gaW50byB0aGlzIG9uZS4gSSd2ZSBjb25maXJtZWQgdGhhdCB0
aGUgcmVwb3J0IGlzIGEgcmVhbCBidWcsDQo+ID4gPiA+IGJ1dCB3ZSBzdGlsbCBkb24ndCBrbm93
IGhvdyBoYXJkIGl0IGlzIHRvIGhpdCBpdCB3aXRoIHJlYWwNCj4gPiA+ID4gd29ya2xvYWRzLg0K
PiA+ID4gDQo+ID4gPiBXZSBiZWxpZXZlIHRoZSBmb2xsb3dpbmcsIHdoaWNoIHNob3VsZCBiZSBw
YXJ0IG9mIHRoZSBmaXJzdA0KPiA+ID4gTkZTRCBwdWxsIHJlcXVlc3QgZm9yIDUuMTksIHdpbGwg
cHJvcGVybHkgYWRkcmVzcyB0aGUgc3BsYXQuDQo+ID4gPiANCj4gPiA+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2NlbC9saW51eC5naXQvY29tbWl0Lz9o
PWZvci1uZXh0JmlkPTU1NjA4MmY1ZTVkN2VjZmQwZWU0NWMzNjQxZTJiMzY0YmZmOWVlNDQNCj4g
PiA+IA0KPiA+ID4gDQo+ID4gVWguLi4gV2hhdCBoYXBwZW5zIGlmIHlvdSBoYXZlIDIgc2ltdWx0
YW5lb3VzIGNhbGxzIHRvDQo+ID4gbmZzZDRfcmVsZWFzZV9sb2Nrb3duZXIoKSBmb3IgdGhlIHNh
bWUgZmlsZT8gaS5lLiAyIHNlcGFyYXRlDQo+ID4gcHJvY2Vzc2VzDQo+ID4gb3duZWQgYnkgdGhl
IHNhbWUgdXNlciwgYm90aCBsb2NraW5nIHRoZSBzYW1lIGZpbGUuDQo+ID4gDQo+ID4gQ2FuJ3Qg
dGhhdCBjYXVzZSB0aGUgJ3B1dGxpc3QnIHRvIGdldCBjb3JydXB0ZWQgd2hlbiBib3RoIGNhbGxl
cnMNCj4gPiBhZGQNCj4gPiB0aGUgc2FtZSBuZi0+bmZfcHV0ZmlsZSB0byB0d28gc2VwYXJhdGUg
bGlzdHM/DQo+IA0KPiBJSVVDLCBjbF9sb2NrIHNlcmlhbGl6ZXMgdGhlIHR3byBSRUxFQVNFX0xP
Q0tPV05FUiBjYWxscy4NCj4gDQo+IFRoZSBmaXJzdCBjYWxsIGZpbmRzIHRoZSBsb2Nrb3duZXIg
aW4gY2xfb3duZXJzdHJfaGFzaHRibCBhbmQNCj4gdW5oYXNoZXMgaXQgYmVmb3JlIHJlbGVhc2lu
ZyBjbF9sb2NrLg0KPiANCj4gVGhlbiB0aGUgc2Vjb25kIGNhbm5vdCBmaW5kIHRoYXQgbG9ja293
bmVyLCB0aHVzIGl0IGNhbid0DQo+IHJlcXVldWUgaXQgZm9yIGJ1bGtfcHV0Lg0KPiANCj4gQW0g
SSBtaXNzaW5nIHNvbWV0aGluZz8NCg0KSW4gdGhlIGV4YW1wbGUgSSBxdW90ZWQsIHRoZXJlIGFy
ZSAyIHNlcGFyYXRlIHByb2Nlc3NlcyBydW5uaW5nIG9uIHRoZQ0KY2xpZW50LiBUaG9zZSBwcm9j
ZXNzZXMgY291bGQgc2hhcmUgdGhlIHNhbWUgb3BlbiBvd25lciArIG9wZW4gc3RhdGVpZCwNCmFu
ZCBoZW5jZSB0aGUgc2FtZSBzdHJ1Y3QgbmZzNF9maWxlLCBzaW5jZSB0aGF0IGRlcGVuZHMgb25s
eSBvbiB0aGUNCnByb2Nlc3MgY3JlZGVudGlhbHMgbWF0Y2hpbmcuIEhvd2V2ZXIgdGhleSB3aWxs
IG5vdCBub3JtYWxseSBzaGFyZSBhDQpsb2NrIG93bmVyLCBzaW5jZSBQT1NJWCBkb2VzIG5vdCBl
eHBlY3QgZGlmZmVyZW50IHByb2Nlc3NlcyB0byBzaGFyZQ0KbG9ja3MuDQoNCklPVzogVGhlIHBv
aW50IGlzIHRoYXQgb25lIGNhbiByZWxhdGl2ZWx5IGVhc2lseSBjcmVhdGUgMiBkaWZmZXJlbnQN
CmxvY2sgb3duZXJzIHdpdGggZGlmZmVyZW50IGxvY2sgc3RhdGVpZHMgdGhhdCBzaGFyZSB0aGUg
c2FtZSB1bmRlcmx5aW5nDQpzdHJ1Y3QgbmZzNF9maWxlLg0KDQotLSANClRyb25kIE15a2xlYnVz
dA0KTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBIYW1tZXJzcGFjZQ0KdHJvbmQubXlrbGVi
dXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
