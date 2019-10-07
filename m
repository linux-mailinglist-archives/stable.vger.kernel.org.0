Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734D2CEF5F
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 01:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfJGXHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 19:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfJGXHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 19:07:09 -0400
Received: from localhost (unknown [216.52.21.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF04F20835;
        Mon,  7 Oct 2019 23:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570489629;
        bh=bL1DOSyEb/qxbhDlweEucVwiBW7WVdbO5MG3zj7dRCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H307XciXNSJ9Om7E3sSk8Huddv4awbDFeokMUDR0/TkexMrYlM5Xfq4qP4CNY2v1J
         rDM4bMSGrpk2RFB/qaHnQhKZTiwRfsdp85XP1S14AdavkKW3kqcIqPj974uQ6FAdPj
         Qz4AjhkDQcJA637urhtR5oKv58Aj5xdYqVJWgAzc=
Date:   Mon, 7 Oct 2019 19:07:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
Message-ID: <20191007230708.GA1396@sasha-vm>
References: <20191006171038.266461022@linuxfoundation.org>
 <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
 <20191007144951.GB966828@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191007144951.GB966828@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 04:49:51PM +0200, Greg Kroah-Hartman wrote:
>On Mon, Oct 07, 2019 at 05:53:55AM -0700, Guenter Roeck wrote:
>> On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
>> > This is the start of the stable review cycle for the 4.4.196 release.
>> > There are 36 patches in this series, all will be posted as a response
>> > to this one.  If anyone has any issues with these being applied, please
>> > let me know.
>> >
>> > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
>> > Anything received after that time might be too late.
>> >
>>
>> powerpc:defconfig fails to build.
>>
>> arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
>> arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?
>>
>> It has a point:
>>
>> ... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
>> $ git grep eeh_for_each_pe
>> arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
>> arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)
>>
>> Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
>> Full report will follow later.
>
>Thanks for letting me know, I've dropped this from the queue now and
>pushed out a -rc2 with that removed.
>
>Sasha, I thought your builder would have caught stuff like this?

Interesting, the 4.4 build fails for me with vanilla 4.4 LTS kernel
(which is why this was missed):

  AS      arch/powerpc/kernel/systbl.o
arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1599: Warning: invalid register expression
arch/powerpc/kernel/exceptions-64s.S:1640: Warning: invalid register expression
arch/powerpc/kernel/exceptions-64s.S:839: Error: attempt to move .org backwards
arch/powerpc/kernel/exceptions-64s.S:840: Error: attempt to move .org backwards
arch/powerpc/kernel/exceptions-64s.S:864: Error: attempt to move .org backwards
arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
scripts/Makefile.build:375: recipe for target 'arch/powerpc/kernel/head_64.o' failed

I'll look into it.

--
Thanks,
Sasha
