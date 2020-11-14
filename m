Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC92B2CD4
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 12:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgKNLLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 06:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgKNLLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 06:11:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC767C0613D1;
        Sat, 14 Nov 2020 03:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c2ywRzbolqgg0PiY4dTP6tEXg/1GMWOqYqpkIhQPtFA=; b=AIV3rfSG62BHj0VPqVdppa27MP
        aQ0RDNa3035+upEk4F2pw5ABYaUHP6HZolx/lUdmmMypkquJZLCHPPMAjgTpVGvhurvBLKiZ1j1G6
        1NuApnTvmLVK2tdMEdzEiyjnMBNu/AwxAnfIXBlE6ZjHycSEu9Edz99WrHpZZ/XK07nFrcEyuYs0E
        X/ZEiEuuxOdcWZsmyWKcT3MayniVj2uuI0SIrakOUp/966DgS1S6D/iBDVTfucqGD68ckNsqNB9lz
        dP61AJDZuf4FssDcwD63t4T0N/Gtae0lrRLLOaV4ag3bqb3tY0tITGUSrxFJmRdJgRYNBDtdoFiCV
        nTgZmf6w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdtSL-0004dJ-7U; Sat, 14 Nov 2020 11:10:57 +0000
Date:   Sat, 14 Nov 2020 11:10:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Message-ID: <20201114111057.GA16415@infradead.org>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113080132.16591-1-roberto.sassu@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 09:01:32AM +0100, Roberto Sassu wrote:
> Commit a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
> replaced the __vfs_read() call in integrity_kernel_read() with
> __kernel_read(), a new helper introduced by commit 61a707c543e2a ("fs: add
> a __kernel_read helper").
> 
> Since the new helper requires that also the FMODE_CAN_READ flag is set in
> file->f_mode, this patch saves the original f_mode and sets the flag if the
> the file descriptor has the necessary file operation. Lastly, it restores
> the original f_mode at the end of ima_calc_file_hash().

This looks bogus.  FMODE_CAN_READ has a pretty clear definition and
you can't just go and read things if it is not set.  Also f_mode
manipulations on a life file are racy.

> 
> Cc: stable@vger.kernel.org # 5.8.x
> Fixes: a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/ima/ima_crypto.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 21989fa0c107..22ed86a0c964 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -537,6 +537,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	loff_t i_size;
>  	int rc;
>  	struct file *f = file;
> +	fmode_t saved_mode;
>  	bool new_file_instance = false, modified_mode = false;
>  
>  	/*
> @@ -550,7 +551,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	}
>  
>  	/* Open a new file instance in O_RDONLY if we cannot read */
> -	if (!(file->f_mode & FMODE_READ)) {
> +	if (!(file->f_mode & FMODE_READ) || !(file->f_mode & FMODE_CAN_READ)) {
>  		int flags = file->f_flags & ~(O_WRONLY | O_APPEND |
>  				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
>  		flags |= O_RDONLY;
> @@ -562,7 +563,10 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  			 */
>  			pr_info_ratelimited("Unable to reopen file for reading.\n");
>  			f = file;
> +			saved_mode = f->f_mode;
>  			f->f_mode |= FMODE_READ;
> +			if (likely(file->f_op->read || file->f_op->read_iter))
> +				f->f_mode |= FMODE_CAN_READ;
>  			modified_mode = true;
>  		} else {
>  			new_file_instance = true;
> @@ -582,7 +586,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	if (new_file_instance)
>  		fput(f);
>  	else if (modified_mode)
> -		f->f_mode &= ~FMODE_READ;
> +		f->f_mode = saved_mode;
>  	return rc;
>  }
>  
> -- 
> 2.27.GIT
> 
---end quoted text---
