Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D683604204
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiJSKwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiJSKuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:50:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B8811478
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 03:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666174991; x=1697710991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3/TFUwEHgHTYVn8xMkE6Nu8RDIEOw18cdMThHdwzhPQ=;
  b=fmnS4Cyigtw26z++GUHPw7RfH1YOXsd4PYd+dXncaMmtGbOMr/8xvHjG
   8Y8eC13VWEl7sFOmBHhtCPMkDPz2TkF0p8uRfe7b28245vXRK7JJAdlwS
   rNdq7eUzzTGtFKAmAvKNrUg4/j44sbHGt02sR91nDhivC3cDojhVfAaru
   p39+6TNU/jtXDactxb59Vgy5usET65QzidGpZUZkRL2gud5W5ZsgSMup+
   lGIwGaWdS6SA8WT5NNihiNMwQg18n6cFxCPkTmNhk2HTNZxGCLiegMGAj
   5cYTYehD2MChe+2DpjywYu/jMQsEj2/IGZ+utX5f+GJNv9VAPtvmHDsos
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286759137"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="286759137"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 03:13:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="754510901"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="754510901"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 19 Oct 2022 03:13:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 03:13:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 03:13:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 03:13:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 03:13:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8sA1E0z0OJxU73Oq5LufkpIsjWLZwaKp0I08Rj/I76cqhJRiYLKXmO3udmZmngAC3peIAYZouuKREqdO4IhYgMRhTTU4kiU7mQ7khfm9cOCYDHNhtRk/4/g1xV+5pPpn2+1nVCvtkx3KqI53qkfWi2a33mDi3TEVtFxEx91g2lE14GaECx2U47FiQzmeUZ2TyHYf+SP5A1Ejt747EvwcHvix4mu0JKDutk0P+xY9yUsOf2EKgq/lW1gDe8cY10IrEk0Yom8C7vPMOH6VjBXwvW0Jz/mmYY+lbHlhywcr7v64chzmW70JOsfH5uC1uDDwLBwNIx90NuEvzoEiSj0DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/TFUwEHgHTYVn8xMkE6Nu8RDIEOw18cdMThHdwzhPQ=;
 b=EUh/KRe/QujQO5PLy2/sZX9KL8GXcC0BBcZjJ7DktNVdNt2t8cESrEGPeZHZXSwNq2lq9rmMcnh9c8fU73Zn3Quu+wKEtB44c8kcA9WnFT1ikey+0/gVEdV7cMlPDHz0qwJ86mxmWqMBXihHBbbj0iJOVAK1ScXztAqq8NHqomYVWL6Cel+zNam58nsxwVOCf3aIW3NvxixpKYmyWkfJ0R4H77nuO8eBcnmwoqzUqI0qw1a+XgRb8HHiwKJA+lvkeZ9jlvx7bD36N9I19YVTSyn3G/5T2EDq5LZFvLQZNIJ7LkkCclIQGVM2K4F+bCVZOKvjKDRFPaayVQrZPr+ArA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5411.namprd11.prod.outlook.com (2603:10b6:610:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Wed, 19 Oct
 2022 10:13:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%4]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 10:13:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
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
Subject: RE: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Thread-Topic: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Thread-Index: AQHY1CvD04pCQF3zs02055qhA9FU4a4ARpaAgAAdzACAAOM2gIAAc7sAgBPaDQCAAAeuMA==
Date:   Wed, 19 Oct 2022 10:13:39 +0000
Message-ID: <BN9PR11MB52761B9F3678DCB9D9482DFB8C2B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
 <20221005141717.234c215e.alex.williamson@redhat.com>
 <20221005160356.52d6428c.alex.williamson@redhat.com>
 <Yz695fy8hm0N9DvS@nvidia.com>
 <20221006123122.524c75c9.alex.williamson@redhat.com>
 <a2f60cc9-b468-2ef8-c9cc-b82675b157ed@intel.com>
