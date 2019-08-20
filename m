Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA495CE3
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfHTLG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 07:06:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:43836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728283AbfHTLG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 07:06:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD029AE9A;
        Tue, 20 Aug 2019 11:06:25 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix allocation of bitmap pages.
To:     Christoph Hellwig <hch@infradead.org>, dsterba@suse.cz,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20190817074439.84C6C1056A3@localhost.localdomain>
 <20190819174600.GN24086@twin.jikos.cz> <20190820023031.GC9594@infradead.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <6f99b73c-db8f-8135-b827-0a135734d7da@suse.cz>
Date:   Tue, 20 Aug 2019 13:06:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820023031.GC9594@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/19 4:30 AM, Christoph Hellwig wrote:
> On Mon, Aug 19, 2019 at 07:46:00PM +0200, David Sterba wrote:
>> Another thing that is lost is the slub debugging support for all
>> architectures, because get_zeroed_pages lacking the red zones and sanity
>> checks.
>> 
>> I find working with raw pages in this code a bit inconsistent with the
>> rest of btrfs code, but that's rather minor compared to the above.
>> 
>> Summing it up, I think that the proper fix should go to copy_page
>> implementation on architectures that require it or make it clear what
>> are the copy_page constraints.
> 
> The whole point of copy_page is to copy exactly one page and it makes
> sense to assume that is aligned.  A sane memcpy would use the same
> underlying primitives as well after checking they fit.  So I think the
> prime issue here is btrfs' use of copy_page instead of memcpy.  The
> secondary issue is slub fucking up alignments for no good reason.  We
> just got bitten by that crap again in XFS as well :(

Meh, I should finally get back to https://lwn.net/Articles/787740/ right


