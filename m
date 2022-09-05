Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF54E5ACD20
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 09:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiIEHvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 03:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbiIEHui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 03:50:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E362015739;
        Mon,  5 Sep 2022 00:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662364236; x=1693900236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=841ec55ptevrMtc5NhqZgJGIZHBt99KLas3FXTaEA3w=;
  b=jL2YR05ldSIuRM2qnmnUJrG8i9a12Gp2ORHGxBiHLh9cBT2VucOK4g/B
   i7Kvyv7+/FDCK54gelEEkvdyjau8MyBg5WCyXjbHek95riq4AA7pHG2Zz
   5Zd2NOaop/ANjccIn5qTC3bCBAAZaJ9DqFnVTWMUTBEHXlOD85XhWrZWj
   iMFfA2z/gmtNnLIBOSHTvkZsJ62cEWZT6pjI0KO2/Kea7GFAlzwtrYw0I
   x2LWSrdQ/sVD+U/yLVlGBQ8609AEUdL4b4PLluYBnTofrh2ckQkW0DeeF
   /ZDuSPq6k6LrNAeaMp7rUoHGc6rJysDSaKXrr4vKoSbRt4sXkAjkaaN7e
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="382630853"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="382630853"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 00:50:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="564663580"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 05 Sep 2022 00:50:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 00:50:35 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 00:50:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 5 Sep 2022 00:50:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 5 Sep 2022 00:50:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blMB5UVPzOZFRCOOZcKDT04hMYdvn+bujyU8JvY5QwSPuXEEtCxJBmsGSED3mntGJlFyY8/hCr+YkmtiWsrnH3iRM7PgVWLGA3iLL5qEescUpyC3OsYUTKnGxXRxGs0s2upIvAuEpTnLhjpneWde57FmJJMyUZ1c1Lt6yh0JYSdLgAEc0aTRFgEeWj/Vt9nwfOME5R4h8bpT6AQ5zGKm4CjYZyu0eb2qm+2lkoclLZBwkhfpHEY7rNXJWbHthqYOeyCLTvRFrlqqkdvP8I7dk1CVa79UxX/giXCkvM7TqRrBw5oeVQDgQruZYzv3PfF/CGiXg+Gsv9NfVTQp5ChMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=841ec55ptevrMtc5NhqZgJGIZHBt99KLas3FXTaEA3w=;
 b=P09ETx67hvZWAVpS0sd7+xx2IL9jV7ZPd27ExIStcWLP+99NW1s32BQyXrCMRHIUGtkGZjh/edejRS0/AgaR73YW7I+C8aYi2Dnyk0K9j/Aa/TV8z4IUJjEYXC29SA86/nC1TQwpt4Ry9m9FpOikuEmn/Xd7KfImUTU5ofo+BuwLYFoEeN6FswIQOmyYweIyn2oCaKWx1LSNNtGC3gpBbFNFSUOSw11G+5lDPVbeFPQszvg04N+3aCT+xgiPQLMQ++NvfJa9A3HuxHPcxDjcIHUn0I6ULlqKsXbnOL/t7h2dC/gz955OGDBJuY38V8rWQfhDBmJLSqbQdELTInRVsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5338.namprd11.prod.outlook.com (2603:10b6:408:137::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 07:50:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%9]) with mapi id 15.20.5588.015; Mon, 5 Sep 2022
 07:50:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Thread-Topic: [PATCH 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Thread-Index: AQHYv1qxZ7TsJ3OH1Um94+aMAhZwvq3NgKoAgAL4+QA=
Date:   Mon, 5 Sep 2022 07:50:33 +0000
Message-ID: <a5fa56bdc57d6472a306bd8d795afc674b724538.camel@intel.com>
References: <20220903060108.1709739-1-jarkko@kernel.org>
         <20220903060108.1709739-2-jarkko@kernel.org> <YxMr7hIXsNcWAiN5@kernel.org>
In-Reply-To: <YxMr7hIXsNcWAiN5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c840ac4-dad6-47ed-cb2a-08da8f134fbe
x-ms-traffictypediagnostic: BN9PR11MB5338:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0EgbPAz6ctak2wSIRaRk8gEFVfM3z4CulR5nfW3YQqnLZrKuTdIkyGOzWG4P7PhmSFY534fM4h/UaM3jXNq+TlTJWWkqvAk11m/7DjECHcYxJsZyxQ2QabzK3ixM8mnf6l6xuXcZlhEwbuC3EDXgrRRw4pE6Po3ncEIujWOAPVKcyUQNUgJfdQVnZ6W+lq8pJeJ9dYrIPB5pKlGTbPDkSobMw3amQJq8lfsj3IcvpwKsqSXWyH1/uabSA+807vDApa5zfzx6UpZYMTzmpsBUczwB9OpBFB8Wmpconh3Z4m2uyJiEKx9ZtpOPnt8KwBjBQZsisq9ZzlCCVrOc2F+KV9yWexKxx5mzMv9TdOApMc+Rpsep1KStXDDZfC4p2R9UnCHEVBzmWx53x7Rfbjqr29cEQWPZjk2g+uf9rOZvXc5rilwzvzWE2lugkxzJ/hMXCIk9LJblL4+qrPVupLj0SxQydE12p+CXqoZFX+jvsaHOBcNa2VnB4PdBL9mUJAb08HIhTBjmHY+JSlFR/ZfQw/6WftLX+8Bx/dG2lVa201i7XDI6ydpCqWLtXy2x7zdsqJAoXx57iNP2ymuJ1Fmb5d9UfloEgBbhZ3awn+kwkqUFD0E9wDdsDagrie5eMMqkKHVKFqBF1ueFZN5wy1PkICF083u55nIoN4LmmbqWuKw+wzym6Wmp1iPglcpa7n4LjzhIrwffNvPi71zsVYllL7fME8kEdLXcINLdk+JtB/qYiNM1iEToOOUnEpWXyyHTnu8bx3b+x2HUAd/LenfN2NHFJqjZSzJuxT9Oq1ex4lM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(366004)(376002)(136003)(396003)(82960400001)(38070700005)(38100700002)(122000001)(4326008)(91956017)(8676002)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(110136005)(54906003)(316002)(478600001)(2906002)(5660300002)(8936002)(26005)(6512007)(7416002)(83380400001)(2616005)(186003)(71200400001)(6486002)(41300700001)(6506007)(86362001)(36756003)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVZiajZFQ2dYa1ZNM0Z3VU9IdkRxVGxqU2wraFg4OGJza0hET2t0VjUwMWpy?=
 =?utf-8?B?L0l0dkVmaS9oelBBV0NlQythWW12cnJCMWwwRFErdjd3cWc4NUtOVnV4bHMy?=
 =?utf-8?B?MGZsTk4zL05yNWNkVnZIU1FoTU9xQnNWc3lyK0E4azdKVlNXRmFiYzd4RTA4?=
 =?utf-8?B?TFM0eVJULzVwb2FGZWlnL1VqSlVLQ1Q5ZWw0UTdQN05aaTNlaU4vYmdoczlk?=
 =?utf-8?B?ZklBS3ZtVlgvRkx6U0dUR1dBdmNpdjhnaG96bXBBdlhGODV1WE9JdlE1NkNM?=
 =?utf-8?B?Q1FpQllibytHMVpUek4zTVpjLzltMnhlVnlaS3NRR0w1Y1RLWHozYXJsbGlP?=
 =?utf-8?B?ZS90QmlDUmlONU00MjN6S2NkbTFQb0dTRFBteC9DUlYyV1dBM3VOWGxzc3FC?=
 =?utf-8?B?eEJHNThRdFdvc0VwVzBYR280TWt2V00xWUU4dVVJUEdsRDgvbVdOM3crSmVY?=
 =?utf-8?B?OWQrYmhvM2RTelZ4N3FDVnpYN1dXK3JCZEhidDlyMXV2NWpQdkZPeTFuY0RC?=
 =?utf-8?B?VzRPVVVhLzl1dUY0V05GMGFCa3RwcXZPQlpRcmhtYXFqLzUyZ2MwY2hHS3BM?=
 =?utf-8?B?c3dMa05aWGdZY2xHT2RqR0RzU0VSQVNXbGNGbXRQWWN3aWUyVGxRcUlHUFRH?=
 =?utf-8?B?bVNPc2xaZFA3dVgzNC9TbHVUZlRvTGVjRTVyRFl5c0xBL2hGWmFXVWZpSGRO?=
 =?utf-8?B?aE1Jb2ZPZTZpbk12cHlzY2Z0VnJ4Q0I2L1NCN0pwc200SGdINDljVU91Nnkz?=
 =?utf-8?B?eFV4MDc2VlRvOUN5bFNTSTJBQzdjNjRMcnF5N3dlMmp2Y3EzRVZsdXM5YURl?=
 =?utf-8?B?cUJrOTZtOUJ0Uk9SSWxLUkk0SWFGd21VcjgyQ2k5NDBQTjJoR2NsSmFDVnNW?=
 =?utf-8?B?NUdDWk82Y2RrNVZrOHRpM29DWm11NmwzZmhZYVIzcG1Lb3BWS3NSREFqVzli?=
 =?utf-8?B?b3NnSENxelYvL0p0Y0tZNy9tR1hGbGFvMVdCeW1YMzdWMERWaHRnYU55TFJm?=
 =?utf-8?B?bnZtTE5HcUhpbmVXUVgxTXZlaC9raVkxLzRZZUxGQWRrTWU4RkNsazhZNmpl?=
 =?utf-8?B?R1BnODZGc2k5Tm9OUGYwR1NqdG5ENXdIYWRjR1RteVlOa0dPUzB5Tkl6Z3Y3?=
 =?utf-8?B?ZXB1Z3NIWjh4RFpPRzNaUkRQcGVpTjZjN3N4VXBUUHU1V3hzWE1pYmtVWldr?=
 =?utf-8?B?U2J0MmtJdGY5MmY3c1dyMU4zVjR5Vk1JcUxLSFVBVnZaLytuQlF0ZDY1SDNp?=
 =?utf-8?B?U1ZnRGV6M0NLanlidzJYc3g1UmhTQkRVbUZPeGV0b2JqS0NXeVd5dkR3a0FC?=
 =?utf-8?B?Q3VxZ2dNREEyVVRPWGNGc1VMeVQ5anZ1eHZOSytjdEhIZ3pGejZVMjY5eno2?=
 =?utf-8?B?Y3hxd3N0QWhnSjRFaTEvaDU3dVNrbU9JOGdnbjh3cklaczlGc2E0TjJ1WjNt?=
 =?utf-8?B?RndoMXRZNHBOM29FU1k5VlFwZ1ovZ3lpVG02emtXc3BEa2xEazFDUDdhdGk5?=
 =?utf-8?B?N1FTa2FoMWdUUWdYSTZyUkZPVFZOTGlaVVhtRm5OUUprS2NFUnZYQUVjdGxj?=
 =?utf-8?B?M2d5ZkZYOC9Gd3RmWTQwRFBtamJmcUw3MFlLcFNoZjVoZTd2Q29rcExVYk1r?=
 =?utf-8?B?V2tTa2swRTFmK3JCV0Q5d0FnY1MwOU1iMmNPQ3pvYXUxYkQyLytsbTdSUEVs?=
 =?utf-8?B?MXNBWURNUmVxaHFuejZGekc2Q21qZHNqUktOSHhKNGNnOW5kRGdBMnk5TEli?=
 =?utf-8?B?Nk5ObzFYS3IzN2JoWHdsaHNOZFpubjBSYjJ4VGp4OU5wdmJ3T1hqTFpIOHJm?=
 =?utf-8?B?TzQwdW1ib1RFQ2UxS3N1UWg3ZDVwSDBEVFB0UnZIdFFkYTZEWTRWQU5NTW1a?=
 =?utf-8?B?R2FSRkpFdCtvWFgrRk9kTWRqUkR3YUJJNUczc2lTSE01OVR4cjZwSlZ1WjM3?=
 =?utf-8?B?WklmSk9pZXdSNVhvMTVmUHhqOWlPR0VsOUV1N1hxT1l4RndTdElMS0w1Ym5s?=
 =?utf-8?B?aWphVS9Eb3hmbVo1Y2Q4SmNDUGpCaUNrOElUdzJlQ0ZXN0ExdVcxNXRqNDFY?=
 =?utf-8?B?dVEzMW9WSHVGTHpNSUU4M1FGNFU0Q3Z3UmFLRjdnVlJmNUR6NFRabkE1dkRy?=
 =?utf-8?B?cFUvNVJUbWxoWGVUNUZpejVaUHpNRUhRdW90d2hHV08yaVY1bjJzTzFNTVZM?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAF3F0399949C741B0895C1A88FC4AC9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c840ac4-dad6-47ed-cb2a-08da8f134fbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 07:50:33.0776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c5cN/93GaqKEBjkFcFPUaBHRJe9WLrWO5nGQYQ99431freqtHhTFZwtoaaMd7LgucE+BYVGbxcEryZJ91z1BOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5338
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCAyMDIyLTA5LTAzIGF0IDEzOjI2ICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+ID4gwqAgc3RhdGljIGludCBrc2d4ZCh2b2lkICpwKQ0KPiA+IMKgIHsNCj4gPiArCXVuc2ln
bmVkIGxvbmcgbGVmdF9kaXJ0eTsNCj4gPiArDQo+ID4gwqDCoAlzZXRfZnJlZXphYmxlKCk7DQo+
ID4gwqAgDQo+ID4gwqDCoAkvKg0KPiA+IMKgwqAJICogU2FuaXRpemUgcGFnZXMgaW4gb3JkZXIg
dG8gcmVjb3ZlciBmcm9tIGtleGVjKCkuIFRoZSAybmQgcGFzcyBpcw0KPiA+IMKgwqAJICogcmVx
dWlyZWQgZm9yIFNFQ1MgcGFnZXMsIHdob3NlIGNoaWxkIHBhZ2VzIGJsb2NrZWQgRVJFTU9WRS4N
Cj4gPiDCoMKgCSAqLw0KPiA+IC0JX19zZ3hfc2FuaXRpemVfcGFnZXMoJnNneF9kaXJ0eV9wYWdl
X2xpc3QpOw0KPiA+IC0JX19zZ3hfc2FuaXRpemVfcGFnZXMoJnNneF9kaXJ0eV9wYWdlX2xpc3Qp
Ow0KPiA+ICsJbGVmdF9kaXJ0eSA9IF9fc2d4X3Nhbml0aXplX3BhZ2VzKCZzZ3hfZGlydHlfcGFn
ZV9saXN0KTsNCj4gPiArCXByX2RlYnVnKCIlbGQgdW5zYW5pdGl6ZWQgcGFnZXNcbiIsIGxlZnRf
ZGlydHkpOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICVsdQ0KPiANCg0K
SSBhc3N1bWUgdGhlIGludGVudGlvbiBpcyB0byBwcmludCBvdXQgdGhlIHVuc2FuaXRpemVkIFNF
Q1MgcGFnZXMsIGJ1dCB3aGF0IGlzDQp0aGUgdmFsdWUgb2YgcHJpbnRpbmcgaXQ/IFRvIG1lIGl0
IGRvZXNuJ3QgcHJvdmlkZSBhbnkgdXNlZnVsIGluZm9ybWF0aW9uLCBldmVuDQpmb3IgZGVidWcu
DQoNCkJlc2lkZXMsIHRoZSBmaXJzdCBjYWxsIG9mIF9fc2d4X3Nhbml0aXplX3BhZ2VzKCkgY2Fu
IHJldHVybiAwLCBkdWUgdG8gZWl0aGVyDQprdGhyZWFkX3Nob3VsZF9zdG9wKCkgYmVpbmcgdHJ1
ZSwgb3IgYWxsIEVQQyBwYWdlcyBhcmUgRVJFTU9WRUQgc3VjY2Vzc2Z1bGx5LiANClNvIGluIHRo
aXMgY2FzZSBrZXJuZWwgd2lsbCBwcmludCBvdXQgIjAgdW5zYW5pdGl6ZWQgcGFnZXNcbiIsIHdo
aWNoIGRvZXNuJ3QNCm1ha2UgYSBsb3Qgc2Vuc2U/DQoNCj4gPiDCoCANCj4gPiAtCS8qIHNhbml0
eSBjaGVjazogKi8NCj4gPiAtCVdBUk5fT04oIWxpc3RfZW1wdHkoJnNneF9kaXJ0eV9wYWdlX2xp
c3QpKTsNCj4gPiArCWxlZnRfZGlydHkgPSBfX3NneF9zYW5pdGl6ZV9wYWdlcygmc2d4X2RpcnR5
X3BhZ2VfbGlzdCk7DQo+ID4gKwkvKg0KPiA+ICsJICogTmV2ZXIgZXhwZWN0ZWQgdG8gaGFwcGVu
IGluIGEgd29ya2luZyBkcml2ZXIuIElmIGl0IGhhcHBlbnMgdGhlDQo+ID4gYnVnDQo+ID4gKwkg
KiBpcyBleHBlY3RlZCB0byBiZSBpbiB0aGUgc2FuaXRpemF0aW9uIHByb2Nlc3MsIGJ1dCBzdWNj
ZXNzZnVsbHkNCj4gPiArCSAqIHNhbml0aXplZCBwYWdlcyBhcmUgc3RpbGwgdmFsaWQgYW5kIGRy
aXZlciBjYW4gYmUgdXNlZCBhbmQgbW9zdA0KPiA+ICsJICogaW1wb3J0YW50bHkgZGVidWdnZWQg
d2l0aG91dCBpc3N1ZXMuIFRvIHB1dCBzaG9ydCwgdGhlIGdsb2JhbA0KPiA+IHN0YXRlDQo+ID4g
KwkgKiBvZiBrZXJuZWwgaXMgbm90IGNvcnJ1cHRlZCBzbyBubyByZWFzb24gdG8gZG8gYW55IG1v
cmUNCj4gPiBjb21wbGljYXRlZA0KPiA+ICsJICogcm9sbGJhY2suDQo+ID4gKwkgKi8NCj4gPiAr
CWlmIChsZWZ0X2RpcnR5KQ0KPiA+ICsJCXByX2VycigiJWxkIHVuc2FuaXRpemVkIHBhZ2VzXG4i
LCBsZWZ0X2RpcnR5KTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAlbHUNCg0KTm8gc3Ryb25nIG9waW5pb24sIGJ1dCBJTUhPIHdlIGNhbiBzdGlsbCBq
dXN0IFdBUk4oKSB3aGVuIGl0IGlzIGRyaXZlciBidWc6DQoNCjEpIFRoZXJlJ3Mgbm8gZ3VhcmFu
dGVlIHRoZSBkcml2ZXIgY2FuIGNvbnRpbnVlIHRvIHdvcmsgaWYgaXQgaGFzIGJ1ZzsNCg0KMikg
V0FSTigpIGNhbiBwYW5pYygpIHRoZSBrZXJuZWwgaWYgL3Byb2Mvc3lzL2tlcm5lbC9wYW5pY19v
bl93YXJuIGlzIHNldCBpcw0KZmluZS4gIEl0J3MgZXhwZWN0ZWQgYmVoYXZpb3VyLiAgSWYgSSB1
bmRlcnN0YW5kIGNvcnJlY3RseSwgdGhlcmUgYXJlIG1hbnkNCnBsYWNlcyBpbiB0aGUga2VybmVs
IHRoYXQgdXNlcyBXQVJOKCkgdG8gY2F0Y2ggYnVncy4NCg0KSW4gZmFjdCwgd2UgY2FuIGV2ZW4g
dmlldyBXQVJOKCkgYXMgYW4gYWR2YW50YWdlLiBGb3IgaW5zdGFuY2UsIGlmIHdlIG9ubHkgcHJp
bnQNCm91dCAieHggdW5zYW5pdGl6ZWQgcGFnZXMiIGluIHRoZSBleGlzdGluZyBjb2RlLCBwZW9w
bGUgbWF5IGV2ZW4gd291bGRuJ3QgaGF2ZQ0Kbm90aWNlZCB0aGlzIGJ1Zy4NCg0KRnJvbSB0aGlz
IHBlcnNwZWN0aXZlLCBpZiB5b3Ugd2FudCB0byBwcmludCBvdXQsIEkgdGhpbmsgeW91IG1heSB3
YW50IHRvIG1ha2UNCnRoZSBtZXNzYWdlIG1vcmUgdmlzaWJsZSwgdGhhdCBwZW9wbGUgY2FuIGtu
b3cgaXQncyBkcml2ZXIgYnVnLiAgUGVyaGFwcw0Kc29tZXRoaW5nIGxpa2UgIlRoZSBkcml2ZXIg
aGFzIGJ1ZywgcGxlYXNlIHJlcG9ydCB0byBrZXJuZWwgY29tbXVuaXR5Li4iLCBldGMuDQoNCjMp
IENoYW5naW5nIFdBUk4oKSB0byBwcl9lcnIoKSBjb25jZXB0dWFsbHkgaXNuJ3QgbWFuZGF0b3J5
IHRvIGZpeCB0aGlzDQpwYXJ0aWN1bGFyIGJ1Zy4gIFNvLCBpdCdzIGtpbmRhIG1peGluZyB0aGlu
Z3MgdG9nZXRoZXIuDQoNCkJ1dCBhZ2Fpbiwgbm8gc3Ryb25nIG9waW5pb24gaGVyZS4NCg0KLS0g
DQpUaGFua3MsDQotS2FpDQoNCg0K
