Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448BA549CA3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346886AbiFMTBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346311AbiFMTAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:00:54 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A94A2DD72;
        Mon, 13 Jun 2022 09:27:34 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7AAAA20BA5A7;
        Mon, 13 Jun 2022 09:27:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7AAAA20BA5A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655137654;
        bh=/qpneIaXgCEUFQH7gFgUkKTtF8803lByIPiZ1KxLBA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IGMV2vH6NSqdUPMcxV2+Q36SOixGyuGLw17xQUDm8DcKNSvm3rV5U0zX34JjN8qsU
         IO6llWd74e03MNOcjCA+GvYUaL9Q7JwwtCRIIK7H4wtpVzBctn01zg7VEkae9gPLsk
         VTjUVUY1AinBLGemcB2f1MhyGcXWTyl46RuGYI1Y=
Date:   Mon, 13 Jun 2022 11:27:30 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Jianyong Wu <jianyong.wu@arm.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/06] 9p: fix fid refcount leak in
 v9fs_vfs_atomic_open_dotl
Message-ID: <20220613162730.GB7401@sequoia>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
 <20220612085330.1451496-2-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612085330.1451496-2-asmadeus@codewreck.org>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-06-12 17:53:24, Dominique Martinet wrote:
> We need to release directory fid if we fail halfway through open
> 
> This fixes fid leaking with xfstests generic 531
> 
> Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
> Cc: stable@vger.kernel.org
> Reported-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  fs/9p/vfs_inode_dotl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index d17502a738a9..b6eb1160296c 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -274,6 +274,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
>  	if (IS_ERR(ofid)) {
>  		err = PTR_ERR(ofid);
>  		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
> +		p9_client_clunk(dfid);
>  		goto out;
>  	}
>  
> @@ -285,6 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
>  	if (err) {
>  		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
>  			 err);
> +		p9_client_clunk(dfid);
>  		goto error;
>  	}
>  	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
> @@ -292,6 +294,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
>  	if (err < 0) {
>  		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
>  			 err);
> +		p9_client_clunk(dfid);
>  		goto error;
>  	}
>  	v9fs_invalidate_inode_attr(dir);
> -- 
> 2.35.1
> 
