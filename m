Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78ACD1E8F8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 09:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfEOHag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 03:30:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:53452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfEOHag (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 03:30:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49DC1AEB3;
        Wed, 15 May 2019 07:30:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 9C9291E3CA1; Wed, 15 May 2019 09:30:31 +0200 (CEST)
Date:   Wed, 15 May 2019 09:30:31 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dax: Arrange for dax_supported check to span multiple
 devices
Message-ID: <20190515073031.GA11965@quack2.suse.cz>
References: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 14-05-19 20:48:49, Dan Williams wrote:
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

Thanks for the fix. The patch looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 0a339b85133e..ec2f2262e3a9 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -73,22 +73,12 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>  #endif
>  
> -/**
> - * __bdev_dax_supported() - Check if the device supports dax for filesystem
> - * @bdev: block device to check
> - * @blocksize: The block size of the device
> - *
> - * This is a library function for filesystems to check if the block device
> - * can be mounted with dax option.
> - *
> - * Return: true if supported, false if unsupported
> - */
> -bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
> +bool generic_fsdax_supported(struct dax_device *dax_dev,
> +		struct block_device *bdev, int blocksize, sector_t start,
> +		sector_t sectors)
>  {
> -	struct dax_device *dax_dev;
>  	bool dax_enabled = false;
>  	pgoff_t pgoff, pgoff_end;
> -	struct request_queue *q;
>  	char buf[BDEVNAME_SIZE];
>  	void *kaddr, *end_kaddr;
>  	pfn_t pfn, end_pfn;
> @@ -102,21 +92,14 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
>  		return false;
>  	}
>  
> -	q = bdev_get_queue(bdev);
> -	if (!q || !blk_queue_dax(q)) {
> -		pr_debug("%s: error: request queue doesn't support dax\n",
> -				bdevname(bdev, buf));
> -		return false;
> -	}
> -
> -	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
> +	err = bdev_dax_pgoff(bdev, start, PAGE_SIZE, &pgoff);
>  	if (err) {
>  		pr_debug("%s: error: unaligned partition for dax\n",
>  				bdevname(bdev, buf));
>  		return false;
>  	}
>  
> -	last_page = PFN_DOWN(i_size_read(bdev->bd_inode) - 1) * 8;
> +	last_page = PFN_DOWN((start + sectors - 1) * 512) * PAGE_SIZE / 512;
>  	err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
>  	if (err) {
>  		pr_debug("%s: error: unaligned partition for dax\n",
> @@ -124,20 +107,11 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
>  		return false;
>  	}
>  
> -	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> -	if (!dax_dev) {
> -		pr_debug("%s: error: device does not support dax\n",
> -				bdevname(bdev, buf));
> -		return false;
> -	}
> -
>  	id = dax_read_lock();
>  	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
>  	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
>  	dax_read_unlock(id);
>  
> -	put_dax(dax_dev);
> -
>  	if (len < 1 || len2 < 1) {
>  		pr_debug("%s: error: dax access failed (%ld)\n",
>  				bdevname(bdev, buf), len < 1 ? len : len2);
> @@ -178,6 +152,49 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
>  	}
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> +
> +/**
> + * __bdev_dax_supported() - Check if the device supports dax for filesystem
> + * @bdev: block device to check
> + * @blocksize: The block size of the device
> + *
> + * This is a library function for filesystems to check if the block device
> + * can be mounted with dax option.
> + *
> + * Return: true if supported, false if unsupported
> + */
> +bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
> +{
> +	struct dax_device *dax_dev;
> +	struct request_queue *q;
> +	char buf[BDEVNAME_SIZE];
> +	bool ret;
> +	int id;
> +
> +	q = bdev_get_queue(bdev);
> +	if (!q || !blk_queue_dax(q)) {
> +		pr_debug("%s: error: request queue doesn't support dax\n",
> +				bdevname(bdev, buf));
> +		return false;
> +	}
> +
> +	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> +	if (!dax_dev) {
> +		pr_debug("%s: error: device does not support dax\n",
> +				bdevname(bdev, buf));
> +		return false;
> +	}
> +
> +	id = dax_read_lock();
> +	ret = dax_supported(dax_dev, bdev, blocksize, 0,
> +			i_size_read(bdev->bd_inode) / 512);
> +	dax_read_unlock(id);
> +
> +	put_dax(dax_dev);
> +
> +	return ret;
> +}
>  EXPORT_SYMBOL_GPL(__bdev_dax_supported);
>  #endif
>  
> @@ -303,6 +320,15 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>  }
>  EXPORT_SYMBOL_GPL(dax_direct_access);
>  
> +bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> +		int blocksize, sector_t start, sector_t len)
> +{
> +	if (!dax_alive(dax_dev))
> +		return false;
> +
> +	return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, start, len);
> +}
> +
>  size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  		size_t bytes, struct iov_iter *i)
>  {
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index cde3b49b2a91..350cf0451456 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -880,13 +880,17 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
>  }
>  EXPORT_SYMBOL_GPL(dm_table_set_type);
>  
> +/* validate the dax capability of the target device span */
>  static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
> -			       sector_t start, sector_t len, void *data)
> +				       sector_t start, sector_t len, void *data)
>  {
> -	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
> +	int blocksize = *(int *) data;
> +
> +	return generic_fsdax_supported(dev->dax_dev, dev->bdev, blocksize,
> +			start, len);
>  }
>  
> -static bool dm_table_supports_dax(struct dm_table *t)
> +bool dm_table_supports_dax(struct dm_table *t, int blocksize)
>  {
>  	struct dm_target *ti;
>  	unsigned i;
> @@ -899,7 +903,8 @@ static bool dm_table_supports_dax(struct dm_table *t)
>  			return false;
>  
>  		if (!ti->type->iterate_devices ||
> -		    !ti->type->iterate_devices(ti, device_supports_dax, NULL))
> +		    !ti->type->iterate_devices(ti, device_supports_dax,
> +			    &blocksize))
>  			return false;
>  	}
>  
> @@ -979,7 +984,7 @@ static int dm_table_determine_type(struct dm_table *t)
>  verify_bio_based:
>  		/* We must use this table as bio-based */
>  		t->type = DM_TYPE_BIO_BASED;
> -		if (dm_table_supports_dax(t) ||
> +		if (dm_table_supports_dax(t, PAGE_SIZE) ||
>  		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
>  			t->type = DM_TYPE_DAX_BIO_BASED;
>  		} else {
> @@ -1905,7 +1910,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	}
>  	blk_queue_write_cache(q, wc, fua);
>  
> -	if (dm_table_supports_dax(t))
> +	if (dm_table_supports_dax(t, PAGE_SIZE))
>  		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
>  	else
>  		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 043f0761e4a0..c28787f5357b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1105,6 +1105,25 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	return ret;
>  }
>  
> +static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> +		int blocksize, sector_t start, sector_t len)
> +{
> +	struct mapped_device *md = dax_get_private(dax_dev);
> +	struct dm_table *map;
> +	int srcu_idx;
> +	bool ret;
> +
> +	map = dm_get_live_table(md, &srcu_idx);
> +	if (!map)
> +		return false;
> +
> +	ret = dm_table_supports_dax(map, blocksize);
> +
> +	dm_put_live_table(md, srcu_idx);
> +
> +	return ret;
> +}
> +
>  static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  				    void *addr, size_t bytes, struct iov_iter *i)
>  {
> @@ -3192,6 +3211,7 @@ static const struct block_device_operations dm_blk_dops = {
>  
>  static const struct dax_operations dm_dax_ops = {
>  	.direct_access = dm_dax_direct_access,
> +	.dax_supported = dm_dax_supported,
>  	.copy_from_iter = dm_dax_copy_from_iter,
>  	.copy_to_iter = dm_dax_copy_to_iter,
>  };
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
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 0279eb1da3ef..845c5b430cdd 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -295,6 +295,7 @@ static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  
>  static const struct dax_operations pmem_dax_ops = {
>  	.direct_access = pmem_dax_direct_access,
> +	.dax_supported = generic_fsdax_supported,
>  	.copy_from_iter = pmem_copy_from_iter,
>  	.copy_to_iter = pmem_copy_to_iter,
>  };
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index 4e8aedd50cb0..d04d4378ca50 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -59,6 +59,7 @@ static size_t dcssblk_dax_copy_to_iter(struct dax_device *dax_dev,
>  
>  static const struct dax_operations dcssblk_dax_ops = {
>  	.direct_access = dcssblk_dax_direct_access,
> +	.dax_supported = generic_fsdax_supported,
>  	.copy_from_iter = dcssblk_dax_copy_from_iter,
>  	.copy_to_iter = dcssblk_dax_copy_to_iter,
>  };
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 0dd316a74a29..f5544fc62319 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -19,6 +19,12 @@ struct dax_operations {
>  	 */
>  	long (*direct_access)(struct dax_device *, pgoff_t, long,
>  			void **, pfn_t *);
> +	/*
> +	 * Validate whether this device is usable as an fsdax backing
> +	 * device.
> +	 */
> +	bool (*dax_supported)(struct dax_device *, struct block_device *, int,
> +			sector_t, sector_t);
>  	/* copy_from_iter: required operation for fs-dax direct-i/o */
>  	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
>  			struct iov_iter *);
> @@ -75,6 +81,10 @@ static inline bool bdev_dax_supported(struct block_device *bdev, int blocksize)
>  	return __bdev_dax_supported(bdev, blocksize);
>  }
>  
> +bool generic_fsdax_supported(struct dax_device *dax_dev,
> +		struct block_device *bdev, int blocksize, sector_t start,
> +		sector_t sectors);
> +
>  static inline struct dax_device *fs_dax_get_by_host(const char *host)
>  {
>  	return dax_get_by_host(host);
> @@ -99,6 +109,13 @@ static inline bool bdev_dax_supported(struct block_device *bdev,
>  	return false;
>  }
>  
> +static inline bool generic_fsdax_supported(struct dax_device *dax_dev,
> +		struct block_device *bdev, int blocksize, sector_t start,
> +		sector_t sectors)
> +{
> +	return false;
> +}
> +
>  static inline struct dax_device *fs_dax_get_by_host(const char *host)
>  {
>  	return NULL;
> @@ -142,6 +159,8 @@ bool dax_alive(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
>  long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>  		void **kaddr, pfn_t *pfn);
> +bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> +		int blocksize, sector_t start, sector_t len);
>  size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  		size_t bytes, struct iov_iter *i);
>  size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
