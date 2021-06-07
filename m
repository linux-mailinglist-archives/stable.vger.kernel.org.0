Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38BD39DBF0
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 14:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFGMKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 08:10:17 -0400
Received: from verein.lst.de ([213.95.11.211]:45916 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhFGMKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 08:10:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4CCDE67373; Mon,  7 Jun 2021 14:08:22 +0200 (CEST)
Date:   Mon, 7 Jun 2021 14:08:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v5 2/2] bcache: avoid oversized read request in cache
 missing code path
Message-ID: <20210607120822.GA11665@lst.de>
References: <20210607103539.12823-1-colyli@suse.de> <20210607103539.12823-3-colyli@suse.de> <20210607110657.GB6729@lst.de> <6d08d23b-b778-4e5f-a5f3-7106a42e26a1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d08d23b-b778-4e5f-a5f3-7106a42e26a1@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 07:55:22PM +0800, Coly Li wrote:
> On 6/7/21 7:06 PM, Christoph Hellwig wrote:
> > On Mon, Jun 07, 2021 at 06:35:39PM +0800, Coly Li wrote:
> >> +	/* Limitation for valid replace key size and cache_bio bvecs number */
> >> +	size_limit = min_t(unsigned int, bio_max_segs(UINT_MAX) * PAGE_SECTORS,
> >> +			   (1 << KEY_SIZE_BITS) - 1);
> > bio_max_segs kaps the argument to BIO_MAX_VECS, so you might as well
> 
> It was suggested to not directly access BIO_MAX_VECS by you, maybe I
> misunderstood you.

Yes, drivers really should not care about it.  But hiding that behind
a tiny wrapper doesn't help either.

> > directly write BIO_MAX_VECS.  Can you explain the PAGE_SECTORS here a bit
> > more? Does this code path use discontiguous per-sector allocations?
> > Preferably in a comment.
> 
> 
> It is just because bch_bio_map() assume the maximum bio size is 1MB. It
> was not true since the multiple pages bvecs
> was merged in mainline kernel.
>  
> The PAGE_SECTORS part is legacy for 1MB maximum size bio (256*4KB), it
> should be fixed/improved later to
> use multiple pages for bio size > 1MB and replace bch_bio_map().

bch_bio_map and bch_bio_alloc_pages that poke directly into the bio are
the root cause of a lot of these problems.

I had a series fixing some of that but Kent did not like it.  Drivers must
not diretly access bi_vcnt or directly build bios.

> Not any more. Now the line limit is 100 characters. Though I still
> prefer 80 characters, place 86 characters in single line
> makes the change more obvious.

It makes it really hard to read in a normal terminal.
