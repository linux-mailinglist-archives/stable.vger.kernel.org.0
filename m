Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F054967A8E6
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 03:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjAYCmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 21:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjAYCmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 21:42:35 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C390A4FCD3;
        Tue, 24 Jan 2023 18:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674614552; x=1706150552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aoe6Ul87ioJcaFSMqx+jW/v9ahqGK2ZJzLvXi1v7vb0=;
  b=VRsyQkPiLAG0ZUENR9xEgItQ2qusqZI03N8aqOBBR5RLtlf84/Yk+xww
   cqFByFlCWzhAQ5ipcVXq0GI5OL3BmsuecO7Py02RoxWoRmvOuo9o+Le+p
   QYOjv1ci9fEDPmv4eT4a9dyl7TcfalOQmHODLgKa6F+kQrXrGrdUt5neZ
   Y1XBKmTszqmu4iCgX10u5FDrbGr8OX/ypPPxK+JLecyiyL+TIPLHcEtXP
   enujNEa9Z4PyyR5uQsXQBuDDoDxHp69xyhdwfH46Ahd4dn9UgKstalodG
   91HwTMXj8MiOi1E8OWNXqW/ZK6HlmnCOig96q3f1C1IewOyBlyqHyOZNz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="388814358"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="388814358"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 18:42:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="692802732"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="692802732"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 24 Jan 2023 18:42:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 18:42:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 18:42:31 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 18:42:31 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 18:42:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaDBUIj9B78+5jbTLp25vGCQQvApjL5KGuPGiGlg9bV+OWU6uhD+dVvEJariZPGoicIMxJCbN5tkmiNiSXnVSizapIaWZ6PcHkC5HLM8UtGRivNhOp6iUMp+q0wh2qt8rYSjWghdAxsYGRco1Q0u5OgU0dGsUBnJ+/KrpNqlbCOXb/4BZqsxOficVuf25ig8bfDzAlmp3sTYn/EeC59eTsdakBh8Qd5k/1+ifMDHM9kBlFoMVHwKA70YXaNjs4dJvIxRE+8QKHAXj05sKhqTgDASAS/ekd72+5R0zSEFwacxUaSc3va3FSnJI0e8dcItxp/0onafm3WXSyiFJp1F9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoe6Ul87ioJcaFSMqx+jW/v9ahqGK2ZJzLvXi1v7vb0=;
 b=UhvweuhmprbEW/dRiUsh928ioGNTHhZLJEMbhrgTCPO0o/0d+7xpOgE1R4uVkg5c2RcARQ51Z9LU3f9xGbxiVc98AsqmyPeclgXSRp7psNIJtORNHfHR0ZHAo6f/RHC1V9gBh4uQPrjAOrr2Qld2OIOtVcClJ64DphUlRiyVS8IjSmdlw06SRbZppQsEAqJ+ElTfyC22pQVEJIZu2fwijJ5fKAVQP4DhWHAWiidMuc5YLVJpBxtOuPw93y12iimoG5OM6+/21ylG6LEod7HuXFM9BlobnvtscehwnRWF2Z8QRE6B0XoBYxsKdW0hMwIoeNRsGcn7y1WCqO2BRqBgQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SN7PR11MB6970.namprd11.prod.outlook.com (2603:10b6:806:2aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 02:42:28 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::cf29:418d:2ed1:c1b9]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::cf29:418d:2ed1:c1b9%5]) with mapi id 15.20.6002.027; Wed, 25 Jan 2023
 02:42:28 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?iso-2022-jp?B?GyRCTHhoR0p2GyhC?= <liujingfeng@qianxin.com>
Subject: RE: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Thread-Topic: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Thread-Index: AQHZG4G35lVMEMdAHEKf7mCxBCtF/K6szOiAgAFfNoCAAAkiAIAAXpAw
Date:   Wed, 25 Jan 2023 02:42:28 +0000
Message-ID: <DS0PR11MB6373D54320929E2A98123671DCCE9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221229123302.4083-1-wei.w.wang@intel.com>
 <Y88XYR0L2DyiKnIM@google.com> <85285ccd-7b1a-9a94-5471-8036cb824b28@rbox.co>
 <Y9BFqIK04V6fBMz7@google.com>
