Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB976040D1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJSKWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiJSKVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:21:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645F3112A85
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 03:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666173669; x=1697709669;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YGRg3PcWew7zrnmdGI2i9zlrui3/4yHjoaUuAbD2pmo=;
  b=cm4IR74Nf4gIwHeemoYNQ1W4BppFx9ZRsTMvMEXmX14q4zDmCCyGlhO4
   ryHvEb98ZnwU0iUSeGviPy2U869LdSWiGP1sR3nU54A7f1q+G5ASAgwRT
   FcJWnsB1QQXim7DHBUgrKBEzO5h+s3EWG4QjsvyVyJPMvdBuyLfd8v8VA
   A81jM5lHm1c8M6gppON+HWLloStlZQeXhHbBQyzPYfElnZJMwpwiZr78l
   sA6RHAkInsYpg07Jn9AtaUsWA2edehc16pX28ebGW92XMcGC4Q9iskVca
   eBCfLmZzSygqpLgcT0lxmapNUnLluxjiD2jXIHt7vnGhPZ+K44gVsA6sR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="308048275"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="308048275"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 02:40:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="958256530"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="958256530"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 19 Oct 2022 02:40:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 02:40:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 02:40:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 02:40:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 02:40:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ParpGW8R+hI5Uf4vA/TrHga22ILeyOiKjQ+UbVO2wwWe0Zrno9PrC/QVSLoPkH4kKPFz3W+k5pDZp0A4rdGnuUpXhDr+6paHt2h+Kbtf61UFH8SFQSk/tyu4E/BXb5OSCb5i3HOUMkHweP3PF2EUBb5wdd62Cwu+SKqezOlmZCH8W4lkU0SkmuV+83QkpZvxw9tGjpLSPV79a0GVNAT2V7x/8NmIaEW2K0JVdpb8LyGMSIORbi1XOUGQw56ipUBfkFIWXtnHELBwGu7DIcR6Po8Of5Pb3AGCooEXv/HUHkm4dCVN3yvElBl350y4eLuxIQySB9AD0tWdPrc5DSsnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGRg3PcWew7zrnmdGI2i9zlrui3/4yHjoaUuAbD2pmo=;
 b=kIs2yxdkYSWJvr0dypT99UKEJnWWoLIm1reDBzDzIb0PcxJvQy0MBj4o1LQqKu6hCBQ731KSbx1HS6Nvo90hvMx4t3/uQk1fsqQ6us5WrIcmA/AR2MOSCAs5qQJOjAyrHcFNVAvkVG1jqf37Z128UcO+hDj00GqhycGEYUnoeutLw1Y+cs7LlXvMmKcRkdrTgewALz37uqnXPxvbYFLfcwZQFOfmA8lj3fq3EzizV/DeHVa5Lh85qN7DwtFfS99QxII2gS2ynJYVTh+G+Nr20gqV0TL/oAzNVeFr4ZHN/kQQ7+5tE8Ua40KOtufGYmcwsF6GrFr7EdtfnQ1Sgw9Rsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 CO1PR11MB4964.namprd11.prod.outlook.com (2603:10b6:303:9e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.30; Wed, 19 Oct 2022 09:40:44 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::c883:cac2:79cf:8019]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::c883:cac2:79cf:8019%4]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 09:40:44 +0000
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        "Daniel Vetter" <daniel@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Thread-Topic: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Thread-Index: AQHY1Cu/6lij7tp6KkeVH6VOHXXYMK4ARpaAgAAdzACAAOM2gIAAc7sAgBPaC4A=
Date:   Wed, 19 Oct 2022 09:40:44 +0000
Message-ID: <a2f60cc9-b468-2ef8-c9cc-b82675b157ed@intel.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
 <20221005141717.234c215e.alex.williamson@redhat.com>
 <20221005160356.52d6428c.alex.williamson@redhat.com>
 <Yz695fy8hm0N9DvS@nvidia.com>
 <20221006123122.524c75c9.alex.williamson@redhat.com>
