Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CDE5A2902
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 16:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344418AbiHZODG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 10:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344375AbiHZODG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 10:03:06 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA17C04D1
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:03:05 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 83C84100D585B;
        Fri, 26 Aug 2022 16:03:03 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 55A4952672; Fri, 26 Aug 2022 16:03:03 +0200 (CEST)
Date:   Fri, 26 Aug 2022 16:03:03 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Urja Rannikko <urjaman@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [regression] build failure of smsc95xx since 5.15.61
Message-ID: <20220826140303.GA31167@wunner.de>
References: <CAPCnQJm+M4Sm_gAA6vKK5jRnwp8etsaA+gx07HqPS-v8GjqnuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPCnQJm+M4Sm_gAA6vKK5jRnwp8etsaA+gx07HqPS-v8GjqnuA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 26, 2022 at 04:55:55PM +0300, Urja Rannikko wrote:
> Here's the relevant bit of the build log:
> drivers/net/usb/smsc95xx.c: In function "smsc95xx_status":
> drivers/net/usb/smsc95xx.c:625:3: error: implicit declaration of
> function "generic_handle_domain_irq"; did you mean
> "generic_handle_irq"? [-Werror=implicit-function-declaration]
[...]
> The build is for 32-bit x86, the defconfig can be found here:
> https://github.com/urjaman/i586con/blob/master/brext/board/linux.config
> 
> The build failure also happens with 5.15.62 and 63.

I've already asked Sasha & Greg for a revert today:

https://lore.kernel.org/netdev/20220826132137.GA24932@wunner.de

This was backported to stable kernels although it wasn't tagged
for stable.  You're the third person reporting breakage to me
because of it:

https://lore.kernel.org/all/YwaqZ1+zm78vl4L1@sirena.org.uk/
https://github.com/raspberrypi/linux/issues/5145

Thanks,

Lukas
