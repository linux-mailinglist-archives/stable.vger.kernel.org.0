Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC954B229
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 15:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244756AbiFNNR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 09:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiFNNRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 09:17:55 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CBA1A387;
        Tue, 14 Jun 2022 06:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=yPWorgb0nr92bflDyKeZ83J7zJKK6wo32UMgOsFApt0=; b=W5PkkAnkCNWBWUe9Ca6EUMymYt
        eptL/wb2mi7n+x+RtR8RLGWLarmhCRy6jO7jaYXItiBlm27vOnQrROJRMshwT+8RyBxV3jZhWTqFr
        l8lD+o/YsWyDhvYBqfazCd4dGi/tsWTXL65TVyk8wG8ys5jnTjhm1MVpKX5VPmgjGlS7bOl2QK4xC
        P/wti0pMCSAhvg3m3FJ7D5QyUIEAhum19ZcoTYoS3osWKaChRdVMaLR4WvEzXxztkrwo4YP6dEVsG
        bP8Cx7FMSRdXHn/5EflxYjnTpZLIZDzcLAj2hgj/4HbBVobVnr+QDN+p4AO3n0VIIz8q7cH1pQxJ+
        dxlNNQg3UbdSltXoNZiRXh6Lhg2CdZKmQeaM0Z3PmjfJlHzA+ubxYAzYAU+KFWopmhR/bmSuBjna/
        Icwlvx8FDroBO5YclKhpWb7M+kRTGZqQnToQzU7L0OlGrLsjl5EsXogNqMH6nS9RdZanJixETmiVX
        xmBwRNBzAJWr8Po0LckNZcrzHvKLuzCkKFYyrMOJBd90qyP7uWWcJtCsDmgpKtuPMuJRLH5aJ9mlT
        cHm63ENQGlf1pE8Z8BBxjath+Sug0S3sh97pjfW9ek06ah9CGPUxeaNtyYkbFBLK80oyc4IVeeriQ
        JcFQFUdphEIpns3qSm+68ExG1tEeBa9RyExdgGjJ0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jianyong Wu <jianyong.wu@arm.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/06] 9p: fix fid refcount leak in v9fs_vfs_atomic_open_dotl
Date:   Tue, 14 Jun 2022 15:17:46 +0200
Message-ID: <5002134.MN0KzyuZDv@silver>
In-Reply-To: <20220612085330.1451496-2-asmadeus@codewreck.org>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
 <20220612085330.1451496-2-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sonntag, 12. Juni 2022 10:53:24 CEST Dominique Martinet wrote:
> We need to release directory fid if we fail halfway through open
> 
> This fixes fid leaking with xfstests generic 531
> 
> Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
> Cc: stable@vger.kernel.org
> Reported-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

> ---
>  fs/9p/vfs_inode_dotl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index d17502a738a9..b6eb1160296c 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -274,6 +274,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct
> dentry *dentry, if (IS_ERR(ofid)) {
>  		err = PTR_ERR(ofid);
>  		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
> +		p9_client_clunk(dfid);
>  		goto out;
>  	}
> 
> @@ -285,6 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct
> dentry *dentry, if (err) {
>  		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
>  			 err);
> +		p9_client_clunk(dfid);
>  		goto error;
>  	}
>  	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
> @@ -292,6 +294,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct
> dentry *dentry, if (err < 0) {
>  		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
>  			 err);
> +		p9_client_clunk(dfid);
>  		goto error;
>  	}
>  	v9fs_invalidate_inode_attr(dir);




