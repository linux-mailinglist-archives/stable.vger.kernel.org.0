Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2968B6E16C1
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 23:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDMVxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 17:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDMVxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 17:53:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977518A6A;
        Thu, 13 Apr 2023 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681422776; x=1712958776;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ixi/248sX5fQYIvw3gafQzCjG9iGNd2MaeQJUXFK6Xs=;
  b=Tiyk5uPmF49xxkNoPHPrLksA1zlNYPkPfO1B3ciz3WWOGAyddlz5391i
   qDCHBIUH2ePUUfpyCdOmu1gkk8eDbgCH69yPGEqf95XqTyEadiV9H4Q5o
   edH9tRBpXmnVjloy5vfrk84HF1nN4qSUx1xSMy0ODqhhzFZqYhUnS/6pH
   Jg53AInmid4t/qFf8cyGjiNMLWamIkaM1ssDkFlY1IRwxttZYKumqhTCS
   AtG6aKy3PjhYN3bkURmjA9aObuBhLYP6yR00gksrkhAaKUIMAZvllM7wV
   b54LDO+ApXfXboo5oQ9ZX5azOY6NuevxRtTBgGst1t4H0L5TDB8V2Lcoo
   g==;
X-IronPort-AV: E=Sophos;i="5.99,195,1677567600"; 
   d="scan'208";a="206437397"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2023 14:52:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 13 Apr 2023 14:52:54 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 13 Apr 2023 14:52:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKg4m5n/lfqNRXZxwJMy/XyIlK+UmqsbsF3dfiB028mvtxgQsmHNXORsabwdjU/MOshNhTljBTyY2Y0F0M8/NT7xgpyUMeXw5nFm+9dqpiI4Ssdl7X+g4JYzpSTDIj4LoSVYg3wn/OrRH35Freajne0shqhEqdSBOIubhKn72jqNvCbMPz6NFCEsGk4VFmtEjNIEKb/1OK/lBdFXQYEFXPK9GllYbzHlqZfwLE4hMlPMWik1UipawcDnkPy/nKrJzJif9w3VqQfKWG6TYTYVOe+vE0GDpc0Yz++1vxzCE9N+jOP3VTrDXI45fSKcyLuNqCyJcLWehQXgFooTBcKOcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixi/248sX5fQYIvw3gafQzCjG9iGNd2MaeQJUXFK6Xs=;
 b=U2uQFvPQj80YG/EnSyg4UL/o6yUX1cfKZ5s5+uPf2La1KjtFyY1SLOORlZQP7r62Z6yDjzzqwhdq9ArA5aUayW6cDoQJ00v8O5EiA+dWBxAak9BTGwqVNn9hgaYIEGmkbgDxtJ+sXecZgY1axO0WjN8IwQK6YtHFjN5OdbYJJsrRkII01M6irJxMbcboMFU8UTEaQ1hAk+gg2jxjdLCkXZ+QX3KJQR8RbedkeCqRSQWsEw2CZIBnuJ6oqfExuBKKoxbZ5mzkO79tW6y/BH9gmkPdT4MdtbUlvTTZvJnWdAwnYS/E+yZPcwq9mcYzlv+n/cI5ITVJ7iUsccuxKPEtew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixi/248sX5fQYIvw3gafQzCjG9iGNd2MaeQJUXFK6Xs=;
 b=Qy1zMgq5CgI7/rkb5ivaTv4GMO0H0FR4oZwuBWlpu8wsZS2+9qecSjom+4qMYxDmw6J/YWJSeHxMdZYXR/1S4qQr3CqhJgJI6CT6dNO7SpAGE1MsE3vD4U0Y1Px/DVrOavFhNQBUILs6IL7qX7UQuqpyaeICGv2esfe+8s2U/LI=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Thu, 13 Apr
 2023 21:52:52 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064%6]) with mapi id 15.20.6298.028; Thu, 13 Apr 2023
 21:52:52 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <john.g.garry@oracle.com>, <Don.Brace@microchip.com>,
        <Gilbert.Wu@microchip.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <brking@linux.vnet.ibm.com>, <stable@vger.kernel.org>,
        <Tom.White@microchip.com>
