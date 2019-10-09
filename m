Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D517D1B3F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 23:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfJIVzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 17:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfJIVzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 17:55:05 -0400
Received: from localhost (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB069206B6;
        Wed,  9 Oct 2019 21:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570658104;
        bh=oAoT7tDis+MgcqEHt2aEIBpYj48lAWF2BJLncuZbCME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t+kYOiHIY1/XXGJ+YqbwsSVQJ4OGnXid5HkIT2iUNKD9ctwrzYs4E2iKQy7R5KWXu
         tcdKHV+br7WPjf+1hcaDrczQ2tJcAprxluUJvU7R0LAoi/wm74Uj2XTrW9zqi9N0A8
         aetHYm68XjNHJ2bBxRxP/IpdP0qPXDh86dnem/aI=
Date:   Wed, 9 Oct 2019 17:55:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Minwoo Im <minwoo.im@samsung.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 4.19] nvme: Assign subsys instance from first ctrl
Message-ID: <20191009215504.GW1396@sasha-vm>
References: <20191009162910.1801-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191009162910.1801-1-kbusch@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 01:29:10AM +0900, Keith Busch wrote:
>commit 733e4b69d508d03c20adfdcf4bd27abc60fae9cc upstream
>
>The namespace disk names must be unique for the lifetime of the
>subsystem. This was accomplished by using their parent subsystems'
>instances which were allocated independently from the controllers
>connected to that subsystem. This allowed name prefixes assigned to
>namespaces to match a controller from an unrelated subsystem, and has
>created confusion among users examining device nodes.
>
>Ensure a namespace's subsystem instance never clashes with a controller
>instance of another subsystem by transferring the instance ownership
>to the parent subsystem from the first controller discovered in that
>subsystem.
>
>Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
>Reviewed-by: Christoph Hellwig <hch@lst.de>
>Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
>Reviewed-by: Hannes Reinecke <hare@suse.com>
>Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>Signed-off-by: Sagi Grimberg <sagi@grimberg.me>

What are your thoughts about taking the following for 4.19 instead?

733e4b69d508d nvme: Assign subsys instance from first ctrl
e654dfd38c1ec nvme: fix memory leak caused by incorrect subsystem free
32fd90c407680 nvme: change locking for the per-subsystem controller list
092ff0520070f nvme: fix kernel paging oops
cb5b7262b011c nvme: provide fallback for discard alloc failure

--
Thanks,
Sasha
