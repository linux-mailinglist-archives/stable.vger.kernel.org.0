Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5B167E6B8
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbjA0NaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbjA0N37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:29:59 -0500
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C8178ACC;
        Fri, 27 Jan 2023 05:29:57 -0800 (PST)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pLOnZ-001xfs-9c; Fri, 27 Jan 2023 14:29:45 +0100
Received: from dynamic-077-013-135-231.77.13.pool.telefonica.de ([77.13.135.231] helo=[192.168.1.11])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pLOnZ-000Wu9-2w; Fri, 27 Jan 2023 14:29:45 +0100
Message-ID: <8981c636-6145-6589-d4c9-8cdc12801be3@physik.fu-berlin.de>
Date:   Fri, 27 Jan 2023 14:29:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.4 fix build id for arm64 6/6] sh: define
 RUNTIME_DISCARD_EXIT
Content-Language: en-US
To:     Tom Saeger <tom.saeger@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <cover.1674588616.git.tom.saeger@oracle.com>
 <7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger@oracle.com>
 <Y9N9Ux4asZRE25zC@kroah.com> <20230127132540.agmyuzg64wlcwglo@oracle.com>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
In-Reply-To: <20230127132540.agmyuzg64wlcwglo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 77.13.135.231
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tom!

On 1/27/23 14:25, Tom Saeger wrote:
> On Fri, Jan 27, 2023 at 08:29:23AM +0100, Greg Kroah-Hartman wrote:
>> On Tue, Jan 24, 2023 at 02:14:23PM -0700, Tom Saeger wrote:
>>> sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
>>> commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").
>>>
>>> This is similar to fixes for powerpc and s390:
>>> commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
>>> commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
>>> with GNU ld < 2.36").
>>>
>>>    $ sh4-linux-gnu-ld --version | head -n1
>>>    GNU ld (GNU Binutils for Debian) 2.35.2
>>>
>>>    $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
>>>    $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-
>>>
>>>    `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
>>>    defined in discarded section `.exit.text' of crypto/algboss.o
>>>    `.exit.text' referenced in section `__bug_table' of
>>>    drivers/char/hw_random/core.o: defined in discarded section
>>>    `.exit.text' of drivers/char/hw_random/core.o
>>>    make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
>>>    make[1]: *** [Makefile:1252: vmlinux] Error 2
>>>
>>> arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:
>>>
>>> 	/*
>>> 	 * .exit.text is discarded at runtime, not link time, to deal with
>>> 	 * references from __bug_table
>>> 	 */
>>> 	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }
>>>
>>> However, EXIT_TEXT is thrown away by
>>> DISCARD(include/asm-generic/vmlinux.lds.h) because
>>> sh does not define RUNTIME_DISCARD_EXIT.
>>>
>>> GNU ld 2.40 does not have this issue and builds fine.
>>> This corresponds with Masahiro's comments in a494398bde27:
>>> "Nathan [Chancellor] also found that binutils
>>> commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
>>> issue, so we cannot reproduce it with binutils 2.36+, but it is better
>>> to not rely on it."
>>>
>>> Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
>>> Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
>>> Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
>>> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
>>> ---
>>>   arch/sh/kernel/vmlinux.lds.S | 1 +
>>>   1 file changed, 1 insertion(+)
>>
>> No upstream git id?
>>
>> :(
> 
> No, not yet.  I'll try resending.

Can you push this via Andrew's tree until we have sorted out the new SH tree?

We're currently having issues with our git instance and we're also not yet official.

Apologies for the delay!

Adrian

-- 
  .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
   `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

