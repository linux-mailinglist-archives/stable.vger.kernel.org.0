Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E2444595
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhKCQO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:14:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60216 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbhKCQO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 12:14:27 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7D5921FC9E;
        Wed,  3 Nov 2021 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635955909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/5aL2kwhmUQQo9sqoIsf812z+KBd1siwpzACpEXlmU=;
        b=lR2Wbq59KuHBplxEIc8Zh0LYjBdH543DEoSnXVNMzHfEdlBVQ/CLG3P0eAMLkpQiKX8nst
        1i+QrjIWicqI1fqw4MTV9Sxu4TCzfqoWvc5+kq5E2jza2VCX71ir3X0gfK0G3AwDe2NqvC
        /08xmox+2J2IgW1nWz8vODHQ54Tvq7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635955909;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/5aL2kwhmUQQo9sqoIsf812z+KBd1siwpzACpEXlmU=;
        b=61fihADloQ3juKYwpgNW/L+RXojXUTaTd0OMed1k/yxylZbsQ+k/eErJ6wAJMuKrJRqfYs
        HrXiOfAtrEhAIbBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0841413C91;
        Wed,  3 Nov 2021 16:11:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BtsSL8O0gmHPTwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 03 Nov 2021 16:11:47 +0000
Message-ID: <1d1180e0-32bc-e571-3252-ce496508d2b5@suse.de>
Date:   Thu, 4 Nov 2021 00:11:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, stable@vger.kernel.org
References: <20211103151041.70516-1-colyli@suse.de>
 <20211103154644.GA30686@lst.de>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211103154644.GA30686@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/3/21 11:46 PM, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 11:10:41PM +0800, Coly Li wrote:
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 93b67b8d31c3..88c573eeb598 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -378,7 +378,7 @@ static void do_btree_node_write(struct btree *b)
>>   		struct bvec_iter_all iter_all;
>>   
>>   		bio_for_each_segment_all(bv, b->bio, iter_all) {
>> -			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
>> +			memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
> How could there be an offset?  bch_bio_alloc_pages allocates a
> fresh page for each vec, and bio_for_each_segment_all iterates page
> by page.  IFF there is an offset there is proble in the surrounding
> code as bch_bio_alloc_pages assumes that it is called on a freshly
> allocate and initialized bio.

Yes, the offset is modified in bch_bio_alloc_pages(). Normally the 
bcache defined block size is 4KB so the issue was not triggered 
frequently. I found it during testing my nvdimm enabling code for 
bcache, where I happen to make the bcache defined block size to non-4KB. 
The offset is from the previous written bkey set, which the minimized 
unit size is 1 bcache-defined-block-size.

Coly Li
