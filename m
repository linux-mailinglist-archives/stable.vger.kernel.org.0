Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7092A3EE651
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 07:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhHQFnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 01:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhHQFnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 01:43:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA151C061764;
        Mon, 16 Aug 2021 22:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VeKnM02wWuhrHmIkGzHEjGcNpMFRvvPghHJFGQ1kIg0=; b=wIXvWYPSodcx5cY+IU7NfDLX0S
        bkLtJBaE1CLafopA81uy6O0zlaIKaqhDtuJObSaeQpeWEevZdas4nzAxNF6ZN/fbJ6FpqWACAfsem
        Adzo0NqKx5Mq94NFjy/s4zYD8Nc5N2PkFB4FkxxLp3XHrVSSgt2/FNAtFVstq6tv3zmaI0J6Xbc8+
        Z242N+Ct8KmBPBG+h+heoSCM5FMhaosHwm1gSFVNegbrtusRkIcGffnGWL41lbtGjYsPoTxzL5ur6
        0su9nPU0ZOvguaWVj63XaEAdOKGk8nk43WYgFu2Y5R+yAEudCdm4EJHuV8ItaUGzW1RBuDgetNAUF
        fbJNmtdQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFrre-002BMB-98; Tue, 17 Aug 2021 05:42:23 +0000
Date:   Tue, 17 Aug 2021 06:42:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YRtMOqzZU4c1Vjje@infradead.org>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com>
 <YRsY6dyHyaChkQ6n@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRsY6dyHyaChkQ6n@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:03:21PM -0700, Eric Biggers wrote:
> Freeing preallocated blocks on error would be better than nothing, although note
> that the preallocated blocks may have filled an arbitrary sequence of holes --
> so simply truncating past EOF would *not* be sufficient.
> 
> But really filesystems need to be designed to never expose uninitialized data,
> even if I/O errors or a sudden power failure occurs.  It is unfortunate that
> f2fs apparently wasn't designed with that goal in mind.
> 
> In any case, I don't think we can proceed with any other f2fs direct I/O
> improvements until this data leakage bug can be solved one way or another.  If
> my patch to remove support for allocating writes isn't acceptable and the
> desired solution is going to require some more invasive f2fs surgery, are you or
> Chao going to work on it?  I'm not sure there's much I can do here.

Btw, this is generally a problem for buffered I/O as well, although the
window for exposing uninitialized blocks on a crash tends to be smaller.