Subject: RE: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Topic: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Index: AQHZYb4PYBI21vPRIUeRtFcfEd9THa8RVvYAgBPI3YCAAmG6gIAApQoQgAG5e0A=
Date:   Thu, 13 Apr 2023 21:52:52 +0000
Message-ID: <BYAPR11MB3606A019F9557536CB0D47C9FA989@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
 <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
 <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
 <BYAPR11MB36066650D56088B1B7EB1D75FA9B9@BYAPR11MB3606.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB36066650D56088B1B7EB1D75FA9B9@BYAPR11MB3606.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|PH0PR11MB5580:EE_
x-ms-office365-filtering-correlation-id: 1a775088-0ecf-46a5-8db9-08db3c696e5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VCuGSoIyO9bb12cuATH067hMONFIh1sKwbyGLXS+z14m08JlBprgNvT8LZ85bqrfZ16kQJND14UGCL5ourdHyZpLpVwtqamNdfLEhdMd0DA1wX9ZhmWJw0ZUsUYxwvdb10c2bdEUE0NYsKbvpZ81Yoie4l/c0qN6bJAmRkW/123CBGTKWNq4Up1jhQOguTbCk0epmEvuuGTHTf1ckAFsZ9jY+KFVSvxGFlGZsMPyS6ktT435Ou/ByBYDCMxtDGszaOQClDycFiF+umLxlfnf3gboU7AP2lw6mFjMUjzuPJei91jm1mVuBAlKKMJpNE4zkYywb2a6TwBnmu7kvztPWRimR7ZfmU8dmuOdkfAKB0M92AK9rNor5i7CP+8B81Cp2RpnJ/ssueEJJ7pt1MCj/5DoLU1si7PmUY76ayLWXhp5lWkLH17sCa1YJgvuHO5m2rin7W1o4kBq6H6vPZ1tD/DJJVSKGNU2UZoZn8VKWwcGG4vHnID8gvOqD8yyoODQI1n+Yg/PrEj8HkKEOq/LG9rQ9emI2dYjyFia4yzJnZpbGlfIe5WGHSIrmaNGIzkj8P65KnQAQc2wTa32oRvxtQCylgBlxPkxQyy0jORfIRWu87kLZo2ct3RtbkEnRI24foqwjMif+IVFFxkGBTCFHUe/CccKss7DLSgrsfF+bQs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(186003)(86362001)(33656002)(55016003)(41300700001)(66446008)(64756008)(53546011)(9686003)(6506007)(26005)(316002)(71200400001)(7696005)(966005)(83380400001)(478600001)(110136005)(6636002)(38070700005)(38100700002)(8676002)(8936002)(76116006)(2906002)(66946007)(66476007)(66556008)(52536014)(122000001)(5660300002)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UC9Gb3ZzSGJONGI1Q3Z2K1UrNlBPZGNnTXlSc1F1Sk11SEhBaGZGbi80WEo1?=
 =?utf-8?B?VThDM3JpU1VMdS9vdkZmTGdNbWxsQWt5TnpmbE90NlBjMDR2bG14WGdvNnFY?=
 =?utf-8?B?bkFXZG9JVmJlTkdwMDlkbFhoUDNYZmVqbUhJRzdTQUpVdDAyOGd1MVlaT2Nh?=
 =?utf-8?B?MUZSR2cvMFFBdnh2ak1ucEMwMWhoeEREck15NS8yc21GaDd0RlJKa3R4bmJD?=
 =?utf-8?B?RXNMekNHR0g3RVNZTmRMZVZKRkFEbmFINXZhZUhrSGJ0T1Z1UTBmUGtpZmto?=
 =?utf-8?B?Y3Q5MTJOUjU1dkU4Q1U0V1gyYzNzbFp0ZG1zQXJxVHZ3NkNocTRjalFiQlhy?=
 =?utf-8?B?SlpPc3RYWm5CN2J5K2NDSTFLclJ5emNLNEpSTWUyZUQyZkM5am96MzI1L1U0?=
 =?utf-8?B?V3d0N0FMSXRWWWFvSlZaMVVaaC9OMXIyQUxlNzBaWnkrVFdRemtiMHJsaktJ?=
 =?utf-8?B?d09VenNvcUExZWM2K0FFV1RCMnpBcFFEZjIwbUs5ZTFtZktacGhiRUtNNm9k?=
 =?utf-8?B?T21vRW9saFVhMTJlaVJjWWVyOVEya1ZIR0krcnZJN1pJNW9HNGl0Y0ZIN0Zo?=
 =?utf-8?B?L3RJOHRpS1VKNmp5ZmJ4QmVDalk3OEljcDBHV3N3cTVIVU9yN2JuWlNXL2JE?=
 =?utf-8?B?ZzlQYTQ3TytwVy95QlhIK2d1di9WbEIvRU82UkJNUHMrai8yS1hLVDEyMk4r?=
 =?utf-8?B?Z0prMnltS3BJRjZwYTVDdzhJc3pVYXlZMUt4RVRXQW5IZVJpRHRpQ1F5Nkto?=
 =?utf-8?B?dzVJaVpaT2xSTEtlTUtWWm91d25BVFpuT2ptWE1BdGp1NWtmZ3RoNk9mcFVN?=
 =?utf-8?B?eUJ4R0UxWkxPTTM1d2J0bkgzQ0VpZFBmMnQ0TmZ6OXFNTnRGUUh3TGZGS2dB?=
 =?utf-8?B?WXFrY1FPK3ZDU3N3bWg2MXJucFdkUGxFeWJXc2k3blFISlY5U3AvYzJGZHhB?=
 =?utf-8?B?allwT2VDWHZTVnQ0WkVSc3dqK0M4QXFVMVVvQTVTOXMrcTlnNDVGOGl6a1dC?=
 =?utf-8?B?dXV6QTJVbnlzQVVxQW5UQVVsQ3JRQVJJS01wNmlQVjFINUNndUtpV0NjRHNm?=
 =?utf-8?B?djNoMjRBbW55M1N6eVRjcHpxQU1DZXN6TW9FUVBzVnNkNFh2eUNzQjlSajQ0?=
 =?utf-8?B?TFptS0NhZWk2WFdORVUvMkNsbVRXRVhNaCtObjlsQWpPVmtRZEZ2d2VNY1ND?=
 =?utf-8?B?b2lmL2lXeE5paDZUNSszWHpCdTQrdENIeTV0aUxkbDdSYUZKclVrRnZyNFVi?=
 =?utf-8?B?dGpFWjlRODdLUmZ3NG5jOWplQ2hFd2dwQ3BPWTY0Q3c2SmVFdDFYbEFNSWh1?=
 =?utf-8?B?QWRtZFZBdmFBa21xQUJ5cDdzRmNIOFlvRVNzUE1IeHQ4b2JYZ28zczNWSmRm?=
 =?utf-8?B?RENrR21OTDNmU2lTUXVxdFRLNXZBVk11alBaUkxybEpVY3pzRy9HM2ptdmJK?=
 =?utf-8?B?bHNmVDhCcWJHZUMrUXkrYTBlSnc0eDNHdHQwUC9VcmNZeEhacnFrUlVFd2Iw?=
 =?utf-8?B?S3RnNGpjNzd3MlFzYWFmOEpKMVU3OHdXUmZSYXlZRnVPd2ZPVGpLajhMWXlB?=
 =?utf-8?B?aEo5U1NGZzJWRWZUYnUxWWNZbGduTWw3azIvYVA2QnY4ZURGY21qaUJqQytv?=
 =?utf-8?B?OStsQ1VqWFRwTm5uSytXWU5VcnpCTzBOK0FvbG5NaDY4Y3d1cDh1MjJicGI1?=
 =?utf-8?B?M3pWcm9DVytIcW9pb3ExNW5FQitQMTl2Z2FkcmxINUVXV1NBSklZMWVkcDhP?=
 =?utf-8?B?SDEyQWJjMnRteld6QnFBUWpjUlFxa2Vkbk1qM0hnTFFIRFN3U3YzeDNFYVBz?=
 =?utf-8?B?eS9FS0wyZkRDQldxMExyTFVGQktEY0RaT0FVWU1yWWFoeUw1SGFjVlBJeEFy?=
 =?utf-8?B?Vjh3dEhoaFFoZzlZdkQvUUdKNHZ0VG11dFVra1dlK1dBcVpqZ25QNnJLUXFB?=
 =?utf-8?B?THE0N2VDL3RKRTNTVjc1L2dSb2FwaUdvb2hrNUNJUWcxenNwU09HckJoNjRy?=
 =?utf-8?B?Wjh5cGc1aS9YcWpMdTlTTS9PTnlKanlWMi9sNGx2NDc1THpkeGZTVTNoVEQy?=
 =?utf-8?B?NWp5V0h3MFgxd1BQUW1Vc21TKzlwOEthTXlUK3VvVGoreVAydCtnMEZEelZw?=
 =?utf-8?Q?ciGDoKdnV5rwzSiOA+qSDe8P5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a775088-0ecf-46a5-8db9-08db3c696e5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 21:52:52.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfZ7/OZwSoTUnQOFuILJ3L6j3FWzQ/Hs7exGNscy9rr+VkH24NSwpgC5mu9VgaqtCZqq/Dd4xra9hw9tNi7DfXOzWrXPuFayCL8o022wlDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBTYWdhciBCaXJhZGFyIC0gQzM0
