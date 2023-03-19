Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69B36C0467
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 20:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCSTcv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 19 Mar 2023 15:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCSTcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 15:32:50 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3BC136C3;
        Sun, 19 Mar 2023 12:32:49 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pdylr-002DmL-My; Sun, 19 Mar 2023 20:32:47 +0100
Received: from p57bd9bc2.dip0.t-ipconnect.de ([87.189.155.194] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pdylr-002sOE-Fu; Sun, 19 Mar 2023 20:32:47 +0100
Message-ID: <6753a4a9d28f490e068e0a3c4ce1a470319e3e86.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 2/7 v4] sh: nmi_debug: fix return value of __setup
 handler
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Igor Zhbanov <izh1979@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Date:   Sun, 19 Mar 2023 20:32:46 +0100
In-Reply-To: <20230306040037.20350-3-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
         <20230306040037.20350-3-rdunlap@infradead.org>
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
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) argument or environment
> strings. Also, error return codes don't mean anything to
> obsolete_checksetup() -- only non-zero (usually 1) or zero.
> So return 1 from nmi_debug_setup().
> 
> Fixes: 1e1030dccb10 ("sh: nmi_debug support.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Igor Zhbanov <izh1979@gmail.com>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: linux-sh@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
> v2: add more Cc's;
>     refresh and resend;
> v3: add Arnd to Cc: list
> v4: update Cc: list, refresh & resend
> 
>  arch/sh/kernel/nmi_debug.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -- a/arch/sh/kernel/nmi_debug.c b/arch/sh/kernel/nmi_debug.c
> --- a/arch/sh/kernel/nmi_debug.c
> +++ b/arch/sh/kernel/nmi_debug.c
> @@ -49,7 +49,7 @@ static int __init nmi_debug_setup(char *
>  	register_die_notifier(&nmi_debug_nb);
>  
>  	if (*str != '=')
> -		return 0;
> +		return 1;
>  
>  	for (p = str + 1; *p; p = sep + 1) {
>  		sep = strchr(p, ',');
> @@ -70,6 +70,6 @@ static int __init nmi_debug_setup(char *
>  			break;
>  	}
>  
> -	return 0;
> +	return 1;
>  }
>  __setup("nmi_debug", nmi_debug_setup);

Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
