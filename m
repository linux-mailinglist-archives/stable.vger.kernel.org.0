Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1997037964
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 18:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbfFFQS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 12:18:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:46396 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729585AbfFFQS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 12:18:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 48FCEAF84;
        Thu,  6 Jun 2019 16:18:28 +0000 (UTC)
Date:   Thu, 6 Jun 2019 18:18:27 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     aarcange@redhat.com, jannh@google.com, oleg@redhat.com,
        peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com,
        stable@vger.kernel.org, srivatsab@vmware.com, amakhalov@vmware.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Message-ID: <20190606161827.GC12311@dhcp22.suse.cz>
References: <1559857274-20824-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559857274-20824-1-git-send-email-akaher@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 07-06-19 03:11:14, Ajay Kaher wrote:
[...]
> [Ajay: Dropped infiniband changes to get patch to apply on 4.9.y]
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  fs/proc/task_mmu.c    | 18 ++++++++++++++++++
>  fs/userfaultfd.c      |  9 +++++++++
>  include/linux/sched.h | 21 +++++++++++++++++++++
>  mm/mmap.c             |  7 ++++++-
>  4 files changed, 54 insertions(+), 1 deletion(-)

Are you sure that the backport is complete? I do not see binder code to
be patched, nor khugepaged. Have you considered all places that take
the exclusive mmap_sem on a remote process mm? See my backport for 4.4
stable tree
http://lkml.kernel.org/r/20190604094953.26688-1-mhocko@kernel.org
for reference. Also please note that my backport needs to be reviewed as
well.
-- 
Michal Hocko
SUSE Labs
