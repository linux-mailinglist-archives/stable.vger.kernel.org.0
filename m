Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D58746C35B
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 20:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbhLGTNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 14:13:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48786 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240862AbhLGTNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 14:13:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5ED2B81E00;
        Tue,  7 Dec 2021 19:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B971EC341C1;
        Tue,  7 Dec 2021 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638904218;
        bh=kG+68qcYpyw0i1u2WkR+wTvgvAlREuCP1u2cIoKf1eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9/DVyls8w4C36d/6ZrKl6jXi4wavdH1hb77QCLoLmlRBsJI2tXHCKaRtUcZJjJYW
         OijctMwu4s9PN9veie7/szEZnE1D0Bkn7QOP7Ouqcd1pLwZLkuQyDfhM9uD7ArpQ5S
         LjpMLS69TiyBoEgTBkc3rafGkzxQIABQ9GgzJ9yStI6wS+Suh+K3WIzin0/fZ5InD2
         QfWNrh5hUMyDAfGJFdUHx4a39IoUG8bM1GioL1VJe6Z2WjbrKNWmxWE1bIrdsLhJso
         b5JmLjL4znPw0DJJZrJ238BngQuAmAve8gxr8roErzWeSYNHWrDFnA+m1If1D+nnJT
         rKaMpVZyeVwew==
Date:   Tue, 7 Dec 2021 11:10:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ramji Jiyani <ramjiyani@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <Ya+xl9peAAMiMCqa@sol.localdomain>
References: <20211207095726.169766-1-ebiggers@kernel.org>
 <20211207111758.GB18554@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207111758.GB18554@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 12:17:58PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 07, 2021 at 01:57:21AM -0800, Eric Biggers wrote:
> > This series fixes two bugs in aio poll, and one issue with POLLFREE more
> > broadly.  This is intended to replace
> > "[PATCH v5] aio: Add support for the POLLFREE"
> > (https://lore.kernel.org/r/20211027011834.2497484-1-ramjiyani@google.com)
> > which has some bugs.
> > 
> > Careful review is appreciated; the aio poll code is very hard to work
> > with, and I don't know of an easy way to test it.  Suggestions of any
> > aio poll tests to run would be greatly appreciated.
> 
> libaio has a test for aio poll (test 22).

Great, it doesn't look very comprehensive but at least it is something.  I ran
the whole libaio test suite (including that test), and all the tests pass both
before and after this patch series.

- Eric
