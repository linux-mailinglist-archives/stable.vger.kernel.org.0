Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE6C6B3FC8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCJM43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCJM42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:56:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC17231E6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:56:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 399E060C81
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF69C433EF;
        Fri, 10 Mar 2023 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678452986;
        bh=ALL9J2vSSQ72UEWuKN5WYMn8kG4592Amw6jbQp2VDMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irte6f2TK7REGrK5GQ6DLe4aEfbpSuNxxZNUhACzqDB1KJqEbwZ2KOCFhHW2goA8j
         be6jbdwQTe4/85S92UVchugKw5llnbxg87zCyadO9DCQmdtfAImWurUWyCKaiMWTvk
         hBOvbB9Z1uWwcIcpsZZtCXRpG6YNS78pnQ4lHOO8=
Date:   Fri, 10 Mar 2023 13:56:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     stable@vger.kernel.org,
        Kuan-Ying Lee =?utf-8?B?KOadjuWGoOepjik=?= 
        <Kuan-Ying.Lee@mediatek.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 6.1.y 2/2] arm64: Reset KASAN tag in copy_highpage with
 HW tags only
Message-ID: <ZAso+IbuyINCVa13@kroah.com>
References: <1678182267252151@kroah.com>
 <20230307174925.3613182-1-pcc@google.com>
 <20230307174925.3613182-2-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307174925.3613182-2-pcc@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 09:49:25AM -0800, Peter Collingbourne wrote:
> During page migration, the copy_highpage function is used to copy the
> page data to the target page. If the source page is a userspace page
> with MTE tags, the KASAN tag of the target page must have the match-all
> tag in order to avoid tag check faults during subsequent accesses to the
> page by the kernel. However, the target page may have been allocated in
> a number of ways, some of which will use the KASAN allocator and will
> therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
> update the target page's KASAN tag to match the source page.
> 
> We ended up unintentionally fixing this issue as a result of a bad
> merge conflict resolution between commit e059853d14ca ("arm64: mte:
> Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
> kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
> preserved a tag reset for PG_mte_tagged pages which was considered to be
> unnecessary at the time. Because SW tags KASAN uses separate tag storage,
> update the code to only reset the tags when HW tags KASAN is enabled.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd85706505830f52e0c
> Reported-by: "Kuan-Ying Lee (李冠穎)" <Kuan-Ying.Lee@mediatek.com>
> Cc: <stable@vger.kernel.org> # 6.1
> Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Link: https://lore.kernel.org/r/20230215050911.1433132-1-pcc@google.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> (cherry picked from commit e74a68468062d7ebd8ce17069e12ccc64cc6a58c)
> ---
>  arch/arm64/mm/copypage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Both now queued up, thanks.

greg k-h
