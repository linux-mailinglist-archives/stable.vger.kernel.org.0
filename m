Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8044B641709
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLCNfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLCNfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:35:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E246101DA
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50CBE601D9
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 13:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D859C433D6;
        Sat,  3 Dec 2022 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670074469;
        bh=37Zl9LPsZNwKals7bc9ElLjwKhNseex+1JJu1czI4ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MlZRV4/V/jBAWnemPY2AZcwvlkt1A54ZNzvEB4ariclBmOi1eew6HL59PQ7yrr0jn
         T/7wLZxt5k2Lp/wthOmgsgiZNOTRB7xZcPUvs5+3vnD1uzCV48yDqdtW9Kg4GbTvOW
         mhir4JvLiqROetGD9xr6vt1QzWpznPRcr5Yy2L4k=
Date:   Sat, 3 Dec 2022 14:34:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Hugh Dickins <hughd@google.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section
 warning
Message-ID: <Y4tQYgjDgodwR2pP@kroah.com>
References: <20221128225345.9383-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128225345.9383-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 03:53:46PM -0700, Nathan Chancellor wrote:
> Portions of upstream commit a4055888629b ("mm/memcg: warning on !memcg
> after readahead page charged") were backported as commit cfe575954ddd
> ("mm: add VM_WARN_ON_ONCE_PAGE() macro"). Unfortunately, the backport
> did not account for the lack of commit 33def8498fdd ("treewide: Convert
> macro and uses of __section(foo) to __section("foo")") in kernels prior
> to 5.10, resulting in the following orphan section warnings on PowerPC
> clang builds with CONFIG_DEBUG_VM=y:
> 
>   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
>   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
>   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
> 
> This is a difference between how clang and gcc handle macro
> stringification, which was resolved for the kernel by not stringifying
> the argument to the __section() macro. Since that change was deemed not
> suitable for the stable kernels by commit 59f89518f510 ("once: fix
> section mismatch on clang builds"), do that same thing as that change
> and remove the quotes from the argument to __section().
> 
> Fixes: cfe575954ddd ("mm: add VM_WARN_ON_ONCE_PAGE() macro")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> 
> As far as I can tell, this should be applied to 5.4 and earlier. It
> should apply cleanly but let me know if not.

Queued up everywhere, thanks.

greg k-h
