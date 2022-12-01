Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440D063F966
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 21:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiLAUsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 15:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiLAUsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 15:48:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8477D442D3;
        Thu,  1 Dec 2022 12:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=gM+SGNzlvBm852uPOzFZ2L0ERl2zW0zv3SAqQ3sX+ic=; b=mRQHbNpb3cTL7vq7Q7H4tdjVs7
        fo4b/jGRi1z+nFBuRp7k3WypXqw0Eb5SRjuGUAfwGl4cTL0+Ei7Ie0CVNAd1uic6FE4fBCKCAGSuw
        FnS2ydTQjtY1aIy4Sxc61sboBcUX5LnlSUcInqsVUmScTCkSzhdiW+hXY+s59wj+lZjik5L8opekB
        6VvKF4D7rDA8JwCEJo8u02TlNXQZ+0L5DfV2G47zs6tHukpFdS5d94z12hWZ3hW0xwY7mIMPenLAa
        lbokRcIaYa8ox9LeXxWDznZrtMu17exeHvTPAEangWSulKRCzRRIO4Szd7ALX9em/fluZlwSwiwCB
        6xUsFAzw==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0qU5-00B1qe-HD; Thu, 01 Dec 2022 20:48:41 +0000
Message-ID: <7e5f86c0-04b3-aa68-565a-7b86f1e1553d@infradead.org>
Date:   Thu, 1 Dec 2022 12:48:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] ata: ahci: fix enum constants for gcc-13
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Machado <luis.machado@arm.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org
References: <20221201204310.142039-1-arnd@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221201204310.142039-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/1/22 12:43, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-13 slightly changes the type of constant expressions that are deifined

                                                                    defined

> in an enum, which triggers a compile time sanity check in libata:
> 
> linux/drivers/ata/libahci.c: In function 'ahci_led_store':
> linux/include/linux/compiler_types.h:357:45: error: call to '__compiletime_assert_302' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> 357 | _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> 
> The new behavior is that sizeof() returns the same value for the
> constant as it does for the enum type, which is generally more sensible
> and consistent.
> 
> The problem in libata is that it contains a single enum definition for
> lots of unrelated constants, some of which are large positive (unsigned)
> integers like 0xffffffff, while others like (1<<31) are interpreted as
> negative integers, and this forces the enum type to become 64 bit wide
> even though most constants would still fit into a signed 32-bit 'int'.
> 
> Fix this by changing the entire enum definition to use BIT(x) in place
> of (1<<x), which results in all values being seen as 'unsigned' and
> fitting into an unsigned 32-bit type.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107917
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405
> Reported-by: Luis Machado <luis.machado@arm.com>
> Cc: linux-ide@vger.kernel.org
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Luis, I don't have gcc-13 installed on the machine I used for
> creating this patch, can you give this a spin and see if it
> addresses the build failure?
> ---
>  drivers/ata/ahci.h | 234 ++++++++++++++++++++++-----------------------
>  1 file changed, 117 insertions(+), 117 deletions(-)

What #include <linux/bits.h> ?
or is it just done indirectly?

thanks.
-- 
~Randy
