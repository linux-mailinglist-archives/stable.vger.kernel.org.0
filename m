Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DE716987
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfEGRpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbfEGRpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:45:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D85A205C9;
        Tue,  7 May 2019 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557251115;
        bh=mE/YighewZji2jdALogvRxl+gKJULhzu19FRdUZqyHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sY8/+8XQ92ZXJgN8PAqu8UrV/K07qeZA1yYTfgXcoC/e6WoGCQKN8S+/hRLPmUZhS
         0aJgZ3eezGGEiPFqd+8x7IGAN0cHy4GBimd72MOJC7icpy9MMCykrksZnR+0EeWn0k
         KT9xDdfYUnnWMNzK2P2eNli9huwC2R6ijAa7gcb4=
Date:   Tue, 7 May 2019 13:45:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Michal Hocko <mhocko@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
Message-ID: <20190507174514.GI1747@sasha-vm>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
 <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
 <20190507170208.GF1747@sasha-vm>
 <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
 <20190507171806.GG1747@sasha-vm>
 <20190507173224.GS31017@dhcp22.suse.cz>
 <20190507173655.GA1403@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190507173655.GA1403@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 10:36:55AM -0700, Matthew Wilcox wrote:
>On Tue, May 07, 2019 at 07:32:24PM +0200, Michal Hocko wrote:
>> On Tue 07-05-19 13:18:06, Sasha Levin wrote:
>> > Michal, is there a testcase I can plug into kselftests to make sure we
>> > got this right (and don't regress)? We care a lot about memory hotplug
>> > working right.
>>
>> As said in other email. The memory hotplug tends to work usually. It
>> takes unexpected memory layouts which trigger corner cases. This makes
>> testing really hard.
>
>Can we do something with qemu?  Is it flexible enough to hotplug memory
>at the right boundaries?

That was my thinking too. qemu should be able to reproduce all these
"unexpected" memory layouts we've had issue with so far and at the very
least make sure we don't regress on those.

We're going to have (quite a) large amount of systems with "weird"
memory layouts that do memory hotplug quite frequently in production, so
this whole "tends to work usually" thing kinda scares me.

--
Thanks,
Sasha
