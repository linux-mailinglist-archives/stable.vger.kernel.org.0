Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C642852B
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfEWRnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731217AbfEWRnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 13:43:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB3062177E;
        Thu, 23 May 2019 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558633388;
        bh=e7KUMd6Qz9b5eaPnojS2yc1tJKWJ/Q91VqcSA/cXHbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFW+THozn8RPDBpmFqkirP1+YtrxfcU3nMWjgImo7ALDSTxvfs1qv9Ns4N+pmcRoh
         7B8D5cTb5JkSljOsN39N0PQRwzPPaUDbRmVnUxiBL6w8D/m9VgTRchTx2U+Z68bvjP
         FRv6ueL0a74+JkjGX/yk8rff3o2juOumjqcwRZbI=
Date:   Thu, 23 May 2019 19:43:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     perex@perex.cz, tiwai@suse.de, mathias.payer@nebelwelt.net,
        benquike@gmail.com, kdeus@google.com, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] ALSA: usb-audio: Fix UAF decrement if card has no
 live interfaces in card.c
Message-ID: <20190523174305.GA29438@kroah.com>
References: <20190522172655.183977-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522172655.183977-1-surenb@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 10:26:55AM -0700, Suren Baghdasaryan wrote:
> Commit 5f8cf712582617d523120df67d392059eaf2fc4b upstream.
> 
> This is a backport to stable 3.18.y. Implementation in 3.18 differs using
> chip->probing flag instead of chip->active atomic but it still has the UAF
> issue.
> 
> If a USB sound card reports 0 interfaces, an error condition is triggered
> and the function usb_audio_probe errors out. In the error path, there was a
> use-after-free vulnerability where the memory object of the card was first
> freed, followed by a decrement of the number of active chips. Moving the
> decrement above the atomic_dec fixes the UAF.
> 
> [ The original problem was introduced in 3.1 kernel, while it was
>   developed in a different form.  The Fixes tag below indicates the
>   original commit but it doesn't mean that the patch is applicable
>   cleanly. -- tiwai ]
> 
> Fixes: 362e4e49abe5 ("ALSA: usb-audio - clear chip->probing on error exit")
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Signed-off-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> [surenb@google.com: resolve 3.18 differences]
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
> Analysis for 3.18 codebase:
> snd_usb_audio_create() sets card->device_data = chip
> snd_usb_audio_probe() calls snd_card_free() and then resets chip->probing
> snd_card_free() results in the following call chain:
>  snd_card_free_when_closed() which waits on release_completion
>  snd_card_do_free() calls snd_device_free_all() and signals release_completion
>  snd_card_do_free() calls __snd_device_free()
>  __snd_device_free() calls dev->ops->dev_free() == snd_usb_audio_dev_free()
>  snd_usb_audio_dev_free() calls snd_usb_audio_free(chip) and frees "chip"
> chip->probing = 0 results in UAF

Thanks for the backport.  I've added it to my "internal" 3.18 queue.  As
there is not going to be any more public kernel.org 3.18.y releases,
I'll just be doing updates in the android-common tree over time every
few weeks.  This will end up in the next batch that gets merged into
there, thanks!

greg k-h
