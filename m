Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649C621A16C
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 15:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGINzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 09:55:02 -0400
Received: from foss.arm.com ([217.140.110.172]:59860 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbgGINzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 09:55:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC32A31B;
        Thu,  9 Jul 2020 06:54:59 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BBB93F73D;
        Thu,  9 Jul 2020 06:54:56 -0700 (PDT)
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Cc:     =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>, lepton <ytht.net@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
 <b8e6d844-f096-8efc-1252-ef430069d080@amd.com>
 <20200708095405.GJ3278063@phenom.ffwll.local>
 <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com>
 <CAKMK7uF1nXT-q-rJK0s2yUQa8h8qJmzO=p-ouzvXVQ5HgkE9Qg@mail.gmail.com>
 <ea2ba563-11ba-efc3-44db-ae83920225d6@amd.com>
 <CAKMK7uEA65DT=7Qxku5Mvdcm6ii9qnyeR03Es+E-oCsxXkJBmA@mail.gmail.com>
 <CAKMK7uHe_dZvdfEx7Sd73QRNFPpDoTGVo-=BcU8cRwFhUVRtHA@mail.gmail.com>
 <bdf4b521-eb21-3381-ee06-98eb3b1cbbc6@amd.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <856a735f-0ed2-bfac-481e-e88304f14dff@arm.com>
Date:   Thu, 9 Jul 2020 14:54:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bdf4b521-eb21-3381-ee06-98eb3b1cbbc6@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/07/2020 09:48, Christian König wrote:
> Am 08.07.20 um 18:19 schrieb Daniel Vetter:
>> On Wed, Jul 8, 2020 at 6:11 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>>> On Wed, Jul 8, 2020 at 5:05 PM Christian König 
>>> <christian.koenig@amd.com> wrote:
>>>> Am 08.07.20 um 17:01 schrieb Daniel Vetter:
>>>>> On Wed, Jul 8, 2020 at 4:37 PM Christian König 
>>>>> <christian.koenig@amd.com> wrote:
>>>>>> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
>>>>>>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian König wrote:
>>>>>>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
>>>>>>>>> Quoting lepton (2020-07-07 19:17:51)
>>>>>>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson 
>>>>>>>>>> <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>>> Quoting lepton (2020-07-07 18:05:21)
>>>>>>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson 
>>>>>>>>>>>> <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>>>>> If we assign obj->filp, we believe that the create vgem bo 
>>>>>>>>>>>>> is native and
>>>>>>>>>>>>> allow direct operations like mmap() assuming it behaves as 
>>>>>>>>>>>>> backed by a
>>>>>>>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
>>>>>>>>>>>>> not always meaningful and the shmemfs backing store 
>>>>>>>>>>>>> misleading.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb 
>>>>>>>>>>>>> buffer API,
>>>>>>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>>>>>>>>>> What do you mean by "regular mmap access" here?  It looks 
>>>>>>>>>>>> like vgem is
>>>>>>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it 
>>>>>>>>>>>> doesn't call
>>>>>>>>>>>> drm_gem_dumb_map_offset
>>>>>>>>>>> As I too found out, and so had to correct my story telling.
>>>>>>>>>>>
>>>>>>>>>>> By regular mmap() access I mean mmap on the vgem bo [via the 
>>>>>>>>>>> dumb buffer
>>>>>>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had 
>>>>>>>>>>> to look at
>>>>>>>>>>> igt to see how it was being used.
>>>>>>>>>> Now it seems your fix is to disable "regular mmap" on imported 
>>>>>>>>>> dma buf
>>>>>>>>>> for vgem. I am not really a graphic guy, but then the api 
>>>>>>>>>> looks like:
>>>>>>>>>> for a gem handle, user space has to guess to find out the way 
>>>>>>>>>> to mmap
>>>>>>>>>> it. If user space guess wrong, then it will fail to mmap. Is 
>>>>>>>>>> this the
>>>>>>>>>> expected way
>>>>>>>>>> for people to handle gpu buffer?
>>>>>>>>> You either have a dumb buffer handle, or a dma-buf fd. If you 
>>>>>>>>> have the
>>>>>>>>> handle, you have to use the dumb buffer API, there's no other 
>>>>>>>>> way to
>>>>>>>>> mmap it. If you have the dma-buf fd, you should mmap it 
>>>>>>>>> directly. Those
>>>>>>>>> two are clear.
>>>>>>>>>
>>>>>>>>> It's when you import the dma-buf into vgem and create a handle 
>>>>>>>>> out of
>>>>>>>>> it, that's when the handle is no longer first class and certain 
>>>>>>>>> uAPI
>>>>>>>>> [the dumb buffer API in particular] fail.
>>>>>>>>>
>>>>>>>>> It's not brilliant, as you say, it requires the user to 
>>>>>>>>> remember the
>>>>>>>>> difference between the handles, but at the same time it does 
>>>>>>>>> prevent
>>>>>>>>> them falling into coherency traps by forcing them to use the right
>>>>>>>>> driver to handle the object, and have to consider the 
>>>>>>>>> additional ioctls
>>>>>>>>> that go along with that access.
>>>>>>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of 
>>>>>>>> an importer
>>>>>>>> is illegal.
>>>>>>>>
>>>>>>>> What we could maybe try to do is to redirect this mmap() API 
>>>>>>>> call on the
>>>>>>>> importer to the exporter, but I'm pretty sure that the fs layer 
>>>>>>>> wouldn't
>>>>>>>> like that without changes.
>>>>>>> We already do that, there's a full helper-ified path from I think 
>>>>>>> shmem
>>>>>>> helpers through prime helpers to forward this all. Including 
>>>>>>> handling
>>>>>>> buffer offsets and all the other lolz back&forth.
>>>>>> Oh, that most likely won't work correctly with unpinned DMA-bufs and
>>>>>> needs to be avoided.
>>>>>>
>>>>>> Each file descriptor is associated with an struct address_space. And
>>>>>> when you mmap() through the importer by redirecting the system 
>>>>>> call to
>>>>>> the exporter you end up with the wrong struct address_space in 
>>>>>> your VMA.
>>>>>>
>>>>>> That in turn can go up easily in flames when the exporter tries to
>>>>>> invalidate the CPU mappings for its DMA-buf while moving it.
>>>>>>
>>>>>> Where are we doing this? My last status was that this is forbidden.
>>>>> Hm I thought we're doing all that already, but looking at the code
>>>>> again we're only doing this when opening a new drm fd or dma-buf fd.
>>>>> So the right file->f_mapping is always set at file creation time.
>>>>>
>>>>> And we indeed don't frob this more when going another indirection ...
>>>>> Maybe we screwed up something somewhere :-/
>>>>>
>>>>> Also I thought the mapping is only taken after the vma is instatiated,
>>>>> otherwise the tricks we're playing with dma-buf already wouldn't work:
>>>>> dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap has
>>>>> it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
>>>>> whether we could adjust vm_file too. Or is that the thing that's
>>>>> forbidden?
>>>> Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.
>>>>
>>>> But changing vma->vm_file, that's something I haven't seen before and
>>>> most likely could blow up badly.
>>> Ok, I read the shmem helpers again, I think those are the only ones
>>> which do the importer mmap -> dma_buf_mmap() forwarding, and hence
>>> break stuff all around here.
>>>
>>> They also remove the vma->vm_pgoff offset, which means
>>> unmap_mapping_range wont work anyway. I guess for drivers which use
>>> shmem helpers the hard assumption is that a) can't use p2p dma and b)
>>> pin everything into system memory.
>>>
>>> So not a problem. But something to keep in mind. I'll try to do a
>>> kerneldoc patch to note this somewhere. btw on that, did the
>>> timeline/syncobj documentation patch land by now? Just trying to make
>>> sure that doesn't get lost for another few months or so :-/
>> Ok, so maybe it is a problem. Because there is a drm_gem_shmem_purge()
>> which uses unmap_mapping_range underneath, and that's used by
>> panfrost. And panfrost also uses the mmap helper. Kinda wondering
>> whether we broke some stuff here, or whether the reverse map is
>> installed before we touch vma->vm_pgoff.
> 
> I think the key problem here is that unmap_mapping_range() doesn't blow 
> up immediately when this is wrong.
> 
> E.g. we just have a stale CPU page table entry which allows userspace to 
> write to freed up memory, but we don't really notice that immediately....
> 
> Maybe we should stop allowing to mmap() DMA-buf through the importer 
> file descriptor altogether and only allow mapping it through its own fd 
> or the exporter.

That is what I tried to do with panfrost a while ago:

    583bbf46133c drm/panfrost: Use drm_gem_map_offset()

    panfrost_ioctl_mmap_bo() contains a reimplementation of
    drm_gem_map_offset() but with a bug - it allows mapping imported
    objects (without going through the exporter). Fix this by switching to
    use the newly renamed drm_gem_map_offset() function instead which has
    the bonus of simplifying the code.

Sadly it was followed by:

    be855382bacb Revert "drm/panfrost: Use drm_gem_map_offset()"
    This reverts commit 583bbf46133c726bae277e8f4e32bfba2a528c7f.

    Turns out we need mmap to work on imported BOs even if the current code
    is buggy.

> Christian.
> 
>> panfrost folks, does panfrost purged buffer handling of mmap still
>> work correctly? Do you have some kind of igt or similar for this?

I'm not aware of any real testing of this. And I fear it probably isn't 
getting much in the way of real-world testing either otherwise someone 
would have grown tired of the "Purging xx bytes" message[1]

I'm a little bit lost on this thread - are you expecting this patch to 
break panfrost? We shouldn't be purging imported memory. Although I'm 
not sure what (if anything) stops you trying to mark imported memory as 
"don't need". Or indeed what would happen.

Steve

[1] I have a patch silencing that, but recently haven't had much time 
for working on Panfrost, and don't have my WFH setup quite as slick as I 
did when I was in the office.