In-Reply-To: <Y9BFqIK04V6fBMz7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SN7PR11MB6970:EE_
x-ms-office365-filtering-correlation-id: 93c5071a-482f-4bf0-5e25-08dafe7dccad
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HD2JDVGLdQJ7if4jX7c9I3AR2Q55U6VXO6kPi0NGPwtk2hv3Ef4Pf1UFSD5TRBQSHxaJs4hXnrEUuWfK7ApIKQ2ufvSDTBh4Mf+MnfDnV1xSxhcGJVGmEWyf5AcuHcQbRwjLP2no3BxlFPxhfMZINyk/RMA8ghB7K4MBTij5L508JJeUYD8pNa+IT9d5X/qj3EkxjzYaycwoNnuXFoslv+gM02V6bAlKGuV97Z75hU0Zo1+WEWqwLzFmfWh9M6ztGZ7jF8U4VkqH29ea3AwXeWbipxQfjQlC+wF0Shx7LR1TU168mTwnEA+fkMCT8kT4hq5Ag/21bB43XOk8rtTnySV7SnDescNelSYNYzEnarpIjiMo+UYfimtwrLIjgukggU6zxBQuCsfdH3TiRfiqh7c8i1NZij8iyOxW21kdwqYwegl0F8jaf1OWmnwdTJWof2NMUdgBtNTuAfmGWbeO3dcN3FpiTUuTY/hLvkHeZNAsG+zIdLUqZZiH2IrgWmra06Y8grPMmbGm7lYM7p+FIhty4VRS6aFabejU2lHnGt04VD00dY40Ae71euaZVTKHsnUWDRWRsMZnEfWJCmU8uEHAEOpBn7drzMHBFaFgcRYgiWDRzmu4dISGWhTJ7CjiXxrIXhqR89RBE4ajrD2OPOetoBBicEQes0rIXG1RzAkkDBfOFBI2pRMC1Eqw8clc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(66446008)(66946007)(76116006)(64756008)(4326008)(8676002)(66556008)(110136005)(38070700005)(54906003)(316002)(66476007)(122000001)(82960400001)(38100700002)(55016003)(86362001)(8936002)(52536014)(41300700001)(2906002)(83380400001)(33656002)(4744005)(5660300002)(478600001)(26005)(71200400001)(186003)(9686003)(53546011)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?WGd2eG5URUJJYkxiZlpTbnJlODlOUzBDcER1a0lVdVBlT3dmL0VLWlBP?=
 =?iso-2022-jp?B?cWF5M0s0K2ZSVTZWUktkc0treGZlVElVMjRBb1cxT3Ard01UN1NVVWcz?=
 =?iso-2022-jp?B?S09nRm9XTUc2ck1CUE9ZNDI0ajFTUDMzMk5TTzhvZ2RxMUR6T1RIUW55?=
 =?iso-2022-jp?B?MkFSYTZMSTVUcXpQL2l5emV6QUVCRmg2STlVdVE0SnVvZGV5Zi9nVGFV?=
 =?iso-2022-jp?B?eXByT0tsb0NrbXNRd0lERE56SDZaNUQvQVlOSGpFODdXT2FKU21RRElt?=
 =?iso-2022-jp?B?b2FEalplQXV6bFRSQ0Rmem9FOWxMdmpuenN6NDdSOFNIYWdXMzRMZ0gr?=
 =?iso-2022-jp?B?Y0hNQXYzUnp5L1V5amVyK3dZcW92ZjRtMkFReHZabWFZTGxTaWNSMjBI?=
 =?iso-2022-jp?B?VndEU0ZMQmVkSTFGamlPWWo0NWNzSEJlL3hRZEFUK29JMTZzdVFXOFVm?=
 =?iso-2022-jp?B?TlVmbWsrb0FsemtwUW96aG1zWHhhTzV3K2hPdXV6c0tvTXBZM3N1RkFH?=
 =?iso-2022-jp?B?ZHZqYnR0NHl5bjk3cGduSDZCZGtpTXRTMmN3b3o3Qm9nNnV5d2NYYVY5?=
 =?iso-2022-jp?B?Vk1TY3ZKK24zVEdVbFZBK1RDN0JRN3Z0YmY5NEI2bGNoRkZ3ZjNFditC?=
 =?iso-2022-jp?B?UzB5d09iZUpVN1JSNjI4SksxcVQ5SW9lRkcxbVM4Y0U0UzJNakh5Uy9L?=
 =?iso-2022-jp?B?TEdMcTExdENkWlBRdzVJRHVROTkwS05Ycm5qRzNQTlB6b2FEcVZ3ZkIy?=
 =?iso-2022-jp?B?aXB0VlBXb3NDS3E1c00wYVlpRktQN2dpN3NaYzI2WW82akFUdUl5LzUw?=
 =?iso-2022-jp?B?QXJLcVhVWHV2RUFTYjdBR3JZcWFFUlZydVIrQkhKUzZLMnJDd3dRSzRF?=
 =?iso-2022-jp?B?Q25vMFd1MnhOOUhXU0NJb05mZFpKbFZFWjFML01xRW1tbHdxQXFMK1NE?=
 =?iso-2022-jp?B?STZWZDFTREY1TEJ4NmZRS25yT2thQWdXSUUrKzhDZjYzRGJUcGtjV3Zh?=
 =?iso-2022-jp?B?VFFWRVF6bTNSRk5lVEtWdlE1a0RWbHEzKzhtamJQUG5kNm9CYXppVjEy?=
 =?iso-2022-jp?B?cUhpWWxBMjRVcUdpc1k1TW05dnVLdWJFZUh5RlJPWXdGTjRPVEVkaVEy?=
 =?iso-2022-jp?B?NktwWkgrWmZHQjVpUFZ5MjlBc2tLWmtkT1lZZEcrb0VHUGhFVWtMUUhq?=
 =?iso-2022-jp?B?cUNhOW9FL21VbHVrQlc2cStpVjFubXFoM2dNLzdMQmhoZjM4R0hEcTQ3?=
 =?iso-2022-jp?B?b0xLVWlGNnZud0gweXBGd0dDWVRjYldieUNuRGkwangvclVFZEpoWk8v?=
 =?iso-2022-jp?B?Q2hWeU0zc1FvRUsrd3FQYWRhbmphbUFmZnFkbHkvSTJuUUpsVkRUR0xI?=
 =?iso-2022-jp?B?ejArQjhpUU9CQzJZd21qemU1WTZUZWVDZHJtSkQ3RlBab0pUanVINDgy?=
 =?iso-2022-jp?B?eVhZSnBPOVBON0UxMVJRb3FuaXpkUjRXb0VDK2NSUnhENmFtRWphMXEv?=
 =?iso-2022-jp?B?R1B4ckY4TCs1Syt3K0t1S1ZBQmpFcXBHRTVPN2M4NUViYWdvQXkraElF?=
 =?iso-2022-jp?B?RW9rYXlTUVFQUUwwZm5ESDFCRG5PamZYVS9qVnlFakNveXNMTjA2OTRj?=
 =?iso-2022-jp?B?Y2thZkZRcmprZlFuQkRtS0RnMkp0RXhxaDNsd2psaVJFYVVxRnV6bFhi?=
 =?iso-2022-jp?B?OGxyM1p2dWdaZjhHK3REUlN3NDhYN1FEK25BelVxQkt5WXE2Ym1kWk9F?=
 =?iso-2022-jp?B?dFZqN0lrelZGeUZTbkl4T2lZdUVzem9Id0ZGS05YZld0amg1ZGRuTUVS?=
 =?iso-2022-jp?B?U2hQa3pQazg3T3Rib0xlVGxZRVN1SzFEQ04xMXRtR21oUFBCVks2QWlF?=
 =?iso-2022-jp?B?QWtaVklXYjNtdU5VNE40R2lHKzZGdVQyM3A1dDg5VjQzWitIMFNJdHo5?=
 =?iso-2022-jp?B?RC92Qm5PUGdpRXZSM3I5Y0ptbGUwQ0xaQnZSTDFTbXgyZldES3Z0a0xJ?=
 =?iso-2022-jp?B?S0g4bVdjZDMzMDJBUDUzenVaWjlSd25UYVBIaUtvUHlGQ0ZqTHZFSDNX?=
 =?iso-2022-jp?B?aGZ2eXRiNFRvSGVnNXkrRG5BdnlsaEFhTzV4ekxWNkk5bUtmTVZ0Ui9j?=
 =?iso-2022-jp?B?Mk9pa1Fyblo5NXEyTWdsa096V1Y0ZjBFMEVMVnV2dkUrVStxWjR4bTg2?=
 =?iso-2022-jp?B?MENFVm5UV09HSURSWDJQeHdaaE1OWWZ1TmRLb2FOWHhRZzdCYUpwVHJH?=
 =?iso-2022-jp?B?K0NzQXRVSHd4R25iZjdmWFkvWGtVekFtM1R5U0FCUkIwVWFrSkwrZkIy?=
 =?iso-2022-jp?B?MzJLOQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c5071a-482f-4bf0-5e25-08dafe7dccad
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 02:42:28.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RnUOyvOg+E1YZtW9TMZYU/e2TcZrkVI6FKrivPTCUY2YtVKNF4phjQ/OERQv8y2kdZVFIkCQe0lPAK4+BdrONQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6970
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday, January 25, 2023 4:55 AM, Sean Christopherson wrote:
> >
> > I was wondering: would it make sense to simplify from
> > list_for_each_entry_safe() to list_for_each_entry() in this loop?
>=20
> Ooh, yeah, that's super confusing, at least to me, because the "safe" par=
t
> implies that the loop processes entries after kvm_io_bus_unregister_dev()=
,
> i.e. needs to guard against failure same as the coalesced MMIO case.
>=20
> Wei, want to tack on a patch in v2?

Yes. I will include it in v2.
