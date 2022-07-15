Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C19576339
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiGON6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 09:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGON6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 09:58:03 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8AC820E2;
        Fri, 15 Jul 2022 06:58:02 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id i126so6160797oih.4;
        Fri, 15 Jul 2022 06:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pWWv1KjyLTxceoIzSgy/J2oEMl6lFWv01sP88AzTVPo=;
        b=hy6A+q4WFgzT0FtJwgri6Gva45SKUhbqrX+TC2oEBddixiPv7wdKlHSAdBnQfupc/7
         Yym9Wmt4saQj9DK2MkwAcJlZe2T5h/5+gIwPQuJVrDoovWg6VOL6poCmKkxNncp1DKtM
         YUJfJyRdi2d0GUlIxB5OM/snsNXqsKyV4qT457NjwNvvtfs3ZEPbAP+rWeusaFogisiq
         nQtMgMi6937mFeZeOmXXb5gCKdjeOhrYq9owTM7sRuy9SZG40VuITyrep7+Fn0D/gj/e
         cHJWJ/2AgI1nYOgQK5nDxJs4c9LhMy638pIAk+Ult+MszOYmb79700XjDWA6dFBG73+x
         9Geg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pWWv1KjyLTxceoIzSgy/J2oEMl6lFWv01sP88AzTVPo=;
        b=YElVnnbXS6W9FY9mbeRMVdW+plQNRdtPKLMm3SPYU1ozqk9vXt1nqn8+4hozq6EXoH
         8ZF9r21QOyK61vYfi246/IzfJyuEN3HdGXiBZ8xDTTsl84irH9WTH5dqflkxAh/YxU56
         +Vq4C3ifQ0DEztAx4ErtVgAvFlRE95XUuxGTP+JUSqLoocL51HSt+WHFQkKpO/1HxiNd
         X5adxu+dJ0yUiTnsgdLec5KKOUNSNJtYMqhJzITplw0v3uxxD2W9aZF70G8zU6idhhci
         siDsyOfYLQsgyvmQCAAiMEs0wcsI/zSr9lEBLkopKFvo4HBdqmjc9uHpp9JbDnj/wmlw
         5xxw==
X-Gm-Message-State: AJIora/3A8X9aSnRGx0IGrJCVlXURYZJJpzrmkyBM8VOKCUderSTP+Jc
        XIDJ3KGcYIlQu3utbydv9Fk=
X-Google-Smtp-Source: AGRyM1sDdKwE/nzapTw7FtXptc62bmMajKWpwknjCsW6on5LO+kQEKuNpxWGAUWKzgoFtLOAEDAIKA==
X-Received: by 2002:aca:43d5:0:b0:339:e447:fe2f with SMTP id q204-20020aca43d5000000b00339e447fe2fmr10220246oia.113.1657893481311;
        Fri, 15 Jul 2022 06:58:01 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id er10-20020a056870c88a00b0010cbd1baf5esm2261951oab.51.2022.07.15.06.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 06:58:01 -0700 (PDT)
Date:   Fri, 15 Jul 2022 06:58:00 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] drivers/base: fix userspace break from using
 bin_attributes for cpumap and cpulist
