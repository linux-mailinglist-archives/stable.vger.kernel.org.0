Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504BE217D09
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 04:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgGHC3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 22:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbgGHC3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 22:29:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A3CF20774;
        Wed,  8 Jul 2020 02:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594175377;
        bh=xgGx6uwzn9NeaS+l/FPAXpAhoUdDQ2XZYX9DVgRf5YU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ik3+CPSPmGpG2ABntxHOaGn++8Mk0ZxRqeqGC8DMhDNuvYFl6h2xPef1WYY0+Fi8R
         +ONgL8jclZXHfUWwVBxaAdyk9VXXxmtKAzVd3ETzd6aNdbklKej6bZBq6z18pvxqLd
         fopJbsNzbONot3a9YpLmVcpfLgBrZ3HqxNvn0qd4=
Date:   Tue, 7 Jul 2020 22:29:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 10/36] nvme: fix possible deadlock when I/O is
 blocked
Message-ID: <20200708022935.GW2722994@sasha-vm>
References: <20200707145749.130272978@linuxfoundation.org>
 <20200707145749.639245963@linuxfoundation.org>
 <20200707181641.GA6290@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200707181641.GA6290@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 08:16:41PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Sagi Grimberg <sagi@grimberg.me>
>>
>> [ Upstream commit 3b4b19721ec652ad2c4fe51dfbe5124212b5f581 ]
>>
>> Revert fab7772bfbcf ("nvme-multipath: revalidate nvme_ns_head gendisk
>> in nvme_validate_ns")
>>
>> When adding a new namespace to the head disk (via nvme_mpath_set_live)
>> we will see partition scan which triggers I/O on the mpath device node.
>> This process will usually be triggered from the scan_work which holds
>> the scan_lock. If I/O blocks (if we got ana change currently have only
>> available paths but none are accessible) this can deadlock on the head
>> disk bd_mutex as both partition scan I/O takes it, and head disk revalidation
>> takes it to check for resize (also triggered from scan_work on a different
>> path). See trace [1].
>>
>> The mpath disk revalidation was originally added to detect online disk
>> size change, but this is no longer needed since commit cb224c3af4df
>> ("nvme: Convert to use set_capacity_revalidate_and_notify") which
>> already
>
>AFAICT cb224c3af4df is not applied to 4.19-stable series, so this is
>not safe according to the changelog.
>
>cb224c3af4df is simple enough, but AFAICT
>set_capacity_revalidate_and_notify() is missing in 4.19.132-rc1.

Good point... It might be the case that e598a72faeb5 ("block/genhd:
Notify udev about capacity change") is safe to take along with
cb224c3af4df.

I'll look at it once these releases are out, but for now I'll drop this
commit. Thanks!

-- 
Thanks,
Sasha
