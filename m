Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1EE4EDF48
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 19:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiCaRBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiCaRBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:01:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A9A5E17F;
        Thu, 31 Mar 2022 09:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3DD60E07;
        Thu, 31 Mar 2022 16:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3A8C340EE;
        Thu, 31 Mar 2022 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648745974;
        bh=7kePnT16ECG6vUzK8truXpfEWu5ek7LRonOL0F/VLQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kCZiOh1DDEfiqjqBWHNiuYgKMl0D2Y2Zp/KLewtCTnTDXrqsT00LjRSTfealyT+6/
         Y7PHnOatYazgb7MakPlgACWBSFKqMqznd5oTyDqCdNH79Yx4RPpFEZSHAnlHKUTBsI
         1JOci/b/diMpiN8V0fiwDPRI8NjgkG7yJya/R2YPH16NkHv9DsL8TVu/k2ZzoNF3ea
         wCZYWtZFE4Dv8zt/NqGxxHPkd7apnNYbivs5Zp8AfI4uUGv2XE5cckX7ZDkd+JeIP1
         UpSfMrIjrr8a+sW5Xakh3QS/KM+4WgMId6JVS98Rg8jlpXGKkbu7lTRb6HUv7qG/VD
         H4lvPALsq+9zQ==
Date:   Thu, 31 Mar 2022 12:59:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 17/21] btrfs: reset last_reflink_trans after
 fsyncing inode
Message-ID: <YkXd9UTuFbNDNjo3@sashalap>
References: <20220328194157.1585642-1-sashal@kernel.org>
 <20220328194157.1585642-17-sashal@kernel.org>
 <YkLYhad7iX2Bv/j1@debian9.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkLYhad7iX2Bv/j1@debian9.Home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 10:59:33AM +0100, Filipe Manana wrote:
>On Mon, Mar 28, 2022 at 03:41:52PM -0400, Sasha Levin wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> [ Upstream commit 23e3337faf73e5bb2610697977e175313d48acb0 ]
>>
>> When an inode has a last_reflink_trans matching the current transaction,
>> we have to take special care when logging its checksums in order to
>> avoid getting checksum items with overlapping ranges in a log tree,
>> which could result in missing checksums after log replay (more on that
>> in the changelogs of commit 40e046acbd2f36 ("Btrfs: fix missing data
>> checksums after replaying a log tree") and commit e289f03ea79bbc ("btrfs:
>> fix corrupt log due to concurrent fsync of inodes with shared extents")).
>> We also need to make sure a full fsync will copy all old file extent
>> items it finds in modified leaves, because they might have been copied
>> from some other inode.
>>
>> However once we fsync an inode, we don't need to keep paying the price of
>> that extra special care in future fsyncs done in the same transaction,
>> unless the inode is used for another reflink operation or the full sync
>> flag is set on it (truncate, failure to allocate extent maps for holes,
>> and other exceptional and infrequent cases).
>>
>> So after we fsync an inode reset its last_unlink_trans to zero. In case
>> another reflink happens, we continue to update the last_reflink_trans of
>> the inode, just as before. Also set last_reflink_trans to the generation
>> of the last transaction that modified the inode whenever we need to set
>> the full sync flag on the inode, just like when we need to load an inode
>> from disk after eviction.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>What's the motivation to backport this to stable?
>
>It doesn't fix a bug or any regression, as far as I know at least.
>Or is it to make some other backport easier?

I wasn't sure if it's needed for completeness for the mentioned fixes,
so I took it. Can drop it if it's not needed.

-- 
Thanks,
Sasha
