Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC56663CF
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 20:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjAKThp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 14:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjAKTho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 14:37:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58117D2F2
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 11:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673465822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mbvcywh2c3HfOh904vLvZFGHnaoqFL7ia6UfCCLzqBY=;
        b=LOMe9cYs7cp9RL6SqZ7WY8RMmXwGeqhAu0kfY4gP6hTKdCB8tdpaa8vIJH99CJGLSkNy80
        R8Ad9ZPapnSVIMQTMcEaELT+SM84VFfROGGhsM9XbkBmbeTDL2/6+zFPEtWeLTcq9+DtuW
        Oxp+MjK/88lXxZqTovYS99FTNSTNAiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595--m7sSMw6Ny66ClXGMpAN-g-1; Wed, 11 Jan 2023 14:36:55 -0500
X-MC-Unique: -m7sSMw6Ny66ClXGMpAN-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4118C101A52E;
        Wed, 11 Jan 2023 19:36:55 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE47F1121314;
        Wed, 11 Jan 2023 19:36:54 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: fix mremap after fork null-deref
References: <20221104212519.538108-1-sethjenkins@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 11 Jan 2023 14:40:51 -0500
In-Reply-To: <20221104212519.538108-1-sethjenkins@google.com> (Seth Jenkins's
        message of "Fri, 4 Nov 2022 17:25:19 -0400")
Message-ID: <x49tu0wlv0c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Seth,

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
> +					res = 0;
> +				}
> +				break;
>  			}
> -			break;
>  		}
>  	}

I wonder if it would be better to not copy the ring mapping on fork.
Something like the below?  I think that would be more in line with
expectations (the ring isn't available in the child process).

-Jeff

diff --git a/fs/aio.c b/fs/aio.c
index 562916d85cba..dbf3b0749cb4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -390,7 +390,7 @@ static const struct vm_operations_struct aio_ring_vm_ops = {
 
 static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND|VM_DONTCOPY;
 	vma->vm_ops = &aio_ring_vm_ops;
 	return 0;
 }

