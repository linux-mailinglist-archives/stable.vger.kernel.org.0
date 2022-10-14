Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D2F5FE720
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJNCpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 22:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJNCpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 22:45:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7010F11877F;
        Thu, 13 Oct 2022 19:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665715531; x=1697251531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AobonvmpaPHd0m85cZBdqn7aTG4czwc2MmNhnr1sTZw=;
  b=WlAGiY1srbJ+mVK122FxRgL5rsQn9ls1KOg55LTyZg4zODpMxmXqw73l
   ukqYV1tMSJbIzFpQUh266aX2szsc7PERB+dz73GHwivhRZIMuXV/zSn1G
   EOWL3OWlRcqLiuVSM/ZIAu8BS0FaMg0w8fuyH+9pYeewK4hPRKnGHu155
   PTyr9pZpZ0cT5yfnZEA8H24OyqOdSnfrakOMViAI1SbA8huWgIUx/NGU7
   /cKsOiT306k9dH2WrWt3x2+8e9w1Dkjw3dw+WYycVYoZXcSgk99OZAZa7
   /USjjzzU0TxyfjpotdED6+PklvV+K+efF6Peh6v6+JJt7BkHNDK6tgc85
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="284986318"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="284986318"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 19:45:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="605214627"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="605214627"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 13 Oct 2022 19:45:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 19:45:27 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 19:45:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 19:45:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 19:45:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5qmmst8Fo6LrQx/zZBFfUsYvtceSw5FhxRDlUE7rjMs/vgz4dbx538mDuu/WBARR1c+WdtgQ1GQ7tKpcZeuVqy2rDabgXfkBAmmP9VvCthB7YvNRt+jF11X39tiKdToLgD9MKzu1/mn9gWmrD8y8clBxbARBBtzyZRXC47fynxYCAumtV5i3+nS3HkYc20xJ+lpDtXtTRAjtkFPhMNflKsvmbQ/hvNB8VVH5A2VtgCMHXBzymPkQfJoioH3osJ4nr4JAmgOnNOThv09nEt/xhdTPzjLQkco4Exc/7l2axcmjMpYbb4cIHGEIstqpEIk6Y7mKKS7lqygYlGBpHE3Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AobonvmpaPHd0m85cZBdqn7aTG4czwc2MmNhnr1sTZw=;
 b=hzBe4InVtuNMZh6KkdIGlVFjrtnqqh23dfDdkT3AExCz/T09qEJEhli+b/LVCeam6uwStp/fAFqUJp+HMcYTAuvYJ7dVkWjapJyjTtVzuD9MhSZEOgHMQ8XqaYnsZvWZwE+tUvdcXCd9kYf+t16e+/W5B8MAxkzw5f63j2S1YO6S1d4zUnVL+9YS3UlEpOVa19OGzVANGvhZE+egfAgsP5VvVOBlrYqkZLRRq8htleRsoztiVlofCbl32kWL2u1447Rp7a22nGJ1lkDopC+ahMfukTq5trM6B2FHWk1oKXFHKF+GOWEfkGtTViSEparcfH1X9vso2q+c7AfY/P1VhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Fri, 14 Oct
 2022 02:45:24 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::41ec:63f7:b996:ecaa]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::41ec:63f7:b996:ecaa%4]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 02:45:25 +0000
From:   "Yu, Fenghua" <fenghua.yu@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dmaengine: idxd: Do not enable user type Work Queue
 without Shared Virtual Addressing
Thread-Topic: [PATCH] dmaengine: idxd: Do not enable user type Work Queue
 without Shared Virtual Addressing
Thread-Index: AQHY3ncyzxusTM5q8ky2eoLNjQbRx64LSX4AgAAEKvA=
Date:   Fri, 14 Oct 2022 02:45:25 +0000
Message-ID: <IA1PR11MB609717CC0A6A04C9317CA4ED9B249@IA1PR11MB6097.namprd11.prod.outlook.com>
References: <20221012201418.3883096-1-fenghua.yu@intel.com>
 <9e967bb2-ac46-fc1c-ac3a-ed527c6a4cb5@intel.com>
