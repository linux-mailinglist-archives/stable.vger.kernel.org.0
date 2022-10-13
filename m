Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AED55FE0B5
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiJMSNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiJMSMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:12:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4672170DDB;
        Thu, 13 Oct 2022 11:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84550B82036;
        Thu, 13 Oct 2022 17:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C5FC433C1;
        Thu, 13 Oct 2022 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683749;
        bh=3FTYuGT7nw9NB56TvQ4if0y5cqaa0gEFg/Ln0VSlmD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2zpTStwDhSQFnCPBMdL5w6vdNT5dL/nZAsg5+Djyl6xtjOS/4v0f4zoMfL9cNoAV
         HuPp7hB0fTCB7m0j25kwF3N0oUyQaqRNVv/P+eJmA/sZ73fYFIz8N+T1dm1fW5nCzS
         LMa6Jo5PEAbRumCHCuDVdO0DdzZT64DVg2WPff5jrQrteY5kqX5a/Oc5+97i27m9Jq
         kZ6NQbkq7l2bkGfu7D+TntU9tLb088wMsUw0RGyIBtdaQHUDUF/5kVwrk+ePpBpJkX
         fFMZX94ubP4ocpDrXfwM06xaZYQvnrvHX5jmetT4Zr5rK2CxIQ5yHIcd5EC5mKjnu6
         e8kHTlX91AQzw==
Date:   Thu, 13 Oct 2022 13:55:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 33/46] btrfs: get rid of block group caching
 progress logic
Message-ID: <Y0hRJNrAwSxXvoqV@sashalap>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-33-sashal@kernel.org>
 <Y0YAaXPzuSmSKwiG@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0YAaXPzuSmSKwiG@relinquished.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 04:46:49PM -0700, Omar Sandoval wrote:
>On Tue, Oct 11, 2022 at 10:50:01AM -0400, Sasha Levin wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> [ Upstream commit 48ff70830bec1ccc714f4e31059df737f17ec909 ]
>>
>> struct btrfs_caching_ctl::progress and struct
>> btrfs_block_group::last_byte_to_unpin were previously needed to ensure
>> that unpin_extent_range() didn't return a range to the free space cache
>> before the caching thread had a chance to cache that range. However, the
>> commit "btrfs: fix space cache corruption and potential double
>> allocations" made it so that we always synchronously cache the block
>> group at the time that we pin the extent, so this machinery is no longer
>> necessary.
>>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/btrfs/block-group.c     | 13 ------------
>>  fs/btrfs/block-group.h     |  2 --
>>  fs/btrfs/extent-tree.c     |  9 ++-------
>>  fs/btrfs/free-space-tree.c |  8 --------
>>  fs/btrfs/transaction.c     | 41 --------------------------------------
>>  fs/btrfs/zoned.c           |  1 -
>>  6 files changed, 2 insertions(+), 72 deletions(-)
>
>Hi, Sasha,
>
>This commit is a cleanup. Please drop it from 6.0 and 5.19.

Ack, thanks!

-- 
Thanks,
Sasha
