Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7040520CACA
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 23:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgF1VwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 17:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgF1VwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 17:52:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB709206C3;
        Sun, 28 Jun 2020 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593381145;
        bh=bnMnFIkJ5LxQ90e1w1fW2KZCQeNzVzDS0zucd1dK4NY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xhGIcDS5kXkXBsgWG47glLTGnR8iIHff+SDh1zIMPg7PTahms3xsg/M9oZ7OH9VOc
         MsUgoHv77gcJ+MC8vBKX6zcgZVkhl2G/nLRn1Dsi/ZTKLHYWFWAJRx0j7qxzOWH44K
         Roi2cr58WWjCsNHaUxp8EH/e8s6BRywFynLAZu1U=
Date:   Sun, 28 Jun 2020 17:52:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tiwai@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ALSA: usb-audio: Fix OOB access of mixer
 element list" failed to apply to 4.14-stable tree
Message-ID: <20200628215223.GM1931@sasha-vm>
References: <1593358260240211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1593358260240211@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 28, 2020 at 05:31:00PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 220345e98f1cdc768eeb6e3364a0fa7ab9647fe7 Mon Sep 17 00:00:00 2001
>From: Takashi Iwai <tiwai@suse.de>
>Date: Wed, 24 Jun 2020 14:23:40 +0200
>Subject: [PATCH] ALSA: usb-audio: Fix OOB access of mixer element list
>
>The USB-audio mixer code holds a linked list of usb_mixer_elem_list,
>and several operations are performed for each mixer element.  A few of
>them (snd_usb_mixer_notify_id() and snd_usb_mixer_interrupt_v2())
>assume each mixer element being a usb_mixer_elem_info object that is a
>subclass of usb_mixer_elem_list, cast via container_of() and access it
>members.  This may result in an out-of-bound access when a
>non-standard list element has been added, as spotted by syzkaller
>recently.
>
>This patch adds a new field, is_std_info, in usb_mixer_elem_list to
>indicate that the element is the usb_mixer_elem_info type or not, and
>skip the access to such an element if needed.
>
>Reported-by: syzbot+fb14314433463ad51625@syzkaller.appspotmail.com
>Reported-by: syzbot+2405ca3401e943c538b5@syzkaller.appspotmail.com
>Cc: <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/20200624122340.9615-1-tiwai@suse.de
>Signed-off-by: Takashi Iwai <tiwai@suse.de>

I took these two additional commits:

8c558076c740 ("ALSA: usb-audio: Clean up mixer element list traverse")
b2500b584cfd ("ALSA: usb-audio: uac1: Invalidate ctl on interrupt")

and queued all 3 for 4.14, 4.9, and 4.4

-- 
Thanks,
Sasha