Message-ID: <YtFyaMWfYtjrsrSI@yury-laptop>
References: <20220715134924.3466194-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715134924.3466194-1-pauld@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 09:49:24AM -0400, Phil Auld wrote:
> Using bin_attributes with a 0 size causes fstat and friends to return that
> 0 size. This breaks userspace code that retrieves the size before reading
> the file. Rather than reverting 75bd50fa841 ("drivers/base/node.c: use
> bin_attribute to break the size limitation of cpumap ABI") let's put in a
> size value at compile time.
> 
> For cpulist the maximum size is on the order of
> 	NR_CPUS * (ceil(log10(NR_CPUS)) + 1)/2
> 
> which for 8192 is 20480 (8192 * 5)/2. In order to get near that you'd need
> a system with every other CPU on one node. For example: (0,2,4,8, ... ).
> To simplify the math and support larger NR_CPUS in the future we are using
> (NR_CPUS * 7)/2. We also set it to a min of PAGE_SIZE to retain the older
> behavior for smaller NR_CPUS.
> 
> The cpumap file the size works out to be NR_CPUS/4 + NR_CPUS/32 - 1
> (or NR_CPUS * 9/32 - 1) including the ","s.
> 
> Add a set of macros for these values to cpumask.h so they can be used in
> multiple places. Apply these to the handful of such files in
> drivers/base/topology.c as well as node.c.
> 
> As an example, on an 80 cpu 4-node system (NR_CPUS == 8192):
> 
> before:
> 
> -r--r--r--. 1 root root 0 Jul 12 14:08 system/node/node0/cpulist
> -r--r--r--. 1 root root 0 Jul 11 17:25 system/node/node0/cpumap
> 
> after:
> 
> -r--r--r--. 1 root root 28672 Jul 13 11:32 system/node/node0/cpulist
> -r--r--r--. 1 root root  4096 Jul 13 11:31 system/node/node0/cpumap
> 
> CONFIG_NR_CPUS = 16384
> -r--r--r--. 1 root root 57344 Jul 13 14:03 system/node/node0/cpulist
> -r--r--r--. 1 root root  4607 Jul 13 14:02 system/node/node0/cpumap
> 
> The actual number of cpus doesn't matter for the reported size since they
> are based on NR_CPUS.
> 
> Fixes: 75bd50fa841 ("drivers/base/node.c: use bin_attribute to break the size limitation of cpumap ABI")
> Fixes: bb9ec13d156 ("topology: use bin_attribute to break the size limitation of cpumap ABI")
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Phil Auld <pauld@redhat.com>

Acked-by: Yury Norov <yury.norov@gmail.com> (for include/linux/cpumask.h)

> ---
> v2: Fix cpumap size calculation. Increase multiplier for cpulist size.
> 
> v3: Add comments in code.
> 
> v4: Define constants in cpumask.h. Move comments there. Also fix
> topology.c.
> 
> v5: Fixed math based on Yury's corrections.
> 
>  drivers/base/node.c     |  4 ++--
>  drivers/base/topology.c | 32 ++++++++++++++++----------------
>  include/linux/cpumask.h | 18 ++++++++++++++++++
>  3 files changed, 36 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 0ac6376ef7a1..eb0f43784c2b 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -45,7 +45,7 @@ static inline ssize_t cpumap_read(struct file *file, struct kobject *kobj,
>  	return n;
>  }
>  
> -static BIN_ATTR_RO(cpumap, 0);
> +static BIN_ATTR_RO(cpumap, CPUMAP_FILE_MAX_BYTES);
>  
>  static inline ssize_t cpulist_read(struct file *file, struct kobject *kobj,
>  				   struct bin_attribute *attr, char *buf,
> @@ -66,7 +66,7 @@ static inline ssize_t cpulist_read(struct file *file, struct kobject *kobj,
>  	return n;
>  }
>  
> -static BIN_ATTR_RO(cpulist, 0);
> +static BIN_ATTR_RO(cpulist, CPULIST_FILE_MAX_BYTES);
>  
>  /**
>   * struct node_access_nodes - Access class device to hold user visible
> diff --git a/drivers/base/topology.c b/drivers/base/topology.c
> index ac6ad9ab67f9..89f98be5c5b9 100644
> --- a/drivers/base/topology.c
> +++ b/drivers/base/topology.c
> @@ -62,47 +62,47 @@ define_id_show_func(ppin, "0x%llx");
>  static DEVICE_ATTR_ADMIN_RO(ppin);
>  
>  define_siblings_read_func(thread_siblings, sibling_cpumask);
> -static BIN_ATTR_RO(thread_siblings, 0);
> -static BIN_ATTR_RO(thread_siblings_list, 0);
> +static BIN_ATTR_RO(thread_siblings, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(thread_siblings_list, CPULIST_FILE_MAX_BYTES);
>  
>  define_siblings_read_func(core_cpus, sibling_cpumask);
> -static BIN_ATTR_RO(core_cpus, 0);
> -static BIN_ATTR_RO(core_cpus_list, 0);
> +static BIN_ATTR_RO(core_cpus, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(core_cpus_list, CPULIST_FILE_MAX_BYTES);
>  
>  define_siblings_read_func(core_siblings, core_cpumask);
> -static BIN_ATTR_RO(core_siblings, 0);
> -static BIN_ATTR_RO(core_siblings_list, 0);
> +static BIN_ATTR_RO(core_siblings, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(core_siblings_list, CPULIST_FILE_MAX_BYTES);
>  
>  #ifdef TOPOLOGY_CLUSTER_SYSFS
>  define_siblings_read_func(cluster_cpus, cluster_cpumask);
> -static BIN_ATTR_RO(cluster_cpus, 0);
> -static BIN_ATTR_RO(cluster_cpus_list, 0);
> +static BIN_ATTR_RO(cluster_cpus, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(cluster_cpus_list, CPULIST_FILE_MAX_BYTES);
>  #endif
>  
>  #ifdef TOPOLOGY_DIE_SYSFS
>  define_siblings_read_func(die_cpus, die_cpumask);
> -static BIN_ATTR_RO(die_cpus, 0);
> -static BIN_ATTR_RO(die_cpus_list, 0);
> +static BIN_ATTR_RO(die_cpus, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(die_cpus_list, CPULIST_FILE_MAX_BYTES);
>  #endif
>  
>  define_siblings_read_func(package_cpus, core_cpumask);
> -static BIN_ATTR_RO(package_cpus, 0);
> -static BIN_ATTR_RO(package_cpus_list, 0);
> +static BIN_ATTR_RO(package_cpus, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(package_cpus_list, CPULIST_FILE_MAX_BYTES);
>  
>  #ifdef TOPOLOGY_BOOK_SYSFS
>  define_id_show_func(book_id, "%d");
>  static DEVICE_ATTR_RO(book_id);
>  define_siblings_read_func(book_siblings, book_cpumask);
> -static BIN_ATTR_RO(book_siblings, 0);
> -static BIN_ATTR_RO(book_siblings_list, 0);
> +static BIN_ATTR_RO(book_siblings, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(book_siblings_list, CPULIST_FILE_MAX_BYTES);
>  #endif
>  
>  #ifdef TOPOLOGY_DRAWER_SYSFS
>  define_id_show_func(drawer_id, "%d");
>  static DEVICE_ATTR_RO(drawer_id);
>  define_siblings_read_func(drawer_siblings, drawer_cpumask);
> -static BIN_ATTR_RO(drawer_siblings, 0);
> -static BIN_ATTR_RO(drawer_siblings_list, 0);
> +static BIN_ATTR_RO(drawer_siblings, CPUMAP_FILE_MAX_BYTES);
> +static BIN_ATTR_RO(drawer_siblings_list, CPULIST_FILE_MAX_BYTES);
>  #endif
>  
>  static struct bin_attribute *bin_attrs[] = {
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index fe29ac7cc469..4592d0845941 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -1071,4 +1071,22 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
>  	[0] =  1UL							\
>  } }
>  
> +/*
> + * Provide a valid theoretical max size for cpumap and cpulist sysfs files
> + * to avoid breaking userspace which may allocate a buffer based on the size
> + * reported by e.g. fstat.
> + *
> + * for cpumap NR_CPUS * 9/32 - 1 should be an exact length.
> + *
> + * For cpulist 7 is (ceil(log10(NR_CPUS)) + 1) allowing for NR_CPUS to be up
> + * to 2 orders of magnitude larger than 8192. And then we divide by 2 to
> + * cover a worst-case of every other cpu being on one of two nodes for a
> + * very large NR_CPUS.
> + *
> + *  Use PAGE_SIZE as a minimum for smaller configurations.
> + */
> +#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
> +					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
> +#define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
> +
>  #endif /* __LINUX_CPUMASK_H */
> -- 
> 2.31.1
