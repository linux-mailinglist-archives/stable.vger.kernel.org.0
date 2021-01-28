Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B8530743E
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 11:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhA1K6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 05:58:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:44294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhA1K6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 05:58:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 12BA9ACF4;
        Thu, 28 Jan 2021 10:57:24 +0000 (UTC)
Subject: Re: [PATCH] bcache: only check feature sets when sb->version >=
 BCACHE_SB_VERSION_CDEV_WITH_FEATURES
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org,
        Bockholdt Arne <a.bockholdt@precitec-optronik.de>
References: <20210128104847.22773-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <69e0beed-9667-7d28-04cf-418e9a996038@suse.de>
Date:   Thu, 28 Jan 2021 18:57:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128104847.22773-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/21 6:48 PM, Coly Li wrote:
> For super block version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES, it
> doesn't make sense to check the feature sets. This patch checks
> super block version in bch_has_feature_* routines, if the version
> doesn't have feature sets yet, returns 0 (false) to the caller.
> 
> Fixes: 5342fd425502 ("bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET") 
> Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
> Cc: stable@vger.kernel.org # 5.9+
> Reported-and-tested-by: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
> Signed-off-by: Coly Li <colyli@suse.de>

Hi Jens,

Please take this patch for v5.11-rc6, this is necessary to go with other
fixes in previous wave.

Thank you in advance.

Coly Li


> ---
>  drivers/md/bcache/features.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
> index 84fc2c0f0101..d1c8fd3977fc 100644
> --- a/drivers/md/bcache/features.h
> +++ b/drivers/md/bcache/features.h
> @@ -33,6 +33,8 @@
>  #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
>  static inline int bch_has_feature_##name(struct cache_sb *sb) \
>  { \
> +	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
> +		return 0; \
>  	return (((sb)->feature_compat & \
>  		BCH##_FEATURE_COMPAT_##flagname) != 0); \
>  } \
> @@ -50,6 +52,8 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
>  #define BCH_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
>  static inline int bch_has_feature_##name(struct cache_sb *sb) \
>  { \
> +	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
> +		return 0; \
>  	return (((sb)->feature_ro_compat & \
>  		BCH##_FEATURE_RO_COMPAT_##flagname) != 0); \
>  } \
> @@ -67,6 +71,8 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
>  #define BCH_FEATURE_INCOMPAT_FUNCS(name, flagname) \
>  static inline int bch_has_feature_##name(struct cache_sb *sb) \
>  { \
> +	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
> +		return 0; \
>  	return (((sb)->feature_incompat & \
>  		BCH##_FEATURE_INCOMPAT_##flagname) != 0); \
>  } \
> 

