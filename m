Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EFE489D25
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 17:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiAJQIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 11:08:25 -0500
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:26382
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236654AbiAJQIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 11:08:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPTUAW0YIMc8n09JQSzccLACTA1V8vU6eeXKM7ocq9u7EK9CF7TXe7pOnxXws7oFe0WYXw/Zzo5MejSwnXlxJc52FwH156EqwweUjsSCdOTEExmw3l/kovIe9eBraQqaGW5CJyOxU/m3iCxhDWzbnnlVM1ZnBFeYhbFh6jtYiDJtqJoxi0ZHrWHFG/IXWgSbkyLzqrj30o3ilM8j9LxlcckMdwMWscBf10gSVln2Nnhv+Dh46o+zowsAZTsAfI+poIuwaDSY107o75wE/+DHXKdBTIcpSVof5LS2GoTzSBsGFtUoSK1iKBxqvg3KOFF3PcUbG1OKbSLwQjaqOAgXgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d52QZMdYPDQVfN55zTXTb6nULEKTb8UCqNiTQjJ0bSM=;
 b=jUaB326fAFol+Yge4HVhhsFXxWE2c1OR3hTDoESEcE9hO0vmQkG1GggSm98hrgbTpAmGGmkXo9YVW6n1L+jJ39hO3Yxmu/ACi7Xzxt8wE7ZXOTwLmD6jbHzntHmi7aFw3yE138EiU6gz9yFqPlK7Icl+MyX5bFTEjXBeXcBboeS4UcFlF5Nyzo77ZDuuwSqXfZXfJkxeI78rF4iFj2cQXMMKeLZobdIg7Crztn5wD9gHMZbhgYdfDPjvawEja/l5qZn/D9/Rhl07gMjEeKNH/OsLvFfAdQba68o5E6BsBkb6H72/0+/F9noJh+VwuJDyJ1XvHhbih15ipTUFgpU+mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d52QZMdYPDQVfN55zTXTb6nULEKTb8UCqNiTQjJ0bSM=;
 b=Z58DDYbk983cPZ5pRk18qqgRq4eLmlFZu0+inqnU220fmTskhkUuA7hVCRvwuxcT1jLPO6q75RPQxHjeSjNTDrcs+nbArovU/lBdSrIhWXFHckyWOKwnIhHB7IuYnwcL3ZFC8CK5kaB6ZVtkFgetvKf2sUbTSI8j9i3MP2SRQNk=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5045.namprd12.prod.outlook.com (2603:10b6:208:310::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 16:08:22 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::99d4:4d4f:653f:61be]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::99d4:4d4f:653f:61be%4]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 16:08:22 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Len Brown <lenb@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Chen, Guchun" <Guchun.Chen@amd.com>,
        "Grodzovsky, Andrey" <Andrey.Grodzovsky@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Thread-Topic: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Thread-Index: AQHYBYR7VOg0MzhXpUSaIqoHT+4q4qxcbLeA
