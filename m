Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A541882CF
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 13:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgCQMBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 08:01:02 -0400
Received: from albireo.enyo.de ([37.24.231.21]:50338 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgCQMBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 08:01:01 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2020 08:01:00 EDT
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jEAmp-0003yE-1g; Tue, 17 Mar 2020 11:53:31 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1jEAlQ-0004mu-4A; Tue, 17 Mar 2020 12:52:04 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, qemu-devel@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Give 32bit personalities 32bit hashes
References: <20200317113153.7945-1-linus.walleij@linaro.org>
Date:   Tue, 17 Mar 2020 12:52:04 +0100
In-Reply-To: <20200317113153.7945-1-linus.walleij@linaro.org> (Linus Walleij's
        message of "Tue, 17 Mar 2020 12:31:53 +0100")
Message-ID: <87lfnzdwrf.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Linus Walleij:

> It was brought to my attention that this bug from 2018 was
> still unresolved: 32 bit emulators like QEMU were given
> 64 bit hashes when running 32 bit emulation on 64 bit systems.
>
> The personality(2) system call supports to let processes
> indicate that they are 32 bit Linux to the kernel. This
> was suggested by Teo in the original thread, so I just wired
> it up and it solves the problem.
>
> Programs that need the 32 bit hash only need to issue the
> personality(PER_LINUX32) call and things start working.
>
> I made a test program like this:
>
>   #include <dirent.h>
>   #include <errno.h>
>   #include <stdio.h>
>   #include <string.h>
>   #include <sys/types.h>
>   #include <sys/personality.h>
>
>   int main(int argc, char** argv) {
>     DIR* dir;
>     personality(PER_LINUX32);
>     dir = opendir("/boot");
>     printf("dir=%p\n", dir);
>     printf("readdir(dir)=%p\n", readdir(dir));
>     printf("errno=%d: %s\n", errno, strerror(errno));
>     return 0;
>   }
>
> This was compiled with an ARM32 toolchain from Bootlin using
> glibc 2.28 and thus suffering from the bug.

Just be sure: Is it possible to move the PER_LINUX32 setting into QEMU?
(I see why not.)

However, this does not solve the issue with network file systems and
other scenarios.  I still think need to add a workaround to the glibc
implementation.
