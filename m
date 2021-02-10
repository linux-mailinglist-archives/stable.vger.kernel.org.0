Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBD431662F
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 13:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhBJMMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 07:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231630AbhBJMKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 07:10:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F2F264E31;
        Wed, 10 Feb 2021 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612958966;
        bh=kqqb49qXsasdkSstetjMzcEMKwXctHVPfjOZKYUSEQ8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JxtImahqfsyEYtMz027sJyToIJwi0xLfP+wZBfojfVJrVrf2FV6/SvU5fzG2RSk5Y
         AMCwFdgS0MQxsrM9el7SkeziYHT9YKMUCcEmsY/yI0t83orL82gMT8pitm3tj+YClM
         QPQh9u3xGHlM97kgEtq5WtajDfusMAjDO2/sY25UWr/pcowkSwzWYGP0azR6CWX3iX
         QK8f+h5vYoun5WlHcwlPbqjUM7/bKaGUaxxJVTtcPrsfGQfSeEcUpWrhi4jShu1FUo
         95j4lYugp3n+fhW064Chhym7tipTMizLPqf2DVNk4o0ggBM2hx7mCY3zwv0jYkIJkS
         /LhAwhybrYcaw==
Subject: Re: [PATCH] erofs: initialized fields can only be observed after bit
 is set
To:     Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <20210209130618.15838-1-hsiangkao.ref@aol.com>
 <20210209130618.15838-1-hsiangkao@aol.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <ac5abccb-70ad-441b-a5b0-b8808ff37c00@kernel.org>
Date:   Wed, 10 Feb 2021 20:09:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209130618.15838-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiang,

On 2021/2/9 21:06, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Currently, although set_bit() & test_bit() pairs are used as a fast-
> path for initialized configurations. However, these atomic ops are
> actually relaxed forms. Instead, load-acquire & store-release form is
> needed to make sure uninitialized fields won't be observed in advance
> here (yet no such corresponding bitops so use full barriers instead.)
> 
> Fixes: 62dc45979f3f ("staging: erofs: fix race of initializing xattrs of a inode at the same time")
> Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
> Cc: <stable@vger.kernel.org> # 5.3+
> Reported-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>   fs/erofs/xattr.c | 10 +++++++++-
>   fs/erofs/zmap.c  | 10 +++++++++-
>   2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
> index 5bde77d70852..47314a26767a 100644
> --- a/fs/erofs/xattr.c
> +++ b/fs/erofs/xattr.c
> @@ -48,8 +48,14 @@ static int init_inode_xattrs(struct inode *inode)
>   	int ret = 0;
>   
>   	/* the most case is that xattrs of this inode are initialized. */
> -	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags))
> +	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags)) {
> +		/*
> +		 * paired with smp_mb() at the end of the function to ensure
> +		 * fields will only be observed after the bit is set.
> +		 */
> +		smp_mb();

I can understand below usage, since w/o smp_mb(), xattr initialization
could be done after set_bit(EROFS_I_EA_INITED_BIT), then other apps could
see out-of-update xattr info after that bit check.

So what out-of-order execution do we need to avoid by adding above barrier?

Thanks,

> +	/* paired with smp_mb() at the beginning of the function. */
> +	smp_mb();
>   	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
