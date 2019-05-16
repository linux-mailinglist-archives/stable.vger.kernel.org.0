Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2F920EFB
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 20:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfEPS5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 14:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfEPS5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 14:57:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99A843083392;
        Thu, 16 May 2019 18:57:38 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 036B719C4F;
        Thu, 16 May 2019 18:57:33 +0000 (UTC)
Date:   Thu, 16 May 2019 14:57:32 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ira Weiny <ira.weiny@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dax: Arrange for dax_supported check to span multiple devices
Message-ID: <20190516185732.GA27796@redhat.com>
References: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 16 May 2019 18:57:52 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14 2019 at 11:48pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> Pankaj reports that starting with commit ad428cdb525a "dax: Check the
> end of the block-device capacity with dax_direct_access()" device-mapper
> no longer allows dax operation. This results from the stricter checks in
> __bdev_dax_supported() that validate that the start and end of a
> block-device map to the same 'pagemap' instance.
> 
> Teach the dax-core and device-mapper to validate the 'pagemap' on a
> per-target basis. This is accomplished by refactoring the
> bdev_dax_supported() internals into generic_fsdax_supported() which
> takes a sector range to validate. Consequently generic_fsdax_supported()
> is suitable to be used in a device-mapper ->iterate_devices() callback.
> A new ->dax_supported() operation is added to allow composite devices to
> split and route upper-level bdev_dax_supported() requests.
> 
> Fixes: ad428cdb525a ("dax: Check the end of the block-device...")
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Reported-by: Pankaj Gupta <pagupta@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Hi Mike,
> 
> Another day another new dax operation to allow device-mapper to better
> scope dax operations.
> 
> Let me know if the device-mapper changes look sane. This passes a new
> unit test that indeed fails on current mainline.
> 
> https://github.com/pmem/ndctl/blob/device-mapper-pending/test/dm.sh
> 
>  drivers/dax/super.c          |   88 +++++++++++++++++++++++++++---------------
>  drivers/md/dm-table.c        |   17 +++++---
>  drivers/md/dm.c              |   20 ++++++++++
>  drivers/md/dm.h              |    1 
>  drivers/nvdimm/pmem.c        |    1 
>  drivers/s390/block/dcssblk.c |    1 
>  include/linux/dax.h          |   19 +++++++++
>  7 files changed, 110 insertions(+), 37 deletions(-)
> 

...

> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 2d539b82ec08..e5e240bfa2d0 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -78,6 +78,7 @@ void dm_unlock_md_type(struct mapped_device *md);
>  void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
>  enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
>  struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
> +bool dm_table_supports_dax(struct dm_table *t, int blocksize);
>  
>  int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
>  

I'd prefer to have dm_table_supports_dax come just after
dm_table_get_md_mempools in the preceding dm_table section of dm.h (just
above this mapped_device section you extended).

But other than that nit, patch looks great on a DM level:

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
