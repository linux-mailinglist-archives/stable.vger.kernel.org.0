Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF37422E05D
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 17:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgGZPHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 11:07:06 -0400
Received: from verein.lst.de ([213.95.11.211]:40620 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgGZPHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jul 2020 11:07:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 050B968B05; Sun, 26 Jul 2020 17:07:03 +0200 (CEST)
Date:   Sun, 26 Jul 2020 17:07:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 25/25] bcache: fix bio_{start,end}_io_acct with proper
 device
Message-ID: <20200726150702.GA23338@lst.de>
References: <20200725120039.91071-1-colyli@suse.de> <20200725120039.91071-26-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725120039.91071-26-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 25, 2020 at 08:00:39PM +0800, Coly Li wrote:
> Commit 85750aeb748f ("bcache: use bio_{start,end}_io_acct") moves the
> io account code to the location after bio_set_dev(bio, dc->bdev) in
> cached_dev_make_request(). Then the account is performed incorrectly on
> backing device, indeed the I/O should be counted to bcache device like
> /dev/bcache0.
> 
> With the mistaken I/O account, iostat does not display I/O counts for
> bcache device and all the numbers go to backing device. In writeback
> mode, the hard drive may have 340K+ IOPS which is impossible and wrong
> for spinning disk.
> 
> This patch introduces bch_bio_start_io_acct() and bch_bio_end_io_acct(),
> which switches bio->bi_disk to bcache device before calling
> bio_start_io_acct() or bio_end_io_acct(). Now the I/Os are counted to
> bcache device, and bcache device, cache device and backing device have
> their correct I/O count information back.

Please switch to use disk_{start,end}_io_acct instead of hacking around
with bi_disk assignments.
