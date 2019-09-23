Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F0EBB540
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407048AbfIWNa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 09:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404581AbfIWNa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 09:30:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF5A20867;
        Mon, 23 Sep 2019 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569245427;
        bh=CA3jF6Gt7vTntOiNm7Ka9iK9XTY7AzxUYxpyJSRtT+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vs1xNEWZ/cH9GY0nruq1EHVFCmL/BQMrp8GEO7tRzWK4V9PTUO0pDnlnRPn0iPf+z
         unyrvy+QABye++Z/AdZ7j7DyFrSNT5kc31Aiw3nrmdnv82QGRlg1hCVSRvZFDiEOth
         /3IHlWp3MAKcOGTobl6cbgCyoqhjSf7HUCglg544=
Date:   Mon, 23 Sep 2019 09:30:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.2 072/185] ALSA: hda: Add codec on bus address
 table lately
Message-ID: <20190923133025.GE8171@sasha-vm>
References: <20190922184924.32534-1-sashal@kernel.org>
 <20190922184924.32534-72-sashal@kernel.org>
 <s5h8sqgm9qz.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5h8sqgm9qz.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 22, 2019 at 09:06:12PM +0200, Takashi Iwai wrote:
>On Sun, 22 Sep 2019 20:47:30 +0200,
>Sasha Levin wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit ee5f85d9290fe25d460bd320b7fe073075d72d33 ]
>>
>> The call of snd_hdac_bus_add_device() is needed only for registering
>> the codec onto the bus caddr_tbl[] that is referred essentially only
>> in the unsol event handler.  That is, the reason of this call and the
>> release by the counter-part function snd_hdac_bus_remove_device() is
>> just to assure that the unsol event gets notified to the codec.
>>
>> But the current implementation of the unsol notification wouldn't work
>> properly when the codec is still in a premature init state.  So this
>> patch tries to work around it by delaying the caddr_tbl[] registration
>> at the point of snd_hdac_device_register().
>>
>> Also, the order of snd_hdac_bus_remove_device() and device_del() calls
>> are shuffled to make sure that the unsol event is masked before
>> deleting the device.
>>
>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204565
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>The upstream commit was reverted later by 246bb4aaa4f4, which has even
>Fixes tag pointing this.  So please drop this.

I'll drop it, thank you.

>BTW, this is the second time AUTOSEL overlooked the existing revert.
>I'm afraid something is missing in the check.

Usually it's the case that I check for fixes/reverts once I compile the
series, and again right before I queue it up to a stable tree. In
between fixes and reverts tend to sneak in just like in this case.

In general, I also check the -rcs for fixes and reverts during their
review window, so while sometimes we send out mails with patches that
have a fix or revert upstream, they rarely make it into a released
stable kernel.

--
Thanks,
Sasha
