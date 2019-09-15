Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5837B2F60
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 11:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfIOJfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 05:35:04 -0400
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:31969 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfIOJfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 05:35:04 -0400
Subject: Re: [PATCH 5.2 36/37] vhost: block speculation of translated
 descriptors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20190913130510.727515099@linuxfoundation.org>
 <20190913130522.155505270@linuxfoundation.org> <20190914025411.3016e3d9@mir>
 <20190914055050.GA489003@kroah.com> <20190914091548.230a63de@mir>
 <20190914080836.GB522114@kroah.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <368d254b-dc29-6309-062d-a2d07b5dad75@mageia.org>
Date:   Sun, 15 Sep 2019 12:34:57 +0300
MIME-Version: 1.0
In-Reply-To: <20190914080836.GB522114@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C020F.5D7E05C6.0029,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 14-09-2019 kl. 11:08, skrev Greg Kroah-Hartman:
> On Sat, Sep 14, 2019 at 09:15:48AM +0200, Stefan Lippers-Hollmann wrote:
>> Hi
>>
>> On 2019-09-14, Greg Kroah-Hartman wrote:
>>> On Sat, Sep 14, 2019 at 02:54:11AM +0200, Stefan Lippers-Hollmann wrote:
>>>> On 2019-09-13, Greg Kroah-Hartman wrote:
>>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>>>
>>>>> commit a89db445fbd7f1f8457b03759aa7343fa530ef6b upstream.
>>>>>
>>>>> iovec addresses coming from vhost are assumed to be
>>>>> pre-validated, but in fact can be speculated to a value
>>>>> out of range.
>>>>>
>>>>> Userspace address are later validated with array_index_nospec so we can
>>>>> be sure kernel info does not leak through these addresses, but vhost
>>>>> must also not leak userspace info outside the allowed memory table to
>>>>> guests.
>>>>>
>>>>> Following the defence in depth principle, make sure
>>>>> the address is not validated out of node range.
>> [...]
>>> Do you have the same problem with Linus's tree right now?
>>
>> Actually, yes I do (I had not tested i386 for 5.3~ within the last ~2
>> weeks, only amd64). Very similar kernel config, same compiler versions
>> but built in a slightly different environment (built directly on the bare
>> iron, in a amd64 multilib userspace, rather than a pure-i386 chroot on an
>> amd64 kernel).
>>
>> $ git describe
>> v5.3-rc8-36-ga7f89616b737
>>
>> $ LANG= make ARCH=x86 -j1 bzImage modules
>>    CALL    scripts/checksyscalls.sh
>>    CALL    scripts/atomic/check-atomics.sh
>>    CHK     include/generated/compile.h
>>    CHK     kernel/kheaders_data.tar.xz
>>    CC [M]  drivers/vhost/vhost.o
>> In file included from ./include/linux/export.h:45,
>>                   from ./include/linux/linkage.h:7,
>>                   from ./include/linux/kernel.h:8,
>>                   from ./include/linux/list.h:9,
>>                   from ./include/linux/wait.h:7,
>>                   from ./include/linux/eventfd.h:13,
>>                   from drivers/vhost/vhost.c:13:
>> drivers/vhost/vhost.c: In function 'translate_desc':
>> ./include/linux/compiler.h:350:38: error: call to '__compiletime_assert_2076' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
>>    350 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>>        |                                      ^
>> ./include/linux/compiler.h:331:4: note: in definition of macro '__compiletime_assert'
>>    331 |    prefix ## suffix();    \
>>        |    ^~~~~~
>> ./include/linux/compiler.h:350:2: note: in expansion of macro '_compiletime_assert'
>>    350 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>>        |  ^~~~~~~~~~~~~~~~~~~
>> ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>>     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>>        |                                     ^~~~~~~~~~~~~~~~~~
>> ./include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>>     50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>>        |  ^~~~~~~~~~~~~~~~
>> ./include/linux/nospec.h:56:2: note: in expansion of macro 'BUILD_BUG_ON'
>>     56 |  BUILD_BUG_ON(sizeof(_s) > sizeof(long));   \
>>        |  ^~~~~~~~~~~~
>> drivers/vhost/vhost.c:2076:5: note: in expansion of macro 'array_index_nospec'
>>   2076 |     array_index_nospec((unsigned long)(addr - node->start),
>>        |     ^~~~~~~~~~~~~~~~~~
>> make[2]: *** [scripts/Makefile.build:281: drivers/vhost/vhost.o] Error 1
>> make[1]: *** [scripts/Makefile.build:497: drivers/vhost] Error 2
>> make: *** [Makefile:1083: drivers] Error 2
>>
>> $ git revert a89db445fbd7f1f8457b03759aa7343fa530ef6b
>>
>> $ LANG= make ARCH=x86 -j16 bzImage modules
>>    CALL    scripts/atomic/check-atomics.sh
>>    CALL    scripts/checksyscalls.sh
>>    CHK     include/generated/compile.h
>>    CHK     kernel/kheaders_data.tar.xz
>>    Building modules, stage 2.
>> Kernel: arch/x86/boot/bzImage is ready  (#1)
>>    MODPOST 3464 modules
>>
>> $ echo $?
>> 0
>>
>> $ find . -name vhost\\.ko
>> ./drivers/vhost/vhost.ko
>>
>> I've attached the affected kernel config for v5.3~/ i386.
> 
> Ok, good, we will be "bug compatible" at the very least now :)
> 
> When this gets fixed in Linus's tree we can backport the fix here as
> well.  The number of users of that compiler version/configuration is
> probably pretty low at the moment to want to hold off on this fix.
> 

This is now reverted upstream:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0d4a3f2abbef73b9e5bb5f12213c275565473588

--
Thomas

