Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF1E39AE8C
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 01:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFCXXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 19:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCXXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 19:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A6BF6140A;
        Thu,  3 Jun 2021 23:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622762492;
        bh=Gak9x0Jsv0qhm09RFUhZ1Xt3qmQIL2Xcnz1VL+vQr28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hnm0DfXImrd2t+ksfCfL4lH+3Bf6b0GvdQogi1TgrfkZF7HYbH7FbBFZ3QdIVScqB
         kPoVBtJWEzjR9CFggZf4ciU8taNYZjseLf6viVUl+ZGxIIuPyAmhwdgqWa3HrlM2dv
         puzF5QVdwhMevqBw3EQeUTF0ubVH/zc5Xa1hMZJzGUs+UNJXbqJButL5V/ag5jooF0
         nQtclPG5xz9E4T4Z3DBiIXuJF9xz/RqNCF6cQleau46SrFB4JFUVERTjt11OhzE4h9
         6ysQXwp96mroYEYleFG758g251MtnRrKJv53y51agwjEf5HxSzH5+DpmWni15U18oq
         PJiXQGc58+GhQ==
Date:   Thu, 3 Jun 2021 16:21:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Message-ID: <YLlj+h4RiT6FvyK6@sol.localdomain>
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
> @@ -579,6 +582,7 @@ enum feat_id {
>  	FEAT_CASEFOLD,
>  	FEAT_COMPRESSION,
>  	FEAT_TEST_DUMMY_ENCRYPTION_V2,
> +	FEAT_ENCRYPTED_CASEFOLD,
>  };

Actually looking at it more closely, this patch is wrong.

It only makes sense to declare "encrypted_casefold" as a feature of the
filesystem implementation, i.e. /sys/fs/f2fs/features/encrypted_casefold.

It does *not* make sense to declare it as a feature of a particular filesystem
instance, i.e. /sys/fs/f2fs/$disk/features, as it is already implied by the
filesystem instance having both the encryption and casefold features enabled.

Can we add /sys/fs/f2fs/features/encrypted_casefold only?

- Eric
