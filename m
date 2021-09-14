Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A9640B289
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhINPI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:08:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:9934 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233858AbhINPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 11:08:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="209115430"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="209115430"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 08:06:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="472024055"
Received: from wilesamy-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.131.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 08:06:00 -0700
Date:   Tue, 14 Sep 2021 08:05:58 -0700
From:   Ben Widawsky <ben.widawsky@intel.com>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-doc@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 03/25] cxl: Move cxl_core to new directory
Message-ID: <20210914150558.n3lbmmt7h6o2uz6a@intel.com>
References: <20210913223339.435347-1-sashal@kernel.org>
 <20210913223339.435347-3-sashal@kernel.org>
 <20210914095623.00005306@Huawei.com>
 <20210914095749.0000151f@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914095749.0000151f@Huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-09-14 09:57:49, Jonathan Cameron wrote:
> On Tue, 14 Sep 2021 09:56:23 +0100
> Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:
> 
> > On Mon, 13 Sep 2021 18:33:17 -0400
> > Sasha Levin <sashal@kernel.org> wrote:
> > 
> > > From: Ben Widawsky <ben.widawsky@intel.com>
> > > 
> > > [ Upstream commit 5161a55c069f53d88da49274cbef6e3c74eadea9 ]
> > > 
> > > CXL core is growing, and it's already arguably unmanageable. To support
> > > future growth, move core functionality to a new directory and rename the
> > > file to represent just bus support. Future work will remove non-bus
> > > functionality.
> > > 
> > > Note that mem.h is renamed to cxlmem.h to avoid a namespace collision
> > > with the global ARCH=um mem.h header.  
> > 
> > Not a fix...
> > 
> > I'm guessing this got picked up on the basis of the Reported-by: tag?
> > I think that was added for a minor tweak as this went through review rather
> > than referring to the whole patch.
> Or possibly because it was a precursor to the fix in the next patch.
> 
> Hmm.  Ben, Dan, does it make sense for these two to go into stable?
> 
> Jonathan

As of now, no, but having this will make future fixes much easier to cherry
pick.

> 
> > 
> > Jonathan
> > 
> > 
> > > 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > Link: https://lore.kernel.org/r/162792537866.368511.8915631504621088321.stgit@dwillia2-desk3.amr.corp.intel.com
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  Documentation/driver-api/cxl/memory-devices.rst | 2 +-
> > >  drivers/cxl/Makefile                            | 4 +---
> > >  drivers/cxl/core/Makefile                       | 5 +++++
> > >  drivers/cxl/{core.c => core/bus.c}              | 4 ++--
> > >  drivers/cxl/{mem.h => cxlmem.h}                 | 0
> > >  drivers/cxl/pci.c                               | 2 +-
> > >  drivers/cxl/pmem.c                              | 2 +-
> > >  7 files changed, 11 insertions(+), 8 deletions(-)
> > >  create mode 100644 drivers/cxl/core/Makefile
> > >  rename drivers/cxl/{core.c => core/bus.c} (99%)
> > >  rename drivers/cxl/{mem.h => cxlmem.h} (100%)
> > > 
> > > diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
> > > index 487ce4f41d77..a86e2c7c551a 100644
> > > --- a/Documentation/driver-api/cxl/memory-devices.rst
> > > +++ b/Documentation/driver-api/cxl/memory-devices.rst
> > > @@ -36,7 +36,7 @@ CXL Core
> > >  .. kernel-doc:: drivers/cxl/cxl.h
> > >     :internal:
> > >  
> > > -.. kernel-doc:: drivers/cxl/core.c
> > > +.. kernel-doc:: drivers/cxl/core/bus.c
> > >     :doc: cxl core
> > >  
> > >  External Interfaces
> > > diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
> > > index 32954059b37b..d1aaabc940f3 100644
> > > --- a/drivers/cxl/Makefile
> > > +++ b/drivers/cxl/Makefile
> > > @@ -1,11 +1,9 @@
> > >  # SPDX-License-Identifier: GPL-2.0
> > > -obj-$(CONFIG_CXL_BUS) += cxl_core.o
> > > +obj-$(CONFIG_CXL_BUS) += core/
> > >  obj-$(CONFIG_CXL_MEM) += cxl_pci.o
> > >  obj-$(CONFIG_CXL_ACPI) += cxl_acpi.o
> > >  obj-$(CONFIG_CXL_PMEM) += cxl_pmem.o
> > >  
> > > -ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CXL
> > > -cxl_core-y := core.o
> > >  cxl_pci-y := pci.o
> > >  cxl_acpi-y := acpi.o
> > >  cxl_pmem-y := pmem.o
> > > diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> > > new file mode 100644
> > > index 000000000000..ad137f96e5c8
> > > --- /dev/null
> > > +++ b/drivers/cxl/core/Makefile
> > > @@ -0,0 +1,5 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +obj-$(CONFIG_CXL_BUS) += cxl_core.o
> > > +
> > > +ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CXL -I$(srctree)/drivers/cxl
> > > +cxl_core-y := bus.o
> > > diff --git a/drivers/cxl/core.c b/drivers/cxl/core/bus.c
> > > similarity index 99%
> > > rename from drivers/cxl/core.c
> > > rename to drivers/cxl/core/bus.c
> > > index a2e4d54fc7bc..0815eec23944 100644
> > > --- a/drivers/cxl/core.c
> > > +++ b/drivers/cxl/core/bus.c
> > > @@ -6,8 +6,8 @@
> > >  #include <linux/pci.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/idr.h>
> > > -#include "cxl.h"
> > > -#include "mem.h"
> > > +#include <cxlmem.h>
> > > +#include <cxl.h>
> > >  
> > >  /**
> > >   * DOC: cxl core
> > > diff --git a/drivers/cxl/mem.h b/drivers/cxl/cxlmem.h
> > > similarity index 100%
> > > rename from drivers/cxl/mem.h
> > > rename to drivers/cxl/cxlmem.h
> > > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > > index 4cf351a3cf99..a945c5fda292 100644
> > > --- a/drivers/cxl/pci.c
> > > +++ b/drivers/cxl/pci.c
> > > @@ -12,9 +12,9 @@
> > >  #include <linux/pci.h>
> > >  #include <linux/io.h>
> > >  #include <linux/io-64-nonatomic-lo-hi.h>
> > > +#include "cxlmem.h"
> > >  #include "pci.h"
> > >  #include "cxl.h"
> > > -#include "mem.h"
> > >  
> > >  /**
> > >   * DOC: cxl pci
> > > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > > index 0088e41dd2f3..9652c3ee41e7 100644
> > > --- a/drivers/cxl/pmem.c
> > > +++ b/drivers/cxl/pmem.c
> > > @@ -6,7 +6,7 @@
> > >  #include <linux/ndctl.h>
> > >  #include <linux/async.h>
> > >  #include <linux/slab.h>
> > > -#include "mem.h"
> > > +#include "cxlmem.h"
> > >  #include "cxl.h"
> > >  
> > >  /*  
> > 
> 
