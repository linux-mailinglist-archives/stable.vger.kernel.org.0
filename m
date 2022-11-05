Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6061D93A
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 10:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKEJ5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 05:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKEJ5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 05:57:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489E518B21;
        Sat,  5 Nov 2022 02:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28CB60B16;
        Sat,  5 Nov 2022 09:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609AAC433D6;
        Sat,  5 Nov 2022 09:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667642237;
        bh=CrtV301dX680V0TO45XPkqCAEPd5NncbV4z/AHZEjjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WQ/p1MLGqU8w1n0eRBDGckYVHyHConKkkopJDp6KKUoZExEtiwwRPi+7lAj/EnT/7
         6crldLZom/JqM31NPid0WcmWS+e8HF+Hscd2yI1UKiA76g+C8iBGQ+ycxUN64Yhy/6
         a4/4+91D4bPj8sdUkgUDRjjm3xlVIUdUsxlcDk4E=
Date:   Sat, 5 Nov 2022 10:57:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.14.297
Message-ID: <Y2YzeruPdM2y327C@kroah.com>
References: <166732705422181@kroah.com>
 <20221104181745.ahtjvjvk5qk7vu37@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104181745.ahtjvjvk5qk7vu37@google.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 11:17:45AM -0700, Nick Desaulniers wrote:
> On Tue, Nov 01, 2022 at 07:24:13PM +0100, Greg Kroah-Hartman wrote:
> > I'm announcing the release of the 4.14.297 kernel.
> > 
> > All users of the 4.14 kernel series must upgrade.
> > 
> > The updated 4.14.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> Hi Greg and stable tree maintainers,
> Please consider cherry-picking
> commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and friends available in assembly")
> back to 4.19.y and 4.14.y. It first landed in v5.3-rc1 and applies
> cleanly to both branches. I did not find any fixups to 95b980d62d52,
> FWIW.
> 
> Otherwise users upgrading to this point release of linux-4.14.y still on
> versions of the GNU assembler older than v1.28 will observe assembler
> errors when building this series. See the link below for the error
> messages.
> 
> Please see
> https://lore.kernel.org/llvm/20221103210748.1343090-1-ndesaulniers@google.com/
> for more info.

Did you try building with that commit applied?  I get the following
build error when running it through the Android build system:

In file included from /buildbot/src/android/q-common-android-4.14/common/arch/arm64/include/asm/bitops.h:49:
/buildbot/src/android/q-common-android-4.14/common/include/asm-generic/bitops/non-atomic.h:60:23: error: implicit declaration of function 'UL' [-Werror,-Wimplicit-function-declaration]
        unsigned long mask = BIT_MASK(nr);
                             ^
/buildbot/src/android/q-common-android-4.14/common/include/linux/bits.h:10:24: note: expanded from macro 'BIT_MASK'
#define BIT_MASK(nr)            (UL(1) << ((nr) % BITS_PER_LONG))

So are you sure this is the correct fix?

thanks,

greg k-h
