Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03F139DAA1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 13:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhFGLIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 07:08:53 -0400
Received: from verein.lst.de ([213.95.11.211]:45696 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhFGLIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 07:08:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 67A4867373; Mon,  7 Jun 2021 13:06:57 +0200 (CEST)
Date:   Mon, 7 Jun 2021 13:06:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
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
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Takashi Iwai <tiwai@suse.com>
Subject: Re: [PATCH v5 2/2] bcache: avoid oversized read request in cache
 missing code path
Message-ID: <20210607110657.GB6729@lst.de>
References: <20210607103539.12823-1-colyli@suse.de> <20210607103539.12823-3-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607103539.12823-3-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 06:35:39PM +0800, Coly Li wrote:
> +	/* Limitation for valid replace key size and cache_bio bvecs number */
> +	size_limit = min_t(unsigned int, bio_max_segs(UINT_MAX) * PAGE_SECTORS,
> +			   (1 << KEY_SIZE_BITS) - 1);

bio_max_segs kaps the argument to BIO_MAX_VECS, so you might as well
directly write BIO_MAX_VECS.  Can you explain the PAGE_SECTORS here a bit
more? Does this code path use discontiguous per-sector allocations?
Preferably in a comment.

> +	s->insert_bio_sectors = min3(size_limit, sectors, bio_sectors(bio));

Also I don't really understand the units involved here.
s->insert_bio_sectors, sectors, and bio_sectors is in unit of 512 byte
sectors.  

> -	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
> +	miss = bio_next_split(bio, s->insert_bio_sectors, GFP_NOIO, &s->d->bio_split);

Overly long line.
