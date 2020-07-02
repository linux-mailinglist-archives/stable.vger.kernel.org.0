Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BFA21281D
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGBPkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 11:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgGBPkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 11:40:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3BC720737;
        Thu,  2 Jul 2020 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593704411;
        bh=oJ3zHcVqAy/JxZzwfoHUXTSMOzOw+ZzJ9i06DTlWEQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x0J9iRMH/EhuNiq2457CW/wn1T/c12TJZpm6/1/anz9hfxJxrMqCXYCudIO27WZA4
         pvesBX87itDCyPpafqWTznHkOt2mI4hESOSYQ4Co3fW+u6mfGoS4X1VMh39WOHjl7E
         CbHmImOKsaPhWHEu2f2WT03y+t40twd0QCjIjg80=
Date:   Thu, 2 Jul 2020 11:40:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com,
        nborisov@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix a block group ref counter leak
 after failure to" failed to apply to 4.19-stable tree
Message-ID: <20200702154009.GA2722994@sasha-vm>
References: <1593428443202151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1593428443202151@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 01:00:43PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 9fecd13202f520f3f25d5b1c313adb740fe19773 Mon Sep 17 00:00:00 2001
>From: Filipe Manana <fdmanana@suse.com>
>Date: Mon, 1 Jun 2020 19:12:06 +0100
>Subject: [PATCH] btrfs: fix a block group ref counter leak after failure to
> remove block group
>
>When removing a block group, if we fail to delete the block group's item
>from the extent tree, we jump to the 'out' label and end up decrementing
>the block group's reference count once only (by 1), resulting in a counter
>leak because the block group at that point was already removed from the
>block group cache rbtree - so we have to decrement the reference count
>twice, once for the rbtree and once for our lookup at the start of the
>function.
>
>There is a second bug where if removing the free space tree entries (the
>call to remove_block_group_free_space()) fails we end up jumping to the
>'out_put_group' label but end up decrementing the reference count only
>once, when we should have done it twice, since we have already removed
>the block group from the block group cache rbtree. This happens because
>the reference count decrement for the rbtree reference happens after
>attempting to remove the free space tree entries, which is far away from
>the place where we remove the block group from the rbtree.
>
>To make things less error prone, decrement the reference count for the
>rbtree immediately after removing the block group from it. This also
>eleminates the need for two different exit labels on error, renaming
>'out_put_label' to just 'out' and removing the old 'out'.
>
>Fixes: f6033c5e333238 ("btrfs: fix block group leak when removing fails")
>CC: stable@vger.kernel.org # 4.4+
>Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>Reviewed-by: Anand Jain <anand.jain@oracle.com>
>Signed-off-by: Filipe Manana <fdmanana@suse.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

On older branches, btrfs_remove_block_group() lived in
fs/btrfs/extent-tree.c. I've fixed up the patch and queued it for
4.19-4.9. The 4.4 backport needs some attention.

-- 
Thanks,
Sasha
