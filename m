Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE5239DC71
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 14:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFGMeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 08:34:04 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41382 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGMeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 08:34:04 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AC30121A9C;
        Mon,  7 Jun 2021 12:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623069131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xujXttsQ0h26rg4aNmqeVpzzpa7x113gO557TuV5pLU=;
        b=AOhl595vrgfKnAuXC5yvPCYMOxddB+q6+wK49+ct7AYPQUkx/0zBcNCAQJzxvq8qWokKOP
        mVHJHpvtfIAgpshbP3/W4g6nnmmhtphWInomCkYyXTNM0QR0Eg9ACv5P2x1rPEvUxAByey
        Fn24mCj4lpOtLMgS1WSSNqG1XOjRwG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623069131;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xujXttsQ0h26rg4aNmqeVpzzpa7x113gO557TuV5pLU=;
        b=Q6QdDGjPM6FGK235oEnTf/9V5KBfqby9x10xj/mrFAevp8uDDnWeduhr7ssq5Ua4gl6QGO
        +iV5XDN1tawZUEBw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 60569118DD;
        Mon,  7 Jun 2021 12:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623069131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xujXttsQ0h26rg4aNmqeVpzzpa7x113gO557TuV5pLU=;
        b=AOhl595vrgfKnAuXC5yvPCYMOxddB+q6+wK49+ct7AYPQUkx/0zBcNCAQJzxvq8qWokKOP
        mVHJHpvtfIAgpshbP3/W4g6nnmmhtphWInomCkYyXTNM0QR0Eg9ACv5P2x1rPEvUxAByey
        Fn24mCj4lpOtLMgS1WSSNqG1XOjRwG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623069131;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xujXttsQ0h26rg4aNmqeVpzzpa7x113gO557TuV5pLU=;
        b=Q6QdDGjPM6FGK235oEnTf/9V5KBfqby9x10xj/mrFAevp8uDDnWeduhr7ssq5Ua4gl6QGO
        +iV5XDN1tawZUEBw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id ZFn9CMURvmDlfQAALh3uQQ
        (envelope-from <colyli@suse.de>); Mon, 07 Jun 2021 12:32:05 +0000
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
 <6d08d23b-b778-4e5f-a5f3-7106a42e26a1@suse.de>
 <20210607120822.GA11665@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <d7848f93-4acc-031f-b8ae-6fc2a4742fe7@suse.de>
Date:   Mon, 7 Jun 2021 20:31:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607120822.GA11665@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/21 8:08 PM, Christoph Hellwig wrote:
> On Mon, Jun 07, 2021 at 07:55:22PM +0800, Coly Li wrote:
>> On 6/7/21 7:06 PM, Christoph Hellwig wrote:
>>> On Mon, Jun 07, 2021 at 06:35:39PM +0800, Coly Li wrote:
>>>> +	/* Limitation for valid replace key size and cache_bio bvecs number */
>>>> +	size_limit = min_t(unsigned int, bio_max_segs(UINT_MAX) * PAGE_SECTORS,
>>>> +			   (1 << KEY_SIZE_BITS) - 1);
>>> bio_max_segs kaps the argument to BIO_MAX_VECS, so you might as well
>> It was suggested to not directly access BIO_MAX_VECS by you, maybe I
>> misunderstood you.
> Yes, drivers really should not care about it.  But hiding that behind
> a tiny wrapper doesn't help either.

OK, I change back to BIO_MAX_VECS.
>>> directly write BIO_MAX_VECS.  Can you explain the PAGE_SECTORS here a bit
>>> more? Does this code path use discontiguous per-sector allocations?
>>> Preferably in a comment.
>>
>> It is just because bch_bio_map() assume the maximum bio size is 1MB. It
>> was not true since the multiple pages bvecs
>> was merged in mainline kernel.
>>  
>> The PAGE_SECTORS part is legacy for 1MB maximum size bio (256*4KB), it
>> should be fixed/improved later to
>> use multiple pages for bio size > 1MB and replace bch_bio_map().
> bch_bio_map and bch_bio_alloc_pages that poke directly into the bio are
> the root cause of a lot of these problems.
>
> I had a series fixing some of that but Kent did not like it.  Drivers must
> not diretly access bi_vcnt or directly build bios.

Last time when you posted the series, Ming Lei's multipages bvecs were
not merged yet.

But the bcache code has kind of implicit restriction, e.g.
cached_dev_cache_miss(), the refill
cache missing 'cache_bio' must be a single bio and not chained,
otherwise the following
cached_dev_read_done() will have problem. Therefore I give up to fix
such thing in this
series, maybe there is no unique way to fix, and I also need to improve
the bio related stuffs
case by case.


>> Not any more. Now the line limit is 100 characters. Though I still
>> prefer 80 characters, place 86 characters in single line
>> makes the change more obvious.
> It makes it really hard to read in a normal terminal.

I don't know you still use 80 characters terminal for coding. Sure you
have my respect and I will serve your
request in next post.

Thanks.

Coly Li
