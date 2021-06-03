Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87294399E6F
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhFCKHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 06:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhFCKHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 06:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CBA2611CA;
        Thu,  3 Jun 2021 10:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622714699;
        bh=ruv4xX6Eg/YETRybxUhFp8CkZkACBGmGpdG3fCfTNYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G45+ZBzfThzxAH4ZUIGo4rpnqPa6od3F0KNjIxTAh/TfAMROu2xvHCoQTFNLRtRb7
         BVcbWAi/urwY1OQkhDRsSjlzoctHOVjWIvz/j86jj2PtZ3fpaiABbrWwE8vyQqkfIB
         KiKruC8CbO0DqbV4tOWh2O0khvtt4TUDlSTFEYV8=
Date:   Thu, 3 Jun 2021 12:04:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Message-ID: <YLipSQxNaUDy9Ff1@kroah.com>
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-3-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603095038.314949-3-drosen@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 09:50:38AM +0000, Daniel Rosenberg wrote:
> Older kernels don't support encryption with casefolding. This adds
> the sysfs entry encrypted_casefold to show support for those combined
> features. Support for this feature was originally added by
> commit 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> 
> Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> Cc: stable@vger.kernel.org # v5.11+
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> ---
>  fs/f2fs/sysfs.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
> index 09e3f258eb52..6604291a3cdf 100644
> --- a/fs/f2fs/sysfs.c
> +++ b/fs/f2fs/sysfs.c
> @@ -161,6 +161,9 @@ static ssize_t features_show(struct f2fs_attr *a,
>  	if (f2fs_sb_has_compression(sbi))
>  		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
>  				len ? ", " : "", "compression");
> +	if (f2fs_sb_has_casefold(sbi) && f2fs_sb_has_encrypt(sbi))
> +		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> +				len ? ", " : "", "encrypted_casefold");
>  	len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
>  				len ? ", " : "", "pin_file");
>  	len += scnprintf(buf + len, PAGE_SIZE - len, "\n");

This is a HUGE abuse of sysfs and should not be encouraged and added to.

Please make these "one value per file" and do not keep growing a single
file that has to be parsed otherwise you will break userspace tools.

And I don't see a Documentation/ABI/ entry for this either :(

not good...

greg k-h
