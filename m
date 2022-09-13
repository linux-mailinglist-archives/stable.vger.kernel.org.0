Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A770E5B77B6
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiIMRWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiIMRVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:21:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23923AE7E;
        Tue, 13 Sep 2022 09:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663085355; x=1694621355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4RGxnTuf0EGorCfzBBsKi950rl+/SMinAG0mkDHlMRY=;
  b=cKznttY0rUNV7Ox0qcCTSJ3+UyyxyY7d8hjebZnoplPkndYtjfethMPe
   JlOrVXoPgAgFbb8pPGIunSm4FVqYZr0p9zO6Rrp+2ymHp97EwOKvXxAtq
   U3boCqADLV0DQzN2dfVFiAIIaxSB5lvjmnxqCkiGxh8/GJVD0Lagb/zUR
   k9QJ5IErUNndN+ZNad/uoiHkCBT7IHI3YZcmWG0S07j/j2kq9Z/VlFujH
   wx5MaGqtQcrieLL6c3lBmbBRxvzz8NEm7RiUUPIn6MgMzDjM2IiulBXZm
   E36LgUgr1fy9J/97QY7gB4mm/KsPKk6gR+vYeiujCg7rgtoBzXGMpZBF+
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="176947502"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 09:09:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 09:09:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 13 Sep 2022 09:09:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZULxQd4M8arl6UT3WyfA6I7h23hqgF4kLgOaYoy4AqSOFR0vMSOzIvxA6w7CFst8aWblzzytuUcACZzj8mSH3NLN/0jepH2xGCnDRt0iDCkSBFwQ5XJZcJzeiHGUvfZyUYQ0RZXj553LiBEdD85M1ekYOnXXajOAsi93YL34qvGy2bVds/78xsbSmJUaPPBi9b3UGqCKYLPSVNgIdIJjROQ/r2CbSecwC82QO3gHuBm+JhVHD+/9YmYzvyfwiPifF5HEtSnC/NUNdPnH0sPkXSsrAu6J1OZnxWqL4KDs1cM6Ei9p3736OZ+Q0bfr5/MIqy8NKOSMGOr6PLpl5D+6Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RGxnTuf0EGorCfzBBsKi950rl+/SMinAG0mkDHlMRY=;
 b=hxs2or+OAOAgdlhSydn/XsCwUCxwCMKYcKuV5/20wbd1AQBEuUXWfuIQo9nMXubrwfgRX1UdRJbeJuhNp6LL8u8WOEaidNpJQkySi5oIrqTEESMtyN1LBidA1g/WshjEGL4M+4PaMLXJQ86sxYrkCV+UuBBWuH2kJTuPO1S9siR0UmEM7qlo2EEz6uEtcckr2ldaeI2j/dvcSLWVfjz8U4WSop2gHBtSPLNHCB1RdHkhGsPN1b++HNKmEReM07FjhtKYoX0yPJjr4SQ327zPmzzRP6pmE9ZMj02uFVxPywUNDlwLuzbzINWwFDGYs5NpGMvXuBseOxNbaK5McbmccQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RGxnTuf0EGorCfzBBsKi950rl+/SMinAG0mkDHlMRY=;
 b=WXh1YjUk7BiwEJIRgY5LaNYXXLRflHM+/+a5XW+dVmSABEiGr1zaRqCkh1MAbjlGMoSM0m0zFsJuAlIyZ2DEago8aPwgg7mMpBko+n4IQFruprBds61B6jZe6/v8Uon4QitMoxwBq15PCCHFaumcKnwHGINqeab/mL1TJaVtoEY=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 13 Sep 2022 16:09:09 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 16:09:09 +0000
From:   <Conor.Dooley@microchip.com>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <geert@linux-m68k.org>,
        <krzysztof.kozlowski@canonical.com>, <palmer@rivosinc.com>,
        <sashal@kernel.org>
Subject: Re: [PATCH 5.15 048/121] riscv: dts: microchip: mpfs: Fix reference
 clock node
Thread-Topic: [PATCH 5.15 048/121] riscv: dts: microchip: mpfs: Fix reference
 clock node
Thread-Index: AQHYx3u29tjn0iIPPUCL+gv4JJiQLq3dh1iA
Date:   Tue, 13 Sep 2022 16:09:09 +0000
Message-ID: <f9be96f9-77fa-10fc-44cb-65d3a7fce57c@microchip.com>
References: <20220913140357.323297659@linuxfoundation.org>
 <20220913140359.425823284@linuxfoundation.org>
