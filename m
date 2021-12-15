Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817DC475672
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 11:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbhLOKeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 05:34:05 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39146 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241691AbhLOKeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 05:34:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 02D3F1F386;
        Wed, 15 Dec 2021 10:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639564444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4B/t1E772kncxf7q+3szKnolpRRxz03FLz9K8j69YlU=;
        b=mtiETWpGphTKrWOG62e1vOFPHatQJf/iEqNVBfCpjkix25dH4uCRc6NEQ5QGT2rWvyGYmZ
        oVL43PUrJXuHttPs9d/995nedzm90YIhMU4XnPTmiq1yWHCpMeIn4OYlmvIV89ctqH6zCa
        5G8pY/Z7Kc8dKzyHn9sxp+g31Uz/EBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639564444;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4B/t1E772kncxf7q+3szKnolpRRxz03FLz9K8j69YlU=;
        b=IjUeu0n+nj1T1BrCZFQYHRTwBcXulcOdaAH3RBD+zzGWgpJHj/YQZ4rcwUaLa/UBwYmy8M
        NN+g+5BhhRdhgPDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C095013B1C;
        Wed, 15 Dec 2021 10:34:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RYgzLpvEuWHNcwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 15 Dec 2021 10:34:03 +0000
Message-ID: <f7c1f169-f9b3-6930-f933-d69ab0287069@suse.cz>
Date:   Wed, 15 Dec 2021 11:34:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com> <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid> <20211215070335.GA1165926@odroid>
 <20211215072710.GA3010@lst.de>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
In-Reply-To: <20211215072710.GA3010@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 08:27, Christoph Hellwig wrote:
> On Wed, Dec 15, 2021 at 07:03:35AM +0000, Hyeonggon Yoo wrote:
>> I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
>> for kdump kernel is nice way to solve this problem.
> 
> What is the problem with zones in kdump kernels?

My understanding is that kdump kernel can only use physical memory that it
got reserved by the main kernel, and the main kernel will reserve some block
of memory that doesn't include any pages from ZONE_DMA (first 16MB of
physical memory or whatnot). By looking at the "crashkernel" parameter
documentation in kernel-parameters.txt it seems we only care about
below-4GB/above-4GB split.
So it can easily happen that ZONE_DMA in the kdump kernel will be completely
empty because the main kernel was using all of it.

>> Devices that requires ZONE_DMA memory is rare but we still support them.
> 
> Indeed.
> 
>> >     1) Do not call warn_alloc in page allocator if will always fail
>> >     to allocate ZONE_DMA pages.
>> > 
>> > 
>> >     2) let's check all callers of kmalloc with GFP_DMA
>> >     if they really need GFP_DMA flag and replace those by DMA API or
>> >     just remove GFP_DMA from kmalloc()
>> > 
>> >     3) Drop support for allocating DMA memory from slab allocator
>> >     (as Christoph Hellwig said) and convert them to use DMA32
>> 
>> 	(as Christoph Hellwig said) and convert them to use *DMA API*
>> 
>> >     and see what happens
> 
> This is the right thing to do, but it will take a while.  In fact
> I dont think we really need the warning in step 1, a simple grep
> already allows to go over them.  I just looked at the uses of GFP_DMA
> in drivers/scsi for example, and all but one look bogus.
> 
>> > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
>> > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
>> > > > the right way to call people when the first name is the same. Correct me if
>> > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
>> > > > Means device enforces getting memory inside addressing limit for those
>> > > > DMA transferring buffer which is usually large, Megabytes level with
>> > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
>> > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
>> > > > a counter example if anyone happens to know, it could be easy.
> 
> The way this works is that the dma_map* calls will bounce buffer memory

But if ZONE_DMA is not populated, where will it get the bounce buffer from?
I guess nowhere and the problem still exists?

> that does to fall into the addressing limitations.  This is a performance
> overhead, but allows drivers to address all memory in a system.  If the
> driver controls memory allocation it should use one of the dma_alloc_*
> APIs that allocate addressable memory from the start.  The allocator
> will dip into ZONE_DMA and ZONE_DMA32 when needed.

