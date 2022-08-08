Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A031558C94D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242599AbiHHNYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbiHHNYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:24:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4E42DC0;
        Mon,  8 Aug 2022 06:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 489EE611EB;
        Mon,  8 Aug 2022 13:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED75C433C1;
        Mon,  8 Aug 2022 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659965038;
        bh=YkyrKw26MEh+tZJyTS0AEH3Lyk3WA721wpslJzRMgcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsQjitbxJ+p2kwdhYNgnWuKxNlW6LyAL/PywNvcBJhtLkIVSUwvOjDFj2ZNpHOLD7
         NO2DR+LTzOJx5Y6ctZLrh/YCYqQ0AUOxjoA9Xl/rhMLm1G29rmHwNF/C6/fw3vEF3c
         JmX7rrlXD906ClFTJBy6IViHUQlYCoUO004xzIZI=
Date:   Mon, 8 Aug 2022 15:23:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Collingbourne <pcc@google.com>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH][for-stable] arm64: set UXN on swapper page tables
Message-ID: <YvEOa/l7zcukaqle@kroah.com>
References: <20220808125321.32598-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808125321.32598-1-will@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 01:53:21PM +0100, Will Deacon wrote:
> From: Peter Collingbourne <pcc@google.com>
> 
> [ This issue was fixed upstream by accident in c3cee924bd85 ("arm64:
>   head: cover entire kernel image in initial ID map") as part of a
>   large refactoring of the arm64 boot flow. This simple fix is therefore
>   preferred for -stable backporting ]
> 
> On a system that implements FEAT_EPAN, read/write access to the idmap
> is denied because UXN is not set on the swapper PTEs. As a result,
> idmap_kpti_install_ng_mappings panics the kernel when accessing
> __idmap_kpti_flag. Fix it by setting UXN on these PTEs.
> 
> Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
> Cc: <stable@vger.kernel.org> # 5.15
> Link: https://linux-review.googlesource.com/id/Ic452fa4b4f74753e54f71e61027e7222a0fae1b1
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/r/20220719234909.1398992-1-pcc@google.com
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kernel-pgtable.h | 4 ++--
>  arch/arm64/kernel/head.S                | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

So this should be added to 5.15.y, 5.18.y, and 5.19.y?  Or some subset?

thanks,

greg k-h
