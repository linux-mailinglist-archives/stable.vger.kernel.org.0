Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B633CADFA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 20:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbfJCSRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 14:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387457AbfJCSRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 14:17:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C42520830;
        Thu,  3 Oct 2019 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570126639;
        bh=2gR1/8+6KNwuus/1iRi4DzDZpIjwjP8+/ENL9EsUrBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C8skyptaKj2C0GOXHC+F/bb/LQlqvF5p2Gxl/WiAEhiJc+P8mH+HtVU0FS7AfXlDE
         IyMPk0ZgVtTXuE16o/XX5hLs7AKCUrLVDMWR4Qxs933IssaYahV2YE6xH58E0AtelP
         TVNcoqT+GXEOeD7GrgilFwPcKzUydmmSwgNAfi4M=
Date:   Thu, 3 Oct 2019 20:17:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.2 078/313] RAS: Fix prototype warnings
Message-ID: <20191003181717.GB3457141@kroah.com>
References: <20191003154533.590915454@linuxfoundation.org>
 <20191003154540.526612763@linuxfoundation.org>
 <20191003164527.GB11675@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191003164527.GB11675@zn.tnic>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 06:45:27PM +0200, Borislav Petkov wrote:
> On Thu, Oct 03, 2019 at 05:50:56PM +0200, Greg Kroah-Hartman wrote:
> > From: Valdis Klētnieks <valdis.kletnieks@vt.edu>
> > 
> > [ Upstream commit 0a54b809a3a2c31e1055b45b03708eb730222be1 ]
> > 
> > When building with C=2 and/or W=1, legitimate warnings are issued about
> > missing prototypes:
> > 
> >     CHECK   drivers/ras/debugfs.c
> >   drivers/ras/debugfs.c:4:15: warning: symbol 'ras_debugfs_dir' was not declared. Should it be static?
> >   drivers/ras/debugfs.c:8:5: warning: symbol 'ras_userspace_consumers' was not declared. Should it be static?
> >   drivers/ras/debugfs.c:38:12: warning: symbol 'ras_add_daemon_trace' was not declared. Should it be static?
> >   drivers/ras/debugfs.c:54:13: warning: symbol 'ras_debugfs_init' was not declared. Should it be static?
> >     CC      drivers/ras/debugfs.o
> >   drivers/ras/debugfs.c:8:5: warning: no previous prototype for 'ras_userspace_consumers' [-Wmissing-prototypes]
> >       8 | int ras_userspace_consumers(void)
> >         |     ^~~~~~~~~~~~~~~~~~~~~~~
> >   drivers/ras/debugfs.c:38:12: warning: no previous prototype for 'ras_add_daemon_trace' [-Wmissing-prototypes]
> >      38 | int __init ras_add_daemon_trace(void)
> >         |            ^~~~~~~~~~~~~~~~~~~~
> >   drivers/ras/debugfs.c:54:13: warning: no previous prototype for 'ras_debugfs_init' [-Wmissing-prototypes]
> >      54 | void __init ras_debugfs_init(void)
> >         |             ^~~~~~~~~~~~~~~~
> > 
> > Provide the proper includes.
> > 
> >  [ bp: Take care of the same warnings for cec.c too. ]
> > 
> > Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: linux-edac@vger.kernel.org
> > Cc: x86@kernel.org
> > Link: http://lkml.kernel.org/r/7168.1565218769@turing-police
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/ras/cec.c     | 1 +
> >  drivers/ras/debugfs.c | 2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
> > index f5795adc5a6e1..8037c490f3ba7 100644
> > --- a/drivers/ras/cec.c
> > +++ b/drivers/ras/cec.c
> > @@ -1,6 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #include <linux/mm.h>
> >  #include <linux/gfp.h>
> > +#include <linux/ras.h>
> >  #include <linux/kernel.h>
> >  #include <linux/workqueue.h>
> >  
> > diff --git a/drivers/ras/debugfs.c b/drivers/ras/debugfs.c
> > index 9c1b717efad86..0d4f985afbf37 100644
> > --- a/drivers/ras/debugfs.c
> > +++ b/drivers/ras/debugfs.c
> > @@ -1,5 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  #include <linux/debugfs.h>
> > +#include <linux/ras.h>
> > +#include "debugfs.h"
> >  
> >  struct dentry *ras_debugfs_dir;
> >  
> > -- 
> 
> Definitely not stable material.

Agreed, I'll go drop it from everywhere, sorry about that.

greg k-h
