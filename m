Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3218BF8B48
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 10:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKLJCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 04:02:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45470 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKLJCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 04:02:48 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iUS4S-0005xA-R8; Tue, 12 Nov 2019 09:02:44 +0000
Subject: Re: [PATCH][V2] ovl: fix lookup failure on multi lower squashfs
From:   Colin Ian King <colin.king@canonical.com>
To:     Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, stable@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191107104957.306383-1-colin.king@canonical.com>
Autocrypt: addr=colin.king@canonical.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <62aebc33-6887-e6c4-fe2e-79fb3ce0746e@canonical.com>
Date:   Tue, 12 Nov 2019 09:02:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191107104957.306383-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there,

I was wondering if this fix will get applied?

Colin

On 07/11/2019 10:49, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the past, overlayfs required that lower fs have non null uuid in
> order to support nfs export and decode copy up origin file handles.
> 
> Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of
> lower fs") relaxed this requirement for nfs export support, as long
> as uuid (even if null) is unique among all lower fs.
> 
> However, said commit unintentionally also relaxed the non null uuid
> requirement for decoding copy up origin file handles, regardless of
> the unique uuid requirement.
> 
> Amend this mistake by disabling decoding of copy up origin file handle
> from lower fs with a conflicting uuid.
> 
> We still encode copy up origin file handles from those fs, because
> file handles like those already exist in the wild and because they
> might provide useful information in the future.
> 
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Link: https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
> Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid ...")
> Cc: stable@vger.kernel.org # v4.20+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/overlayfs/namei.c     |  8 ++++++++
>  fs/overlayfs/ovl_entry.h |  2 ++
>  fs/overlayfs/super.c     | 16 ++++++++++------
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index e9717c2f7d45..f47c591402d7 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -325,6 +325,14 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>  	int i;
>  
>  	for (i = 0; i < ofs->numlower; i++) {
> +		/*
> +		 * If lower fs uuid is not unique among lower fs we cannot match
> +		 * fh->uuid to layer.
> +		 */
> +		if (ofs->lower_layers[i].fsid &&
> +		    ofs->lower_layers[i].fs->bad_uuid)
> +			continue;
> +
>  		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
>  					    connected);
>  		if (origin)
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index a8279280e88d..28348c44ea5b 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -22,6 +22,8 @@ struct ovl_config {
>  struct ovl_sb {
>  	struct super_block *sb;
>  	dev_t pseudo_dev;
> +	/* Unusable (conflicting) uuid */
> +	bool bad_uuid;
>  };
>  
>  struct ovl_layer {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index afbcb116a7f1..5d4faab57ba0 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1255,17 +1255,18 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
>  {
>  	unsigned int i;
>  
> -	if (!ofs->config.nfs_export && !(ofs->config.index && ofs->upper_mnt))
> -		return true;
> -
>  	for (i = 0; i < ofs->numlowerfs; i++) {
>  		/*
>  		 * We use uuid to associate an overlay lower file handle with a
>  		 * lower layer, so we can accept lower fs with null uuid as long
>  		 * as all lower layers with null uuid are on the same fs.
> +		 * if we detect multiple lower fs with the same uuid, we
> +		 * disable lower file handle decoding on all of them.
>  		 */
> -		if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid))
> +		if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid)) {
> +			ofs->lower_fs[i].bad_uuid = true;
>  			return false;
> +		}
>  	}
>  	return true;
>  }
> @@ -1277,6 +1278,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
>  	unsigned int i;
>  	dev_t dev;
>  	int err;
> +	bool bad_uuid = false;
>  
>  	/* fsid 0 is reserved for upper fs even with non upper overlay */
>  	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
> @@ -1287,10 +1289,11 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
>  			return i + 1;
>  	}
>  
> -	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> +	if (ofs->upper_mnt && !ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> +		bad_uuid = true;
>  		ofs->config.index = false;
>  		ofs->config.nfs_export = false;
> -		pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
> +		pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', enforcing index=off,nfs_export=off.\n",
>  			uuid_is_null(&sb->s_uuid) ? "null" : "conflicting",
>  			path->dentry);
>  	}
> @@ -1303,6 +1306,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
>  
>  	ofs->lower_fs[ofs->numlowerfs].sb = sb;
>  	ofs->lower_fs[ofs->numlowerfs].pseudo_dev = dev;
> +	ofs->lower_fs[ofs->numlowerfs].bad_uuid = bad_uuid;
>  	ofs->numlowerfs++;
>  
>  	return ofs->numlowerfs;
> 