MjQ5IA0KU2VudDogV2VkbmVzZGF5LCBBcHJpbCAxMiwgMjAyMyAxMjozMCBQTQ0KVG86IEpvaG4g
R2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPjsgRG9uIEJyYWNlIC0gQzMzNzA2IDxEb24u
QnJhY2VAbWljcm9jaGlwLmNvbT47IEdpbGJlcnQgV3UgLSBDMzM1MDQgPEdpbGJlcnQuV3VAbWlj
cm9jaGlwLmNvbT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBtYXJ0aW4ucGV0ZXJzZW5A
b3JhY2xlLmNvbTsgamVqYkBsaW51eC5pYm0uY29tOyBicmtpbmdAbGludXgudm5ldC5pYm0uY29t
OyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBUb20gV2hpdGUgLSBDMzM1MDMgPFRvbS5XaGl0ZUBt
aWNyb2NoaXAuY29tPg0KU3ViamVjdDogUkU6IFtQQVRDSF0gYWFjcmFpZDogcmVwbHkgcXVldWUg
bWFwcGluZyB0byBDUFVzIGJhc2VkIG9mIElSUSBhZmZpbml0eQ0KDQoNCg0KLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29t
Pg0KU2VudDogV2VkbmVzZGF5LCBBcHJpbCAxMiwgMjAyMyAyOjM4IEFNDQpUbzogU2FnYXIgQmly
YWRhciAtIEMzNDI0OSA8U2FnYXIuQmlyYWRhckBtaWNyb2NoaXAuY29tPjsgRG9uIEJyYWNlIC0g
QzMzNzA2IDxEb24uQnJhY2VAbWljcm9jaGlwLmNvbT47IEdpbGJlcnQgV3UgLSBDMzM1MDQgPEdp
bGJlcnQuV3VAbWljcm9jaGlwLmNvbT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBtYXJ0
aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgamVqYkBsaW51eC5pYm0uY29tOyBicmtpbmdAbGludXgu
dm5ldC5pYm0uY29tOyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBUb20gV2hpdGUgLSBDMzM1MDMg
PFRvbS5XaGl0ZUBtaWNyb2NoaXAuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSF0gYWFjcmFpZDog
cmVwbHkgcXVldWUgbWFwcGluZyB0byBDUFVzIGJhc2VkIG9mIElSUSBhZmZpbml0eQ0KDQpFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gMTAvMDQvMjAyMyAyMjoxNywgU2Fn
YXIuQmlyYWRhckBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPiBPbiAyOC8wMy8yMDIzIDIyOjQxLCBT
YWdhciBCaXJhZGFyIHdyb3RlOg0KPj4gRml4IHRoZSBJTyBoYW5nIHRoYXQgYXJpc2VzIGJlY2F1
c2Ugb2YgTVNJeCB2ZWN0b3Igbm90IGhhdmluZyBhIA0KPj4gbWFwcGVkIG9ubGluZSBDUFUgdXBv
biByZWNlaXZpbmcgY29tcGxldGlvbi4NCj4gV2hhdCBhYm91dCBpZiB0aGUgQ1BVIHRhcmdldGVk
IGdvZXMgb2ZmbGluZSB3aGlsZSB0aGUgSU8gaXMgaW4tZmxpZ2h0Pw0KPg0KPj4gVGhpcyBwYXRj
aCBzZXRzIHVwIGEgcmVwbHkgcXVldWUgbWFwcGluZyB0byBDUFVzIGJhc2VkIG9uIHRoZSBJUlEg
DQo+PiBhZmZpbml0eSByZXRyaWV2ZWQgdXNpbmcgcGNpX2lycV9nZXRfYWZmaW5pdHkoKSBBUEku
DQo+Pg0KPiBibGstbXEgYWxyZWFkeSBkb2VzIHdoYXQgeW91IHdhbnQgaGVyZSwgaW5jbHVkaW5n
IGhhbmRsaW5nIGZvciB0aGUgY2FzZSBJIG1lbnRpb24gYWJvdmUuIEl0IG1haW50YWlucyBhIENQ
VSAtPiBIVyBxdWV1ZSBtYXBwaW5nLCBhbmQgdXNpbmcgYSByZXBseSBtYXAgaW4gdGhlIExMRCBp
cyB0aGUgb2xkIHdheSBvZiBkb2luZyB0aGlzLg0KPg0KPiBDb3VsZCB5b3UgaW5zdGVhZCBmb2xs
b3cgdGhlIGV4YW1wbGUgaW4gY29tbWl0IDY2NGYwZGNlMjA1OCAoInNjc2k6DQo+IG1wdDNzYXM6
IEFkZCBzdXBwb3J0IGZvciBzaGFyZWQgaG9zdCB0YWdzZXQgZm9yIENQVSBob3RwbHVnIiksIGFu
ZCBleHBvc2UgdGhlIEhXIHF1ZXVlcyB0byB0aGUgdXBwZXIgbGF5ZXI/IFlvdSBjYW4gYWx0ZXJu
YXRpdmVseSBjaGVjayB0aGUgZXhhbXBsZSBvZiBhbnkgU0NTSSBkcml2ZXIgd2hpY2ggc2V0cyBz
aG9zdC0+aG9zdF90YWdzZXQgZm9yIHRoaXMuDQo+DQo+IFRoYW5rcywNCj4gSm9obg0KPiBbU2Fn
YXIgQmlyYWRhcl0NCj4NCj4gKioqV2hhdCBhYm91dCBpZiB0aGUgQ1BVIHRhcmdldGVkIGdvZXMg
b2ZmbGluZSB3aGlsZSB0aGUgSU8gaXMgaW4tZmxpZ2h0Pw0KPiBXZSByYW4gbXVsdGlwbGUgcmFu
ZG9tIGNhc2VzIHdpdGggdGhlIElPJ3MgcnVubmluZyBpbiBwYXJhbGxlbCBhbmQgZGlzYWJsaW5n
IGxvYWQtYmVhcmluZyBDUFUncy4gV2Ugc2F3IHRoYXQgdGhlIGxvYWQgd2FzIHRyYW5zZmVycmVk
IHRvIHRoZSBvdGhlciBvbmxpbmUgQ1BVcyBzdWNjZXNzZnVsbHkgZXZlcnkgdGltZS4NCj4gVGhl
IHNhbWUgd2FzIHRlc3RlZCBhdCB2ZW5kb3IgYW5kIHRoZWlyIGN1c3RvbWVyIHNpdGUgLSB0aGV5
IGRpZCBub3Qgc2VlIGFueSBpc3N1ZXMgdG9vLg0KDQpZb3UgbmVlZCB0byBlbnN1cmUgdGhhdCBh
bGwgQ1BVcyBhc3NvY2lhdGVkIHdpdGggdGhlIEhXIHF1ZXVlIGFyZSBvZmZsaW5lIGFuZCBzdGF5
IG9mZmxpbmUgdW50aWwgYW55IElPIG1heSB0aW1lb3V0LCB3aGljaCB3b3VsZCBiZSAzMCBzZWNv
bmRzIGFjY29yZGluZyB0byBTQ1NJIHNkIGRlZmF1bHQgdGltZW91dC4gSSBhbSBub3Qgc3VyZSBp
ZiB5b3Ugd2VyZSBkb2luZyB0aGF0IGV4YWN0bHkuDQoNCj4NCj4NCj4gKioqYmxrLW1xIGFscmVh
ZHkgZG9lcyB3aGF0IHlvdSB3YW50IGhlcmUsIGluY2x1ZGluZyBoYW5kbGluZyBmb3IgdGhlIGNh
c2UgSSBtZW50aW9uIGFib3ZlLiBJdCBtYWludGFpbnMgYSBDUFUgLT4gSFcgcXVldWUgbWFwcGlu
ZywgYW5kIHVzaW5nIGEgcmVwbHkgbWFwIGluIHRoZSBMTEQgaXMgdGhlIG9sZCB3YXkgb2YgZG9p
bmcgdGhpcy4NCj4gV2UgYWxzbyB0cmllZCBpbXBsZW1lbnRpbmcgdGhlIGJsay1tcSBtZWNoYW5p
c20gaW4gdGhlIGRyaXZlciBhbmQgd2Ugc2F3IGNvbW1hbmQgdGltZW91dHMuDQo+IFRoZSBmaXJt
d2FyZSBoYXMgbGltaXRhdGlvbiBvZiBmaXhlZCBudW1iZXIgb2YgcXVldWVzIHBlciB2ZWN0b3Ig
YW5kIHRoZSBibGstbXEgY2hhbmdlcyB3b3VsZCBzYXR1cmF0ZSB0aGF0IGxpbWl0Lg0KPiBUaGF0
IGFuc3dlcnMgdGhlIHBvc3NpYmxlIGNvbW1hbmQgdGltZW91dC4NCj4NCj4gQWxzbyB0aGlzIGlz
IEVPTCBwcm9kdWN0IGFuZCB0aGVyZSB3aWxsIGJlIG5vIGZpcm13YXJlIGNvZGUgY2hhbmdlcy4g
R2l2ZW4gdGhpcywgd2UgaGF2ZSBkZWNpZGVkIHRvIHN0aWNrIHRvIHRoZSByZXBseV9tYXAgbWVj
aGFuaXNtLg0KPiAoaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vc3RvcmFnZS5t
aWNyb3NlbWkuY29tL2VuLXVzL3N1cHBvDQo+IHJ0L3NlcmllczgvaW5kZXgucGhwX187ISFBQ1dW
NU45TTJSVjk5aFEhUExyYmZvRUJ2RUd4dzJDdmFoQ0wwQVA1YzRmNWMNCj4gUThnVDBhaFhWZ0Iw
bVNieXF4V0o4cGR0WVkwSndSTDh4WjU5azBOSEpoWENCYk10VldscTVwWU1lT0VIbXc3d3ckICAp
DQo+DQo+IFRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcgY29tbWVudHMgYW5kIHdlIGhvcGUgeW91
IHdpbGwgcmVjb25zaWRlciB0aGUgb3JpZ2luYWwgcGF0Y2guDQoNCkkndmUgYmVlbiBjaGVja2lu
ZyB0aGUgZHJpdmVyIGEgYml0IG1vcmUgYW5kIHRoaXMgZHJpdmVycyB1c2VzIHNvbWUgInJlc2Vy
dmVkIiBjb21tYW5kcywgcmlnaHQ/IFRoYXQgd291bGQgYmUgaW50ZXJuYWwgY29tbWFuZHMgd2hp
Y2ggdGhlIGRyaXZlciBzZW5kcyB0byB0aGUgYWRhcHRlciB3aGljaCBkb2VzIG5vdCBoYXZlIGEg
c2NzaV9jbW5kIGFzc29jaWF0ZWQuDQpJZiBzbywgaXQgZ2V0cyBhIGJpdCBtb3JlIHRyaWNreSB0
byB1c2UgYmxrLW1xIHN1cHBvcnQgZm9yIEhXIHF1ZXVlcywgYXMgd2UgbmVlZCB0byBtYW51YWxs
eSBmaW5kIGEgSFcgcXVldWUgZm9yIHRob3NlICJyZXNlcnZlZCBjb21tYW5kcyIsIGxpa2UNCmh0
dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xp
bnV4LmdpdC90cmVlL2RyaXZlcnMvc2NzaS9oaXNpX3Nhcy9oaXNpX3Nhc19tYWluLmM/aD12Ni4z
LXJjNiNuNTMyDQoNCkFueXdheSwgaXQncyBub3QgdXAgdG8gbWUgLi4uDQoNClRoYW5rcywNCkpv
aG4NCg0KW1NhZ2FyIEJpcmFkYXJdDQpJIHRoYW5rIHlvdSBmb3IgeW91ciB0aW1lIGFuZCByZXZp
ZXcgY29tbWVudHMuDQoNCioqKllvdSBuZWVkIHRvIGVuc3VyZSB0aGF0IGFsbCBDUFVzIGFzc29j
aWF0ZWQgd2l0aCB0aGUgSFcgcXVldWUgYXJlIG9mZmxpbmUgYW5kIHN0YXkgb2ZmbGluZSB1bnRp
bCBhbnkgSU8gbWF5IHRpbWVvdXQsIHdoaWNoIHdvdWxkIGJlIDMwIHNlY29uZHMgYWNjb3JkaW5n
IHRvIFNDU0kgc2QgZGVmYXVsdCB0aW1lb3V0LiBJIGFtIG5vdCBzdXJlIGlmIHlvdSB3ZXJlIGRv
aW5nIHRoYXQgZXhhY3RseS4NCg0KV2UgZGlzYWJsZWQgMTQgb3V0IG9mIDE2IENQVXMgYW5kIGVh
Y2ggdGltZSB3ZSBzYXcgdGhlIGludGVycnVwdHMgbWlncmF0ZWQgdG8gdGhlIG90aGVyIENQVXMu
DQpUaGUgQ1BVcyByZW1haW5lZCBvZmZsaW5lIGZvciB2YXJ5aW5nIHRpbWVzLCBlYWNoIG9mIHdo
aWNoIHdlcmUgbW9yZSB0aGFuIDMwIHNlY29uZHMuDQpXZSBtb25pdG9yZWQgcHJvcGVyIGJlaGF2
aW9yIG9mIHRoZSB0aHJlYWRzIHJ1bm5pbmcgb24gQ1BVcyBhbmQgb2JzZXJ2ZWQgdGhlbSBtaWdy
YXRpbmcgdG8gb3RoZXIgQ1BVcyBhcyB0aGV5IHdlcmUgZGlzYWJsZWQuDQpXZSwgYWxvbmcgd2l0
aCB0aGUgdmVuZG9yL2N1c3RvbWVyLCBkaWQgbm90IG9ic2VydmUgYW55IGNvbW1hbmQgdGltZW91
dHMgaW4gdGhlc2UgZXhwZXJpbWVudHMuIA0KSW4gY2FzZSBhbnkgY29tbWFuZHMgdGltZSBvdXQg
LSB0aGUgZHJpdmVyIHdpbGwgcmVzb3J0IHRvIHRoZSBlcnJvciBoYW5kbGluZyBtZWNoYW5pc20u
DQoNCioqKkkndmUgYmVlbiBjaGVja2luZyB0aGUgZHJpdmVyIGEgYml0IG1vcmUgYW5kIHRoaXMg
ZHJpdmVycyB1c2VzIHNvbWUgInJlc2VydmVkIiBjb21tYW5kcywgcmlnaHQ/IFRoYXQgd291bGQg
YmUgaW50ZXJuYWwgY29tbWFuZHMgd2hpY2ggdGhlIGRyaXZlciBzZW5kcyB0byB0aGUgYWRhcHRl
ciB3aGljaCBkb2VzIG5vdCBoYXZlIGEgc2NzaV9jbW5kIGFzc29jaWF0ZWQuDQpJZiBzbywgaXQg
Z2V0cyBhIGJpdCBtb3JlIHRyaWNreSB0byB1c2UgYmxrLW1xIHN1cHBvcnQgZm9yIEhXIHF1ZXVl
cywgYXMgd2UgbmVlZCB0byBtYW51YWxseSBmaW5kIGEgSFcgcXVldWUgZm9yIHRob3NlICJyZXNl
cnZlZCBjb21tYW5kcyIsIGxpa2UNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2RyaXZlcnMvc2NzaS9oaXNpX3Nh
cy9oaXNpX3Nhc19tYWluLmM/aD12Ni4zLXJjNiNuNTMyDQpBbnl3YXksIGl0J3Mgbm90IHVwIHRv
IG1lIC4uLg0KDQpZZXMgd2UgaGF2ZSByZXNlcnZlZCBjb21tYW5kcywgdGhhdCBvcmlnaW5hdGUg
ZnJvbSB3aXRoaW4gdGhlIGRyaXZlci4NCldlIHJlbHkgb24gdGhlIHJlcGx5X21hcCBtZWNoYW5p
c20gKGZyb20gdGhlIG9yaWdpbmFsIHBhdGNoKSB0byBnZXQgaW50ZXJydXB0IHZlY3RvciBmb3Ig
dGhlIHJlc2VydmVkIGNvbW1hbmRzIHRvby4NCg0KDQpUaGFua3MNClNhZ2FyDQoNCg0KDQoNCkFs
c28sIHRoZXJlIGlzIHRoaXMgcGF0Y2ggd2hpY2ggYWRkcmVzc2VzIHRoZSBjb25jZXJucyBKb2hu
IEdhcnJ5IHJhaXNlZC4NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMjA5MjkwMzM0
MjguMjU5NDgtMS1tajAxMjMubGVlQHNhbXN1bmcuY29tL1QvDQoNClRoaXMgcGF0Y2ggZXhwbGFp
bnMgaG93IHRoZSBjb29yZGluYXRpb24gaGFwcGVucyB3aGVuIGEgQ1BVIGdvZXMgb2ZmbGluZS4N
CklQSSBjYW4gYmUgcmVhZCBJbnRlclByb2Nlc3NvciBJbnRlcnJ1cHQuDQpUaGUgcmVxdWVzdCBz
aGFsbCBiZSBjb21wbGV0ZWQgZnJvbSB0aGUgQ1BVIHdoZXJlIGl0IGlzIHJ1bm5pbmcgd2hlbiB0
aGUgb3JpZ2luYWwgQ1BVIGdvZXMgb2ZmbGluZS4NCg0KVGhhbmtzDQpTYWdhcg0KDQo=
