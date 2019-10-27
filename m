Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45014E61B3
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 09:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfJ0IwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 04:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfJ0IwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 04:52:08 -0400
Received: from localhost (smb-adpcdg1-03.hotspot.hub-one.net [213.174.99.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA45620663;
        Sun, 27 Oct 2019 08:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572166327;
        bh=QEDuMB5S9nIW/bPQCF+frKlf4tIHGH8IHlfYKs2AGEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aecqja9E9xOH1oXWdzqlpJvhroXk8O1k9WzVCoD8rbnulA6zNE0JnStxnCHGSFsoR
         g8sLNVGBqDXLACXnyRMjd2mn6QxEmAvIN75dj3BPUIj4EpU3Y64U75Z+q9Z1u0S8iG
         L4n2iXcmmtq5o9IeTBQxcgx29p8qi9cnqZcZTnkY=
Date:   Sun, 27 Oct 2019 04:52:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: io_uring stable 5.3 backports
Message-ID: <20191027085204.GA1560@sasha-vm>
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>Hi,
>
>For some reason I forgot to mark these stable, but they should go
>into stable. In order of applying them, they are:
>
>bc808bced39f4e4b626c5ea8c63d5e41fce7205a

This commit says it fixes c576666863b78 ("io_uring: optimize
submit_and_wait API") which is not in the stable tree.

>ef03681ae8df770745978148a7fb84796ae99cba

This commit doesn't say so, but really it fixes 5262f567987d3
("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.

>a1f58ba46f794b1168d1107befcf3d4b9f9fd453

Same as the commit above.

>84d55dc5b9e57b513a702fbc358e1b5489651590
>fb5ccc98782f654778cb8d96ba8a998304f9a51f

This needed some massaging to work around not having 4fe2c963154c3
("io_uring: add support for link with drain"). I've fixed it up and
queued it.

>935d1e45908afb8853c497f2c2bbbb685dec51dc

I think that Greg's scripts didn't like how much this code moved around
and refused to deal with it. I've verified patching did the right thing
and queued it up.

>498ccd9eda49117c34e0041563d0da6ac40e52b8

This one needed massaging to work around missing 75b28affdd6ae
("io_uring: allocate the two rings together") in the stable tree. I've
fixed it up and queued it up.


Jens, could you please take a look at my backport of fb5ccc98782f65:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.3/io_uring-fix-broken-links-with-offloading.patch

And 498ccd9eda491:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.3/io_uring-used-cached-copies-of-sq-dropped-and-cq-ove.patch

And confirm I did the right thing?

-- 
Thanks,
Sasha
