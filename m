Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132926C0489
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 20:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCSTtR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 19 Mar 2023 15:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCSTtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 15:49:16 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1139F6A72;
        Sun, 19 Mar 2023 12:49:14 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pdz1k-002FzR-1Y; Sun, 19 Mar 2023 20:49:12 +0100
Received: from p57bd9bc2.dip0.t-ipconnect.de ([87.189.155.194] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pdz1j-002vLh-NP; Sun, 19 Mar 2023 20:49:11 +0100
Message-ID: <aecfa23bdb4003a5471ddd4b6827b2f5a9c0fcac.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 4/7 v4] sh: math-emu: fix macro redefined warning
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable@vger.kernel.org
Date:   Sun, 19 Mar 2023 20:49:10 +0100
In-Reply-To: <20230306040037.20350-5-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
         <20230306040037.20350-5-rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.155.194
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> Fix a warning that was reported by the kernel test robot:
> 
> In file included from ../include/math-emu/soft-fp.h:27,
>                  from ../arch/sh/math-emu/math.c:22:
> ../arch/sh/include/asm/sfp-machine.h:17: warning: "__BYTE_ORDER" redefined
>    17 | #define __BYTE_ORDER __BIG_ENDIAN
> In file included from ../arch/sh/math-emu/math.c:21:
> ../arch/sh/math-emu/sfp-util.h:71: note: this is the location of the previous definition
>    71 | #define __BYTE_ORDER __LITTLE_ENDIAN
> 
> Fixes: b929926f01f2 ("sh: define __BIG_ENDIAN for math-emu")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: lore.kernel.org/r/202111121827.6v6SXtVv-lkp@intel.com
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: linux-sh@vger.kernel.org
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: stable@vger.kernel.org
> ---
> v2: add Reviewed-by Geert,
>     rebase to linux-next-20211115
> v3: skipped
> v4: refresh & resend
> 
>  arch/sh/math-emu/sfp-util.h |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff -- a/arch/sh/math-emu/sfp-util.h b/arch/sh/math-emu/sfp-util.h
> --- a/arch/sh/math-emu/sfp-util.h
> +++ b/arch/sh/math-emu/sfp-util.h
> @@ -67,7 +67,3 @@
>    } while (0)
>  
>  #define abort()	return 0
> -
> -#define __BYTE_ORDER __LITTLE_ENDIAN
> -
> -

Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
