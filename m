Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DB01BA537
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgD0Nmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 09:42:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:34888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgD0Nmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 09:42:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 919B1ADB5;
        Mon, 27 Apr 2020 13:42:50 +0000 (UTC)
Date:   Mon, 27 Apr 2020 08:42:47 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        krzysztof.struczynski@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ima: Set file->f_mode instead of file->f_flags in
 ima_calc_file_hash()
Message-ID: <20200427134247.vcpx6gyh62seucnf@fiona>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427102900.18887-1-roberto.sassu@huawei.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12:28 27/04, Roberto Sassu wrote:
> Commit a408e4a86b36 ("ima: open a new file instance if no read
> permissions") tries to create a new file descriptor to calculate a file
> digest if the file has not been opened with O_RDONLY flag. However, if a
> new file descriptor cannot be obtained, it sets the FMODE_READ flag to
> file->f_flags instead of file->f_mode.
> 
> This patch fixes this issue by replacing f_flags with f_mode as it was
> before that commit.

Thanks for fixing this.

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Changelog
> 
> v1:
> - fix comment for f_mode change (suggested by Mimi)
> - rename modified_flags variable to modified_mode (suggested by Mimi)
> 
> Cc: stable@vger.kernel.org # 4.20.x
> Fixes: a408e4a86b36 ("ima: open a new file instance if no read permissions")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/ima/ima_crypto.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 5201f5ec2ce4..f3a7f4eb1fc1 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -537,7 +537,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	loff_t i_size;
>  	int rc;
>  	struct file *f = file;
> -	bool new_file_instance = false, modified_flags = false;
> +	bool new_file_instance = false, modified_mode = false;
>  
>  	/*
>  	 * For consistency, fail file's opened with the O_DIRECT flag on
> @@ -557,13 +557,13 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  		f = dentry_open(&file->f_path, flags, file->f_cred);
>  		if (IS_ERR(f)) {
>  			/*
> -			 * Cannot open the file again, lets modify f_flags
> +			 * Cannot open the file again, lets modify f_mode
>  			 * of original and continue
>  			 */
>  			pr_info_ratelimited("Unable to reopen file for reading.\n");
>  			f = file;
> -			f->f_flags |= FMODE_READ;
> -			modified_flags = true;
> +			f->f_mode |= FMODE_READ;
> +			modified_mode = true;
>  		} else {
>  			new_file_instance = true;
>  		}
> @@ -581,8 +581,8 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  out:
>  	if (new_file_instance)
>  		fput(f);
> -	else if (modified_flags)
> -		f->f_flags &= ~FMODE_READ;
> +	else if (modified_mode)
> +		f->f_mode &= ~FMODE_READ;
>  	return rc;
>  }
>  
> -- 
> 2.17.1
> 

-- 
Goldwyn
