Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E2B271F76
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 11:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIUJ6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 05:58:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:34918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgIUJ6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 05:58:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BB5BB019;
        Mon, 21 Sep 2020 09:58:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4361B1E12E1; Mon, 21 Sep 2020 11:58:03 +0200 (CEST)
Date:   Mon, 21 Sep 2020 11:58:03 +0200
From:   Jan Kara <jack@suse.cz>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>,
        linux-nvdimm@lists.01.org, linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        open list <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH v2] dm: Call proper helper to determine dax support
Message-ID: <20200921095803.GE5862@quack2.suse.cz>
References: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+G9fYud7x0TfTDNWHa_0hzYHNQyet-a2==gQzDaZKXywY1meg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYud7x0TfTDNWHa_0hzYHNQyet-a2==gQzDaZKXywY1meg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon 21-09-20 11:23:07, Naresh Kamboju wrote:
> On Fri, 18 Sep 2020 at 11:18, Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > From: Jan Kara <jack@suse.cz>
> >
> > DM was calling generic_fsdax_supported() to determine whether a device
> > referenced in the DM table supports DAX. However this is a helper for "leaf" device drivers so that
> > they don't have to duplicate common generic checks. High level code
> > should call dax_supported() helper which that calls into appropriate
> > helper for the particular device. This problem manifested itself as
> > kernel messages:
> >
> > dm-3: error: dax access failed (-95)
> >
> > when lvm2-testsuite run in cases where a DM device was stacked on top of
> > another DM device.
> >
> > Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multiple devices")
> > Cc: <stable@vger.kernel.org>
> > Tested-by: Adrian Huang <ahuang12@lenovo.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > Changes since v1 [1]:
> > - Add missing dax_read_lock() around dax_supported()
> >
> > [1]: http://lore.kernel.org/r/20200916151445.450-1-jack@suse.cz
> >
> >  drivers/dax/super.c   |    4 ++++
> >  drivers/md/dm-table.c |   10 +++++++---
> >  include/linux/dax.h   |   11 +++++++++--
> >  3 files changed, 20 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index e5767c83ea23..b6284c5cae0a 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -325,11 +325,15 @@ EXPORT_SYMBOL_GPL(dax_direct_access);
> >  bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> >                 int blocksize, sector_t start, sector_t len)
> >  {
> > +       if (!dax_dev)
> > +               return false;
> > +
> >         if (!dax_alive(dax_dev))
> >                 return false;
> >
> >         return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, start, len);
> >  }
> > +EXPORT_SYMBOL_GPL(dax_supported);
> 
> arm build error while building with allmodconfig.
> 
> ../drivers/dax/super.c:325:6: error: redefinition of ‘dax_supported’
>   325 | bool dax_supported(struct dax_device *dax_dev, struct
> block_device *bdev,
>       |      ^~~~~~~~~~~~~
> In file included from ../drivers/dax/super.c:16:
> ../include/linux/dax.h:162:20: note: previous definition of
> ‘dax_supported’ was here
>   162 | static inline bool dax_supported(struct dax_device *dax_dev,
>       |                    ^~~~~~~~~~~~~
> make[3]: *** [../scripts/Makefile.build:283: drivers/dax/super.o] Error 1
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> Ref:
> https://builds.tuxbuild.com/IO690jFQDp0qP9zFuWBqpA/build.log

Thanks for report! Attached patch should fix the build (at least I've
tested it with CONFIG_DAX && CONFIG_FS_DAX, CONFIG_DAX && !CONFIG_FS_DAX,
and !CONFIG_DAX cases). Dan can you please merge the fix?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--Pk6IbRAofICFmK5e
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Fix-compilation-for-CONFIG_DAX-CONFIG_FS_DAX.patch"

From c48c9d1ee41ca17561dfd7ec5247b5afc527d40e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 21 Sep 2020 11:33:23 +0200
Subject: [PATCH] dax: Fix compilation for CONFIG_DAX && !CONFIG_FS_DAX

dax_supported() is defined whenever CONFIG_DAX is enabled. So dummy
implementation should be defined only in !CONFIG_DAX case, not in
!CONFIG_FS_DAX case.

Fixes: e2ec51282545 ("dm: Call proper helper to determine dax support")
Cc: <stable@vger.kernel.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/dax.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index 497031392e0a..43b39ab9de1a 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -58,6 +58,8 @@ static inline void set_dax_synchronous(struct dax_device *dax_dev)
 {
 	__set_dax_synchronous(dax_dev);
 }
+bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
+		int blocksize, sector_t start, sector_t len);
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
@@ -104,6 +106,12 @@ static inline bool dax_synchronous(struct dax_device *dax_dev)
 static inline void set_dax_synchronous(struct dax_device *dax_dev)
 {
 }
+static inline bool dax_supported(struct dax_device *dax_dev,
+		struct block_device *bdev, int blocksize, sector_t start,
+		sector_t len)
+{
+	return false;
+}
 static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 				struct dax_device *dax_dev)
 {
@@ -130,8 +138,6 @@ static inline bool generic_fsdax_supported(struct dax_device *dax_dev,
 	return __generic_fsdax_supported(dax_dev, bdev, blocksize, start,
 			sectors);
 }
-bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
-		int blocksize, sector_t start, sector_t len);
 
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
@@ -159,13 +165,6 @@ static inline bool generic_fsdax_supported(struct dax_device *dax_dev,
 	return false;
 }
 
-static inline bool dax_supported(struct dax_device *dax_dev,
-		struct block_device *bdev, int blocksize, sector_t start,
-		sector_t len)
-{
-	return false;
-}
-
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 }
-- 
2.16.4


--Pk6IbRAofICFmK5e--
