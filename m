Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4323DBF19
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 21:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhG3Tg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 15:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhG3Tg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 15:36:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF92AC06175F;
        Fri, 30 Jul 2021 12:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ueynV+nblVsWpN8hPsFYEUVDSwljUmFy2cW2jdkum+o=; b=miIna91mYUypxbgiB1GEGMpo5c
        h2gON1k0fSzi9781+ctKlsFwS5Zuy0jOndYOaiSEAee1HgcBn80NbdgMtZeTeMzO7B36+b977S2h3
        /Tcc9TVVsodfSCYpZNqrRSlG58r2RaUH7GZZHKi242mWhhOmKzsm23ziQCFa/Vc6+V+xF/75pHyR/
        klZyg738qCiLKGbkxQHKORhtECPcse1D0sCv+BgKNGWZfuZC7CbiVn2TTSucVGVty7ofw0Nv+02JQ
        wdcWA4RWLmXdgjCienz+xEW+P2E17TRLreVEctu3DA54Gsgwfnt4J4tC4TWiCpZdVFxsNpalB4dzm
        Z42K03sA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m9YJL-00A7hd-3A; Fri, 30 Jul 2021 19:36:47 +0000
Date:   Fri, 30 Jul 2021 12:36:47 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Liang Wang <wangliang101@huawei.com>
Cc:     palmerdabbelt@google.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        wangle6@huawei.com, kepler.chenxin@huawei.com,
        nixiaoming@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: [PATCH v2] lib: Use PFN_PHYS() in devmem_is_allowed()
Message-ID: <YQRUz9Uw9nfiLcgr@bombadil.infradead.org>
References: <20210730074315.63232-1-wangliang101@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730074315.63232-1-wangliang101@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 03:43:15PM +0800, Liang Wang wrote:
> The physical address may exceed 32 bits on ARM(when ARM_LPAE enabled),
> use PFN_PHYS() in devmem_is_allowed(),

First off, good catch!

This should not be ARM specific, this should just say:

on 32-bit systems with more than 32 bits of physcial address

Also, towards then end then explain that in practice, yes,
this is probably just ARM which is affected. By explaining
this, it ensures folks are aware of the affected systems.

May be good to refer to commit 947d0496cf3e1 ("generic: make PFN_PHYS
explicitly return phys_addr_t") which added the original PFN_PHYS()
casting to phys_addr_t to resolve the same problem.

> or the physical address may overflow and be truncated.

Indeed. How did you find this issue? Can you describe that in the commit
log? Was it a real world issue or did you do just code inspection? Or
was there a bot which helped you?

> This bug was initially introduced from v2.6.37, and the function was moved
> to lib when v5.11.
> 
> Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
> Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
> Cc: stable@vger.kernel.org # v2.6.37
> Signed-off-by: Liang Wang <wangliang101@huawei.com>

Other than that:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