In-Reply-To: <20221006123122.524c75c9.alex.williamson@redhat.com>
Accept-Language: en-FI, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5549:EE_|CO1PR11MB4964:EE_
x-ms-office365-filtering-correlation-id: 3bf1bbf1-90ce-405e-00f4-08dab1b5fe7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wH1czxKVUwbDIWrwqFnqQ1jCPih/VQs8ImwO3I7rR4ip8QgjG8p8Ztg2UyOOXhecZQ8wOwhIfiqaAR3kvYB3UhUxJAdIgCSN+yyvFL+5/FvHesh2aWMVZrtYD1qKPT9uCWS9LJPgWA/pPVFBOUSehjS6IKQj3gz8mylbPfpbUbWQUrVrdXHlPrflboLjYGKTN+DO4WR9RB4M9KXmZt1dqdCt8WhOntzWnzy1HcLIlp4HoAR8iSMDJH9Qc95mo2CStUy9ugTAeqHvPFY/udkuyI6vWFvu3wJ74ZB98abzKtIqS+VDm1Dcc1i+rBjA6CwnOKcWWR7wy3YMipYH+OmtSdnT/azoKiaVE1h6Yb/FkONjfva9ZFBFStQ8HWwR4aLRvREny9aZgcU/FEU2oP4ndI2Z6l1pdBO3nlWNFk0DSaILPKBgxwe2LoFKhvTSJhz0VEsJpiE+yAEevArbYCS8XdXf668KkgrRLZad//0Fubdxyf29U0IJFtd4OBZ9NOvfJTUOSDHcVjRBOYlHAyvtQiMwWcIGbzRWb6UNcF/gYTuLgzO5P9pzNue1TGrLm2JJJaDDs0eYY9SwgdIsrp0LbYut5GteqboVFpPKiLRPVZ6iBIj58l4UWBKfZzwp2pq7J/do9WW6kpUrPecNxW6J8UrrPmPfyq5521RC9KtVZb0tzxGoykAlk8aO6McThWIpOFPgJIsXyI4jFd0gM/q4Fex3o5RsaTW82OPTv5kJ9mcZZaMcCRGaMLWjzXDJYdCtFUmKp55LnZlBbFjZC9t8OVIbRMZOqphB/D5630uhNKpVWQpGeNhwuQZG267o7SoxKvU61Bm4N2L0QclBPpYZZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(110136005)(4326008)(6636002)(66476007)(64756008)(66446008)(86362001)(76116006)(66946007)(66556008)(316002)(186003)(2616005)(83380400001)(7416002)(2906002)(6506007)(6512007)(53546011)(41300700001)(5660300002)(36756003)(26005)(31696002)(8936002)(8676002)(478600001)(31686004)(6486002)(38100700002)(122000001)(82960400001)(54906003)(38070700005)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2Z1K25Ca0FLUTMxbFZLMDM5Nk9XUDR6d3I1S3RVa3pyQ0pSd0dyRlplR0J5?=
 =?utf-8?B?SWZpQ2Q1dytvL3loNDRtaTdqbWJiQ0cwR2tiY1B5UkRkbExjS3FTZXZGYS83?=
 =?utf-8?B?ZGgyVkNqbFo5UG1jRFVUWTFCNXBZSloyVWpvdlJ6UU5oZGdEZG01T3E5ZUtZ?=
 =?utf-8?B?dVVTeUhwTTNYY0E1cGVrcHp3emlGK0VkQlVlbldUL0M5SXp2enk2d2JST2NP?=
 =?utf-8?B?L1VRUW5PdGR3SzZFUURSRm9RQ3NYOCs0QnpRbVdTVVJEVTFDTGNobGtYa0FV?=
 =?utf-8?B?SUthSTJuTWNGdjRjRkxtY3dnS1B5M2dTMEpqZjhnd3VxNFJzbXZvL25oT2Nq?=
 =?utf-8?B?Nm9lREkwUzJyV1ZlSHBCaGNHY3lmTjBQKzlwOUlwVU5ndzB4N2RlRkNqZmda?=
 =?utf-8?B?a3ptTTkyVXNuVkFGT0JFTHBTN1NxSnAzNkJ2aXVnWnhEMlRSZ0lyc3pBZk1B?=
 =?utf-8?B?dnhUa0UxbVdUWUp0OUxEOURFQ3pKVDBFa1Y5THpyRVRGK3JUcGd4bVdIQXNG?=
 =?utf-8?B?Y2phYWZUU2JSWFkvaW9tRE1ML3JKZ3ZHd3J0UHJpcTB2TS9jcmZpbFI0MFBL?=
 =?utf-8?B?K0VRNFFQbmhGUHFPazRwWktoWGZER3VNMFRiOTBySEhHRUpBWHFRdnNnT3oz?=
 =?utf-8?B?a1lPd0VwUFlGSHIxemhMam9mVWFKbFNEV2tXWGZRMVdRM1NTWnQ5ZUFPb0tt?=
 =?utf-8?B?OWRHMytha2tTSnRLbStSWG9VSllQWHpEbzcwWVd4eU8wVHcxVVV0ZzhGM1lS?=
 =?utf-8?B?TlNRYzNMT2M5UVZ6SDRLOHZHVERnMzZwTzhuM0g5YjhaYytuRVNyc0JPZHhR?=
 =?utf-8?B?ai90VGlBbFEvYmZUOW1mRk1oSHlFTzhWa1VvZXdtbmwvd1ZNNHg4djZFY2R6?=
 =?utf-8?B?aE50YUZFTFMvTFRXdDRjeWMvMlQwOE45aVlCSlp5MnE0MUN2c0s2OHQreVBs?=
 =?utf-8?B?NnNaUUFleVl5OXdMSm9SQmFMQk9RTjRaNVZlWkRzOXJwS1FZY1dJMTJwTlEx?=
 =?utf-8?B?Z2ZvU0RTRThlQTg3bkpDdzZGc3BIak5NbUMxM0VTQTR4Qk9USEV6SjZoZWxV?=
 =?utf-8?B?TU42U1lvYkt3TVJoOUhHM3p4S2xGbDZUVDZIejRVdXdLWnVIT0c1Rm1yR0to?=
 =?utf-8?B?RGRyS05qc0VzOCs0Z3ZranlxdW5jeVM1c2syR0w5OUJLdzJoa0U1SVlNSzM4?=
 =?utf-8?B?WjJuTElwM1BPR3RPa0xmQmUyVEE1L2N4V1c3YklNNEVHaFJrTGM2WGhUUWow?=
 =?utf-8?B?MU9ZdjZFUk9ERFBNUDM3dENFQy9qZjZoR3JWUU9kUmJ3NVBXSVZqVksvOVpr?=
 =?utf-8?B?MXhkM0h2U0NPRi9IV25SbE5Kb3hFeUdyZ1d6bkNxQkNtd1BJeENOc0NQQmtB?=
 =?utf-8?B?SmVtS09XVVN6bWFoWEc0YmhmVUxzTEhVb2JIZHFCUitHdHpHR0w0NGZ1QTFG?=
 =?utf-8?B?MGpGYU01aXFRY2ZNSmY5R2JERXFYdmVER01UZWhCSGMvUlZNdVFaSkRDeGdM?=
 =?utf-8?B?UDZRZHdwUk5rYVBuNTlhcEtrOUV4eUMzSEpqRXhoTVllUlo2VnN5Ty9GcHpz?=
 =?utf-8?B?L0pteFVOU3dMZGdaSi9CZVVlUHFoYlBieU5oV3RnNStxeDRYU1dSejJhNElD?=
 =?utf-8?B?YXh2b1dJUXd6U0xHSFFEVTJqM083SmpHNy9ydUhOSXlQNGhXVTJXR0UvZ28z?=
 =?utf-8?B?NVBhcncraVZBMHhNOTRyYitSZ0ZESXdNQk1wQTdFY0FlWFlDWTA5N1pJTEEz?=
 =?utf-8?B?ZVd2OUVvbEgzSFc0dXN3eTZEcDcrWWI3SW5rWkpPTlNsaFJNcFcwR0ptbW9h?=
 =?utf-8?B?NFRKNmVlTW1ldDVWanF5WXFPbUkwTzNzeWRjZjc5ekhBekQ4ZUlCdE1vdlg2?=
 =?utf-8?B?VVpTTTRJZE1jSmZzQkwvcGJHWUlIY09lOFQwWnYvRWNPOER1MnRjaWNoeDY4?=
 =?utf-8?B?KzVlQUx6ZjlFSGtrZ1FtRzdMUXZ4bGNvdndBSGFlSVh2TjRSNWRFOGFvNHBq?=
 =?utf-8?B?aG9FZDJWVW4waDI5Qmcrd05ZSTNMdjR6cUkyQ1RBRGJrNG93SVo0dGtTZzA3?=
 =?utf-8?B?S3lWVFE4S0ZlSWxPdDFoMkxYT2laKzhsSU4vR0FiOTVGNytHTGdmc290eWg3?=
 =?utf-8?Q?X6lPSi7UYNVta4CbHSjqMAfDV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6F7B5BFB9A69B469A2BFABBE84FDE13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf1bbf1-90ce-405e-00f4-08dab1b5fe7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 09:40:44.2927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GGkBb0q7wKWbq77ZCzu/ReE1ZY3j29sgzAbrt0V5hRk7Z3pWRT7uT5CFbOXv3811Jr7HnXaRCeu5NCOV6CE4Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4964
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTAvNi8yMiAxODozMSwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiBPbiBUaHUsIDYgT2N0
IDIwMjIgMDg6Mzc6MDkgLTAzMDANCj4gSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4g
d3JvdGU6DQo+IA0KPj4gT24gV2VkLCBPY3QgMDUsIDIwMjIgYXQgMDQ6MDM6NTZQTSAtMDYwMCwg
QWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPj4+IFdlIGNhbid0IGhhdmUgYSAucmVtb3ZlIGNhbGxi
YWNrIHRoYXQgZG9lcyBub3RoaW5nLCB0aGlzIGJyZWFrcw0KPj4+IHJlbW92aW5nIHRoZSBkZXZp
Y2Ugd2hpbGUgaXQncyBpbiB1c2UuICBPbmNlIHdlIGhhdmUgdGhlDQo+Pj4gdmZpb191bnJlZ2lz
dGVyX2dyb3VwX2RldigpIGZpeCBiZWxvdywgd2UnbGwgYmxvY2sgdW50aWwgdGhlIGRldmljZSBp
cw0KPj4+IHVudXNlZCwgYXQgd2hpY2ggcG9pbnQgdmdwdS0+YXR0YWNoZWQgYmVjb21lcyBmYWxz
ZS4gIFVubGVzcyBJJ20NCj4+PiBtaXNzaW5nIHNvbWV0aGluZywgSSB0aGluayB3ZSBzaG91bGQg
YWxzbyBmb2xsb3ctdXAgd2l0aCBhIHBhdGNoIHRvDQo+Pj4gcmVtb3ZlIHRoYXQgYm9ndXMgd2Fy
bi1vbiBicmFuY2gsIHJpZ2h0PyAgVGhhbmtzLCAgDQo+Pg0KPj4gWWVzLCBsb29rcyByaWdodCB0
byBtZS4NCj4+DQo+PiBJIHF1ZXN0aW9uIGFsbCB0aGUgbG9naWNhbCBhcnJvdW5kIGF0dGFjaGVk
LCB3aGVyZSBpcyB0aGUgbG9ja2luZz8NCj4gDQo+IFpoZW55dSwgWmhpLCBLZXZpbiwNCj4gDQo+
IENvdWxkIHNvbWVvbmUgcGxlYXNlIHRha2UgYSBsb29rIGF0IHVzZSBvZiB2Z3B1LT5hdHRhY2hl
ZCBpbiB0aGUgR1ZULWcNCj4gZHJpdmVyPyAgSXQncyB1c2UgaW4gaW50ZWxfdmdwdV9yZW1vdmUo
KSBpcyBib2d1cywgdGhlIC5yZWxlYXNlDQo+IGNhbGxiYWNrIG5lZWRzIHRvIHVzZSB2ZmlvX3Vu
cmVnaXN0ZXJfZ3JvdXBfZGV2KCkgdG8gd2FpdCBmb3IgdGhlDQo+IGRldmljZSB0byBiZSB1bnVz
ZWQuICBUaGUgV0FSTl9PTi9yZXR1cm4gaGVyZSBicmVha3MgYWxsIGZ1dHVyZSB1c2Ugb2YNCj4g
dGhlIGRldmljZS4gIEkgYXNzdW1lIEBhdHRhY2hlZCBoYXMgc29tZXRoaW5nIHRvIGRvIHdpdGgg
dGhlIHBhZ2UgdGFibGUNCj4gaW50ZXJmYWNlIHdpdGggS1ZNLCBidXQgaXQgYWxsIGxvb2tzIHJh
Y3kgYW55d2F5Lg0KPiANClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhpcyBvdXQuDQoNCkl0IHdhcyBp
bnRyb2R1Y2VkIGluIHRoZSBHVlQtZyByZWZhY3RvciBwYXRjaCBzZXJpZXMgYW5kIENocmlzdG9w
aCBtaWdodA0Kbm90IHdhbnQgdG8gdG91Y2ggdGhlIHZncHUtPnJlbGVhc2VkIHdoaWxlIGhlIG5l
ZWRlZCBhIG5ldyBzdGF0ZS4NCg0KSSBkaWcgaXQgYSBiaXQuIHZncHUtPmF0dGFjaGVkIHdvdWxk
IGJlIHVzZWQgZm9yIHByZXZlbnRpbmcgbXVsdGlwbGUgb3Blbg0Kb24gYSBzaW5nbGUgdkdQVSBh
bmQgaW5kaWNhdGUgdGhlIGt2bV9nZXRfa3ZtKCkgaGFzIGJlZW4gZG9uZS4NCnZncHUtPnJlbGVh
c2VkIHdhcyB0byBwcmV2ZW50IHRoZSByZWxlYXNlIGJlZm9yZSBjbG9zZSwgd2hpY2ggaXMgbm93
DQpoYW5kbGVkIGJ5IHRoZSB2ZmlvX2RldmljZV8qLg0KDQpXaGF0IEkgd291bGQgbGlrZSB0byBk
byBhcmU6IA0KMSkgUmVtb3ZlIHRoZSB2Z3B1LT5yZWxlYXNlZC4gMikgVXNlIGFsb2NrIHRvIHBy
b3RlY3QgdmdwdS0+YXR0YWNoZWQuDQoNCkFmdGVyIHRob3NlIHdlcmUgc29sdmVkLCB0aGUgV0FS
Tl9PTi9yZXR1cm4gaW4gdGhlIGludGVsX3ZncHVfcmVtb3ZlKCkNCnNob3VsZCBiZSBzYWZlbHkg
cmVtb3ZlZCBhcyB0aGUgLnJlbGVhc2Ugd2lsbCBiZSBjYWxsZWQgYWZ0ZXIgLmNsb3NlX2Rldmlj
ZQ0KZGVjZWFzZXMgdGhlIHZmaW9fZGV2aWNlLT5yZWZjbnQgdG8gemVyby4NCg0KVGhhbmtzLA0K
WmhpLg0KDQo+IEFsc28sIHdoYXRldmVyIHB1cnBvc2UgdmdwdS0+cmVsZWFzZWQgc2VydmVkIGxv
b2tzIHVubmVjZXNzYXJ5IG5vdy4NCj4gVGhhbmtzLA0KPiANCj4gQWxleA0KPiANCg0K
