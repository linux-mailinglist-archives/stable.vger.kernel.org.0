Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC252E94EB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbhADMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:34:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbhADMer (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 07:34:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26B70207AE;
        Mon,  4 Jan 2021 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609763646;
        bh=iL6LTFVp44ZEBP/Pk40Eo+rRVOlGrGRbL4H0CJ30d18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDXDbt4Nu3YAGxb5rof18FPSaPiKaAi5fvB8lNnvcii9uSSdZFSOrEP3jKAO7JPAc
         3H+EFRkM31H7B4PqqIeejdDf5b49cRSFK6etDJAfdkWElwV0OMcgJtAVhgxG2Qrs+x
         26h4n4yA+6krXIvmw1IQJ5ElTh815icNqLRo7Akc=
Date:   Mon, 4 Jan 2021 13:35:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.4] of: fix linker-section match-table corruption
Message-ID: <X/MLlAI4GJGsf1Hg@kroah.com>
References: <1609156019944@kroah.com>
 <20210104094435.18916-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104094435.18916-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 10:44:35AM +0100, Johan Hovold wrote:
> commit 5812b32e01c6d86ba7a84110702b46d8a8531fe9 upstream.
> 
> Specify type alignment when declaring linker-section match-table entries
> to prevent gcc from increasing alignment and corrupting the various
> tables with padding (e.g. timers, irqchips, clocks, reserved memory).
> 
> This is specifically needed on x86 where gcc (typically) aligns larger
> objects like struct of_device_id with static extent on 32-byte
> boundaries which at best prevents matching on anything but the first
> entry. Specifying alignment when declaring variables suppresses this
> optimisation.
> 
> Here's a 64-bit example where all entries are corrupt as 16 bytes of
> padding has been inserted before the first entry:
> 
> 	ffffffff8266b4b0 D __clk_of_table
> 	ffffffff8266b4c0 d __of_table_fixed_factor_clk
> 	ffffffff8266b5a0 d __of_table_fixed_clk
> 	ffffffff8266b680 d __clk_of_table_sentinel
> 
> And here's a 32-bit example where the 8-byte-aligned table happens to be
> placed on a 32-byte boundary so that all but the first entry are corrupt
> due to the 28 bytes of padding inserted between entries:
> 
> 	812b3ec0 D __irqchip_of_table
> 	812b3ec0 d __of_table_irqchip1
> 	812b3fa0 d __of_table_irqchip2
> 	812b4080 d __of_table_irqchip3
> 	812b4160 d irqchip_of_match_end
> 
> Verified on x86 using gcc-9.3 and gcc-4.9 (which uses 64-byte
> alignment), and on arm using gcc-7.2.
> 
> Note that there are no in-tree users of these tables on x86 currently
> (even if they are included in the image).
> 
> Fixes: 54196ccbe0ba ("of: consolidate linker section OF match table declarations")
> Fixes: f6e916b82022 ("irqchip: add basic infrastructure")
> Cc: stable <stable@vger.kernel.org>     # 3.9
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20201123102319.8090-2-johan@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [ johan: adjust context to 5.4 ]
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> Greg and Sasha, this one should hopefully apply to all stable trees
> which doesn't have 33def8498fdd ("treewide: Convert macro and uses of
> __section(foo) to __section("foo")").

That worked, thanks!

greg k-h
