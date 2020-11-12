Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AE32B097B
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 17:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgKLQGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 11:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgKLQGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 11:06:17 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B25322227;
        Thu, 12 Nov 2020 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605197176;
        bh=10qvMBJzG+sSHOSl4DkAXx/fQBkcDpJgq49vggcntLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OpASYblgoZtU0AQ0o8DCgy4rY7gskFu/y14hKoUOVXbTl5c/4MNXrev1MNHft70p6
         I2c0MBQN0q5JrX/6+Rq1AMvzYUgCgZgBcIiLqfU5rWDuKMP+EZZp4HOyoi7MDEYlLI
         LupOQy+ceXOfr+ixjH/kK91lL+PSIPv0qT5cv3S4=
Date:   Thu, 12 Nov 2020 11:06:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4.19 19/71] btrfs: extent_io: add proper error handling
 to lock_extent_buffer_for_io()
Message-ID: <20201112160615.GC403069@sasha-vm>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125020.811120362@linuxfoundation.org>
 <20201111124448.GA26508@amd>
 <b51433b08042307ddbbdcb818bc5eab0d4cb8bec.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b51433b08042307ddbbdcb818bc5eab0d4cb8bec.camel@codethink.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 02:39:34PM +0000, Ben Hutchings wrote:
>On Wed, 2020-11-11 at 13:44 +0100, Pavel Machek wrote:
>> Hi!
>>
>> > Thankfully it's handled by the only caller, btree_write_cache_pages(),
>> > as later write_one_eb() call will trigger submit_one_bio().  So there
>> > shouldn't be any problem.
>>
>> This explains there should not be any problem in _the
>> mainline_. AFAICT this talks about this code. Mainline version is:
>>
>>  prev_eb = eb;
>>  ret = lock_extent_buffer_for_io(eb, &epd);
>>  if (!ret) {
>>  	free_extent_buffer(eb);
>>  	continue;
>>  } else if (ret < 0) {
>>  	done = 1;
>>  	free_extent_buffer(eb);
>>  	break;
>>  }
>>
>> But 4.19 has:
>>
>>  ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
>>  if (!ret) {
>>   	free_extent_buffer(eb);
>>  	continue;
>>  }
>
>That was changed in mainline two releases after this commit, though.
>
>> IOW missing the code mentioned in the changelog. Is 0607eb1d452d4
>> prerequisite for this patch?
>
>I think it's a separate fix, but probably worth picking too.

I'll take it in too, thanks!

-- 
Thanks,
Sasha
