Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA8162952
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 16:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBRPVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 10:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgBRPVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 10:21:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2712420679;
        Tue, 18 Feb 2020 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582039297;
        bh=MsKV/xYN47aCVRgI/YrteenwxAkj4w1wnfbAF5aBSHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pb9iDQnqN+9vvY7eLj7gM0UgNTP9aNiFjDxf9K8iueuvqEbWn6IdR4EbZFucIF5zb
         YmDgBFhGnguj4EizvQqwwIkPN9QLsPgc4OC/L3qggqG1RNoR/14CLARUlSzAyfU6at
         o53F+ImSLaQACKxk44yoOHvSjxapsqBUhAylAwA0=
Date:   Tue, 18 Feb 2020 10:21:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Santosh Sivaraj <santosh@fossix.org>, stable@vger.kernel.org
Subject: Re: Random memory corruption may occur due to incorrent tlb flushes
Message-ID: <20200218152136.GL1734@sasha-vm>
References: <87pnecxqlg.fsf@santosiv.in.ibm.com>
 <20200218084901.GA2285287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200218084901.GA2285287@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 09:49:01AM +0100, Greg KH wrote:
>On Tue, Feb 18, 2020 at 01:41:07PM +0530, Santosh Sivaraj wrote:
>> Hi Greg/Sasha,
>>
>> The commit a46cc7a90fd (powerpc/mm/radix: Improve
>> TLB/PWC flushes) picked up in 4.14 release has the potential to cause random
>> memory corruption. This was fixed in 5.5 by the following patches.
>>
>> 12e4d53f3f powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
>> 0ed1325967 mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
>> 0758cd8304 asm-generic/tlb: avoid potential double flush
>>
>> It's a bit tricky to backport to 4.14 stable (though I have a backport to 4.19
>> stable, which I will post shortly). If you think it's important to fix this in
>> 4.14, it would easier to revert the above mentioned commit (a46cc7a90fd).
>>
>> Please let me know your thoughts.
>
>A revert is probably best, can you send it?

This is a bit tricky because a46cc7a90fd wasn't picked up by as, but
rather is part of the 4.14 kernel. Please make sure you Cc the revert to
the PowerPC mm folks so they could give it a careful review, as it's
much more complex than just reverting a stable commit we queued up.

-- 
Thanks,
Sasha
