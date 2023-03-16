Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5E06BD717
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 18:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjCPRac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 13:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCPRaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 13:30:24 -0400
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570799C
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 10:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1678987491;
        bh=HllymALVY19388r8TABmZcfXD1RXq/kC+X7yrfk/53c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=XdlJ0ZO0ryRxVP6oeXb8NOEYDgpIpxFlgLJtRcUBOQwg8xgbKK5JVTPM0YuHYaI1H
         sKbkkaPL2XIJZF0n4RjF0AXYeXNGCKlOyrli91pGQINFis16QXi+xL1tgkkBPCzfqa
         AhOgnELA+KXExA8r0jrbXmm5CbUrOEZ10ZkLQ8Cc=
Received: from [192.168.31.5] ([106.92.97.150])
        by newxmesmtplogicsvrszc5-0.qq.com (NewEsmtp) with SMTP
        id 49E17813; Fri, 17 Mar 2023 01:18:30 +0800
X-QQ-mid: xmsmtpt1678987110t82u4fhkl
Message-ID: <tencent_237449E643BFE56794AA49EAA3A09A499907@qq.com>
X-QQ-XMAILINFO: NY3HYYTs4gYSkPornHS1119FR+H5h9MYaVSfinF4IXZNy5XKibKjlBbSnDumy/
         dJZpdX32pVx75QspsQr7q33J3Earkvql89vGBXx29b9uq7pQYC1Ig8/eaEzmOK0jvbFbVrNFDnXF
         9rtRHboDPf1HZNXTjfWY9zhHFDpZ0zfWIpyu74NBFNtCwBLhKxqNhMe0TqTPVD/NenezlcYy2EWO
         C2FY0AnQcBmW53NkrL9RPNwijBVFTdTkGI9BlAiNcVgBPNAWz8bx/Di+o9MR5TCg1Ug47LCXDmda
         WqO7TEGGS+W+KV3IGcllHgt8ttoC8EqyGvQmRwghqwuGlBvQyFonRE7mQlHeHXrHYXTUhbj4lpc8
         pWR2P/FXStxPsJUUpCh40vJP4B/FVpj2tsC+ljIiOHzG7P8PqK3Mvk04i2snzfSbYBF39+BukzkW
         Ho1qYNLdIWRT+MdRrc0T+IDXl3N5KIk011nqpbYbswBkLIkidZOIsfJ/7U/ThwlqM9/9FTgoOO7s
         pX8jWdMzMRBv87Tue88stzN002D/oSY+a/rVOp9mjSbDhiv+I1rfENhNbIW56+FYlufvnoxBDZFQ
         LQIzMwikwmWDHxskSWeMl4NGS/pFY5cz7Bf7CsCLeg2OJXurSCYvKYcRqUE7Qo6XOh3xy7IBDEDM
         GCLwQFhFMkdwMS1fewKrwfwX/wrqPMF1uScWnKXSt4OkIHcfYs+uLnPPBlVQWVMR5/UsxjPdM47l
         ploZyHnXoeUNyFG7ERWt37FPSSG6Bt9AUEPnbhICmOvh673a7pNFGbG5YG8H/UFQgrpfXRXjkqGG
         1u6afqawNXKEQrEqxDMREk/eytrbp6PBZsRqZ7j4L1YZczQ6RKszLUCuzgDcbvNSRMaQPHksYrrg
         Fvp5yJxsWU1jYJqGdnh4Fn+XpKxalFhOF7EYJ+TadTC6FwELWB2OJF62NaResHfl7SIV+k5PpAvj
         Y5m1W+a5oPjELIvCI3gv56BRV4aOrFjwZtoDwz0MoYH1l+3M9gIQ==
X-OQ-MSGID: <6b4606ac-b48e-ea7a-9aa9-4d257951884b@foxmail.com>
Date:   Fri, 17 Mar 2023 01:18:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH 1/3] kexec: move locking into do_kexec_load
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Feng Tang <feng.tang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
References: <tencent_FE90DDE46BFA03B385DFC4B367953D357206@qq.com>
 <ZBF5vkkwB+qs2GlS@kroah.com>
From:   Wen Yang <wenyang.linux@foxmail.com>
In-Reply-To: <ZBF5vkkwB+qs2GlS@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2023/3/15 15:54, Greg Kroah-Hartman 写道:
> On Thu, Mar 02, 2023 at 12:18:04AM +0800, wenyang.linux@foxmail.com wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> commit 4b692e861619353ce069e547a67c8d0e32d9ef3d upstream.
>>
>> Patch series "compat: remove compat_alloc_user_space", v5.
>>
>> Going through compat_alloc_user_space() to convert indirect system call
>> arguments tends to add complexity compared to handling the native and
>> compat logic in the same code.
>>
>> This patch (of 6):
> What about the other 6?

Hi,
Both 4b692e861619 ("kexec: move locking into do_kexec_load") and 
7bb5da0d490b
("kexec: turn all kexec_mutex acquisitions into trylocks") are prerequisites
for 05c6257433b7 ("panic, kexec: make __crash_kexec() NMI safe").

In addition, although 4b692e861619 ("kexec: move locking into 
do_kexec_load")
is part of patch series "compat: remove compat_alloc_user_space", it is also
independent and a general optimization,  and here we just need is it, as 
follows:

Arnd Bergmann (6):
   kexec: move locking into do_kexec_load
   kexec: avoid compat_alloc_user_space
   mm: simplify compat_sys_move_pages
   mm: simplify compat numa syscalls
   compat: remove some compat entry points
   arch: remove compat_alloc_user_space

https://lore.kernel.org/all/20210727144859.4150043-7-arnd@kernel.org/T/#u


> And what kernel is this going to, just 5.10.y?

For 5.10.y, these three patches are needed:

4b692e861619 ("kexec: move locking into do_kexec_load")
7bb5da0d490b ("kexec: turn all kexec_mutex acquisitions into trylocks")
05c6257433b7 ("panic, kexec: make __crash_kexec() NMI safe").

For 5.15.y, only these two patches are needed:

7bb5da0d490b ("kexec: turn all kexec_mutex acquisitions into trylocks")
05c6257433b7 ("panic, kexec: make __crash_kexec() NMI safe").


> Can you resend this as an actual patch series linked together?  They do
> not show up properly for some reason (same for your 5.15.y patches.)
>
> Try using git send-email to send them out.
>
OK, we'll resend it later.

-- 

Best wishes,

Wen


