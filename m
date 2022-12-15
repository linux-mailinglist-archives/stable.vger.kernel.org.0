Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F0E64DC84
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 14:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLONy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiLONy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 08:54:28 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEE52ED45
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 05:54:25 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o5-20020a05600c510500b003d21f02fbaaso1733209wms.4
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 05:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9OTgqMJ72hTY8DmgwqYKfCFn5Uuqu5CGzMqc6diHDoY=;
        b=uRvXA3sWZXvyIXrliOdhwK6HbALAYO1yJfHGmadQChubshMyKVuUMe1LaRyVZT/p6g
         vD2RwRQVrzQUTjhNkNbDq3VU6SmxfYEJc5woUO4YwpxrZJ+gvCjzWoRQLihCNmre8M6u
         I+Pfo122gPGAO3HQHXnpaJuuuPb7fFOB7TihTG6uEWHvXMtMN4wOs9Mmkg1vdU5oR26O
         fdcp+P/UxjHHsyZbh2Qww9sA6XIRYc6RKkpgI+ggCB0Xb3E0L8CjT5GXOiE7ERlWxpik
         LQ47MaHFDob5Pzq3mfuoa4BXA0TIB8xpBOMytHBvQmZBizGh0iUo+FQOdRXV3nvnAK19
         JAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9OTgqMJ72hTY8DmgwqYKfCFn5Uuqu5CGzMqc6diHDoY=;
        b=aVLVO487qifzrhhkY4G1uq5lyWDI55lkmY+/ud9x/p/EeC8eo/SjE+BSAQj9XNoV6i
         yPi4bKWSh/OMEJ33UGJHsvGo/Iq2w0ePiZ0dM9kJ3sDVBenKPRqf11uqup3mvoPiU8iM
         xPE7w7J+wsDYeIoZ5YyPdIqVcXAW+6wnZWMDae8rA6XyjJVRrj0JNVS3OaVVj9JmRsYA
         kBpgVLOFy9vMnBxYIZrmEHjLi4pAPs2QtlPCVYmeV3FdbbPVOYxr7YdUQphcl2c0Evry
         GFmNwV/bdI5G8XbB64eaMLtA10hKbgmOJeGapgtSlTYUPiKOw9UQtoJ4V/ad5wBS7nvS
         RByQ==
X-Gm-Message-State: ANoB5pmBf1uQanct5r9QNug/KEATesK/02vYbJLeAt7SJAjIZqPS8L0U
        5qblJ2ymWENtqveH3Zirq7VSpQ==
X-Google-Smtp-Source: AA0mqf7JVIcTPYdeX+DwIlk55rlpMShtycDHmgZrVZxgWpoACaOHyPw1OWw+dIhhtCWJetqZGFJ0Vg==
X-Received: by 2002:a05:600c:3c92:b0:3cf:a851:d2f2 with SMTP id bg18-20020a05600c3c9200b003cfa851d2f2mr22167012wmb.21.1671112463881;
        Thu, 15 Dec 2022 05:54:23 -0800 (PST)
Received: from localhost ([82.66.159.240])
        by smtp.gmail.com with ESMTPSA id w23-20020a05600c099700b003d1de805de5sm5632729wmp.16.2022.12.15.05.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 05:54:23 -0800 (PST)
From:   Mattijs Korpershoek <mkorpershoek@baylibre.com>
To:     Jason Andryuk <jandryuk@gmail.com>, linux-kernel@vger.kernel.org
Cc:     xen-devel@lists.xenproject.org, Jason Andryuk <jandryuk@gmail.com>,
        Phillip Susi <phill@thesusis.net>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2] Input: xen-kbdfront - drop keys to shrink modalias
In-Reply-To: <20221209142615.33574-1-jandryuk@gmail.com>
References: <20221209142615.33574-1-jandryuk@gmail.com>
Date:   Thu, 15 Dec 2022 14:54:22 +0100
Message-ID: <87359gkc1d.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 09:26, Jason Andryuk <jandryuk@gmail.com> wrote:

> xen kbdfront registers itself as being able to deliver *any* key since
> it doesn't know what keys the backend may produce.
>
> Unfortunately, the generated modalias gets too large and uevent creation
> fails with -ENOMEM.
>
> This can lead to gdm not using the keyboard since there is no seat
> associated [1] and the debian installer crashing [2].
>
> Trim the ranges of key capabilities by removing some BTN_* ranges.
> While doing this, some neighboring undefined ranges are removed to trim
> it further.
>
> An upper limit of KEY_KBD_LCD_MENU5 is still too large.  Use an upper
> limit of KEY_BRIGHTNESS_MENU.
>
> This removes:
> BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
> Empty space 0x224..0x229
>
> Empty space 0x28a..0x28f
> KEY_MACRO1(0x290)..KEY_MACRO30(0x2ad)
> KEY_MACRO_RECORD_START          0x2b0
> KEY_MACRO_RECORD_STOP           0x2b1
> KEY_MACRO_PRESET_CYCLE          0x2b2
> KEY_MACRO_PRESET1(0x2b3)..KEY_MACRO_PRESET3(0xb5)
> Empty space 0x2b6..0x2b7
> KEY_KBD_LCD_MENU1(0x2b8)..KEY_KBD_LCD_MENU5(0x2bc)
> Empty space 0x2bd..0x2bf
> BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
> Empty space 0x2e8..0x2ff
>
> The modalias shrinks from 2082 to 1550 bytes.
>
> A chunk of keys need to be removed to allow the keyboard to be used.
> This may break some functionality, but the hope is these macro keys are
> uncommon and don't affect any users.
>
> [1] https://github.com/systemd/systemd/issues/22944
> [2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/T/
>
> Cc: Phillip Susi <phill@thesusis.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>

Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>

> ---
>  drivers/input/misc/xen-kbdfront.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> v2:
> Remove more keys: v1 didn't remove enough and modalias was still broken.
>
> diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
> index 8d8ebdc2039b..4ecb579df748 100644
> --- a/drivers/input/misc/xen-kbdfront.c
> +++ b/drivers/input/misc/xen-kbdfront.c
> @@ -256,7 +256,14 @@ static int xenkbd_probe(struct xenbus_device *dev,
>  		__set_bit(EV_KEY, kbd->evbit);
>  		for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
>  			__set_bit(i, kbd->keybit);
> -		for (i = KEY_OK; i < KEY_MAX; i++)
> +		/* In theory we want to go KEY_OK..KEY_MAX, but that grows the
> +		 * modalias line too long.  There is a gap of buttons from
> +		 * BTN_DPAD_UP..BTN_DPAD_RIGHT and KEY_ALS_TOGGLE is the next
> +		 * defined. Then continue up to KEY_BRIGHTNESS_MENU as an upper
> +		 * limit. */
> +		for (i = KEY_OK; i < BTN_DPAD_UP; i++)
> +			__set_bit(i, kbd->keybit);
> +		for (i = KEY_ALS_TOGGLE; i <= KEY_BRIGHTNESS_MENU; i++)
>  			__set_bit(i, kbd->keybit);
>  
>  		ret = input_register_device(kbd);
> -- 
> 2.38.1
