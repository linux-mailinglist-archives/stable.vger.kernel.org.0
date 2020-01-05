Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7D91308DC
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 16:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAEPrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 10:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgAEPri (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 10:47:38 -0500
Received: from localhost (unknown [73.61.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E212077B;
        Sun,  5 Jan 2020 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578239258;
        bh=/dAZarcvxCsitg+Stew117r8KkhBn7Ok0MYDAr0QGSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0BMiktE5AmVX1DuclgiX4Xh7K1fR7MvDPGCFJhyUVw4ugE64T2uLtMo2NkEODBDkd
         bTKCOssnS2YLnsywJgnTCGX+qzbpYYcCJelya8GkKnGpFBIeBVF3iX85528SJFjdt4
         V5k/md871fsY+d0r6coalr3guCQOsFWqDvzLxSfc=
Date:   Sun, 5 Jan 2020 10:47:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Chris Down <chris@chrisdown.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 071/114] kernel: sysctl: make drop_caches write-only
Message-ID: <20200105154735.GQ16372@sasha-vm>
References: <20200102220029.183913184@linuxfoundation.org>
 <20200102220036.228967185@linuxfoundation.org>
 <20200103182911.GE14328@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200103182911.GE14328@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 07:29:11PM +0100, Pavel Machek wrote:
>Hi!
>
>> From: Johannes Weiner <hannes@cmpxchg.org>
>>
>> [ Upstream commit 204cb79ad42f015312a5bbd7012d09c93d9b46fb ]
>>
>> Currently, the drop_caches proc file and sysctl read back the last value
>> written, suggesting this is somehow a stateful setting instead of a
>> one-time command.  Make it write-only, like e.g.  compact_memory.
>
>I have no problem with that, but is it good idea for stable?

Usually I'd drop it, yes. In this case it seems like it made "real"
users interact with the switch incorrectly, which I parse as a bug.

>Plus, I seem to recall that drop_caches was somehow dangerous,
>debugging-only stuff, one should not use on production system. Did
>that get fixed in the meantime?

Sounds like it's being used in production, at scale, so I'd hope so :)

-- 
Thanks,
Sasha
