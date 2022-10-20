Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFDB6057E6
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 09:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJTHJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 03:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJTHJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 03:09:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11FF152C79;
        Thu, 20 Oct 2022 00:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666249745; x=1697785745;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cv3ZrWJuE7/C/fQ57jlLfqfwlw6jYW/ulg5igHv3ChA=;
  b=l+6t8XBNt/THI01uQFiFX4HLRUbBAgZStoBF0ZMsifG5tyDpKjAvvgeg
   WyigxGzCVDPK5drHtWq9XVGODsDFhsOcLsm2wyLqtEptFcZu745MESMBI
   qd5D+d/11ol3zCEtHNhSA+fBDuKQuYLiGZsP7xnuf96+2BrqN/fz6/Ivb
   iddP63wBBEksdwL3JuuLEus8l4vn/CYEOZDZCNNpSLKX9Sn7c2+gsuEnM
   wY5+T8ImQWOlHixJv+qqeP8ipwQeJpNXgilouz2XtjVkGmndiUpt1LJ/9
   qFsFU9gEZ2nXuPQqRxGQMoxbSjoiAPzMtCfG1vEGp6ixckOclA+0zoOG+
   A==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="183092493"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 00:09:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 00:09:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 20 Oct 2022 00:09:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUrAsSWqQm5nC2D7Yre/pVUGlryKaJXVOcYu9M4ugjENlVLxCJ6X5pbP/bbEi/p6wdpf1DqdN9SMD0w43IEER2CFzyeRpC8o0jfm0KK9UaawS8cEWX07TRmO7A2etbQn/6+tGsZJ074UMvZzQBmwioM8deAzkyyempevJ0SBiB+hDYuEtozWLP3SqLQRuauAmLda2J/PdyVDLzANZsEf2rMG3wwLRkhLAIcxZcBKB45CRV9NN/cjIKXmc1WJPGPb2piSo599iuA5qSQ2xQstv9Aj1ZsUrUuCJVQfMws4HtcqeCqRqLEfbOjMwFqhKdtyaTDveV9YfkNedeY4y9dw+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cv3ZrWJuE7/C/fQ57jlLfqfwlw6jYW/ulg5igHv3ChA=;
 b=VMDxahSIo/0SjIuehlCCfuGL+r8HmwntAHRIzut+/p2uRL0ZFhjTdmh3fzBo+mWLglijvJMnpLNkQ/X4MTdk9/D/sKvodF5Zl+OPWtvO8/hwUenw/KojN52ElCwccNZJJagIcPr9R1RXA+38uwetGJvxtw1zP0o/tj0cugFPLlQA9U9+CkEiInkEIk37m6Zrrs4MJtaYwgOg/8tAiFmw4V1YgdBQMRI8JPVhk0mnWKr+qMWswWFu+GenIQMXhIMJHJqs2UB6a6IZ5/sWF6VgFaiz2iT0ZQFMCr9PZiRJB+s228UwM7h5O2cHk3elfqUCHvFKob0TFULY/wZ8PMLjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cv3ZrWJuE7/C/fQ57jlLfqfwlw6jYW/ulg5igHv3ChA=;
 b=jBNeAzeyM8gxd1K3CSio3limduFS/pEg7504Qwbz72SFt6N+yL7d902JnCfnFDmk6WfvLYHCdhgXnVSskSlRXHkN3TQEmDH8rgBVIxIE/C1nKrZ3xqdu+qdH1eFP4OsQaIWuz7FxLmkbuLaSdK1E8/IPO2PBZU4xq0x5Oy22kuE=
