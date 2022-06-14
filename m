Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF0454B873
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiFNSUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbiFNSUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:20:11 -0400
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA66B45796;
        Tue, 14 Jun 2022 11:20:10 -0700 (PDT)
Date:   Tue, 14 Jun 2022 17:47:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1655230805; x=1655490005;
        bh=nX8icfvtNzRNgQ+GqhWZfTZkY8gRANApzpXRITUNgEc=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:Feedback-ID:From:To:
         Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=Hw9UGbiz/ZBVnfMPtBB++DCRLeCoESuRMmSCyWEP+0PUSLU+GKAQIDGTENMmz5F2D
         zR+mCbPMd/wQtGwM2CBBzHpP3ivPff04SIBdczMOrZqXiXJMSii0iSOvtmamL88qMr
         X/8pu5FDbG9PLoUhJGOh/IkW6PJPczgNZS73UYLY=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
Feedback-ID: 19711308:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2022-06-14 kl. 20:12, skrev Greg Kroah-Hartman:
> On Tue, Jun 14, 2022 at 10:08:27AM -0700, Guenter Roeck wrote:
>> On Tue, Jun 14, 2022 at 08:36:08AM -0700, Guenter Roeck wrote:
>>> On Mon, Jun 13, 2022 at 08:19:49PM +0200, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.15.47 release.
>>>> There are 251 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, pleas=
e
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Build results:
>>> =09total: 159 pass: 159 fail: 0
>>> Qemu test results:
>>> =09total: 488 pass: 488 fail: 0
>>>
>>
>> I spoke a bit too early. I see the following backtrace in some qemu arm
>> boot tests.
>>
>> BUG: spinlock bad magic on CPU#0, kdevtmpfs/15
>>   lock: noop_backing_dev_info+0x6c/0x3b0, .magic: 00000000, .owner: <non=
e>/-1, .owner_cpu: 0
>> CPU: 0 PID: 15 Comm: kdevtmpfs Not tainted 5.15.47-rc2-00252-g677f0128d0=
ed #1
>> Hardware name: ARM RealView Machine (Device Tree Support)
>> [<c01101d0>] (unwind_backtrace) from [<c010bc0c>] (show_stack+0x10/0x14)
>> [<c010bc0c>] (show_stack) from [<c0a10ae4>] (dump_stack_lvl+0x68/0x90)
>> [<c0a10ae4>] (dump_stack_lvl) from [<c0191250>] (do_raw_spin_lock+0xbc/0=
x124)
>> [<c0191250>] (do_raw_spin_lock) from [<c02eb578>] (__mark_inode_dirty+0x=
1cc/0x704)
>> [<c02eb578>] (__mark_inode_dirty) from [<c02e6a74>] (simple_setattr+0x44=
/0x5c)
>> [<c02e6a74>] (simple_setattr) from [<c02d7a18>] (notify_change+0x400/0x4=
5c)
>> [<c02d7a18>] (notify_change) from [<c0a19ef8>] (devtmpfsd+0x1f8/0x2b8)
>> [<c0a19ef8>] (devtmpfsd) from [<c014cf3c>] (kthread+0x150/0x17c)
>> [<c014cf3c>] (kthread) from [<c0100120>] (ret_from_fork+0x14/0x34)
>> Exception stack(0xd00dbfb0 to 0xd00dbff8)
>> bfa0:                                     00000000 00000000 00000000 000=
00000
>> bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000=
00000
>> bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>
>> This bisects to commit bc5d960d4e58 ("writeback: Fix inode->i_io_list no=
t
>> be protected by inode->i_lock error"). The problem is also seen in the
>> mainline kernel. v5.15.y.queue and later are affected. Reverting the pat=
ch
>> here and in mainline fixes the problem.
>
> Thanks for letting me know.  Hopefully it gets fixed in upstream...
>

I "think" this is the suggested fix:

https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git/commit/?h=
=3Dfor_next&id=3D46b6418e26c7c26f98ff9c2c2310bce5ae2aa4dd

--
Thomas


