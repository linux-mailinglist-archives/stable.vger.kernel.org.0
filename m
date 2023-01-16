Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEF066CEF8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 19:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbjAPSjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 13:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbjAPSi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 13:38:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656D71E1ED;
        Mon, 16 Jan 2023 10:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17543B8106C;
        Mon, 16 Jan 2023 18:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91409C433F0;
        Mon, 16 Jan 2023 18:30:50 +0000 (UTC)
Date:   Mon, 16 Jan 2023 18:30:47 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        kernel test robot <lkp@intel.com>, akpm@linux-foundation.org,
        anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
        liushixin2@huawei.com, david@redhat.com, tongtiangen@huawei.com,
        yuzhao@google.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.4 05/16] arm64/mm: Define dummy pud_user_exec()
 when using 2-level page-table
Message-ID: <Y8WX1/q8dSEAPDy0@arm.com>
References: <20230116140520.116257-1-sashal@kernel.org>
 <20230116140520.116257-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116140520.116257-5-sashal@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 09:05:08AM -0500, Sasha Levin wrote:
> From: Will Deacon <will@kernel.org>
> 
> [ Upstream commit 4e4ff23a35ee3a145fbc8378ecfeaab2d235cddd ]
> 
> With only two levels of page-table, the generic 'pud_*' macros are
> implemented using dummy operations in pgtable-nopmd.h. Since commit
> 730a11f982e6 ("arm64/mm: add pud_user_exec() check in
> pud_user_accessible_page()"), pud_user_accessible_page() unconditionally
> calls pud_user_exec(), which is an arm64-specific helper and therefore
> isn't defined by pgtable-nopmd.h. This results in a build failure for
> configurations with only two levels of page table:
> 
>    arch/arm64/include/asm/pgtable.h: In function 'pud_user_accessible_page':
> >> arch/arm64/include/asm/pgtable.h:870:51: error: implicit declaration of function 'pud_user_exec'; did you mean 'pmd_user_exec'? [-Werror=implicit-function-declaration]
>      870 |         return pud_leaf(pud) && (pud_user(pud) || pud_user_exec(pud));
>          |                                                   ^~~~~~~~~~~~~
>          |                                                   pmd_user_exec
> 
> Fix the problem by defining pud_user_exec() as pud_user() in this case.
> 
> Link: https://lore.kernel.org/r/202301080515.z6zEksU4-lkp@intel.com
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't think this patch should be backported to 5.4. It is a fix for a
commit that went in shortly before this one (730a11f982e6). The latter
commit does have a Fixes tag but I guess Will thought it's not worth a
cc stable (and it's up to 5.19 anyway).

-- 
Catalin