In-Reply-To: <9e967bb2-ac46-fc1c-ac3a-ed527c6a4cb5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6097:EE_|IA1PR11MB7320:EE_
x-ms-office365-filtering-correlation-id: a26a5ede-9045-426e-92ec-08daad8e2579
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1AyIEUpNbdnpF8wc3KWobqEK3vwl8qZPMJm7rcuIsB+RBV/0g0gLA8zrgmXpItaPr2XF6Tdy+ERqnDJKVkOp3krErPCfxF035G7TKwm9By1J1SDSqyy2FSQYIBHcCHGgbZmPXKpOquelT6y0YHvvoUpQIGQf1DDNU+zzhEdodWT+kseRbDTBWWD5KCcBeciOcd09v/LGavrXTTHhii7YtSnwWARISsOC0jFX4kYQzB8PRG2ty74trIgvEK3Io6gYNPWA9JBnyQ/XDuBoPQXVBBpSm7d7vP4sbFSplLOlQfNnWemc0+zaca5/2clropPF40aBPrfOZshbHnN4YLxRuI4O1JH6Km6if082pRoYnSC2vEOrxBvIQqU9uTeMvMGFHVPKY2uPFcIGwkugsNAsGu0K0Y24Re4UihaMp/QQEVLgdVCRpdpslYUOPBqDiUwPm7GZlsT6qXmZuInXwnidVJi8NDo/bgW06aSfZRQDq/JOGI72laWW0BQB4APOOgysexm0kC3bqdtoc8Q91PxtR4MZzsWdnb9TQSsgdRVygf6MqRDuAQiYoQzzhaHEGfjqY+8FJCW5TQORYdHQZap2IuIJvCJJAZlu5YLNGGPnZsPoa2d5iWN8D87YhxR96TmXXqSHigd2+xRY4+rUG40Pq9ffSh7WbvHUtorIxyr3x2qpkYYRe+pBnbGJPGA4oXKf7TAgTiQJEVTaN29chhzRtSDx33TaJN0IeyOzGkU12rTYzcZANSCGf4oIUhSGYgH0bfMq8rKsDb21U0rdiS+Ff7CAOxvYtnJb5TQgmQL5wzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(52536014)(9686003)(26005)(8936002)(66556008)(54906003)(71200400001)(110136005)(38070700005)(33656002)(316002)(38100700002)(921005)(86362001)(41300700001)(53546011)(5660300002)(4326008)(6506007)(55016003)(122000001)(8676002)(478600001)(64756008)(66946007)(76116006)(66446008)(83380400001)(186003)(7696005)(82960400001)(2906002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0J3dG1pOHFMYXIrd1pKVTFmMnZndjMzUW1lY3ZMM1FhWWRicHp0RTVDSjdK?=
 =?utf-8?B?WC83MFMzb3hXR3I5Rm5wTlJ6elRLS1dwZ2F6Q2FMaDNUeG1ncGFyYWd3MytC?=
 =?utf-8?B?ZDRyUURONjlsTEpialJ0OU83dDJQbVc5d3M4bDFiaVlsRmpMQ2gybmppQXhy?=
 =?utf-8?B?UGYvWk1tOGdacVpuWHY1Tlp2Zk1LZDhuRDJuVmc2bnl0c1lSaEQ1WmtLK0VV?=
 =?utf-8?B?UzV6TGVjdmlFcjVudWRSOG1pZzhENWlwUk5wYjJBTE9sb1l1RWlabkYyK3FW?=
 =?utf-8?B?c2pMaW1mS2ZvckR6dUk2Mk8vZnRXQ3Vna3V1dVFUNVg1K29oUk9DUUcvczNI?=
 =?utf-8?B?UXBYL2kxcUFDaml3aU1GTjBlRFpNTGdIZldVL2JpQlUwWjJYVEFMazFHZkNl?=
 =?utf-8?B?MWFBdFZaMTBld2NqbXQ0a0lOUzdoQmNiY2lFbVpoelNSajd1bjUyUmVmdmF2?=
 =?utf-8?B?Nkcxa1N4aWQ0c1JVV29WRDVuOXZ4QmdDaU5KaG83b1ZJRnR1aS9KTjV3YnpB?=
 =?utf-8?B?OVZRRkdIS0FaLzdIT1R5eDc4SHNkclB4ZDZUajZVcEVVT2ZibDJhbk9uMkpm?=
 =?utf-8?B?Z25aazlaMWo2cmxoU0x6ZzYweVVoWDYvNWxib09Dc1M3Y3dLOW5GeHF4VTA0?=
 =?utf-8?B?cWhFTTZFVGZSWEVXOHhrZDQwZDl2RllNNE0yclZxZVNXVFhqR1FHL3Y5N05u?=
 =?utf-8?B?Vnk3R2UvUWtrUm8vbldZeTM4OC9YMUdvSEZaSFNNanFMNFlPUTQ4VytESTgr?=
 =?utf-8?B?cWFMOTdsZVhhSGdhakhEbk5iVm5vRXNyYXh5eitHWlBUS1JBNVRoZE5vU2ds?=
 =?utf-8?B?ZGwvdHlVYUp3KzFaeTV3Z013dnV4VnBDUUx5dnRnZGRVVWl0V3RuN0JyVWdt?=
 =?utf-8?B?T2t1eTdHV2g1NW5UUU5OSWptMHFZMXVTa0E5eUVOeXhvZE1scWQ2T05jTU5U?=
 =?utf-8?B?UkEvczFvRDFjUkd5aTNVNTFoaVZDakpiSkdjV2d3eWlEcFRaSFBXWUduOUYw?=
 =?utf-8?B?V0RMZFNUZVBraGFWbGxwTi9HNU9sZTArS0ptNmE2d2N6bHkrOGRINzdwOENN?=
 =?utf-8?B?Qm5mUUhYSUl5R1Q5RWc4eFZCdW9YNVZFZWk1SGUrMnVZME1HR2dHbS9NenJF?=
 =?utf-8?B?V0Faa1ZxclBHM1lqV25jV2VvQVZKN2ZUQWQ5Um1oeVQxWFprOHRnS2s2SHlr?=
 =?utf-8?B?Vi81UGxVb21kWkdpdHMxQ0dnb0tucDJPYmtlM0JpTW5ELzNMS1NtOGt3d0Vz?=
 =?utf-8?B?bVVMZ3FQZG5IcjBaRWJyNHcwZ1BHUXJnMExzYURBb1FEejVFaWtSRE9QMmsw?=
 =?utf-8?B?NnhDZjJxNWdTcXFmOVhsNUpCTVdyWXpVd1ZFMnE1cDVDcStMcVBVK0dIWGVT?=
 =?utf-8?B?L1Arakkxak9RM2J4UEhXbCtVZXRtVTRXWXI5TnZaWWZuVGRhYVFkWE5hOS9v?=
 =?utf-8?B?bmVTeS9QK0psYnhDYkFYY2ZLYkQ4MnAzSHVndVhvQ2pyOEhUN3RxN0Rsb0xx?=
 =?utf-8?B?b0NTVjFOeC81dldiaVRGdjk4SDZiVXp1Y01HZjR0Vmt4UXRkNnV1UUE3MlJt?=
 =?utf-8?B?RVhsOFVObTN4ZzVoVlFMRnVlMEQwaTUzSzJHL0VvMmcwQlZSM2hWQXY3c1FP?=
 =?utf-8?B?M0M1SlVvay9SSzlXS0c3ejVCdm9BeEVIdnJvNVdicFBBbTcrdjAySHZOZzdu?=
 =?utf-8?B?THBobGdWQU15NytRSlZhVnJDUExPeDN3L0dseFAyRUNvVy9vWi80TGhXM1Bk?=
 =?utf-8?B?b0pTS1FJTkQyU0N4Smp4Z25ueWFZTmFuWE9pL3h1Zy94KzB5NkxnbEFFa3F0?=
 =?utf-8?B?RmE4TXR2UUYwY1M3SzNPVG8zL3AyeGRLQjR6Q290aUlPeEl1TC9kNTRXdlFT?=
 =?utf-8?B?OTFDM3ppc2VWZ1h4MUw2cGV3WDZacHdRa2RiZ1hCWjVpb1lsQ3kwWXZWYVZl?=
 =?utf-8?B?Nkd4eWM1dEVnWjViN3NqRDBLR2xXYXZLekNkYlRNK2pkY3Z3a21HOVUzZGVP?=
 =?utf-8?B?WDQwOFNsdXl3eHpYVjlGSDNmUnR2bS83c2xONkJSWWUrTjJqRm8zRVNVQlNi?=
 =?utf-8?B?THdYR0ZKN3RMWkhjVnoxR1RTVnNxYmhrOGxuTWlDVFB1OUNLanA2MUNyTGRW?=
 =?utf-8?Q?fH00LCl8irWfLkVTZpnRZbfxE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26a5ede-9045-426e-92ec-08daad8e2579
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 02:45:25.1719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpvj7Y5NnpiXJYOdNGPp6loT2dyYXGVNr6t/M4cixvb0vjXzo8IIspg6Zc5x/9Wyd8Jr0morxIGIkwOvL5LRpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksIERhdmUsDQoNCk9uIDEwLzEyLzIyIDE0OjE0LCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gT24g
MTAvMTIvMjIgMTM6MTQsIEZlbmdodWEgWXUgd3JvdGU6DQo+ID4gVXNlcnNwYWNlIGNhbiBkaXJl
Y3RseSBhY2Nlc3MgcGh5c2ljYWwgYWRkcmVzcyB0aHJvdWdoIHVzZXIgdHlwZSBXb3JrDQo+ID4g
UXVldWUgKFdRKSBpbiB0d28gc2NlbmFyaW9zOiBubyBJT01NVSBvciBJT01NVSBQYXNzdGhyb3Vn
aCB3aXRob3V0DQo+ID4gU2hhcmVkIFZpcnR1YWwgQWRkcmVzc2luZyAoU1ZBKS4gSW4gdGhlc2Ug
dHdvIGNhc2VzLCB1c2VyIHR5cGUgV1ENCj4gPiBhbGxvd3MgdXNlcnNwYWNlIHRvIGlzc3VlIERN
QSBwaHlzaWNhbCBhZGRyZXNzIGFjY2VzcyB3aXRob3V0IHZpcnR1YWwNCj4gPiB0byBwaHlzaWNh
bCB0cmFuc2xhdGlvbi4NCj4gPg0KPiA+IFRoaXMgaXMgaW5jb25zaXN0ZW50IHdpdGggdGhlIHNl
Y3VyaXR5IGdvYWxzIG9mIGEgZ29vZCBrZXJuZWwgQVBJLg0KPiA+DQo+ID4gUGx1cyB0aGVyZSBp
cyBubyB1c2FnZSBmb3IgdXNlciB0eXBlIFdRIHdpdGhvdXQgU1ZBLg0KPiA+DQo+ID4gU28gZW5h
YmxlIHVzZXIgdHlwZSBXUSBvbmx5IHdoZW4gU1ZBIGlzIGVuYWJsZWQgKGkuZS4gdXNlciBQQVNJ
RCBpcw0KPiA+IGVuYWJsZWQpLg0KPiANCj4gSSdtIG5vdCBzdXJlIHRoZSBjaGFuZ2Vsb2cgaGVy
ZSBpcyBncmVhdC4NCj4gDQo+IFRoZSB3aG9sZSAidXNlciBXb3JrIFF1ZXVlIiB0aGluZyBpcyBh
biBlbnRpcmUgKkRSSVZFUiouICBTbywgdGhpcyByZWFsbHkgaGFzDQo+IHplcm8gdG8gZG8gd2l0
aCB0aGUgdHlwZSBvZiB3b3JrcXVldWUgYW5kIGV2ZXJ5dGhpbmcgdG8gZG8gd2l0aCB0aGUga2lu
ZCBvZg0KPiBkcml2ZXJzIHdlIGFsbG93IHRvIGJlIGxvYWRlZCBhbmQgZHJpdmUgdGhlIGhhcmR3
YXJlLg0KPiANCj4gQmFzaWNhbGx5LCB0aGUgKmhhcmR3YXJlKiBhbGxvd3MgcHJldHR5IGFyYml0
cmFyeSBkaXJlY3QgYWNjZXNzIHRvIHBoeXNpY2FsDQo+IG1lbW9yeS4gIFRoZSAnaWR4ZF91c2Vy
X2RydicgZHJpdmVyIGNvZGUgKGluY2x1ZGluZw0KPiBpZHhkX3VzZXJfZHJ2X3Byb2JlKCkpIGdp
dmVzIGxvdy1sZXZlbCwgZGlyZWN0IGFjY2VzcyB0byB0aGUgaGFyZHdhcmUsIHdoaWNoIGlzDQo+
IGJhZCBuZXdzLg0KPiANCj4gUGx1cywgZXZlbiBpZiB1c2Vyc3BhY2UgZ290IGFjY2VzcyB0byB0
aGUgZGV2aWNlIHZpYSB0aGlzIGRyaXZlciwgdGhleSBoYXZlIHRvIGZlZWwNCj4gcGh5c2ljYWwg
YWRkcmVzc2VzIHRvIGl0LCB3aGljaCBpcyBnZW5lcmFsbHkgbm90IGVhc3kgZnJvbSB1c2Vyc3Bh
Y2UuDQo+IA0KPiBUaGF0J3MgYXMgY2xvc2UgYXMgSSBjYW4gZ2V0IHRvIHJlcGhyYXNpbmcgdGhl
IGFib3ZlIFRMQSBzb3VwIGluIHBsYWluIG9sZCBFbmdsaXNoLg0KPiANCj4gSSBhbHNvIGRldGVz
dCB0aGUgIlRoZXJlIGlzIG5vIHVzYWdlIGNhc2UgZm9yIHRoZSBXUSB3aXRob3V0IFNWQS4iDQo+
IGxhbmd1YWdlLiAgVGhvc2Ugd29yZHMgbGFjayBtZWFuaW5nLiAgVGhlcmUgaGFzIHRvIGJlIGEg
KlJFQVNPTiogdGhlcmUgaXMgbm8NCj4gdXNlIGNhc2UuICBQbGVhc2UgdGhpbmsgYWJvdXQgd2hh
dCB0aG9zZSB3b3JkcyAqbWVhbiosIHRoZW4gZGVsZXRlIHRoZW0gYW5kDQo+IHdyaXRlIHdoYXQg
dGhleSBtZWFuLg0KDQpJJ20gd29ya2luZyBvbiBjaGFuZ2luZyB0aGUgY2hhbmdlbG9nIGFuZCB3
aWxsIHNlbmQgdjIgd2l0aCB0aGUgY2hhbmdlcy4NCg0KVGhhbmtzLg0KDQotRmVuZ2h1YQ0K