Date:   Mon, 10 Jan 2022 16:08:22 +0000
Message-ID: <BL1PR12MB514403767AC6BC6CD617674DF7509@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
In-Reply-To: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: Guchun.Chen@amd.com,Andrey.Grodzovsky@amd.com,Christian.Koenig@amd.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-10T16:05:34Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=3c0575c8-d3c4-447a-b51d-210bef0591bb;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-10T16:08:18Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 3d7b4787-efef-4455-b9a6-85ebdab313f7
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 331d4a16-6718-4023-717d-08d9d4536cf8
x-ms-traffictypediagnostic: BL1PR12MB5045:EE_
x-microsoft-antispam-prvs: <BL1PR12MB50453F9518249EBF8B66DA5CF7509@BL1PR12MB5045.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:389;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bP/5ncQ8oOxmm8w4AnuiW2GNvk8tiChdpPxVw5F7EARk6H2YKQSDOdBO0nSQMLFmWfX6V6FS61N7uBxntOe9SEWrZkdXIseAsvtzN4eKze8tgFU0VQDVPmPByfBBgSeUqzZ+pIyE8Ylr5eBCTp/V2QUulyDqdF0qKiHhqmshq0E2S5jg3bbSaaUlZpO+QI8MEvFbD5TXxye7LTKV0ku/uIjTlp/IhWy+JQ68H2lhOTAyZmHIWN7ARF2Pr4vUlZakwCQYCBWp9FNXO5wQ05CQApcBHF/9mLNPeOhgTriqSTdtuPEzKruXWxNUOfRLwW7oygDU0Ft8v6snT+BUs8BaNZ3j+ZivDO7AX8YBlqTj3FOpFLdGXuUkXWTPd8gJ5fuhAWxiepbqu1MHhFCZraaNUi4EYkMXdyh77kbzSGrnkcYs6KfR2kblgJpsp9aWw5HLBFmjtNprRfnv87AATtuM8Jvq4Mv+cMWvWQE/yDc6ase5L/P7vED0T+UsGBUNSdyJh7a/WKCsEHi5t5gBreBwIE9p0RKWh08bigNnMlp76VaUaIWGXtjIunoUXmWnSFhWRNrKsyie/qbHXLPrm6W/V0aS70AawSLRuwFrUF3hFkqJdxAFWne9YmEjorzNnx1HD5OC64Lhf40aq5/iULWX2pyDBwEWneUpyAShi3VgrD5o/hL7VL9bW1c96l9aENS1GvaVga5prZ8S9w0otWKpbxiMhbulfxueKfLCP8VLZh9qB9mYHuldQ04wYQOWvbUJQJifnzchrGrHbKAlrB2lVU3fl/TPYhctbuUXoK1VKtI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(186003)(110136005)(6636002)(4326008)(966005)(33656002)(7696005)(38070700005)(5660300002)(52536014)(508600001)(6506007)(8676002)(55016003)(53546011)(83380400001)(2906002)(45080400002)(71200400001)(122000001)(38100700002)(76116006)(26005)(8936002)(86362001)(66446008)(66476007)(66556008)(64756008)(66946007)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YesjHL1+aZMD74CusRnOf2In6yWnjp0wwoPwvyUqKS1WJSmuPRzHJg5pbOQ4?=
 =?us-ascii?Q?6zOzlQ8VWTyy5Ro97jySyURvPec0rSH03SFYx3rf/4cKIGiAd7H2/X1PToM9?=
 =?us-ascii?Q?dpFFGMpRLYgBIfsdX7d3Oez3e6LBkMzdekRMQ9XvqL+Cqj4IqyK52nSHXsl8?=
 =?us-ascii?Q?e4bNk9XthdSOTF9BTzQE4p9b4PPzQQe08AxB5VpPj/uNSJuzvj6d30vuqht7?=
 =?us-ascii?Q?kLE0fX7jjbhq8ZYFYuW/H2vKbmcRW+a4ZJs819dtb5qHovYiSvD8uTagApKq?=
 =?us-ascii?Q?LuBXKfkCavKc7S0BYeG1DzZy7VC/O0/zZYP9CG/ferj0HsoOlM6rsif9PuUr?=
 =?us-ascii?Q?iMxO98/0t6dHNBrBPfgKW2eIEbPUaneW0oz2vdhiHdSRDFGPvsi4mNPQ/uHv?=
 =?us-ascii?Q?H/IggV4Tw8UGxhWcC72mjEadCs7BKRzGUvSmUrin0HkGbhhJ7T9umQ/FcuJ2?=
 =?us-ascii?Q?y+jmhzJwnuXiAdXrGT06aU8cOIk/AzWOiIPN16+s7E6shxUinXiT0798MTY0?=
 =?us-ascii?Q?2JUip2nPwOuv5VeDR7zWUH821+ggthZflq+O2Yx6pmuhSogPtXiNiCQHbrVd?=
 =?us-ascii?Q?Xp9+HQNr23die2AL5B2Eh6I1k1jxmckm5r9WxLmaGetY5fxmOszLPjiYdcuQ?=
 =?us-ascii?Q?6tkW2vbifIBJwrSiD7sjt89BWCJ4w51eEntjpF3q02qbiFtdM/pLr6RRw+LO?=
 =?us-ascii?Q?o5ZBcvaJA88F8vpauQWWVz58maho5ijBiLwL2AK6flq4oTWHfhpwaGkCKwjk?=
 =?us-ascii?Q?laccooEClDN+eqeOkkLTI5tJ2gY2OXeVLuoPBgoqhGMVByjiQR63k/0Y0brj?=
 =?us-ascii?Q?af0hX1ShTg64NKA4r9BJoslOrkxzWPg7O1b45/Jjmw8npdIP7fefHJiJok/j?=
 =?us-ascii?Q?JStuUoz2cAivLyCRLgLC8e5xj4ReJtBMfeIFWlQea6hD1pq2vsQVtkHJujs4?=
 =?us-ascii?Q?SbSNuQHJqBUW7YCIX10rpfk2b/CpTcOyObVhzidh4UGuTxa2Kc0DEPW469+D?=
 =?us-ascii?Q?2zt/Vx9HH5TAXqbyJgJ7AzLSc0rG8n8mNDgKU5YKm+zP+HUicJDJpSwkQ5Ek?=
 =?us-ascii?Q?aRZxUPzaCd1Wss588TfeW7nkyzT3vfqfcVOW2dVxFGeVrRKSTbFF/TLE3zaT?=
 =?us-ascii?Q?MlDOX+W2WmEEnOAKhYJKOH4xz26h+hdflhyD8AF7lhB71aw+a6DTLlf/3cGd?=
 =?us-ascii?Q?N7SlPI0g0+hPuxTN0Ep/seIRi6dEyc61n+2Xjt9pYSkH0Ffst1iHcg7Wr6wV?=
 =?us-ascii?Q?+ByBE2nYQQ2FPQgUsHzPfpmdOExqk0kp6IgvN+NC5Y0YY5R+LypLhbKIablA?=
 =?us-ascii?Q?HpJaoB7+1+bAdfKgHc0bEvrdzsNe3j6yeXYSgrLI35pREFlhAqA5yWlDS1bY?=
 =?us-ascii?Q?ofSi/pEIqwDv88bSoLDqGv/SibNKbLIO2oo7s3LUwRUCZ0f2lNQgYaagV3Hb?=
 =?us-ascii?Q?Q70KDIfJ6rj7+hAe1lR2OdDrAKSJGIhFVTpki8rkm0peiOuHYyWYrrSVIuD6?=
 =?us-ascii?Q?H7ekz0PMHko3acsuCD40IOsBh95vUli1Ue/fB6t1r8ewnHXxXwE0eNlvld4j?=
 =?us-ascii?Q?8kJn+nZjuuzuC6gsuu98vgY3iJMpbnlDVVAejE4VQ3bN8ScYZA2krtY80UR1?=
 =?us-ascii?Q?9mFeDMzYeTq1SSdGeDJUUnI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331d4a16-6718-4023-717d-08d9d4536cf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 16:08:22.3669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByNFWfnZnrpCo0H8tLTb9zhJvLEc6K//OuSHP7j5IuWCKVLWYR3/P9h13MivwcxOPfpmYYXOPVtCTu5PieZ+yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5045
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Len Brown <lenb417@gmail.com> On Behalf Of Len Brown
> Sent: Sunday, January 9, 2022 1:12 PM
> To: torvalds@linux-foundation.org
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Len Brown
> <len.brown@intel.com>; Chen, Guchun <Guchun.Chen@amd.com>;
> Grodzovsky, Andrey <Andrey.Grodzovsky@amd.com>; Koenig, Christian
> <Christian.Koenig@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> Subject: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
> calling hw_fini (v2)"
>=20
> From: Len Brown <len.brown@intel.com>
>=20
> This reverts commit f7d6779df642720e22bffd449e683bb8690bd3bf.
>=20
> This bisected regression has impacted suspend-resume stability since 5.15=
-
> rc1. It regressed -stable via 5.14.10.
>=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D215315&amp;data=3D04%7C01%7Cal
> exander.deucher%40amd.com%7Ccf790be4827f4df9f2d808d9d39b81af%7C3
> dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637773487569442716%7C
> Unknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJB
> TiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3DAX0TXkyoMhy%2BZqE
> VgRSWMkKd5nPa4WOv%2B1FZHLSErSw%3D&amp;reserved=3D0
>=20
> Fixes: f7d6779df64 ("drm/amdgpu: stop scheduler when calling hw_fini (v2)=
")
> Cc: Guchun Chen <guchun.chen@amd.com>
> Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Len Brown <len.brown@intel.com>

@Chen, Guchun, @Grodzovsky, Andrey, @Koenig, Christian

Any ideas?  What's the consequence of reverting this patch?  Didn't this pa=
tch fix another suspend/resume issue?

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 8 --------
>  1 file changed, 8 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
> index 9afd11ca2709..45977a72b5dd 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
> @@ -547,9 +547,6 @@ void amdgpu_fence_driver_hw_fini(struct
> amdgpu_device *adev)
>  		if (!ring || !ring->fence_drv.initialized)
>  			continue;
>=20
> -		if (!ring->no_scheduler)
> -			drm_sched_stop(&ring->sched, NULL);
> -
>  		/* You can't wait for HW to signal if it's gone */
>  		if (!drm_dev_is_unplugged(adev_to_drm(adev)))
>  			r =3D amdgpu_fence_wait_empty(ring);
> @@ -609,11 +606,6 @@ void amdgpu_fence_driver_hw_init(struct
> amdgpu_device *adev)
>  		if (!ring || !ring->fence_drv.initialized)
>  			continue;
>=20
> -		if (!ring->no_scheduler) {
> -			drm_sched_resubmit_jobs(&ring->sched);
> -			drm_sched_start(&ring->sched, true);
> -		}
> -
>  		/* enable the interrupt */
>  		if (ring->fence_drv.irq_src)
>  			amdgpu_irq_get(adev, ring->fence_drv.irq_src,
> --
> 2.25.1
