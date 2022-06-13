Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9235548391
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiFMJVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiFMJVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2630818B1E
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B71FF6130B
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3103C34114;
        Mon, 13 Jun 2022 09:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655112105;
        bh=+K2+wNStrxavCSy2piYJ2hQqdT7ExjIfR0Y2zzb5FvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZWzxwIrgivj5+pv7uXzjjb8retBC93g9CpXPlbciHUMIi+l69D0R5ML0NlfLJgEbR
         hI5VE0X2WdaqJDBgPEwFAw4KZLgpI7xKQviY85tk/xkyMUoNE2kxXVqYyXpPThTJ04
         hssXAGu5zf2I4PVHfZ6uJ8Nqy1FHaaY6auXcYy0Q=
Date:   Mon, 13 Jun 2022 11:21:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH for 4.9.y 2/2] mtd: cfi_cmdset_0002: Use chip_ready() for
 write on S29GL064N
Message-ID: <YqcBphMj/XeAaDEC@kroah.com>
References: <20220610155604.1342511-1-ikegami.t@gmail.com>
 <20220610155604.1342511-2-ikegami.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610155604.1342511-2-ikegami.t@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 11, 2022 at 12:56:04AM +0900, Tokunori Ikegami wrote:
> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
> check correct value") buffered writes fail on S29GL064N. This is
> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> write completion, where as, chip_good() check expects actual data
> written to the last location to be returned post DQ polling completion.
> Fix is to revert to using chip_good() for S29GL064N which only checks
> for DQ lines to settle down to determine write completion.
> 
> Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Acked-by: Vignesh Raghavendra <vigneshr@ti.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Link: https://lore.kernel.org/linux-mtd/20220323170458.5608-3-ikegami.t@gmail.com
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 42 +++++++++++++++++++++++------
>  include/linux/mtd/cfi.h             |  1 +
>  2 files changed, 35 insertions(+), 8 deletions(-)

All now queued up, thanks.

greg k-h
