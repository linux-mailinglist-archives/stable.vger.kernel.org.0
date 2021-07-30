Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7573DC0F9
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhG3WUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234727AbhG3WTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 18:19:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63BE76103B;
        Fri, 30 Jul 2021 22:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627683574;
        bh=4VKfcpb8qAKuyVWq8IH8w3NNv3+Ftr3X6OmmhKffEVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0xvD9yioLv4AFX/uD/lZJ760hM93+P+CYC30btjoU30gqtw+qyTljeGiL5mP7HHv
         ZDhIRzciAJRIrmlHbjhk75Eemzb1Rr+OV4LaHsWzegR4DsOKTvBhL84LHDfh9QReRq
         h5LXDFYsBIkORSwT1K4y2aAB6EItuzcDeXj1F2TRMQZSV9JR4hYFCQJyHctba5Pae8
         m8SnKau/s2urdMWcUDEGKngkUbIXQ4vV0KTVN2R/bVGcpdt0so+BBJwKT6vT/qRY06
         JsI1Q8Mod8JJJVHR8NoLcGQ/8lFedbjb5vltZq4MGfAz3PMoOIUwRU8sO4wMip6qFp
         BrOazGH7Ed+8Q==
Date:   Fri, 30 Jul 2021 15:19:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net, Chao Yu <chao@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQR69fzcv2vkgtfT@gmail.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQR5P6aMxhOL+6os@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQR5P6aMxhOL+6os@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 03:12:15PM -0700, Jaegeuk Kim wrote:
> On 07/30, Eric Biggers wrote:
> > On Tue, Jul 27, 2021 at 06:51:54PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > > they require preallocating blocks, but f2fs doesn't support unwritten
> > > blocks and therefore has to preallocate the blocks as regular blocks.
> > > f2fs has no way to reliably roll back such preallocations, so as a
> 
> Hmm, I'm still wondering why this becomes a problem. And, do we really need
> to roll back the preallocated blocks?
> 
> > > result, f2fs will leak uninitialized blocks to users if a DIO write
> > > doesn't fully complete.  This can be easily reproduced by issuing a DIO
> > > write that will fail due to misalignment, e.g.:
> 
> If there's any error, truncating blocks having NEW_ADDR could address this?
> 

My understanding is that the "NEW_ADDR" block address in f2fs means that space
was reserved for the block, but not allocated in any particular place yet.
Buffered writes reserve blocks in this way, but DIO writes cannot because DIO by
definition has to directly write to a specific on-disk location.  Therefore DIO
writes require that the blocks be preallocated for real.

- Eric
