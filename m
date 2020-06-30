Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B802820F9E5
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 18:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388130AbgF3QyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 12:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731280AbgF3QyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 12:54:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A6E20759;
        Tue, 30 Jun 2020 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593536048;
        bh=HWGkKnuEEog9NEW5ea1FbMOv2iZauM/6Bx+/Cta2v4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CLBIrOfplkgMai2b10olTcOYuoQBTDblwZlTSp3IRBtJNpEnLtDKBqj03ntn5kl4b
         2eFAOJoNh0HFAv54d92aZZAGrbvED82u3wxREGCaWZLnSCzWB/285RTfLA3ntFw89U
         3TW2mYjWD9ZnP2bBH1wouD051xGpANkG3mfVldlY=
Date:   Tue, 30 Jun 2020 12:54:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Alexander Tsoy <alexander@tsoy.me>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.9 026/191] ALSA: usb-audio: Improve frames size
 computation
Message-ID: <20200630165407.GZ1931@sasha-vm>
References: <20200629154007.2495120-1-sashal@kernel.org>
 <20200629154007.2495120-27-sashal@kernel.org>
 <e033669a50b53e439f5071ad12d05c2d02ab6cfc.camel@tsoy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e033669a50b53e439f5071ad12d05c2d02ab6cfc.camel@tsoy.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 01:49:50PM +0300, Alexander Tsoy wrote:
>В Пн, 29/06/2020 в 11:37 -0400, Sasha Levin пишет:
>> From: Alexander Tsoy <alexander@tsoy.me>
>>
>> [ Upstream commit f0bd62b64016508938df9babe47f65c2c727d25c ]
>>
>> For computation of the the next frame size current value of fs/fps
>> and
>> accumulated fractional parts of fs/fps are used, where values are
>> stored
>> in Q16.16 format. This is quite natural for computing frame size for
>> asynchronous endpoints driven by explicit feedback, since in this
>> case
>> fs/fps is a value provided by the feedback endpoint and it's already
>> in
>> the Q format. If an error is accumulated over time, the device can
>> adjust fs/fps value to prevent buffer overruns/underruns.
>>
>> But for synchronous endpoints the accuracy provided by these
>> computations
>> is not enough. Due to accumulated error the driver periodically
>> produces
>> frames with incorrect size (+/- 1 audio sample).
>>
>> This patch fixes this issue by implementing a different algorithm for
>> frame size computation. It is based on accumulating of the remainders
>> from division fs/fps and it doesn't accumulate errors over time. This
>> new method is enabled for synchronous and adaptive playback
>> endpoints.
>>
>> Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
>> Link:
>> https://lore.kernel.org/r/20200424022449.14972-1-alexander@tsoy.me
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  sound/usb/card.h     |  4 ++++
>>  sound/usb/endpoint.c | 43 ++++++++++++++++++++++++++++++++++++++--
>> ---
>>  sound/usb/endpoint.h |  1 +
>>  sound/usb/pcm.c      |  2 ++
>>  4 files changed, 45 insertions(+), 5 deletions(-)
>
>Please drop this patch from the queue for now (and for 4.4 as well). It
>introduced a regression for some devices. The fix is available, but not
>accepted yet.

I've dropped it from the older branches, but note that it's already in
newer released stable kernels. Should it be reverted or should we wait
for the fix?

-- 
Thanks,
Sasha
