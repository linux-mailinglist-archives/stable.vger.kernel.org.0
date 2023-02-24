Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DCE6A1FE6
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 17:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjBXQoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 11:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBXQoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 11:44:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026A96B144;
        Fri, 24 Feb 2023 08:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677257051; x=1708793051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ly784NDDVJnzIx1OyIUDhj7paccH4VfGKw1KnmS82DA=;
  b=KdKqP14ug1SnzJfraJhn1k6Bwl1FC6HiB4fpFk90Mhh5iZQWV0/lnbxh
   cYyV3biIA/ATrH0diMcymXGHQgPJs5YWDqlcOu73eW/fJ45gR1lTiaue2
   4Bt1QYonnBGzk330kja3R1HmRQcXC6gPgXC81GXEP9e7gilJIpAcxXizq
   A/fc9GUl+RC61BcoMJKuSOrf4UUtTOlpZlHHH2kT7bmO3gFIGRYNVxfjG
   ic/Ia1V//rQ5FdiXFdwuifOhCVadxuZ7uKOQvuji+6vc9fYJWSCZfP9XQ
   EIsushahuHlylwOad3mUcZXVdXPqAAIlqAuWCI/wcNGlAvrH0ZhWFbgCY
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,325,1669100400"; 
   d="scan'208";a="202292010"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2023 09:44:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 09:44:03 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 09:44:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JduDXmkRQlUHCb9sxZ8jiTKUtkkfLefb7pcZfSQVPRg5EOMzYquPIvUCWKwSyBTGlDB+H0MnWua6ekFjgPtDEOhkc3MKZjOdbd1eAhadzrtXrQYNGaNkO4DS5kQbzSWRAKXtCd/bRJvEXt2FxXJtRu07urxpaamKL6KKN+KGfD0AhhU2z2b4Se3XZQ3qnhW8/uGp2plGl27tEPY24vD77GAbdK0hTw+MWB+/iY4WfPC5XwYzE8WvY8xIdbJjn3pV4ZtMjTJKYyuV8TGiQ8tAn+ANl1rZ1HRBL7bM1agUBk53q/RIoPDdsRuL0qdcW1FFdyZsQ0cbSZ5pgKt82W9etQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ly784NDDVJnzIx1OyIUDhj7paccH4VfGKw1KnmS82DA=;
 b=Mo6tSc0g+ojy8W///k4dR3zcC9YDnSA6WT9dJxr7y62jp9P0q5GihDFB+KUyQI/OQWMQ9lM2g9OuKBrxzaESOANYhMluZ4+AapQ/eOyAD4SbtsnHDXr3gl3ocX6+IYKv3fdypj1tlmTa38Tsx4QeQkupxSoOLUKSgpIStzI0Cjx8eR7YwSjn4mSxXXWRJ2+rl+1WLJfrfSGNPYQBnk2dVHiiSxDdaClH99qRdmivXd8cIj1URHGFIX61RXo6oF0zBO4Ao4UlqjzaPh6ignALjeud2CKDV3W/GjvC/KYUpSih8tSqPTQg776KS4Cbd+62W7pMpiyJkb1EupU8kgsHlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly784NDDVJnzIx1OyIUDhj7paccH4VfGKw1KnmS82DA=;
 b=msLUwvVG6Xuox3bR5JUfBW1oOTeb8lwye4jjzC96tVilIJ7Yn6j3iEVkXtpI00Ct2jWf48CsV+sqoRM59H8YAKElmVgqYpMa6DglKQfCARo+Oj9MSdDdGhW8skKjoNfCO1jofdWtuXr/h6S/1X9mZCue9/i2hdErnjGGm/dCbpk=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 16:44:01 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::6eb8:36cd:3f97:ab32]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::6eb8:36cd:3f97:ab32%5]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 16:44:01 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <johan+linaro@kernel.org>, <Ludovic.Desroches@microchip.com>,
        <linus.walleij@linaro.org>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <tglx@linutronix.de>, <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: at91-pio4: fix domain name assignment
