Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D11ED827
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 23:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgFCVqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 17:46:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20209 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726229AbgFCVqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 17:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591220798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j8irI2YP3QxKXjo5qFTtbAZdDKv971AUeB+9+HvcfEc=;
        b=HTiqvSSYGJADts/qv5b5rstK9QUVHZ1bWPSz+RXqgAkhHruXWufmnSkICpY/hlP3eDWLLH
        j8sLH/RRC+gJ2hcn2QdXC5z8jwZycaUaBhOwhmT/kS4mh2X6ZOZlI/wylyXqhAktm1tnCz
        UEBeqiiq5F7vNPrwODY2c+P7Sthw8zQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-QvVLwQMmN6OODyKajwOZpA-1; Wed, 03 Jun 2020 17:46:36 -0400
X-MC-Unique: QvVLwQMmN6OODyKajwOZpA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A84A91B18BC3;
        Wed,  3 Jun 2020 21:46:34 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-25.rdu2.redhat.com [10.10.118.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5327B60BE1;
        Wed,  3 Jun 2020 21:46:34 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id D1478220C5A; Wed,  3 Jun 2020 17:46:33 -0400 (EDT)
Date:   Wed, 3 Jun 2020 17:46:33 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     glider@google.com
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        royyang@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
Message-ID: <20200603214633.GF48122@redhat.com>
References: <20200603174714.192027-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603174714.192027-1-glider@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 07:47:14PM +0200, glider@google.com wrote:
> Under certain circumstances (we found this out running Docker on a
> Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> return uninitialized value of |error| from ovl_copy_xattr().

If we are returning uninitialized value of error, doesn't that mean
that somewhere in the function we are returning without setting error.
And that probably means that's a bug and we should fix it?

I am wondering if this is triggered by loop finishing because all
the xattr on the file are ovl_is_private_xattr(). In that case, we
will come out of the loop without setting error. This is in fact
success and we should return 0 instead of some random error?

Thanks
Vivek


> It is then returned by ovl_create() to lookup_open(), which casts it to
> an invalid dentry pointer, that can be further read or written by the
> lookup_open() callers.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Roy Yang <royyang@google.com>
> Cc: <stable@vger.kernel.org> # 4.1
> 
> ---
> 
> It's unclear to me whether error should be initially 0 or some error
> code (both seem to work), but I thought returning an error makes sense,
> as the situation wasn't anticipated by the code authors.
> 
> The bug seem to date back to at least v4.1 where the annotation has been
> introduced (i.e. the compilers started noticing error could be used
> before being initialized). I hovever didn't try to prove that the
> problem is actually reproducible on such ancient kernels. We've seen it
> on a real machine running v4.4 as well.
> ---
>  fs/overlayfs/copy_up.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 9709cf22cab3..428d43e2d016 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -47,7 +47,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
>  {
>  	ssize_t list_size, size, value_size = 0;
>  	char *buf, *name, *value = NULL;
> -	int uninitialized_var(error);
> +	int error = -EINVAL;
>  	size_t slen;
>  
>  	if (!(old->d_inode->i_opflags & IOP_XATTR) ||
> -- 
> 2.27.0.rc2.251.g90737beb825-goog
> 

