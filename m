Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF1B1C0B66
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgEAA4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgEAA4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 20:56:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F128206C0;
        Fri,  1 May 2020 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588294598;
        bh=qzVIbLzLR1waAT8wlVFyTN88f+j4YehVbaac6sHmrqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2dpHcfa2x6CWh90gpUjnXE6dUI69GmXxQwjq0IWsjL0YhUq3U2tGgrcuVqXjB90MX
         H1jQG+xAN+jdyLJz6GqCfPvJGD2K22GTYUadDRhGRGWqMWbJIY5rsXKUPZl5prEJAC
         7x7XxBnFtK5xqJvRl2tnkSTkDzCCjNwGm6TQfHhA=
Date:   Thu, 30 Apr 2020 20:56:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roy Spliet <nouveau@spliet.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 4.9 03/13] ALSA: hda: Keep the controller
 initialization even if no codecs found
Message-ID: <20200501005637.GD13035@sasha-vm>
References: <20200424122447.10882-1-sashal@kernel.org>
 <20200424122447.10882-3-sashal@kernel.org>
 <s5hh7x9rr0c.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5hh7x9rr0c.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 02:45:55PM +0200, Takashi Iwai wrote:
>On Fri, 24 Apr 2020 14:24:36 +0200,
>Sasha Levin wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit 9479e75fca370a5220784f7596bf598c4dad0b9b ]
>>
>> Currently, when the HD-audio controller driver doesn't detect any
>> codecs, it tries to abort the probe.  But this abort happens at the
>> delayed probe, i.e. the primary probe call already returned success,
>> hence the driver is never unbound until user does so explicitly.
>> As a result, it may leave the HD-audio device in the running state
>> without the runtime PM.  More badly, if the device is a HD-audio bus
>> that is tied with a GPU, GPU cannot reach to the full power down and
>> consumes unnecessarily much power.
>>
>> This patch changes the logic after no-codec situation; it continues
>> probing without the further codec initialization but keep the
>> controller driver running normally.
>>
>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
>> Tested-by: Roy Spliet <nouveau@spliet.org>
>> Link: https://lore.kernel.org/r/20200413082034.25166-5-tiwai@suse.de
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Applying this without other commits isn't recommended, especially for
>the older branches.  Maybe OK up from 4.19, but I'd avoid applying for
>the older.

Okay, I've dropped it from branches older than 4.19. Thanks!

-- 
Thanks,
Sasha
