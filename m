Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D582690D
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbfEVRZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 13:25:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36182 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfEVRZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 13:25:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id j187so3050028wmj.1
        for <stable@vger.kernel.org>; Wed, 22 May 2019 10:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsBZvd8d8Lx/qEs/7XK8hcABtGMw5blgUQOjawmXbJo=;
        b=ocyQ0VicEUVqqSoaLxmhoVXTfshq7MWvQte+2y/dp6rrHX7AcI5MkjgE2fRGS4/Ods
         7sh793SO/LR6CEb+HjRcHNOSYMOGy7ifD+oaR67urhEwLpWATYzv8vt26PmwxDMUhIfB
         6UZX2bOIMDFE+RTrWOI6J7/iV4RaOJ4DypnS3owyKlX37RC7jXShuX2XuQUercOpHN4T
         N9QCJg4lDfgbYql9+09UKMFSGgUtdhd419nI0e6QcLrIBDq9Dwmw1qZ+rpcSPxQXv/85
         sQWTULHeKgN+XCzmFzlMqqHnIw7cfiEY87AzPEFe4QKz0i+c04NQ9GncL7vFN8ppz3ZT
         ILuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsBZvd8d8Lx/qEs/7XK8hcABtGMw5blgUQOjawmXbJo=;
        b=AwwHjbVwhrESUiGRL6Ku7zpMqdZwfRbVhLvzmLCnEAu6pPJlw0BK0XP/apRXxH151W
         6NL7J5aVz48m7fVWl3n/cpC64pDfzRZdb6UuZjsg5EqhSGXYBu+JLVS+FOvBH1UszV95
         EeMAixGYqukg4GD9UjLl8lHiMfTtj+EVd4UEj7vUSl9y8jhLDbnZVelMzAAdRh4KByiV
         HEF6JvbDfSjHGxuHX9E+vuArrfMEQjfroLmVcYI0S8DOHL4j+x9UaXO3KjWroavkowjO
         zGWvL8KrxG8eT2bGl81ot2j57IA3Lg2gqlhj66cqKrWiyfg8/mYZqmLhjTyk0N7klUvP
         kPEg==
X-Gm-Message-State: APjAAAWJuZUn9tzTD9ybzz5bFvw+46Q8vvKGOrY0+K5mDc0KAjLm2G1k
        C8FpdGal7z/gZKuaEOQxSNuOs5fMvB1SCby18MqR4A==
X-Google-Smtp-Source: APXvYqxn+CZc1Dwi1JczMkGBIzrpKWPu8tdlmcCtkIG2ETNrffYe6c78ZfDJuTq9aUs9yA5scmiuBhjQajWdmAGVyAQ=
X-Received: by 2002:a7b:c8d2:: with SMTP id f18mr8822531wml.29.1558545921053;
 Wed, 22 May 2019 10:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190522172312.182489-1-surenb@google.com>
In-Reply-To: <20190522172312.182489-1-surenb@google.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 22 May 2019 10:25:10 -0700
Message-ID: <CAJuCfpFtPYOjW80OADDWS6RLLfv=+f_1fOGhZK3Z2NdOXLRT4w@mail.gmail.com>
Subject: Re: [PATCH 1/1] ALSA: usb-audio: Fix UAF decrement if card has no
 live interfaces in card.c
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, missed CC'ing the maintainers. Will repost.

On Wed, May 22, 2019 at 10:23 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
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
>
>  sound/usb/card.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index f7dbdc10bf77..59fb1ef3cd55 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c
> @@ -593,9 +593,12 @@ snd_usb_audio_probe(struct usb_device *dev,
>
>   __error:
>         if (chip) {
> +               /* chip->probing is inside the chip->card object,
> +                * reset before memory is possibly returned.
> +                */
> +               chip->probing = 0;
>                 if (!chip->num_interfaces)
>                         snd_card_free(chip->card);
> -               chip->probing = 0;
>         }
>         mutex_unlock(&register_mutex);
>   __err_val:
> --
> 2.21.0.1020.gf2820cf01a-goog
>
