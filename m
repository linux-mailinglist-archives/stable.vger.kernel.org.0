Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73699598027
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 10:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbiHRIeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 04:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241660AbiHRIeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 04:34:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D53073919;
        Thu, 18 Aug 2022 01:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660811642; x=1692347642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nPlBav536/HDURp7Oo0s+3nC9zgBJypQvxjQ9ol7AbM=;
  b=FMQPZXr9wx9ipIc42pFb+YDg5r6X2aHtiO+hG9XPN0QKiQD44BD0l1T3
   r6hwD4buuU1XOCfmh+Kv9OznVTmgUNz8R587pitL93jqKQsK8abO2rIC0
   xHHJlB3SQOfC1b9EokUV8Fo0L1li6ArMOB/x9E9r20r3EzKs+xlruRo1f
   KdgffeHwMnNit13bCARazcrpxgLeuz/yWRPmt62jVJUX0Lkb+mv4OP98q
   UrS1ciunv7CVThonNTL9WhMb+jZqaO86qoOFcq10exJHuHI3CT8zfIH0o
   /uqiHF07LYCI83yhUHbH/spuOYflAUlPzCe/3bq1Whh5ZAe5zvurwYqDF
   w==;
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="176889128"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Aug 2022 01:34:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 18 Aug 2022 01:34:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 18 Aug 2022 01:34:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iogO4hKlxoyup4hsFTNQ0MU2ZZxes9iSZZV9WdaAncIrTv4eCGs84x0NZOdKDtuLZp1xvjudvMddmJqmLaC1/tu794Be2F45oORkJkJ9zhIoucXjetk7vVTSi/O4Bo92mi8yyMK+Zk/gaB78IcyaCyuTILGB0u3N2zS0OX7bnNDMZf1FnqBZ2GSVQsC3/ttMEPW1Pr9HugFD6AVwN5xuIa/zrpNj04ISpW4WJYf5EV4366izL8qIZ/208oQTz7v3pXVS3/VLvGW3yxAAAvoiGAQ0rCy1kY53wLLGiM4fuKKcPrHE1W8mnqflRzts6JSHkltWnY+FaaMDcqj9gigjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPlBav536/HDURp7Oo0s+3nC9zgBJypQvxjQ9ol7AbM=;
 b=Is4cpADUFqWDjJ7WHuBN0pEXlW/3MDcnbCZ165VPd8vCCtb26DobECdtLlVsqH/3V7bClWOThAki8CHc8xOUEaAj+U9zhlWeM5mgQpD/V/AgU1/v1sjkT+O6CJ/ONgU639UjD/UcTPyxu7Swh8fGvd0NrvceMhI/N4Aqa+QUqQJTYG2E9UV8nSbxgWc1pJxn8ku0U6ODpW7AycZJIFApcIGh/8pbNJXNi2kBGHayANeQKKukOqPVH1fEoflWJptpk0vfKPrSsBK44e+UW90KbumGVTlS8ngNtL4uAB4h4/QRPVppEbHsSBXXJQmcFCdvPbB8EHGvde4fqloxBPjavw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPlBav536/HDURp7Oo0s+3nC9zgBJypQvxjQ9ol7AbM=;
 b=nGI8k+Fxz1I5dYa8JiH4T4sBYhqVxxiKCMGBeMline2F9Gut53gFLlimb+UelilXaqCyXnjFwG13Cfr3IMCHM4YZUCL58088SeN+Kf8ognbiW/m3VkfHbH0YgPY+n8rQi3Fym45ZQFb7AlPnPNY/g++80itqQOErbi8Np88qJ/o=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BN0PR11MB5758.namprd11.prod.outlook.com (2603:10b6:408:166::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 08:33:56 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%8]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 08:33:56 +0000
From:   <Conor.Dooley@microchip.com>
To:     <heinrich.schuchardt@canonical.com>, <Daire.McNamara@microchip.com>
CC:     <linux-riscv@lists.infradead.org>,
        <emil.renner.berthing@canonical.com>, <devicetree@vger.kernel.org>,
        <paul.walmsley@sifive.com>, <aou@eecs.berkeley.edu>,
        <palmer@dabbelt.com>, <geert@linux-m68k.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <atishp@rivosinc.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Thread-Topic: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Thread-Index: AQHYsjzjuV6JQqnbNU6bXELDL6GyqK2zYxOAgADZw4CAABSRAIAABI4A
