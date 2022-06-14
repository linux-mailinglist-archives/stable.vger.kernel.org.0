Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E1054B231
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiFNNUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 09:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiFNNUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 09:20:14 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758933BA4F;
        Tue, 14 Jun 2022 06:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=DLyhQU5lJWhVZZVn72cR39+qTOXv1WDBApcB+gX5W6Y=; b=is5MvyS4fDXL9ODiNPfhnVUzUA
        TRRGM4PWmgxe+lPztWRKwlK6XrT3axY7amNxmy+CrE0Uk7MhPN7TZWrtuuKxhkmeKUlvFU9wz4eEa
        ifNpaYgDtWRVK/txseObyy0BGjr0kzusLpu2hOYzkGKs5NeFbgUOWYngZJkoMKatpva4ee3xw89hM
        Y7XI3Ofz7v04vzDOh5UXpHYTAn/Zqnqw1pjwFs5Z+jPBiDGnN6+Fc9gtbsOXkuk8mTC+OMlLMphOU
        zeJR167bSUUKNpcxdrwqTaAzo1KTA3DPeazeiLj4p6DqZE90pQ975msHts7MJzm9CVq3A0diZ1RAB
        z8JviEu32WnMEgS3AQS8p7wHRLLfq6z9YZO7XIrY08Tzso5EQe8I1/n5cBb6o5eHlol1VIKndV729
        w/tgs/P85mMOKZXAlLEMxKy5A0G3E8zL2gvYKA4kyEHPYtna2UdKSdTppsNAl1xrjIqJq8DeWyQU0
        sj7i4QlkNjq52Mp+CrvQvdwSJlTh4NS/CBAHvMmNJTgSO+9FnUt9TO5xJ6MOcI5Y5pE/bqe5p0pKK
        frCt3cXRzicaWyWx2Co59FJYaHZhsC8Ubo2IGy9Dm6Le7lfGOS+lrhEJABFmKF1aEaAovhpAFrXvd
        f38uaYm53uv9+AkZy34D7XyhLFQsKNc/nF10hRo/Y=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jianyong Wu <jianyong.wu@arm.com>,
        v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 02/06] 9p: fix fid refcount leak in v9fs_vfs_get_link
Date:   Tue, 14 Jun 2022 15:19:55 +0200
Message-ID: <3172397.lbAG7NvT7i@silver>
In-Reply-To: <20220612085330.1451496-3-asmadeus@codewreck.org>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
 <20220612085330.1451496-3-asmadeus@codewreck.org>
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

On Sonntag, 12. Juni 2022 10:53:25 CEST Dominique Martinet wrote:
> we check for protocol version later than required, after a fid has
> been obtained. Just move the version check earlier.
> 
> Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

>  fs/9p/vfs_inode.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 55367ecb9442..18c780ffd4b5 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1250,15 +1250,15 @@ static const char *v9fs_vfs_get_link(struct dentry
> *dentry, return ERR_PTR(-ECHILD);
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




