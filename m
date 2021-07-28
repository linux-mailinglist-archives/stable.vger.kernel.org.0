Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236E43D894E
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 09:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhG1H7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 03:59:40 -0400
Received: from 8bytes.org ([81.169.241.247]:48660 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235273AbhG1H7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 03:59:24 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id CDBAF310; Wed, 28 Jul 2021 09:59:21 +0200 (CEST)
Date:   Wed, 28 Jul 2021 09:59:12 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Andrey Ryabinin <arbn@yandex-team.com>,
        Will Deacon <will@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 4.9 1/2] iommu/amd: Fix backport of
 140456f994195b568ecd7fc2287a34eadffef3ca
Message-ID: <YQEOUD0uP6v/i3Y0@8bytes.org>
References: <20210727225650.726875-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727225650.726875-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 03:56:49PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/iommu/amd_iommu.c:1335:6: warning: variable 'flags' is used
> uninitialized whenever 'if' condition is true
> [-Wsometimes-uninitialized]
>         if (!pte)
>             ^~~~
> drivers/iommu/amd_iommu.c:1352:40: note: uninitialized use occurs here
>         spin_unlock_irqrestore(&domain->lock, flags);
>                                               ^~~~~
> drivers/iommu/amd_iommu.c:1335:2: note: remove the 'if' if its condition
> is always false
>         if (!pte)
>         ^~~~~~~~~
> drivers/iommu/amd_iommu.c:1331:21: note: initialize the variable 'flags'
> to silence this warning
>         unsigned long flags;
>                            ^
>                             = 0
> 1 warning generated.
> 
> The backport of commit 140456f99419 ("iommu/amd: Fix sleeping in atomic
> in increase_address_space()") to 4.9 as commit 1d648460d7c5 ("iommu/amd:
> Fix sleeping in atomic in increase_address_space()") failed to keep the
> "return false", which in 4.9 needs to be a regular "return" due to a
> lack of commit f15d9a992f90 ("iommu/amd: Remove domain->updated").
> 
> This resolves the warning and matches the 4.14-4.19 backport.
> 
> Cc: Andrey Ryabinin <arbn@yandex-team.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Fixes: 1d648460d7c5 ("iommu/amd: Fix sleeping in atomic in increase_address_space()")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Joerg Roedel <jroedel@suse.de>

