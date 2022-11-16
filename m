Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21A762C72A
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 19:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbiKPSDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 13:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbiKPSCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 13:02:42 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DADE627E5;
        Wed, 16 Nov 2022 10:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668621756; x=1700157756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s34ypOWc44IP4NnvNxUoSEG5Y5dcSM89oReBrMa/yxU=;
  b=mS/vVedk7W02rNFFZQn7PezefKceoUjjwhJP9rreo2rPLtBP9KKDwDRS
   i3KuI/zTPAL4BBHyQ43i5QtsTKopgwQuThM8i0kKSd9I6Utv8LptgyasB
   D3ge0cp0RpF8FmYyV6iG/9qecCwdSw9Bws1wYr8HgUn8tHvKcw5FagkUG
   /imKnBbPcZJ9NWbd+A9yGILCAVoV4Oj+SDngYY8P1VSsv6iqkqvk9gxHt
   e0EEDt+0XH7x0bafE2vR6VOApnJu9rjrilzZRu7fxftQ9N6RPgd2mx1Dt
   Pcl+RhZA8Wxsvf6ZbBebUsNsHjvCswF2h24A+sBUBBtS1OwsS7MMuscZf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339436841"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339436841"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 10:02:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="968519264"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="968519264"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 16 Nov 2022 10:02:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 10:02:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 10:02:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 10:02:35 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 10:02:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nk27P0ku7Rs2ZlEXjjIqJErhOK1FiU81PfslRsUsACBOL8PpcAn7Tan6Fh1dW7DNUZKOtqPp0chfHj4yvkGrgGOXnfk2AXfvt8wlfabdM1RDyTWtusy6SR7pPeQGHhZ2NmY7nm+uLdQ16P6itrWtRCGfC4iigb1yr5deg/QbLp+C2FKX5/xV2yiv76uHdsTYqB1nVC8kNK2uFJqJ/rgtyHPx3HbJVV8rjTntQ0HABY5TPMGCVLiL+58xOAmo34r++D/o1CkkZx9SVTuWBA3SCKB2Ajl85FfEO1FbKFJwyaobOo6y6j5uo9n0GIozPUpfjvaJgyRsxJSU7tQJU6MCww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s34ypOWc44IP4NnvNxUoSEG5Y5dcSM89oReBrMa/yxU=;
 b=MQv63FK1IIvkMgk0WxY+VEhvWhxpZJmOBKQAHi+nuXYhyyakXOaEEntUxZJudQ3bDh/vkhF6AOBTu6wIJj4MoiOigA5mza7+Z392QgO/AhypAT1veM5qvW/+BxfLEBx8/28m0MrgO9BXMQLEJJJu0j+e91wt9wWUm63UFuGfoYaAaZ/FGBZcrTxpsQHdX3EvGV2aLOnr2U+hVQ/PDKjAc3v1ac5UxkJPlnRier40/fPuoY4yXBtqnWRz74Kib7QvugzupVG86XNmjDb9KBx+cotFKN7koRttnYotaBoeMBog7uXgljHhpgh/cAIy5MoyHbPuyqS4hibmnOVlZxw0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by IA0PR11MB7332.namprd11.prod.outlook.com (2603:10b6:208:434::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 18:02:33 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 18:02:33 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "kirill@shutemov.name" <kirill@shutemov.name>
CC:     "Piper, Chris D" <chris.d.piper@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "liushixin2@huawei.com" <liushixin2@huawei.com>
Subject: Re: [PATCH 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Thread-Topic: [PATCH 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Thread-Index: AQHY+ZEjfknpBsstC0GhyFfrZfqvSq5Bf8gAgABYRoA=
Date:   Wed, 16 Nov 2022 18:02:32 +0000
Message-ID: <b29163f4e39d28c3656b468a52a63b34073cb933.camel@intel.com>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
         <20221116075736.1909690-3-vishal.l.verma@intel.com>
         <20221116124634.nlvnsirdnlafdfeh@box.shutemov.name>
In-Reply-To: <20221116124634.nlvnsirdnlafdfeh@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|IA0PR11MB7332:EE_
x-ms-office365-filtering-correlation-id: b4aceb79-94f1-48e4-0f0a-08dac7fcbc4d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h8EC9IR83Oi8H5KzkausFaTd6h84ljA8YnPoxbhwngl/W1I7rLh7eDoD+K0mAXvSLF1tnp7EA7IxBiTAmvf4ZhnPiF5/R+02ay1XRYw4LnS68w9Yd/fB/85VkUK3Ay3VZKnzMGsHRQJUyOc6qfp5nqGMyBotEjJvZk0EZgelkZqyJltPxf6gAc4JE2kEagO6j+BZ9bXLv1vFErj6hPBi1Ouu0OR6pGhFUhnwbJSVmZW7fb9E4xHJnTiNqxjhGh4O0xrzcBJf5/2cL9A8s+NKijCa6p/3rfiL+ZdaBH6fx2kybmqRiB+Hk2qQN5/brDb7/trsXTm6mC7oFPHTtVUKZM7ERY6ecJvvW1ecQmua/4o0QBjlxVjDDopF++9DqKOUbRyWVbG1xdXNx1fjI2piCnH3WMPncRORUcghH4nDdux/1bD3pUfOfaUSegGgR4I0vF19RiMg4tRVn2N2MtoPT9GLZRetc2lAFvU73B6K9cEwokJyU5TpcPbuEpTWKKxVvgOjPb7yi5/eEGZpKVwhrUyiDf0JTCkQywzNSoMiSuU0uKt+7bJCWiSujuNhMJjdk07aGKtV39OzWR40efFZ/D7pyRhVOJfO4SqnJEZ3pV+xPO//YmYqCnY91Pgvu/36nNVVmHV+VZhmRwN6FdVeNCcYiOaGUIfSepWL8nmcbyFyaoJY645gCIsJud8bs8QEpv88bhAHRib15rR/W6cvDq9anAUzhwgbE3H0uYDP4AD4mHqBXAK2ViIc/uBBnc25ap2XiK+PGhfqfAZnNetv4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(86362001)(76116006)(316002)(91956017)(4001150100001)(8676002)(2906002)(66556008)(6916009)(6512007)(66946007)(54906003)(64756008)(4326008)(66476007)(66446008)(36756003)(2616005)(41300700001)(5660300002)(71200400001)(186003)(83380400001)(82960400001)(122000001)(38100700002)(8936002)(26005)(6506007)(478600001)(6486002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NURLemc0UmJDbXpvV084eVhoOUJMVXc5cXpsbzhya1czSC8rVWQ4VlJzTzBV?=
 =?utf-8?B?OFI5bk9JOEtDcWI1QUNJY1NOYU9KMFErdWRYRFY5QlFiRkt6M2lyZHppOEh3?=
 =?utf-8?B?UHU0Z1F6bmZQalptODNmYlkxOXZkVmcxaUhraTFvMGd3V0tJVHl6VnRsYmNF?=
 =?utf-8?B?NEtkMGQrTU9ueXk5SDlodmg3b0Z6MW0yK2lUOXdhVUZPRWRZalBraXdMc0ZR?=
 =?utf-8?B?VmxLUTFnbm9yRk9rMUs5MVpPM01obTYyMWhFVWxKQWhieHIySnBlWE4rRjlT?=
 =?utf-8?B?ZDNXV2xGTTRibzZLaG4zcGNWQzRvbGthV2laOXFsbGxobW0xWUlOVTlHRTdl?=
 =?utf-8?B?cDdpTjk1WXhvNC9rdVRobkxqR3VMeWVaS2tIbkpxUnBzcWJJZ1JtZjNwUU1i?=
 =?utf-8?B?QlU4VGxWaFNSQXJjNTFaU0hPQnp3QnNVYjd2WmcwZThxY3Rsb0VEYTlERGVC?=
 =?utf-8?B?V2RBU3R4RjZOK0FqUXp6MG8zeEhydGtIejRKYVNXNG9PbTVBYTNSUWdvYUI4?=
 =?utf-8?B?cFI5K3VwbEN5TmRRMFZ5c05RZ1BuSlZQTjFEaHFUWHJKK3FKMHA4MmN3QXFC?=
 =?utf-8?B?Q2VkczhBUnI2b3pLdEdQaDZTaGxJRDM0ZGNyMzlCeHREOEVaZjlibWJhRG1v?=
 =?utf-8?B?eXdlbzljSnk5NzV1QUUybWppKzRiWnRoZnpHUEtTbFNYV25hNVNYcmt1Mmps?=
 =?utf-8?B?UWhIN3BUaFZwcmNPdGNkQWxJT1RmU2xHUlE2NzN3YXE2YkJkVU02SFdCREN3?=
 =?utf-8?B?NG9OUzJCajVucTZOZmE1bGxET042ZGJJakZ4Rm5EYnNwQk1rdHFUNloza09q?=
 =?utf-8?B?Zy9zWHd3a0ozRVhhdmUzeXBIcCtsMmEwMFpZWktVSUIrTnRGeTBwdDc3NkND?=
 =?utf-8?B?ZzNOY0VrTnAvRkhzMk0ydW0zVU5IaDI0dGVrZmd6U01hZkUxeHFlVm9XVjBk?=
 =?utf-8?B?SEpKeWZFUkhWS2d6OXJrWW5BODZFZ3REVW5HVWs3dHVUbmsvdFJjMjdYV0l1?=
 =?utf-8?B?dG4zMDE0cG80dHNwYW0rYUUyWmZ6dVdhU2k2MVhtZXJ1YzY4N1libFpiN1NN?=
 =?utf-8?B?UFR6UWFmSlZvSmQ1djBVTW1XdE5LY3FOekdGSTNyd0wyeWZ2UHNDaFVNSHRx?=
 =?utf-8?B?Ulp2ZVVtRG94RGZDS01JcFZBVXM0NTBqTkJvZWhJc0t1VERtMUtCdDNzdkww?=
 =?utf-8?B?SitGS0pISVZwa3BDeG5XZlpjb0tUL3preHF6ZWYxNm5nQ1Y2emgrQ25HeFda?=
 =?utf-8?B?UWYwNzd5ZVkxZEYwRm5VdEo2YUNNWnBVOTBOTy9RRGpramdDdGN1THN1ekpx?=
 =?utf-8?B?TEVGc3N3dXdneVlJQTJsV0lMb1hndGIwSW8zVG8rZTVCejcwb2dMckRHZnBM?=
 =?utf-8?B?TEZvaXNYOUdBRk82Y3dHSXNScG9TdTk4ZnBHbkpxVjhDNVlEc3JsWmNadEo5?=
 =?utf-8?B?ajBGQzY4bzErTlljbFppaGFvWml5dExWSHZHVUM5K0NwUG54QmNhVFppcTVM?=
 =?utf-8?B?UlFxRTVTOVJGZzROQ01nYVU3MlVBZlhHaXovb0xPZHkvaDBCT2lzS0ZnWFRE?=
 =?utf-8?B?TElhTFF6TENIRVdxVGw2UWR3UHJ5b2dqNDJmM1E2Z09zM3VMU0VNQ0JCL09z?=
 =?utf-8?B?M01FWThJT2w0ejFkSjEwUEJuaS9ZQUhqaG44NlJWNW4xdEtPQlRIWEFlTUJ1?=
 =?utf-8?B?ZnRxZ1dadzRyUXhqdFh3WHBrQjB3bTh1aS80V1plR2pOUXhlc21DckNwM3pH?=
 =?utf-8?B?bGhqdngvekVsenM2SmF4T1kzODVSK3ExS01xTlgwY1VCODlFeElnRUtrR3RT?=
 =?utf-8?B?UldjVnFLUngrYXdTaFlyN1c4L0o1bTFIN09wd2ROVmdEc21JazVzZGZLSXY1?=
 =?utf-8?B?VExEMzc2YkNlVlBsS0IvMWorL00rSE1lRjI2NUhHbG1vZWhXNGhHbThlZjVw?=
 =?utf-8?B?eHZMbGc0emNCQ2VTMllqQS81Qy9TN0tJS2gzamQ5Q0xWWTFyQUd4TEhwTkVH?=
 =?utf-8?B?S1RXc3FnV2JIWmtxUVVzelJlNFlWRXE2ZFJqUEU1ZVIvQzBLdWJ4NS9COGsv?=
 =?utf-8?B?S1ZlS0FMejl1aVowNHZ1WmZlczEwaCtkKzR2a0lDaXBCS01iUUJ3N05UU1RU?=
 =?utf-8?B?SUM5UHZBV0NLaDh5TEpUVkVEeEgrM1JuQUVzWkRYL2pqb0pwcUtoM05kdC9m?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5B90EEAE27AE44FBA9E49AFDAEBD89C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4aceb79-94f1-48e4-0f0a-08dac7fcbc4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 18:02:33.0574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H00nYTyO3IcU/zFQXn7ZKCPK/sR0de1SeHdCAEQxibSFYyY4UxMLUqDn4yCP3NU7JFTt8EJAvPoxczrAkhZ32TVvPhNf+ZVho6/Iv/i2K0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7332
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTE2IGF0IDE1OjQ2ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIFdlZCwgTm92IDE2LCAyMDIyIGF0IDEyOjU3OjM2QU0gLTA3MDAsIFZpc2hhbCBW
ZXJtYSB3cm90ZToNCj4gPiBJbiBhIHN5c3RlbSB3aXRoIGEgc2luZ2xlIGluaXRpYXRvciBub2Rl
LCBhbmQgb25lIG9yIG1vcmUgbWVtb3J5LW9ubHkNCj4gPiAndGFyZ2V0JyBub2RlcywgdGhlIG1l
bW9yeS1vbmx5IG5vZGUocykgd291bGQgZmFpbCB0byByZWdpc3RlciB0aGVpcg0KPiA+IGluaXRp
YXRvciBub2RlIGNvcnJlY3RseS4gaS5lLiBpbiBzeXNmczoNCj4gPiANCj4gPiDCoCAjIGxzIC9z
eXMvZGV2aWNlcy9zeXN0ZW0vbm9kZS9ub2RlMC9hY2Nlc3MwL3RhcmdldHMvDQo+ID4gwqAgbm9k
ZTANCj4gPiANCj4gPiBXaGVyZSBhcyB0aGUgY29ycmVjdCBiZWhhdmlvciBzaG91bGQgYmU6DQo+
ID4gDQo+ID4gwqAgIyBscyAvc3lzL2RldmljZXMvc3lzdGVtL25vZGUvbm9kZTAvYWNjZXNzMC90
YXJnZXRzLw0KPiA+IMKgIG5vZGUwIG5vZGUxDQo+ID4gDQo+ID4gVGhpcyBoYXBwZW5lZCBiZWNh
dXNlIGhtYXRfcmVnaXN0ZXJfdGFyZ2V0X2luaXRpYXRvcnMoKSB1c2VzIGxpc3Rfc29ydCgpDQo+
ID4gdG8gc29ydCB0aGUgaW5pdGlhdG9yIGxpc3QsIGJ1dCB0aGUgc29ydCBjb21wYXJpc2lvbiBm
dW5jdGlvbg0KPiA+IChpbml0aWF0b3JfY21wKCkpIGlzIG92ZXJsb2FkZWQgdG8gYWxzbyBzZXQg
dGhlIG5vZGUgbWFzaydzIGJpdHMuDQo+ID4gDQo+ID4gSW4gYSBzeXN0ZW0gd2l0aCBhIHNpbmds
ZSBpbml0aWF0b3IsIHRoZSBsaXN0IGlzIHNpbmd1bGFyLCBhbmQgbGlzdF9zb3J0DQo+ID4gZWxp
ZGVzIHRoZSBjb21wYXJpc2lvbiBoZWxwZXIgY2FsbC4gVGh1cyB0aGUgbm9kZSBtYXNrIG5ldmVy
IGdldHMgc2V0LA0KPiA+IGFuZCB0aGUgc3Vic2VxdWVudCBzZWFyY2ggZm9yIHRoZSBiZXN0IGlu
aXRpYXRvciBjb21lcyB1cCBlbXB0eS4NCj4gPiANCj4gPiBBZGQgYSBuZXcgaGVscGVyIHRvIHNv
cnQgdGhlIGluaXRpYXRvciBsaXN0LCBhbmQgaGFuZGxlIHRoZSBzaW5ndWxhcg0KPiA+IGxpc3Qg
Y29ybmVyIGNhc2UgYnkgc2V0dGluZyB0aGUgbm9kZSBtYXNrIGZvciB0aGF0IGV4cGxpY2l0bHku
DQo+ID4gDQo+ID4gUmVwb3J0ZWQtYnk6IENocmlzIFBpcGVyIDxjaHJpcy5kLnBpcGVyQGludGVs
LmNvbT4NCj4gPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4gQ2M6IFJhZmFlbCBK
LiBXeXNvY2tpIDxyYWZhZWxAa2VybmVsLm9yZz4NCj4gPiBDYzogTGl1IFNoaXhpbiA8bGl1c2hp
eGluMkBodWF3ZWkuY29tPg0KPiA+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGlu
dGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1h
QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMvYWNwaS9udW1hL2htYXQuYyB8IDMy
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwg
MzAgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9hY3BpL251bWEvaG1hdC5jIGIvZHJpdmVycy9hY3BpL251bWEvaG1hdC5jDQo+ID4g
aW5kZXggMTQ0YTg0ZjQyOWVkLi5jZDIwYjBlOWNkZmEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9hY3BpL251bWEvaG1hdC5jDQo+ID4gKysrIGIvZHJpdmVycy9hY3BpL251bWEvaG1hdC5jDQo+
ID4gQEAgLTU3Myw2ICs1NzMsMzAgQEAgc3RhdGljIGludCBpbml0aWF0b3JfY21wKHZvaWQgKnBy
aXYsIGNvbnN0IHN0cnVjdCBsaXN0X2hlYWQgKmEsDQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVy
biBpYS0+cHJvY2Vzc29yX3B4bSAtIGliLT5wcm9jZXNzb3JfcHhtOw0KPiA+IMKgfQ0KPiA+IMKg
DQo+ID4gK3N0YXRpYyBpbnQgaW5pdGlhdG9yc190b19ub2RlbWFzayh1bnNpZ25lZCBsb25nICpw
X25vZGVzKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoMKgLyoNCj4gPiArwqDCoMKgwqDCoMKg
wqAgKiBsaXN0X3NvcnQgZG9lc24ndCBjYWxsIEBjbXAgKGluaXRpYXRvcl9jbXApIGZvciAwIG9y
IDEgc2l6ZWQgbGlzdHMuDQo+ID4gK8KgwqDCoMKgwqDCoMKgICogRm9yIGEgc2luZ2xlLWluaXRp
YXRvciBzeXN0ZW0gd2l0aCBvdGhlciBtZW1vcnktb25seSBub2RlcywgdGhpcw0KPiA+ICvCoMKg
wqDCoMKgwqDCoCAqIG1lYW5zIGFuIGVtcHR5IHBfbm9kZXMgbWFzaywgc2luY2UgdGhhdCBpcyBz
ZXQgYnkgaW5pdGlhdG9yX2NtcCgpLg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIFNwZWNpYWwgY2Fz
ZSB0aGUgc2luZ3VsYXIgbGlzdCwgYW5kIG1ha2Ugc3VyZSB0aGUgbm9kZSBtYXNrIGdldHMgc2V0
DQo+ID4gK8KgwqDCoMKgwqDCoMKgICogYXBwcm9wcmlhdGVseS4NCj4gPiArwqDCoMKgwqDCoMKg
wqAgKi8NCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAobGlzdF9lbXB0eSgmaW5pdGlhdG9ycykpDQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5YSU87DQo+ID4gKw0K
PiA+ICvCoMKgwqDCoMKgwqDCoGlmIChsaXN0X2lzX3Npbmd1bGFyKCZpbml0aWF0b3JzKSkgew0K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbWVtb3J5X2luaXRpYXRv
ciAqaW5pdGlhdG9yID0gbGlzdF9maXJzdF9lbnRyeSgNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCZpbml0aWF0b3JzLCBzdHJ1Y3QgbWVtb3J5X2lu
aXRpYXRvciwgbm9kZSk7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBzZXRfYml0KGluaXRpYXRvci0+cHJvY2Vzc29yX3B4bSwgcF9ub2Rlcyk7DQo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiA+ICvCoMKgwqDCoMKgwqDCoH0N
Cj4gPiArDQo+ID4gK8KgwqDCoMKgwqDCoMKgbGlzdF9zb3J0KHBfbm9kZXMsICZpbml0aWF0b3Jz
LCBpbml0aWF0b3JfY21wKTsNCj4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gPiArfQ0K
PiA+ICsNCj4gDQo+IEhtLiBJIHRoaW5rIGl0IGluZGljYXRlcyB0aGF0IHRoZXNlIHNldF9iaXQo
KXMgZG8gbm90IGJlbG9uZyB0bw0KPiBpbml0aWF0b3JfY21wKCkuDQo+IA0KPiBNYXliZSByZW1v
dmUgYm90aCBzZXRfYml0KCkgZnJvbSB0aGUgY29tcGFyZSBoZWxwZXIgYW5kIHdhbGsgdGhlIGxp
c3QNCj4gc2VwYXJhdGVseSB0byBpbml0aWFsaXplIHRoZSBub2RlIG1hc2s/IEkgdGhpbmsgaXQg
d2lsbCBiZSBlYXNpZXIgdG8NCj4gZm9sbG93Lg0KDQoNClllcyAtIEkgdGh1b2dodCBhYm91dCB0
aGlzLCBidXQgd2VudCB3aXRoIHRoZSBzZWVtaW5nbHkgbGVzcyBpbnRydXNpdmUNCmNoYW5nZS4g
SSBjYW4gc2VuZCBhIHYyIHdoaWNoIHNlcGFyYXRlcyBvdXQgdGhlIHNldF9iaXQoKXMuIEkgYWdy
ZWUNCnRoYXQncyBjbGVhbmVyIGFuZCBlYXNpZXIgdG8gZm9sbG93IHRoYW4gb3ZlcmxvYWRpbmcg
aW5pdGlhdG9yX2NtcCgpLg0K
