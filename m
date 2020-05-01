Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911FE1C0B96
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 03:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEABR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 21:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgEABR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 21:17:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 376C72073E;
        Fri,  1 May 2020 01:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588295845;
        bh=Mz6sN8uk0484dPtngixCMMsVEMJZKClCMUn+e0ge4NU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x63oQ56cQA9Bl8D50Rpxxf8WvZrBvFUvuXGolJKStkcDajfnGA0hsDp6X5vr8LFVt
         3ogdumnhPxzwfsfy0gmKrSzIoo1dLds7f2tExur8fAAEz9TWhyC+boj7aJPmSBjMt6
         RDkFis3kbIzztbBb9F2PhXedX++P9qV62kAh56+o=
Date:   Thu, 30 Apr 2020 21:17:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Roy Spliet <nouveau@spliet.org>
Cc:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 12/38] ALSA: hda: Skip controller resume if
 not needed
Message-ID: <20200501011724.GF13035@sasha-vm>
References: <20200424122237.9831-1-sashal@kernel.org>
 <20200424122237.9831-12-sashal@kernel.org>
 <s5himhprr32.wl-tiwai@suse.de>
 <f5f301c7-a74d-7c2e-d182-3f003bfc061b@spliet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f5f301c7-a74d-7c2e-d182-3f003bfc061b@spliet.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 11:36:05PM +0100, Roy Spliet wrote:
>(Minus "Linux kernel", that list has enough volume)
>
>Op 24-04-2020 om 13:44 schreef Takashi Iwai:
>>On Fri, 24 Apr 2020 14:22:10 +0200,
>>Sasha Levin wrote:
>>>
>>>From: Takashi Iwai <tiwai@suse.de>
>>>
>>>[ Upstream commit c4c8dd6ef807663e42a5f04ea77cd62029eb99fa ]
>>>
>>>The HD-audio controller does system-suspend and resume operations by
>>>directly calling its helpers __azx_runtime_suspend() and
>>>__azx_runtime_resume().  However, in general, we don't have to resume
>>>always the device fully at the system resume; typically, if a device
>>>has been runtime-suspended, we can leave it to runtime resume.
>>>
>>>Usually for achieving this, the driver would call
>>>pm_runtime_force_suspend() and pm_runtime_force_resume() pairs in the
>>>system suspend and resume ops.  Unfortunately, this doesn't work for
>>>the resume path in our case.  For handling the jack detection at the
>>>system resume, a child codec device may need the (literally) forcibly
>>>resume even if it's been runtime-suspended, and for that, the
>>>controller device must be also resumed even if it's been suspended.
>>>
>>>This patch is an attempt to improve the situation.  It replaces the
>>>direct __azx_runtime_suspend()/_resume() calls with with
>>>pm_runtime_force_suspend() and pm_runtime_force_resume() with a slight
>>>trick as we've done for the codec side.  More exactly:
>>>
>>>- azx_has_pm_runtime() check is dropped from azx_runtime_suspend() and
>>>   azx_runtime_resume(), so that it can be properly executed from the
>>>   system-suspend/resume path
>>>
>>>- The WAKEEN handling depends on the card's power state now; it's set
>>>   and cleared only for the runtime-suspend
>>>
>>>- azx_resume() checks whether any codec may need the forcible resume
>>>   beforehand.  If the forcible resume is required, it does temporary
>>>   PM refcount up/down for actually triggering the runtime resume.
>>>
>>>- A new helper function, hda_codec_need_resume(), is introduced for
>>>   checking whether the codec needs a forcible runtime-resume, and the
>>>   existing code is rewritten with that.
>>>
>>>BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
>>>Link: https://lore.kernel.org/r/20200413082034.25166-6-tiwai@suse.de
>>>Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>>This commit is known to cause a regression, and the fix patch is
>>included in today's pull request.  If we apply this, better to wait
>>for the next batch including its fix.
>
>These six patches, plus Takashi's fix on top of them, do not seem to 
>have made it to 5.6.7 or 5.6.8 in the end. Is there a plan to include 

AUTOSEL stuff take a while to hit the stable trees, if you want patches
in quicker they should be tagged for stable...

>them in 5.6.9?

What are the commit ids?

-- 
Thanks,
Sasha