In-Reply-To: <a2f60cc9-b468-2ef8-c9cc-b82675b157ed@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5411:EE_
x-ms-office365-filtering-correlation-id: 55822ca6-99f4-4989-455f-08dab1ba9814
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KTaJS+W1oTR/NcbK4vfHqZsAoHq3NdS5acMrEr1NCI5yxzwOZzy8OaZGGAvxFYU4/5T/gH0vj3eu6Ujjn0ZGWhJYkzvuN1stZd1OUJPEaZheJjB/942q4FCHWDdAVKP+TKK4MvNv5k1wbK7YOEsXP0EuXvOTgP37GkAgvKcIRos45nMnq26hO995tItk0HP+23sYBPiAMmyHrE7GxYlhhkwsm5GEXK2/0jgXQakQE/3iQVroxB6UUo36fJRXoOi7b1G1mypiTAqRAdzXKvXTiFLKkVAke2CJX9GmIx2OFEHRUuRw9ZUouQeuHIWVJ57k0AzmNmEo/l26vxpUSL1HnGN/As4EjvBZpstUpRNuXi6N6fbS27WZGoJglqPJ75CPEuk6mS2miwAAgdjvuxRCo/wU/Dus/0+QmMctS9I5Ik5i1Msu3V4gB19VwxkJ3F8gc/0sRQmyaER7UT2E3xG3VAUzpzURluN8H2Gz5Pv3R56jLkfsZYkh5O5EMBfD0uoA3uSnGGQbJFhlz9feE1WQVqQLb0mXngTflAMZQbjr25rZ9d1S+10iSHQVCa5wvHd6xcbWa+xwzrUZDjxFw1fEyerymYplLIiHwZyB0JzW1zmXRu5/B/nD7XCsBROGd/csgMuWd7jCM4vMXI/fLt6+OgPaCHOWiCXgS95qfH2LWSMvT2zK8JRAoivpqMRy4OuZsGTODQZpecMvzhoT9dCyMrOHlXsGH7kZbVpqcSAN2HAkhkykJQ9P9K43ckMggO3nev+CZ1/EGnxuNJNU9sWfpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199015)(83380400001)(82960400001)(9686003)(54906003)(38070700005)(33656002)(86362001)(122000001)(38100700002)(52536014)(8936002)(5660300002)(76116006)(66946007)(7416002)(41300700001)(66446008)(4326008)(66556008)(7696005)(2906002)(66476007)(478600001)(64756008)(26005)(8676002)(110136005)(316002)(6506007)(53546011)(186003)(55016003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clZUTWM4SEpiQmNaYUFGK3VpSVlOazZ5OEx0SnJOUHJXV25qaWluUUNLckVj?=
 =?utf-8?B?a240TFhPQzdob0Y5N0YzWUQzeVFLRWM5bXkyd3JMM3dPSWlYSXpSMUtRbFkw?=
 =?utf-8?B?Zk5JVnpjWkp3OHFIKzNqNUZTdnY1M0J4VU9BcktlMGdSS1ZkUHIrN05pYTF2?=
 =?utf-8?B?NjM3WWY2K2VHU210UW9zTTZGeUhIckNRNXducHZoRHpMQWdwL0ZQYWp1ZUxR?=
 =?utf-8?B?S2JlZjdncHZlMkU3SjE5N1dEelhPT25hbjVRSHYzNC92OXhHTzdIYVZLZ3Vk?=
 =?utf-8?B?NzJZeG92UFJiQUEwdVUrSXFtVEdLcTc0OFhNakxiMmREVHcwbm10U1lwVW1L?=
 =?utf-8?B?TUwwbEwyMVZoNHJUVTVZVU5vZjNKNjJMVWZORFdqaHlkUUFHVXhwS09iL2dS?=
 =?utf-8?B?N3grUmQ2UEw5cmREZm53bHFZaHpKYjlJNjU2UllXb3RGSEFGd2dJZ1pwdHhT?=
 =?utf-8?B?eFZYRDhVNUxRc09peHpJbWZGaDZjNG0vYW1VY1FWbHo0NmxJeGVaNm1nSjRY?=
 =?utf-8?B?NFpaSWlqQU9Lb0FWc2FURHh3U09UUDY5c05XeHJ0eE00QmpoMVQ3RFJTZE5K?=
 =?utf-8?B?NzZTZUdxd2s1TklkZVZvb3Zlb2loUldvNjQ3OU5TZm94REZ5QUUrRnFrcU0r?=
 =?utf-8?B?M09JNVhsOGZWMnhCNWpEYzhWV3YzaG1kRDlMbllSRHhqUkM5UWlyU2djUWxS?=
 =?utf-8?B?T1FzNTBkNWY1QjVObFNCVlAxdk5jeTY0cjRweHNHakNUcmFwVGlock9GdHFi?=
 =?utf-8?B?TktJQXJNQUNPeTMzbzF4a01PSW83ZnlVYUpEQkpuemlUUmU4OGFmZnhaTWdW?=
 =?utf-8?B?ejdZbStCV0M3aVF4UDFHb3JmVnlqK1JsY0FOV1FLMVFPTm0yVlU4OGd3NEdl?=
 =?utf-8?B?azRPeDFCUC9leUR5VEwrOXhIS1ZNdTNOQ0ZGZERwbHBiNUZLQlR2UGNwdktR?=
 =?utf-8?B?b2RSQ1NTajA1Q0ZpZU1pUzdVeUUzQm85b2g5Nnd0YjU2bS9VRThleDVzZUFR?=
 =?utf-8?B?NnVmWmlFNFluaitsUWVrNFN4dzIyRGFmR1h3N1NRQ1ZIOEkxeUJtMGo2cnNi?=
 =?utf-8?B?QXpXUlBQelYxVjc4T0NCUkF1dzR4SUFPRmNrSmY3cUJvbUJXMTZGeFdlYzFu?=
 =?utf-8?B?MTJCTDZBNWJtdVpwdUpHWkkzSzFMdkdLY0x2ZDEybk9veGQ0dlBOK1ZGWWQv?=
 =?utf-8?B?Vm1VM1BqNjg3bG9DUG8xS3dmM0FnZmhUNEFDMit5ZjZ2OVU1U0R0dXczeEs2?=
 =?utf-8?B?YlM4aEdOSk9kOWtYK0tpb0EzSWhXWVUwQnkxU3dtUXdES0JuK3JBTkZGc25x?=
 =?utf-8?B?OHd2U0ZCYzVoRnJPdVdrZC9WVHgwNGUwZS9DbktaODBLYldoOHRXckFGN01Z?=
 =?utf-8?B?Nkh4THR4OXkyc1UxSmVHMlljeXZ1QnFvMU9USDM0WHRyM3g4Uk1kQ08vME5y?=
 =?utf-8?B?Zkl1UG9sdHNEWE1OSnVoRGYvTERxdnJFdkRZWmUvVWJiNUlMM1Bkcm13bitl?=
 =?utf-8?B?V1hLZDJKWUM3UlNiMEpPNW41ZkU1eE5GcGFmdWN4Mk1nVzN4QmNEd3E4YlFt?=
 =?utf-8?B?c2NuTXpoTjZQQVdxc295S3NnbjhZQTlobDlnNjhHMXIvTWs0d3ZpNUVjalpu?=
 =?utf-8?B?blIrd2xWZUN5bjJUYWxBZlVMZ2NEZE9UR3o5eHFPUmFndXhoZUJvYVVJTWQ0?=
 =?utf-8?B?TnBsRVYvOGNNZ3JoSU9BYWxmNG53dnZrZU9ha3drMVlhL2RnMXlpVUcwN1dP?=
 =?utf-8?B?VUlsNW9ZcTFRdjZObTNnL2tKYTJjV2p3MUQ4MGtRQkN1TE9OR2RIbWt1QlVR?=
 =?utf-8?B?K0NNeEI0MkxjK1p0SXc3d3NpcmwwejVmOTJ5VmtETEVRTGxqRzBxM3VGNXk3?=
 =?utf-8?B?VHNaZnhuOGg2MUJ5b2RBc204L05lcXBoZFU5YU1TYTdKdU5EdVdFMUcxdkJ3?=
 =?utf-8?B?bWNXczJ6OUwzcitEVUhHL2RzTmlKTVh3aVlLRXJGV3VBakdjd3orVmFFMHll?=
 =?utf-8?B?aWw5My9jckloZ21HU0JWaDJYSHlnZmFrd2EreEgrMTBydWNNNE5oV1NmT09x?=
 =?utf-8?B?a3VQcDlQSFhyVHlES2FQSW5UU0lxQkNNZk0yWDlHdnV0bTBRcDA4RnJEY213?=
 =?utf-8?Q?rKepP4kvDYi2G4Gb7Mnz7SQmk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55822ca6-99f4-4989-455f-08dab1ba9814
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 10:13:39.9376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qrfIDBeGfBIGd+6rPL1oSBKwvpvcnAoN1kK/oDPt+YHMGNwVg03Oqpzi/DrMZd5HQxLexFuqU/x+BKGthR854A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5411
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBXYW5nLCBaaGkgQSA8emhpLmEud2FuZ0BpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgT2N0b2JlciAxOSwgMjAyMiA1OjQxIFBNDQo+IA0KPiBPbiAxMC82LzIyIDE4OjMxLCBB
bGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gT24gVGh1LCA2IE9jdCAyMDIyIDA4OjM3OjA5IC0w
MzAwDQo+ID4gSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4NCj4g
Pj4gT24gV2VkLCBPY3QgMDUsIDIwMjIgYXQgMDQ6MDM6NTZQTSAtMDYwMCwgQWxleCBXaWxsaWFt
c29uIHdyb3RlOg0KPiA+Pj4gV2UgY2FuJ3QgaGF2ZSBhIC5yZW1vdmUgY2FsbGJhY2sgdGhhdCBk
b2VzIG5vdGhpbmcsIHRoaXMgYnJlYWtzDQo+ID4+PiByZW1vdmluZyB0aGUgZGV2aWNlIHdoaWxl
IGl0J3MgaW4gdXNlLiAgT25jZSB3ZSBoYXZlIHRoZQ0KPiA+Pj4gdmZpb191bnJlZ2lzdGVyX2dy
b3VwX2RldigpIGZpeCBiZWxvdywgd2UnbGwgYmxvY2sgdW50aWwgdGhlIGRldmljZSBpcw0KPiA+
Pj4gdW51c2VkLCBhdCB3aGljaCBwb2ludCB2Z3B1LT5hdHRhY2hlZCBiZWNvbWVzIGZhbHNlLiAg
VW5sZXNzIEknbQ0KPiA+Pj4gbWlzc2luZyBzb21ldGhpbmcsIEkgdGhpbmsgd2Ugc2hvdWxkIGFs
c28gZm9sbG93LXVwIHdpdGggYSBwYXRjaCB0bw0KPiA+Pj4gcmVtb3ZlIHRoYXQgYm9ndXMgd2Fy
bi1vbiBicmFuY2gsIHJpZ2h0PyAgVGhhbmtzLA0KPiA+Pg0KPiA+PiBZZXMsIGxvb2tzIHJpZ2h0
IHRvIG1lLg0KPiA+Pg0KPiA+PiBJIHF1ZXN0aW9uIGFsbCB0aGUgbG9naWNhbCBhcnJvdW5kIGF0
dGFjaGVkLCB3aGVyZSBpcyB0aGUgbG9ja2luZz8NCj4gPg0KPiA+IFpoZW55dSwgWmhpLCBLZXZp
biwNCj4gPg0KPiA+IENvdWxkIHNvbWVvbmUgcGxlYXNlIHRha2UgYSBsb29rIGF0IHVzZSBvZiB2
Z3B1LT5hdHRhY2hlZCBpbiB0aGUgR1ZULWcNCj4gPiBkcml2ZXI/ICBJdCdzIHVzZSBpbiBpbnRl
bF92Z3B1X3JlbW92ZSgpIGlzIGJvZ3VzLCB0aGUgLnJlbGVhc2UNCj4gPiBjYWxsYmFjayBuZWVk
cyB0byB1c2UgdmZpb191bnJlZ2lzdGVyX2dyb3VwX2RldigpIHRvIHdhaXQgZm9yIHRoZQ0KPiA+
IGRldmljZSB0byBiZSB1bnVzZWQuICBUaGUgV0FSTl9PTi9yZXR1cm4gaGVyZSBicmVha3MgYWxs
IGZ1dHVyZSB1c2Ugb2YNCj4gPiB0aGUgZGV2aWNlLiAgSSBhc3N1bWUgQGF0dGFjaGVkIGhhcyBz
b21ldGhpbmcgdG8gZG8gd2l0aCB0aGUgcGFnZSB0YWJsZQ0KPiA+IGludGVyZmFjZSB3aXRoIEtW
TSwgYnV0IGl0IGFsbCBsb29rcyByYWN5IGFueXdheS4NCj4gPg0KPiBUaGFua3MgZm9yIHBvaW50
aW5nIHRoaXMgb3V0Lg0KPiANCj4gSXQgd2FzIGludHJvZHVjZWQgaW4gdGhlIEdWVC1nIHJlZmFj
dG9yIHBhdGNoIHNlcmllcyBhbmQgQ2hyaXN0b3BoIG1pZ2h0DQo+IG5vdCB3YW50IHRvIHRvdWNo
IHRoZSB2Z3B1LT5yZWxlYXNlZCB3aGlsZSBoZSBuZWVkZWQgYSBuZXcgc3RhdGUuDQo+IA0KPiBJ
IGRpZyBpdCBhIGJpdC4gdmdwdS0+YXR0YWNoZWQgd291bGQgYmUgdXNlZCBmb3IgcHJldmVudGlu
ZyBtdWx0aXBsZSBvcGVuDQo+IG9uIGEgc2luZ2xlIHZHUFUgYW5kIGluZGljYXRlIHRoZSBrdm1f
Z2V0X2t2bSgpIGhhcyBiZWVuIGRvbmUuDQoNCnZmaW8gY29yZSBhbHJlYWR5IGVuc3VyZXMgdGhh
dCAub3Blbl9kZXZpY2UoKSBpcyBjYWxsZWQgb25seSBvbmNlOg0KDQp2ZmlvX2RldmljZV9vcGVu
KCkNCnsNCgkuLi4NCgltdXRleF9sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KCWRldmlj
ZS0+b3Blbl9jb3VudCsrOw0KCWlmIChkZXZpY2UtPm9wZW5fY291bnQgPT0gMSkgew0KCQkuLi4N
CgkJaWYgKGRldmljZS0+b3BzLT5vcGVuX2RldmljZSkgew0KCQkJcmV0ID0gZGV2aWNlLT5vcHMt
Pm9wZW5fZGV2aWNlKGRldmljZSk7DQoJCQkuLi4NCn0NCg0KPiB2Z3B1LT5yZWxlYXNlZCB3YXMg
dG8gcHJldmVudCB0aGUgcmVsZWFzZSBiZWZvcmUgY2xvc2UsIHdoaWNoIGlzIG5vdw0KPiBoYW5k
bGVkIGJ5IHRoZSB2ZmlvX2RldmljZV8qLg0KPiANCj4gV2hhdCBJIHdvdWxkIGxpa2UgdG8gZG8g
YXJlOg0KPiAxKSBSZW1vdmUgdGhlIHZncHUtPnJlbGVhc2VkLiAyKSBVc2UgYWxvY2sgdG8gcHJv
dGVjdCB2Z3B1LT5hdHRhY2hlZC4NCj4gDQo+IEFmdGVyIHRob3NlIHdlcmUgc29sdmVkLCB0aGUg
V0FSTl9PTi9yZXR1cm4gaW4gdGhlIGludGVsX3ZncHVfcmVtb3ZlKCkNCj4gc2hvdWxkIGJlIHNh
ZmVseSByZW1vdmVkIGFzIHRoZSAucmVsZWFzZSB3aWxsIGJlIGNhbGxlZCBhZnRlciAuY2xvc2Vf
ZGV2aWNlDQo+IGRlY2Vhc2VzIHRoZSB2ZmlvX2RldmljZS0+cmVmY250IHRvIHplcm8uDQo+IA0K
PiBUaGFua3MsDQo+IFpoaS4NCj4gDQo+ID4gQWxzbywgd2hhdGV2ZXIgcHVycG9zZSB2Z3B1LT5y
ZWxlYXNlZCBzZXJ2ZWQgbG9va3MgdW5uZWNlc3Nhcnkgbm93Lg0KPiA+IFRoYW5rcywNCj4gPg0K
PiA+IEFsZXgNCj4gPg0KDQo=