Received: from DM4PR11MB6479.namprd11.prod.outlook.com (2603:10b6:8:8c::19) by
 PH7PR11MB6605.namprd11.prod.outlook.com (2603:10b6:510:1b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 07:08:55 +0000
Received: from DM4PR11MB6479.namprd11.prod.outlook.com
 ([fe80::cf13:1785:f79d:9eb9]) by DM4PR11MB6479.namprd11.prod.outlook.com
 ([fe80::cf13:1785:f79d:9eb9%7]) with mapi id 15.20.5723.032; Thu, 20 Oct 2022
 07:08:55 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <vkoul@kernel.org>
CC:     <peda@axentia.se>, <du@axentia.se>, <regressions@leemhuis.info>,
        <Ludovic.Desroches@microchip.com>, <maciej.sosnowski@intel.com>,
        <dan.j.williams@intel.com>, <Nicolas.Ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tudor.ambarus@gmail.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 07/33] dmaengine: at_hdmac: Fix at_lli struct definition
Thread-Topic: [PATCH 07/33] dmaengine: at_hdmac: Fix at_lli struct definition
Thread-Index: AQHY5FLQasSuHlViqUGi0qrL9YJV0Q==
Date:   Thu, 20 Oct 2022 07:08:55 +0000
Message-ID: <7a80bcf5-302e-0263-cbcd-e288be374b1a@microchip.com>
References: <20220820125717.588722-1-tudor.ambarus@microchip.com>
 <20220820125717.588722-8-tudor.ambarus@microchip.com>
 <Y1AoDDVoiWDJ2ae2@matsya>