In-Reply-To: <20220913140359.425823284@linuxfoundation.org>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5154:EE_|DM4PR11MB6504:EE_
x-ms-office365-filtering-correlation-id: 0f4fb692-d228-4bb2-814f-08da95a24a96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VT3i9n/QP4F/m1VHkUmdGe3YepdTZbtK5iAZotJcUy0ZRkrPRJ1dcLLHL9PE9LY/1eogJzs1XORXTBZaQZqqkj3Ybr8w+vBG4lhOyjoRbRPpfTS1LhdlimV8KywfGPasCy+ybY+4ODJQR7/rPAqm7U94lnTilX5A/WBdF/gTngZl2i5TEzdHGwYgRuJ3TDri6EZxvyaDqmLCIrWaA8PkLmZGLh1JwlvNGZ9mjZhNg/1xl60+1RryjUZFKopvUiD4MmpX+p99O3pflYm0tIXmizTzj1x9aWslM/KzuvwK9D1D+NXtUesWbr60uhFVNJj7/wzMqmWZBSjgBfo+uMLMasKG4gwr3dqGl+FwD400iUx6HHjazLY0GPQ+M9MUMI1GEM7AbSZ3kxBoRgO52kPMzEQDZGUoZ7oQYlvtfoO1+gOLOhCtIPQgj/hC9pLpzjPhSo2fj0/pegv3Ao/GmoS1ooZZrsI8tYuI85wEIX21uiQbAwnrH3ViNtq5QNFTuabRj71mzdqFbUQPBPLHAtJmMRZzlwvq8vhYqM8HEsSxRahRUSravLdkmzfsiRTU0YajJIYvlozCb2ubn/bCPv+B9YnT6eFUoIuzBgicCadhnD/J8nLDb5ySC6LIUndxZWdFcFMOb6nTKJkHPU0WYLtWvCRRAM/jIXEpg/n/X2RmpAjR5IoYsChZWeJsUj3qUD+WzCRv0M0wHEp3+3nHz/RrjsXsJg1n7fSgJGogds2WOteOQXaPoqCz1XoLUKgFEbd2HgTGJ9WSP7tKNE/lByxvGekPozk1cHVcImUakqvh4tHN0hlCMN9UPOVCB/2M8FV6gdN34VhSrLOtTsACp/DxNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(316002)(66556008)(66476007)(2906002)(36756003)(64756008)(26005)(66946007)(4326008)(66446008)(38100700002)(8676002)(6486002)(2616005)(6506007)(186003)(31696002)(110136005)(91956017)(6512007)(76116006)(41300700001)(54906003)(53546011)(86362001)(83380400001)(122000001)(8936002)(31686004)(478600001)(38070700005)(5660300002)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QS9pK1FFOERtek8rV000ZUJXdWRxRXo4RUQ1am51ZkdETmlBaFp1MzV3T2Jn?=
 =?utf-8?B?QVVBTUJHVm9BL2toSkZ0WHYySnRHYVcrVlBUZG5mSENFVGdMd0syRlhnWitw?=
 =?utf-8?B?c042NVkyVFRQS3hzUGk5aUh6QUpKVWp3Q2NsZE1IcXpGZUJTS0hCZDhocGRU?=
 =?utf-8?B?Qld4eXEzSklzQkF4ajZQREowaXFMeGRXdkVOWkRJdmdSS2R1ZWpCRDlxVzdV?=
 =?utf-8?B?Ym5CRnAzbHBDK2tyT01UaU9GNGVLcmU2aGl3RStKWWJrSnh0ZDZrWWpUK2Fi?=
 =?utf-8?B?dWdHSEI3YUt3TDU2bFQ4WC8yT08xUTBzL3ZxMGpGaHQyZ01leExCMVJZbjF3?=
 =?utf-8?B?dUtlVG03WFZLZmhveFdJMDhLd2RLTGs5cUVuSTlWUThWUWpWUEdGUTNCK2Y5?=
 =?utf-8?B?OGdZSFVaRFFWZk16QW03VnJoYlRMSEhIbmtKaWF1YTVrM2xCZ3orUElGS09S?=
 =?utf-8?B?TThUeFNoc2c4ckRQaVEvWDRjbFZZY1VsT3RTNGZhUmlxMWNUeUFXTXE4YmZv?=
 =?utf-8?B?dzJjVjlqNElaSFFXUXNXc25nVlNxVk1MekpnR0F5UnhHVlNJKzErZ3ZrMWk1?=
 =?utf-8?B?VnFnbGc0QXIvMDVrejFMYlVXNU5YQ0xsOTlBL3Vab0poNkZRS2c5cjVMQ2xC?=
 =?utf-8?B?MWNucXhEQ21iZHI2cVkwbVF5SmVzMEdCUWpLdXVmcmRFMXFwSElsTzlVUDlF?=
 =?utf-8?B?UUpBN1l2WFVnRm9aUmErRFBDYTVvOEE0QURIYWNnNzB2dWFBdkw0ZktmUFR4?=
 =?utf-8?B?SGVNNmFqb0RyYzQ3K2J5MWFPYVhCV2ZkaHlYVUFlUjJTcW9iN214M2dKdHc2?=
 =?utf-8?B?WHRpaktJUnNTd0RHdGxhd0tyMWxrQXNlSENJbGJkbUJycTVTSDNjc2FLdThE?=
 =?utf-8?B?WEg1ZW5lWE1qcXFwODg2VThleTlIRWgxTzRDbndLeTRHT29UMEl0ZjUxeUc3?=
 =?utf-8?B?UDR4bG1sUVdmTnRIZFNBR3htQlBWV0k2Wkw2eVdrU2hyL3UvOGoyL1lhalEy?=
 =?utf-8?B?azlUaitIZXBoQWwzQVkzUk9MVzQyeWpKNGp2TlorYVpNMTZjRVpGMlMvUWhI?=
 =?utf-8?B?UE14Z3lWcEZONGJuTU9YeWV1S3ZDeHZyVTNJSi84UDBTenU4VElaVG55VkV0?=
 =?utf-8?B?S1owdVNmMExyeXhPQzlBRXZFUm94RkZTYXZxQlNDOGJhZnJ5UVNBVW1hVnJt?=
 =?utf-8?B?WFA5VW1jdy8xZUVIWVk1Y3FWb0NQNlJ6TGpGQUJ6TzlhekpGaDQzWnE5TTJS?=
 =?utf-8?B?Q3pORjBnMEczdCtFR2J1ZTQ0cFpZNlF0bXZJdnV5V0ljb2ZONGthOUgvdU9u?=
 =?utf-8?B?WGdPY01pdXJHQStMbFR2R2pFOFpxdGlxZ3pWaVZvdlB2VEQvWCtYWDFGaFR6?=
 =?utf-8?B?eG9QREVQUlExcUI4V0FPZnJRekREZ05QQVJ4aE9Eblg4RFdtWVJIWk9hQ0l4?=
 =?utf-8?B?QlpZWE5IZm5WNElnMldNWEJ1Qy95Mk5XRnprK1RjVSs3aHprdVppTmdEczdj?=
 =?utf-8?B?eHBCTUlrV2tLYWc3MC9aZlFiUk9HbW04K2hQYjBmTTdQamN5RFpuVTdZazNp?=
 =?utf-8?B?WFpieWIwV3lrdllsc3ZIZ0UvaHdjVE44WGw2eFlwMmNhNFY1T0pmNDhUWnhS?=
 =?utf-8?B?eEJ5VzRrSm50SHFwalVTYytMNGR4blBUbEkvSHplR0E3ZmJjVld0Z0lBblpF?=
 =?utf-8?B?dzVpNTdTRURVak5vbmtNMk9nQ1RjT051bytIdllxNHQ3WDRPVmEvUlhyYUFt?=
 =?utf-8?B?aHZSSkgwanl5NDlPVUY0NE9MZHB2aEY4K0xxQ2RHZmFrdlZhWVBzMlRtbUgw?=
 =?utf-8?B?NTVQM2NxcS9FR1liVkVUc0FxRTFWOUlQSHBQNGhRamZ4OEZ2cHlteG5rYlJC?=
 =?utf-8?B?UTNTWkNVc3lOd1dQVG1hRll4Wkg2WU05ZHVXdVM0b3I3Q3JwQXdPL3kzWVgv?=
 =?utf-8?B?OCsvSHZybTE4OUZ6eWNrWllzSVd2aDVrVFFPNm5GV1lGVFJBNzhINjdmWHBQ?=
 =?utf-8?B?QkVETmIzTlozMTNacVNNZlpQWS81SnJJUy9IVlZ0RWMvYzFiMnJPbGFFdXE1?=
 =?utf-8?B?RXoxVHAwRERRR1N3a2cydHNCemZaS2JlcldzS3E4M2RzKzZjeXJEb29JSCtB?=
 =?utf-8?B?N3Vwb3krem12Tmw2aHRjL2lhSDdpSk8xYnBsb3VkbXpYY2I3Y2l0NkU1OUhl?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <015169E978F5334B82BBD1BC0AB81CF1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4fb692-d228-4bb2-814f-08da95a24a96
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 16:09:09.4652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3mUAj9eshhbfcQoTSChG8YNuYujVWP8CMFwuonwoASOH82Z7/mOJPtfmnVznZ3GyxYJkl8HYgtbE3smMP40PSEyF8iu0OmNysje2+gV3PUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTMvMDkvMjAyMiAxNTowMywgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZl
biA8Z2VlcnRAbGludXgtbTY4ay5vcmc+DQo+IA0KPiBbIFVwc3RyZWFtIGNvbW1pdCA5ZDdiMzA3
ODYyOGY1OTFlNDAwNzIxMGMwZDVkM2Y5NDgwNWNmZjU1IF0NCj4gDQo+ICJtYWtlIGR0YnNfY2hl
Y2siIHJlcG9ydHM6DQo+IA0KPiAgICAgIGFyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21p
Y3JvY2hpcC1tcGZzLWljaWNsZS1raXQuZHQueWFtbDogc29jOiByZWZjbGs6IHsnY29tcGF0aWJs
ZSc6IFsnZml4ZWQtY2xvY2snXSwgJyNjbG9jay1jZWxscyc6IFtbMF1dLCAnY2xvY2stZnJlcXVl
bmN5JzogW1s2MDAwMDAwMDBdXSwgJ2Nsb2NrLW91dHB1dC1uYW1lcyc6IFsnbXNzcGxsY2xrJ10s
ICdwaGFuZGxlJzogW1s3XV19IHNob3VsZCBub3QgYmUgdmFsaWQgdW5kZXIgeyd0eXBlJzogJ29i
amVjdCd9DQo+ICAgICAgICAgIEZyb20gc2NoZW1hOiBkdHNjaGVtYS9zY2hlbWFzL3NpbXBsZS1i
dXMueWFtbA0KPiANCj4gRml4IHRoaXMgYnkgbW92aW5nIHRoZSBub2RlIG91dCBvZiB0aGUgInNv
YyIgc3Vibm9kZS4NCj4gV2hpbGUgYXQgaXQsIHJlbmFtZSBpdCB0byAibXNzcGxsY2xrIiwgYW5k
IGRyb3AgdGhlIG5vdyBzdXBlcmZsdW91cw0KPiAiY2xvY2stb3V0cHV0LW5hbWVzIiBwcm9wZXJ0
eS4NCj4gTW92ZSB0aGUgYWN0dWFsIGNsb2NrLWZyZXF1ZW5jeSB2YWx1ZSB0byB0aGUgYm9hcmQg
RFRTLCBzaW5jZSBpdCBpcyBub3QNCj4gc2V0IHVudGlsIGJpdHN0cmVhbSBwcm9ncmFtbWluZyB0
aW1lLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51
eC1tNjhrLm9yZz4NCj4gQWNrZWQtYnk6IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5r
b3psb3dza2lAY2Fub25pY2FsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IENvbm9yIERvb2xleSA8Y29u
b3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IFRlc3RlZC1ieTogQ29ub3IgRG9vbGV5IDxjb25v
ci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGFsbWVyIERhYmJlbHQg
PHBhbG1lckByaXZvc2luYy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNo
YWxAa2VybmVsLm9yZz4NCg0KSGV5LA0KSSBvbmx5IGdvdCB0aGlzIHBhdGNoIGFuZCBub3RoaW5n
IGVsc2UgaW4gbXkgaW5ib3ggcmVsYXRlZCB0byB0aGUgZHRzDQp0aGF0IGRlcGVuZHMgb24gdGhl
IHBhdGNoLiBIYXMgdGhpcyBiZWVuIGF1dG9zZWxlY3RlZD8gSSBkb24ndCByZWFsbHkNCnRoaW5r
IHRoZXJlJ3MgbXVjaCBiZW5lZml0IHRvIGJhY2twb3J0aW5nIHRoaXMgb25lIHRvIDUuMTUgYXMg
dGhlDQpib2FyZCBpdHNlbGYgZGlkbid0IGV2ZW4gYm9vdCBmb3IgYW5vdGhlciB0aHJlZSBrZXJu
ZWwgcmVsZWFzZXMuDQpUaGFua3MsDQpDb25vci4NCg0KPiAtLS0NCj4gICAuLi4vYm9vdC9kdHMv
bWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLWljaWNsZS1raXQuZHRzIHwgIDQgKysrKw0KPiAgIGFy
Y2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLmR0c2kgICAgfCAxMiAr
KysrKy0tLS0tLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNyBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3JvY2hp
cC9taWNyb2NoaXAtbXBmcy1pY2ljbGUta2l0LmR0cyBiL2FyY2gvcmlzY3YvYm9vdC9kdHMvbWlj
cm9jaGlwL21pY3JvY2hpcC1tcGZzLWljaWNsZS1raXQuZHRzDQo+IGluZGV4IGNjZTVlY2EzMWYy
NTcuLjRiNjlhYjRmZjMwYTIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcmlzY3YvYm9vdC9kdHMvbWlj
cm9jaGlwL21pY3JvY2hpcC1tcGZzLWljaWNsZS1raXQuZHRzDQo+ICsrKyBiL2FyY2gvcmlzY3Yv
Ym9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLWljaWNsZS1raXQuZHRzDQo+IEBAIC00
MCw2ICs0MCwxMCBAQA0KPiAgICAgICAgICB9Ow0KPiAgIH07DQo+IA0KPiArJnJlZmNsayB7DQo+
ICsgICAgICAgY2xvY2stZnJlcXVlbmN5ID0gPDYwMDAwMDAwMD47DQo+ICt9Ow0KPiArDQo+ICAg
JnNlcmlhbDAgew0KPiAgICAgICAgICBzdGF0dXMgPSAib2theSI7DQo+ICAgfTsNCj4gZGlmZiAt
LWdpdCBhL2FyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLmR0c2kg
Yi9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3JvY2hpcC9taWNyb2NoaXAtbXBmcy5kdHNpDQo+IGlu
ZGV4IDRlZjRiY2I3NDg3MjkuLjkyNzljY2YyMDAwOWEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcmlz
Y3YvYm9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLmR0c2kNCj4gKysrIGIvYXJjaC9y
aXNjdi9ib290L2R0cy9taWNyb2NoaXAvbWljcm9jaGlwLW1wZnMuZHRzaQ0KPiBAQCAtMTM5LDYg
KzEzOSwxMSBAQA0KPiAgICAgICAgICAgICAgICAgIH07DQo+ICAgICAgICAgIH07DQo+IA0KPiAr
ICAgICAgIHJlZmNsazogbXNzcGxsY2xrIHsNCj4gKyAgICAgICAgICAgICAgIGNvbXBhdGlibGUg
PSAiZml4ZWQtY2xvY2siOw0KPiArICAgICAgICAgICAgICAgI2Nsb2NrLWNlbGxzID0gPDA+Ow0K
PiArICAgICAgIH07DQo+ICsNCj4gICAgICAgICAgc29jIHsNCj4gICAgICAgICAgICAgICAgICAj
YWRkcmVzcy1jZWxscyA9IDwyPjsNCj4gICAgICAgICAgICAgICAgICAjc2l6ZS1jZWxscyA9IDwy
PjsNCj4gQEAgLTE4OCwxMyArMTkzLDYgQEANCj4gICAgICAgICAgICAgICAgICAgICAgICAgICNk
bWEtY2VsbHMgPSA8MT47DQo+ICAgICAgICAgICAgICAgICAgfTsNCj4gDQo+IC0gICAgICAgICAg
ICAgICByZWZjbGs6IHJlZmNsayB7DQo+IC0gICAgICAgICAgICAgICAgICAgICAgIGNvbXBhdGli
bGUgPSAiZml4ZWQtY2xvY2siOw0KPiAtICAgICAgICAgICAgICAgICAgICAgICAjY2xvY2stY2Vs
bHMgPSA8MD47DQo+IC0gICAgICAgICAgICAgICAgICAgICAgIGNsb2NrLWZyZXF1ZW5jeSA9IDw2
MDAwMDAwMDA+Ow0KPiAtICAgICAgICAgICAgICAgICAgICAgICBjbG9jay1vdXRwdXQtbmFtZXMg
PSAibXNzcGxsY2xrIjsNCj4gLSAgICAgICAgICAgICAgIH07DQo+IC0NCj4gICAgICAgICAgICAg
ICAgICBjbGtjZmc6IGNsa2NmZ0AyMDAwMjAwMCB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICBjb21wYXRpYmxlID0gIm1pY3JvY2hpcCxtcGZzLWNsa2NmZyI7DQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICByZWcgPSA8MHgwIDB4MjAwMDIwMDAgMHgwIDB4MTAwMD47DQo+IC0tDQo+IDIu
MzUuMQ0KPiANCj4gDQo+IA0KDQo=
