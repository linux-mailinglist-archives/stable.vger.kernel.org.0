Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C802A17A7
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgJaNaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:30:52 -0400
Received: from fgw23-4.mail.saunalahti.fi ([62.142.5.110]:34286 "EHLO
        fgw23-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbgJaNav (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 09:30:51 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Oct 2020 09:30:50 EDT
Received: from toshiba (85-76-11-205-nat.elisa-mobile.fi [85.76.11.205])
        by fgw23.mail.saunalahti.fi (Halon) with ESMTP
        id 0afb966e-1b7b-11eb-8ccd-005056bdfda7;
        Sat, 31 Oct 2020 15:14:46 +0200 (EET)
Message-ID: <5F9D6341.71F2A54E@users.sourceforge.net>
Date:   Sat, 31 Oct 2020 15:14:41 +0200
From:   Jari Ruusu <jariruusu@users.sourceforge.net>
MIME-Version: 1.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Linux 4.19.154
References: <160405368022942@kroah.com> <160405368043128@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2127,11 +2127,10 @@ static void handle_bad_sector(struct bio *bio, sector_t maxsector)
>  {
>         char b[BDEVNAME_SIZE];
> 
> -       printk(KERN_INFO "attempt to access beyond end of device\n");
> -       printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
> -                       bio_devname(bio, b), bio->bi_opf,
> -                       (unsigned long long)bio_end_sector(bio),
> -                       (long long)maxsector);
> +       pr_info_ratelimited("attempt to access beyond end of device\n"
> +                           "%s: rw=%d, want=%llu, limit=%llu\n",
> +                           bio_devname(bio, b), bio->bi_opf,
> +                           bio_end_sector(bio), maxsector);
>  }
> 
>  #ifdef CONFIG_FAIL_MAKE_REQUEST

Above change "block: ratelimit handle_bad_sector() message"
upstream commit f4ac712e4fe009635344b9af5d890fe25fcc8c0d
in 4.19.154 kernel is not completely OK.

Removing casts from arguments 4 and 5 produces these compile warnings:



In file included from ./include/linux/kernel.h:14:0,
                 from block/blk-core.c:14:
block/blk-core.c: In function 'handle_bad_sector':
./include/linux/kern_levels.h:5:18: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 4 has type 'sector_t {aka long unsigned int}' [-Wformat=]
 #define KERN_SOH "\001"  /* ASCII Start Of Header */
                  ^
./include/linux/printk.h:424:10: note: in definition of macro 'printk_ratelimited'
   printk(fmt, ##__VA_ARGS__);    \
          ^~~
./include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
 #define KERN_INFO KERN_SOH "6" /* informational */
                   ^~~~~~~~
./include/linux/printk.h:444:21: note: in expansion of macro 'KERN_INFO'
  printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                     ^~~~~~~~~
block/blk-core.c:2130:2: note: in expansion of macro 'pr_info_ratelimited'
  pr_info_ratelimited("attempt to access beyond end of device\n"
  ^~~~~~~~~~~~~~~~~~~
./include/linux/kern_levels.h:5:18: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 5 has type 'sector_t {aka long unsigned int}' [-Wformat=]
 #define KERN_SOH "\001"  /* ASCII Start Of Header */
                  ^
./include/linux/printk.h:424:10: note: in definition of macro 'printk_ratelimited'
   printk(fmt, ##__VA_ARGS__);    \
          ^~~
./include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
 #define KERN_INFO KERN_SOH "6" /* informational */
                   ^~~~~~~~
./include/linux/printk.h:444:21: note: in expansion of macro 'KERN_INFO'
  printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                     ^~~~~~~~~
block/blk-core.c:2130:2: note: in expansion of macro 'pr_info_ratelimited'
  pr_info_ratelimited("attempt to access beyond end of device\n"
  ^~~~~~~~~~~~~~~~~~~



For 64 bit systems it is only compile time cosmetic warning. For 32 bit
system + CONFIG_LBDAF=n it introduces bugs: output formats are "%llu" and
passed parameters are 32 bits. That is not OK.

Upstream kernels have hardcoded 64 bit sector_t. In older stable trees
sector_t can be either 64 or 32 bit. In other words, backport of above patch
needs to keep those original casts.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
