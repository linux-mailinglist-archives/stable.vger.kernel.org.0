Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6F27B81F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 01:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgI1Xac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 19:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgI1Xab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 19:30:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E05221E8;
        Mon, 28 Sep 2020 22:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601331093;
        bh=YBeqDoTTv1COv/mV2jDQE4oU4Ml8daQLTPiWYQ8o1pc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hjx+tNOq1Riy+XNlQ3y1QeseKZxGAFUVtgeV0Y/P4EL/XtY9dzpUL2s+kM97s12Z0
         hbUh4DkQBxnQVMbDeJiEi8ghw3tV7qOKCZwUA7iOSp3reMkdSPK05045/LtP4OrOiC
         3S0wMAcBcoKxOEvVY8gS/dJqE1QfSZvz+3xse8+A=
Date:   Mon, 28 Sep 2020 18:11:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable queue/5.4] build errors on queue/5.4
Message-ID: <20200928221131.GF2219727@sasha-vm>
References: <CAMGffEnTKBjKq7xLxFBPcigwrA4=LM+M_EL+tGYS_oZeY=2ywA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMGffEnTKBjKq7xLxFBPcigwrA4=LM+M_EL+tGYS_oZeY=2ywA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 10:55:03AM +0200, Jinpu Wang wrote:
>Hi Sasha,
>
>I noticed build error on latest stable-rc/queue/5.4 branch:
>
>util/parse-events.c: In function 'parse_events_add_pmu':
>util/parse-events.c:1373:11: error: 'struct perf_evsel_config_term'
>has no member named 'free_str'
>    if (pos->free_str)
>           ^~
>In file included from util/parse-events.c:4:
>util/parse-events.c:1374:20: error: 'union <anonymous>' has no member
>named 'str'
>     zfree(&pos->val.str);
>                    ^
>/<<PKGBUILDDIR>>/tools/include/linux/zalloc.h:10:38: note: in
>definition of macro 'zfree'
> #define zfree(ptr) __zfree((void **)(ptr))
>
>revert both
>d6ac1bd91161 ("perf parse-events: Fix incorrect conversion of 'if ()
>free()' to 'zfree()'")
>b6f48cb0c18b ("perf parse-events: Fix memory leaks found on parse_events")
>
>Fixed the problem.

Fixed up, thanks!

-- 
Thanks,
Sasha
