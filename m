Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4241C256EC2
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgH3Oqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 10:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgH3Oqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 10:46:34 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2FBC2087D;
        Sun, 30 Aug 2020 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598798794;
        bh=U0oxIumzrar1JxnaRQFyP4U4DzbcRA+kUEXg1R8kxBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1JwZ13c/x1oacuBew1ze9HEyy4RETXNJ52/lKHfkM8iLJO1lZWdbNSCdPHhcuNqR
         0iJtU4EPgyJklusLudVn+7ivjFwwpEQSqQXbUdVsZv3VWJEXcfFua2LiLgCAo2TLmI
         nOgl5yxGkf6rvQhZ0aiLLWlnWYXlqx+bafPq0yvg=
Date:   Sun, 30 Aug 2020 10:46:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 34/38] btrfs: file: reserve qgroup space
 after the hole punch range is locked
Message-ID: <20200830144632.GZ8670@sasha-vm>
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-34-sashal@kernel.org>
 <20200829121123.GB20944@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200829121123.GB20944@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 29, 2020 at 02:11:23PM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit a7f8b1c2ac21bf081b41264c9cfd6260dffa6246 ]
>>
>> The incoming qgroup reserved space timing will move the data reservation
>> to ordered extent completely.
>>
>> However in btrfs_punch_hole_lock_range() will call
>> btrfs_invalidate_page(), which will clear QGROUP_RESERVED bit for the
>> range.
>>
>> In current stage it's OK, but if we're making ordered extents handle the
>> reserved space, then btrfs_punch_hole_lock_range() can clear the
>> QGROUP_RESERVED bit before we submit ordered extent, leading to qgroup
>> reserved space leakage.
>>
>> So here change the timing to make reserve data space after
>> btrfs_punch_hole_lock_range().
>> The new timing is fine for either current code or the new code.
>
>I'm not sure why this is queued for -stable. It is preparation for
>future work, and that work is not queued for -stable.

So you understand why it was queued: it's preparation for a fix that is
relevant to 4.19 but didn't apply cleanly.

I can look into what happened next week, or if you'd sent me a backport
I'd be happy to take it.

-- 
Thanks,
Sasha
