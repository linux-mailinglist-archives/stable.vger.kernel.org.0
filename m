Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54621EACB2
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgFASig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731450AbgFASig (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:38:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F42120678;
        Mon,  1 Jun 2020 18:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035966;
        bh=pui4Eunr9vvlaJNN2MkwBQuyMjNOAHK9kAG3F+RYf5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2klU8btkQOpNyYHO7afVR43+blMRYEfQzcdOlEEdVDVliu9p/Rq6eWJaXHpgNus3h
         IL0gd099oqAn6T+F3Ek7NiKQVtBw5QpHV0LwLrDVNFy/wJnBRlUI+vk47XciknWrlz
         9tv8z52cu8C1o8jTSwWpVeur26q/cUY+IaSQqRMY=
Date:   Mon, 1 Jun 2020 14:26:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
Message-ID: <20200601182605.GI1407771@sasha-vm>
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com>
 <20200601170751.GO1551@shell.armlinux.org.uk>
 <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 11:01:19PM +0530, Naresh Kamboju wrote:
>On Mon, 1 Jun 2020 at 22:37, Russell King - ARM Linux admin
><linux@armlinux.org.uk> wrote:
>>
>> On Mon, Jun 01, 2020 at 07:02:48PM +0200, Greg Kroah-Hartman wrote:
>> > On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
>> > > stable-rc 4.9 arm architecture build failed due to
>> > > following errors,
>> > >
>> > > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
>> > > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
>> > > arm-linux-gnueabihf-gcc" O=build zImage
>> > > #
>> > > ../arch/arm/vfp/vfphw.S: Assembler messages:
>> > > ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
>> > > ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
>> > > make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
>> > > make[2]: Target '__build' not remade because of errors.
>> > > make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
>> > > ../arch/arm/lib/changebit.S: Assembler messages:
>> > > ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
>>
>> It looks like Naresh's toolchain doesn't like the new format
>> instructions.  Which toolchain (and versions of the individual
>> tools) are you (Naresh) using?
>
>  toolchain version is gcc-9

Do you see the same issue with upstream? I'd expect it to fail the sam
way because of this patch.

-- 
Thanks,
Sasha
