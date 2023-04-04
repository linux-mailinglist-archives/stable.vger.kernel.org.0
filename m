Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9406D5E8C
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjDDLFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbjDDLFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:05:03 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2093.outbound.protection.outlook.com [40.107.113.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D939A4237;
        Tue,  4 Apr 2023 04:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7yyHtFPWZR7xzpWKvy8SbrTZifmQzgjFbEvNbjs9mE+gkyZKDf80vkSZSLOsyK/fY/k3Nf59CtNytUXY9ahYpALa7rTarwoXo84LtsiDeqAdRk4htoagUYwxJKnCwc+TEKYLNPf4yatOhPf0teiqSYgizWx5tcouGiAvPj55X2E7mdDWdM7BJtAQ8MwC55U7ETM9zeTd1V3As+iit92gUO0mK5W3YudXMOq1wSmbucPzdvFBH2ZAtQmN/q/0uTfd0586LtMWWLvEzbwIvOi2DvJLWCdWoxeIgUsqKgxMaioJ33ZOi2MQquqyeZW/BbdAJvcFyUSbG1GO1+bGVtHFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNz4lboYDFs+gbM0W8tQYTDCBbX4ThuBEqZszMLVrE0=;
 b=dbZtP4EQrBADs6bMuLt3AHUfe3Gkf1GiYmv5++WIYQAM9fclOKn2JPXapsYZ4C9RLAMjelmUVDSuMEMvLyJcIZn9lcNf2Ga9iH7YkEO2Av2MH23vV14Z9w1ek7FHR5hdrVrGlj4v4xoRWzVkr6J4t19z3JoKaYUWV3dFSoXre/YNvEClGD0paqMg7CR5edTdLKNY2ljDx4c7HBvxeSJB49Deh9akjTS4kNlcRe0y2/JYNux+pgTARUkeTCFdrZgkf9yerRYnpkTtcGLzj/UKm6fikN6z9VK2AEqt+8kzQGvUlV8/BDKNfs62TGV/YuK1LeXOb3kZrtShi5fEWoFChw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNz4lboYDFs+gbM0W8tQYTDCBbX4ThuBEqZszMLVrE0=;
 b=na/EC6TRDoTsk44c6gS5Q4QFMPxof+4O3GFkH7d6ybbHlLgiUypcJjasRyE++NQuAUFR+1t3Jjcb7EOdPDr+VD9YXBlnen28ZLrGTO71yNBWoewnZURAKyNAgYm0b5B6anjemTnFBs6IaEUn1vBSYzJgRMIzXnZAfoHpNh1YoYc=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OSZPR01MB9650.jpnprd01.prod.outlook.com (2603:1096:604:1d8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 10:55:33 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:55:33 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: [PATCH 5.15 00/99] 5.15.106-rc1 review
Thread-Topic: [PATCH 5.15 00/99] 5.15.106-rc1 review
Thread-Index: AQHZZjj9DIOd5TTJekmyoGOcbsANWa8a+yfQ
Date:   Tue, 4 Apr 2023 10:55:33 +0000
Message-ID: <TY2PR01MB37884F7A9CF0CCA3A2E0FCC6B7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140356.079638751@linuxfoundation.org>
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OSZPR01MB9650:EE_
x-ms-office365-filtering-correlation-id: 8d5965fb-6a66-42b5-980c-08db34fb1d68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HdCUn+JBvQUyerBB4TxcI3YNHRSJeOIFsgUGvvxOX02u5HPUNnb96Gx9KQkNVEpvkaqbfm5wZT+lNSRYWTmmoOjgSB1UY3Lo26tTaTG4By2p5Eylk0unltJ0OMvpX3KRCusu7vP18eGqR/pB2hOgx7qYL9v2XghMI/TtbUuTqucXk513B4o3Fr6t/9hRtjPi25dWOAhFW4SI4NDTDtnzFaKHAkzNLF5TgooMu085G01/jYx7U/q3cKlHgkmKyQ9GCFV0ofWHyWnwuq6aP9+IJhbLs7dDkysdDFunOLm2tX223rbpklfHsS1c0hbfkvexWPlDOAXfH6sHE5ik13/p8YT2u2OGHi1y/dV2lr6QjBJoOpADJQSZ3FkJLXl5rfQkx9/PFSdkLO3J2LNmvikAh6yIU+7KzMUvB6FGmhevWNyLutfo4Qx330GwTrMge3rDd+v5XnI8S3CK1NSBNnbCQQoz8VnVl1XZSY6MnVrTt9dKqW0jPVi22ZJ5QcRzbYbm/mTgq8cfEHWvxAj9c5o/RwPCePiPr1sp9PfvTlaJz2MIT298JjgJLP6w1DGZqychg5U50cGlzwYNandRn1/MseClntVRpYxP5ZJvakPPHqPRyP7kIrfRZ54dFE1fS6GjJAyOs+3RaWqR7ojRz1p5WQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199021)(7696005)(71200400001)(966005)(55016003)(38100700002)(86362001)(33656002)(38070700005)(26005)(6506007)(9686003)(122000001)(186003)(316002)(54906003)(110136005)(2906002)(7416002)(5660300002)(8936002)(41300700001)(52536014)(66946007)(4326008)(76116006)(66556008)(8676002)(64756008)(66476007)(66446008)(4744005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUJXUUxqSjNlY0ZWbitJdzUzcXc1eUN6MGtGS2lNWFVFRTNQeGRycGROMGNr?=
 =?utf-8?B?cURWTXhneS9rTGw5RXh5ZnBJbUVWby9jbW1GQ0ZDOWFHZHlSV0d3S0pvOXhz?=
 =?utf-8?B?cjZ4MkdtVnVsdVA3Y2txNzAzRGJVTzdQVG1KT0ltenN3K3lmSGZLd1U2V25s?=
 =?utf-8?B?TVViMDlWYkI3NXV4RG1FNVhZZjhpV1J2NzErK1JWUGNlVWlLVkcxeHpLV0VY?=
 =?utf-8?B?d01BOW9aRlJXUmI3dkRDY2pRZ1Y1OWN0SjFpMEN0dG9HcE80aW8zWG1OZzlO?=
 =?utf-8?B?RlBtYjFhS1RFVnhxNksxeXNFVlpKK0ZIWlJpT3d2Uk1qYklxTFB6K2ViR3F2?=
 =?utf-8?B?RlBRZWluL2JsQkZMcEZCcSs5QVY5SVBKS0xpZTY4dCtYN250Qlo2MnZCMjNj?=
 =?utf-8?B?bWhWaEdsYUhNZmRXbnVMampRVCtFRHFyUGd4ejlTV3ZFRVBYbGpqcmVGQk1y?=
 =?utf-8?B?cno2dlVQKzR5aVhBcm9nK0FGVlpLRkRDT25uNit4bWwrNFFZSi93QU9nZ3VK?=
 =?utf-8?B?Y2IzaFBNVDRTS1B0WGZsaFIvVGUwdmdsUVBQY3IySm5jZ0NYS0NKNDNFN0FS?=
 =?utf-8?B?VEJTVUJiUW4veStObFU1cHdBL0w4WFFYbThRc21adHVoSFVJMyttQWxxSito?=
 =?utf-8?B?QUxiM3pUbWRadXhhblpQcU00WVZsbGJWR0p1QkROclFRNXU0ckZ6SnhTVElK?=
 =?utf-8?B?dmhuOWJybzZsOHVrRkJoTmN3VnB3blNlV1N2Y3U1QlY4THhXQ2ZidWtzOTFt?=
 =?utf-8?B?ZUtDdGVRSStsTUxUNGFrNURuWi95STMwcXZQUEplUG1GUWVpaEpRWVZ6Y3pu?=
 =?utf-8?B?MWdTMmdhempDRjVpREZna0hybmxUTXBIdDNONjA2d3F6bFVrZ0tEL2J2R21q?=
 =?utf-8?B?WWJJL3l1NGVORU5QendFOHU4K2VyMUhoNG5DOXIwZVJ1R1cvWm9hZzlsWC80?=
 =?utf-8?B?Z0JTT3duczRObDR6OVJMcWtBZmNlOElocDlKYzJBaWZiNEVHblQ1MHpZNFl4?=
 =?utf-8?B?R3Q1a0x2NnZNK09Bb2lvVUFFSkxGZitBOXJOZC9hNlJIUW9VVW5xMkRkQ3Bw?=
 =?utf-8?B?cnJ2bXZIQ3J6d1NQTm9BamtYdGwrS2QwUXVlUDJHRmc4TFdsZ2ZDQ2VNYmJ4?=
 =?utf-8?B?RHJKTldTZFF2ejZsblhDbjYwcG0yVlZpUi9IMGZqWUhldTRMOGpNUXFPQ3lP?=
 =?utf-8?B?aGdIdTJMMDZPNjg5eHV2YUVzM3hCRmpMVG1sbTlmRjdyNUFoMEMzWitSYVhl?=
 =?utf-8?B?VURKSVc3T1VZdjdHd3pTLzJaS1YzZ1JqU0R1V3ViNys1b2FPM0lSK3YyamVP?=
 =?utf-8?B?Tm9zQ2FsRFordUE5N09kQTdqcEFMdFUyWnVoTjBqbHRGMnBwanI1NGdFZlF1?=
 =?utf-8?B?Z2lLOFNLb3laTW96a0dqdUhObXJpZVN1elJXS2NiWnlFbEJ4dFlXZ1dXZFEx?=
 =?utf-8?B?TGdMek91eEpOYmZjMDRDZmpXeUdSSUFWV05XY2ZwTzV6ZURIZG9MTGJxUy9F?=
 =?utf-8?B?SVBDWFJnTFhTcm1ISy9ZdXFHaUxSYUJBSDVFb3RaVDl6cEgrYlIvMzJyYnFP?=
 =?utf-8?B?aU9YM1dZaTZmM0hPeGV4ditWb2ZZVnpLZmpYY3FwdW1CVlBnVm5vaWQrMTNi?=
 =?utf-8?B?OUpsRkJNWDdMYnNXMVJsRUJoWDBQUGVzQkl0SjhRZHl4S1RFVTltR3Zqelh2?=
 =?utf-8?B?dnhoYkVCS3czOVgrbWFHdG9iQnVTQmh3WlJlbTNBYXFPbUtmeWREYVU4QktG?=
 =?utf-8?B?Ukw5K2ZnaGtjeUZDMTFKWEVVc0VKNXhQcXdwSEVnWVJnc1VkVWgwU3Jab2tC?=
 =?utf-8?B?RWxoUWZYMjBJcWVGZ2NXVFB6SWsrT0ZoUGpacHJjZlRod0dHaTZIZTdnS2FN?=
 =?utf-8?B?aUFtRmdUb3ZUZ0YwZHpXbzY2U2JGTklxT2c0UWI5dDZQQlZEZzdXNWxPVWxo?=
 =?utf-8?B?Z09RL2kzUGZmaU4zZ2EzdEpKa0gxa2diTGVxQ2ZPOEt1aGFwSVhyT0s4YjJR?=
 =?utf-8?B?TDhrVXUwckpvQnpaY2xwS25RRXBBemZYSTcyRGZKZDhLa2dtZTdtOUdDZ3dt?=
 =?utf-8?B?SGJvYkMwbG5TSXp1emsrZGFBaUVxWVlXS2l6MEZId0VoUDQrVnZPaDYrWVBV?=
 =?utf-8?B?bDNKL1N5a1lza29XbWZhY3pydGpRUW9oOVhZUkx2bkRLenlOVkdoUURZN0o3?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5965fb-6a66-42b5-980c-08db34fb1d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:55:33.7354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qx/0m8BWeiyWY8PALSw7xcazgTdHDEj93AfCejfHYN+0XGDBIrTxBSmSXhxlUMOyWwGpYp5OU5LJMcsTHnXA01M1AAUPmnLLz9GNl1d8TAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9650
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiBNb25kYXksIEFwcmlsIDMsIDIwMjMgMzowOCBQTQ0KPiAN
Cj4gVGhpcyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA1
LjE1LjEwNiByZWxlYXNlLg0KPiBUaGVyZSBhcmUgOTkgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywg
YWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlv
bmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0
IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgV2VkLCAwNSBBcHIg
MjAyMyAxNDowMzoxOCArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1l
IG1pZ2h0IGJlIHRvbyBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJvb3Rl
ZCB3aXRoIExpbnV4IDUuMTUuMTA2LXJjMSAoYWFjZDYyMTQ5OTkxKToNCmh0dHBzOi8vZ2l0bGFi
LmNvbS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvLS9waXBlbGlu
ZXMvODI2Mzk5NzkxDQpodHRwczovL2dpdGxhYi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3Rpbmcv
bGludXgtc3RhYmxlLXJjLWNpLy0vY29tbWl0cy9saW51eC01LjE1LnkNCg0KVGVzdGVkLWJ5OiBD
aHJpcyBQYXRlcnNvbiAoQ0lQKSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5k
IHJlZ2FyZHMsIENocmlzDQogDQoNCg==
