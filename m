Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69519218A41
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 16:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgGHOhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 10:37:46 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:6141
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729468AbgGHOhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 10:37:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kubu3IWEfxIN+OPie0U1Kiwr+qB1CAdeyu2u2iC/yAGN0zmmzN8C9T4uNpUQ/Mi3DAAuU0mHk+tkDH4uSV6gVNP2byIgAPHBfRNA+erMNYKe0zrRMswdJg2JEwPLKi2oHoy1ObQOodMXcU+aU7J3Nl53ej5QOm9COIAdhySxIckoE2SjhTge3c9dMrzrK0vvkEp0WWZXH6YrFZXtZqVvOUVhZQLMGMe08SiwJv+w9+pfqkGNgYdu8QwYYRoqDwD824/eoejtaKSWSjsIzPd1pmByfVpA1HJGUnGSt1YQ1zoC9mo/On51+TUbeGh6CiY5mm3G7WajSwPbB+r9OEn+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckqzsVYy9mjGbHscVpg2kEizuYZXDxUBiUU1JoJA1jY=;
 b=jPZyBeFrgVbWUXBepI+2GUzDrvgUfjfxR6C/hBEd+xQFfY6RjJCgE82keNkteKU3NBHqrZ4xEoD0CTr1pBPBHfEX9/LmJ4Ou/E/mqvBPQ14TffNHqIt4gaQ9JXh+e4kUcR2kGaVLSr4jg6Ir6S5Kg0N4ziQKHMWUbqtMz/SNFxXP/xX4CfGifnT4Ll4PZQN1vECLUDwUq01Cwk40P7qFKMmdYbrReL2tJBZ2JBA+8Ix8iu9mUQQBW10xfzS49nnTwbm1lI9Jc6Muvs+1p3FB9VfoaQXvblbUfT8Nvvvm3+/eI100cplIN4IcMquMBMQy/QxLkynv7JGo4sBkcXXzFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckqzsVYy9mjGbHscVpg2kEizuYZXDxUBiUU1JoJA1jY=;
 b=Hf+F6dA1OoIudiRVLoN5MFMeptXI2lGcAcjHSBQfx3kL/rPfLdMEU2ZLIybWLH5TWsz8EkuOiwCIgQqZSzXHZCfHiOaKUgSQ7bQR+OVpasufs7PsBjDr40p6XJZJ8YhmHnuIWfl3W8tbkOaLlnjYc95SmEcowVXJvyTaz2/LEOo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB3727.namprd12.prod.outlook.com (2603:10b6:208:15a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Wed, 8 Jul
 2020 14:37:43 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 14:37:43 +0000
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        lepton <ytht.net@gmail.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
 <b8e6d844-f096-8efc-1252-ef430069d080@amd.com>
 <20200708095405.GJ3278063@phenom.ffwll.local>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com>
Date:   Wed, 8 Jul 2020 16:37:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200708095405.GJ3278063@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR03CA0070.eurprd03.prod.outlook.com (2603:10a6:208::47)
 To MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR03CA0070.eurprd03.prod.outlook.com (2603:10a6:208::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 14:37:41 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4ccf0b2-5d3a-4abc-ea8d-08d8234c7910
X-MS-TrafficTypeDiagnostic: MN2PR12MB3727:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3727726DDDE99B3CBF61FE1683670@MN2PR12MB3727.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3tMs2og2IM0GfkNeqaTMqmp7365hyllJ9dKQ8nR4/FddlbDRcNIeUq+CatKioYk2xUY8PpLF1aGQQSXbCgIh7kNgRP9o8zkOvcUolipEdh2zI1CMU/IqoCGY8S7nQ+nsVE5agGXMcmBCJchPdrCvxxiezE1l4zUojutbJRjwrQ5CT5YBIoj3Ab8VHAjwkpKpYdH5eLPUhmOIVavwNyPwyvZ/xnPdU85CwAnpV9aSWlP/MV+PPT7NJiDU1rrHJjW+v7IRbt1ndcP9EZDyB11wocM6hW6KpiPnLyL3MXTCOK0HLp7QG6+bMAl55Dthp8TzGj1eN/FuWxBeaUyjnHNNwR+35sTwf3HEW2+XB21InzDZ5+QjwAKasJ34sLtYO+yq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39850400004)(66946007)(6666004)(6916009)(52116002)(66574015)(83380400001)(31696002)(2616005)(316002)(36756003)(86362001)(8676002)(5660300002)(8936002)(2906002)(66556008)(66476007)(31686004)(478600001)(54906003)(4326008)(6486002)(53546011)(186003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: t8B2CODYEe7nffWGbzody2iNWbq2a/QSKtbOFn9KhoQOJv7j79SNrGlZnv6PG4v9ljIyWXJeD4UWIJOogpSjsTRamOR/JabeeybTQpYJsTprG4v+NAVErYlWmWhTZduygqV6Duub7mmb+yi+IXyzNfRI7Pa2T2PcpPCjQLp2PR7GC7Ebqp20Yg6ZnQhrMS8lbcVg5HCeC8CPi0+LN7FJZbzgmPcAqFCVxpcfdcrglKog8M79FMeJug5qic8HROc59CefG1uFJ/SS6e4XCLoxyJSvOUCx0ICTOqWF1xmripGGnw0/zkpUUbcBRBTHl3Ih2vBFjhoQM1sc5pA8SkZjPzmqjtUT4Xe9Q/7pFbGfIVrBgbnMrav+g3T274e2I98vSHukJ/2pf9KlYpPQcjPYzcy34Quu4HnYagG0Z1+vl014N+6NiSo446y/E8nr/0a5yGsR2tM8BycbdkLPc78XTRXyqapZdevB2oIucp+8jrZP5oRLesdazxqXMzribnNaVcHvNI8AXL6T41NmQ4ottdzw4CKjC643Nkaw/j8gJRar+Y77AFLwWWTDgGAw1JxG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ccf0b2-5d3a-4abc-ea8d-08d8234c7910
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 14:37:43.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Wv40aTx8J7gduE/7rs/oEYdZWt3t1/SUxNrjbKmIRASlRsRQIdy5yNbb5B3CcGl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3727
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 08.07.20 um 11:54 schrieb Daniel Vetter:
> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian König wrote:
>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
>>> Quoting lepton (2020-07-07 19:17:51)
>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>> Quoting lepton (2020-07-07 18:05:21)
>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>> If we assign obj->filp, we believe that the create vgem bo is native and
>>>>>>> allow direct operations like mmap() assuming it behaves as backed by a
>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
>>>>>>> not always meaningful and the shmemfs backing store misleading.
>>>>>>>
>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb buffer API,
>>>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>>>> What do you mean by "regular mmap access" here?  It looks like vgem is
>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
>>>>>> drm_gem_dumb_map_offset
>>>>> As I too found out, and so had to correct my story telling.
>>>>>
>>>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb buffer
>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to look at
>>>>> igt to see how it was being used.
>>>> Now it seems your fix is to disable "regular mmap" on imported dma buf
>>>> for vgem. I am not really a graphic guy, but then the api looks like:
>>>> for a gem handle, user space has to guess to find out the way to mmap
>>>> it. If user space guess wrong, then it will fail to mmap. Is this the
>>>> expected way
>>>> for people to handle gpu buffer?
>>> You either have a dumb buffer handle, or a dma-buf fd. If you have the
>>> handle, you have to use the dumb buffer API, there's no other way to
>>> mmap it. If you have the dma-buf fd, you should mmap it directly. Those
>>> two are clear.
>>>
>>> It's when you import the dma-buf into vgem and create a handle out of
>>> it, that's when the handle is no longer first class and certain uAPI
>>> [the dumb buffer API in particular] fail.
>>>
>>> It's not brilliant, as you say, it requires the user to remember the
>>> difference between the handles, but at the same time it does prevent
>>> them falling into coherency traps by forcing them to use the right
>>> driver to handle the object, and have to consider the additional ioctls
>>> that go along with that access.
>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an importer
>> is illegal.
>>
>> What we could maybe try to do is to redirect this mmap() API call on the
>> importer to the exporter, but I'm pretty sure that the fs layer wouldn't
>> like that without changes.
> We already do that, there's a full helper-ified path from I think shmem
> helpers through prime helpers to forward this all. Including handling
> buffer offsets and all the other lolz back&forth.

Oh, that most likely won't work correctly with unpinned DMA-bufs and 
needs to be avoided.

Each file descriptor is associated with an struct address_space. And 
when you mmap() through the importer by redirecting the system call to 
the exporter you end up with the wrong struct address_space in your VMA.

That in turn can go up easily in flames when the exporter tries to 
invalidate the CPU mappings for its DMA-buf while moving it.

Where are we doing this? My last status was that this is forbidden.

Christian.

> Of course there's still the problem that many drivers don't forward the
> cache coherency calls for begin/end cpu access, so in a bunch of cases
> you'll cache cacheline dirt soup. But that's kinda standard procedure for
> dma-buf :-P
>
> But yeah trying to handle the mmap as an importer, bypassing the export:
> nope. The one exception is if you have some kind of fancy gart with
> cpu-visible pci bar (like at least integrated intel gpus have). But in
> that case the mmap very much looks&acts like device access in every way.
>
> Cheers, Daniel
>
>> Regards,
>> Christian.
>>
>>
>>> -Chris

