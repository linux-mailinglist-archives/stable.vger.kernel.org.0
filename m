Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46480549CAB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346038AbiFMTBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiFMTA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:00:56 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A41892DD69;
        Mon, 13 Jun 2022 09:29:54 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id C9DB120BE530;
        Mon, 13 Jun 2022 09:29:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C9DB120BE530
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655137794;
        bh=VHKLq2BI+ptgotAr2Y/DtZAYZ5G9EvxX5w++UzCKBJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pzj/hgNUG7ikF8xXWIFd7nKIh7dKYgZQNn8csX0Ya4DJiuWAPqmIMkwCf2pOz9QXC
         ShumvvFjhi9MhqDlX/dLwh85vCqeQkA9nMxUbUFLgfe7oc6hilR6/nNnvKDs1tz9wC
         TD5WFKlQ3xBp950c4hfCgf6kL7bybeDac2yDEbVQ=
Date:   Mon, 13 Jun 2022 11:29:50 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Jianyong Wu <jianyong.wu@arm.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/06] 9p: fix fid refcount leak in v9fs_vfs_get_link
Message-ID: <20220613162950.GC7401@sequoia>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
 <20220612085330.1451496-3-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612085330.1451496-3-asmadeus@codewreck.org>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-06-12 17:53:25, Dominique Martinet wrote:
> we check for protocol version later than required, after a fid has
> been obtained. Just move the version check earlier.
> 
> Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
> Cc: stable@vger.kernel.org

Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  fs/9p/vfs_inode.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 55367ecb9442..18c780ffd4b5 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1250,15 +1250,15 @@ static const char *v9fs_vfs_get_link(struct dentry *dentry,
>  		return ERR_PTR(-ECHILD);
>  
>  	v9ses = v9fs_dentry2v9ses(dentry);
> -	fid = v9fs_fid_lookup(dentry);
> +	if (!v9fs_proto_dotu(v9ses))
> +		return ERR_PTR(-EBADF);
> +
>  	p9_debug(P9_DEBUG_VFS, "%pd\n", dentry);
> +	fid = v9fs_fid_lookup(dentry);
>  
>  	if (IS_ERR(fid))
>  		return ERR_CAST(fid);
>  
> -	if (!v9fs_proto_dotu(v9ses))
> -		return ERR_PTR(-EBADF);
> -
>  	st = p9_client_stat(fid);
>  	p9_client_clunk(fid);
>  	if (IS_ERR(st))
> -- 
> 2.35.1
> 
