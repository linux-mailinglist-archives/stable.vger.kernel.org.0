Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE84333E177
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 23:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhCPWgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 18:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhCPWgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 18:36:02 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0130CC06174A;
        Tue, 16 Mar 2021 15:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=xvzZnCWrKZT0JYHkyAEkkHGmKAdznp6+1YwBcbQSrOg=; b=SmtyiZMBSnHke3kLrzs7mUN8YT
        LZb+zuHCPWAIk/mJfTSwvpukCETivUB0LCjz8wQoVvAhxb4DOdxLWa+yOXZAu6WdDpcWrr5mxNeWZ
        RPvTz7P0U2/giBjwEerlIePvLIr/imEEgr8owZiEdIXZpvD7tCT4glaLWzbn++BP0mZfnQk7LOzrr
        u4mmU12mF54kAGoILJQh64YMSgSVtafxwMal9CUaKaPWWmCpbX2qO3/wE26pLD2v7rPko5rHkJ/9M
        eCZyWTUrcWh8AlIuibNPn5MnD/5cGHHkrd9IEPSxV6pDGSBKd50n8Y3LueEGK7DuIrGUo9pYbkVn2
        l8la76eA==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMII9-001XnS-Ad; Tue, 16 Mar 2021 22:35:57 +0000
Subject: Re: [PATCH] NFS: fs_context: validate UDP retrans to prevent shift
 out-of-bounds
To:     linux-kernel@vger.kernel.org
Cc:     syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com,
        syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
References: <20210302001930.2253-1-rdunlap@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b98720c9-2798-f168-eaaa-01d638d9900d@infradead.org>
Date:   Tue, 16 Mar 2021 15:35:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302001930.2253-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping?

On 3/1/21 4:19 PM, Randy Dunlap wrote:
> Fix shift out-of-bounds in xprt_calc_majortimeo(). This is caused
> by a garbage timeout (retrans) mount option being passed to nfs mount,
> in this case from syzkaller.
> 
> If the protocol is XPRT_TRANSPORT_UDP, then 'retrans' is a shift
> value for a 64-bit long integer, so 'retrans' cannot be >= 64.
> If it is >= 64, fail the mount and return an error.
> 
> Fixes: 9954bf92c0cd ("NFS: Move mount parameterisation bits into their own file")
> Reported-by: syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com
> Reported-by: syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: Anna Schumaker <anna.schumaker@netapp.com>
> Cc: linux-nfs@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> ---
>  fs/nfs/fs_context.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> --- lnx-512-rc1.orig/fs/nfs/fs_context.c
> +++ lnx-512-rc1/fs/nfs/fs_context.c
> @@ -974,6 +974,15 @@ static int nfs23_parse_monolithic(struct
>  			       sizeof(mntfh->data) - mntfh->size);
>  
>  		/*
> +		 * for proto == XPRT_TRANSPORT_UDP, which is what uses
> +		 * to_exponential, implying shift: limit the shift value
> +		 * to BITS_PER_LONG (majortimeo is unsigned long)
> +		 */
> +		if (!(data->flags & NFS_MOUNT_TCP)) /* this will be UDP */
> +			if (data->retrans >= 64) /* shift value is too large */
> +				goto out_invalid_data;
> +
> +		/*
>  		 * Translate to nfs_fs_context, which nfs_fill_super
>  		 * can deal with.
>  		 */
> @@ -1073,6 +1082,9 @@ out_no_address:
>  
>  out_invalid_fh:
>  	return nfs_invalf(fc, "NFS: invalid root filehandle");
> +
> +out_invalid_data:
> +	return nfs_invalf(fc, "NFS: invalid binary mount data");
>  }
>  
>  #if IS_ENABLED(CONFIG_NFS_V4)
> 


-- 
~Randy

