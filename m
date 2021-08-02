Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360043DE29D
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhHBWkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 18:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhHBWkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 18:40:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC51C06175F;
        Mon,  2 Aug 2021 15:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mWzo8Djge4X2E23FPVHu3Yx5Ai4UZnTkJ05FNZFrWqk=; b=hqCvs3+1vdNa5zDoHJ7Zue04NV
        HQBAJAH3rC3yOlRfe5iYtAZLGfvWP3crOgO10fM5Ne+ec2pt9H5ORhPFHcnqOyh+Yk2cHKWCW+1tg
        Wt0Y8x4fSrMGGD6LfTgbOheG29WB615HyTJCngsOqThlML/gxYmfqevHb69aQn+YCxPfm/Rdl/VCy
        IB3D6dZ3DdwPQ+SLJf5zcHHwSrqJsrFeJLPEVCCJrXbVVfocckOifCj+lqQWBx2vAizHWk1Zalx9b
        p1myN0/BBdMLFJY3vQIMACJAt6/vNyw31Pvw7oCa9o7tRfeLRxuxVBh2TpTyl7W2G1gTllZw6GaSb
        eTA2HA6Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAgbK-000V3J-8H; Mon, 02 Aug 2021 22:40:02 +0000
Date:   Mon, 2 Aug 2021 15:40:02 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Liang Wang <wangliang101@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     palmerdabbelt@google.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        wangle6@huawei.com, kepler.chenxin@huawei.com,
        nixiaoming@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: [PATCH v3] lib: Use PFN_PHYS() in devmem_is_allowed()
Message-ID: <YQh0Quhry/+dbTbn@bombadil.infradead.org>
References: <20210731025057.78825-1-wangliang101@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731025057.78825-1-wangliang101@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 31, 2021 at 10:50:57AM +0800, Liang Wang wrote:
> The physical address may exceed 32 bits on 32-bit systems with
> more than 32 bits of physcial address,use PFN_PHYS() in devmem_is_allowed(),
> or the physical address may overflow and be truncated.
> We found this bug when mapping a high addresses through devmem tool,
> when CONFIG_STRICT_DEVMEM is enabled on the ARM with ARM_LPAE and devmem
> is used to map a high address that is not in the iomem address range,
> an unexpected error indicating no permission is returned.
> 
> This bug was initially introduced from v2.6.37, and the function was moved
> to lib when v5.11.
> 
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
> Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
> Cc: stable@vger.kernel.org # v2.6.37
> Signed-off-by: Liang Wang <wangliang101@huawei.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
