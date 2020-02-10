Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194AC15836E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgBJTR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:17:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgBJTR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:17:59 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ED2E20661;
        Mon, 10 Feb 2020 19:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581362278;
        bh=ZyB0HayJV9hA11EQE3OHddet92bzHEDctB8rpbAnB2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JjcZB5vn0hUrVokfNT8lpRNWPpvf6xsZ2XP8QGuI4TuiuMUmBl7rECwc++d/GJtv4
         cSdjcYYCvTkpCV9T2upXleimEwzmh6OUdTftd8tZynfo8dRKWMolDaOyDmW7D3b78o
         7CBSY4X4loVfQg71m2RNPCZXUgsz0m4JKBWGhEVg=
Date:   Mon, 10 Feb 2020 11:17:57 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>
Subject: Re: [EXTERNAL] [PATCH 5.4 303/309] cifs: fix mode bits from dir
 listing when mounted with modefromsid
Message-ID: <20200210191757.GA1098324@kroah.com>
References: <20200210122406.106356946@linuxfoundation.org>
 <20200210122436.056141941@linuxfoundation.org>
 <BY5PR21MB14279039445B44E57437E16CB6190@BY5PR21MB1427.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR21MB14279039445B44E57437E16CB6190@BY5PR21MB1427.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 07:10:00PM +0000, Pavel Shilovskiy wrote:
> 
> -----Original Message Begin-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
> Sent: Monday, February 10, 2020 4:34 AM
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Aurelien Aptel <aaptel@suse.com>; Steven French <Steven.French@microsoft.com>; Pavel Shilovskiy <pshilov@microsoft.com>
> Subject: [EXTERNAL] [PATCH 5.4 303/309] cifs: fix mode bits from dir listing when mounted with modefromsid
> 
> From: Aurelien Aptel <aaptel@suse.com>
> 
> commit e3e056c35108661e418c803adfc054bf683426e7 upstream.
> 
> When mounting with -o modefromsid, the mode bits are stored in an ACE. Directory enumeration (e.g. ls -l /mnt) triggers an SMB Query Dir which does not include ACEs in its response. The mode bits in this case are silently set to a default value of 755 instead.
> 
> This patch marks the dentry created during the directory enumeration as needing re-evaluation (i.e. additional Query Info with ACEs) so that the mode bits can be properly extracted.
> 
> Quick repro:
> 
> $ mount.cifs //win19.test/data /mnt -o ...,modefromsid $ touch /mnt/foo && chmod 751 /mnt/foo $ stat /mnt/foo
>   # reports 751 (OK)
> $ sleep 2
>   # dentry older than 1s by default get invalidated $ ls -l /mnt
>   # since dentry invalid, ls does a Query Dir
>   # and reports foo as 755 (WRONG)
> 
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> CC: Stable <stable@vger.kernel.org>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  fs/cifs/readdir.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -174,7 +174,8 @@ cifs_fill_common_info(struct cifs_fattr
>  	 * may look wrong since the inodes may not have timed out by the time
>  	 * "ls" does a stat() call on them.
>  	 */
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
> +	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
> +	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
>  		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
>  
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
> 
> -----Original Message End-----
> 
> Hi Greg,
> 
> This patch fixes the following commit that was introduced in v5.5:
> 
> commit fdef665ba44ad5ed154af2acfb19ae2ee3bf5dcc
> Author: Steve French <stfrench@microsoft.com>
> Date:   Fri Dec 6 02:02:38 2019 -0600
> 
>     smb3: fix mode passed in on create for modetosid mount option
> 
> 
> Please remove the patch from all stable trees expect 5.5.y.

Now dropped, thanks for letting me know.

greg k-h
