Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EDD2C3AB3
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 09:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgKYIMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 03:12:13 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:51218 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgKYIMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 03:12:12 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 03:12:11 EST
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 2ECA08AB47A;
        Wed, 25 Nov 2020 09:05:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1606291502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvcW9HZaeh1OandD5GIG39Q2Ayk1GgjH3J6qCgDWOJw=;
        b=vM8tr4dL6fv0m7XBgouKQNyYgrzoVJ+S3IiBMJqx9qJ/88tpWX0ZzHYs7Tfw7b4kXYPp+C
        R4pNvyP6feDj6a47yQUFhOLwZx5G+RjzwiRwjkk8xVX6fN8TahOlxEVJDi2OCY7yJWQBNb
        LWuWNT01K4XkzrXOCr3RXVlWn1XkD5o=
MIME-Version: 1.0
Date:   Wed, 25 Nov 2020 09:05:02 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, jk@ozlabs.org, mjg59@google.com,
        David.Laight@aculab.com,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] efivarfs: revert "fix memory leak in efivarfs_create()"
In-Reply-To: <20201125075303.3963-1-ardb@kernel.org>
References: <20201125075303.3963-1-ardb@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <97016e69314d90aef859ae6d98e4bb9c@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On 25.11.2020 08:53, Ard Biesheuvel wrote:
> The memory leak addressed by commit fe5186cf12e3 is a false positive:
> all allocations are recorded in a linked list, and freed when the
> filesystem is unmounted. This leads to double frees, and as reported
> by David, leads to crashes if SLUB is configured to self destruct when
> double frees occur.
> 
> So drop the redundant kfree() again, and instead, mark the offending
> pointer variable so the allocation is ignored by kmemleak.
> 
> Cc: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

Should also have:

Cc: <stable@vger.kernel.org> # v5.9

> Fixes: fe5186cf12e3 ("efivarfs: fix memory leak in efivarfs_create()")
> Reported-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  fs/efivarfs/inode.c | 1 +
>  fs/efivarfs/super.c | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index 96c0c86f3fff..38324427a2b3 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -103,6 +103,7 @@ static int efivarfs_create(struct inode *dir,
> struct dentry *dentry,
>  	var->var.VariableName[i] = '\0';
> 
>  	inode->i_private = var;
> +	kmemleak_ignore(var);
> 
>  	err = efivar_entry_add(var, &efivarfs_list);
>  	if (err)
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index f943fd0b0699..15880a68faad 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -21,7 +21,6 @@ LIST_HEAD(efivarfs_list);
>  static void efivarfs_evict_inode(struct inode *inode)
>  {
>  	clear_inode(inode);
> -	kfree(inode->i_private);
>  }
> 
>  static const struct super_operations efivarfs_ops = {

-- 
   Oleksandr Natalenko (post-factum)
