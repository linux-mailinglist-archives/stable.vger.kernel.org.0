Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8CA5652FF
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiGDLFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiGDLFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:05:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E826160
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99B60B80ECF
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8718EC3411E;
        Mon,  4 Jul 2022 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656932720;
        bh=g8rfcbdTq7juTwCMcKkY3lMIoD+xtPNmivJNIC1YA58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JR6HPZhBaUaiNlJPm3PSuvcIvMI/GVJ7+yYRvurwZDNqSX6iue1OcQYPI6BNFY/ln
         yMF6lwqTjzRITFV6cxC6cIQuRMgpYd/DfOxreoiyLipaJ4k+sMU6lO8rC2h5sLracw
         nPIyqEmDKvk2tT6bJXP1PYb+peSJIgIYlW3hZ2Xw=
Date:   Mon, 4 Jul 2022 13:05:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH stable 4.14] s390/archrandom: simplify back to earlier
 design and initialize earlier
Message-ID: <YsLJbEdf+bIWq3cj@kroah.com>
References: <20220704102819.337213-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704102819.337213-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 12:28:19PM +0200, Jason A. Donenfeld wrote:
> commit e4f74400308cb8abde5fdc9cad609c2aba32110c upstream.
> 
> s390x appears to present two RNG interfaces:
> - a "TRNG" that gathers entropy using some hardware function; and
> - a "DRBG" that takes in a seed and expands it.
> 
> Previously, the TRNG was wired up to arch_get_random_{long,int}(), but
> it was observed that this was being called really frequently, resulting
> in high overhead. So it was changed to be wired up to arch_get_random_
> seed_{long,int}(), which was a reasonable decision. Later on, the DRBG
> was then wired up to arch_get_random_{long,int}(), with a complicated
> buffer filling thread, to control overhead and rate.
> 
> Fortunately, none of the performance issues matter much now. The RNG
> always attempts to use arch_get_random_seed_{long,int}() first, which
> means a complicated implementation of arch_get_random_{long,int}() isn't
> really valuable or useful to have around. And it's only used when
> reseeding, which means it won't hit the high throughput complications
> that were faced before.
> 
> So this commit returns to an earlier design of just calling the TRNG in
> arch_get_random_seed_{long,int}(), and returning false in arch_get_
> random_{long,int}().
> 
> Part of what makes the simplification possible is that the RNG now seeds
> itself using the TRNG at bootup. But this only works if the TRNG is
> detected early in boot, before random_init() is called. So this commit
> also causes that check to happen in setup_arch().
> 
> Cc: stable@vger.kernel.org
> Cc: Harald Freudenberger <freude@linux.ibm.com>
> Cc: Ingo Franzki <ifranzki@linux.ibm.com>
> Cc: Juergen Christ <jchrist@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Link: https://lore.kernel.org/r/20220610222023.378448-1-Jason@zx2c4.com
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

All now queued up, thanks.

greg k-h