In-Reply-To: <Y1AoDDVoiWDJ2ae2@matsya>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6479:EE_|PH7PR11MB6605:EE_
x-ms-office365-filtering-correlation-id: c49913a4-8221-402b-f906-08dab269f37e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bbrgOpVWp+89ViFsOhMjletxp8m4I+GmdlZiq5ZK5bAwPNoFLs9D9q1ePOP+b4adJqI209eHSB1HgZfgN3mhwbwtJH6xrs73JvuDARreFKYQuHvLYUmCX4DdjN5FIB6p3ELgxXIZQ/o+s7jJymP6eJ2BLDbHPWklG8fcsipUezTYNWLvbrHEiOnX/luVAagr6h1GS/IfQc1lAtzNyh6l2zVNYEsdnRhdcO/8c3BGyXL+tgX2jH9Uk3nq0peEjBdACBBg5t1rQQSB7MdeYvkpglZjMQjpLHr5X6/W9SRBH3J5aC/Y6DwCF0CorUhWafdEVXE+9qzFKCuxEatgOmYG7vInqDHF1VofQLUMrZ/C8dioBO1oeHCfL4AdFfZIFsC0RunZ1hx0pkNZnEXouqOdGXNLlJ+0rytff37c7R9pprYna85GwefEc5VV1tbUPu05VwFXeLUlU7VZqBpMIngCk+kU8rTWnmNmC9EKIQfj6dkjMzcwS/VquCNlVZkaS4pFCh78kmZVtbpxMlhVx3n01a7S4asGZ6iRu7V624KXAkrBlODAQA97UBb3EesDrW1ZGk9+60/TpHbkBRVV7XT4Do1rXJ3OwSx8j800HfQ6SSiHNwKrQXk3rLLAN2MpvfQgDxqgC1/zhdBXGucsIQV57wMNbniyPWngJql3JN6Rlx0PJidFX96scblRe6NQwXQd70Hyn8xOs4ye4q/erzjEYP2S976qOH1Qdtu6iOtyQ+UTMzxk8n0ru9VuPr+tRe5GhSszuxqtSJyegSnurHR5LqS3Fhz70UMwm6KjRp1DbUhoM8ZGNdF4PERNGlCcK3fO1cOeymxAXaL5jXCxnXH0GQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6479.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(38070700005)(122000001)(38100700002)(478600001)(6916009)(54906003)(4326008)(64756008)(66446008)(53546011)(6506007)(76116006)(66946007)(66556008)(66476007)(8676002)(186003)(316002)(2616005)(71200400001)(6512007)(91956017)(31686004)(7416002)(6486002)(8936002)(36756003)(41300700001)(2906002)(26005)(86362001)(5660300002)(83380400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RS8rVmdKMGJFamxSZHltMUd1b1JvcTJjbGJ5Mk1MMWc3YlVpS25GVnRmRHBQ?=
 =?utf-8?B?aXpuTldCaEpjc3pvdllPL0ZjNUlSWVV6UkcxeUd5K3pxQ1lRQkRXVENxQlg4?=
 =?utf-8?B?SjZsc0Y5bzA3NGtaVVNtUGtwMzAwMlJaekQ0MEd0NVJ5cmtGZWJSVkFuTHRT?=
 =?utf-8?B?Mnc0QXN1N3hTQmlDZXowcG5wcVJhSFF4cG9NMTdaWVgyS0V1YVc2VWxjbFVM?=
 =?utf-8?B?YTQyUytvQy9jdmM5Mi9vZ3loWXFuRlQ5bkgzT29mSGxtek9sTXJwQU1CUlRX?=
 =?utf-8?B?ODM0VWt4TFRub3Fqa0RHeHlrb0RlWS9nQkdSMnVwUTlyVWF4R1RkWFp0R29N?=
 =?utf-8?B?QW9DNUV6QzlST2U0VHhaOGlHbTZHY3RSU01wT0lMN05QTVh1SkxIcmVkcVN6?=
 =?utf-8?B?aFFvNjRkZHlVZXZ0WFhIU21QOGFjbjh0MDkyUy9tWEF2VDRZSUZneDhoNGNX?=
 =?utf-8?B?c2FleXhoRDFPQ2xlTWZjYzF5ZlArUVAvOGFCSGgxUWpOWWdmSVhRQVVSVXU4?=
 =?utf-8?B?MERMdzRyZEJMRERveHdQOTh6MEFBaDJ2ZFI1SG9OS2N0dzB2c2JlVHpic2dV?=
 =?utf-8?B?NU9DQm5Pak9PTE8rVUE1aXB2YU9sbVJlR2JHbk9iSG96c0d1UjR5WjhvOXBN?=
 =?utf-8?B?Q0hBTC9XVkFwd3N0YVRvbWkzMW0wZVJDbTd1anNoaHA2VFNMR3hvYjlwMDJM?=
 =?utf-8?B?R05iYVIzR2hqNFE5QklHbThQR3E3V2lWQXNWZkJEallPZWIzMlhyTSs1TUFp?=
 =?utf-8?B?T2wrNVFaSTdnMTlKT2REZkhzTHpXNlZpYVVWUDlmd2xYUlBGUEJUTDBROXdO?=
 =?utf-8?B?OGZGd1IvODFIbkVXbE9jbEtqeWEyWWJJVWlXRTY2VS8vdU5wU1BnZytUd0F3?=
 =?utf-8?B?VnBwTS91L1RTKzhHWmdKTFJpVE90cTQ1YzVrTXB3ZVFIcDIzdW1TU3hldXNP?=
 =?utf-8?B?V2ttbjNUWE9FVXBKS3VsdGdqTS9WWlZkNXJKWXF5YjVDcmhac2ZkYWlnODJj?=
 =?utf-8?B?NlpJQkRpOENjZXpiaXEwaEhhRWxQbmRLdXg3bnhFckRtUUZZNEtaTXpkR2FZ?=
 =?utf-8?B?L1BPRG9EWDJSaWZwd2tJeDF2SEdyZUhrRmRMYWQ3TXdVLzFuUVQ0QS9IZXM2?=
 =?utf-8?B?VGRDaWd2STNOWXlZeENPUXF3ZDd2dEZkaWVRbmIzdHZhRDllNFJId3J6L1Jo?=
 =?utf-8?B?WDY2VnNDaU5rQ1lMT1JYekZKaGxXaEtYNy8raHBRSDk0VEhmYzhOS283cDJW?=
 =?utf-8?B?ZVFKM3JyY08xRmpINDRldXhlTThiV0pWQ29DQ1N2M3lKcU5kY2RLNnhhN25C?=
 =?utf-8?B?Z0RPVFAvUFUxbVRjR0hRR2ttdENJWkFZcytYcG5YMkN0NUJqdU9kRGtxNWtk?=
 =?utf-8?B?eGxudFk3Rlp4RjI3eVRDQU1DamtSaW1HcHpVTkZmSWZzdDF2Nk15Nm5rZWJ0?=
 =?utf-8?B?OExiN2o5dk8wdzhsYTR6ZHFnazRtTjNvckZnbmtnUGVlakwxL2E5VkkyL2x4?=
 =?utf-8?B?Ni91S3J3RThmNnM4clkrcGFla29KTzNOOGxVYUxheTBYNFdNemx3SW42dlQ0?=
 =?utf-8?B?ZFdKa0diYkpRQTAzNjVnN1lhMUlFKzh1UFIwNUZoUGs0Mm42TG5SWEMvZmpL?=
 =?utf-8?B?NWQ4c29jdUV3bk4xT2l2cUk3ZitpbUdkaFFzQUJyaHFDVTFTbE5OalBQVHJi?=
 =?utf-8?B?WXg4MEJhZ1pHVGIrdGQ0REdqbjJjMjVVSjU1SXpjMERGRjVXRjlMUEc4Sk9M?=
 =?utf-8?B?R1RIWmxKTnA2WEluU1A0RlZlMEY4ZmtFazl0Zk5Bd3pKam9qT3NiRTJ2M2t4?=
 =?utf-8?B?Ry9ySmVhS0Q0dFNUeDBRSTZCZWtMZkRTVThqTnphTys5M250WjVCSXBLRzU2?=
 =?utf-8?B?Q09BeFhra3dtR0Z2NzVXMzZJUnF6OFRRVXorZnB5WmxnWG1EZ0FRRSszVjRx?=
 =?utf-8?B?WTFzTityTml4NlozMjJwUm53WW9VcUIxV1NqczhtSjJicDlCTDVNS21qSEJR?=
 =?utf-8?B?VmJYVHF3L0p6elBxcDgrNkpmZ1ZVMTV4S3JWSURGRjdhMWt3MXdEYnc2QTRC?=
 =?utf-8?B?dUsrTzFOajd6bmlYaWVVcGdJUWZPZXlOQ0Y0N3B1TXRQbk12d3BwdUdyYnBv?=
 =?utf-8?Q?6TVvSNm3f3db9vaa1vVDVJD3z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58AD8AEBFE8714418C74CAF2C07600C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6479.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49913a4-8221-402b-f906-08dab269f37e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 07:08:55.2373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fGFfbENUp5ALW4dW02YCC8TEaGcsBePyDxn7m1LJjbHb5GLUzCLcGwTaGYpx3v4jHIIm7joSUn7QEXupFgk4AfRbQUzOVw93cNfux01JYGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6605
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTAvMTkvMjIgMTk6MzgsIFZpbm9kIEtvdWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhl
IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gMjAtMDgtMjIsIDE1OjU2LCBUdWRvciBBbWJhcnVz
IHdyb3RlOg0KPj4gRnJvbTogVHVkb3IgQW1iYXJ1cyA8dHVkb3IuYW1iYXJ1c0BnbWFpbC5jb20+
DQo+Pg0KPj4gVGhvc2UgaGFyZHdhcmUgcmVnaXN0ZXJzIGFyZSBhbGwgb2YgMzIgYml0cywgd2hp
bGUgZG1hX2FkZHJfdCBjYSBiZSBvZg0KPj4gdHlwZSB1NjQgb3IgdTMyIGRlcGVuZGluZyBvbiBD
T05GSUdfQVJDSF9ETUFfQUREUl9UXzY0QklULiBGb3JjZSB1MzIgdG8NCj4+IGNvbXBseSB3aXRo
IHdoYXQgdGhlIGhhcmR3YXJlIGV4cGVjdHMuDQo+Pg0KPj4gRml4ZXM6IGRjNzhiYWEyYjkwYiAo
ImRtYWVuZ2luZTogYXRfaGRtYWM6IG5ldyBkcml2ZXIgZm9yIHRoZSBBdG1lbCBBSEIgRE1BIENv
bnRyb2xsZXIiKQ0KPj4gU2lnbmVkLW9mZi1ieTogVHVkb3IgQW1iYXJ1cyA8dHVkb3IuYW1iYXJ1
c0BnbWFpbC5jb20+DQo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiANCj4gT2theQ0K
PiANCj4+IC0tLQ0KPj4gIGRyaXZlcnMvZG1hL2F0X2hkbWFjLmMgfCAxMCArKysrKy0tLS0tDQo+
PiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4+DQo+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvYXRfaGRtYWMuYyBiL2RyaXZlcnMvZG1hL2F0X2hk
bWFjLmMNCj4+IGluZGV4IDkxZTUzYTU5MGQ1Zi4uZTg5ZmFjZjE0ZmFiIDEwMDY0NA0KPj4gLS0t
IGEvZHJpdmVycy9kbWEvYXRfaGRtYWMuYw0KPj4gKysrIGIvZHJpdmVycy9kbWEvYXRfaGRtYWMu
Yw0KPj4gQEAgLTE4NywxMyArMTg3LDEzIEBADQo+PiAgLyogTExJID09IExpbmtlZCBMaXN0IEl0
ZW07IGFrYSBETUEgYnVmZmVyIGRlc2NyaXB0b3IgKi8NCj4+ICBzdHJ1Y3QgYXRfbGxpIHsNCj4+
ICAgICAgIC8qIHZhbHVlcyB0aGF0IGFyZSBub3QgY2hhbmdlZCBieSBoYXJkd2FyZSAqLw0KPj4g
LSAgICAgZG1hX2FkZHJfdCAgICAgIHNhZGRyOw0KPj4gLSAgICAgZG1hX2FkZHJfdCAgICAgIGRh
ZGRyOw0KPj4gKyAgICAgdTMyIHNhZGRyOw0KPj4gKyAgICAgdTMyIGRhZGRyOw0KPiANCj4gSSB0
aGluayB5b3Ugc2hvdWxkIGFkZCBmaXhlcyBmaXJzdCBpbiB0aGUgc2VyaWVzIGFuZCB0aGVuIGRv
IGhlYWRlcg0KPiBtb3ZlLCB0aGF0IHdheSB3ZSBjYW4gYmFja3BvcnQgdGhpcyBhbmQgb3RoZXIg
Zml4ZXMgdG8gc3RhYmxlIGtlcm5lbHMuLi4NCg0KUmlnaHQsIHdvdWxkIGJlIGVhc2llciBpbmRl
ZWQuIFdpbGwgZG8sIHRoYW5rcy4NCg0KQ2hlZXJzLA0KdGENCj4gDQo+PiAgICAgICAvKiB2YWx1
ZSB0aGF0IG1heSBnZXQgd3JpdHRlbiBiYWNrOiAqLw0KPj4gLSAgICAgdTMyICAgICAgICAgICAg
IGN0cmxhOw0KPj4gKyAgICAgdTMyIGN0cmxhOw0KPj4gICAgICAgLyogbW9yZSB2YWx1ZXMgdGhh
dCBhcmUgbm90IGNoYW5nZWQgYnkgaGFyZHdhcmUgKi8NCj4+IC0gICAgIHUzMiAgICAgICAgICAg
ICBjdHJsYjsNCj4+IC0gICAgIGRtYV9hZGRyX3QgICAgICBkc2NyOyAgIC8qIGNoYWluIHRvIG5l
eHQgbGxpICovDQo+PiArICAgICB1MzIgY3RybGI7DQo+PiArICAgICB1MzIgZHNjcjsgICAgICAg
LyogY2hhaW4gdG8gbmV4dCBsbGkgKi8NCj4+ICB9Ow0KPj4NCj4+ICAvKioNCj4+IC0tDQo+PiAy
LjI1LjENCj4gDQo+IC0tDQo+IH5WaW5vZA0KDQotLSANCkNoZWVycywNCnRhDQoNCg==
