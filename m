Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87939DBC9
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFGL5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 07:57:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56274 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGL5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 07:57:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 79F211FDC5;
        Mon,  7 Jun 2021 11:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623066930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqFN536PDnP3Zynyosw+raEhWyH991Zb94ulbNCCUPI=;
        b=TfZh0rTwQFOmv60JXi81ZTOEXzkiIC1f08hfqAXbhh1wptG/d6HMQAUAD/Ryh4w+KpVOtG
        hyb6wjs/6d5YEPr+tMVAUkxW/quPnjDnt2acUPxKG6rE6C3mKgqqGIbffeukTGRxf6/CDO
        5nfRX0xDEGrLF1VnvcCW5Il7ybSn7sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623066930;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqFN536PDnP3Zynyosw+raEhWyH991Zb94ulbNCCUPI=;
        b=hJe2nXU8SuQLJ2QccHgBR3B8xjhz/y+SDzvWX2OFp2igGZoqWQXShRhJ6YJzTIA7AnuqH4
        d/LwCpFdA+dK72BA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1CD94118DD;
        Mon,  7 Jun 2021 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623066930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqFN536PDnP3Zynyosw+raEhWyH991Zb94ulbNCCUPI=;
        b=TfZh0rTwQFOmv60JXi81ZTOEXzkiIC1f08hfqAXbhh1wptG/d6HMQAUAD/Ryh4w+KpVOtG
        hyb6wjs/6d5YEPr+tMVAUkxW/quPnjDnt2acUPxKG6rE6C3mKgqqGIbffeukTGRxf6/CDO
        5nfRX0xDEGrLF1VnvcCW5Il7ybSn7sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623066930;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqFN536PDnP3Zynyosw+raEhWyH991Zb94ulbNCCUPI=;
        b=hJe2nXU8SuQLJ2QccHgBR3B8xjhz/y+SDzvWX2OFp2igGZoqWQXShRhJ6YJzTIA7AnuqH4
        d/LwCpFdA+dK72BA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id hgKGNSwJvmCYaAAALh3uQQ
        (envelope-from <colyli@suse.de>); Mon, 07 Jun 2021 11:55:24 +0000
Subject: Re: [PATCH v5 2/2] bcache: avoid oversized read request in cache
 missing code path
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Ullrich <ealex1979@gmail.com>,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Rolf Fokkens <rolf@rolffokkens.nl>,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Takashi Iwai <tiwai@suse.com>
References: <20210607103539.12823-1-colyli@suse.de>
 <20210607103539.12823-3-colyli@suse.de> <20210607110657.GB6729@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <6d08d23b-b778-4e5f-a5f3-7106a42e26a1@suse.de>
Date:   Mon, 7 Jun 2021 19:55:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607110657.GB6729@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/21 7:06 PM, Christoph Hellwig wrote:
> On Mon, Jun 07, 2021 at 06:35:39PM +0800, Coly Li wrote:
>> +	/* Limitation for valid replace key size and cache_bio bvecs number */
>> +	size_limit = min_t(unsigned int, bio_max_segs(UINT_MAX) * PAGE_SECTORS,
>> +			   (1 << KEY_SIZE_BITS) - 1);
> bio_max_segs kaps the argument to BIO_MAX_VECS, so you might as well

It was suggested to not directly access BIO_MAX_VECS by you, maybe I
misunderstood you.


> directly write BIO_MAX_VECS.  Can you explain the PAGE_SECTORS here a bit
> more? Does this code path use discontiguous per-sector allocations?
> Preferably in a comment.


It is just because bch_bio_map() assume the maximum bio size is 1MB. It
was not true since the multiple pages bvecs
was merged in mainline kernel.
 
The PAGE_SECTORS part is legacy for 1MB maximum size bio (256*4KB), it
should be fixed/improved later to
use multiple pages for bio size > 1MB and replace bch_bio_map().


>> +	s->insert_bio_sectors = min3(size_limit, sectors, bio_sectors(bio));
> Also I don't really understand the units involved here.
> s->insert_bio_sectors, sectors, and bio_sectors is in unit of 512 byte
> sectors.  

Yes, they are in sectors, this is the maximum permitted bio size for 1MB
bio size. Now we can have bio > 1MB, and you modify
bio_alloc_bioset() parameter 'nr_iovecs from unsigned int to unsigned
short, so bio-size/page-size can be > 256 and overflow,
e.g. 258 overflows to 2, then the BUG in biovec_slab() is triggered.

I feel this is a long time existing issue in bcache code, and should be
fixed from bcache side, and your change helps to trigger
the problem explicitly.

>> -	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
>> +	miss = bio_next_split(bio, s->insert_bio_sectors, GFP_NOIO, &s->d->bio_split);
> Overly long line.

Not any more. Now the line limit is 100 characters. Though I still
prefer 80 characters, place 86 characters in single line
makes the change more obvious.

Thanks.

Coly Li