Thread-Topic: [PATCH] pinctrl: at91-pio4: fix domain name assignment
Thread-Index: AQHZSG8yNWfQQp0eIUKC7QvD2EnZ0Q==
Date:   Fri, 24 Feb 2023 16:44:01 +0000
Message-ID: <e563ef5d-5e19-3c8c-6880-fa15d232106c@microchip.com>
References: <20230224130828.27985-1-johan+linaro@kernel.org>
In-Reply-To: <20230224130828.27985-1-johan+linaro@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|MW3PR11MB4683:EE_
x-ms-office365-filtering-correlation-id: 76685d18-4e4b-4270-d387-08db16865533
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bxtnqb0hxGf1MUytqsILS2F9bts4t2G0HIlJgInPIMSVnxS78FPiCaSQHaeTC4vMVIJCvSHMR8qv+D4dkaf+kMR3Nlaz0Uf+Unz9zfRZNTOxI3Zo3UMo5EZ/OvWfKGbfNvy10/Qgy/Gz4rfmsTLVGoNgg/bngaRMqvYYcZ4QEDYuXqyPEu/f1Dgl0k4x2gvKYu/K9OGnG7W5kZDABvGPMRbe4OYb3qASzPspE+q+aNVC+Y0kkxek2kByUkIcMQmSYZZOjBJ3hsw6S0GdLo9qorv8otk7oIUzxBRmlzos49plFJwh/QkGOdrFlz7ENKfJC+VGpZ4yOpRAmKObZeZhNtfiIyZ7+GQppMZQLe3JLBJN6upHvQifvY4tdqj/cFrxl92N7qazMaJakGEK1S475Xxw3TW2IHrFbIO1yYCcgn3sYezhTNI03M0QtbQG8Q+iZ2uvrB57xzZ18QRqtGnMMk08rDmi0FWx7B9l90CHx9Wh5EX/wMPhSAQ7m7effFXmaY10Z38YgzrRD4r6NfaAHekjgePWOVAQAsdobMK118e+J7AIrARLtD9gnD1sBfmPge9PZCXRRlKWLGTg7ThVGyRrN1QQ8+d8kgxmhmxfmDNLVzxk41U6CxwfTZhnuF0RBjjNANzeZFFl+0ULBlN0UGTw5zJ9szwazlaC/ow4QPHEVPX7mlt2+byIe96e07JKBw/rXwJyaSwbh8mXpKBMFLJaBOROjcInb9eNl0wCbeF7s3ihQNXA28yzFciQfA5AQQ6PIv+pvd+uGnJ+sEkDUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(6486002)(83380400001)(8936002)(110136005)(36756003)(5660300002)(66446008)(66556008)(66946007)(86362001)(76116006)(2616005)(66476007)(4326008)(64756008)(31696002)(316002)(91956017)(54906003)(41300700001)(478600001)(8676002)(26005)(186003)(38070700005)(71200400001)(122000001)(31686004)(2906002)(53546011)(6506007)(38100700002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlIyTEpacHlmMXAzWDN4T2lKVzBtbG1JVFQvWjZaVUJrQWRoOGFlSHlWRGc3?=
 =?utf-8?B?YWFYRkYwL1pDRUh4TlFVOFNhUG1ZZmxhL1BWaWx3Mkx2VnhLVU1aNm5yWU1Z?=
 =?utf-8?B?SHdPYnQwTXdqMUE5Sm1teDBSU2huMEV3MnovcUQ4T3dXRERDMWhaVmdDVTJt?=
 =?utf-8?B?Kzl0bnJWSkJzdVZBWWhZTkNqanplbWF5T0VCMFpxZHdLSE9ERllKYjY5bUc1?=
 =?utf-8?B?dUxXMkdpMnVmVGFxSHQ2NFNkc1hVNVMydnRLc3JqZ3FFSnJGSzlOdGxtcXR5?=
 =?utf-8?B?aEJkaDJDSXhmOTBpQWU3UFBWZmluUDZ3LzlYVzlwTy9DZ2FCNzJUcmNYRjh4?=
 =?utf-8?B?Y2tXbUFRM2NZRGUvdllaeDhzSW1FWHJnZ0EvZzIrdHYxUEtvVjlodStDWnZR?=
 =?utf-8?B?bnp4WmRybWNCZHRoL3hKZXZQVjd1UXNrcTlFdWY3c0dMWDkvcEpWeW50YzJU?=
 =?utf-8?B?TDQ5N3JOMXBwaFVPT2ZNeS8ya21vVThWK1VXOENvcW9oeTBDdlpNRHBIVmtt?=
 =?utf-8?B?WlhjMjRmUW1UYURtUnJMSTUxRzB4bDlOOXJVditYODh0MHNGU2Z0ZXdtdXJD?=
 =?utf-8?B?NW12WFViWXpvMzNxcE9VMnJ1WnNlaG1mbjFZRTYvelNTcy9kRTA2WGNqTnJh?=
 =?utf-8?B?OFlaMW85OFZKZENKQVpMenhva1VORStKZXZ4OTlsVlVUa05JbzVjOE0rOTZO?=
 =?utf-8?B?dHBvZGJSK1ZuY0dRdUlSY0xBb0FzelFUb0JCVXc4N0ozZk1lWk9LbVJ4NEtj?=
 =?utf-8?B?RWlLRS96KzNMNXBYQ3FvMnU1Um0weFlNOWpzczNmMVIrNTM3WTg2UE9EY3lK?=
 =?utf-8?B?MXkxTytkNzJ2UDc1Qmc2Z09TYVZpM0EzQjJVOG53R2Q1Ny9SK3E1cUNaMndO?=
 =?utf-8?B?bVl2LzlSb1dyajhmb0JEWWtPakY3V3p2c0hVUVRaOXJpM1hiMm92N0JRdDIr?=
 =?utf-8?B?Y3k4Q0ZUSi94NVlwZTRxYnRyaVJUNGt6YU8vUjh0d2JRZUFVQXBDdlVGTGs5?=
 =?utf-8?B?SUFFeW1UWlJvbTdjUFN4QTJFOWRvejRQb0l0SHMwRzY2anpma3hMVDkwRE1C?=
 =?utf-8?B?QmpObWlGR0FKYklhOWJjUHVsY2ZOdHVOQ0dSRlVtSVZDanI3aFJWblJzVXJj?=
 =?utf-8?B?MzBadmRJWktFOWZ2b2NCYm82bzlRdllxNVlLelMza1dRSDZJRGFQN3lmQW9J?=
 =?utf-8?B?TnhwODJ0R083WVgyMkNnWitvYzIvQUJUa2FqcU5sTDlVUGNTcW1mb01pUUhC?=
 =?utf-8?B?TWpyTTBQNDJURUsvbHFpelovWUNoejhmQjRSUE9TdVAxTDlsczl3MWtVckNE?=
 =?utf-8?B?SjJ5VDhrT01INzFHcFZrMjRCQVNwMm9VNEdCWUhBSmkrM1FkU3g2WVhXeDhu?=
 =?utf-8?B?Rk5xRzRGcTNzNlFLcS9KVWttUWMwYVdyYkpzajBDWFZGOHJWUHRyT2VKaEYw?=
 =?utf-8?B?NTZ2cXlzdzg2T2pRbmd1WENsOWpzWjNXdFZtdzRTMFp5WDZubVhqVjd5S3h1?=
 =?utf-8?B?ai9PVGhIOHFWMllKV0V5M2FOc05Fb2xvK0NycGhXcHBsYVlxVC8rSk5XeVNS?=
 =?utf-8?B?ZTk5TzZ3WmxBUUluOWJiUkFYZWR0YmwwMEs2WEJYS29kb3BLV1YxSUFLV0Qz?=
 =?utf-8?B?eDdoZFlib0d5UHJweEd4UmRPdUFMa0tOZG0wN0xhZzFpZkhyR3ZtR0ppckV5?=
 =?utf-8?B?RDl6RFc1eTZJOTZHUExaUnhSam1sWStvanFSRTN3d0hRZW4xQ2ptNlZ0d1FO?=
 =?utf-8?B?UFhKbzI3dXFna2EwZmhVWUszZW9QUEE3YmRXS1c3ZG9DY0dOdjRQWCtJbksy?=
 =?utf-8?B?WTR2U0lyK2ZtRlFvbExDVzhNZGt4UTB4aFhzbTdlRThZUGd1cGlBMTZ4RW9F?=
 =?utf-8?B?NEJPdkYyNm1JcUpvczd1OW1WcnhlOGJjWDc3MDJTY0xWeEVaTnljRzZDV0hk?=
 =?utf-8?B?NEVkT3BzeExYSFo4RWU4cVdrMi8zZktxMXEySWRTbm1NdHZMQlNHV3RuUkpv?=
 =?utf-8?B?RWlOcmdKejZkRlM0NVBjdUJnaEN6b0xnUHBsenBmTEVBMy9zSE1UZnZjMlJJ?=
 =?utf-8?B?cUI3ZHFaRzFnYUF3WWFDdVl3TmNrdzQ3bFRPNzJoYk83YlpQYVdkeWZNNkRh?=
 =?utf-8?B?MzQvT2dkR21JTGt5YUlRaGRpQlM5RC9CZVQ4ellheUoxWnhxUzM1MWliYmVh?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBF0078DF063F747918D5AC36FE590D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76685d18-4e4b-4270-d387-08db16865533
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 16:44:01.3633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 769bIdU6wH2kiYIMzhfsK4BL5+El/e8nmxZ0BlXStVbcX0gDw6mWPO7oImUPwr/Lw+CxAE8mo/CNzuHYqnxlDwAN8PHYcVqhCvdEB16q2eU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjQuMDIuMjAyMyAxNTowOCwgSm9oYW4gSG92b2xkIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFNpbmNlIGNvbW1pdCBkNTlmNjYxN2VlZjAgKCJn
ZW5pcnE6IEFsbG93IGZ3bm9kZSB0byBjYXJyeSBuYW1lDQo+IGluZm9ybWF0aW9uIG9ubHkiKSBh
biBJUlEgZG9tYWluIGlzIGFsd2F5cyBnaXZlbiBhIG5hbWUgZHVyaW5nDQo+IGFsbG9jYXRpb24g
KGUuZy4gdXNlZCBmb3IgdGhlIGRlYnVnZnMgZW50cnkpLg0KPiANCj4gRHJvcCB0aGUgbm8gbG9u
Z2VyIHZhbGlkIG5hbWUgYXNzaWdubWVudCwgd2hpY2ggd291bGQgbGVhZCB0byBhbiBhdHRlbXB0
DQo+IHRvIGZyZWUgYSBzdHJpbmcgY29uc3RhbnQgd2hlbiByZW1vdmluZyB0aGUgZG9tYWluIG9u
IGxhdGUgcHJvYmUNCj4gZmFpbHVyZXMgKGUuZy4gcHJvYmUgZGVmZXJyYWwpLg0KPiANCj4gRml4
ZXM6IGQ1OWY2NjE3ZWVmMCAoImdlbmlycTogQWxsb3cgZndub2RlIHRvIGNhcnJ5IG5hbWUgaW5m
b3JtYXRpb24gb25seSIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICAgICAgIyA0LjEz
DQo+IFNpZ25lZC1vZmYtYnk6IEpvaGFuIEhvdm9sZCA8am9oYW4rbGluYXJvQGtlcm5lbC5vcmc+
DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlw
LmNvbT4NClRlc3RlZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hp
cC5jb20+ICMgb24gU0FNQTdHNQ0KDQoNCj4gLS0tDQo+ICBkcml2ZXJzL3BpbmN0cmwvcGluY3Ry
bC1hdDkxLXBpbzQuYyB8IDEgLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3BpbmN0cmwvcGluY3RybC1hdDkxLXBpbzQuYyBiL2Ry
aXZlcnMvcGluY3RybC9waW5jdHJsLWF0OTEtcGlvNC5jDQo+IGluZGV4IDM5YjIzM2Y3M2UxMy4u
ZDY5OTU4ODY3N2E1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3BpbmN0cmwvcGluY3RybC1hdDkx
LXBpbzQuYw0KPiArKysgYi9kcml2ZXJzL3BpbmN0cmwvcGluY3RybC1hdDkxLXBpbzQuYw0KPiBA
QCAtMTIwNiw3ICsxMjA2LDYgQEAgc3RhdGljIGludCBhdG1lbF9waW5jdHJsX3Byb2JlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgICAgICAgICAgICAgICBkZXZfZXJyKGRldiwg
ImNhbid0IGFkZCB0aGUgaXJxIGRvbWFpblxuIik7DQo+ICAgICAgICAgICAgICAgICByZXR1cm4g
LUVOT0RFVjsNCj4gICAgICAgICB9DQo+IC0gICAgICAgYXRtZWxfcGlvY3RybC0+aXJxX2RvbWFp
bi0+bmFtZSA9ICJhdG1lbCBncGlvIjsNCj4gDQo+ICAgICAgICAgZm9yIChpID0gMDsgaSA8IGF0
bWVsX3Bpb2N0cmwtPm5waW5zOyBpKyspIHsNCj4gICAgICAgICAgICAgICAgIGludCBpcnEgPSBp
cnFfY3JlYXRlX21hcHBpbmcoYXRtZWxfcGlvY3RybC0+aXJxX2RvbWFpbiwgaSk7DQo+IC0tDQo+
IDIuMzkuMg0KPiANCg0K
