Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F361D5E81B0
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 20:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiIWSUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 14:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiIWSUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 14:20:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B41EB5A62
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 11:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663957236; x=1695493236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L3sSAM8a46vfSn0J4yo/cDNpYqGAkeM7SBC13akItJA=;
  b=XAeTZ+7rvQZM3x+73AsrVClLPlQp1W43Brne9CM/obi+ztMKgC5LXvfF
   JXCc5s7YEzQzG1/0jqQsPPqp5TiP+cnZizj86xiDU6/6mTEKciz5zebrA
   hODSPnqP3cf31afZegloApK1WLaW2Sas3tFTHw/JConfjzPvgeDvYyL9b
   O0gEFT74DpdnrEQfT1IYOGgBiI12U4vxmC/Ul5KtzyIutDEunFAAHgSXg
   5iuSvAHprKWjCtLfoVN6kIosfAOySc7N2rSH4dLOEpqCHmS1/LfgxmSLY
   jYyRX8SxfH10OznAthCOmfzZveCD0sDuT3+mnB8jMtKOGH96fXQ2hiouo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="281021776"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="281021776"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 11:20:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="865390233"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2022 11:20:35 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 11:20:34 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 11:20:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 23 Sep 2022 11:20:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 23 Sep 2022 11:20:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaGgM3nvNf5b1fhMDt+9I0TlBoHYRkLnFk40Ou29OcBc2gETQ4UjUxXFr/eYue6WTfac2FznADX/8LokN6Ydo8JSTGPyLmEo+H200hZtGmg8o1IdcD0XjX1N8uX5uSZ91Edg1CNIjh2pJ31gqhp8S1l+6g413rHFRrqP7P7BYvNdHm6pInqFEF6BK0dN1Tc3IVqGYn6bsk+RAY6Q/ZXhdzJGUXWN3N3ls2HXspFvtzZZNJ0rYYJ3cBXv+GfxOX8H6rxGVxkQ0Ki8FNSHf8qqVw1T+DsktAXWYyFlQF0PedL22XaNgGf5Z0iYJvdgaxvYkcgrGfnSLDmsZFysFQ9BuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3sSAM8a46vfSn0J4yo/cDNpYqGAkeM7SBC13akItJA=;
 b=SZl3JIkqPtuereCslLROnxHamVFJDphjnDvo+RoekkPH7zSlSNDwdsyaEUGl+0Qw2ZUc9TunabLCLmU4tlp5uC/eGZaqdi6Nddf5C9udiPudCCo0cPAQds+PenDV1ZQdHGldQ5B8A2KbCL3Ii/ZN/yGtUjy+iETM5FURIO1pBTC/L6Dm0k69RUOiruqNp/bSeLtSJKxd/6hgthl65Gu9kOK6x42kGztVOzyt/+xp2pULFMGU7R6uqGZcqhL5z6aOmEm1MiULwFnitr5Y6l9ptyLMK5GX+mP6zzPE3/NiU4/mG5+74AV15dvzGls/h2ZPGDAgN/K/4CMRC/+ekBfXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 18:20:29 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ea6:6f6c:f2dc:cec7]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ea6:6f6c:f2dc:cec7%3]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 18:20:29 +0000
From:   "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
To:     "tvrtko.ursulin@linux.intel.com" <tvrtko.ursulin@linux.intel.com>,
        "Gupta, Anshuman" <anshuman.gupta@intel.com>
CC:     "Nikula, Jani" <jani.nikula@intel.com>,
        "daniel@quora.org" <daniel@quora.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
Thread-Topic: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
Thread-Index: AQHYzeEYUB05RLeQqEK0AqRZuvlg7a3rFcAAgAAd7ACAABg0AIAAGXGAgAHxPQA=
Date:   Fri, 23 Sep 2022 18:20:29 +0000
Message-ID: <61c4c60f435ff8eb2f94123e84831eeb24492f49.camel@intel.com>
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
         <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
         <YywuKoAg35X1Pclh@intel.com>
         <d2a3a63e-597a-6423-3660-f16717dc85e2@intel.com>
         <CY5PR11MB6211DA61B9089B4D700DE745954E9@CY5PR11MB6211.namprd11.prod.outlook.com>
