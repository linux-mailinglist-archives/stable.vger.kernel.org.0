Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC336E79B6
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjDSM0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 08:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDSM0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 08:26:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9580C2681;
        Wed, 19 Apr 2023 05:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681907190; x=1713443190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LE+A7DbhQDSi7UO2ZJcrffnNPQB9AW8jR1pT8Qx+gSY=;
  b=12LbikrwapBgZyyjz8m+4+2mQPBvVTT4DpUDtzhYRgMo6hY+qLZzWtdA
   IbATJVjsCOYpKI4ELOax2TtWrKXMDKKVmoUyiszOvjyx1xIUylUyiZhFU
   uKrs3iX5eoDrLH2BPzlAaydLprf7bS5uI2mZeBNocV7MnCi8td2y2q6C1
   fmyDULSwJXUuEyN0uW859sjB4r58fOUO72OkcluF1RTzzVOqt2DGmpax1
   jGnXW0DJ5BUM/KB35C848YF64MWohTb0JNEBXiIDXcFVaEpT7nqsxLgIG
   m1GYrHb9zDgeL5gz2LHFPkSnNgRIRz/pgorQDsym25N9zHYC04FvOFEb8
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,208,1677567600"; 
   d="scan'208";a="207271871"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 05:26:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 05:26:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 19 Apr 2023 05:26:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJ1arLlu6jsLJ+1qWyC4FneC8B6kIqfZErzO7p53pD/qcoYALiwMQ/qVc0KZ4rtaFzBiqRdGJg+Ac6qRvL4lk/++Tfle8s5BWQwSR0rPykeIKCfXKJ+9VQb6XRrV8oJCCg1I7qZoPH9xa/qH5cAkd3acc/Elg41R+0iyP/e6dNfcOZ+43pKTQrIkQRFdNK+23Gk73QFAjtCXZDbJc0s8N5ZMH5a6Y5RtetzWCG17H2PGEbM+ZAhkRaJPtiCKDXnzUbsKBz1I4M2yZqHHIcZdcwY57W42HTya/4mixMrkS+aYZhsZWifrqjYtfSRxOZHbuyfzVKDfwySGAVgZcoyh3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LE+A7DbhQDSi7UO2ZJcrffnNPQB9AW8jR1pT8Qx+gSY=;
 b=gKjncyVNUM75KPdC6Gj4cUSMjXTpZvDf/57PMYjQkKWz86huPUcH0MsqPeRbiY7JnF5TQC3d/iLJA1Q0URC9/PBfI32dMls2Z2yDPyGxTZ+yc8TpSajSGv/7wAkFf3YS7tAW8+6x9bWtDY9wVhFaw3XdNJOJtEadSuC3GjWfCCslxdwcU1SDOVLSYzrdtRasi8H9ICderDjbokUZQKRzpwwQZ57WkL0pocrdHBw3oQHmWDaZB1CSWRR4Oe9vsjv6L0pwCQHq1r+YrK/x1afexPgtYBm74r1ZNFMGujJLE6zLbinHWKUkAHfRsmgI07pEUDHHJ55bY01EJtgEtq9U+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LE+A7DbhQDSi7UO2ZJcrffnNPQB9AW8jR1pT8Qx+gSY=;
 b=VkdMqujPuF2QJ/BZbKgurFlqJ0ZVyONxzeB69nJGZWZSSMuZkhA94aIDKnsKsG8rCSR1sWQxQtkZRqRVWiCPir1n3f/y6ckreJw8vefeB3iRE+1KcbCq22/G9bT1LB+/ksUkeMVPQvSZaYBV0ax89qU+dYPyKz7YYpkFg3jWros=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BN9PR11MB5226.namprd11.prod.outlook.com (2603:10b6:408:133::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 12:26:27 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::5615:499e:2fe2:20dd]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::5615:499e:2fe2:20dd%3]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 12:26:27 +0000
