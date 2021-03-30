Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A02134EEFF
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhC3RJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 13:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhC3RIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 13:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90716619AA;
        Tue, 30 Mar 2021 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617124107;
        bh=GcvjMxdvm38+3S+eyxHmpddHO2ySIKOAbjRmYlLyFfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVOEzdXbOpgR3PHF8jHkzMeM+b0lV6nG43MkLJlIngWEPvT3SwivvEkRYH/ZpwWh6
         KhUq44eMrGJ75Wwd8eVgTerU4cvp5Y9ocsuIPMe2c8zJcKwkhZF/xrrS4SSiuzLj5F
         GZYBo8LOjpPPlCd4zXKfLtKbdmbHxbcqttjM/I9zpZA7phk7VUauyvNwRS7OY2jy4Z
         TIYwHMft9kusPlh9dLzT+ZsrOETIcVDBbnPU5uBFYJBh+iUK76cHCy5yWuJeRLC4C6
         QqnxHeBS79XCdBpyqZ93sPpGhGWGPb8dWT6qEmk5i2Fhnxgb7ZYAd8bx8W4rk1U7mb
         SjpM/N+Om61Fw==
Date:   Tue, 30 Mar 2021 13:08:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     tyhicks@linux.microsoft.com, jmorris@namei.org, will@kernel.org,
        anshuman.khandual@arm.com, ardb@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] [Backport for stable 5.11] arm64: mm: correct the inside
 linear map boundaries during hotplug check
Message-ID: <YGNbCjq92b73OBUR@sashalap>
References: <20210329142847.402167-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210329142847.402167-1-pasha.tatashin@soleen.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 10:28:47AM -0400, Pavel Tatashin wrote:
>commit ee7febce051945be28ad86d16a15886f878204de upstream.
>
>Memory hotplug may fail on systems with CONFIG_RANDOMIZE_BASE because the
>linear map range is not checked correctly.
>
>The start physical address that linear map covers can be actually at the
>end of the range because of randomization. Check that and if so reduce it
>to 0.
>
>This can be verified on QEMU with setting kaslr-seed to ~0ul:
>
>memstart_offset_seed = 0xffff
>START: __pa(_PAGE_OFFSET(vabits_actual)) = ffff9000c0000000
>END:   __pa(PAGE_END - 1) =  1000bfffffff
>
>Fixes: 58284a901b42 ("arm64/mm: Validate hotplug range before creating linear mapping")
>Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
>Tested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
>Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Queued up, thanks!

-- 
Thanks,
Sasha
