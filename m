Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2BC32DCEE
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 23:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhCDWYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 17:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhCDWYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 17:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03D6D64FF1;
        Thu,  4 Mar 2021 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614896693;
        bh=LRzk6rIjoAeAQJOsL8Nqck/gDIGCM8liBnPrR/UB3XY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=sw/YY5Jp0sXBd9M83p3EKhMGatcdg97Ei+UN3LNes/HowYn724oVBfNZtZrDkh4LZ
         Yv+tyFTCPttTyO5T6mljyRJIysk4eGLvja7lKeuiOm4qBtYLYcRbq48jt60UwRol7w
         JaFun2Dg7XbH9QkahG1CdzY7iNsPFtgzGlA26u7ohwOyI26SoGFlgKkU479aW0yJwE
         gjxqJvt+oUtUlkSvtQDcvRIHD9p45QQt5hct09cswmlq64bndGbJKlDB7IEtPIRfyB
         L7zaZ9PFVX9CC9+uEDnz5DVdzEDYNt849er1YdhXE0u5Wt7jeaHjHg0rg696Xaeqzb
         Wu7qqySOaJsoQ==
Date:   Thu, 4 Mar 2021 17:24:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 54/67] btrfs: make
 btrfs_start_delalloc_root's nr argument a long
Message-ID: <YEFeNKXQ7FsUoJrt@sashalap>
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-54-sashal@kernel.org>
 <20210224180942.GZ1993@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210224180942.GZ1993@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:09:42PM +0100, David Sterba wrote:
>On Wed, Feb 24, 2021 at 07:50:12AM -0500, Sasha Levin wrote:
>> From: Nikolay Borisov <nborisov@suse.com>
>>
>> [ Upstream commit 9db4dc241e87fccd8301357d5ef908f40b50f2e3 ]
>>
>> It's currently u64 which gets instantly translated either to LONG_MAX
>> (if U64_MAX is passed) or cast to an unsigned long (which is in fact,
>> wrong because writeback_control::nr_to_write is a signed, long type).
>>
>> Just convert the function's argument to be long time which obviates the
>> need to manually convert u64 value to a long. Adjust all call sites
>> which pass U64_MAX to pass LONG_MAX. Finally ensure that in
>> shrink_delalloc the u64 is converted to a long without overflowing,
>> resulting in a negative number.
>
>This patch is a cleanup and I don't see any other patch depend on it, so
>please drop it from autosel.

I'll drop it, thanks!

-- 
Thanks,
Sasha
