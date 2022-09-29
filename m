Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8141B5EFEE5
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 22:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiI2UwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 16:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiI2UwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 16:52:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFCE177367;
        Thu, 29 Sep 2022 13:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664484741; x=1696020741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7//n7eM/ChCeWOdJevXbZd/z1Dvc8iDc9QK7ep2+K2w=;
  b=oCOv3MJ70qGeua83DVsFtbiwNF7gfXSDZPMZQEpe+l6zEIOyefSbuQMW
   7HoB25OcSCfS+8TG52PGvbrD3TRaSfHc9S4/1GR9Mo33Mcq/0cmAqvrky
   7lpO6LCrFZ1HqZ1Au8PX3JbJgProB8n41hsdzwT0DDgBAL0vDiFuVfEx8
   tlYEKjZmiRFmnFBG7WeqmWjAnVvMw6SzYDbjEju3mS5tu7UZ7p44ZaMP0
   pojaHAvkoWBb/Mz/rwt7Nibn9hnufpSAXuFqt8efaLqUWeV5fQmNY7tPX
   HfaJOU3LOCkkCLVhV3MPrdC7j3U48xyO+6giHn6yYVLo6uGI7ZnG7KbNP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328399459"
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="328399459"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 13:52:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="600158308"
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="600158308"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 29 Sep 2022 13:52:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 13:52:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 13:52:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 13:52:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 13:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhRemj2b3vySQHBcednj9YusLwt2h66/7jny8FNQ+FprOcvR2YHjshooaxxES1PCUtdpU2rwWEIA5V8slTCwvpN2nI3IkwGo5ru3BDAx+QwaragwiH98LbagA1fZd95mMg2EUqrQBgNjBZzY4+yc6lNHPPrMS9tkkusH3mcQ9kVVQAuVOUisGGwXO2dyoVccyRrvWuRygMAQIAeUeU2J/9SPastt3vfpE6Dj+KhRpiK9eq0/t896IECjXgWaa9jyYrQvvDEDQkwnTmn4/V6F8+2NYubH3RgcACUveEHy20dguyE1ddN10lDJZNkRaEjCZuBrDoLfikdTxsN7oZcMCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7//n7eM/ChCeWOdJevXbZd/z1Dvc8iDc9QK7ep2+K2w=;
 b=EMMEAejpoEWtxZ9qv8vBtaf/Lni30oMnEyDOeTbIY5DL/5sYdmc1GXl4v8TM6w4WWmILHXxPkr8hySRjRM00ITE1+I1BvDEzZ0CromMHQ2TDz3tQhL2FErKmU9AYxco0PLDd35SUx4+1NkcQHJfeQlOab+zlH1dhrv2yy8MUssGU93RORHJfk2Cw4aV65nmzV/DcOR6f5JdJVqUX+JueFha2iDw5rlfVJkdfU79JV9BFIT7zVxYACfqDkK/Vu3Sa3g9MLaONgBCrHEb6bMuuAhpxUoiEm9MoZXoW3VdUFUcBIwQi0H2BUkM/8zGvHqnVWYNrLdSfLXaULbBxp1iQCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6551.namprd11.prod.outlook.com (2603:10b6:8:b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 20:52:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60%5]) with mapi id 15.20.5612.022; Thu, 29 Sep 2022
 20:52:02 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        James Morse <james.morse@arm.com>
CC:     Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
Subject: RE: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Thread-Topic: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Thread-Index: AQHYz+pWnxyJgYboZk+A8TiiA+I2Ca3u0zyAgALE/YCAAD4LsIAA0nMAgADpGLCAAiYcAIABMbYw
Date:   Thu, 29 Sep 2022 20:52:02 +0000
Message-ID: <SJ1PR11MB60837ABF899B5CF1F01D68D1FC579@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
 <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
 <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f09e6aee-5d7f-62c2-8a6e-d721d8b22699@linux.alibaba.com>