In-Reply-To: <CY5PR11MB6211DA61B9089B4D700DE745954E9@CY5PR11MB6211.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6059:EE_|PH0PR11MB4902:EE_
x-ms-office365-filtering-correlation-id: 91f4b685-4646-4abc-1f4a-08da9d904b9a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qISE+NVYoPcpe4KyMAkjM/bUNDAB/m8VV0ZviITsLVW0t4aS8JNNVa9/Vkj4Jh7N28gCc/3iKwyundwlcnM8sq2NBZTGJCliUVEjEpTwKsoEC/keVWzkItaMuSJ1ILWVGRtw5HUVigf2Bob8np+BWORj1PvrpytaNcUUItFIvkAYBt92C25x0arr5WlLBBNCQalVBlzxnvmsWMLnUm628aqXBAM2Fi3ddvXattTdtqzd73Z31jVflEcUFL8Fb755BxnZ9nUHwyLpfGKgALMKhZu6cnAzgtRu/QsI54tE+vuR9Kma4r2SMt0vzaRRKusRjiJjXnwRMcqHCsYr4Jy+0F1QPkXV98V5iw0xGVW/nO5N5H09FVg+e1D/KH0cwHKeR6LGZArNU0kqg010h0/zUUdZd2A8fSgPiTp//GKXk08kXCqPCpR7kOEIoEsoCvK0kCS6eEKDcGNyPXedw0nSzhafD+DY3oJmKSHS7LSB1z1A3VLLbQLSRvhZNKbzUJFsYU0gZTK/wKhmhU5Va92DXmnRY9o61YXoz0etD9mNg5TnbINwvO0+92/mtpuRX2NCP34iGiIMmmeiscrF184kDjrGlF4XAweNuOCrzVItVafyLFaAS5Ajf/hj2I9NUR2vvtoVgv6Hwy4K5heFicAFpm5si1vXsRQB5OfNIqjqkpRZHaTOQfDNkI9Q0CkkTMoCVyN7wvt1V8Qrj4k73MVXDO4YznVTzG8uVuanItTJXSUDcA2xwT7drsCfI8bDc4HQ4BtU4QoO5xj33Pmi+vobGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199015)(66446008)(8936002)(4326008)(66476007)(66556008)(91956017)(82960400001)(64756008)(66946007)(76116006)(122000001)(36756003)(86362001)(38070700005)(38100700002)(5660300002)(2906002)(53546011)(6506007)(26005)(6512007)(83380400001)(6486002)(71200400001)(2616005)(478600001)(8676002)(110136005)(41300700001)(186003)(54906003)(316002)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cG1IWVR0Y2xsdTNXNnVHd2I5NFpobFFtZXhsRUxyZ3hid2lMZzBzcUtjYjNh?=
 =?utf-8?B?WlhsUkg3WWdlSDBrOUd4bXVJMTJNSXR3V3hyWmxMT2hJM2FpL216aVdEczBx?=
 =?utf-8?B?L05BdlVXanZWRlp2OTdaMXByU1UzWG5FTkNkVGt4Rm82NUV0dkhzS3NMQVRr?=
 =?utf-8?B?NFRQQkhwS0xhRlk1QXV2dlVtcVRLdFQ4b3lCQ0UrS2ErSWZaTGdaeWFiaWpH?=
 =?utf-8?B?V0ticzV3R0wxazNSWGRyMFpZNVhlTUpXeGo1Y28zOVZOVHZSeXQwN1JRRTB1?=
 =?utf-8?B?ck5pcVIyWTlMYmphU0xtZklJYnh3d0k5Z3YxWXVwcXprc09LSzBFR2FWeVc1?=
 =?utf-8?B?bHRNUSsyQ0NhdkdiQnFZc1I4akxFTWdTQ3l5UnUxSi9CYWZ2YXFSTXFPdm5M?=
 =?utf-8?B?bzY4WFM2Y2c4ak1pN0tHNWE2WlVvYzdVK2F3eTZyZTU1NXZucE1QSjFrM0hl?=
 =?utf-8?B?YmNyMW1nbDkyTHpXb3dNOTJmWXFWNmd6ZWdhM1RGYUxxb1NiVEplaUljR3pr?=
 =?utf-8?B?V0V2VFlacGRpMnJxUHhLVkdyVHBreHY5a0dtaEh6azFBZzJpLzZKQjk1N3hS?=
 =?utf-8?B?YUdJdDJyYXRMRzkySkJ0M3BFOGltZlUxdTNOcVJvK2lURE5zbGhodnhPOEpK?=
 =?utf-8?B?YnFrRTBKZzJYdEEwVTNyTllFdWJ0dSthbDAvU0FseXJ1ZjlmVm0vb0dqY2Na?=
 =?utf-8?B?T3RwQVRTMng4WTFnQ0VOaldZN25JeVJ1M01Mem81dDNYWXFiakZrdWFINUZo?=
 =?utf-8?B?RnpyV1JWVmxqbGVCK21DcDBCUVFWS2ZrdHl1L2pudEg5aHRvd0MzaHhkTlU3?=
 =?utf-8?B?dUtkWWVPMHNrU0VDY0VnQi9uKzlEaCtvRkFjbEY5Rk9BSUUrL3BJMkYzUzhS?=
 =?utf-8?B?Z1Q3L296Qkh5V2ZKTGgxUmZUUXhXZlVvb240Z1lhKzN5azN1WklSN1Yva09Y?=
 =?utf-8?B?QmN0Z2FwdVNaN1ppZmZGWHo5c0tuUmJEaVYvcXRCejV3dUJRUDJYaVVSaXVj?=
 =?utf-8?B?azZtb3VUNE9aME1JWUpoNTBSVGpjWEdmL2M4ajdpQi9IcDFsdGZ3MDAyL1hG?=
 =?utf-8?B?eUF0dTJxejBCSHgrZGFGME1TU01LNkxWaWtkTkxKb1VjS1VmWHBSaTdTQk5F?=
 =?utf-8?B?ZXlKQVB4OXhrNWhKNG5SQ2xtc1R3eUpNS2lSQWZKaUJ3N3hkbGtwZ2pUcVRx?=
 =?utf-8?B?eVBrWkhvcE9oQXloMTRJelhvSWk4YkxubDdJR0hyTGhwLzFZWC96SHBKN3A1?=
 =?utf-8?B?Z1NPSU1aeXpzUDVObnBlbzB3T09ranBodFJpTmtnYmpZZnpqU1VrMUZQTHNT?=
 =?utf-8?B?ZEdGK1ZwOXRmZmdKRi8rUjRDTk0wbUkzTkJzL2JqU3ZBVGI2WWJmdzBiM045?=
 =?utf-8?B?V1pwSlZGZUZiQTVuaDZ4Z1Z4WG5KSUFqRUM2c253dUFNRFYyb3FsYjUzRmtu?=
 =?utf-8?B?TTlnRm5ndVFXOVVtRkZ0cHlkbFpTK3BsSWVvL1VSWEIvQjlpZEpZSTRGcm4z?=
 =?utf-8?B?MzdGN0hGVE0zVGlEdWpBUXROd2tPMXhiU2JiVTRTTGFWejI1azZ4bFFaUnNm?=
 =?utf-8?B?NE52Mk0rVHJvcU1vMHNuclhieklvNjlpaTFjc2NSY3ByRkRLaVZHZzZxZjdh?=
 =?utf-8?B?TC9MMzVCZURkKzJoL0tUSHFFa1Vkc3V2TWtLM0Y2NnZJT3dxTnI1UWF3QkNB?=
 =?utf-8?B?Qmk2d0sycHl5am42eUZrb2dBd3MzcDNqcXZlYkkzTndQVnpleHB5QTE0VGNz?=
 =?utf-8?B?Z2lia3JUN0xyMnpwVndldDMyQlZ3WUFmem5YdlljQUxrSlJNYTVwZnYxZTlv?=
 =?utf-8?B?ZXl2SlJVQTh4MWduQ256M1hhUm52ZEdGcVZ0c1pJNDIxazVNRUR0MS9vd2o4?=
 =?utf-8?B?R2Vrb3RKdTRKZjdUczRaWVpaUFRGSUtvckF0eWg3VzloSUNiZU5sTUpkWFd5?=
 =?utf-8?B?Y3NQNWtCeXEySEU5WVZEdmM5RUdpVThiQ2N1VVZjUW5MeWVwOWpOTHB4NUc1?=
 =?utf-8?B?VlhWV2duWGc1NHFrRDNCTnp2SkFkVGo5T2hDR3BlWnlkendabzU1czFub21Z?=
 =?utf-8?B?R0RUckNHb01VcE9lamVweUk0RVVrWG1KVlpENVUycnNxc25lVERmUXFhTXgy?=
 =?utf-8?B?Z3RDMzFJNG9XYlZ5YlNBZGlNWXAwUVRQS0RhbktxbzJsUllJellHZ2xpdUcy?=
 =?utf-8?B?eEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AA0C693452C1D43AC48E3D54F6A38B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f4b685-4646-4abc-1f4a-08da9d904b9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 18:20:29.4964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZ7eNI4CDqliqQ8wM/RM4UM35RMhRw/De8aa1CcqhJ7gIIzQRw5HC0Es2P5dJeKgW83Pwaa/WGtfmoOaPXKL6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UmFmYWVsLCBjb3VsZCB5b3UgcGxlYXNlIGFkZCB5b3VyIHRob3VnaHRzIGhlcmU/DQoNCk9uIFRo
