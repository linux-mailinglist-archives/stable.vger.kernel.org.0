Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83541AF2E4
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDRRin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 13:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDRRin (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 13:38:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BBC20724;
        Sat, 18 Apr 2020 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587231522;
        bh=Nc8OhsFzQOJr/tZ0tnZenfidFaopuDzt197ESLvR4dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lzGk+BMLwJlK+ZZyZVoMFcTWuzaJX3c6zlGLKk1V+tOHQI+FT8cMjNysUY2mgG8h6
         R5y1Q7FqivmB3apwcX9KZ1SzwB+/mONRrz81TQ66k8oiLpU0FllAmDtS8lDA0I7eB7
         Sthz0qVzdxs+PQGPcAZ6uK05cx3OyUup/Zo2rRjk=
Date:   Sat, 18 Apr 2020 13:38:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     gregkh@linuxfoundation.org, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] posix-cpu-timers: Store a reference to a
 pid not a task" failed to apply to 5.6-stable tree
Message-ID: <20200418173841.GD1809@sasha-vm>
References: <158720526370190@kroah.com>
 <871rol3r7v.fsf@x220.int.ebiederm.org>
 <20200418160513.GB1809@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200418160513.GB1809@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 18, 2020 at 12:05:13PM -0400, Sasha Levin wrote:
>On Sat, Apr 18, 2020 at 07:37:08AM -0500, Eric W. Biederman wrote:
>><gregkh@linuxfoundation.org> writes:
>>
>>>The patch below does not apply to the 5.6-stable tree.
>>>If someone wants it applied there, or to any other stable or longterm
>>>tree, then please email the backport, including the original git commit
>>>id to <stable@vger.kernel.org>.
>>
>>So for anyone who cares the fix I refer to in the commit comment is the
>>workaround that keeps the past implementation from being a real problem.
>>
>>I just see this as code cleanup so I can remove the old workaround.  The
>>old workaround will cause posix_cpu_timers_exit_group to be called early
>>on particular variants of multi-threaded exec, resulting in the
>>corresponding cpu clock stopping.  So this does represent a real fix.
>>
>>However using a cpu timer of another process to signal things in your
>>process is rare, and the case is breaks is only in certain obscure
>>variations of a multi-threaded exec.  Further no one has to my knowledge
>>complained in over a decade.
>>
>>If someone sees that fix as important, and something that needs to be
>>backported, it will be easiest to backport my earlier cleanup patches
>>in the same series.
>
>For 5.6, 5.5, and 5.4 it was enough to take:
>
>	60f2ceaa8111 ("posix-cpu-timers: Remove unnecessary locking around cpu_clock_sample_group")
>
>as a dependency. Based on the commit message there it should be safe so
>I did just that.

Ignore that, I've dropped it for now.

-- 
Thanks,
Sasha
