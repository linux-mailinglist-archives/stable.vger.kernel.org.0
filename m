Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D370E59BD47
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiHVKBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiHVKB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B0731EEB
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFD5760F8D
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60EEC433C1;
        Mon, 22 Aug 2022 10:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661162485;
        bh=bO/ALU+BgGGJCirLHmzFrC3tMjo6CNH75F00tpAQeG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qj6fx4MRQ2YyOvSg1UYoCuKwNTZxrZe7SQPa0Wtv+fGF9XlThijQ3qy0RBB6XU1KF
         EdVQQL9Zz15Roe2n54PZsXsRXB8lx/Qphmcf6G7WyoLRaUvcx9tnXow/3nAOMwoxgy
         LvOeuQy059/yWkyKXipVxWV5OrNx/uaq8RGuHv7M=
Date:   Mon, 22 Aug 2022 12:01:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
Message-ID: <YwNT8tkhHl6K5D2L@kroah.com>
References: <20220822092621.3691771-1-jens.wiklander@linaro.org>
 <YwNTdQTj8SC/wnYD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YwNTdQTj8SC/wnYD@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 11:59:17AM +0200, Greg KH wrote:
> On Mon, Aug 22, 2022 at 11:26:21AM +0200, Jens Wiklander wrote:
> > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> > 
> > With special lengths supplied by user space, tee_shm_register() has
> > an integer overflow when calculating the number of pages covered by a
> > supplied user space memory region.
> > 
> > This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> > 
> > Fix this by adding an an explicit call to access_ok() in
> > tee_ioctl_shm_register() to catch an invalid user space address early.
> > 
> > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > Cc: stable@vger.kernel.org # 5.4
> > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [JW: backport to stable-5.4 + update commit message]
> 
> Will this also work for 4.19?

Nope, it breaks the build on 4.19.y, needs a different backport there:

  CC [M]  drivers/tee/tee_core.o
drivers/tee/tee_core.c: In function ‘tee_ioctl_shm_register’:
drivers/tee/tee_core.c:178:76: error: macro "access_ok" requires 3 arguments, but only 2 given
  178 |         if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
      |                                                                            ^
In file included from ./include/linux/uaccess.h:14,
                 from drivers/tee/tee_core.c:24:
./arch/x86/include/asm/uaccess.h:98: note: macro "access_ok" defined here
   98 | #define access_ok(type, addr, size)                                     \
      |
drivers/tee/tee_core.c:178:14: error: ‘access_ok’ undeclared (first use in this function)
  178 |         if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
      |              ^~~~~~~~~


