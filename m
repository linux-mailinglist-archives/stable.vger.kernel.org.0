Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A475C34F2E8
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 23:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhC3VPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 17:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232549AbhC3VPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 17:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4CA9619C7;
        Tue, 30 Mar 2021 21:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617138911;
        bh=CxxRJoq3whxYbBkHOiov7iUfokoLNhhoidpJLU7R/2I=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=D0cwlW5cpzXEHoyBAhF3+z+PQxjiOB8xAls8gm5gx38D1b5vUrhjJXInBAl754cUE
         A7KfJTSBgvuMyZUf69cFfjAav07+yJO83JEhGaAbfdEKuGNAim1T+Wjr/wDXHrjyhV
         qYr1ezKY3Dw7BLrqx1X0XLqc7M4WqXIpnQ9dJrzg8n5dNj/o2Trwts7SC3XK7z36VV
         60tKEFEx+RgXc7Uo4RIjthUh9hRZqAQ+ddnhwzth+XCLGZtspirbTw1mjKOO6uivLK
         0WA8B3Blke7DtmUwDBEqtYke7PB5IEChr0l2W2mzCZ7N6kmX5cOyxooD2MF4oiQsSB
         yAmuTcuFhyzlA==
Date:   Tue, 30 Mar 2021 17:15:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 26/44] btrfs: track qgroup released data in
 own variable in insert_prealloc_file_extent
Message-ID: <YGOU3rct+jbzVi8R@sashalap>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-26-sashal@kernel.org>
 <20210325120802.GK7604@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210325120802.GK7604@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 01:08:02PM +0100, David Sterba wrote:
>On Thu, Mar 25, 2021 at 07:24:41AM -0400, Sasha Levin wrote:
>> From: Qu Wenruo <wqu@suse.com>
>>
>> [ Upstream commit fbf48bb0b197e6894a04c714728c952af7153bf3 ]
>>
>> There is a piece of weird code in insert_prealloc_file_extent(), which
>> looks like:
>>
>> 	ret = btrfs_qgroup_release_data(inode, file_offset, len);
>> 	if (ret < 0)
>> 		return ERR_PTR(ret);
>> 	if (trans) {
>> 		ret = insert_reserved_file_extent(trans, inode,
>> 						  file_offset, &stack_fi,
>> 						  true, ret);
>> 	...
>> 	}
>> 	extent_info.is_new_extent = true;
>> 	extent_info.qgroup_reserved = ret;
>> 	...
>>
>> Note how the variable @ret is abused here, and if anyone is adding code
>> just after btrfs_qgroup_release_data() call, it's super easy to
>> overwrite the @ret and cause tons of qgroup related bugs.
>>
>> Fix such abuse by introducing new variable @qgroup_released, so that we
>> won't reuse the existing variable @ret.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch is a preparatory work and does not make sense for backport
>standalone. Either this one plus
>https://lore.kernel.org/linux-btrfs/20210303104152.105877-2-wqu@suse.com/
>or neither. And IIRC it does not apply directly and needs some
>additional review before it can be backported to older code base, so it
>has no CC: stable tags.

I'll drop it, thanks!

-- 
Thanks,
Sasha
