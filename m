Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5CB8CD00
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 09:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHNHgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 03:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbfHNHgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 03:36:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0D382084D;
        Wed, 14 Aug 2019 07:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565768170;
        bh=g7MnDQo7NrTooPqDFnX9PC+UoP5yPthTOb4dDh9L2ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EymXfAMBfxPgkFKKayc0E63SNvDth+890gLccp2zAdtd6ZN3uAf/zxBkdVIN3uDKc
         AZ9HDWssWwQPJyEdtDVEerG7bPZoPBT16t2awNZzoiON0Y4bgRTaygvK/vOdXgP9dG
         IgbgqcvnCI+tirhrjv0bxPVcXbvOg699tfXnLxq4=
Date:   Wed, 14 Aug 2019 09:36:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Muchun Song <smuchun@gmail.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.2 067/123] driver core: Fix use-after-free and
 double free on glue directory
Message-ID: <20190814073608.GA23414@kroah.com>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-67-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814021047.14828-67-sashal@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 10:09:51PM -0400, Sasha Levin wrote:
> From: Muchun Song <smuchun@gmail.com>
> 
> [ Upstream commit ac43432cb1f5c2950408534987e57c2071e24d8f ]
> 
> There is a race condition between removing glue directory and adding a new
> device under the glue dir. It can be reproduced in following test:
> 
> CPU1:                                         CPU2:
> 
> device_add()
>   get_device_parent()
>     class_dir_create_and_add()
>       kobject_add_internal()
>         create_dir()    // create glue_dir
> 
>                                               device_add()
>                                                 get_device_parent()
>                                                   kobject_get() // get glue_dir
> 
> device_del()
>   cleanup_glue_dir()
>     kobject_del(glue_dir)
> 
>                                                 kobject_add()
>                                                   kobject_add_internal()
>                                                     create_dir() // in glue_dir
>                                                       sysfs_create_dir_ns()
>                                                         kernfs_create_dir_ns(sd)
> 
>       sysfs_remove_dir() // glue_dir->sd=NULL
>       sysfs_put()        // free glue_dir->sd
> 
>                                                           // sd is freed
>                                                           kernfs_new_node(sd)
>                                                             kernfs_get(glue_dir)
>                                                             kernfs_add_one()
>                                                             kernfs_put()
> 
> Before CPU1 remove last child device under glue dir, if CPU2 add a new
> device under glue dir, the glue_dir kobject reference count will be
> increase to 2 via kobject_get() in get_device_parent(). And CPU2 has
> been called kernfs_create_dir_ns(), but not call kernfs_new_node().
> Meanwhile, CPU1 call sysfs_remove_dir() and sysfs_put(). This result in
> glue_dir->sd is freed and it's reference count will be 0. Then CPU2 call
> kernfs_get(glue_dir) will trigger a warning in kernfs_get() and increase
> it's reference count to 1. Because glue_dir->sd is freed by CPU1, the next
> call kernfs_add_one() by CPU2 will fail(This is also use-after-free)
> and call kernfs_put() to decrease reference count. Because the reference
> count is decremented to 0, it will also call kmem_cache_free() to free
> the glue_dir->sd again. This will result in double free.
> 
> In order to avoid this happening, we also should make sure that kernfs_node
> for glue_dir is released in CPU1 only when refcount for glue_dir kobj is
> 1 to fix this race.
> 
> The following calltrace is captured in kernel 4.14 with the following patch
> applied:
> 
> commit 726e41097920 ("drivers: core: Remove glue dirs from sysfs earlier")
> 
> --------------------------------------------------------------------------
> [    3.633703] WARNING: CPU: 4 PID: 513 at .../fs/kernfs/dir.c:494
>                 Here is WARN_ON(!atomic_read(&kn->count) in kernfs_get().
> ....
> [    3.633986] Call trace:
> [    3.633991]  kernfs_create_dir_ns+0xa8/0xb0
> [    3.633994]  sysfs_create_dir_ns+0x54/0xe8
> [    3.634001]  kobject_add_internal+0x22c/0x3f0
> [    3.634005]  kobject_add+0xe4/0x118
> [    3.634011]  device_add+0x200/0x870
> [    3.634017]  _request_firmware+0x958/0xc38
> [    3.634020]  request_firmware_into_buf+0x4c/0x70
> ....
> [    3.634064] kernel BUG at .../mm/slub.c:294!
>                 Here is BUG_ON(object == fp) in set_freepointer().
> ....
> [    3.634346] Call trace:
> [    3.634351]  kmem_cache_free+0x504/0x6b8
> [    3.634355]  kernfs_put+0x14c/0x1d8
> [    3.634359]  kernfs_create_dir_ns+0x88/0xb0
> [    3.634362]  sysfs_create_dir_ns+0x54/0xe8
> [    3.634366]  kobject_add_internal+0x22c/0x3f0
> [    3.634370]  kobject_add+0xe4/0x118
> [    3.634374]  device_add+0x200/0x870
> [    3.634378]  _request_firmware+0x958/0xc38
> [    3.634381]  request_firmware_into_buf+0x4c/0x70
> --------------------------------------------------------------------------
> 
> Fixes: 726e41097920 ("drivers: core: Remove glue dirs from sysfs earlier")
> Signed-off-by: Muchun Song <smuchun@gmail.com>
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
> Signed-off-by: Prateek Sood <prsood@codeaurora.org>
> Link: https://lore.kernel.org/r/20190727032122.24639-1-smuchun@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/base/core.c | 53 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index eaf3aa0cb8031..2dc0123cbba12 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1820,12 +1820,63 @@ static inline struct kobject *get_glue_dir(struct device *dev)
>   */
>  static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
>  {
> +	unsigned int ref;
> +
>  	/* see if we live in a "glue" directory */
>  	if (!live_in_glue_dir(glue_dir, dev))
>  		return;
>  
>  	mutex_lock(&gdp_mutex);
> -	if (!kobject_has_children(glue_dir))
> +	/**
> +	 * There is a race condition between removing glue directory
> +	 * and adding a new device under the glue directory.
> +	 *
> +	 * CPU1:                                         CPU2:
> +	 *
> +	 * device_add()
> +	 *   get_device_parent()
> +	 *     class_dir_create_and_add()
> +	 *       kobject_add_internal()
> +	 *         create_dir()    // create glue_dir
> +	 *
> +	 *                                               device_add()
> +	 *                                                 get_device_parent()
> +	 *                                                   kobject_get() // get glue_dir
> +	 *
> +	 * device_del()
> +	 *   cleanup_glue_dir()
> +	 *     kobject_del(glue_dir)
> +	 *
> +	 *                                               kobject_add()
> +	 *                                                 kobject_add_internal()
> +	 *                                                   create_dir() // in glue_dir
> +	 *                                                     sysfs_create_dir_ns()
> +	 *                                                       kernfs_create_dir_ns(sd)
> +	 *
> +	 *       sysfs_remove_dir() // glue_dir->sd=NULL
> +	 *       sysfs_put()        // free glue_dir->sd
> +	 *
> +	 *                                                         // sd is freed
> +	 *                                                         kernfs_new_node(sd)
> +	 *                                                           kernfs_get(glue_dir)
> +	 *                                                           kernfs_add_one()
> +	 *                                                           kernfs_put()
> +	 *
> +	 * Before CPU1 remove last child device under glue dir, if CPU2 add
> +	 * a new device under glue dir, the glue_dir kobject reference count
> +	 * will be increase to 2 in kobject_get(k). And CPU2 has been called
> +	 * kernfs_create_dir_ns(). Meanwhile, CPU1 call sysfs_remove_dir()
> +	 * and sysfs_put(). This result in glue_dir->sd is freed.
> +	 *
> +	 * Then the CPU2 will see a stale "empty" but still potentially used
> +	 * glue dir around in kernfs_new_node().
> +	 *
> +	 * In order to avoid this happening, we also should make sure that
> +	 * kernfs_node for glue_dir is released in CPU1 only when refcount
> +	 * for glue_dir kobj is 1.
> +	 */
> +	ref = kref_read(&glue_dir->kref);
> +	if (!kobject_has_children(glue_dir) && !--ref)
>  		kobject_del(glue_dir);
>  	kobject_put(glue_dir);
>  	mutex_unlock(&gdp_mutex);

This one needs a bit more time to "soak" in the -rc releases before I
want to apply it to the stable release.  So if you could drop it from
all of your autosel queues, that would be great.

I'll queue it up in a few weeks if all goes well with it.

thanks,

greg k-h
