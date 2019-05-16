Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA120FD8
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 23:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfEPVLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 17:11:03 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:32774 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfEPVLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 17:11:03 -0400
Received: by mail-ot1-f68.google.com with SMTP id 66so4840445otq.0
        for <stable@vger.kernel.org>; Thu, 16 May 2019 14:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rncqV+v/sler+WaccX6aFzyW2GBZSvBqWUUQAw2Omxg=;
        b=sBwrHSYohh/5AbGwZanEBCpP/ONR4apwYXhQR3Gh/nmGJtaYsMQTILIps0vPrhK0t4
         CFYcTvs94aN+IOc+2QZpIXl51EU5IBQlgFonCamtkrRCVj/m9LnNsdaUArIfw/wnVMX1
         it246fg4xNMigWkvBlEoYYGsJfwssAsUdk0iD+mLFtO/R/3IlWHbu3tqxSmWEw6cY0BX
         4XjHiTUAOuJdPSch+xJSHicRb+bZZ3UaTbvFnIGhFEKbOFTSbXlsjy65Yr90mqwgS0g+
         F54PjHp1w24jDlC42LFHVVZElkpBuaZb2H3aaORxH/+8FksYfNLY93NcnkFWw0Yb3+aM
         op3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rncqV+v/sler+WaccX6aFzyW2GBZSvBqWUUQAw2Omxg=;
        b=I3jbBe5quy2L24FqFOKwT52lgFyqHejthM9Y2BXQP4lgrDSJo4ouxUgehMCowXF5Xw
         CN215R3U3hZ4e2CpLGolfFy3CeLs4iZH0pFCG2W2CyIAGzcg4aQ4ycRWrH0nUe+DUUOr
         lGP7cZ2085KGXZGXuWjxlruh1SG0YGzQ5uOUNN5kW0JAErn+cX5lzbhpAPwaVsHwcvk9
         Zuo5Q0bvMXj73S/htSWQmB0C63jrOAVHF4BuWxKhGdxU2KsFjiao811oV5zVqOEQi6Oo
         k9WtqFGkObl806CPnRFj0qySY/DNSg0lcBqipY0LP/Z/WsYhE5Bucu6TS0VB3tlaj2++
         iVJg==
X-Gm-Message-State: APjAAAUpYjhybcSWoEYGlOzJEajvLNepWfbjtz+tnDiFxbVvua81vccK
        lpzEq/6iVP37eU4pflAm7ZXVNQlZIc/s7Br3fUNUFw==
X-Google-Smtp-Source: APXvYqxulCJOUDUzJnfXBMN0SCHXR6S91sR3HjlOoR5MHBwl1p8VnIbStmYVv5DJAXlVl4H2Wm68Ee2JYrTDQVx19M4=
X-Received: by 2002:a9d:61ca:: with SMTP id h10mr3517132otk.247.1558041062704;
 Thu, 16 May 2019 14:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190516185732.GA27796@redhat.com>
In-Reply-To: <20190516185732.GA27796@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 16 May 2019 14:10:51 -0700
Message-ID: <CAPcyv4j5M7ZgJqFtRxw1t2p4tb579azdb6=FedV-rcqJ3GJPNw@mail.gmail.com>
Subject: Re: dax: Arrange for dax_supported check to span multiple devices
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Ira Weiny <ira.weiny@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 11:58 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Tue, May 14 2019 at 11:48pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Pankaj reports that starting with commit ad428cdb525a "dax: Check the
> > end of the block-device capacity with dax_direct_access()" device-mapper
> > no longer allows dax operation. This results from the stricter checks in
> > __bdev_dax_supported() that validate that the start and end of a
> > block-device map to the same 'pagemap' instance.
> >
> > Teach the dax-core and device-mapper to validate the 'pagemap' on a
> > per-target basis. This is accomplished by refactoring the
> > bdev_dax_supported() internals into generic_fsdax_supported() which
> > takes a sector range to validate. Consequently generic_fsdax_supported()
> > is suitable to be used in a device-mapper ->iterate_devices() callback.
> > A new ->dax_supported() operation is added to allow composite devices to
> > split and route upper-level bdev_dax_supported() requests.
> >
> > Fixes: ad428cdb525a ("dax: Check the end of the block-device...")
> > Cc: <stable@vger.kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Cc: Keith Busch <keith.busch@intel.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Reported-by: Pankaj Gupta <pagupta@redhat.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > Hi Mike,
> >
> > Another day another new dax operation to allow device-mapper to better
> > scope dax operations.
> >
> > Let me know if the device-mapper changes look sane. This passes a new
> > unit test that indeed fails on current mainline.
> >
> > https://github.com/pmem/ndctl/blob/device-mapper-pending/test/dm.sh
> >
> >  drivers/dax/super.c          |   88 +++++++++++++++++++++++++++---------------
> >  drivers/md/dm-table.c        |   17 +++++---
> >  drivers/md/dm.c              |   20 ++++++++++
> >  drivers/md/dm.h              |    1
> >  drivers/nvdimm/pmem.c        |    1
> >  drivers/s390/block/dcssblk.c |    1
> >  include/linux/dax.h          |   19 +++++++++
> >  7 files changed, 110 insertions(+), 37 deletions(-)
> >
>
> ...
>
> > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > index 2d539b82ec08..e5e240bfa2d0 100644
> > --- a/drivers/md/dm.h
> > +++ b/drivers/md/dm.h
> > @@ -78,6 +78,7 @@ void dm_unlock_md_type(struct mapped_device *md);
> >  void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
> >  enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
> >  struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
> > +bool dm_table_supports_dax(struct dm_table *t, int blocksize);
> >
> >  int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
> >
>
> I'd prefer to have dm_table_supports_dax come just after
> dm_table_get_md_mempools in the preceding dm_table section of dm.h (just
> above this mapped_device section you extended).
>
> But other than that nit, patch looks great on a DM level:
>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Thanks Mike, I folded in this change:

@@ -72,13 +72,13 @@ bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+bool dm_table_supports_dax(struct dm_table *t, int blocksize);

 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
-bool dm_table_supports_dax(struct dm_table *t, int blocksize);

 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