Date:   Thu, 18 Aug 2022 08:33:56 +0000
Message-ID: <2f832b03-a549-5f2e-de1f-3f7ca9fcf808@microchip.com>
References: <20220817132521.3159388-1-heinrich.schuchardt@canonical.com>
 <32a72954-c692-6c5d-b07b-266d426c3cb4@microchip.com>
 <ccb5792bfe467dcc5046b7cb4de3a6af14cd3d5a.camel@microchip.com>
 <00500974-474d-3559-c141-3cc758bc0423@canonical.com>
In-Reply-To: <00500974-474d-3559-c141-3cc758bc0423@canonical.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0677fbc8-7d2d-4184-0c4e-08da80f463e8
x-ms-traffictypediagnostic: BN0PR11MB5758:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K5aRJWcP9YBCTzrkrutgLC5//vdxgAtDXI6Uf1EguwPbi5DTf/UAtUmWDUCypX6r6rEfthFx9sDsPkQj1XlKyvtUJu5ZAklnUeWzYjKcKIhZY6Y6PDL3Yfwj5EUz8lxq+P4izcWRU/oaqLXOzfiCzjxWvuaojrdKnSoz/nXRDJHX0TEj9ar10D0CP5u2EuOg9w7pD63v5QDFOSVvZAf7oEy62iVJZ9F8wjaosFwoa54qV6mLEnfI9dHjz8jxP9m5cZLpgeviQ0NyzPLtCN3KmqCZ6D6jWH/KWpH3ODuDhO1Mm/GJfSkAxcHZsz1EECYfupcb9yWVNIwW98fz8TRap4+Z05Q4iAkoa7P68sBHcxdicrWZDUGmBph+3kBQrgOMupHyOwUaIxldqxF1wOQccqAVlTG+LFb3Sd4qWXxytxXJKcuBsvqKcc35XNlEleBIVTgaiatCG1W9gl7G0qvsYJcUeN+sDKXM5Ta1402uYYDaSguHDAf66dwCnHmZjJD1TxVbfSx7KLrXUCM124/gevnUnMvWaeuxajIoukMBdcl68HN05sdOX8UBXQ1IDd+2NkMAH4VYcNkuXrjCbbAhjMniAlmNxpvP7qkZ1E3J03zQCoP/OI7mrWYm+gEDhyoaGzGjWa1FjaTgfeATvh+RUJ926C4rcFN8j5QWc9inzRGw5yO/3ayfpJ6FvMZBQ5+AxIRs1L0KE/YO+IdUYS8USj646QBgpzT912tNtmI5bohFckBX1RnqfvMQpWQSEzD89kBmgDynOjL7QXIqsVPGAK4t54qzmhHqPor7KiI2chg0xgv+3n9d6U1R8nVWuduyT9mIXlcfedfn3WSnYP0wBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(366004)(376002)(396003)(186003)(53546011)(6506007)(6512007)(86362001)(2616005)(31696002)(26005)(38070700005)(38100700002)(122000001)(83380400001)(71200400001)(7416002)(36756003)(41300700001)(5660300002)(91956017)(6486002)(64756008)(66946007)(66476007)(8936002)(76116006)(4326008)(2906002)(31686004)(66446008)(8676002)(66556008)(110136005)(478600001)(54906003)(316002)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak9NMGIzTDgwVHJpS0xyZzVoNGV1KytWN3E4UWprTXF6VHVsYUVLREVRNi9s?=
 =?utf-8?B?eFluZ2kxZE9zUjNudUlXaFcvMkxWVjQrZ2NYWFZYaXljbHRQZU1VQVZQUVli?=
 =?utf-8?B?QS9tU0ZkKzBMdEw5K3l5Z0VhZ3MzeVkvZnlZejBwR0xiMFRqMXk1eFlXWGN4?=
 =?utf-8?B?LzRXU2NNUTNUc25lNlJKeWZ1N2JmSnNYZkxiOVR6WDkydzY0RmRqZXRHMUxI?=
 =?utf-8?B?SGMyZEplMTgrNGsrZVBJQ0Q3MDBaU1dIYXErbUpwNWtuS2MzWW1FcWNWRHNB?=
 =?utf-8?B?WDJYVDNjZXZZaWgwSXVCWGdiOUNQSm11MytUZ1hYWGpPdjA4cEdvQmdHaURq?=
 =?utf-8?B?TlA3bmk2dGpnSzNvcWZyUGlTTDFDUkkvc2xpNUIrMlNzeFBrRUlYSGlPaGpu?=
 =?utf-8?B?MTBrOXEvV3NRMGE4M09SRFo3aFZjdnZ2WVBIUS9CYnFWNGdtTVZHWEo4Zjlt?=
 =?utf-8?B?OHhMUFR0WU5UbnBwamViRXJVbFJYWlh4NW1pK2Y5UllwSjNZOWl4dXY2RmJQ?=
 =?utf-8?B?cERhYURZZjMrb3o3ZFBMK0p4aTVkckN1TVJ3bTNTN3RRSkszR09IZ3J0MXI0?=
 =?utf-8?B?L2ZsZVNxQVRhb09uVTFaU1J6MzV5SjBUcDhZS1NaQXhLdUk2OEd6Y2hUeEFv?=
 =?utf-8?B?MlpoTDNJOW15Y0pwUVRwb2NBTVc4dFE5SzY4d0lvS2t0c1Z4TnFJUDdhN2V0?=
 =?utf-8?B?NlZKL09tWVdIUE9kdlNNVmtZelpMZjkxN2RYdmllRkIxZG52dm9TUmp3VHNs?=
 =?utf-8?B?alJ5bXgwMVp0ZVhvL0JkZURONGU3UTRUZHVGZlZjYU11R0FzdGpUV2VXcjdZ?=
 =?utf-8?B?aWpmeVpUZVY4M2ZvTDNSMVN6ZHBLYnViRVdPK0F1VkhOSmJwcGUyWXE5OHBR?=
 =?utf-8?B?REcrZnlOaXBENlh1RTVLRnRTVW1rcXN6c1IrdW0zdDJTVUwzNzArYjB0eHpO?=
 =?utf-8?B?ZHpIWU9TWlpqcjRIaElRL29kbnJYRDF0S3hjNFlIZWlCMnVsMnF0cWFKYTly?=
 =?utf-8?B?Z2l4MW8veG5qRHdnQmdBSFJQc2hweE9ZdDVTR0FOcXRuZ2FzL2JwZERKTEVE?=
 =?utf-8?B?SjF3bnVKdXpjdGNUQ1M4eVhPSSswc0VGT3h3Um5kWEVyNUpsWURPaXhRZDc0?=
 =?utf-8?B?N1JWVVZoVDVIYzB2OWMwSGFBR3UxT2U5Q3h5Y2Z2Vi9QazhsY05VRWYrclZU?=
 =?utf-8?B?UHNqd0U5TE41WjlybFhGYVR5RGs5YnRHTzdtYnRrSkpSVHR5anFacmowSHc1?=
 =?utf-8?B?M2VaNmo1dVZGTHBCMUZETnVrTDFoVEs4dnhyRU9JdkUxZTVqWEpqVWp1ZjZk?=
 =?utf-8?B?UUdyS3hCMVRoYzF1dEdZdWhQZU9xV2ZheE9TOEwvdmt1dm51OFpEQ21vSDgx?=
 =?utf-8?B?TGFMWGF4blNpODJlVjZ0VVE4NC9vaU8ySDh1Y0kzZ0NqRlJBYUNiUHlhYklD?=
 =?utf-8?B?RXRXOGs3blJEeFFlWGpvVU11TE5EYVZwNUJSeXo3V1V2SlRkSWcvczRBWjVa?=
 =?utf-8?B?VzJsZkk5bkJBZkEwNjkvdmJacVY3WWRObzZ5Z2hBTzhhUDJHamY4NTZWY1pT?=
 =?utf-8?B?V21mNkhsU0FDSGpXZE0rNWVhZnU2VWFCc00zT3RDazdKc3VXSHRNZU5pUzJW?=
 =?utf-8?B?Z3dWTWJjM3VvNHRQcXFLVytDSkk4NHVRdVlFN3dMWWJ2OGl3RGFkOU5LNXhu?=
 =?utf-8?B?SEp4TmtUL2hmaDVyZDJlR3lzL2wzWW01eGN0VkprV3ZtY3dpb2lFVW9EUUF1?=
 =?utf-8?B?U0ZqZ3lCaGR3SVhFVThoejhsR2FBdnVjMlQrcjJGSEZ0Mk1pbUk1dmREUy9t?=
 =?utf-8?B?b2dpcjlrWHZzZFpxb2tTZVRERldjelBoRTMxNHZoTjgwRkJmcnZXNDIxc0Ni?=
 =?utf-8?B?Qzk1ankwT0N4UnpBa1ljQ0ZLaksrT1dOMzlkTjJpVk1MVnBCd2Y4TitXR3Fn?=
 =?utf-8?B?WGszY1I0dEVjZEZwdXZ3L2JpdGhoSWRwY280cTFIZGlIeDJ1QmkwbmhDYXBI?=
 =?utf-8?B?UlQwa0RnQ0liWTRnRDFmL09vR21YWUtiWWFPRWpGdVB2eGkrcld6S055cVBo?=
 =?utf-8?B?aWNYdUtuMFNQcUxseW1SWkFHNlZzcWtSblBBaFh5SUgyeTNzYnhZd0xWb3k0?=
 =?utf-8?Q?9/G4i4qoqBtExTpouwBrSBB4P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D2FEB68BDF49546807263D55BEA0777@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0677fbc8-7d2d-4184-0c4e-08da80f463e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 08:33:56.2717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Mgj19BZW63sIESvNf1y7zIPKDl7VLw7JFt9o4W5b91xJqXQPSPyP3LBMtvqFkhScsMq2WQ69f+H12U+/g3R/iE3pOsUT/IlXetsn5Ywwjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5758
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTgvMDgvMjAyMiAwOToxNywgSGVpbnJpY2ggU2NodWNoYXJkdCB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiA4LzE4LzIyIDA5OjAzLCBEYWly
ZS5NY05hbWFyYUBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4gT24gV2VkLCAyMDIyLTA4LTE3IGF0
IDE4OjA0ICswMDAwLCBDb25vciBEb29sZXkgLSBNNTI2OTEgd3JvdGU6DQo+Pj4gSGV5IEhlaW5y
aWNoLA0KPj4+IEludGVyZXN0aW5nIENDIGxpc3QgeW91IGdvdCB0aGVyZSEgU3VycHJpc2VkIHRo
ZSBtYWlsbWFwIGRpZG4ndCBzb3J0DQo+Pj4gb3V0IEF0aXNoICYgS3J6eXN6dG9mJ3MgYWRkcmVz
c2VzLCBidXQgSSB0aGluayBJJ3ZlIGZpeGVkIHRoZW0gdXAuDQo+Pj4gwqAgSSBzZWUgRGFpcmUg
aXNuJ3QgdGhlcmUgZWl0aGVyIHNvICtDQyBoaW0gdG9vLg0KPj4+DQo+Pj4gT24gMTcvMDgvMjAy
MiAxNDoyNSwgSGVpbnJpY2ggU2NodWNoYXJkdCB3cm90ZToNCj4+Pj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4+Pj4g
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+Pj4+DQo+Pj4+IFRoZSAiUG9sYXJGaXJlIFNvQyBN
U1MgVGVjaG5pY2FsIFJlZmVyZW5jZSBNYW51YWwiIGRvY3VtZW50cyB0aGUNCj4+Pj4gZm9sbG93
aW5nIFBMSUMgaW50ZXJydXB0czoNCj4+Pj4NCj4+Pj4gMSAtIEwyIENhY2hlIENvbnRyb2xsZXIg
U2lnbmFscyB3aGVuIGEgbWV0YWRhdGEgY29ycmVjdGlvbiBldmVudA0KPj4+PiBvY2N1cnMNCj4+
Pj4gMiAtIEwyIENhY2hlIENvbnRyb2xsZXIgU2lnbmFscyB3aGVuIGFuIHVuY29ycmVjdGFibGUg
bWV0YWRhdGENCj4+Pj4gZXZlbnQgb2NjdXJzDQo+Pj4+IDMgLSBMMiBDYWNoZSBDb250cm9sbGVy
IFNpZ25hbHMgd2hlbiBhIGRhdGEgY29ycmVjdGlvbiBldmVudCBvY2N1cnMNCj4+Pj4gNCAtIEwy
IENhY2hlIENvbnRyb2xsZXIgU2lnbmFscyB3aGVuIGFuIHVuY29ycmVjdGFibGUgZGF0YSBldmVu
dA0KPj4+PiBvY2N1cnMNCj4+Pj4NCj4+Pj4gVGhpcyBkaWZmZXJzIGZyb20gdGhlIFNpRml2ZSBG
VTU0MCB3aGljaCBvbmx5IGhhcyB0aHJlZSBMMiBjYWNoZQ0KPj4+PiByZWxhdGVkDQo+Pj4+IGlu
dGVycnVwdHMuDQo+Pj4+DQo+Pj4+IFRoZSBzZXF1ZW5jZSBpbiB0aGUgZGV2aWNlIHRyZWUgaXMg
ZGVmaW5lZCBieSBhbiBlbnVtOg0KPj4gaW4gZHJpdmVycy9zb2Mvc2lmaXZlL3NpZml2ZV9sMl9j
YWNoZS5jDQo+Pj4+DQo+Pj4+IMKgwqDCoMKgIGVudW0gew0KPj4+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgRElSX0NPUlIgPSAwLA0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgREFU
QV9DT1JSLA0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgREFUQV9VTkNPUlIsDQo+Pj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBESVJfVU5DT1JSLA0KPj4+PiDCoMKgwqDCoCB9Ow0K
Pj4+DQo+Pj4gTml0OiBtb3JlIGFjY3VyYXRlbHkgYnkgdGhlIGR0LWJpbmRpbmc6DQo+Pj4gwqDC
oCBpbnRlcnJ1cHRzOg0KPj4+IMKgwqDCoMKgIG1pbkl0ZW1zOiAzDQo+Pj4gwqDCoMKgwqAgaXRl
bXM6DQo+Pj4gwqDCoMKgwqDCoMKgIC0gZGVzY3JpcHRpb246IERpckVycm9yIGludGVycnVwdA0K
Pj4+IMKgwqDCoMKgwqDCoCAtIGRlc2NyaXB0aW9uOiBEYXRhRXJyb3IgaW50ZXJydXB0DQo+Pj4g
wqDCoMKgwqDCoMKgIC0gZGVzY3JpcHRpb246IERhdGFGYWlsIGludGVycnVwdA0KPj4+IMKgwqDC
oMKgwqDCoCAtIGRlc2NyaXB0aW9uOiBEaXJGYWlsIGludGVycnVwdA0KPj4+DQo+Pj4gSSBkbyBm
aW5kIHRoZSBuYW1lcyBpbiB0aGUgZW51bSB0byBiZSBhIGJpdCBtb3JlIHVuZGVyc3RhbmRhYmxl
DQo+Pj4gaG93ZXZlciwNCj4+PiBhbmQgZGl0dG8gZm9yIHRoZSBkZXNjcmlwdGlvbnMgaW4gb3Vy
IFRSTS4uLiBNYXliZSBJIHNob3VsZCBwdXQgdGhhdA0KPj4+IG9uDQo+Pj4gbXkgdG9kbyBsaXN0
IG9mIGNsZWFudXBzIDopDQo+Pj4NCj4+Pg0KPj4+PiBTbyB0aGUgY29ycmVjdCBzZXF1ZW5jZSBv
ZiB0aGUgTDIgY2FjaGUgaW50ZXJydXB0cyBpcw0KPj4+Pg0KPj4+PiDCoMKgwqDCoCBpbnRlcnJ1
cHRzID0gPDE+LCA8Mz4sIDw0PiwgPDI+Ow0KPj4+DQo+Pj4gVGhpcyBsb29rcyBjb3JyZWN0IHRv
IG1lLiBZb3UgbWVudGlvbmVkIG9uIElSQyB0aGF0IHdoYXQgeW91IHdlcmUNCj4+PiBzZWVpbmcN
Cj4+PiB3YXMgYSB3YWxsIG9mDQo+Pj4gTDJDQUNIRTogRGF0YUZhaWwgQCAweDAwMDAwMDAwLjA4
MDdGRkQ4DQo+Pj4gwqBGcm9tIGEgcXVpY2sgbG9vayBhdCB0aGUgZHJpdmVyLCB3aGF0IHNlZW1z
IHRvIGJlIGhhcHBlbmluZyBoZXJlIGlzDQo+Pj4gdGhhdA0KPj4+IGF0IHNvbWUgcG9pbnQgKHBv
c3NpYmx5IGJlZm9yZSBMaW51eCBldmVuIGNvbWVzIGludG8gdGhlIHBpY3R1cmUpDQo+Pj4gdGhl
cmUNCj4+PiBpcyBhbiB1bmNvcnJlY3RhYmxlIGRhdGEgZXJyb3IuIEJlY2F1c2UgdGhlIG9yZGVy
aW5nIGluIHRoZSBkdCBpcw0KPj4+IHdyb25nLA0KPj4+IHdlIHJlYWQgdGhlIHdyb25nIHJlZ2lz
dGVyIGFuZCBzbyB0aGUgaW50ZXJydXB0IGlzIG5ldmVyIGFjdHVhbGx5DQo+Pj4gY2xlYXJlZC4g
V2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQsIEkgc2VlIGEgc2luZ2xlIERhdGFGYWlsIHJpZ2h0IGFz
DQo+Pj4gdGhlDQo+Pj4gaW50ZXJydXB0IGdldHMgcmVnaXN0ZWQgJiBub3RoaW5nIGFmdGVyIHRo
YXQuDQo+Pj4NCj4+PiBJIGFtIG5vdCByZWFsbHkgc3VyZSB3aGF0IHZhbHVlIHRoZXJlIGlzIGlu
IGVuYWJsaW5nIHRoYXQgZHJpdmVyDQo+Pj4gdGhvdWdoLA0KPj4+IG1vc3RseSBqdXN0IHNlZW1z
IGxpa2UgYSBkZWJ1Z2dpbmcgdG9vbCAmIGZyb20gb3VyIHBvdiB3ZSB3b3VsZCBzZWUNCj4+PiB0
aGUNCj4+PiBIU1MgcnVubmluZyBpbiB0aGUgbW9uaXRvciBjb3JlIGFzIGJlaW5nIHJlc3BvbnNp
YmxlIGZvciBoYW5kbGluZyB0aGUNCj4+PiBsMi1jYWNoZSBlcnJvcnMuDQo+Pj4NCj4+PiBARGFp
cmUsIG1heWJlIHlvdSBoYXZlIGFuIG9waW5pb24gaGVyZT8NCj4+IExpa2V3aXNlLiBUaGUgbmV3
IG9yZGVyaW5nIG9mIHRoZSBpbnRlcnJ1cHRzIHRvIHdoYXQgdGhlIGRyaXZlciBleHBlY3RzDQo+
PiBsb29rcyBjb3JyZWN0IC0gYXMgZmFyIGFzIGl0IGdvZXMuIEhvd2V2ZXIsIEknbSBub3QgY29u
dmluY2VkIGVuYWJsaW5nDQo+PiB0aGUgU2lGaXZlIGwyIGNhY2hlIGRyaXZlciBvdXQgb2YgdGhl
IGJveCBtYWtlcyBzZW5zZS4gVXNpbmcgbDIgY2FjaGUNCj4+IGRyaXZlciBkb2Vzbid0IGFsaWdu
IHRlcnJpYmx5IHdlbGwgd2l0aCB0aGUgY3VycmVudCBNUEZTIHJvYWRtYXAgZm9yDQo+PiBtZ3Qg
b2YgRUNDIGVycm9ycy4NCj4+Pg0KPj4+IFBhdGNoIExHVE0sIHNvIEknbGwgbGlrZWx5IGFwcGx5
IGl0IGluIHRoZSBuZXh0IGRheSBvciB0d28sIHdvdWxkDQo+Pj4ganVzdA0KPj4+IGxpa2UgdG8g
c2VlIHdoYXQgRGFpcmUgaGFzIHRvIHNheSBmaXJzdC4NCj4+IElmIGwyLWNhY2hlIGNvbnRyb2xs
ZXIgaXMgZW5hYmxlZCwgdGhlbiBpbnRlcnJ1cHRzIHNob3VsZCBiZSBjb25uZWN0ZWQNCj4+IGFz
IHBlciBUUk0uwqAgSSB0aGluayB0aGlzIHNwZWNpZmljIHBhdGNoIGxndG0sIGlkZWFsbHkgd2l0
aCBhDQo+PiAnZGlzYWJsZWQnIHN0YW56YSBhbmQgaXQncyB1cCB0byBpbmRpdmlkdWFsIE1QRlMg
Y3VzdG9tZXJzL2JvYXJkcyB0bw0KPj4gZW5hYmxlIGwyIGNhY2hlIGNvbnRyb2xsZXIgaWYgdGhl
eSB3YW50IGl0Lg0KPiANCj4gRGlzYWJsaW5nIHRoZSBkZXZpY2UgaW4gdGhlIGRldmljZS10cmVl
IGlzIG9ydGhvZ29uYWwgdG8gZml4aW5nIHRoZQ0KPiBpbnRlcnJ1cHQgc2VxdWVuY2UuIEkgd291
bGQgc3VnZ2VzdCB0aGF0IHlvdSB1c2UgYSBzZXBhcmF0ZSBwYXRjaCBmb3INCj4gYWRkaW5nIHN0
YXR1cyA9ICJkaXNhYmxlZCI7Lg0KDQpBeWUsIG5vdCB3cm9uZyB0aGVyZS4gQXQgbGVhc3QgZnJv
bSBtZSwgaXQgd2FzIGFuIG9ic2VydmF0aW9uIG9uIHRoZQ0Kd2F5IHlvdSBkaXNjb3ZlcmVkIHRo
YXQgdGhlIGJ1ZyBleGlzdGVkLiBJJ2xsIGFwcGx5IHRoaXMgcGF0Y2ggdG9kYXkNCnNvIC0gdGhh
bmtzIGZvciBmaXhpbmcgaXQhDQpDb25vci4NCg0KPiANCj4gQmVzdCByZWdhcmRzDQo+IA0KPiBI
ZWlucmljaA0KPiANCj4+Pg0KPj4+PiBGaXhlczogZTM1YjA3YTdkZjliICgicmlzY3Y6IGR0czog
bWljcm9jaGlwOiBtcGZzOiBHcm91cCB0dXBsZXMgaW4NCj4+Pj4gaW50ZXJydXB0IHByb3BlcnRp
ZXMiKQ0KPj4+DQo+Pj4gQlRXLCBpdCBpc24ndCByZWFsbHkgZml4aW5nIHRoaXMgcGF0Y2ggcmln
aHQ/IFRoaXMgaXMgYSBkZXBlbmRlbmN5DQo+Pj4gZm9yDQo+Pj4gYmFja3BvcnRzIHRvIDUuMTUu
DQo+Pj4NCj4+PiBUaGFua3MgZm9yIHlvdXIgcGF0Y2gsDQo+Pj4gQ29ub3IuDQo+Pj4NCj4+Pj4g
Rml4ZXM6IDBmYTYxMDdlY2E0MSAoIlJJU0MtVjogSW5pdGlhbCBEVFMgZm9yIE1pY3JvY2hpcCBJ
Q0lDTEUNCj4+Pj4gYm9hcmQiKQ0KPj4+PiBDYzogQ29ub3IgRG9vbGV5IDxjb25vci5kb29sZXlA
bWljcm9jaGlwLmNvbT4NCj4+Pj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+Pj4gU2ln
bmVkLW9mZi1ieTogSGVpbnJpY2ggU2NodWNoYXJkdCA8DQo+Pj4+IGhlaW5yaWNoLnNjaHVjaGFy
ZHRAY2Fub25pY2FsLmNvbT4NCj4+Pj4gLS0tDQo+Pj4+IMKgIGFyY2gvcmlzY3YvYm9vdC9kdHMv
bWljcm9jaGlwL21wZnMuZHRzaSB8IDIgKy0NCj4+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL3Jp
c2N2L2Jvb3QvZHRzL21pY3JvY2hpcC9tcGZzLmR0c2kNCj4+Pj4gYi9hcmNoL3Jpc2N2L2Jvb3Qv
ZHRzL21pY3JvY2hpcC9tcGZzLmR0c2kNCj4+Pj4gaW5kZXggNDk2ZDNiNzY0MmJkLi5lYzFkZTYz
NDRiZTkgMTAwNjQ0DQo+Pj4+IC0tLSBhL2FyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21w
ZnMuZHRzaQ0KPj4+PiArKysgYi9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3JvY2hpcC9tcGZzLmR0
c2kNCj4+Pj4gQEAgLTE2OSw3ICsxNjksNyBAQCBjY3RybGxyOiBjYWNoZS1jb250cm9sbGVyQDIw
MTAwMDAgew0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgY2FjaGUtc2l6ZSA9IDwyMDk3MTUyPjsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNhY2hlLXVuaWZpZWQ7DQo+Pj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnRlcnJ1cHQtcGFyZW50
ID0gPCZwbGljPjsNCj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGludGVycnVwdHMgPSA8MT4sIDwyPiwgPDM+Ow0KPj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50ZXJydXB0cyA9IDwxPiwgPDM+LCA8ND4s
IDwyPjsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfTsNCj4+Pj4NCj4+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2xpbnQ6IGNsaW50QDIwMDAwMDAg
ew0KPj4+PiAtLSANCj4+Pj4gMi4zNi4xDQo+Pj4+DQo+IA0KDQo=
