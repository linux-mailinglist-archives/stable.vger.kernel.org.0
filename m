Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4117521836A
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 11:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGHJWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 05:22:11 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:31610
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726144AbgGHJWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 05:22:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfN1GBFfMwkPqDjj1lX1IYvau8iDpx7PzJbAczqYJKuEzRW5Mz2KyrWCNOM/68+VX4URnLVhSEpNIxEbSZJ4P1KLacfdQ7zwJirLDrbcyfxqg3w/jFcqNBgT6y/L6v7Tm952ZdQLo48NEfbzwCisN7fXRtWgYru2epEE3Pb8EQ6fnUmhyl//eKFC58ycwWugiarao3UqHgDvH9TL039GWgas6hQbonzIrveKiZ7cpVqiXIvzfjg3dtHxtHcm1cnN7fZXyhMDd0q8vkGqN4vJ+c+I1czB5owpRq+0mjGrD/8rF4m9wpSp5nqP21WGEnFsagMTtF2800DvT2BbPEoLeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECjDcugffsXkqOI1Vt93s/6be0nCSsCPkuXALqODjWo=;
 b=ZWziv2MniWMwoJ7ki18fSirh//ZF6Iht4yEmM12l/EmN0+Saeaed835l8JlM8Hl5xLYJyUdHulW5QVtWPHTBoo1Lo9bDLe8sbBb8p+zDjcWfIMDfrEtbd2BUYWyHobQr4r7cerEYChrmXTnqLHGDWEtr5HKgzjoOQSFae5WanpItvKyVGY+5wklHk/c5XQ4heHZb5p+r7MZRv2h4MZbNI7ZbYinSNQY/meTgKcck4a0rhnMnwuZhWeeBube/XGWyfZ/OM4lUqw9xZPJaFXhIgPQbO3s2pHg8om2g4pj0j9Zk33NL7Dq8GYxAK7koTU9S1RHe3hXT/j1w3+FPwGiegA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECjDcugffsXkqOI1Vt93s/6be0nCSsCPkuXALqODjWo=;
 b=w2lcFkzTLm2oZdaNbitiaSxr4P0cO5HvBulYB9QyXhPqpINWP87Mym6Clg2W3wxKLz2e/JP8jlTEhu+N+UvaItURhqvnFXp3kXj9rjSLJK/ZCw3+NW12jhVH2cDq9KsdkA/creljB2zOo3FvIVxdtiwt+OJRGad5E3OLxszS1Dc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4110.namprd12.prod.outlook.com (2603:10b6:208:1dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Wed, 8 Jul
 2020 09:22:08 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 09:22:08 +0000
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        lepton <ytht.net@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <b8e6d844-f096-8efc-1252-ef430069d080@amd.com>
Date:   Wed, 8 Jul 2020 11:22:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <159414692385.17526.10068675168880429917@build.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0701CA0040.eurprd07.prod.outlook.com
 (2603:10a6:200:42::50) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM4PR0701CA0040.eurprd07.prod.outlook.com (2603:10a6:200:42::50) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Wed, 8 Jul 2020 09:22:06 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cabc73d7-de41-4139-a5b7-08d8232062e1
X-MS-TrafficTypeDiagnostic: MN2PR12MB4110:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4110396FDDDB330D72C71C2283670@MN2PR12MB4110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0w+9RGuC5YTmqd2+qV+yoJbEcWiQ5lXsN5q9yIHHz0Tq0bhjo8i1DkJVcLGveFMlEGK906XKDltVKDVf/p7HIufdC73TLVp/Z3pRyeTYNtCOZHbgMc+Tr7+11AzMvmFeA3+uANIYYsqDRh1HOgVdhd8sdGRUprrjuec1gSFI4qxgKFOjqMJg+y54N/SP7Bvvwi6wpHTLCRgDrKUHUlMgdhBzENsuKx8HGo+UG2vWPKpiu6Z6vDoCRydniJUw9a6TzV5/ws4p3CgimOMHYiafixY7gIbtIQnylNHNYh4y1k6PeIBI9QjEbceI8CFZmIoLFAYsIi+D5nf8kLsE99eexaKq3QdgEYaBxR3vTZHCkQxybcupJMU+cgHDiJoUj6DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(52116002)(31686004)(8676002)(8936002)(2616005)(83380400001)(66946007)(66556008)(53546011)(2906002)(66476007)(110136005)(36756003)(5660300002)(316002)(4326008)(54906003)(6666004)(478600001)(6486002)(16526019)(186003)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pyolc4F6Sonltk2vDTp637iLEY3hjmUFf4A48be3geTgaQeMptSAYLmpoMsdM0eovPT850/bOp3tN2MzyNTOFzeinX9Pp/zYVEDiPYEbZEoeTicTVU8jjaCchMjy9v0RfL1+y1OpxxBOYddJnPJaUN76ZA7IkQoQmMNSYzw/fMp7KXjp7+Ci4f5BJpAWJGOzWt3iYV4XOvJ6HbFWDAH8i2n/A2rhSrR5kMMrK+fqA6HF6l2hEYTFgi7dlxa1quqrNcnJ8y6vO/8+aCvro/1Tl5mDdhsjFRolDsf6lyUsab4bnrMMnVjH5qE1XObxKnHULQuonkbBD+VxSCVzwVVATY91gD0EZ3YV0uvlYf37bWZgU87pnJH+XaTpezHqAAv3aAomAYluyABBBt8r/6lNnTn0IsffZt1qjM/uej9rf1Vss/AejbI0mpzP9paJ/sWPCG0MPg2y709S+RcrdD86z413VgEBRZMqRgmNK/6SpTm0EELrrqXwRosx4jw/K5alpnnA+CBGzKwFqseDvvSCLqRaN91g8k+7nQBC2nY6S+mQKoKfwb7vO+0kmz6dOJnM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabc73d7-de41-4139-a5b7-08d8232062e1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 09:22:08.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4DbIhJID+XaOldL67sw03ckJvzhnJXJCGzRh5Z325AAUGmNmZ7rj4Nbk4W83ULE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4110
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.07.20 um 20:35 schrieb Chris Wilson:
> Quoting lepton (2020-07-07 19:17:51)
>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>> Quoting lepton (2020-07-07 18:05:21)
>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>> If we assign obj->filp, we believe that the create vgem bo is native and
>>>>> allow direct operations like mmap() assuming it behaves as backed by a
>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
>>>>> not always meaningful and the shmemfs backing store misleading.
>>>>>
>>>>> Note, that regular mmap access to a vgem bo is via the dumb buffer API,
>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>> What do you mean by "regular mmap access" here?  It looks like vgem is
>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
>>>> drm_gem_dumb_map_offset
>>> As I too found out, and so had to correct my story telling.
>>>
>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb buffer
>>> API] as opposed to mmap() via an exported dma-buf fd. I had to look at
>>> igt to see how it was being used.
>> Now it seems your fix is to disable "regular mmap" on imported dma buf
>> for vgem. I am not really a graphic guy, but then the api looks like:
>> for a gem handle, user space has to guess to find out the way to mmap
>> it. If user space guess wrong, then it will fail to mmap. Is this the
>> expected way
>> for people to handle gpu buffer?
> You either have a dumb buffer handle, or a dma-buf fd. If you have the
> handle, you have to use the dumb buffer API, there's no other way to
> mmap it. If you have the dma-buf fd, you should mmap it directly. Those
> two are clear.
>
> It's when you import the dma-buf into vgem and create a handle out of
> it, that's when the handle is no longer first class and certain uAPI
> [the dumb buffer API in particular] fail.
>
> It's not brilliant, as you say, it requires the user to remember the
> difference between the handles, but at the same time it does prevent
> them falling into coherency traps by forcing them to use the right
> driver to handle the object, and have to consider the additional ioctls
> that go along with that access.

Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an 
importer is illegal.

What we could maybe try to do is to redirect this mmap() API call on the 
importer to the exporter, but I'm pretty sure that the fs layer wouldn't 
like that without changes.

Regards,
Christian.


> -Chris

