Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32125447BA8
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbhKHITj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 03:19:39 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56342 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbhKHITj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 03:19:39 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5510E1FD4B;
        Mon,  8 Nov 2021 08:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636359414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+Yq6hG3k36s1uOE6Y/7uPoV6fFQWVw9AJQWSG06kqk=;
        b=r8O4XAp1QrBSB0InooRmiwPRL5Y7doiXPa5sm9kBcPCOGZnNl8H88IFxuTjB2yKJrxT6dU
        WivnXWDbs2+rcj9WSupsCLlt2g5+1aPqqV0yx7S/ovKjDR5f3tAxgbyJ4rXI8JWlB+Hdye
        2Rxhujmr9jPG7+PmQ04A8iBtlOhNVhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636359414;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+Yq6hG3k36s1uOE6Y/7uPoV6fFQWVw9AJQWSG06kqk=;
        b=lAD9AVD1VLR+1y0udUDzlfVqycMBOI7xecHyyrCswEt2CzZlTU32rsf7Zv96n9Cce/3dXA
        q+RExUJ3IdyJlaCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59CD41345F;
        Mon,  8 Nov 2021 08:16:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CUqiDPXciGHdUgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 08 Nov 2021 08:16:53 +0000
Message-ID: <0bfbf514-4036-23ff-436a-01e0b7eba67e@suse.de>
Date:   Mon, 8 Nov 2021 16:16:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Content-Language: en-US
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20211103151041.70516-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211103151041.70516-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/3/21 11:10 PM, Coly Li wrote:
> This reverts commit 2fd3e5efe791946be0957c8e1eed9560b541fe46.
>
> The above commit replaces page_address(bv->bv_page) by bvec_virt(bv) to
> avoid directly access to bv->bv_page, but in situation bv->bv_offset is
> not zero and page_address(bv->bv_page) is not equal to bvec_virt(bv). In
> such case a memory corruption may happen because memory in next page is
> tainted by following line in do_btree_node_write(),
> 	memcpy(bvec_virt(bv), addr, PAGE_SIZE);
>
> This patch reverts the mentioned commit to avoid the memory corruption.
>
> Fixes: 2fd3e5efe791 ("bcache: use bvec_virt")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org # 5.15
> ---
>   drivers/md/bcache/btree.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 93b67b8d31c3..88c573eeb598 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -378,7 +378,7 @@ static void do_btree_node_write(struct btree *b)
>   		struct bvec_iter_all iter_all;
>   
>   		bio_for_each_segment_all(bv, b->bio, iter_all) {
> -			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
> +			memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
>   			addr += PAGE_SIZE;
>   		}
>   

Hi Jens,

Since now we don't have a better alternative patch yet, and this issue 
should be fixed ASAP. Could you please take it firstly. And I will work 
with Christoph for a better change (maybe large and not trivial) later 
for next merge window?

Thanks.

Coly Li