From:   <Conor.Dooley@microchip.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <hi@alyssa.is>
CC:     <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>
Subject: Re: [PATCH 6.2 000/138] 6.2.12-rc2 review
Thread-Topic: [PATCH 6.2 000/138] 6.2.12-rc2 review
Thread-Index: AQHZcqMoYWvLVad+t0ut2X6QreRmI68yjvoA
Date:   Wed, 19 Apr 2023 12:26:26 +0000
Message-ID: <b6e0cc8b-eb4b-4906-9697-a1dab4741745@microchip.com>
References: <20230419093655.693770727@linuxfoundation.org>
In-Reply-To: <20230419093655.693770727@linuxfoundation.org>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5154:EE_|BN9PR11MB5226:EE_
x-ms-office365-filtering-correlation-id: 7d912d69-3295-4c62-9c31-08db40d14c00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OOTiC3Lyn3zAapjquSnhgYHsYoiepuKj1169Duc7KHWuGFP9W/Ossf+m3i2HucTKKhniOfUE1Drrf66ow+OvEURYMKwAPOYFV8SJ9vHw1EYBKpfTSQMm2ztmP1JQfeUrhb1Npxg5Ca8+wqPoNCrv9vuydZWtYr8O/xk2PE+dS8U8OUhAJ5PRmCOxj4//LH9xfou/RB8AIIUNb3Jf4H7TG+HSwA0aOuk+HmVl/GCtynSEr5loX+bwvPkN1YtPB5TPfcFgLEhFafX8RBzwGLZ0y6PdoWbXyv5nuc8wgVdnVTLrF9/VK0ZDKi4OvNdPr8nsAbo8LYvLtbBJ/103bw6emdj6yXj2fRPJ898Xl8zMzx7syBdtsLKeY8Wm0lRcHF20UjOMFO4sXXSf+KhGnb03g9YGRAziHyX0KFaXrXoSrnHIaHRGfbpuFRtP/hRTjVd8ke7ParpJiaT9zYNQryOtMSwDrlgrwwevcoJ/tOIsl1neXw3fztwbhmGdGqpe0gILaI9IUgXwRlUNZPPGpBwGOqqPJtTx7otnTkH/3MvwDeyIliVaDTcgmi8mqdAad9WgwpzkGxaUSPJQY30YUsQyJtOxx7wxHMJ1g2xkYPx9K0A/xnQeKfE95P1cE+dlM63giRChDxi5DwTn+06EnQfCgr/ZczMLZVW1EYHptshxcdf1grwJoMHeXxFK4na++vg9GAGIa2OpozsiSe7OHW5fKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199021)(38070700005)(2906002)(8936002)(38100700002)(8676002)(7416002)(5660300002)(36756003)(86362001)(31696002)(6486002)(71200400001)(6512007)(6506007)(26005)(966005)(110136005)(54906003)(478600001)(2616005)(31686004)(53546011)(186003)(316002)(4326008)(66556008)(66476007)(64756008)(66446008)(91956017)(76116006)(66946007)(122000001)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTBLZUlLVk1DMi9IbVBWR0xTZTYrVDRPTVF4Z04wV21WdXhKZ0MrZlVJVThx?=
 =?utf-8?B?VVUzVEwyNmxiMlcvMmJTQThiSjNYZTdUaUx6eDgwaGxXU3pNdjNjWVc4eHd5?=
 =?utf-8?B?dU4xZTVCRHBhNTlUbFhMR294MFBIVGFnSW94djMydWpzczdBS3NMM2RrenpO?=
 =?utf-8?B?dkdBUzFabWt4ZGd5bVR5OTNSZTNFdkRuOGhkaENld1Bub3VrZFc1YWtBTDJy?=
 =?utf-8?B?QkJKWlZVQVZFZWR2WENScWx4eGVwTkFyVmxpMnd3QW1LLzE5NG9IckFaZWlh?=
 =?utf-8?B?YmM2enlHYm53UkF3RDZkWWNtZXdLa1FHdXZNK1RHMHhla1o0OTdiQ09reXAw?=
 =?utf-8?B?V0FkZExCR0FMVFFrWlhPalF3RmVSTVVkSzM2eUxoSFVPSFNtMkhpSkplZHZE?=
 =?utf-8?B?K0tGVFdMS0Mrczd1ZW9PcGxmT0tYSmhxd2xxcVlkUjhadjlzVkhjRUtKSFJw?=
 =?utf-8?B?NUZRb0pzcThLUStpcHZZYkNSTkJUYnRibHdzbFQ2S28zbS9ZMW1sZ2IwWllw?=
 =?utf-8?B?NXVvL09odkw3Q3V3d2dqS0RWMHpPSE1mV1QwcnUzeU1FcVJ1cjV3RTZ5UXd4?=
 =?utf-8?B?bkcrOTFzS01ZU0E0djQ2T2hZQm9wUThvNW10VnM3SFVYRzdETC8ySFIyTkVF?=
 =?utf-8?B?S0xaaGpScktGTmZWdFVFL1g2cWhuNE5PL0RnMUpmZW5XMkxCZHIweTVBZ0I3?=
 =?utf-8?B?WFdQZVNLK21uY3RiNlZCN2wrMVJJVFdIWmEvUFB3ZmMwc29jQW83S0FqLzYv?=
 =?utf-8?B?eGljVWV3WkROQ0x2WTNqTFFocCtGZG5tWCt3cnBqTk9wTzhWV3VsaUlCQ2JX?=
 =?utf-8?B?SFRqc0ZwREdLMFM3eDdUWDFIaWN6dFRhUW80ZU4vTnlFVGRnbXJnK3NYcS94?=
 =?utf-8?B?c281TjN3V0tJSEtnMVJ6aHdRcjJtMmU1WU9EYWthcThkRVFVUFg5dmVmbmlo?=
 =?utf-8?B?eTJUR1hkUE5wVnpQK3p0bHlrWjNxWHZTT1V4Vks0SEgwUWQ1QWdmNVNUYmdQ?=
 =?utf-8?B?S1J6UDdSSnFKTHBvaU1KVDdIRnBxR2VMZWxONXVmaEJJciswcnV0empvT3F6?=
 =?utf-8?B?UHZ5a0VKbGJsVE44U1hMYzFKZ2FyemJsSy8wWFlRYUdLVVZ5S0N4WUpLUFhW?=
 =?utf-8?B?dWlTcXRaWWt4dm1pTXo2U1pISFl6dXN3cGo5VFo4eG5vSnU0cnBpK3Q1NlJT?=
 =?utf-8?B?U2ZjN0VHQzVsUlJ6QUR2Zm02RE15bFJEREdjdG12T1o1eitMRjQ3dDVFOGRM?=
 =?utf-8?B?cFFpVE5tVmE3bWJXMGx6ay9paW4waDFGWSt4dUxab3FDZG80K3RGMDNDbUxx?=
 =?utf-8?B?VmsrVUI0UWhkeGtlWjlHdkJnT3N0OGZyTC9samN2cWtLb1MwS0RMQ2psWkFP?=
 =?utf-8?B?b1hUMWFMbG5Db08rZEtFQnVBaFpsSDc3WHF3bDRZQm5kME5mdnhTZ0wrTVVB?=
 =?utf-8?B?a3BnV0Q2MnBzVm5NVjNPaVllTnN2RWZob2tyZm81Z2RMVEhqVDNSQXphVDRJ?=
 =?utf-8?B?NlpydmF0U2s1cE1CMGpybmVSQ3d4YXhpTytCRllta1pPVUZYWE4wZHRnVnlJ?=
 =?utf-8?B?MmZKT3g5Ulcza1U1cjNSdWhvOUJsdmlFYktVTzQvczJoVjFzZGh2UTBTVmJZ?=
 =?utf-8?B?MWw5Z2xEcVNnQTZZSmgya2lYNlh5YnllRW9NYWt1ZWsvRVlrSERPeWNhQmhu?=
 =?utf-8?B?SUFHTUlVbGRtKzVFZnVhUnJ0TFMrZHN4YnB4dHFmZnF5WjF0TG84NFdiR1hQ?=
 =?utf-8?B?eWtLbmJWYzREMmIwV0k5MmxjZVluTHZKbGcrdDlzN1FtOGorWGhBMjY5QWQ3?=
 =?utf-8?B?UlZ5R01yRFZiemdXY3dHNkZObm50YnlrWGtWbGNsWVpSc3pjbTVMeC9Vd2pT?=
 =?utf-8?B?NmwxN3BVYndlRElmKzhraXFBbzFvM0pxMmZxNkIvVVlNMUh2aEgzcTh4M0t6?=
 =?utf-8?B?T1NEd1VuY1pGcGZwZ2FvcU10RTg2N3hyVmhJWDhwTWI1cjFVQURZcHd6bUZ4?=
 =?utf-8?B?NldadUk1b0NrQVp0NWRLNWQrMTEvM2FBRlZITERGV1h5SldvUEhiS3hINi9m?=
 =?utf-8?B?RjFWMWxmb09OT2xGeGlheUlLRmtra090Mzd5UEpDYVlxUHdoS0VrRklIak9J?=
 =?utf-8?Q?Ru5WpcozCr+sjq1JDbCSZuYRl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE59A37560EC764A98606FB54AEC9015@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d912d69-3295-4c62-9c31-08db40d14c00
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 12:26:26.9994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BDLqLYXU2R86TVXT+HIbW4qSW6W+1fJ7jbHN2zu32us1L66EEbg+H2KouUeGYSMRayKcxCqDIN1Cp/+/9+lXgTsQs1wr8jdZL95M/skTCL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5226
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTkvMDQvMjAyMyAxMDo0MCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFRoaXMgaXMgdGhlIHN0YXJ0IG9mIHRo
ZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUgNi4yLjEyIHJlbGVhc2UuDQo+IFRoZXJlIGFy
ZSAxMzggcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVz
cG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVz
ZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMg
c2hvdWxkIGJlIG1hZGUgYnkgRnJpLCAyMSBBcHIgMjAyMyAwOTozNjoyNiArMDAwMC4NCj4gQW55
dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPiANCj4g
VGhlIHdob2xlIHBhdGNoIHNlcmllcyBjYW4gYmUgZm91bmQgaW4gb25lIHBhdGNoIGF0Og0KPiAg
ICAgICAgICBodHRwczovL3d3dy5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwvdjYueC9zdGFi
bGUtcmV2aWV3L3BhdGNoLTYuMi4xMi1yYzIuZ3oNCj4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBi
cmFuY2ggYXQ6DQo+ICAgICAgICAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9zdGFibGUvbGludXgtc3RhYmxlLXJjLmdpdCBsaW51eC02LjIueQ0KPiBhbmQg
dGhlIGRpZmZzdGF0IGNhbiBiZSBmb3VuZCBiZWxvdy4NCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdy
ZWcgay1oDQoNCg0KPiBBbHlzc2EgUm9zcyA8aGlAYWx5c3NhLmlzPg0KPiAgICAgIHB1cmdhdG9y
eTogZml4IGRpc2FibGluZyBkZWJ1ZyBpbmZvDQo+IA0KPiBIZWlrbyBTdHVlYm5lciA8aGVpa28u
c3R1ZWJuZXJAdnJ1bGwuZXU+DQo+ICAgICAgUklTQy1WOiBhZGQgaW5mcmFzdHJ1Y3R1cmUgdG8g
YWxsb3cgZGlmZmVyZW50IHN0ciogaW1wbGVtZW50YXRpb25zDQoNCkxvcmUgaXMgfmRlYWQgZm9y
IG1lIHJpZ2h0IG5vdywgYnV0IHRoZXJlIHNob3VsZCBiZSBhIGN1c3RvbSBiYWNrcG9ydCBvZg0K
QWx5c3NhJ3MgY29tbWl0LCBzdWJtaXR0ZWQgYnkgaGVyLCBoZXJlOg0KaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjMwNDE3MTM0MDQ0LjE4MjEwMTQtMS1oaUBhbHlzc2EuaXMvDQoNClBl
cmhhcHMgdGhlIHJlYXNvbiBpcyBqdXN0IHRoZSBxdWFudGl0eSBvZiBlbWFpbCwgYnV0IHRoYXQg
d2FzDQpzdWJtaXR0ZWQgYWdhaW5zdCB0aGUgImZhaWwiIGVtYWlsIChhbmQgd2l0aGluIGEgZmV3
IGhvdXJzKSwgc28gd2h5DQp3YXMgYW5vdGhlciBjb21taXQgcHVsbGVkIGJhY2sgaW5zdGVhZCBv
ZiB1c2luZyB3aGF0IHNoZSBwcm92aWRlZD8NCg0KDQo+IEFsZXhhbmRyZSBHaGl0aSA8YWxleGdo
aXRpQHJpdm9zaW5jLmNvbT4NCj4gICAgICByaXNjdjogRG8gbm90IHNldCBpbml0aWFsX2Jvb3Rf
cGFyYW1zIHRvIHRoZSBsaW5lYXIgYWRkcmVzcyBvZiB0aGUgZHRiDQoNClNhbWUgYXMgNi4xLnks
IEFsZXggc2FpZCBoZSdsbCBwcm92aWRlIGEgYmFja3BvcnQgZm9yIHRoZSB3aG9sZQ0Kc2VyaWVz
LCBzbyBqdXN0IGRyb3AgdGhpcyBoZXJlIHRvbyBwbGVhc2UuDQoNClRoYW5rcywNCkNvbm9yLg0K
