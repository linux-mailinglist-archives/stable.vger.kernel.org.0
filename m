Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9831AD806
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 09:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgDQHxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 03:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbgDQHxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 03:53:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E14C061A0C;
        Fri, 17 Apr 2020 00:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q5yoPHJCkMbeyhbAEdK16CGWUtkEt6yQeeOm9280kIA=; b=mt7rGzwBoRbi0ELfc3cA+epBtT
        pFHc/KJ2++BbuqlNzuvQGtT9EFknpqUBTHghxHsPIBpyhCaRzRIAfWxs9HX+NLEx+dw2qNOKyjJUX
        pQrnWj8MVoRiS0y6I3Mekai8z7E9OQnnrwfY3jg9MmaKIapoadc6hvRZqHLw9rep5hFioN2rkYN9r
        U6kmhyrm/CvT0qHOQwmsbUS4k4mv49TsbX0VD41w5jUo0v5UKSybvBBm80HZIbhNEWza2NpCftCVp
        NqQ21hJW+QKHRNOiwOJPUlebnxuCEO07I7RKrQLNEelUmYd3o0DLdOC6F0EhmiE4NDo8WkQJgm2V1
        m7QqotHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPLoq-000071-G0; Fri, 17 Apr 2020 07:53:48 +0000
Date:   Fri, 17 Apr 2020 00:53:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, agruenba@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 4/4] nfs/super: check NFS_CAP_ACLS instead of the NFS
 version
Message-ID: <20200417075348.GD598@infradead.org>
References: <20200407142243.2032-1-mk@cm4all.com>
 <20200407142243.2032-4-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407142243.2032-4-mk@cm4all.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 04:22:43PM +0200, Max Kellermann wrote:
> This sets SB_POSIXACL only if ACL support is really enabled, instead
> of always setting SB_POSIXACL if the NFS protocol version
> theoretically supports ACL.
> 
> The code comment says "We will [apply the umask] ourselves", but that
> happens in posix_acl_create() only if the kernel has POSIX ACL
> support.  Without it, posix_acl_create() is an empty dummy function.
> 
> So let's not pretend we will apply the umask if we can already know
> that we will never.
> 
> This fixes a problem where the umask is always ignored in the NFS
> client when compiled without CONFIG_FS_POSIX_ACL.  This is a 4 year
> old regression caused by commit 013cdf1088d723 which itself was not
> completely wrong, but failed to consider all the side effects by
> misdesigned VFS code.
> 
> Signed-off-by: Max Kellermann <mk@cm4all.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/nfs/super.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index dada09b391c6..dab79193f641 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -977,11 +977,14 @@ static void nfs_fill_super(struct super_block *sb, struct nfs_fs_context *ctx)
>  	if (ctx && ctx->bsize)
>  		sb->s_blocksize = nfs_block_size(ctx->bsize, &sb->s_blocksize_bits);
>  
> -	if (server->nfs_client->rpc_ops->version != 2) {
> +	if (NFS_SB(sb)->caps & NFS_CAP_ACLS) {
>  		/* The VFS shouldn't apply the umask to mode bits. We will do
>  		 * so ourselves when necessary.
>  		 */
>  		sb->s_flags |= SB_POSIXACL;
> +	}

Looks good, but I'd use the opportunity to also fix up the commen to be
a little less cryptic:

	/*
	 * If the server supports ACLs, the VFS shouldn't apply the umask to
	 * the mode bits as we'll do it ourselves when necessary.
	 */
	if (NFS_SB(sb)->caps & NFS_CAP_ACLS)
		sb->s_flags |= SB_POSIXACL;
