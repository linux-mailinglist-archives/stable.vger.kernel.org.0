Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC64364EBEA
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLPNKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLPNKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:10:30 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B01D242
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 05:10:30 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BGDA94m008171
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 08:10:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671196212; bh=6A1HlZSOMAQRr4FKU2q50VMcNFp/OOxmzrLfT0bUeVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=nNsgKeEOqOyHKGyaN71I0uluXODIn0mBbOK91ZMYztJiJgqylXYj5RDj40DVUk/q3
         V32yLn/w7rksFQJ8iRwyLIa+JXX/2ZzJwLxTCMvqBaC0Q3GjTzucX5tTZN6nUcLzSX
         xUJ8SqfO5bOlON874dwDzpHWOysmMT2f8DN6kavS6E56T0tM9ww/hrkz1GDm0/UR05
         65w/MJ68wOuV/pigdur8ODR9YZO4+e/tI2eYwTi8y33U8ZjoL/8fRGfSVJXiW+4otJ
         f9sc3Z8D9uBELPEHVcGEEoXdtA67xDwJxJ1H38xB/Ssg06soEi1NvIreIoG159fPil
         P3Mxf9w0OI2ZA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 59AED15C40A2; Fri, 16 Dec 2022 08:10:09 -0500 (EST)
Date:   Fri, 16 Dec 2022 08:10:09 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jun Nie <jun.nie@linaro.org>
Cc:     stable@vger.kernel.org, djwong@kernel.org, jack@suse.cz,
        jlayton@kernel.org, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, xuyang2018.jy@fujitsu.com
Subject: Re: [PATCH v1] ext4: Remove deprecated noacl/nouser_xattr options
Message-ID: <Y5xuMZn/Ysu2uThj@mit.edu>
References: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
 <20221216034116.869864-1-jun.nie@linaro.org>
 <Y5wGZG05uicAPscI@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5wGZG05uicAPscI@mit.edu>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here is a proper, minmized reproducer which reproduces on upstream, for someone
who wants to try to work this bug.

On Fri, Dec 16, 2022 at 12:47:16AM -0500, Theodore Ts'o wrote:
> Fixing this the clean and proper way, which is by making
> ext4_xattr_move_to_block() more intelligent/efficient, is left as an
> exercise to the reader.

For someone who wants to work the bug, here is a cleaner, properly
minimzed, easier-for-humans-to-understand reproducer:

#!/bin/bash -vx
#
# This reproduces an ext4 bug caused by an unfortunate interaction
# between lazytime updates happening when a file system is being
# unmounted and expand_extra_isize
#
# Initially discovered via syzkaller:
# https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08
#

img=/tmp/foo.img
dir=/mnt
file=$dir/file0

rm -f $img
mke2fs -Fq -t ext4 -I 256 -O ea_inode -b 1024 $img 200k
mount $img $dir
v=$(dd if=/dev/zero bs=2000 count=1 2>/dev/null | tr '\0' =)
touch $file
attr -q -s test -V $v $file
umount $dir
mount -o debug_want_extra_isize=128,lazytime /tmp/foo.img $dir
cat $file
umount $dir
