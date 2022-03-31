Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D844EDF3E
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiCaRAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbiCaRAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAF510FDA;
        Thu, 31 Mar 2022 09:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 974E1B8218B;
        Thu, 31 Mar 2022 16:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F925C340ED;
        Thu, 31 Mar 2022 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648745909;
        bh=BKvjdCsLv3Ic0I4T8UQJKKMnRKPo6SUNKqirrFu3/C4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JtVeH3izMStBmLto12CoHY4knU6SF4TbKy6AqDSbaWECEbBUP1DE4hLgj/+p4sY42
         pw0/AbXsy4aANqylze5HV/8gqhD1JhCrK7OCAejPCmdyFqNGNqMthkz3aAuynVkv18
         FNvkKCmTUdVu/sXQmJzSV5iOGiRZU148YVqIfrX8kPM9/nQB47GD77M2+J2hi+8LBc
         2gMGB3y3LuFvTHmVm1Y9yxoUiJYnG/3QcCuLl9H6ez5Bur1IBVPC3AHM4O2IPMjvmw
         6ULEk5b4jTP6VEIapaGh9Y8M9CCaxNLeObTMgLp3ZblDhgSiPkUBPaC2UTzi+APBst
         33VrTfgRN1gQA==
Date:   Thu, 31 Mar 2022 12:58:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 12/21] btrfs: don't advance offset for
 compressed bios in btrfs_csum_one_bio()
Message-ID: <YkXdtBfNbH2/oP5z@sashalap>
References: <20220328194157.1585642-1-sashal@kernel.org>
 <20220328194157.1585642-12-sashal@kernel.org>
 <YkNko1BcsyDt2QUS@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkNko1BcsyDt2QUS@relinquished.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 12:57:23PM -0700, Omar Sandoval wrote:
>On Mon, Mar 28, 2022 at 03:41:47PM -0400, Sasha Levin wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> [ Upstream commit e331f6b19f8adde2307588bb325ae5de78617c20 ]
>>
>> btrfs_csum_one_bio() loops over each filesystem block in the bio while
>> keeping a cursor of its current logical position in the file in order to
>> look up the ordered extent to add the checksums to. However, this
>> doesn't make much sense for compressed extents, as a sector on disk does
>> not correspond to a sector of decompressed file data. It happens to work
>> because:
>>
>> 1) the compressed bio always covers one ordered extent
>> 2) the size of the bio is always less than the size of the ordered
>>    extent
>>
>> However, the second point will not always be true for encoded writes.
>>
>> Let's add a boolean parameter to btrfs_csum_one_bio() to indicate that
>> it can assume that the bio only covers one ordered extent. Since we're
>> already changing the signature, let's get rid of the contig parameter
>> and make it implied by the offset parameter, similar to the change we
>> recently made to btrfs_lookup_bio_sums(). Additionally, let's rename
>> nr_sectors to blockcount to make it clear that it's the number of
>> filesystem blocks, not the number of 512-byte sectors.
>>
>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/btrfs/compression.c |  2 +-
>>  fs/btrfs/ctree.h       |  2 +-
>>  fs/btrfs/file-item.c   | 37 +++++++++++++++++--------------------
>>  fs/btrfs/inode.c       |  8 ++++----
>>  4 files changed, 23 insertions(+), 26 deletions(-)
>
>Hi, Sasha,
>
>This patch doesn't fix a real bug, so it should be dropped from both
>5.16 and 5.17.

I'll drop it, thanks.

-- 
Thanks,
Sasha