In-Reply-To: <f09e6aee-5d7f-62c2-8a6e-d721d8b22699@linux.alibaba.com>
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
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6551:EE_
x-ms-office365-filtering-correlation-id: 808e1703-460f-4451-59e2-08daa25c7622
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +nhE87VZ/8sbMIiR39lX2Jac7YIn+pV+zEvxHc1/vP8Rp0u3BHXN9In7zKxCe9FWgFDa7fnLsNlKcNnthBhkKjdGHLEbKfuZnCIJjRVPSDlAJWbaeVgNbQiTpWBoWkxUc/rBfLPyhwtByCcF/dMV9SeufJ0x0a4rOnsCWaPTmJv7YWDacHyvwH9STz/CbtVkyxUr4PzBXBfewG4rOrzS5CVOvmq7efMgsQJuhCy5AoVhX0yYevefZrFI/Z/0HmVn9HxUuTuZw1/q7/Ek3EUS0Qyc0jPEdq/Q15XMyr/D6+eUDeiY26IOzGZ3utW4X72H4XJilvsUyQkmdzbJDDiVCoUCzpVWz6PLF1f6IZjmUkPNe4O4VL4tfwALnOKrRq6BxadVSc+tmVRCoQVuDM4DYap/JRkj7kD12/nqkJ1zCEHbskDT/hk9hXv/fUjeiKeUdps1RMKSZ2jF+30JRyEmi5wTjgCNdze8qwqGfgtVamusCDx0le4WClyx/6SOXYTm9bwYerZcFar+GaiZfgr/Om8hdKMahRsqmtjyyqeE5yjiD3ZZj6U3Yw3Vtxk3Td2Xq2d9BzmNg9Hcct7sA3o+LaB6jZDfqrccDrvzYDuSieIVEIIhkA2nKMmBAOQav9y5Phj6+upm0Lt+TJuWXZu0D/oFMeY1yPP74PwK/eeyBIcc1jS0H/cbJOHf4cGwYN3YvatpKLpwuBbDcJZO2jZCL6SHwurS02ec9A7x2nWhjL6WvQVJlNx44A5HQ08VvSBUNYzALpjbtEZUuKRWbTQlzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(4744005)(33656002)(7416002)(186003)(2906002)(8936002)(52536014)(9686003)(6506007)(7696005)(26005)(122000001)(8676002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(54906003)(110136005)(38070700005)(316002)(478600001)(38100700002)(71200400001)(5660300002)(55016003)(41300700001)(82960400001)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zm53L2c0U3RUQ09Seno2Vk9YNGpnZ3B6aW9NdldYdGxPOVR0ZzdLUE1tU0JP?=
 =?utf-8?B?VlpsdXQzelAwV0JLSnRPekVEbWZoci9FNFFGU0VOVFBoUnd6VElmZGpMSEJi?=
 =?utf-8?B?YlJlQTRjZC91K0Vxd0Z5YmhnQXJFaUJhUXZ4RlRpcGJFbG5LRmJzR2NNUDMz?=
 =?utf-8?B?TVByME1GS3YyMG1HVU9EdXFoMGVHUDNqbWxMNGZ6blZEWXUyRFpSWXZMTldR?=
 =?utf-8?B?SlJidHZ1RnFOTld0TnRyTHhBb1pzMDZZY1kzQVRwZkptSkphRjN6Q1JsL2tF?=
 =?utf-8?B?cVdRSjhGYU5uYk5DRE5heXVRQ1dKUmY2WHpPTXVBeWlNQ3JwWCtrSThYS3Ux?=
 =?utf-8?B?M1g5SHpxdXZuMjE2Rk00UEhzMWM2U2F3VEY5b0c3TUNIL0xEWXpMbjg1Z0Uz?=
 =?utf-8?B?VHJrNmFSNHQ3TmYxMDdFUjZHTk1Bc1hBSnVCUlBuUVMrSlZTVldMeWw1L2JM?=
 =?utf-8?B?dFBSeVVzaHFtd2V4WUI0dkxEUFdWcWg2S1FmQkFOQU1aM2FwbWpNY1Jjbklh?=
 =?utf-8?B?Ni9jSXc2bEkxUHdkZ0tscnRPQ0srMk5ZSmZNd2sxQ1c5enJEeDNveG1YakF5?=
 =?utf-8?B?SjQwTHBqVXlSbXNqc0hMMERFRVZsbnE4L1lqZEY3SkVkdDhXN3N6eFZLcnlB?=
 =?utf-8?B?WXZVb0d4TDFMbTQwbHI3ZzRMTWl3d0Q5YkloRFIyNzllKzRHcXRjSlRVeG5m?=
 =?utf-8?B?Q2NtL3I1OTNCQ2FXOWxUMFIxQmtFN0lIRlJQQ0VlOTFNSXEwQnk5SjZaZHht?=
 =?utf-8?B?VVVEcVU1OTRSM2RoWVBIQlRHb04yN1g2eGcwZEpPYTBsVGd4M29Bd1JIQUVR?=
 =?utf-8?B?OGEvS1dSMDNTTXpXdXdibThLWXhFZTJyUjhyelVnS1BtM3ZVQUE4WmZsU1NM?=
 =?utf-8?B?VFdyVGZEamMrUnNRTWl1aU9iVXA5VkZaR3pJb2dUeXpOKzJVS2JHTEJSNDZu?=
 =?utf-8?B?bndYNUlmNC8rTU9lRS9Jb0lVR2lXMGI2aW9hMlVxQlBQQVRjcEVxYTArV3JS?=
 =?utf-8?B?cXJuSHpNVHAvTThVYy9BK2g5VDJGb1J5VjRvZytJR0p2K2N4YVFyV3N2MHg0?=
 =?utf-8?B?cTlmSXVSU3VPUWNuTzhvSG1zZzhJd3lKYWlHTUtLY1lwcGo0UGFTcldHRWs0?=
 =?utf-8?B?UnZhT21jU1hpVm5XUnZkYW8yd0h1WVBGZmprVjlYVTR4VE5PZE1oaFZhMG1P?=
 =?utf-8?B?cGE0MmN3Mmw4WG80K2JOVmY4VW10cjMya2d1VjduT0FsMUhPWkVqeXg4U2ZX?=
 =?utf-8?B?Z0pRT01CcjhYeElIb09mTVdGczZBWjlXNEJySUVnRjdRbUNQbVU5L1lhMmpj?=
 =?utf-8?B?eUVPTHU5VHJyMFNVNE1IL0tmS1BlbjdLbjF3ZWlyY0krbjZMMHB6b2E0cVRU?=
 =?utf-8?B?cjc4VWx4eTNud3EyZ015UlQvcnNwNHVlMy9FUTFoMVZCNEwwMityekNFSFFP?=
 =?utf-8?B?cHZaTWxzMnNUcGRlcmdwckVDazVkNGI0emk5RWo0V2dWOGNScGlRMURjbVpF?=
 =?utf-8?B?L2pXRitwVm9uL0hDYlE5d0MxVTJ6M2MvQjBvTnJPcVFaNHJab2t1V2VuZ1Vy?=
 =?utf-8?B?ZkxLMXVKZS9KVkJOd0JhOUFHRXhDNkZNeUczSHpWOTVTSE4rNXBRdWlNcy9V?=
 =?utf-8?B?RDlHUE03d1ZvRURZbDRCajF3NFdWOEMzLzQ1b09OUmhRZVJRWWRKejlMc3FM?=
 =?utf-8?B?eTBHVWRjRDBpR2I1UHR0amNBS09NMyszUFlXdUhRd1Z3TEtieVNkZGpLbG1q?=
 =?utf-8?B?eS92cFpzRm8vOEw3RmNWNkFaVW5ZOFFPOVNyK0VTeFp4K1Q3K3Q1TldIS3lI?=
 =?utf-8?B?bzkzbGM3TkRkUHZBNkp3aExpQTNyUDc3OVlXdTVaMUR5ZjB0aEtpMkRKRTZ4?=
 =?utf-8?B?ZTR0d0ppS2VFQ1JxL2paRXdseGZQZXZzM1d0ZXF0c3NoS3o1Qkp1ZVFqYkFL?=
 =?utf-8?B?anhqdk9BcDhUZ1JjN3RBVjVES2t3eU4xOE1TZStEdm1VVnViNXZhNFpFcUpk?=
 =?utf-8?B?cW10Qm1JQXg3Tkx0RGFQZnE3V1dpSnJucm41NS9kLzBOL09ZYzYrS2NWbDlr?=
 =?utf-8?B?RFRRSG8xUTlubnFMSytRSG9GVGJpQWVaNktabWlWT0wxWmEvOFZ1UmZxR3Qv?=
 =?utf-8?Q?m+BM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808e1703-460f-4451-59e2-08daa25c7622
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 20:52:02.8229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wuJZA1wOwD0/vUx2FB82Hd38azELFLbzHJiSkibqCtj3mfJfHu8csuIos1aGs+cctOpRSiQruAKcanIHgumgbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6551
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHBhdGllbnQgZXhwbGFuYXRpb25zLg0KDQo+IFNURVAyOiBJbiBJUlEg
Y29udGV4dCwgZ2hlc19wcm9jX2luX2lycSgpIHF1ZXVlcyBtZW1vcnkgZmFpbHVyZSB3b3JrIG9u
IGN1cnJlbnQgQ1BVDQo+IGluIHdvcmtxdWV1ZSBhbmQgYWRkIHRhc2sgd29yayB0byBzeW5jIHdp
dGggdGhlIHdvcmtxdWV1ZS4NCg0KV2h5IGlzIHRoZXJlIGEgZGlmZmVyZW5jZSBpZiB0aGUgaW50
ZXJydXB0ZWQgdGFzayB3YXMgYSB1c2VyIHRhc2sgdnMuIGEga2VybmVsIHRocmVhZD8NCg0KSXQg
c2VlbXMgYXJiaXRyYXJ5LiBJZiB0aGUgZXJyb3IgY2FuIGJlIGhhbmRsZWQgaW4gdGhlIGtlcm5l
bCB0aHJlYWQgY2FzZSB3aXRob3V0DQphIHRhc2tfd29ya19hZGQoKSB0byB0aGUgY3VycmVudCBw
cm9jZXNzLCBjYW4ndCBhbGwgZXJyb3JzIGJlIGhhbmRsZWQgdGhpcyB3YXk/DQoNClRoZSBjdXJy
ZW50IHRocmVhZCBsaWtlbHkgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCB0aGUgZXJyb3IuIEp1c3Qg
YSBtYXR0ZXIgb2YgY2hhbmNlDQpvbiB3aGF0IGlzIHJ1bm5pbmcgd2hlbiB0aGUgTk1JIGlzIGRl
bGl2ZXJlZCwgcmlnaHQ/DQoNCi1Ub255DQo=
