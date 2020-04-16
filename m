Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C311AC20B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894738AbgDPNFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894562AbgDPNFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:05:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE36214AF;
        Thu, 16 Apr 2020 13:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587042330;
        bh=1aqS3ApOJZL131b3+GP4SDwvys2LjxC6LVYadv4Jp5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F7dA11MECDQf4JRUI8jcS2j/XplUbOOQt9U0ycAufMCNc2mDB7BMRu69WD8M4pfMq
         Urx4i6xs4ZVVS9aWy5B5XZPquKMA4X/9JJmzpZjWSw+7cFci1b8IgiLMCglXKvSdeg
         hgtPgRa8cu2vmXNAXKw3FgQlTdV+XP355S+kWs4M=
Date:   Thu, 16 Apr 2020 09:05:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: handle logged extent failure
 properly" failed to apply to 5.6-stable tree
Message-ID: <20200416130528.GJ1068@sasha-vm>
References: <158687410512288@kroah.com>
 <20200416004154.GN1068@sasha-vm>
 <20200416070720.GC372946@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200416070720.GC372946@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 09:07:20AM +0200, Greg KH wrote:
>On Wed, Apr 15, 2020 at 08:41:54PM -0400, Sasha Levin wrote:
>> On Tue, Apr 14, 2020 at 04:21:45PM +0200, gregkh@linuxfoundation.org wrote:
>> >
>> > The patch below does not apply to the 5.6-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> > > From ab9b2c7b32e6be53cac2e23f5b2db66815a7d972 Mon Sep 17 00:00:00 2001
>> > From: Josef Bacik <josef@toxicpanda.com>
>> > Date: Thu, 13 Feb 2020 10:47:30 -0500
>> > Subject: [PATCH] btrfs: handle logged extent failure properly
>> >
>> > If we're allocating a logged extent we attempt to insert an extent
>> > record for the file extent directly.  We increase
>> > space_info->bytes_reserved, because the extent entry addition will call
>> > btrfs_update_block_group(), which will convert the ->bytes_reserved to
>> > ->bytes_used.  However if we fail at any point while inserting the
>> > extent entry we will bail and leave space on ->bytes_reserved, which
>> > will trigger a WARN_ON() on umount.  Fix this by pinning the space if we
>> > fail to insert, which is what happens in every other failure case that
>> > involves adding the extent entry.
>> >
>> > CC: stable@vger.kernel.org # 5.4+
>> > Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> > Reviewed-by: Qu Wenruo <wqu@suse.com>
>> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> > Reviewed-by: David Sterba <dsterba@suse.com>
>> > Signed-off-by: David Sterba <dsterba@suse.com>
>>
>> Greg, I've noticed that you've fixed it up for 5.5 and 5.4 but no for
>> 5.6? I've queued it up for 5.6 as well.
>
>I didn't include this in 5.5 or 5.4, so please queue it up in those two
>trees as well.

Hm, looking at the patch:

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a7bc66121330e..219ac9990513e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4431,7 +4431,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
        ret = alloc_reserved_file_extent(trans, 0, root_objectid, 0, owner,
                                         offset, ins, 1);
        if (ret)
-               btrfs_pin_extent(fs_info, ins->objectid, ins->offset, 1);
+               btrfs_pin_extent(trans, ins->objectid, ins->offset, 1);
        btrfs_put_block_group(block_group);
        return ret;
 }

It changes the var and type used to call btrfs_pin_extent() without
changing the declaration of btrfs_pin_extent() itself - which is weird.

The change to btrfs_pin_extent() was done in b25c36f84b59 ("btrfs: Make
btrfs_pin_extent take trans handle"), but then I'm confused how this
patch on it's own fixes anything but a build issue - which makes the
commit message confusing :)

Maybe one of the btrfs folks could clarify?

-- 
Thanks,
Sasha
