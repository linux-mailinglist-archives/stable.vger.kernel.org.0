Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A02669D8A
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 17:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjAMQWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 11:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjAMQVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 11:21:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC967827E
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 08:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673626480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UnyCGexQh4EwPAqsC7ijXoPzL2plmVvArEUvtL9Gw3U=;
        b=KzuTCZw12iRJQP+pI7OLdTztWS+rAoq/9NLGPIu9MKBNHr4FRZtF1W+dRV8HcPCi1LYZQ7
        K3M8bRFqCuOUSun+ud9F3uoPOopvuNzoksIYzJIDVcNlHSWL8+5NQSwTY9v/cJgECyBhIV
        +GcEsc/6c8l5ZRVA4FkXYBmBEHEHsYA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-HvU4vtMbP4C2N92cq1wegA-1; Fri, 13 Jan 2023 11:14:37 -0500
X-MC-Unique: HvU4vtMbP4C2N92cq1wegA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A52C61C05AF0;
        Fri, 13 Jan 2023 16:14:36 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 654E32026D68;
        Fri, 13 Jan 2023 16:14:36 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org
Subject: Re: [PATCH] aio: fix mremap after fork null-deref
References: <20221104212519.538108-1-sethjenkins@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 13 Jan 2023 11:18:33 -0500
In-Reply-To: <20221104212519.538108-1-sethjenkins@google.com> (Seth Jenkins's
        message of "Fri, 4 Nov 2022 17:25:19 -0400")
Message-ID: <x49a62ml86e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Seth Jenkins <sethjenkins@google.com> writes:

> Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
> a null-deref if mremap is called on an old aio mapping after fork as
> mm->ioctx_table will be set to NULL.
>
> Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
> Cc: stable@vger.kernel.org
> Signed-off-by: Seth Jenkins <sethjenkins@google.com>
> ---
>  fs/aio.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 5b2ff20ad322..74eae7de7323 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -361,16 +361,18 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
>  	spin_lock(&mm->ioctx_lock);
>  	rcu_read_lock();
>  	table = rcu_dereference(mm->ioctx_table);
> -	for (i = 0; i < table->nr; i++) {
> -		struct kioctx *ctx;
> -
> -		ctx = rcu_dereference(table->table[i]);
> -		if (ctx && ctx->aio_ring_file == file) {
> -			if (!atomic_read(&ctx->dead)) {
> -				ctx->user_id = ctx->mmap_base = vma->vm_start;
> -				res = 0;
> +	if (table) {
> +		for (i = 0; i < table->nr; i++) {
> +			struct kioctx *ctx;
> +
> +			ctx = rcu_dereference(table->table[i]);
> +			if (ctx && ctx->aio_ring_file == file) {
> +				if (!atomic_read(&ctx->dead)) {
> +					ctx->user_id = ctx->mmap_base = vma->vm_start;

This is now over 80 columns.  I'd prefer it if you would just invert the
NULL pointer check and add a label:

if (!table)
	goto out_unlock;

Other than that, it looks good to me.

Cheers,
Jeff