dSwgMjAyMi0wOS0yMiBhdCAxMjo0MCArMDAwMCwgR3VwdGEsIEFuc2h1bWFuIHdyb3RlOg0KPiAN
Cj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBHdXB0YSwgQW5z
aHVtYW4NCj4gPiBTZW50OiBUaHVyc2RheSwgU2VwdGVtYmVyIDIyLCAyMDIyIDQ6NDAgUE0NCj4g
PiBUbzogVml2aSwgUm9kcmlnbyA8cm9kcmlnby52aXZpQGludGVsLmNvbT47IFR2cnRrbyBVcnN1
bGluDQo+ID4gPHR2cnRrby51cnN1bGluQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogTmlrdWxh
LCBKYW5pIDxqYW5pLm5pa3VsYUBpbnRlbC5jb20+OyBpbnRlbC0NCj4gPiBnZnhAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnOyBEYW5pZWwNCj4gPiBKIEJsdWVtYW4gPGRhbmllbEBxdW9yYS5vcmc+OyBX
eXNvY2tpLCBSYWZhZWwgSg0KPiA+IDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT47IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTdWJqZWN0OiBSZTogW0ludGVsLWdmeF0gW1BBVENIXSBk
cm0vaTkxNTogQWxsb3cgRDMgd2hlbiB3ZSBhcmUgbm90DQo+ID4gYWN0aXZlbHkNCj4gPiBtYW5h
Z2luZyBhIGtub3duIFBDSSBkZXZpY2UuDQo+ID4gDQo+ID4gDQo+ID4gDQo+ID4gT24gOS8yMi8y
MDIyIDM6MTMgUE0sIFJvZHJpZ28gVml2aSB3cm90ZToNCj4gPiA+IE9uIFRodSwgU2VwIDIyLCAy
MDIyIGF0IDA4OjU2OjAwQU0gKzAxMDAsIFR2cnRrbyBVcnN1bGluIHdyb3RlOg0KPiA+ID4gPiAN
Cj4gPiA+ID4gT24gMjEvMDkvMjAyMiAxODozOSwgUm9kcmlnbyBWaXZpIHdyb3RlOg0KPiA+ID4g
PiA+IFRoZSBmb3JjZV9wcm9iZSBwcm90ZWN0aW9uIGFjdGl2ZWx5IGF2b2lkcyB0aGUgcHJvYmUg
b2YgaTkxNQ0KPiA+ID4gPiA+IHRvDQo+ID4gPiA+ID4gbWFuYWdlIGEgZGV2aWNlIHRoYXQgaXMg
Y3VycmVudGx5IHVuZGVyIGRldmVsb3BtZW50LiBJdCBpcyBhDQo+ID4gPiA+ID4gbmljZQ0KPiA+
ID4gPiA+IHByb3RlY3Rpb24gZm9yIGZ1dHVyZSB1c2VycyB3aGVuIGdldHRpbmcgYSBuZXcgcGxh
dGZvcm0gYnV0DQo+ID4gPiA+ID4gdXNpbmcNCj4gPiA+ID4gPiBzb21lIG9sZGVyIGtlcm5lbC4N
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiBIb3dldmVyLCB3aGVuIHdlIGF2b2lkIHRoZSBwcm9iZSB3
ZSBkb24ndCB0YWtlIGJhY2sgdGhlDQo+ID4gPiA+ID4gcmVnaXN0cmF0aW9uDQo+ID4gPiA+ID4g
b2YgdGhlIGRldmljZS4gV2UgY2Fubm90IGdpdmUgdXAgdGhlIHJlZ2lzdHJhdGlvbiBhbnl3YXkN
Cj4gPiA+ID4gPiBzaW5jZSB3ZQ0KPiA+ID4gPiA+IGNhbiBoYXZlIG11bHRpcGxlIGRldmljZXMg
cHJlc2VudC4gRm9yIGluc3RhbmNlIGFuIGludGVncmF0ZWQNCj4gPiA+ID4gPiBhbmQgYQ0KPiA+
ID4gPiA+IGRpc2NyZXRlIG9uZS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBXaGVuIHRoaXMgc2Nl
bmFyaW8gb2NjdXJzLCB0aGUgdXNlciB3aWxsIG5vdCBiZSBhYmxlIHRvDQo+ID4gPiA+ID4gY2hh
bmdlIGFueQ0KPiA+ID4gPiA+IG9mIHRoZSBydW50aW1lIHBtIGNvbmZpZ3VyYXRpb24gb2YgdGhl
IHVubWFuYWdlZCBkZXZpY2UuIFNvLA0KPiA+ID4gPiA+IGl0IHdpbGwNCj4gPiA+ID4gPiBiZSBi
bG9ja2VkIGluIEQwIHN0YXRlIHdhc3RpbmcgcG93ZXIuIFRoaXMgaXMgc3BlY2lhbGx5IGJhZA0K
PiA+ID4gPiA+IGluIHRoZQ0KPiA+ID4gPiA+IGNhc2Ugd2hlcmUgd2UgaGF2ZSBhIGRpc2NyZXRl
IHBsYXRmb3JtIGF0dGFjaGVkLCBidXQgdGhlIHVzZXINCj4gPiA+ID4gPiBpcw0KPiA+ID4gPiA+
IGFibGUgdG8gZnVsbHkgdXNlIHRoZSBpbnRlZ3JhdGVkIG9uZSBmb3IgZXZlcnl0aGluZyBlbHNl
Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNvLCBsZXQncyBwdXQgdGhlIHByb3RlY3RlZCBhbmQg
dW5tYW5hZ2VkIGRldmljZSBpbiBEMy4gU28gd2UNCj4gPiA+ID4gPiBjYW4NCj4gPiA+ID4gPiBz
YXZlIHNvbWUgcG93ZXIuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gUmVwb3J0ZWQtYnk6IERhbmll
bCBKIEJsdWVtYW4gPGRhbmllbEBxdW9yYS5vcmc+DQo+ID4gPiA+ID4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gPiA+ID4gPiBDYzogRGFuaWVsIEogQmx1ZW1hbiA8ZGFuaWVsQHF1b3Jh
Lm9yZz4NCj4gPiA+ID4gPiBDYzogVHZydGtvIFVyc3VsaW4gPHR2cnRrby51cnN1bGluQGludGVs
LmNvbT4NCj4gPiA+ID4gPiBDYzogQW5zaHVtYW4gR3VwdGEgPGFuc2h1bWFuLmd1cHRhQGludGVs
LmNvbT4NCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSb2RyaWdvIFZpdmkgPHJvZHJpZ28udml2
aUBpbnRlbC5jb20+DQo+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gwqDCoCBkcml2ZXJzL2dwdS9k
cm0vaTkxNS9pOTE1X3BjaS5jIHwgOCArKysrKysrKw0KPiA+ID4gPiA+IMKgwqAgMSBmaWxlIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X3BjaS5jDQo+ID4gPiA+ID4gYi9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pOTE1X3BjaS5jIGluZGV4DQo+ID4gPiA+ID4gNzdlN2RmMjFmNTM5Li5mYzNl
N2M2OWFmMmENCj4gPiA+ID4gPiAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9pOTE1X3BjaS5jDQo+ID4gPiA+ID4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUv
aTkxNV9wY2kuYw0KPiA+ID4gPiA+IEBAIC0yNSw2ICsyNSw3IEBADQo+ID4gPiA+ID4gwqDCoCAj
aW5jbHVkZSA8ZHJtL2RybV9jb2xvcl9tZ210Lmg+DQo+ID4gPiA+ID4gwqDCoCAjaW5jbHVkZSA8
ZHJtL2RybV9kcnYuaD4NCj4gPiA+ID4gPiDCoMKgICNpbmNsdWRlIDxkcm0vaTkxNV9wY2lpZHMu
aD4NCj4gPiA+ID4gPiArI2luY2x1ZGUgPGxpbnV4L3BtX3J1bnRpbWUuaD4NCj4gPiA+ID4gPiDC
oMKgICNpbmNsdWRlICJndC9pbnRlbF9ndF9yZWdzLmgiDQo+ID4gPiA+ID4gwqDCoCAjaW5jbHVk
ZSAiZ3QvaW50ZWxfc2FfbWVkaWEuaCINCj4gPiA+ID4gPiBAQCAtMTMwNCw2ICsxMzA1LDcgQEAg
c3RhdGljIGludCBpOTE1X3BjaV9wcm9iZShzdHJ1Y3QNCj4gPiA+ID4gPiBwY2lfZGV2ICpwZGV2
LA0KPiA+IGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICplbnQpDQo+ID4gPiA+ID4gwqDCoCB7
DQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbnRlbF9kZXZpY2VfaW5mbyAqaW50
ZWxfaW5mbyA9DQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAoc3Ry
dWN0IGludGVsX2RldmljZV9pbmZvICopIGVudC0NCj4gPiA+ID4gPiA+ZHJpdmVyX2RhdGE7DQo+
ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqa2RldiA9ICZwZGV2LT5kZXY7
DQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGludCBlcnI7DQo+ID4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoGlmIChpbnRlbF9pbmZvLT5yZXF1aXJlX2ZvcmNlX3Byb2JlICYmIEBAIC0xMzE0LDYN
Cj4gPiA+ID4gPiArMTMxNiwxMiBAQA0KPiA+ID4gPiA+IHN0YXRpYyBpbnQgaTkxNV9wY2lfcHJv
YmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdA0KPiA+ID4gPiA+IHBjaV9kZXZp
Y2VfaWQNCj4gPiAqZW50KQ0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAibW9kdWxlIHBhcmFtZXRlciBvcg0KPiA+IENPTkZJR19EUk1f
STkxNV9GT1JDRV9QUk9CRT0lMDR4IGNvbmZpZ3VyYXRpb24gb3B0aW9uLFxuIg0KPiA+ID4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAib3IgKHJl
Y29tbWVuZGVkKSBjaGVjayBmb3Iga2VybmVsDQo+ID4gPiA+ID4gdXBkYXRlcy5cbiIsDQo+ID4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBk
ZXYtPmRldmljZSwgcGRldi0+ZGV2aWNlLCBwZGV2LQ0KPiA+ID4gPiA+ID5kZXZpY2UpOw0KPiA+
ID4gPiA+ICsNCj4gPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogTGV0
J3Mgbm90IHdhc3RlIHBvd2VyIGlmIHdlIGFyZSBub3QNCj4gPiA+ID4gPiBtYW5hZ2luZyB0aGUg
ZGV2aWNlICovDQo+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBtX3J1
bnRpbWVfdXNlX2F1dG9zdXNwZW5kKGtkZXYpOw0KPiA+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBwbV9ydW50aW1lX2FsbG93KGtkZXYpOw0KPiA+ID4gPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwbV9ydW50aW1lX3B1dF9hdXRvc3VzcGVuZChrZGV2KTsN
Cj4gPiBBRkFJSyB3ZSBkb24ndCBuZWVkIHRvIGVuYWJsZSBhdXRvc3VzcGVuZCBoZXJlLA0KPiA+
IHBtX3J1bnRpbWVfcHV0X2F1dG9zdXNwZW5kKCkgd2lsbCBjYXVzZSBhIE5VTEwgcG9pbnRlciBk
ZS1yZWZlcmVuY2UNCj4gPiBhcyBpdCB3aWxsDQo+ID4gaW1tZWRpYXRlbHkgY2FsbCB0aGUgaW50
ZWxfcnVudGltZV9zdXNwZW5kKCkoYmVjYXVzZSB3ZSBoYXZlbid0DQo+ID4gY2FsbGVkIHRoZQ0K
PiA+IHBtX3J1bnRpbWVfbWFya19sYXN0X2J1c3kpIHdpdGhvdXQgaW5pdGlhbGl6aW5nIGk5MTUu
DQoNCkkgZG9uJ3Qgc2VlIGFueSBudWxsIHBvaW50ZXIgZGVyZWZlcmVuY2UgaGVyZS4NClRoZSBw
cm9ibGVtIGlzIGV4YWN0bHkgdGhhdCB3ZSBkbyB0aGUgaW5pdGlhbGl6YXRpb24gYW5kIHRoZSB3
ZSBnaXZlIHVwDQpvbiB0aGXCoA0KZGV2aWNlIGFuZCBlbmQgdXAgYmxvY2tpbmcgdGhlIHJ1bnRp
bWUgcG0gaW4gc29tZSBzdGF0ZSB0aGF0IHdlIGNhbm5vdA0KY2hhbmdlLg0KDQo+ID4gDQo+ID4g
SGF2aW5nIHNhaWQgdGhhdCB3ZSBvbmx5IG5lZWQgYmVsb3csIGluIG9yZGVyIHRvIGxldCBwY2kg
Y29yZSBrZWVwDQo+ID4gdGhlIHBjaSBkZXYgaW4NCj4gPiBEMy4NCj4gPiANCj4gPiBwbV9ydW50
aW1lX3B1dF9ub2lkbGUoKQ0KDQphcyBmb3IgdGhpcyBvbmUgaGVyZSBJIGdldDoNClsgOTAzNi4z
NTcwNzhdIGk5MTUgMDAwMDowMzowMC4wOiBSdW50aW1lIFBNIHVzYWdlIGNvdW50IHVuZGVyZmxv
dyENCg0KPiANCj4gSGkgUm9kcmlnbyAsDQo+IEl0IHNlZW1zIHBsYXlpbmcgd2l0aCB0aGVzZSBy
dW50aW1lIGhvb2tzLCB3aWxsIG9ubHkgZW5hYmxlIHRoZQ0KPiAicnVudGltZSBzdXNwZW5kIg0K
PiBidXQgYWN0dWFsIHN0YXRlIGluICJQTUNTUiIgcGNpIGNvbmZpZyBpcyBEMCBkZXNwaXRlIGRl
dmljZSBpcw0KPiBydW50aW1lIHN1c3BlbmRlZCwgd2hlbiB0aGVyZSBpcyBubyBkcml2ZXIuDQo+
IEV4YW1wbGU6DQo+IHJvb3RARFVUMjEzNS1ERzJNUkI6L2hvbWUvZ3RhIyBjYXQNCj4gL3N5cy9i
dXMvcGNpL2RldmljZXMvMDAwMFw6MDNcOjAwLjAvcG93ZXIvcnVudGltZV9zdGF0dXMNCj4gc3Vz
cGVuZGVkDQo+IHJvb3RARFVUMjEzNS1ERzJNUkI6L2hvbWUvZ3RhIyBzZXRwY2kgLXMgMDM6MDAu
MCAweGQ0LmwNCj4gMDAwMDAwMDgNCj4gKEJpdHMgMDA6MDEgYXJlIHRoZSBwb3dlciBzdGF0ZSBp
biBQTUNTUihvZmZzZXQgPSA0KSBjb25maWcgcmVnaXN0ZXINCj4gZnJvbSBQTSBDYXAgb2Zmc2V0
IGF0IDB4ZDApLg0KDQpXZWxsLCB0aGlzIGlzIGluZGVlZCBhd2t3YXJkLg0KDQpSYWZhZWwsIGRv
IHlvdSBrbm93IHdoYXQgd2UgY291bGQgYmUgbWlzc2luZyBoZXJlIHRvIGVuc3VyZSB3ZSBnZXQg
dGhlDQpwcm9wZXIgZDM/DQoNCkkgbm90aWNlZCB0aGF0IHdpdGggdGhlIGxpbnV4IHBhcmFtIHZm
aW8tcGNpLmlkcz04MDg2OjxkZzJfaWQ+IGl0IGRvZXMNCmdldCB1cyB0byB0aGUgZDMuDQoNCiMg
c2V0cGNpIC1zIDAzOjAwLjAgMHhkNC5sDQowMDAwMDEwYg0KDQpXaGlsZSB3aXRoIHRoZSBhcHBy
b2FjaCBpbiB0aGlzIHBhdGNoIG9yIHRoZSBub2lkbGUoKSBJIGFsc28gZ2V0DQp0aGUgMDAwMDAw
MDgNCg0KVGhhbmtzLA0KUm9kcmlnby4NCg0KPiANCj4gVGhhbmtzLA0KPiBBbnNodW1hbiBHdXB0
YS4NCj4gPiANCj4gPiBCciwNCj4gPiBBbnNodW1hbiBHdXB0YQ0KPiA+IA0KPiA+IA0KPiA+ID4g
PiANCj4gPiA+ID4gVGhpcyBzZXF1ZW5jZSBpcyBibGFjayBtYWdpYyB0byBtZSBzbyBjYW4ndCBy
ZWFsbHkgY29tbWVudCBvbg0KPiA+ID4gPiB0aGUgc3BlY2lmaWNzLg0KPiA+IEJ1dCBpbiBnZW5l
cmFsLCB3aGF0IEkgdGhpbmsgSSd2ZSBmaWd1cmVkIG91dCBpcywgdGhhdCB0aGUgUENJIGNvcmUN
Cj4gPiBjYWxscyBvdXIgcnVudGltZQ0KPiA+IHJlc3VtZSBjYWxsYmFjayBiZWZvcmUgcHJvYmU6
DQo+ID4gPiA+IA0KPiA+ID4gPiBsb2NhbF9wY2lfcHJvYmU6DQo+ID4gPiA+IC4uLg0KPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgIC8qDQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoCAqIFVuYm91
bmQgUENJIGRldmljZXMgYXJlIGFsd2F5cyBwdXQgaW4gRDAsDQo+ID4gPiA+IHJlZ2FyZGxlc3Mg
b2YNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgICogcnVudGltZSBQTSBzdGF0dXMuwqAgRHVy
aW5nIHByb2JlLCB0aGUgZGV2aWNlIGlzIHNldA0KPiA+ID4gPiB0bw0KPiA+ID4gPiDCoMKgwqDC
oMKgwqDCoMKgwqAgKiBhY3RpdmUgYW5kIHRoZSB1c2FnZSBjb3VudCBpcyBpbmNyZW1lbnRlZC7C
oCBJZiB0aGUNCj4gPiA+ID4gZHJpdmVyDQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoCAqIHN1
cHBvcnRzIHJ1bnRpbWUgUE0sIGl0IHNob3VsZCBjYWxsDQo+ID4gPiA+IHBtX3J1bnRpbWVfcHV0
X25vaWRsZSgpLA0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgKiBvciBhbnkgb3RoZXIgcnVu
dGltZSBQTSBoZWxwZXIgZnVuY3Rpb24NCj4gPiA+ID4gZGVjcmVtZW50aW5nIHRoZSB1c2FnZQ0K
PiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgKiBjb3VudCwgaW4gaXRzIHByb2JlIHJvdXRpbmUg
YW5kDQo+ID4gPiA+IHBtX3J1bnRpbWVfZ2V0X25vcmVzdW1lKCkgaW4NCj4gPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgICogaXRzIHJlbW92ZSByb3V0aW5lLg0KPiA+ID4gPiDCoMKgwqDCoMKgwqDC
oMKgwqAgKi8NCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCBwbV9ydW50aW1lX2dldF9zeW5jKGRl
dik7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqAgcGNpX2Rldi0+ZHJpdmVyID0gcGNpX2RydjsN
Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCByYyA9IHBjaV9kcnYtPnByb2JlKHBjaV9kZXYsIGRk
aS0+aWQpOw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgIGlmICghcmMpDQo+ID4gPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByYzsNCj4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoCBpZiAocmMgPCAwKSB7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHBjaV9kZXYtPmRyaXZlciA9IE5VTEw7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHBtX3J1bnRpbWVfcHV0X3N5bmMoZGV2KTsNCj4gPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJjOw0KPiA+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgIH0NCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IFllcywgaW4gTGludXggdGhlIGRlZmF1
bHQgaXMgRDAgZm9yIGFueSB1bm1hbmFnZWQgZGV2aWNlLiBCdXQNCj4gPiA+IHRoZW4gdGhlDQo+
ID4gPiB1c2VyIGNhbiBnbyB0aGVyZSBpbiB0aGUgc3lzZnMgYW5kIGNoYW5nZSB0aGUgcG93ZXIv
Y29udHJvbCB0bw0KPiA+ID4gJ2F1dG8nDQo+ID4gPiBhbmQgZ2V0IHRoZSBkZXZpY2UgdG8gRDMu
DQo+ID4gPiANCj4gPiA+ID4gQW5kIGlmIHByb2JlIGZhaWxzIGl0IGNhbGxzIHBtX3J1bnRpbWVf
cHV0X3N5bmMgd2hpY2gNCj4gPiA+ID4gcHJlc3VtYWJseSBkb2VzIG5vdA0KPiA+IHByb3ZpZGUg
dGhlIHN5bW1ldHJ5IHdlIG5lZWQ/DQo+ID4gPiANCj4gPiA+IFRoZSBtYWluIHByb2JsZW0gSSBz
ZWUgaXMgdGhhdCB3aGVuIHRoZSBwcm9iZSBmYWlsIGluIG91ciBjYXNlIHdlDQo+ID4gPiBkb24n
dCB1bnJlZ2lzdGVyIGFuZCBpOTE1IGlzIHN0aWxsIGxpc3RlZCBhcyBjb250cm9sbGluZyB0aGF0
DQo+ID4gPiBkZXZpY2UNCj4gPiA+IGFzIHdlIGNvdWxkIHNlZSB3aXRoIGxzcGNpIC0tbm52Lg0K
PiA+ID4gDQo+ID4gPiBBbmQgYW55IGF0dGVtcHQgdG8gY2hhbmdlIHRoZSBjb250cm9sIHRvICdh
dXRvJyBmYWlscy4gU28gd2UgYXJlDQo+ID4gPiBmb3JldmVyIHN0dWNrIGluIEQwLg0KPiA+ID4g
DQo+ID4gPiBTbywgSSByZWFsbHkgYmVsaWV2ZSBpdCBpcyBiZXR0ZXIgdG8gYnJpbmcgdGhlIGRl
dmljZSB0byBEMyB0aGVuDQo+ID4gPiBsZWF2aW5nIGl0IHRoZXJlIGJsb2NrZWQgaW4gRDAgZm9y
ZXZlci4NCj4gPiA+IA0KPiA+ID4gT3IgZm9yY2luZyB1c2VycyB0byB1c2UgYW5vdGhlciBwYXJh
bWV0ZXIgdG8gZW50aXJlbHkgYXZvaWQgaTkxNQ0KPiA+ID4gdG8NCj4gPiA+IGdldCB0aGlzIGRl
dmljZSBhdCBmaXJzdCBwbGFjZS4NCj4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gQW55d2F5IHNp
bmNlIEkgY2FuJ3QgcHJvdmlkZSBtZWFuaW5nZnVsIHJldmlldyBJJ2xsIGNvcHkgSW1yZQ0KPiA+
ID4gPiBzaW5jZSBJIHRoaW5rIGhlDQo+ID4gd29ya2VkIGluIHRoZSBhcmVhIGluIHRoZSBwYXN0
LiBKdXN0IHNvIG1vcmUgZXllcyBpcyBiZXR0ZXIuDQo+ID4gPiA+IA0KPiA+ID4gPiBSZWdhcmRz
LA0KPiA+ID4gPiANCj4gPiA+ID4gVHZydGtvDQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4g
PiArDQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVO
T0RFVjsNCj4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgfQ0KDQo=
