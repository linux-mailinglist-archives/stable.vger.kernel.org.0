Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033A250E4F2
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiDYQCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 12:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiDYQCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 12:02:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB66F43EF5
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 08:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 941F9B818A7
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 15:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33C6C385A7;
        Mon, 25 Apr 2022 15:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650902381;
        bh=jzgsfvJnXMtNOlOisOPN1hIrbEwIswo5i6mAte5eDuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=woTUG4rp+uSpNVQ+rVUxqk3whYALcAkqx1mJ6nNnlR0ogwTnAvaj+S7/jUKSqxnuW
         CuV6eYNlqevdJeR43IPWSsv5qAtOyV4HNI3XhAID4QkzN+jdDvB8XiF0IZYIi+uYWD
         HdNGapGIDIFKtkHJRxbYU3gAl1l1+U6e4Z/7XKhI=
Date:   Mon, 25 Apr 2022 17:59:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YmbFatGdeHcjXml9@kroah.com>
References: <20220425155154.2742426-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425155154.2742426-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 04:51:54PM +0100, Lee Jones wrote:
> Supply additional check in order to prevent unexpected results.
> 
> Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> This is a forward-port from linux-4.4.y and linux-4.9.y.
> 
> It has never been upstream.
> 
> Please apply to v4.14 through v5.10.
> 
>  drivers/staging/android/ion/ion.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index e1fe03ceb7f13..e6d4a3ee6cda5 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -114,6 +114,9 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
>  	void *vaddr;
>  
>  	if (buffer->kmap_cnt) {
> +		if (buffer->kmap_cnt == INT_MAX)
> +			return ERR_PTR(-EOVERFLOW);
> +
>  		buffer->kmap_cnt++;
>  		return buffer->vaddr;
>  	}
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 

Now queued up, thanks.

gre gk-h
