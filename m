Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC35BFDC8
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiIUMYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiIUMX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:23:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB5597EC9;
        Wed, 21 Sep 2022 05:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663763037; x=1695299037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gneLaYGSJmneo1U/sTQKSwvec9XlQFnmJhVFTeJiK6w=;
  b=NK84pISVWV2gMKg/rukWiRHIHAsBr17MaUZFWKQXMyaKz2BR2gvORwu0
   ZmTpWZQn+wa6TKwxVvprOYiWo8PLpFXO/RMLeJ3xwTD1ZO8j9S6Eofq3z
   pBs3l+V11gZTE2EW8T6n/D7P+4yvEQYp52u4n6hjs+z5QRgijf8TD+APE
   ZmD+k+7XTJ4XE07Tgc23j3jzlP2IvgZzgGhxQO/s77Udy8B33eTHaV2Kn
   +6cMhRBatTo4dBwgnI6Mz1qUveF5Ee1E2fqVj8DCtuRu5xgPZzKoV/K1y
   XgVrjGCI4M0Fj3liSanrw2iXhDoCxBcMTjE5HCzboGLvX/Nwj0UZuRjm2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="361745145"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="361745145"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 05:23:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="708426883"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Sep 2022 05:23:55 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 05:23:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 05:23:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 05:23:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 05:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrKnxiQvf58BMLBdIczm9UgB2Y4VfnVSg5sPd2AtEbSFT0eLaTOyk8Ai066/w8DJvk8vZs4iExGuiurlsN10ql0+1MsoU6KlRORAWFNlZfOHIXyJVrJfIakTsjZ8g+ZfcQHRQuJVqPCEJGoJKzfwVkLi8FaZxQhmTwtFWcLzfDLr7UVbTzRUxoXdW8dednPEfrshUYxMm8XSTwxU6iHsiDeP94Uom0u4QdR787A8m+ybSUribA0EAEMjvcOiI9e1ojCJfXg1u3CHD9fZ8a7ykbnynpTM99/zo0IHb0OIbl7NB0sfIT5hMcq5/uhpF53TF+iatuZfUVhN0GilGrFUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQQWmVmr1KkuxGN3REhRZsmFTBuglNGJmM9yKrrZ/Vc=;
 b=SwlEzuAIE0uGgx8UanbLk5jzo5Ezf/C4KTWqatMub25G3fgafgGFB3tueKkpm0J1DcoJ79dCJWFlV7Sf3iIm2ozCY8izNP2J5zzhM84b25Xoqa6aGWJYl38bUKmtgXpRz0xndkZ1gW64wf7lL0TUkp4eudOIIkKNPEs6/K1vSgaq9PXwctInfxlQTWQdJw6IiDZKqfXgjabZpwHYxz8YVcWkF9XaeQfdtVRJIT/8+sy82/lQrfDOmIGA8VA3MeM6tKEG1IEUAPoFw1L63nMbaHkXVwuuT9sNdEEgFJnIUVSjMe5YgxImBMdYMA/vLyF1L1O6hlSOvQpJPz8uiOMRew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3544.namprd11.prod.outlook.com (2603:10b6:a03:b5::29)
 by PH7PR11MB7074.namprd11.prod.outlook.com (2603:10b6:510:20d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 12:23:47 +0000
Received: from BYAPR11MB3544.namprd11.prod.outlook.com
 ([fe80::5f7f:2fa:74b1:11d8]) by BYAPR11MB3544.namprd11.prod.outlook.com
 ([fe80::5f7f:2fa:74b1:11d8%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 12:23:47 +0000
From:   "Huang, Yonghua" <yonghua.huang@intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Wang, Yu1" <yu1.wang@intel.com>, "Li, Fei1" <fei1.li@intel.com>,
        Linux MM <linux-mm@kvack.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
Thread-Topic: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
Thread-Index: AQHYLEfg4LGJm4nTXkWIyXm40QwGzK2pDmuAgEICZEA=
Date:   Wed, 21 Sep 2022 12:23:47 +0000
Message-ID: <BYAPR11MB354411F3B1C3AE2423627147F74F9@BYAPR11MB3544.namprd11.prod.outlook.com>
References: <20220228022212.419406-1-yonghua.huang@intel.com>
 <YvOiZ2jp2Fv0Ex0J@phenom.ffwll.local>
In-Reply-To: <YvOiZ2jp2Fv0Ex0J@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3544:EE_|PH7PR11MB7074:EE_
x-ms-office365-filtering-correlation-id: e0c0aab0-a540-4d90-25b9-08da9bcc2202
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XPUQ1F/27RC+datfBT5Gb/sjNMSps1PqsA+B6SFitH8klZw5UsdAGyd3eojTawg736WMPVYtETtLj/CzeEqY6s4P3Z5OfH5qFC6jVdWZsHEsNsRvXeaGWXLtyoVKkI/tr4rbUWmW5wV14INKfXuxpO4p0XFKNI4ydwopHlxP3mBVVUJHJheLYkVxUXGxJV7Hk4oDCe8mEI/SR2u/c7p2X/e8txFH5WQezrRXlJ0oEdT+A7U65RcbRSvw1uK4kqrME9e7S4thAJH3hS4FbbwCN0mKka3hoTkmyaycBBGuMKedsK/Cysp0E9WfwsbyPWzb9Zpq2XJ+1jtT99vQPIR5ekoh6UgvCl9k85HeP71dWz3u4QngNExAT5PrHlKvicpYTwxP6BF0moeFOtD7g5qqrRQUSlgFdr7hft72kSzmMTYbqCHF7PBZTE4zqYd+55dh7ffjbNd6ZBvp1B+jb7wwIlr/NNrDda+CrZGxGvlYNnWKeygT+kHpMgELhOUfDHlDiShcwnYaAwIj8NEbx1mOgtXzafGJ+rk7QZRy8Kf5xcm3YEjNx9P9PlpUuWesgZNzxdSRFSzfKh3o/SMRI4/3nhVoQ8Drebx5nxY+P2cbqaprA4d4k6oCSr6IDAsGGMUUmYYRM7mVXVCg9pGHV9u6grm3/HXLMISsVbp+RXcw7lFXIxuoiw0uQpjE5OBBVIbYKBp6eqfmJPMIDTj12I9tgKYEzcSI5Iw39ie8uq3ZkZm+58qbZKffLJ0xK+Bhx7lx9RQgAZtyQFxhYiMqRutHDRZmTZqM66KsZO4IFe7kwo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3544.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199015)(7696005)(41300700001)(55016003)(478600001)(26005)(53546011)(966005)(6506007)(9686003)(122000001)(71200400001)(33656002)(38100700002)(2906002)(86362001)(186003)(64756008)(82960400001)(66446008)(66946007)(66556008)(8676002)(66476007)(4326008)(76116006)(38070700005)(5660300002)(316002)(52536014)(8936002)(6916009)(83380400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wx9MPx6v0Op6f7Zt3TnCKn5UFRobkIaIM07WGGFSjzFkDMjb2oSHG+or3cC6?=
 =?us-ascii?Q?ctLhYOs/fl9KjsqK45DhuPdgiE8kFGvanFxjGeylsiE4hmzpGJPFijdyjp9U?=
 =?us-ascii?Q?ZK6GhWZQQJ/7TCyt6N7tPRJIdvFTOIq4a6afOL6eaU8Xmg1uRdHSlDYY9b8s?=
 =?us-ascii?Q?rr03Cyv7zaZOOguvn15g5pUOF8krqfPvL2tjGZ+wXEkG37nbqr8hdPKSW+lT?=
 =?us-ascii?Q?VSmpqCn72gEsRkqapQ/yx9Q+kqLIopw/X5PpJmflCLieF56ZtnKxt9QTPk2b?=
 =?us-ascii?Q?RvQnapwxdI58ybOy4q3ZW5xwQCsYLHzvrgY3ICFn1I63q71SgWNMn4v5+yoL?=
 =?us-ascii?Q?rxJBeVVAxL2SBPRqbVHaVOpgK20ur+q34cjCDapgveqHB8ahKis4uxpuTbic?=
 =?us-ascii?Q?1ic0RqoZv+lLr28t1LD7dZ3N/zV9yvN6XU9WeI9oRdImejhvYIbMpefMohMy?=
 =?us-ascii?Q?BBtZFELPM4aZwOcDnIelH5uDmockOEQE10EKW8vSrvofXGUNgDdhy3qJrz13?=
 =?us-ascii?Q?HlEdmqi1iqOGm7pk4QTj0nrYGj1+h5+uov42kwrL+sCOAIbngOFYWHOFeWuT?=
 =?us-ascii?Q?TvEhFX7DQ15ngxdP6bHdH50UPkfFjKCYWf6Gsbfej+F/F0eDt3cqsK3H8E7t?=
 =?us-ascii?Q?k1q7qX3QLaZhlLqQovzfBl4AJS4j3+2Nff4JVISxCZr+1unng2jSO9WCP7tK?=
 =?us-ascii?Q?wFYt6d7xKDTzweUf3to+AjAak3TN3zMwJeBnmWwZmWuLu3Nw9mO9J6E/GWnv?=
 =?us-ascii?Q?8RlIiv+93Cs1JnaLTTwsUX8p3yQkgGlhgKAedR08K0g6helCUg6/RpYFBI3G?=
 =?us-ascii?Q?/wuEL5Sr37O+/3hE5Ui0Q8Tfu/I6zvM0RESx6QbJpZAwMx/c8DWRj41BKLi8?=
 =?us-ascii?Q?q34vXqYcYOejHwuzIuI3O8R+U8EX/2v1FGQfmkzo6CfuAApPeW8ANb17XNBP?=
 =?us-ascii?Q?E8SDwSbkNcYY34lLl+uX+Y/ZgPrGZxymX629pdq9uAOr6+JbvaUzRKHf6coQ?=
 =?us-ascii?Q?xBZdGQ2eOrf1dnfqLjdWZhNlStDH/Opu9vh6fSaqkDXbO/Ixf54E11XPxJnz?=
 =?us-ascii?Q?G3wZuK/GDkdK78Wuf5m9UQKkeKtC/kVajjpo3LR+jvl0w2GW0DUXnIis8rWW?=
 =?us-ascii?Q?GQ0LALjr5zqwoW09bCmOs7JyTooOtWwwmNFuWCSgd3sU6ZCu3yzysyvFV64o?=
 =?us-ascii?Q?wYRtpcnQPIWTrytXf9dNfUhyvj4LlcIm8QkAJRsdeioHRC0/euTU+uUpjjjX?=
 =?us-ascii?Q?WcrFX/QhoOYJm781p9DqjKt03Kk3Evu46BtvZGtWmRj7DM6y8XVBLsyc0BPx?=
 =?us-ascii?Q?Hek9n8q/jnIBo9RnIcPHlzOQSdQXTTyQlxqUpAwMkFV93+Pba7cedz4hw30y?=
 =?us-ascii?Q?KaoAqEis0V3DSitV5v31SuSMqbXpJk6fgMZflIJuKcf3fPYhqj09267Eas6h?=
 =?us-ascii?Q?iLzKvIpuAKF2SfRoJcuerGTW1CSp34guLF0ZrBA/u2MqKHEoflAJqAetZrSs?=
 =?us-ascii?Q?zqFxqafPBvLdYO/QItmAdUp7N/e0AmPeRhHrO+Ebvo4LGlo7gv8fJv5+pZFR?=
 =?us-ascii?Q?YArK4R09baQSwcrz5Eb7k1gC7gPMrIxVqGQNE5Z5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3544.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c0aab0-a540-4d90-25b9-08da9bcc2202
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 12:23:47.2390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XR68joh7DU6kn85Q5PFGt0KaRiAL7M4l8wseXwTiYM8Q0BtSxSSwFWPG47bTvehjoMkcxEEnkbh4wCoA+EL/dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7074
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

 Thank you for this info, we will fix this issue.

Almost miss this mail, sorry!

-Yonghua

> -----Original Message-----
> From: Daniel Vetter <daniel@ffwll.ch>
> Sent: Wednesday, August 10, 2022 20:20
> To: Huang, Yonghua <yonghua.huang@intel.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; Chatre, Reinette <reinette.chatre@intel.com>; Wan=
g,
> Zhi A <zhi.a.wang@intel.com>; Wang, Yu1 <yu1.wang@intel.com>; Li, Fei1
> <fei1.li@intel.com>; Linux MM <linux-mm@kvack.org>; DRI Development <dri-
> devel@lists.freedesktop.org>
> Subject: Re: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
>=20
> On Mon, Feb 28, 2022 at 05:22:12AM +0300, Yonghua Huang wrote:
> >  acrn_vm_ram_map can't pin the user pages with VM_PFNMAP flag  by
> > calling get_user_pages_fast(), the PA(physical pages)  may be mapped
> > by kernel driver and set PFNMAP flag.
> >
> >  This patch fixes logic to setup EPT mapping for PFN mapped RAM region
> > by checking the memory attribute before adding EPT mapping for them.
> >
> > Fixes: 88f537d5e8dd ("virt: acrn: Introduce EPT mapping management")
> > Signed-off-by: Yonghua Huang <yonghua.huang@intel.com>
> > Signed-off-by: Fei Li <fei1.li@intel.com>
> > ---
> >  drivers/virt/acrn/mm.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c index
> > c4f2e15c8a2b..3b1b1e7a844b 100644
> > --- a/drivers/virt/acrn/mm.c
> > +++ b/drivers/virt/acrn/mm.c
> > @@ -162,10 +162,34 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct
> acrn_vm_memmap *memmap)
> >  	void *remap_vaddr;
> >  	int ret, pinned;
> >  	u64 user_vm_pa;
> > +	unsigned long pfn;
> > +	struct vm_area_struct *vma;
> >
> >  	if (!vm || !memmap)
> >  		return -EINVAL;
> >
> > +	mmap_read_lock(current->mm);
> > +	vma =3D vma_lookup(current->mm, memmap->vma_base);
> > +	if (vma && ((vma->vm_flags & VM_PFNMAP) !=3D 0)) {
> > +		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
> > +			mmap_read_unlock(current->mm);
> > +			return -EINVAL;
> > +		}
> > +
> > +		ret =3D follow_pfn(vma, memmap->vma_base, &pfn);
>=20
> This races, don't use follow_pfn() and most definitely don't add new user=
s. In
> some cases follow_pte, but the pte/pfn is still only valid for as long as=
 you hold
> the pte spinlock.
>=20
> > +		mmap_read_unlock(current->mm);
>=20
> Definitely after here there's zero guarantees about this pfn and it could=
 point at
> anything.
>=20
> Please fix, I tried pretty hard to get rid of follow_pfn(), but some of t=
hem are
> just too hard to fix (e.g. kvm needs a pretty hug rewrite to get it all s=
orted).
>=20
> Cheers, Daniel
>=20
> > +		if (ret < 0) {
> > +			dev_dbg(acrn_dev.this_device,
> > +				"Failed to lookup PFN at VMA:%pK.\n", (void
> *)memmap->vma_base);
> > +			return ret;
> > +		}
> > +
> > +		return acrn_mm_region_add(vm, memmap->user_vm_pa,
> > +			 PFN_PHYS(pfn), memmap->len,
> > +			 ACRN_MEM_TYPE_WB, memmap->attr);
> > +	}
> > +	mmap_read_unlock(current->mm);
> > +
> >  	/* Get the page number of the map region */
> >  	nr_pages =3D memmap->len >> PAGE_SHIFT;
> >  	pages =3D vzalloc(nr_pages * sizeof(struct page *));
> >
> > base-commit: 73878e5eb1bd3c9656685ca60bc3a49d17311e0c
> > --
> > 2.25.1
> >
>=20
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
