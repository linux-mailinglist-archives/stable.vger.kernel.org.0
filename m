Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1677BCA9A0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392828AbfJCQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:45:44 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55350 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390402AbfJCQpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:45:42 -0400
Received: from zn.tnic (p200300EC2F0F5D00F0B6154A9AF851AA.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:5d00:f0b6:154a:9af8:51aa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0EBC61EC0503;
        Thu,  3 Oct 2019 18:45:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570121136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIkPCeTvcN78j8vweFeN2Nr3nk3iKgIhVmOywuUW9/M=;
        b=XWyVnN3Hnw3ZyTL4XgOzMreKMhkPulfwnXD1mttsER3/l8E7tfOwYc+ObMHMUdYfH1glId
        O7tKS29RD2qU8cboLOfagoGjGU1QORTSGArxvzRZhOQPs9Dyrh65tnk+E5cokgz+Aymvus
        hvfoU6NbYJIvWKB5LRGu7anv5uYgt9c=
Date:   Thu, 3 Oct 2019 18:45:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.2 078/313] RAS: Fix prototype warnings
Message-ID: <20191003164527.GB11675@zn.tnic>
References: <20191003154533.590915454@linuxfoundation.org>
 <20191003154540.526612763@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191003154540.526612763@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:50:56PM +0200, Greg Kroah-Hartman wrote:
> From: Valdis Klētnieks <valdis.kletnieks@vt.edu>
> 
> [ Upstream commit 0a54b809a3a2c31e1055b45b03708eb730222be1 ]
> 
> When building with C=2 and/or W=1, legitimate warnings are issued about
> missing prototypes:
> 
>     CHECK   drivers/ras/debugfs.c
>   drivers/ras/debugfs.c:4:15: warning: symbol 'ras_debugfs_dir' was not declared. Should it be static?
>   drivers/ras/debugfs.c:8:5: warning: symbol 'ras_userspace_consumers' was not declared. Should it be static?
>   drivers/ras/debugfs.c:38:12: warning: symbol 'ras_add_daemon_trace' was not declared. Should it be static?
>   drivers/ras/debugfs.c:54:13: warning: symbol 'ras_debugfs_init' was not declared. Should it be static?
>     CC      drivers/ras/debugfs.o
>   drivers/ras/debugfs.c:8:5: warning: no previous prototype for 'ras_userspace_consumers' [-Wmissing-prototypes]
>       8 | int ras_userspace_consumers(void)
>         |     ^~~~~~~~~~~~~~~~~~~~~~~
>   drivers/ras/debugfs.c:38:12: warning: no previous prototype for 'ras_add_daemon_trace' [-Wmissing-prototypes]
>      38 | int __init ras_add_daemon_trace(void)
>         |            ^~~~~~~~~~~~~~~~~~~~
>   drivers/ras/debugfs.c:54:13: warning: no previous prototype for 'ras_debugfs_init' [-Wmissing-prototypes]
>      54 | void __init ras_debugfs_init(void)
>         |             ^~~~~~~~~~~~~~~~
> 
> Provide the proper includes.
> 
>  [ bp: Take care of the same warnings for cec.c too. ]
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: linux-edac@vger.kernel.org
> Cc: x86@kernel.org
> Link: http://lkml.kernel.org/r/7168.1565218769@turing-police
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/ras/cec.c     | 1 +
>  drivers/ras/debugfs.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
> index f5795adc5a6e1..8037c490f3ba7 100644
> --- a/drivers/ras/cec.c
> +++ b/drivers/ras/cec.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/mm.h>
>  #include <linux/gfp.h>
> +#include <linux/ras.h>
>  #include <linux/kernel.h>
>  #include <linux/workqueue.h>
>  
> diff --git a/drivers/ras/debugfs.c b/drivers/ras/debugfs.c
> index 9c1b717efad86..0d4f985afbf37 100644
> --- a/drivers/ras/debugfs.c
> +++ b/drivers/ras/debugfs.c
> @@ -1,5 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include <linux/debugfs.h>
> +#include <linux/ras.h>
> +#include "debugfs.h"
>  
>  struct dentry *ras_debugfs_dir;
>  
> -- 

Definitely not stable material.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
