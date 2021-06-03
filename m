Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFD339A9FE
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFCS2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 14:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhFCS2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 14:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FFF4613B8;
        Thu,  3 Jun 2021 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622744784;
        bh=KS86fETWmO2r8Ciw4jfg1Y3IIHZrd2X3PoK1uPLexhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdffuVn5maDp6qAdluN5DK6pj9KzZtIaIYSdpleY1s6xLX+PpN2v+HjUqgS8OgfIn
         /+dwcdf7hF62TFGeow+zYe5D+adGRaYLmiIQmZADTZsmoGiZteHpfg24TZats8yVQ/
         oeN4ul5ClnbOW4ZLXmzjo3JeCT9g1105lRjTBXz/dMXN5Wkfe5FANtk7+HfXvKvryp
         6zYYr2zH0WmD03A/pDyqQQN6K8emJRMgisXm8hhsIKrnUkVd/7xY4Uon/HzxLHkPjo
         oCsLA7B1LbtWM5zhiAwOvByGaQn90Ren6UwejPXX3fMV/modlI4yoLm5HhK7Mxwyuu
         S8HA2wXDfbUUw==
Date:   Thu, 3 Jun 2021 11:26:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Message-ID: <YLkezhSmr+aC0v9p@sol.localdomain>
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
>  
>  static ssize_t f2fs_feature_show(struct f2fs_attr *a,
> @@ -600,6 +604,7 @@ static ssize_t f2fs_feature_show(struct f2fs_attr *a,
>  	case FEAT_CASEFOLD:
>  	case FEAT_COMPRESSION:
>  	case FEAT_TEST_DUMMY_ENCRYPTION_V2:
> +	case FEAT_ENCRYPTED_CASEFOLD:
>  		return sprintf(buf, "supported\n");
>  	}
>  	return 0;
> @@ -704,7 +709,10 @@ F2FS_GENERAL_RO_ATTR(avg_vblocks);
>  #ifdef CONFIG_FS_ENCRYPTION
>  F2FS_FEATURE_RO_ATTR(encryption, FEAT_CRYPTO);
>  F2FS_FEATURE_RO_ATTR(test_dummy_encryption_v2, FEAT_TEST_DUMMY_ENCRYPTION_V2);
> -#endif
> +#ifdef CONFIG_UNICODE
> +F2FS_FEATURE_RO_ATTR(encrypted_casefold, FEAT_ENCRYPTED_CASEFOLD);
> +#endif /* CONFIG_UNICODE */
> +#endif /* CONFIG_FS_ENCRYPTION */

I had only asked for the #endif comment for CONFIG_FS_ENCRYPTION, since that is
a longer block.  #endif comments aren't helpful for single-line blocks.
See Documentation/process/coding-style.rst:

	At the end of any non-trivial #if or #ifdef block (more than a few lines),
	place a comment after the #endif on the same line, noting the conditional
	expression used.

Anyway, doesn't matter much...

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
