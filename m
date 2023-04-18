Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A566E701A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 01:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjDRX4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 19:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDRX4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 19:56:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119557AAB;
        Tue, 18 Apr 2023 16:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681862166; x=1713398166;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=TDRNdS37M0y5W3+8wfHc0JplnlEsUIqcVixzjoabWMg=;
  b=MF2BM5RZnaUwEZnK5wnBCJc9c1tbR1afzhLqWP1380V4FRzYgenVnm2Z
   jlk8+CHqKXRsIsiMsv+LbO3B3txyPBjCRm+it+lZJHimqK/Hv4ZS8atG3
   kW9O8PM/FP50du+Rmw0jZ23KuJwCOLibZ3oDYaYQpJ5Ve/UtsajcgL7Nz
   HieUgnozUj6ulHj/AEDculyfV6T1TjNS26UpzRZx2119Vh2sTq8tVcihM
   MRxNYA36yLBJ/6Tb70Xsh2rlLmlV8k7ISQ5hS64ItDAJwL8UacR7AFLc3
   Rkqu8LJH/2ulsBkxzJUZHe72xYlqetGReEYVrpEd9prSW3G6esADcEDBy
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,208,1677567600"; 
   d="scan'208";a="209705488"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2023 16:56:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 18 Apr 2023 16:56:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 18 Apr 2023 16:56:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4sLGeItS6bQgL+9y5Su6dnGczLWdoXtT882vevcLPnWFyekOhahaEAxVySbP/dGOPw7JvNQVNsckuT8bdLfvVdiYzlj3R+LYd1PcoZFt8LHYANbFPOra6nv1iMeDsJGmOWiyqHjxQMo6mYnBfPP/pGp+Fb38paVOHMjMiXC5wG+hmIh2CDNtTNYoLmAbn4NSKF+t4fF+0iXJSUresym6CbDA+9vgXfOkwjC/saX4UpHjFmCS0PrYPmmZn8PEEsLeB+QnI31rpqRFT3aIY3H3UWCrYCrrCUYrO1vW1AK63gchdsJ0ITzVPyjJ05Lhrgo7Xz0EeXiXg9IWEepg3hq0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDRNdS37M0y5W3+8wfHc0JplnlEsUIqcVixzjoabWMg=;
 b=ga1WtFvFg2B78H5PVKc8jqQ8Sd8mPgMPYr5lUnzdw4dlReSE1fQ7qfS+oj8sSsg38q4m7NoifScibZNx2bW4r6/2eeKGGB/sY6BJuQ0c8B5m3EKlj6K0cXmfm73I6MWzRHC7Q43+VVN0rfCqDDbnDxjjWsiGFUwiBgAgrBLEjmdrwdN+j4nIxi9UFGxfCAMRsVxJnFFxzDj8Fub/5/8ZBk2h2DiCDHlmKh5W1xUjdkMv/l3gSkPNQ3qqTKtQQ6jrO/X59KQU9oyJerCh6RfwYpXqiU9tw0lf+nldN2S++aWEhdAnow/DEEiqEbAwWCmEe1wUV2ZUtCG7eAQu/ngUIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDRNdS37M0y5W3+8wfHc0JplnlEsUIqcVixzjoabWMg=;
 b=eKuvpA23halB4PgIHf3lbIYQXqyEslO9v/rWi17wxD01nMxXXgsEdKGyAuUtZc2Pu6GZIEH46edphr9xjMAQyDTIOBDn1G60SyfQKEb+iO7YIM5/Q1v09hFJSIwqZ1LMchkuVKqQ1ouRzjnLdXJLvp8VqsD6sXdcKGUhY1eUpoM=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by SA0PR11MB4750.namprd11.prod.outlook.com (2603:10b6:806:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 23:55:58 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 23:55:55 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <jejb@linux.ibm.com>, <john.g.garry@oracle.com>,
        <Don.Brace@microchip.com>, <Gilbert.Wu@microchip.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <brking@linux.vnet.ibm.com>, <stable@vger.kernel.org>,
        <Tom.White@microchip.com>
Subject: RE: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Topic: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Index: AQHZYb4PYBI21vPRIUeRtFcfEd9THa8RVvYAgBPI3YCADE6iAIAAcHog
Date:   Tue, 18 Apr 2023 23:55:54 +0000
Message-ID: <BYAPR11MB36062386E7B3DBE1FA69CEB4FA9D9@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
         <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
         <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
 <c5405999615929ba304988ebe18faf3853cc9a95.camel@linux.ibm.com>
In-Reply-To: <c5405999615929ba304988ebe18faf3853cc9a95.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|SA0PR11MB4750:EE_
x-ms-office365-filtering-correlation-id: 4c831067-42c5-4a64-e219-08db406872d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uiXaaDs2bpvz1sv3rJmecSnU1kv99RujcllcM9eLjW2R6Ke6rZL3ScR4YooNqQglMFuP/LOx0zJIdV/446DT8tZHWtjOfaI5odC9Az04WQWufpKiqzSlJMoY5ihu9n87duIAuIs0+nGdKn78KbTB56RqgBSlI58WFlMCos2PLDJXOUk/FKs1NzxtXTU2Qr2X6DhpUBQyxUU38qwoG9aslycaNEvdUQScoGr+iS+g5qk5o4esSa/SGHwhnpFxGIuUSRY0ufxYwO0kpbt9gRfFZR3+dP/ri9az+L6nSokxrc3izw061/l2Ik59ue6VSe3LuLmES7BPTVtTDmviSh+oD+AODEqKN0bt5gCFtmW3xN78k2wjwc5xXo8rfP/yGxABAG9Oj8anYY9Phm2BnQipCafukA7c8qayx56g0kNegPx9Jj3jaXP9+pGydvxouhw9f0ZNQ/CMB4lvFdiOisba0NDvKi8N3nILZMFnTPe0RyDz9kRKzYZqZ6tyyBtIMDMcxI86Oxq4tZoNBgGj82LVWrdUu2xZg0QYaz0txBYXTV5saZZff0LDVscI1jTIP0NgUacP7PvD38PpPCJcgUr5JKJ/mKUiUu5omoa8WkG7IQA+e0A4LOSWpffiew0yKBCF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199021)(52536014)(5660300002)(86362001)(6636002)(53546011)(83380400001)(122000001)(9686003)(186003)(26005)(6506007)(38100700002)(8676002)(38070700005)(8936002)(110136005)(33656002)(478600001)(71200400001)(7696005)(316002)(55016003)(41300700001)(76116006)(66446008)(66556008)(64756008)(66946007)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VURoSGpTVnUwT3RDeGhpUEd6VnQvZXpaUTYyV1MwR2U4eCsrVGtnb1hTbFdu?=
 =?utf-8?B?NWZPeEVSWU1xMk9oQnVCcUtxa3h6QkpiMU1yNUxaYXd4Vnc0aGVSbEFQODk5?=
 =?utf-8?B?V2dZbkpCUmFYZFp2cHRKWXZDWDY1OHIzK2JXVXByQTlaL1pscnVuanVHU3BJ?=
 =?utf-8?B?M1hCY3V1YkVnOGpEdWQ3aGNEOHJUTFVIazFTY1RJakRGSWlndnR4Mi85MS9q?=
 =?utf-8?B?TGF5K1NOOURzZzVaZ1VRQTZ6L3hXR0JyZ2kzR2E3dEg2ckpjZ1hwODlwekZJ?=
 =?utf-8?B?T1pWYXJFb1hiand2Z25BTjZWWW1TQXlVVDk5RVVuNHZEMmZRNDJ5aDV5Uk53?=
 =?utf-8?B?ZmROQXVlLzQrMFd0VHhqcFVsYm5lU0VpcVFJZ09BRDFZb0c1cnpabmR3Rlhv?=
 =?utf-8?B?Z3BXOEI3Nlk2M0ZsbmVSdjgrWnRJckZWWENlRm9yNzFYc0NCMFVkR0FJTVpS?=
 =?utf-8?B?R2c5aGE1ZEs1UWhRaElVcUVIL0U4a1VVMU5Hc214d0FDZ2o0aFRrWm5hTE1M?=
 =?utf-8?B?OGc4Wm12clNnTjNSWVgrVUlPcGNqOHYvUWpCekF5S0xCc0w4WERvZ3grSHY4?=
 =?utf-8?B?aU00UGg0S0NreW9HeEZkS3ltSlp3QytYeFMxOThmRGdXcFQvMFlqV09ZWEdP?=
 =?utf-8?B?UFkzYk5EWHlQRGtHTXM4eSs3N3BpNGNRdnY2SGxKcE9wR0NmUHFnd3cxdlBn?=
 =?utf-8?B?WWdvazA3SGhRQnI5dkxZTUI0YUpSalkvNm0xaUtySFd0K1gxVHk2Um0wZTdN?=
 =?utf-8?B?NSs5VnhNeXVJV1huWU0zUXFFSTZWTk1SZEpmK2d2V05NNU1vOThVRmJoQmZT?=
 =?utf-8?B?RlJXTG4xYW5CN3pzTU5GQWk3dFR0NngvYWx6L25aY0lnOVBYMWhabWllRXdv?=
 =?utf-8?B?dEpVYTJzRkdIazJ6ZW50bTArM1FpckR4VzE3eGxESGpkRDdKUG45MkVsSEhU?=
 =?utf-8?B?cFhUdDF5aFJieXU2V0EyTGtiVE1TUEdaVEw0d1FEbFEybk1USGhNeXRlaUh3?=
 =?utf-8?B?WlN1OEVwWXJ1dXIrdTlKa1Jvc2NYZld3YjJtSmx4Y3drWnpGUHNEakVQZ2Rr?=
 =?utf-8?B?ZmRtRTF3c3VXU0lNb0NFbmQ0eUUrVnJHQy9RNDF6eXRYbllTZ2NYWE1aTGtY?=
 =?utf-8?B?WjhoYkhFL3YvZVIxRG9sTnRMcWUySXJHTEhIMjhWcjF2TnNrVWdiRlhxRUxH?=
 =?utf-8?B?eXdBL3R2cmJsSzZFZXB0RFVyY3NLMjE3RXBwTnJFNjNvQlJrbThoQUl4cmo2?=
 =?utf-8?B?dGk0aHVGZFRzRVI3clBMS3l3bmFZekFIMVgyYmR1cDdwNWkxZUkxQWl3Vllj?=
 =?utf-8?B?MlNoR2FTd1JkTnIreDdHcnhPMFZ3QWVLUUtWTGhwMWhPQzdFR1R1RlBOWnhZ?=
 =?utf-8?B?M0w5NFpMMk1EYkdHdDZXWXNBS3JqKzB2emJibFlPTEJuLzdTM3kyV01QSXlY?=
 =?utf-8?B?VzRJSm1iY0dlaDVpY1E0YlRZdDdYbUhGbkhrOFVOelFZM2Zza08yYm9DS0Fz?=
 =?utf-8?B?NkF2anNmVXBDVTRXTFF5eWJrRWlDRTVrcmIydmhzODZJM1p0STU4cDdzRFpY?=
 =?utf-8?B?WUtTenVaWWg4MDYzTjlYQ1U4YzhOeUpvYUZIL1hRc3o2MXJRNXVTcHEzRDg2?=
 =?utf-8?B?ZmJYbEExQlB2RXFjTmpzMHBSUlpKZm94M0s0QXJ0OXRhcXN1SnJPdy9RNGVT?=
 =?utf-8?B?b3V4akVkUVB3OWxkMFY3LzY0Zm9NamRyMVh4MGFFOXpTbDJLVVBHaHd1dXRv?=
 =?utf-8?B?b1c0TDA5TkQzdUs4Szd5SW5TaTFNc292YmNrTjJoV3NlR091eG9zVVBZUUEx?=
 =?utf-8?B?cStlWE5nWi9nakxDaWxDdll0T0orYlZXM3lkMDBxQ2VZVGZBa3RUVll5enZn?=
 =?utf-8?B?b0V1ano5UXAwdUt1dU1JWVdYbG43Z09TSm14R3YzYmlPTEJCNHVFRWRvZzBx?=
 =?utf-8?B?eFhZY0ZmRjB3OUFweklnVjZwdnBNSUlEYW1vM0hJcW9OL0dtY2xhYlZiQzF0?=
 =?utf-8?B?c3JqazR1MlduVUtXWTg3cXdic1ZoZWxtYkF6cXF6WS93ZjhaaWxPL2Q3NXRQ?=
 =?utf-8?B?Nkc2MWtUZ1ZlN0wxeTR6S0dGWkptRVp4WlBFK3Vrcnc1QldKZHdpYkV6WGpi?=
 =?utf-8?Q?trnn7aNZh/4h68/kak2ki1+RE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c831067-42c5-4a64-e219-08db406872d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 23:55:55.0113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipy7AH/tVtuLCpSBkt5vD+tTZEsFI18AQMHWMlIbNTSftYnOOgNt4Zl3pVut2nasU0jW6Zu1B51mMSI1HNTxgJz68O67XBzzEJz71YAq8HA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4750
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKYW1lcyBCb3R0b21sZXkgPGpl
amJAbGludXguaWJtLmNvbT4gDQpTZW50OiBUdWVzZGF5LCBBcHJpbCAxOCwgMjAyMyAxMDoxMyBB
TQ0KVG86IFNhZ2FyIEJpcmFkYXIgLSBDMzQyNDkgPFNhZ2FyLkJpcmFkYXJAbWljcm9jaGlwLmNv
bT47IGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tOyBEb24gQnJhY2UgLSBDMzM3MDYgPERvbi5CcmFj
ZUBtaWNyb2NoaXAuY29tPjsgR2lsYmVydCBXdSAtIEMzMzUwNCA8R2lsYmVydC5XdUBtaWNyb2No
aXAuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IG1hcnRpbi5wZXRlcnNlbkBvcmFj
bGUuY29tOyBicmtpbmdAbGludXgudm5ldC5pYm0uY29tOyBzdGFibGVAdmdlci5rZXJuZWwub3Jn
OyBUb20gV2hpdGUgLSBDMzM1MDMgPFRvbS5XaGl0ZUBtaWNyb2NoaXAuY29tPg0KU3ViamVjdDog
UmU6IFtQQVRDSF0gYWFjcmFpZDogcmVwbHkgcXVldWUgbWFwcGluZyB0byBDUFVzIGJhc2VkIG9m
IElSUSBhZmZpbml0eQ0KDQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KW0kn
bSB3aXRoIEpvbjogeW91ciBlbWFpbCBzdHlsZSBtYWtlcyBkaWdnaW5nIGluZm9ybWF0aW9uIG91
dCBvZiB0aGUgZW1haWxzIHZlcnkgaGFyZCwgd2hpY2ggaXMgd2h5IEkgb25seSBxdW90ZSB0aGlz
IHNlY3Rpb25dIE9uIE1vbiwgMjAyMy0wNC0xMCBhdCAyMToxNyArMDAwMCwgU2FnYXIuQmlyYWRh
ckBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPiAqKipibGstbXEgYWxyZWFkeSBkb2VzIHdoYXQgeW91
IHdhbnQgaGVyZSwgaW5jbHVkaW5nIGhhbmRsaW5nIGZvciB0aGUgDQo+IGNhc2UgSSBtZW50aW9u
IGFib3ZlLiBJdCBtYWludGFpbnMgYSBDUFUgLT4gSFcgcXVldWUgbWFwcGluZywgYW5kIA0KPiB1
c2luZyBhIHJlcGx5IG1hcCBpbiB0aGUgTExEIGlzIHRoZSBvbGQgd2F5IG9mIGRvaW5nIHRoaXMu
DQo+DQoNCj4gV2UgYWxzbyB0cmllZCBpbXBsZW1lbnRpbmcgdGhlIGJsay1tcSBtZWNoYW5pc20g
aW4gdGhlIGRyaXZlciBhbmQgd2UgDQo+IHNhdyBjb21tYW5kIHRpbWVvdXRzLg0KPiBUaGUgZmly
bXdhcmUgaGFzIGxpbWl0YXRpb24gb2YgZml4ZWQgbnVtYmVyIG9mIHF1ZXVlcyBwZXIgdmVjdG9y
IGFuZCANCj4gdGhlIGJsay1tcSBjaGFuZ2VzIHdvdWxkIHNhdHVyYXRlIHRoYXQgbGltaXQuDQo+
IFRoYXQgYW5zd2VycyB0aGUgcG9zc2libGUgY29tbWFuZCB0aW1lb3V0Lg0KDQpDb3VsZCB3ZSBo
YXZlIG1vcmUgZGV0YWlscyBvbiB0aGlzLCBwbGVhc2U/ICBUaGUgcHJvYmxlbSBpcyB0aGF0IHRo
aXMgaXMgYSB2ZXJ5IGZyYWdpbGUgYXJlYSBvZiB0aGUga2VybmVsLCBzbyB5b3Ugcm9sbGluZyB5
b3VyIG93biBzcGVjaWFsIHNub3dmbGFrZSBpbXBsZW1lbnRhdGlvbiBpbiB0aGUgZHJpdmVyIGlz
IGdvaW5nIHRvIGJlIGFuIG9uZ29pbmcgbWFpbnRlbmFuY2UgcHJvYmxlbSAoYW5kIHRoZSBmYWN0
IHRoYXQgeW91IG5lZWQgdGhpcyBhdCBhbGwgaW5kaWNhdGVzIHlvdSBoYXZlIGxvbmcgdGFpbCBj
dXN0b21lcnMgd2hvIHdpbGwgYmUgYXJvdW5kIGZvciBhIHdoaWxlIHlldCkuICBJZiB0aGUgb25s
eSBpc3N1ZSBpcyBsaW1pdGluZyB0aGUgbnVtYmVyIG9mIHF1ZXVlcyBwZXIgdmVjdG9yLCB3ZSBj
YW4gbG9vayBhdCBnZXR0aW5nIHRoZSBibG9jayBsYXllciB0byBkbyB0aGF0LiAgQWx0aG91Z2gg
SSB3YXMgdW5kZXIgdGhlIGltcHJlc3Npb24gdGhhdCB5b3UgY2FuIGRvIGl0IHlvdXJzZWxmIHdp
dGggdGhlIC0+bWFwX3F1ZXVlcygpIGNhbGxiYWNrLiAgQ2FuIHlvdSBzYXkgYSBiaXQgYWJvdXQg
d2h5IHRoaXMgZGlkbid0IHdvcms/DQoNCltTYWdhciBCaXJhZGFyXSANClRoYW5rIHlvdSBmb3Ig
eW91ciByZXNwb25zZS4NCldlIGRpZCB2ZW50dXJlIHRyeWluZyBpbnRvIHNvbWV0aGluZyBsaWtl
IHdoYXQgeW91IHBvaW50ZWQgdG8uDQpXZSBtYXBwZWQgdGhlIGhhcmR3YXJlIHF1ZXVlcywgYW5k
IHdlIHN0aWxsIHNlZSBjb21tYW5kIHRpbWVvdXQuIFRoaXMgY2hhbmdlIGRvZXNu4oCZdCB3b3Jr
IGZvciB1cyBhdCB0aGlzIHN0YWdlLiANCkFsc28sIHdlIG9ic2VydmVkIHRoYXQgdGhlIGxvYWQg
aXMgbm90IGJhbGFuY2VkIGFjcm9zcyBhbGwgdGhlIENQVXMuDQpJIGFtIHBhc3RpbmcgdGhlIGNv
ZGUgc25pcHBldHMgZm9yIGJldHRlciB1bmRlcnN0YW5kaW5nLg0KDQoNCkR1cmluZyB0aGUgcHJv
YmUsIHdlIGFzc2lnbmVkIHRoZSBoYXJkd2FyZSBxdWV1ZXMuDQpzaG9zdC0+bnJfaHdfcXVldWVz
ID0gc2hvc3QtPmNhbl9xdWV1ZTsgLy9pbnNpZGUgYWFjX3Byb2JlX29uZSgpLg0KDQpXZSBhbHNv
IHdyb3RlIGEgbmV3IHJvdXRpbmUgImJsa19tcV9wY2lfbWFwX3F1ZXVlcyIgKG1hcHBlZCB0byAu
bWFwX3F1ZXVlcyBpbiBzY3NpX2hvc3RfdGVtcGxhdGUpLg0Kc3RhdGljIHZvaWQgYWFjX21hcF9x
dWV1ZXMoc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QpDQp7DQogICAgICAgICAgICAgICAgc3RydWN0
IGFhY19kZXYgKmFhYyA9IChzdHJ1Y3QgYWFjX2RldiAqKXNob3N0LT5ob3N0ZGF0YTsNCiAgICAg
ICAgICAgICAgICBibGtfbXFfcGNpX21hcF9xdWV1ZXMoJnNob3N0LT50YWdfc2V0Lm1hcFtIQ1RY
X1RZUEVfREVGQVVMVF0sDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBhYWMtPnBkZXYsIDApOw0KfQ0KDQpXaXRoIHRoZSBhYm92ZSBjaGFuZ2Vz
LCB3ZSBzZWUgY29tbWFuZCB0aW1lb3V0cyBpbiB0aGUgZmlybXdhcmUgc3BhY2UgYW5kIHRoZSBj
b21tYW5kcyBuZXZlciByZXR1cm4gdG8gdGhlIGRyaXZlci4NClRoaXMgbWF5IG5lZWQgc29tZSBj
aGFuZ2VzIGluIHRoZSBmaXJtd2FyZSwgYnV0IHRoZSBmaXJtd2FyZSBjaGFuZ2VzIGFyZSByZXN0
cmljdGVkIChzaW5jZSB0aGlzIGlzIEVPTCBwcm9kdWN0KS4NCkFsc28sIHdlIHNhdyB0aGF0IHRo
ZSBsb2FkIHdhcyBlbnRpcmVseSB1cG9uIG9uZSBDUFUgYW5kIGl0IHdhcyBub3QgYmFsYW5jZWQg
YWNyb3NzIG90aGVyIENQVXMuDQoNCldlIGhhdmUgaGFkIHRoaXMgcmVwbHlfcXVldWUgbWVjaGFu
aXNtIChwYXRjaCkgaW4gb3VyIE91dCBPZiBCb3ggZHJpdmVyIChPT0IpIGZvciBtb3JlIHRoYW4g
dGhyZWUgeWVhcnMuDQpXZSh2ZW5kb3JzL2N1c3RvbWVycyBpbmNsdWRlZCkgaGF2ZSBub3Qgb2Jz
ZXJ2ZWQgYW55IGlzc3Vlcy4NCg0KDQpKYW1lcw0KDQo=
