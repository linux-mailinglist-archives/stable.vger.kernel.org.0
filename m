Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB54144D72D
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 14:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhKKN3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 08:29:13 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44668 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhKKN3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 08:29:09 -0500
Received: from [IPv6:2a00:23c7:68b7:9701:265e:513:1aea:5fb7] (unknown [IPv6:2a00:23c7:68b7:9701:265e:513:1aea:5fb7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: obbardc)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 3B7651F45C03;
        Thu, 11 Nov 2021 13:26:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1636637179; bh=ws9AI98ohBYaWMhz8Pzoz4nmMkKBzFjzqgFAClF1QUE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pUM9C6ciVyrsxvmWoIgVoW4izCxl5ErhgUS2Zx2dt40zQO9mOHh8amWcFAJ5e216t
         7SH5csRmVCKPh4l3x/J//5AJg2uoFQZTvp48wsW2IIZeSTDRZLtLa+GVXJQc1scBb7
         02Y0S7mRW96XE2BM9PgAL6CKebD2xw3ima0qSYbXrlBRtXCtnTdZYgHq5s0uQw9ZDF
         PSPxB9MKjcXonX3X+3btAk9LnqKhDugaZJ6lNGhSho9Ptm9ulREJfrKYUWPzg2wH55
         qx2BTvsJ0TxRVHHvnAvufer6hc4pt/tfushVjSLjc+QbvL1/qcCI7eQX/1FhQi47su
         bT5M0mj8BZlEg==
Subject: Re: [PATCH] hostfs: Fix writeback of dirty pages
To:     Sjoerd Simons <sjoerd@collabora.com>, linux-um@lists.infradead.org
Cc:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211105081052.2353801-1-sjoerd@collabora.com>
From:   Christopher Obbard <chris.obbard@collabora.com>
Message-ID: <d9bcb237-39e1-29b1-9718-b720a7e7540b@collabora.com>
Date:   Thu, 11 Nov 2021 13:26:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211105081052.2353801-1-sjoerd@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sjoerd,

On 05/11/2021 08:10, Sjoerd Simons wrote:
> Hostfs was not setting up the backing device information, which means it
> uses the noop bdi. The noop bdi does not have the writeback capability
> enabled, which in turns means  dirty pages never got written back to
> storage.
> 
> In other words programs using mmap to write to files on  hostfs never
> actually got their data written out...
> 
> Fix this by simply setting up the bdi with default settings as all the
> required code for writeback is already in place.
> 
> Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>

Cc: stable@vger.kernel.org
Reviewed-by: Christopher Obbard <chris.obbard@collabora.com>

...replying mainly as I wonder if adding the stable tag in a reply will 
make the patch appear in stable (obviously once it is in mainline) ? :-)


> 
> ---
> 
>   fs/hostfs/hostfs_kern.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
> index d5c9d886cd9f..ef481c3d9019 100644
> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -924,6 +924,9 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
>   	sb->s_op = &hostfs_sbops;
>   	sb->s_d_op = &simple_dentry_operations;
>   	sb->s_maxbytes = MAX_LFS_FILESIZE;
> +	err = super_setup_bdi(sb);
> +	if (err)
> +		goto out;
>   
>   	/* NULL is printed as '(null)' by printf(): avoid that. */
>   	if (req_root == NULL)
>
